import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { UserSession } from '../../models/user-session.model';
import type { UserDevice } from '../../models/user-device.model';
export const ACCOUNT_SECURITY_REPOSITORY = Symbol(
  'ACCOUNT_SECURITY_REPOSITORY',
);
export interface SecuritySession {
  session: UserSession;
  device: UserDevice | null;
}
export interface IAccountSecurityRepository {
  listSessions(userId: string, now: Date): Promise<SecuritySession[]>;
  findSession(
    userId: string,
    sessionId: string,
    now: Date,
  ): Promise<UserSession | null>;
  isPhoneUsedByAnother(userId: string, phone: string): Promise<boolean>;
  revokeOthers(actor: AuthPrincipal, now: Date): Promise<number>;
  changePhone(actor: AuthPrincipal, phone: string, now: Date): Promise<void>;
}
