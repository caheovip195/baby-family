import { createPublicKey } from 'node:crypto';
import {
  Inject,
  Injectable,
  ServiceUnavailableException,
  UnauthorizedException,
} from '@nestjs/common';
import type { OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { importSPKI, jwtVerify } from 'jose';
import type { JWTPayload } from 'jose';
import type { Environment } from '../config/environment';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { AUTH_ACCESS_REPOSITORY } from '../interfaces/repositories/auth-access-repository.interface';
import type { IAuthAccessRepository } from '../interfaces/repositories/auth-access-repository.interface';
import type { IAuthenticationService } from '../interfaces/services/authentication-service.interface';

const uuid =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

@Injectable()
export class AuthenticationService
  implements IAuthenticationService, OnModuleInit
{
  private key: Awaited<ReturnType<typeof importSPKI>> | undefined;

  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(AUTH_ACCESS_REPOSITORY)
    private readonly repository: IAuthAccessRepository,
  ) {}

  async onModuleInit(): Promise<void> {
    // The verifying key comes from AUTH_JWT_PUBLIC_KEY or, when this API also
    // issues tokens, is derived from AUTH_JWT_PRIVATE_KEY.
    let pem = this.config.get('AUTH_JWT_PUBLIC_KEY', { infer: true });
    const privatePem = this.config.get('AUTH_JWT_PRIVATE_KEY', {
      infer: true,
    });
    if (!pem && privatePem) {
      try {
        pem = createPublicKey(privatePem.replace(/\\n/g, '\n'))
          .export({ type: 'spki', format: 'pem' })
          .toString();
      } catch {
        throw new Error(
          'Invalid AUTH_JWT_PRIVATE_KEY: expected an ES256 PKCS#8 private key.',
        );
      }
    }
    if (!pem) return;
    try {
      this.key = await importSPKI(pem.replace(/\\n/g, '\n'), 'ES256');
    } catch {
      throw new Error(
        'Invalid AUTH_JWT_PUBLIC_KEY: expected an ES256 public key.',
      );
    }
  }

  async verifyAccessToken(token: string): Promise<AuthPrincipal> {
    if (!this.key)
      throw new ServiceUnavailableException(
        'Access token verification is not configured.',
      );
    const now = new Date();
    let payload: JWTPayload;
    try {
      const result = await jwtVerify(token, this.key, {
        algorithms: ['ES256'],
        issuer: this.config.get('AUTH_JWT_ISSUER', { infer: true }),
        audience: this.config.get('AUTH_JWT_AUDIENCE', { infer: true }),
        typ: 'at+jwt',
        requiredClaims: ['sub', 'sid', 'ver', 'iat', 'exp'],
        maxTokenAge: 900,
        currentDate: now,
        clockTolerance: 0,
      });
      payload = result.payload;
      if (
        typeof payload.sub !== 'string' ||
        !uuid.test(payload.sub) ||
        typeof payload.sid !== 'string' ||
        !uuid.test(payload.sid) ||
        !Number.isSafeInteger(payload.ver) ||
        (payload.ver as number) < 0 ||
        typeof payload.iat !== 'number' ||
        typeof payload.exp !== 'number' ||
        !Number.isInteger(payload.iat) ||
        !Number.isInteger(payload.exp) ||
        payload.exp <= payload.iat ||
        payload.exp - payload.iat > 900 ||
        payload.scope === 'reauth'
      )
        throw new Error('Invalid access claims');
    } catch {
      throw new UnauthorizedException(
        'The access token is invalid or expired.',
      );
    }
    // Keep database outages distinct from invalid credentials; never log the token.
    let state;
    try {
      state = await this.repository.findUserSessionState(
        payload.sid,
        payload.sub,
        now,
      );
    } catch {
      throw new ServiceUnavailableException(
        'Session verification is temporarily unavailable.',
      );
    }
    if (!state || state.tokenVersion !== payload.ver)
      throw new UnauthorizedException('The session is no longer active.');
    return {
      userId: state.userId,
      sessionId: state.sessionId,
      tokenVersion: state.tokenVersion,
    };
  }
}
