import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { PhoneOtpResponseDto } from '../../dto/auth/phone-otp.dto';
import type { ReauthResponseDto } from '../../dto/auth/reauth.dto';
export const REAUTH_SERVICE = Symbol('REAUTH_SERVICE');
export interface IReauthService {
  verifyToken(
    actor: AuthPrincipal,
    token: string,
  ): Promise<{ expiresAt: Date }>;
  requestOtp(
    actor: AuthPrincipal,
    ip: string | null,
  ): Promise<PhoneOtpResponseDto>;
  verify(actor: AuthPrincipal, code: string): Promise<ReauthResponseDto>;
}
