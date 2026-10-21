import type { JWTVerifyGetKey } from 'jose';

export const EXTERNAL_IDENTITY_VERIFIER = Symbol('EXTERNAL_IDENTITY_VERIFIER');
export const EXTERNAL_IDENTITY_KEY_RESOLVER = Symbol(
  'EXTERNAL_IDENTITY_KEY_RESOLVER',
);

export type ExternalProvider = 'APPLE' | 'GOOGLE';

export interface VerifiedExternalIdentity {
  provider: ExternalProvider;
  subject: string;
  email: string | null;
}

export interface IExternalIdentityVerifier {
  verify(
    provider: ExternalProvider,
    token: string,
    nonce?: string,
  ): Promise<VerifiedExternalIdentity>;
}

/** Trusted composition-root override for local JWKS tests; never supplied by HTTP input. */
export interface IExternalIdentityKeyResolver {
  getKeySet(provider: ExternalProvider, url: URL): JWTVerifyGetKey;
}
