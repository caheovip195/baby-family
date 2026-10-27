import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { ChangesQueryDto } from '../../dto/offline-sync/changes-query.dto';
import type {
  OfflineChangeData,
  OfflineEntity,
} from '../../models/offline-change.model';
export const OFFLINE_SYNC_SERVICE = Symbol('OFFLINE_SYNC_SERVICE');
export interface ChangesResponse {
  items: {
    entity: OfflineEntity;
    id: string;
    memoryId?: string;
    op: 'upsert' | 'delete';
    version?: number;
    updatedAt: string;
    data?: OfflineChangeData;
  }[];
  nextCursor: string;
  hasMore: boolean;
}
export interface IOfflineSyncService {
  changes(
    actor: AuthPrincipal,
    familyId: string,
    query: ChangesQueryDto,
  ): Promise<ChangesResponse>;
}
