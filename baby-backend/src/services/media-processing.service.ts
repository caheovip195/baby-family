import { createHash } from 'node:crypto';
import { createReadStream } from 'node:fs';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { Inject, Injectable } from '@nestjs/common';
import { z } from 'zod';
import {
  ConflictError,
  ServiceUnavailableError,
} from '../common/errors/domain.error';
import { PermanentJobError } from '../common/errors/job.error';
import { MEDIA_REPOSITORY } from '../interfaces/repositories/media-repository.interface';
import type {
  IMediaRepository,
  ProcessedVariantInput,
  ProcessingResult,
} from '../interfaces/repositories/media-repository.interface';
import { IMAGE_PROCESSOR_SERVICE } from '../interfaces/services/image-processor-service.interface';
import type {
  IImageProcessorService,
  ProcessedFile,
} from '../interfaces/services/image-processor-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import type { IMediaProcessingService } from '../interfaces/services/media-processing-service.interface';
import { MEDIA_TRANSCODER_SERVICE } from '../interfaces/services/media-transcoder-service.interface';
import type { IMediaTranscoderService } from '../interfaces/services/media-transcoder-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type {
  IObjectStorageService,
  ObjectLocation,
  ObjectStorageBucket,
} from '../interfaces/services/object-storage-service.interface';
import type { Asset } from '../models/asset.model';
import type { MediaAssetView } from '../models/media-upload.model';

const planSchema = z.object({
  quotas: z.looseObject({
    videoMaxSec: z.number().int().nonnegative().optional(),
    audioMaxSec: z.number().int().nonnegative().optional(),
  }),
  features: z.record(z.string(), z.unknown()),
});
/** Container metadata rounding; the client already enforces the plan limit. */
const DURATION_TOLERANCE_MS = 1000;
const EXTENSION_BY_MIME: Record<string, string> = {
  'video/mp4': 'mp4',
  'video/quicktime': 'mov',
  'audio/mp4': 'm4a',
  'audio/x-m4a': 'm4a',
  'audio/aac': 'aac',
  'audio/mpeg': 'mp3',
};

interface PlanLimits {
  keepOriginal: boolean;
  videoMaxSec?: number;
  audioMaxSec?: number;
}

type Rendered = Omit<ProcessingResult, 'variants'> & { files: ProcessedFile[] };

@Injectable()
export class MediaProcessingService implements IMediaProcessingService {
  constructor(
    @Inject(MEDIA_REPOSITORY) private readonly media: IMediaRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    @Inject(IMAGE_PROCESSOR_SERVICE)
    private readonly images: IImageProcessorService,
    @Inject(MEDIA_TRANSCODER_SERVICE)
    private readonly transcoder: IMediaTranscoderService,
  ) {}

  async processAsset(
    assetId: string,
    context: JobContext,
  ): Promise<Record<string, number>> {
    const asset = await this.media.startProcessing(assetId);
    if (!asset) {
      // Committed before a crash: finish the post-commit cleanup only.
      const view = await this.media.findAssetView(assetId);
      if (view?.isReady()) {
        await this.cleanup(view);
        return { cleaned: 1 };
      }
      return { skipped: 1 };
    }
    const workDir = await mkdtemp(path.join(tmpdir(), 'bf-media-'));
    try {
      const rendered = await this.render(asset, workDir, context.signal);
      context.signal.throwIfAborted();
      // Attempt-specific keys: a stalled previous owner cannot overwrite them.
      const variants = await this.uploadRenditions(
        asset,
        rendered.files,
        `r${context.lease.fencingToken}`,
      );
      const commit = await this.media.completeProcessing(
        assetId,
        { ...rendered, variants },
        context.lease,
      );
      if (commit === 'LEASE_LOST')
        throw new Error('Job lease was lost before completion.');
      if (commit === 'NOT_PROCESSING') return { skipped: 1 };
      const view = await this.media.findAssetView(assetId);
      if (view) await this.cleanup(view);
      return { processed: 1 };
    } catch (error) {
      if (error instanceof PermanentJobError)
        await this.media.failProcessing(assetId, error.code, context.lease);
      throw error;
    } finally {
      await rm(workDir, { recursive: true, force: true });
    }
  }

  private async render(
    asset: Asset,
    workDir: string,
    signal: AbortSignal,
  ): Promise<Rendered> {
    const limits = await this.limitsOf(asset);
    const input = path.join(workDir, 'input');
    try {
      await this.storage.downloadToFile(this.locationOf(asset), input);
    } catch (error) {
      if (error instanceof ConflictError)
        throw new PermanentJobError(
          'ORIGINAL_MISSING',
          'Uploaded file is missing.',
        );
      throw error;
    }
    // Multipart uploads are not checksum-signed: verify the declared hash here.
    const digest = await sha256File(input);
    if (!asset.sha256 || !Buffer.from(asset.sha256).equals(digest))
      throw new PermanentJobError(
        'CHECKSUM_MISMATCH',
        'Uploaded file does not match its SHA-256.',
      );
    signal.throwIfAborted();
    if (asset.kind === 'IMAGE') {
      const image = await this.images.process(input, {
        keepOriginal: limits.keepOriginal,
        workDir,
      });
      return {
        width: image.width,
        height: image.height,
        durationMs: null,
        capturedAt: image.capturedAt,
        blurhash: image.blurhash,
        keepOriginal: limits.keepOriginal,
        files: image.variants,
      };
    }
    return this.renderTimed(asset, input, workDir, limits, signal);
  }

