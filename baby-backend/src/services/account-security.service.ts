import { randomInt, timingSafeEqual } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { normalizePhoneNumber } from '../common/auth/phone-number';
import {
  DomainError,
  NotFoundError,
  ServiceUnavailableError,
} from '../common/errors/domain.error';
import { ACCOUNT_SECURITY_POLICY as POLICY } from '../config/account-security-policy';
import type {
  RequestPhoneChangeOtpDto,
  VerifyPhoneChangeDto,
} from '../dto/user/account-security.dto';
import { ACCOUNT_SECURITY_REPOSITORY } from '../interfaces/repositories/account-security-repository.interface';
import type { IAccountSecurityRepository } from '../interfaces/repositories/account-security-repository.interface';
import { AUTH_SESSION_REPOSITORY } from '../interfaces/repositories/auth-session-repository.interface';
import type { IAuthSessionRepository } from '../interfaces/repositories/auth-session-repository.interface';
import { CACHE_REPOSITORY } from '../interfaces/repositories/cache-repository.interface';
import type { ICacheRepository } from '../interfaces/repositories/cache-repository.interface';
import { AUTH_TOKEN_SERVICE } from '../interfaces/services/auth-token-service.interface';
import type { IAuthTokenService } from '../interfaces/services/auth-token-service.interface';
import { OTP_SENDER_SERVICE } from '../interfaces/services/otp-sender-service.interface';
import type { IOtpSenderService } from '../interfaces/services/otp-sender-service.interface';
import { REAUTH_SERVICE } from '../interfaces/services/reauth-service.interface';
import type { IReauthService } from '../interfaces/services/reauth-service.interface';
import type { IAccountSecurityService } from '../interfaces/services/account-security-service.interface';

@Injectable()
export class AccountSecurityService implements IAccountSecurityService {
  constructor(
    @Inject(ACCOUNT_SECURITY_REPOSITORY)
    private readonly repository: IAccountSecurityRepository,
    @Inject(AUTH_SESSION_REPOSITORY)
    private readonly sessions: IAuthSessionRepository,
    @Inject(CACHE_REPOSITORY) private readonly cache: ICacheRepository,
    @Inject(AUTH_TOKEN_SERVICE) private readonly tokens: IAuthTokenService,
    @Inject(OTP_SENDER_SERVICE) private readonly sender: IOtpSenderService,
    @Inject(REAUTH_SERVICE) private readonly reauth: IReauthService,
    private readonly config: ConfigService,
  ) {}

  async listSessions(actor: AuthPrincipal) {
    const rows = await this.repository.listSessions(actor.userId, new Date());
    return {
      items: rows.map(({ session, device }) => ({
        id: session.id,
        platform: device?.platform ?? session.platform,
        appVersion: device?.appVersion ?? session.appVersion,
        deviceModel: device?.deviceModel ?? null,
        createdAt: session.createdAt.toISOString(),
        lastUsedAt: session.lastUsedAt.toISOString(),
        current: session.id === actor.sessionId,
      })),
    };
  }

  async revokeSession(actor: AuthPrincipal, id: string) {
    const now = new Date();
    if (!(await this.repository.findSession(actor.userId, id, now)))
      throw new NotFoundError('Session not found.');
    // Existing refresh-chain revocation also invalidates access via the guard's live revokedAt check.
    await this.sessions.revokeSession(actor.userId, id, 'REMOTE_LOGOUT', now);
  }

  async revokeOthers(actor: AuthPrincipal) {
    return {
      revokedCount: await this.repository.revokeOthers(actor, new Date()),
    };
  }

  async requestPhoneOtp(
    actor: AuthPrincipal,
    input: RequestPhoneChangeOtpDto,
    ip: string | null,
  ) {
    const proof = await this.reauth.verifyToken(actor, input.reauthToken);
    this.assertAvailable();
    const phone = this.normalize(input.phone);
    if (await this.repository.isPhoneUsedByAnother(actor.userId, phone))
      throw this.phoneUsed();
    const phoneKey = this.phoneKey(phone);
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
    const ttlMs = Math.min(
      POLICY.ttlSeconds * 1000,
      proof.expiresAt.getTime() - Date.now(),
    );
    if (ttlMs <= 0)
      throw new DomainError(
        'Fresh reauthentication is required.',
        'REAUTH_REQUIRED',
        401,
      );
    const code = randomInt(0, 1000000).toString().padStart(6, '0');
    const key = this.key(actor, phoneKey);
    await this.cache.set(key, this.digest(key, code).toString('hex'), {
      ttlMs,
    });
    const result = await this.sender.send({
      phoneE164: phone,
      code,
      locale: 'vi',
      requestedChannel: 'ZALO',
    });
    return {
      expiresIn: Math.floor(ttlMs / 1000),
      resendIn: POLICY.resendSeconds,
      channelUsed: result.channelUsed,
    };
  }

  async verifyPhone(actor: AuthPrincipal, input: VerifyPhoneChangeDto) {
    this.assertAvailable();
    const phone = this.normalize(input.phone),
      phoneKey = this.phoneKey(phone);
    await this.assertUnlocked(phoneKey);
    const key = this.key(actor, phoneKey),
      stored = await this.cache.get(key);
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
      actual = this.digest(key, input.code);
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
    if (!(await this.cache.delete(key))) throw this.invalidCode();
    await this.cache.delete(`otp:att:${phoneKey}`);
    await this.repository.changePhone(actor, phone, new Date());
    return {
      phone: `${phone.slice(0, 3)}${'*'.repeat(Math.max(0, phone.length - 6))}${phone.slice(-3)}`,
    };
  }

  private assertAvailable() {
    if (
      !this.tokens.isConfigured() ||
      !this.cache.isConfigured() ||
      !this.sender.isConfigured()
    )
      throw new ServiceUnavailableError(
        'Phone verification is not configured.',
      );
  }
  private normalize(phone: string) {
    const result = normalizePhoneNumber(
      phone,
      this.config.get<string[]>('AUTH_OTP_ALLOWED_COUNTRY_CODES') ?? [],
    );
    if (!result)
      throw new DomainError(
        'This phone number is not supported.',
        'PHONE_NOT_SUPPORTED',
        400,
      );
    return result;
  }
  private phoneKey(phone: string) {
    return this.tokens.keyedHash('phone', phone).toString('hex');
  }
  private key(actor: AuthPrincipal, phoneKey: string) {
    return `otp:${POLICY.purpose}:v${POLICY.version}:${phoneKey}:${actor.userId}:${actor.sessionId}:${actor.tokenVersion}`;
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
  private invalidCode() {
    return new DomainError(
      'The code is incorrect or has expired.',
      'OTP_INVALID',
      400,
    );
  }
  private phoneUsed() {
    return new DomainError(
      'This phone number is unavailable.',
      'PHONE_ALREADY_USED',
      409,
    );
  }
  private rateLimited() {
    return new DomainError(
      'Too many codes or attempts. Try again later.',
      'RATE_LIMITED',
      429,
    );
  }
}
