export const AUTH_TOKEN_SERVICE = Symbol('AUTH_TOKEN_SERVICE');

export interface AccessTokenClaims {
  userId: string;
  sessionId: string;
  tokenVersion: number;
}

export interface IssuedAccessToken {
  token: string;
  /** Seconds until expiry (spec §5.1: 15 minutes). */
  expiresIn: number;
}

export interface GeneratedSecret {
  /** Plain value returned to the client once; never stored. */
  value: string;
  /** SHA-256 digest stored in PostgreSQL. */
  hash: Buffer;
}

/** Purposes keep keyed hashes of different inputs from colliding. */
export type KeyedHashPurpose = 'phone' | 'otp' | 'invite-code' | 'identity';

/**
 * Token issuance and secret hashing (spec §5.1, §5.3, §6.5). Throws
 * ServiceUnavailableError when signing keys or the pepper are not configured.
 */
export interface IAuthTokenService {
  isConfigured(): boolean;
  issueAccessToken(claims: AccessTokenClaims): Promise<IssuedAccessToken>;
  /** 256-bit opaque refresh token. */
  newRefreshToken(): GeneratedSecret;
  hashRefreshToken(token: string): Buffer;
  /** 256-bit URL-safe invite token (spec §10 BR-041). */
  newInviteToken(): GeneratedSecret;
  hashInviteToken(token: string): Buffer;
  /** HMAC-SHA256(pepper, purpose:value). */
  keyedHash(purpose: KeyedHashPurpose, value: string): Buffer;
}
