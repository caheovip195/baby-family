import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { AuthTokensResponseDto } from '../../dto/auth/auth-tokens.dto';
import type {
  PhoneOtpResponseDto,
  RequestPhoneOtpDto,
} from '../../dto/auth/phone-otp.dto';
import type { VerifyPhoneOtpDto } from '../../dto/auth/verify-phone-otp.dto';

export const AUTH_SESSION_SERVICE = Symbol('AUTH_SESSION_SERVICE');

export interface AuthRequestContext {
  /** Client IP, used only for rate limiting and session audit. */
  ip: string | null;
}

/** Sign-in, refresh rotation and sign-out (spec §5). */
export interface IAuthSessionService {
  requestPhoneOtp(
    input: RequestPhoneOtpDto,
    context: AuthRequestContext,
  ): Promise<PhoneOtpResponseDto>;
  verifyPhoneOtp(
    input: VerifyPhoneOtpDto,
    context: AuthRequestContext,
  ): Promise<AuthTokensResponseDto>;
  refresh(refreshToken: string): Promise<AuthTokensResponseDto>;
  logout(actor: AuthPrincipal): Promise<void>;
}
