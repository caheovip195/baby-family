import type { JobContext } from './job-runner-service.interface';
export const PROFILE_IMAGE_CLEANUP_SERVICE = Symbol(
  'PROFILE_IMAGE_CLEANUP_SERVICE',
);
export interface IProfileImageCleanupService {
  /** Owner scope is used by isolated maintenance/integration runs. */
  purge(
    now: Date,
    context?: JobContext,
    ownerUserIds?: string[],
  ): Promise<Record<string, number>>;
}
