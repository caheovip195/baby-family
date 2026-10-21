import { createHash, timingSafeEqual } from 'node:crypto';
import { Inject, Injectable, Optional } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createRemoteJWKSet, errors, jwtVerify } from 'jose';
import type { JWTVerifyGetKey } from 'jose';
import { DomainError } from '../common/errors/domain.error';
import { EXTERNAL_IDENTITY_KEY_RESOLVER } from '../interfaces/services/external-identity-verifier.interface';
import type {
  ExternalProvider,
  IExternalIdentityKeyResolver,
  IExternalIdentityVerifier,
  VerifiedExternalIdentity,
} from '../interfaces/services/external-identity-verifier.interface';

@Injectable()
export class ExternalIdentityVerifierService implements IExternalIdentityVerifier {
  private readonly keySets = new Map<string, JWTVerifyGetKey>();

  constructor(
    private readonly config: ConfigService,
    @Optional()
    @Inject(EXTERNAL_IDENTITY_KEY_RESOLVER)
    private readonly resolver?: IExternalIdentityKeyResolver,
  ) {}

  async verify(
    provider: ExternalProvider,
    token: string,
    nonce?: string,
  ): Promise<VerifiedExternalIdentity> {
    const prefix = `AUTH_${provider}`;
    const issuer = this.config.get<string>(`${prefix}_ISSUER`);
    const audience = this.config.get<string>(`${prefix}_CLIENT_ID`);
    const url = this.config.get<string>(`${prefix}_JWKS_URL`);
    if (!issuer || !audience || !url) throw this.unavailable();
    let keySet: JWTVerifyGetKey;
    try {
      const endpoint = new URL(url);
      if (endpoint.protocol !== 'https:') throw this.unavailable();
      const cacheKey = `${provider}:${endpoint.href}`;
      const cached = this.keySets.get(cacheKey);
      keySet =
        cached ??
        this.resolver?.getKeySet(provider, endpoint) ??
        createRemoteJWKSet(endpoint);
      if (!cached) this.keySets.set(cacheKey, keySet);
    } catch {
      throw this.unavailable();
    }
    try {
      const { payload } = await jwtVerify(
        token,
        async (header, jwt) => {
          try {
            return await keySet(header, jwt);
          } catch (error) {
            if (
              error instanceof errors.JWKSNoMatchingKey ||
              error instanceof errors.JWKSMultipleMatchingKeys ||
              error instanceof errors.JOSENotSupported
            )
              throw this.invalid();
            throw this.unavailable();
          }
        },
        {
          algorithms: ['RS256'],
          issuer,
          audience,
          requiredClaims: ['sub', 'iss', 'aud', 'iat', 'exp'],
          clockTolerance: 0,
        },
      );
      const now = Math.floor(Date.now() / 1000);
      if (
        typeof payload.sub !== 'string' ||
        !payload.sub.trim() ||
        payload.sub.length > 255 ||
        !Number.isSafeInteger(payload.iat) ||
        !Number.isSafeInteger(payload.exp) ||
        payload.iat! > now ||
        payload.exp! <= payload.iat!
      )
        throw this.invalid();
      if (provider === 'APPLE' && nonce !== undefined) {
        const expected = createHash('sha256').update(nonce).digest('hex');
        if (
          typeof payload.nonce !== 'string' ||
          payload.nonce.length !== expected.length ||
          !timingSafeEqual(Buffer.from(payload.nonce), Buffer.from(expected))
        )
          throw this.invalid();
      }
      const verified =
        payload.email_verified === true ||
        (provider === 'APPLE' && payload.email_verified === 'true');
      return {
        provider,
        subject: payload.sub,
        email:
          verified &&
          typeof payload.email === 'string' &&
          payload.email.length <= 254 &&
          /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(payload.email)
            ? payload.email
            : null,
      };
    } catch (error) {
      if (error instanceof DomainError) throw error;
      throw this.invalid();
    }
  }

  private unavailable() {
    return new DomainError(
      'Sign-in provider is unavailable.',
      'AUTH_PROVIDER_UNAVAILABLE',
      503,
    );
  }

  private invalid() {
    return new DomainError(
      'Identity token is invalid.',
      'AUTH_IDENTITY_INVALID',
      401,
    );
  }
}