  private async renderTimed(
    asset: Asset,
    input: string,
    workDir: string,
    limits: PlanLimits,
    signal: AbortSignal,
  ): Promise<Rendered> {
    const probe = await this.transcoder.probe(input, signal);
    const video = asset.kind === 'VIDEO';
    if (video ? !probe.hasVideo : !probe.hasAudio)
      throw new PermanentJobError(
        'MEDIA_UNREADABLE',
        'Expected stream is missing.',
      );
    const maxSec = video ? limits.videoMaxSec : limits.audioMaxSec;
    if (
      maxSec === undefined ||
      probe.durationMs > maxSec * 1000 + DURATION_TOLERANCE_MS
    )
      throw new PermanentJobError(
        'DURATION_EXCEEDED',
        'Duration exceeds the current plan.',
      );
    const files: ProcessedFile[] = [];
    let width = probe.width;
    let height = probe.height;
    if (video) {
      const v1080 = await this.transcoder.transcodeVideo(
        input,
        workDir,
        signal,
      );
      const output = await this.transcoder.probe(v1080.path, signal);
      ({ width, height } = output);
      const poster = await this.transcoder.extractPoster(
        v1080.path,
        output.durationMs,
        workDir,
        signal,
      );
      files.push(
        { ...v1080, width, height, durationMs: output.durationMs },
        { ...poster, width, height },
        await this.images.thumbnail(poster.path, workDir),
      );
    } else {
      const audio = await this.transcoder.transcodeAudio(
        input,
        workDir,
        signal,
      );
      files.push({ ...audio, durationMs: probe.durationMs });
    }
    // FAMILY keeps the original, remuxed losslessly without metadata (GPS atoms);
    // other plans keep only the processed renditions.
    if (limits.keepOriginal) {
      const clean = await this.transcoder.stripMetadata(
        input,
        EXTENSION_BY_MIME[asset.mime] ?? 'bin',
        workDir,
        signal,
      );
      files.push({
        ...clean,
        mime: asset.mime,
        width: probe.width,
        height: probe.height,
      });
    }
    return {
      width,
      height,
      durationMs: probe.durationMs,
      capturedAt: null,
      blurhash: null,
      keepOriginal: limits.keepOriginal,
      files,
    };
  }

  private async uploadRenditions(
    asset: Asset,
    files: ProcessedFile[],
    attempt: string,
  ): Promise<ProcessedVariantInput[]> {
    const bucket = this.locationOf(asset).bucket;
    const prefix = `${path.posix.dirname(asset.storageKey)}/${attempt}`;
    const variants: ProcessedVariantInput[] = [];
    for (const file of files) {
      const key = `${prefix}/${path.basename(file.path)}`;
      await this.storage.uploadFile({ bucket, key }, file.path, file.mime);
      variants.push({
        code: file.code,
        storageBucket: asset.storageBucket,
        storageKey: key,
        mime: file.mime,
        sizeBytes: BigInt(file.sizeBytes),
        width: file.width,
        height: file.height,
        durationMs: file.durationMs,
      });
    }
    return variants;
  }

  /**
   * After READY: erase every version of the raw upload (it may carry GPS) and
   * delete renditions left by earlier or stalled attempts.
   */
  private async cleanup(view: MediaAssetView): Promise<void> {
    const location = this.locationOf(view.asset);
    await this.storage.eraseObjectVersions(location);
    const keep = new Set(view.variants.map((variant) => variant.storageKey));
    const prefix = `${path.posix.dirname(view.asset.storageKey)}/`;
    for (const key of await this.storage.listKeys(location.bucket, prefix))
      if (!keep.has(key) && key !== location.key)
        await this.storage.deleteObject({ bucket: location.bucket, key });
  }

  private async limitsOf(asset: Asset): Promise<PlanLimits> {
    const parsed = planSchema.safeParse(
      await this.media.findEffectivePlan(asset.familyId),
    );
    // No usable plan: keep the safest behaviour (no raw original, no long media).
    if (!parsed.success) return { keepOriginal: false };
    return {
      keepOriginal: parsed.data.features['media.keepOriginal'] === true,
      videoMaxSec: parsed.data.quotas.videoMaxSec,
      audioMaxSec: parsed.data.quotas.audioMaxSec,
    };
  }

  private locationOf(asset: Asset): ObjectLocation & {
    bucket: ObjectStorageBucket;
  } {
    const bucket = this.storage.bucketOf(asset.storageBucket);
    // Operator configuration error: retryable, never a reason to fail user media.
    if (!bucket)
      throw new ServiceUnavailableError('Storage bucket is not configured.');
    return { bucket, key: asset.storageKey };
  }
}

async function sha256File(filePath: string): Promise<Buffer> {
  const hash = createHash('sha256');
  for await (const chunk of createReadStream(filePath))
    hash.update(chunk as Buffer);
  return hash.digest();
}
