import { ServiceUnavailableError } from '../common/errors/domain.error';
import { Inject, Injectable } from '@nestjs/common';
import { MEDIA_MAINTENANCE } from '../config/jobs';
import {
  PROFILE_IMAGE_CLEANUP_REPOSITORY,
  type IProfileImageCleanupRepository,
} from '../interfaces/repositories/profile-image-cleanup-repository.interface';
import {
  OBJECT_STORAGE_SERVICE,
  type IObjectStorageService,
} from '../interfaces/services/object-storage-service.interface';
import type { IProfileImageCleanupService } from '../interfaces/services/profile-image-cleanup-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';

/** Runs inside the existing durable media.purge-orphans job. */
@Injectable()
export class ProfileImageCleanupService implements IProfileImageCleanupService {
  constructor(
    @Inject(PROFILE_IMAGE_CLEANUP_REPOSITORY)
    private readonly repository: IProfileImageCleanupRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
  ) {}
  async purge(now: Date, context?: JobContext, ownerUserIds?: string[]) {
    const stats = { avatarRawPurged: 0, avatarAssetsPurged: 0 };
    // Signed PUTs are capped at the original deadline; include clock-skew grace.
    const cutoff = new Date(now.getTime() - 60_000);
    const staleBefore = new Date(now.getTime() - 6 * 60 * 60 * 1000);
    for (const candidate of await this.repository.findDue(
      cutoff,
      staleBefore,
      MEDIA_MAINTENANCE.batchSize,
      ownerUserIds,
    )) {
      context?.signal.throwIfAborted();
      const asset = await this.repository.prepare(
        candidate.id,
        cutoff,
        staleBefore,
        context?.lease,
      );
      if (!asset) continue;
      const bucket = this.storage.bucketOf(asset.storageBucket);
      if (!bucket)
        throw new ServiceUnavailableError(
          'Avatar storage bucket is not configured.',
        );
      await this.storage.eraseObjectVersions({ bucket, key: asset.storageKey });
      if (asset.status === 'DELETED') {
        await this.storage.eraseObjectVersions({
          bucket,
          key: `${asset.storageKey}/avatar.webp`,
        });
        stats.avatarAssetsPurged++;
      }
      context?.signal.throwIfAborted();
      await this.repository.clearDeadline(asset, context?.lease);
      stats.avatarRawPurged++;
    }
    return stats;
  }
}
