import type { AuthSessionState } from '../../models/auth-session-state.model';
import type { FamilyAccessState } from '../../models/family-access-state.model';

export const AUTH_ACCESS_REPOSITORY = Symbol('AUTH_ACCESS_REPOSITORY');

export interface IAuthAccessRepository {
  findUserSessionState(
    sessionId: string,
    userId: string,
    now: Date,
  ): Promise<AuthSessionState | null>;
  findFamilyAccessState(
    familyId: string,
    userId: string,
    now: Date,
  ): Promise<FamilyAccessState | null>;
}
