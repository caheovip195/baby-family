import type { OfflineChange } from '../../models/offline-change.model';
export const OFFLINE_SYNC_REPOSITORY = Symbol('OFFLINE_SYNC_REPOSITORY');
export interface ChangesPosition {
  at: Date;
  id: string;
}
export interface IOfflineSyncRepository {
  pull(
    familyId: string,
    userId: string,
    since: Date,
    after: ChangesPosition | null,
    limit: number,
  ): Promise<OfflineChange[]>;
}
