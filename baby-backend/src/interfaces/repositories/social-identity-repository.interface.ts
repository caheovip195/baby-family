import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { AuthProvider } from '../../common/database.enums';
import type {
  NewSessionInput,
  PhoneSignInResult,
} from './auth-session-repository.interface';
import type { AuthIdentity } from '../../models/auth-identity.model';
import type { VerifiedExternalIdentity } from '../services/external-identity-verifier.interface';
export const SOCIAL_IDENTITY_REPOSITORY = Symbol('SOCIAL_IDENTITY_REPOSITORY');
export interface ISocialIdentityRepository {
  signIn(
    identity: VerifiedExternalIdentity,
    displayName: string,
    session: NewSessionInput,
    now: Date,
  ): Promise<PhoneSignInResult>;
  list(actor: AuthPrincipal): Promise<AuthIdentity[]>;
  link(actor: AuthPrincipal, identity: VerifiedExternalIdentity): Promise<void>;
  unlink(actor: AuthPrincipal, provider: AuthProvider): Promise<void>;
  assertOwned(
    actor: AuthPrincipal,
    identity: VerifiedExternalIdentity,
  ): Promise<void>;
}
