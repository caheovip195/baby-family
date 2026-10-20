import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { Platform } from '../../common/database.enums';
import type { User } from '../../models/user.model';
import type { UserSession } from '../../models/user-session.model';

export const AUTH_SESSION_REPOSITORY = Symbol('AUTH_SESSION_REPOSITORY');

export interface NewSessionInput {
  refreshTokenHash: Buffer;
  expiresAt: Date;
  absoluteExpiresAt: Date;
  platform: Platform | null;
  appVersion: string | null;
  ip: string | null;
}

export interface PhoneSignInInput {
  phoneE164: string;
  /** Placeholder until AUTH-04 sets the real name (column is NOT NULL). */
  initialDisplayName: string;
  locale: string;
  timezone: string;
  session: NewSessionInput;
  now: Date;
}

export type PhoneSignInResult =
  | { kind: 'SIGNED_IN'; user: User; session: UserSession; created: boolean }
  | { kind: 'USER_UNAVAILABLE' };

export interface RotateSessionInput {
  refreshTokenHash: Buffer;
  newRefreshTokenHash: Buffer;
  slidingExpiresAt: Date;
  now: Date;
}

export type RotateSessionResult =
  | { kind: 'ROTATED'; user: User; session: UserSession }
  /** A replaced token was presented again: the whole chain was revoked (spec §5.1). */
  | { kind: 'REUSED' }
  | { kind: 'INVALID' };

/** Sign-in identities and refresh-token sessions (spec §5). */
export interface IAuthSessionRepository {
  /** PHONE identities are created only after successful phone verification. */
  findReauthPhone(actor: AuthPrincipal, now: Date): Promise<string | null>;
  signInWithPhone(input: PhoneSignInInput): Promise<PhoneSignInResult>;
  rotateSession(input: RotateSessionInput): Promise<RotateSessionResult>;
  /** Revokes the caller's session (and its push devices); idempotent. */
  revokeSession(
    userId: string,
    sessionId: string,
    reason: string,
    now: Date,
  ): Promise<void>;
}
