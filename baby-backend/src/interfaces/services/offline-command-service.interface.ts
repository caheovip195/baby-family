import type { AuthPrincipal } from '../../common/auth/auth-principal';
export const OFFLINE_COMMAND_SERVICE = Symbol('OFFLINE_COMMAND_SERVICE');
export interface OfflineCommand {
  actor?: AuthPrincipal;
  operation: string;
  familyId?: string;
  memoryId?: string;
  parentOnly?: boolean;
  resourceId?: string;
  body?: unknown;
}
export interface IOfflineCommandService {
  execute<T>(
    command: OfflineCommand,
    key: string,
    work: () => Promise<T>,
    authorize?: () => Promise<unknown>,
  ): Promise<T>;
}
