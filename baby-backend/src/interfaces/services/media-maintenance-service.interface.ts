export const MEDIA_MAINTENANCE_SERVICE = Symbol('MEDIA_MAINTENANCE_SERVICE');

/** Recurring media housekeeping (spec §10.2). Each item is idempotent. */
export interface IMediaMaintenanceService {
  /**
   * Removes expired PENDING_UPLOAD uploads, FAILED assets past retention and, when
   * enabled, never-attached uploads; refunds their quota. Stalled PROCESSING → FAILED.
   */
  purgeOrphans(now: Date): Promise<Record<string, number>>;
  /** Confirms single uploads whose object exists although complete was never called. */
  reconcileUploads(now: Date): Promise<Record<string, number>>;
}
