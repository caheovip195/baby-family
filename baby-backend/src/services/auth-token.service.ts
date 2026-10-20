import { createHash, createHmac, randomBytes } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import type { OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { importPKCS8, SignJWT } from 'jose';
import type { Environment } from '../config/environment';
import { ServiceUnavailableError } from '../common/errors/domain.error';
import type {
  AccessTokenClaims,
  GeneratedSecret,
  IAuthTokenService,
  IssuedAccessToken,
  KeyedHashPurpose,
} from '../interfaces/services/auth-token-service.interface';

/** Spec §5.1: access tokens live 15 minutes (the verifier rejects anything longer). */
const ACCESS_TOKEN_SECONDS = 900;

@Injectable()
export class AuthTokenService implements IAuthTokenService, OnModuleInit {
  private signingKey: Awaited<ReturnType<typeof importPKCS8>> | undefined;
  private readonly pepper: string | undefined;

  constructor(private readonly config: ConfigService<Environment, true>) {
    this.pepper = this.config.get('AUTH_SECRET_PEPPER', { infer: true });
  }

  async onModuleInit(): Promise<void> {
    const pem = this.config.get('AUTH_JWT_PRIVATE_KEY', { infer: true });
    if (!pem) return;
    try {
      this.signingKey = await importPKCS8(pem.replace(/\\n/g, '\n'), 'ES256');
    } catch {
      throw new Error(
        'Invalid AUTH_JWT_PRIVATE_KEY: expected an ES256 PKCS#8 private key.',
      );
    }
  }

  isConfigured(): boolean {
    return this.signingKey !== undefined && this.pepper !== undefined;
  }

  async issueAccessToken(
    claims: AccessTokenClaims,
  ): Promise<IssuedAccessToken> {
    const key = this.requireSigningKey();
    const issuedAt = Math.floor(Date.now() / 1000);
    const token = await new SignJWT({
      sid: claims.sessionId,
      ver: claims.tokenVersion,
    })
      .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
      .setSubject(claims.userId)
      .setIssuer(this.config.get('AUTH_JWT_ISSUER', { infer: true }))
      .setAudience(this.config.get('AUTH_JWT_AUDIENCE', { infer: true }))
      .setIssuedAt(issuedAt)
      .setExpirationTime(issuedAt + ACCESS_TOKEN_SECONDS)
      .sign(key);
    return { token, expiresIn: ACCESS_TOKEN_SECONDS };
  }

  newRefreshToken(): GeneratedSecret {
    this.requireSigningKey();
    const value = randomBytes(32).toString('base64url');
    return { value, hash: this.hashRefreshToken(value) };
  }

  hashRefreshToken(token: string): Buffer {
    return createHash('sha256').update(token, 'utf8').digest();
  }

  newInviteToken(): GeneratedSecret {
    const value = randomBytes(32).toString('base64url');
    return { value, hash: this.hashInviteToken(value) };
  }

  hashInviteToken(token: string): Buffer {
    return createHash('sha256').update(token, 'utf8').digest();
  }

  keyedHash(purpose: KeyedHashPurpose, value: string): Buffer {
    if (!this.pepper)
      throw new ServiceUnavailableError('Sign-in is not configured.');
    return createHmac('sha256', this.pepper)
      .update(`${purpose}:${value}`, 'utf8')
      .digest();
  }

  private requireSigningKey() {
    if (!this.signingKey || !this.pepper)
      throw new ServiceUnavailableError('Sign-in is not configured.');
    return this.signingKey;
  }
}
