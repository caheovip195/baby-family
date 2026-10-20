import type { UserAsset } from '../../models/user-asset.model';
import type { JobLease } from '../../models/job-lease.model';
export const PROFILE_IMAGE_CLEANUP_REPOSITORY = Symbol(
  'PROFILE_IMAGE_CLEANUP_REPOSITORY',
);
export interface IProfileImageCleanupRepository {
  findDue(
    cutoff: Date,
    staleBefore: Date,
    limit: number,
    ownerUserIds?: string[],
  ): Promise<UserAsset[]>;
  /** Locks against attach; marks unreferenced/deleted-owner assets before storage I/O. */
  prepare(
    id: string,
    cutoff: Date,
    staleBefore: Date,
    lease?: JobLease,
  ): Promise<UserAsset | null>;
  clearDeadline(asset: UserAsset, lease?: JobLease): Promise<void>;
}
