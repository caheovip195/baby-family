import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  AppleSignInDto,
  GoogleSignInDto,
  SignInMethodResponseDto,
} from '../../dto/auth/social-identity.dto';
import type { AuthTokensResponseDto } from '../../dto/auth/auth-tokens.dto';
import type { ReauthResponseDto } from '../../dto/auth/reauth.dto';
import type { ExternalProvider } from './external-identity-verifier.interface';
export const SOCIAL_IDENTITY_SERVICE = Symbol('SOCIAL_IDENTITY_SERVICE');
export interface ISocialIdentityService {
  signIn(
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
    ip: string | null,
  ): Promise<AuthTokensResponseDto>;
  list(actor: AuthPrincipal): Promise<SignInMethodResponseDto[]>;
  link(
    actor: AuthPrincipal,
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
    reauthToken: string,
  ): Promise<void>;
  unlink(
    actor: AuthPrincipal,
    provider: string,
    reauthToken: string,
  ): Promise<void>;
  reauthenticate(
    actor: AuthPrincipal,
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
  ): Promise<ReauthResponseDto>;
}
