import type { AuthPrincipal } from '../../common/auth/auth-principal';

export const AUTHENTICATION_SERVICE = Symbol('AUTHENTICATION_SERVICE');
export interface IAuthenticationService {
  verifyAccessToken(token: string): Promise<AuthPrincipal>;
}
