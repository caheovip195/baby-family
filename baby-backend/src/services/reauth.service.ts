import { createPublicKey, randomInt, timingSafeEqual } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { importPKCS8, importSPKI, jwtVerify, SignJWT } from 'jose';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  ServiceUnavailableError,
} from '../common/errors/domain.error';
import { ACCOUNT_DELETION_POLICY } from '../config/account-deletion-policy';
import { REAUTH_POLICY as POLICY } from '../config/reauth-policy';
import { AUTH_SESSION_REPOSITORY } from '../interfaces/repositories/auth-session-repository.interface';
import type { IAuthSessionRepository } from '../interfaces/repositories/auth-session-repository.interface';
import { CACHE_REPOSITORY } from '../interfaces/repositories/cache-repository.interface';
import type { ICacheRepository } from '../interfaces/repositories/cache-repository.interface';
import { AUTH_TOKEN_SERVICE } from '../interfaces/services/auth-token-service.interface';
import type { IAuthTokenService } from '../interfaces/services/auth-token-service.interface';
import { OTP_SENDER_SERVICE } from '../interfaces/services/otp-sender-service.interface';
import type { IOtpSenderService } from '../interfaces/services/otp-sender-service.interface';
import type { IReauthService } from '../interfaces/services/reauth-service.interface';

@Injectable()
export class ReauthService implements IReauthService {
  constructor(
    private readonly config: ConfigService,
    @Inject(AUTH_SESSION_REPOSITORY)
    private readonly repository: IAuthSessionRepository,
    @Inject(CACHE_REPOSITORY) private readonly cache: ICacheRepository,
    @Inject(AUTH_TOKEN_SERVICE) private readonly tokens: IAuthTokenService,
    @Inject(OTP_SENDER_SERVICE) private readonly sender: IOtpSenderService,
  ) {}

  async requestOtp(actor: AuthPrincipal, ip: string | null) {
    this.assertAvailable();
    if (!this.sender.isConfigured())
      throw new ServiceUnavailableError('Sign-in codes cannot be sent now.');
    const phone = await this.phone(actor);
    const phoneKey = this.tokens.keyedHash('phone', phone).toString('hex');
    // Share phone/IP throttles with login; REAUTH proof lives in a separate purpose/session namespace.
    await this.assertUnlocked(phoneKey);
    if (
      !(await this.cache.setIfAbsent(
        `otp:cool:${phoneKey}`,
        '1',
        POLICY.resendSeconds * 1000,
      ))
    )
      throw this.rateLimited();
    if (
      (await this.cache.increment(`otp:send:${phoneKey}`, 3600000)) >
      POLICY.sendsPerHour
    )
      throw this.rateLimited();
    if (ip) {
      const ipKey = this.tokens.keyedHash('phone', `ip:${ip}`).toString('hex');
      if (
        (await this.cache.increment(`otp:ip:${ipKey}`, 3600000)) >
        POLICY.sendsPerIpHour
      )
        throw this.rateLimited();
    }
    const code = randomInt(0, 1000000).toString().padStart(6, '0');
    const key = this.key(actor, phoneKey);
    await this.cache.set(key, this.digest(key, code).toString('hex'), {
      ttlMs: POLICY.ttlSeconds * 1000,
    });
    // Wrong attempts are shared by phone and never reset by resending from a second session.
    const result = await this.sender.send({
      phoneE164: phone,
      code,
      locale: 'vi',
      requestedChannel: 'ZALO',
    });
    return {
      expiresIn: POLICY.ttlSeconds,
      resendIn: POLICY.resendSeconds,
      channelUsed: result.channelUsed,
    };
  }

  async verify(actor: AuthPrincipal, code: string) {
    this.assertAvailable();
    const phone = await this.phone(actor);
    const phoneKey = this.tokens.keyedHash('phone', phone).toString('hex');
    await this.assertUnlocked(phoneKey);
    const key = this.key(actor, phoneKey);
    const stored = await this.cache.get(key);
    if (!stored) throw this.invalidCode();
    const attempts = await this.cache.increment(
      `otp:att:${phoneKey}`,
      POLICY.ttlSeconds * 1000,
    );
    if (attempts > POLICY.maxAttempts) {
      await this.lock(phoneKey, key);
      throw this.rateLimited();
    }
    const expected = Buffer.from(stored, 'hex'),
      actual = this.digest(key, code);
    if (
      expected.length !== actual.length ||
      !timingSafeEqual(expected, actual)
    ) {
      if (attempts >= POLICY.maxAttempts) {
        await this.lock(phoneKey, key);
        throw this.rateLimited();
      }
      throw this.invalidCode();
    }
    // Atomic DEL ensures concurrent successes cannot both mint a token.
    if (!(await this.cache.delete(key))) throw this.invalidCode();
    await this.cache.delete(`otp:att:${phoneKey}`);
    // Recheck state after consuming the OTP so a concurrently revoked session cannot issue proof.
    await this.phone(actor);
    const pem = this.config.get<string>('AUTH_JWT_PRIVATE_KEY')!;
    const signingKey = await importPKCS8(pem.replace(/\\n/g, '\n'), 'ES256');
    const iat = Math.floor(Date.now() / 1000),
      exp = iat + ACCOUNT_DELETION_POLICY.reauthMaxAgeSeconds;
    const reauthToken = await new SignJWT({
      sid: actor.sessionId,
      ver: actor.tokenVersion,
      scope: 'reauth',
    })
      .setProtectedHeader({ alg: 'ES256', typ: 'reauth+jwt' })
      .setSubject(actor.userId)
      .setIssuer(this.config.get<string>('AUTH_JWT_ISSUER')!)
      .setAudience(this.config.get<string>('AUTH_JWT_AUDIENCE')!)
      .setIssuedAt(iat)
      .setExpirationTime(exp)
      .sign(signingKey);
    return { reauthToken, expiresAt: new Date(exp * 1000).toISOString() };
  }

