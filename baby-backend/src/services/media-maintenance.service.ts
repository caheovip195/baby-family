import { verifyClientUpload } from './client-media-upload';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import path from 'node:path';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ConflictError, DomainError } from '../common/errors/domain.error';
import type { Environment } from '../config/environment';
import { JOBS, MEDIA_MAINTENANCE } from '../config/jobs';
import { MEDIA_POLICY, maxAcceptedSize } from '../config/media-policy';
import { MEDIA_REPOSITORY } from '../interfaces/repositories/media-repository.interface';
import type {
  IMediaRepository,
  PurgeRule,
} from '../interfaces/repositories/media-repository.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import type { IMediaMaintenanceService } from '../interfaces/services/media-maintenance-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../interfaces/services/object-storage-service.interface';
import type { Asset } from '../models/asset.model';
import {
  PROFILE_IMAGE_CLEANUP_SERVICE,
  type IProfileImageCleanupService,
} from '../interfaces/services/profile-image-cleanup-service.interface';

/** Longer than any single processing run; the worker gave up after this. */
const STALLED_PROCESSING_MS = 6 * 60 * 60 * 1000;
/** Idle UPLOADED/PROCESSING assets without a live run are re-enqueued after this. */
const REQUEUE_AFTER_MS = 15 * 60 * 1000;

@Injectable()
export class MediaMaintenanceService implements IMediaMaintenanceService {
  private readonly logger = new Logger(MediaMaintenanceService.name);
  private readonly unattachedAfterMs: number | null;

  constructor(
    @Inject(MEDIA_REPOSITORY) private readonly media: IMediaRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
    private readonly config: ConfigService<Environment, true>,
    @Inject(PROFILE_IMAGE_CLEANUP_SERVICE)
    private readonly profileImages: IProfileImageCleanupService,
  ) {
    const hours = config.get('MEDIA_PURGE_UNATTACHED_AFTER_HOURS', {
      infer: true,
    });
    this.unattachedAfterMs = hours ? hours * 60 * 60 * 1000 : null;
  }

  async purgeOrphans(
    now: Date,
    context?: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>> {
    const stats = {
      stalled: await this.media.failStaleProcessing(
        new Date(now.getTime() - STALLED_PROCESSING_MS),
        familyId,
      ),
      expired: await this.retire('EXPIRED_UPLOAD', now, familyId),
      failed: await this.retire(
        'FAILED',
        new Date(now.getTime() - MEDIA_MAINTENANCE.failedRetentionMs),
        familyId,
      ),
      // Memories purged from the trash leave their assets without any link.
      detached: await this.retire('DETACHED', now, familyId),
      unattached:
        this.unattachedAfterMs === null
          ? 0
          : await this.retire(
              'UNATTACHED',
              new Date(now.getTime() - this.unattachedAfterMs),
              familyId,
            ),
      objectsPurged: 0,
    };
    // Database first, storage second: a retired asset keeps `purge_after` until its
    // objects are gone, so a crash or storage outage is retried by the next run.
    for (const asset of await this.media.findAssetsAwaitingObjectPurge(
      MEDIA_MAINTENANCE.batchSize,
      familyId,
    )) {
      if (await this.purgeObjects(asset)) stats.objectsPurged++;
    }
    return {
      ...stats,
      ...(familyId ? {} : await this.profileImages.purge(now, context)),
    };
  }

  async reconcileUploads(
    now: Date,
    familyId?: string,
  ): Promise<Record<string, number>> {
    const stats = { confirmed: 0, rejected: 0, waiting: 0, requeued: 0 };
    for (const upload of await this.media.findUncompletedUploads(
      new Date(now.getTime() - MEDIA_MAINTENANCE.reconcileAfterMs),
      BigInt(MEDIA_POLICY.multipartThresholdBytes),
      MEDIA_MAINTENANCE.batchSize,
      familyId,
    )) {
      const bucket = this.storage.bucketOf(upload.asset.storageBucket);
      if (!bucket) continue;
      const location = { bucket, key: upload.asset.storageKey };
      if (upload.variants.length) {
        try {
          const sizes = await verifyClientUpload(
            this.storage,
            upload,
            location,
          );
          const primary = upload.variants.find(
            (v) => v.storageKey === upload.asset.storageKey,
          )!;
          await this.media.confirmUpload(
            upload.asset.id,
            sizes.get(primary.variantCode)!,
            sizes,
          );
          stats.confirmed++;
        } catch (error) {
          // A missing object can still be in flight; completion/expiry owns rejection.
          if (error instanceof DomainError && error.statusCode === 422) {
            stats.waiting++;
            continue;
          }
          if (!(error instanceof ConflictError)) throw error;
        }
        continue;
      }
      if (
        this.config.get('MEDIA_SERVER_PROCESSING', { infer: true }) !== 'legacy'
      ) {
        stats.waiting++;
        continue;
      }
      const stored = await this.storage.headObject(location);
      if (!stored) {
        stats.waiting++;
        continue;
      }
      const reason = upload.rejectionReason(
        stored,
        maxAcceptedSize(upload.asset.declaredSize),
      );
      try {
        if (reason) {
          await this.media.failUpload(upload.asset.id, reason);
          await this.storage.deleteObject(location);
          stats.rejected++;
        } else {
          // Same transaction as POST /media/:id/complete, including the outbox event.
          await this.media.confirmUpload(upload.asset.id, BigInt(stored.size));
          stats.confirmed++;
        }
      } catch (error) {
        // Expired or completed concurrently: purge-orphans or the client owns it now.
        if (!(error instanceof ConflictError)) throw error;
      }
    }
    // Queue jobs can be lost (attempts used up during an outage, Valkey data loss):
    // PostgreSQL is the source of truth, so idle assets are enqueued again.
    if (
      this.config.get('MEDIA_SERVER_PROCESSING', { infer: true }) !== 'legacy'
    )
      return stats;
    const period = Math.floor(now.getTime() / REQUEUE_AFTER_MS);
    for (const asset of await this.media.findStuckProcessing(
      new Date(now.getTime() - REQUEUE_AFTER_MS),
      `${JOBS.processAsset.name}:`,
      MEDIA_MAINTENANCE.batchSize,
      familyId,
    )) {
      await this.queue.enqueue(
        JOBS.processAsset,
        `requeue-${asset.id}-${period}`,
        {
          assetId: asset.id,
        },
      );
      stats.requeued++;
    }
    return stats;
  }

  private async retire(
    rule: PurgeRule,
    cutoff: Date,
    familyId?: string,
  ): Promise<number> {
    let retired = 0;
    for (const id of await this.media.findPurgeCandidates(
      rule,
      cutoff,
      MEDIA_MAINTENANCE.batchSize,
      familyId,
    ))
      if (await this.media.retireAsset(id, rule, cutoff)) retired++;
    return retired;
  }

  private async purgeObjects(asset: Asset): Promise<boolean> {
    const bucket = this.storage.bucketOf(asset.storageBucket);
    if (!bucket) {
      this.logger.warn(`Asset ${asset.id} uses an unconfigured bucket.`);
      return false;
    }
    if (asset.multipartUploadId)
      await this.storage.abortMultipartUpload(
        { bucket, key: asset.storageKey },
        asset.multipartUploadId,
      );
    // Every object of the asset lives under its own prefix (original + renditions).
    const prefix = `${path.posix.dirname(asset.storageKey)}/`;
    for (const key of await this.storage.listKeys(bucket, prefix))
      await this.storage.deleteObject({ bucket, key });
    await this.media.markObjectsPurged(asset.id);
    return true;
  }
}
