export const MEMORY_MAINTENANCE_SERVICE = Symbol('MEMORY_MAINTENANCE_SERVICE');

/** Recurring memory housekeeping (spec §7.8.3, §10.7). Idempotent. */
export interface IMemoryMaintenanceService {
  /**
   * Purges trashed memories whose 30 days have passed (TRASHED → PURGED). Their
   * assets, once no memory uses them, are retired by `media.purge-orphans`.
   */
  purgeExpiredTrash(
    now: Date,
    familyId?: string,
  ): Promise<Record<string, number>>;
}