  /** Purpose-bound, short-lived proof must belong to the currently authenticated session. */
  async verifyToken(
    actor: AuthPrincipal,
    token: string,
  ): Promise<{ expiresAt: Date }> {
    let pem = this.config.get<string>('AUTH_JWT_PUBLIC_KEY');
    const privatePem = this.config.get<string>('AUTH_JWT_PRIVATE_KEY');
    if (!pem && privatePem)
      pem = createPublicKey(privatePem.replace(/\\n/g, '\n'))
        .export({ type: 'spki', format: 'pem' })
        .toString();
    if (!pem)
      throw new DomainError(
        'Reauthentication is not configured.',
        'REAUTH_UNAVAILABLE',
        503,
      );
    try {
      const key = await importSPKI(pem.replace(/\\n/g, '\n'), 'ES256');
      const { payload } = await jwtVerify(token, key, {
        algorithms: ['ES256'],
        typ: 'reauth+jwt',
        issuer: this.config.get<string>('AUTH_JWT_ISSUER'),
        audience: this.config.get<string>('AUTH_JWT_AUDIENCE'),
        requiredClaims: ['sub', 'sid', 'ver', 'iat', 'exp'],
        maxTokenAge: ACCOUNT_DELETION_POLICY.reauthMaxAgeSeconds,
        clockTolerance: 0,
      });
      if (
        payload.scope !== 'reauth' ||
        payload.sub !== actor.userId ||
        payload.sid !== actor.sessionId ||
        payload.ver !== actor.tokenVersion ||
        !Number.isSafeInteger(payload.ver) ||
        payload.ver < 1 ||
        !Number.isInteger(payload.iat) ||
        !Number.isInteger(payload.exp) ||
        payload.exp! <= payload.iat! ||
        payload.exp! - payload.iat! >
          ACCOUNT_DELETION_POLICY.reauthMaxAgeSeconds
      )
        throw new Error('Invalid reauth claims');
      return { expiresAt: new Date(payload.exp! * 1000) };
    } catch {
      throw new DomainError(
        'Fresh reauthentication is required.',
        'REAUTH_REQUIRED',
        401,
      );
    }
  }

  private assertAvailable() {
    if (
      !this.tokens.isConfigured() ||
      !this.cache.isConfigured() ||
      !this.config.get<string>('AUTH_JWT_PRIVATE_KEY')
    )
      throw new ServiceUnavailableError('Reauthentication is not configured.');
  }
  private async phone(actor: AuthPrincipal) {
    const phone = await this.repository.findReauthPhone(actor, new Date());
    if (!phone)
      throw new DomainError(
        'A verified phone and active session are required.',
        'REAUTH_PHONE_REQUIRED',
        403,
      );
    return phone;
  }
  private key(actor: AuthPrincipal, phoneKey: string) {
    return `otp:REAUTH:v${POLICY.version}:${phoneKey}:${actor.userId}:${actor.sessionId}:${actor.tokenVersion}`;
  }
  private digest(key: string, code: string) {
    return this.tokens.keyedHash('otp', `${key}:${code}`);
  }
  private async assertUnlocked(phoneKey: string) {
    if (await this.cache.get(`otp:lock:${phoneKey}`)) throw this.rateLimited();
  }
  private async lock(phoneKey: string, key: string) {
    await this.cache.delete(key);
    await this.cache.set(`otp:lock:${phoneKey}`, '1', {
      ttlMs: POLICY.lockSeconds * 1000,
    });
  }
  private rateLimited() {
    return new DomainError(
      'Too many codes or attempts. Try again later.',
      'RATE_LIMITED',
      429,
    );
  }
  private invalidCode() {
    return new DomainError(
      'The code is incorrect or has expired.',
      'OTP_INVALID',
      400,
    );
  }
}
