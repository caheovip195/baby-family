import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { z } from 'zod';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  ConflictError,
  DomainError,
  NotFoundError,
  ServiceUnavailableError,
  ValidationError,
} from '../common/errors/domain.error';
import {
  MEDIA_POLICY,
  maxAcceptedSize,
  mediaStorageKey,
} from '../config/media-policy';
import type { MediaKindPolicy } from '../config/media-policy';
import type { CompleteUploadDto } from '../dto/media/complete-upload.dto';
import type { CreateUploadIntentDto } from '../dto/media/create-upload-intent.dto';
import type { MediaUrlsDto } from '../dto/media/media-urls.dto';
import type {
  MediaAssetResponseDto,
  MediaUrlsResponseDto,
  UploadInstructionDto,
  UploadIntentResponseDto,
  UploadPartsResponseDto,
  UploadStatusResponseDto,
} from '../dto/media/media-response.dto';
import type { UploadPartsDto } from '../dto/media/upload-parts.dto';
import { CATALOG_QUERY_REPOSITORY } from '../interfaces/repositories/catalog-query-repository.interface';
import type { ICatalogQueryRepository } from '../interfaces/repositories/catalog-query-repository.interface';
import { MEDIA_REPOSITORY } from '../interfaces/repositories/media-repository.interface';
import type { IMediaRepository } from '../interfaces/repositories/media-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IMediaService } from '../interfaces/services/media-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type {
  IObjectStorageService,
  ObjectLocation,
} from '../interfaces/services/object-storage-service.interface';
import type { Asset } from '../models/asset.model';
import type { MediaAssetView, MediaUpload } from '../models/media-upload.model';

const quotaSchema = z.looseObject({
  storageBytes: z.number().int().nonnegative(),
  videoMaxSec: z.number().int().nonnegative().optional(),
  audioMaxSec: z.number().int().nonnegative().optional(),
});
type MediaQuotas = z.infer<typeof quotaSchema>;

