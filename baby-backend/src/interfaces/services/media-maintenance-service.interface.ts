import type { JobContext } from './job-runner-service.interface';
export const MEDIA_MAINTENANCE_SERVICE = Symbol('MEDIA_MAINTENANCE_SERVICE');

/** Recurring media housekeeping (spec §10.2). Each item is idempotent. */
export interface IMediaMaintenanceService {
  /**
   * Removes expired PENDING_UPLOAD uploads, FAILED assets past retention, assets
   * left without memories by trash purge and, when
   * enabled, never-attached uploads; refunds their quota. Stalled PROCESSING → FAILED.
   */
  purgeOrphans(
    now: Date,
    context?: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>>;
  /** Confirms single uploads whose object exists although complete was never called. */
  reconcileUploads(
    now: Date,
    familyId?: string,
  ): Promise<Record<string, number>>;
}
