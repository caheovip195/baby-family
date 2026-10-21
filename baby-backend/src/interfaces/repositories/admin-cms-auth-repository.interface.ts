import type {
  AdminCmsAuthSession,
  AdminCmsAuthUser,
} from '../../models/admin-cms-auth.model';
export const ADMIN_CMS_AUTH_REPOSITORY = Symbol('ADMIN_CMS_AUTH_REPOSITORY');
export interface IAdminCmsAuthRepository {
  reserveAttempt(identityKey: string, clientKey: string): Promise<boolean>;
  findUser(email: string): Promise<AdminCmsAuthUser | null>;
  recordDenied(adminId: string): Promise<void>;
  recordFailure(adminId: string | null): Promise<void>;
  createSession(input: {
    id: string;
    adminId: string;
    tokenHash: Uint8Array;
    expiresAt: Date;
    mfaStep?: Date;
  }): Promise<void>;
  findSession(
    id: string,
    tokenHash: Uint8Array,
  ): Promise<AdminCmsAuthSession | null>;
  revokeSession(adminId: string, sessionId: string): Promise<void>;
  createAdmin(input: {
    email: string;
    passwordHash: string;
    totpSecretEnc: Uint8Array;
    roles: string[];
  }): Promise<string>;
}
