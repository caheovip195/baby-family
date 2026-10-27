import type { OfflineCommandRecord } from '../../models/offline-command-record.model';
export const OFFLINE_COMMAND_REPOSITORY = Symbol('OFFLINE_COMMAND_REPOSITORY');
export interface OfflineCommandClaim {
  actorUserId?: string;
  familyId?: string;
  operation: string;
  scopeKey: string;
  key: string;
  requestHash: Uint8Array;
}
export interface IOfflineCommandRepository {
  claim(
    input: OfflineCommandClaim,
  ): Promise<{ acquired: boolean; record: OfflineCommandRecord }>;
  complete(id: string, response: string): Promise<void>;
  reject(id: string): Promise<void>;
}
