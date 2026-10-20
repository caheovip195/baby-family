import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { PhoneOtpResponseDto } from '../../dto/auth/phone-otp.dto';
import type {
  ChangedPhoneResponseDto,
  RequestPhoneChangeOtpDto,
  RevokeOtherSessionsResponseDto,
  SecuritySessionsResponseDto,
  VerifyPhoneChangeDto,
} from '../../dto/user/account-security.dto';
export const ACCOUNT_SECURITY_SERVICE = Symbol('ACCOUNT_SECURITY_SERVICE');
export interface IAccountSecurityService {
  listSessions(actor: AuthPrincipal): Promise<SecuritySessionsResponseDto>;
  revokeSession(actor: AuthPrincipal, id: string): Promise<void>;
  revokeOthers(actor: AuthPrincipal): Promise<RevokeOtherSessionsResponseDto>;
  requestPhoneOtp(
    actor: AuthPrincipal,
    input: RequestPhoneChangeOtpDto,
    ip: string | null,
  ): Promise<PhoneOtpResponseDto>;
  verifyPhone(
    actor: AuthPrincipal,
    input: VerifyPhoneChangeDto,
  ): Promise<ChangedPhoneResponseDto>;
}