@Injectable()
export class MediaService implements IMediaService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(CATALOG_QUERY_REPOSITORY)
    private readonly catalog: ICatalogQueryRepository,
    @Inject(MEDIA_REPOSITORY) private readonly media: IMediaRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
  ) {}

  async createUploadIntent(
    actor: AuthPrincipal,
    idempotencyKey: string,
    input: CreateUploadIntentDto,
  ): Promise<UploadIntentResponseDto> {
    // Membership, family lifecycle and an unexpired entitlement (402/403/404).
    await this.access.requireParent(actor, input.familyId, 'write');
    const kind = MEDIA_POLICY.kinds[input.kind] as MediaKindPolicy;
    const purpose = MEDIA_POLICY.purposes[input.purpose];
    const mime = input.mime.toLowerCase();
    if (!(purpose.kinds as readonly string[]).includes(input.kind))
      throw mediaError(
        'Kind is not allowed for this purpose.',
        'MEDIA_PURPOSE_INVALID',
      );
    if (!kind.mimes.includes(mime))
      throw mediaError('File type is not supported.', 'MEDIA_TYPE_UNSUPPORTED');
    if (input.size > kind.maxBytes)
      throw mediaError('File is too large.', 'MEDIA_TOO_LARGE');
    const quotas = await this.quotasOf(actor, input.familyId);
    if (kind.durationQuota) {
      const maxSeconds = quotas[kind.durationQuota];
      if (input.durationMs === undefined)
        throw new ValidationError('durationMs is required for this kind.');
      if (maxSeconds === undefined)
        throw new ServiceUnavailableError('Plan media limits are unavailable.');
      if (input.durationMs > maxSeconds * 1000)
        throw new DomainError(
          'Duration exceeds the current plan.',
          'MEDIA_DURATION_EXCEEDED',
          402,
        );
    }
    this.requireStorage();
    const sha256 = input.sha256.toLowerCase();
    const declaredSize = BigInt(input.size);
    const result = await this.media.reserveUpload({
      familyId: input.familyId,
      uploaderUserId: actor.userId,
      idempotencyKey,
      requestHash: createHash('sha256')
        .update(
          JSON.stringify([
            input.familyId,
            input.kind,
            input.purpose,
            mime,
            input.size,
            sha256,
          ]),
        )
        .digest(),
      kind: input.kind,
      purpose: input.purpose,
      mime,
      declaredSize,
      sha256: Buffer.from(sha256, 'hex'),
      width: input.width ?? null,
      height: input.height ?? null,
      durationMs: input.durationMs ?? null,
      storageBucket: this.storage.bucketName(purpose.bucket),
      storageKey: (assetId) => mediaStorageKey(input.familyId, assetId),
      reservedBytes: maxAcceptedSize(declaredSize),
      storageLimitBytes: BigInt(quotas.storageBytes),
      checksumVerifiedMaxBytes: BigInt(MEDIA_POLICY.multipartThresholdBytes),
      reservationExpiresAt: new Date(
        Date.now() + MEDIA_POLICY.reservationTtlMs,
      ),
    });
    if (result.outcome === 'duplicate')
      return {
        assetId: result.asset.id,
        status: result.asset.status,
        deduplicated: true,
      };
    const upload = result.upload;
    const response = {
      assetId: upload.asset.id,
      status: upload.asset.status,
      deduplicated: false,
    };
    // A replay of a finished, failed or expired upload only reports its state:
    // signing again would let the client overwrite stored or rejected content.
    if (!upload.isPending() || upload.isExpired(new Date())) return response;
    return { ...response, upload: await this.uploadInstruction(upload) };
  }

  async signUploadParts(
    actor: AuthPrincipal,
    assetId: string,
    input: UploadPartsDto,
  ): Promise<UploadPartsResponseDto> {
    const upload = await this.requireOwnPendingUpload(actor, assetId);
    if (!isMultipart(upload))
      throw mediaError('Upload is not multipart.', 'UPLOAD_NOT_MULTIPART', 409);
    const partCount = upload.partCount(MEDIA_POLICY.partSizeBytes);
    const partNumbers = input.partNumbers ?? range(partCount);
    if (partNumbers.some((n) => n > partCount))
      throw new ValidationError('Part number is out of range.');
    const uploadId = await this.ensureMultipartUpload(upload);
    const signed = await this.storage.createPartUploadUrls({
      ...this.locationOf(upload.asset),
      uploadId,
      partNumbers,
      expiresInSeconds: MEDIA_POLICY.partUrlTtlSeconds,
    });
    return {
      assetId,
      parts: signed.parts.map((part) => ({
        n: part.partNumber,
        url: part.url,
      })),
      expiresAt: signed.expiresAt,
    };
  }

  async completeUpload(
    actor: AuthPrincipal,
    assetId: string,
    input: CompleteUploadDto,
  ): Promise<UploadStatusResponseDto> {
    const upload = await this.findOwnUpload(actor, assetId);
    const asset = upload.asset;
    if (!upload.isPending()) {
      if (asset.status === 'FAILED')
        throw mediaError('Upload was rejected.', 'UPLOAD_REJECTED', 409);
      return { assetId, status: asset.status }; // already completed: idempotent
    }
    if (upload.isExpired(new Date()))
      throw mediaError('Upload window has expired.', 'UPLOAD_EXPIRED', 409);
    const location = this.locationOf(asset);
    if (isMultipart(upload)) {
      const partCount = upload.partCount(MEDIA_POLICY.partSizeBytes);
      const parts = [...(input.parts ?? [])].sort((a, b) => a.n - b.n);
      if (
        parts.length !== partCount ||
        parts.some((part, index) => part.n !== index + 1)
      )
        throw new ValidationError('All parts 1..N are required exactly once.');
      if (!asset.multipartUploadId)
        throw mediaError('Upload was not started.', 'UPLOAD_NOT_FOUND', 409);
      try {
        await this.storage.completeMultipartUpload({
          ...location,
          uploadId: asset.multipartUploadId,
          parts: parts.map((part) => ({ partNumber: part.n, etag: part.etag })),
        });
      } catch (error) {
        // The upload session is gone when a previous complete already assembled the
        // object but failed before the database commit: recover through HEAD below.
        if (!(error instanceof ConflictError)) throw error;
      }
    } else if (input.parts !== undefined) {
      throw new ValidationError('Single uploads do not take parts.');
    }

    // Presigned PUT does not bound the size: verify the stored object (spec §10.2).
    const stored = await this.storage.headObject(location);
    if (!stored)
      throw mediaError('Uploaded file was not found.', 'UPLOAD_NOT_FOUND', 409);
    const reason = upload.rejectionReason(
      stored,
      maxAcceptedSize(asset.declaredSize),
    );
    if (reason) {
      await this.storage.deleteObject(location);
      await this.media.failUpload(assetId, reason);
      throw new DomainError(
        'Uploaded file does not match the upload intent.',
        `UPLOAD_${reason}`,
        422,
      );
    }
    const confirmed = await this.media.confirmUpload(
      assetId,
      BigInt(stored.size),
    );
    return { assetId, status: confirmed.status };
  }

  async getAsset(
    actor: AuthPrincipal,
    assetId: string,
  ): Promise<MediaAssetResponseDto> {
    const familyId = (await this.media.findFamilyIds([assetId])).get(assetId);
    if (!familyId) throw new NotFoundError('Media not found.');
    await this.access.requireParent(actor, familyId, 'read');
    const [view] = await this.media.findViewableByParent(
      familyId,
      actor.userId,
      [assetId],
    );
    // Not distinguishing "hidden" from "missing" avoids revealing private memories.
    if (!view) throw new NotFoundError('Media not found.');
    return this.project(view);
  }

  async signViewUrls(
    actor: AuthPrincipal,
    input: MediaUrlsDto,
  ): Promise<MediaUrlsResponseDto> {
    const families = await this.media.findFamilyIds(input.assetIds);
    const byFamily = new Map<string, string[]>();
    for (const [assetId, familyId] of families)
      byFamily.set(familyId, [...(byFamily.get(familyId) ?? []), assetId]);
    const items: MediaAssetResponseDto[] = [];
    for (const [familyId, assetIds] of byFamily) {
      try {
        await this.access.requireParent(actor, familyId, 'read');
      } catch (error) {
        if (error instanceof DomainError && error.statusCode < 500) continue;
        throw error;
      }
      const views = await this.media.findViewableByParent(
        familyId,
        actor.userId,
        assetIds,
      );
      for (const view of views) items.push(await this.project(view));
    }
    const available = new Set(items.map((item) => item.assetId));
    return {
      items,
      unavailableIds: input.assetIds.filter((id) => !available.has(id)),
    };
  }

  private async quotasOf(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<MediaQuotas> {
    const state = await this.catalog.findFamilyBillingState(
      familyId,
      actor.userId,
      new Date(),
    );
    const parsed = quotaSchema.safeParse(state?.effectivePlan?.quotas);
    if (!parsed.success)
      throw new ServiceUnavailableError('Plan media limits are unavailable.');
    return parsed.data;
  }

  private async findOwnUpload(
    actor: AuthPrincipal,
    assetId: string,
  ): Promise<MediaUpload> {
    const upload = await this.media.findUpload(assetId);
    if (!upload) throw new NotFoundError('Media not found.');
    await this.access.requireParent(actor, upload.asset.familyId, 'write');
    if (upload.asset.uploaderUserId !== actor.userId)
      throw mediaError(
        'Only the uploader can do this.',
        'MEDIA_NOT_UPLOADER',
        403,
      );
    this.requireStorage();
    return upload;
  }

  private async requireOwnPendingUpload(
    actor: AuthPrincipal,
    assetId: string,
  ): Promise<MediaUpload> {
    const upload = await this.findOwnUpload(actor, assetId);
    if (!upload.isPending())
      throw mediaError(
        'Upload is no longer pending.',
        'UPLOAD_NOT_PENDING',
        409,
      );
    if (upload.isExpired(new Date()))
      throw mediaError('Upload window has expired.', 'UPLOAD_EXPIRED', 409);
    return upload;
  }

  private async uploadInstruction(
    upload: MediaUpload,
  ): Promise<UploadInstructionDto> {
    const asset = upload.asset;
    if (isMultipart(upload)) {
      const uploadId = await this.ensureMultipartUpload(upload);
      const partCount = upload.partCount(MEDIA_POLICY.partSizeBytes);
      const signed = await this.storage.createPartUploadUrls({
        ...this.locationOf(asset),
        uploadId,
        partNumbers: range(Math.min(partCount, 1000)),
        expiresInSeconds: MEDIA_POLICY.partUrlTtlSeconds,
      });
      return {
        mode: 'multipart',
        partSize: MEDIA_POLICY.partSizeBytes,
        partCount,
        parts: signed.parts.map((p) => ({ n: p.partNumber, url: p.url })),
        expiresAt: signed.expiresAt,
      };
    }
    const signed = await this.storage.createUploadUrl({
      ...this.locationOf(asset),
      contentType: asset.mime,
      sha256Base64: asset.sha256
        ? Buffer.from(asset.sha256).toString('base64')
        : undefined,
      expiresInSeconds: MEDIA_POLICY.uploadUrlTtlSeconds,
    });
    return {
      mode: 'single',
      method: 'PUT',
      url: signed.url,
      headers: signed.headers,
      expiresAt: signed.expiresAt,
    };
  }

  /** Starts the multipart upload once; a lost race aborts the extra upload. */
  private async ensureMultipartUpload(upload: MediaUpload): Promise<string> {
    const asset = upload.asset;
    if (asset.multipartUploadId) return asset.multipartUploadId;
    const location = this.locationOf(asset);
    const created = await this.storage.createMultipartUpload({
      ...location,
      contentType: asset.mime,
    });
    let effective: string;
    try {
      effective = await this.media.attachMultipartUpload(asset.id, created);
    } catch (error) {
      await this.storage.abortMultipartUpload(location, created);
      throw error;
    }
    if (effective !== created)
      await this.storage.abortMultipartUpload(location, created);
    return effective;
  }

  private async project(view: MediaAssetView): Promise<MediaAssetResponseDto> {
    const asset = view.asset;
    const urls: Record<string, string> = {};
    let urlsExpireAt: Date | null = null;
    if (view.isReady()) {
      // Only processed variants are served; originals may still carry metadata.
      for (const variant of view.variants) {
        const bucket = this.storage.bucketOf(variant.storageBucket);
        if (!bucket) continue;
        const signed = await this.storage.createDownloadUrl({
          bucket,
          key: variant.storageKey,
          expiresInSeconds: MEDIA_POLICY.viewUrlTtlSeconds,
        });
        urls[variant.variantCode] = signed.url;
        urlsExpireAt = signed.expiresAt;
      }
    }
    return {
      assetId: asset.id,
      kind: asset.kind,
      purpose: asset.purpose,
      status: asset.status,
      width: asset.width,
      height: asset.height,
      durationMs: asset.durationMs,
      blurhash: asset.blurhash,
      urls,
      urlsExpireAt,
    };
  }

  private locationOf(asset: Asset): ObjectLocation {
    const bucket = this.storage.bucketOf(asset.storageBucket);
    if (!bucket)
      throw new ServiceUnavailableError('Storage bucket is not configured.');
    return { bucket, key: asset.storageKey };
  }

  private requireStorage(): void {
    if (!this.storage.isConfigured())
      throw new ServiceUnavailableError('Object storage is not configured.');
  }
}

function isMultipart(upload: MediaUpload): boolean {
  return (
    upload.asset.declaredSize > BigInt(MEDIA_POLICY.multipartThresholdBytes)
  );
}

function range(count: number): number[] {
  return Array.from({ length: count }, (_, index) => index + 1);
}

function mediaError(message: string, code: string, status = 422): DomainError {
  return new DomainError(message, code, status);
}
