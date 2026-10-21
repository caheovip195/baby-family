import type { AdminCmsActor } from '../../models/admin-cms-auth.model';
export const ADMIN_CMS_AUTH_SERVICE = Symbol('ADMIN_CMS_AUTH_SERVICE');
export interface IAdminCmsAuthService {
  login(
    email: string,
    password: string,
    totp?: string,
    clientKey?: string,
  ): Promise<{
    accessToken: string;
    tokenType: 'Bearer';
    expiresAt: string;
    issuer: string;
    audience: string;
    admin: { id: string; roles: string[] };
  }>;
  authenticate(token: string): Promise<AdminCmsActor>;
  recordDenied(actor: AdminCmsActor): Promise<void>;
  logout(actor: AdminCmsActor): Promise<void>;
}
