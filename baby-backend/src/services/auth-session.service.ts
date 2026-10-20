import {
  PROFILE_IMAGE_SERVICE,
  type IProfileImageService,
} from '../interfaces/services/profile-image-service.interface';
import { randomInt, timingSafeEqual } from 'node:crypto';
import { Optional, Inject, Injectable } from '@nestjs/common';
import { NO_PROFILE_IMAGES } from './no-profile-images';
import { ConfigService } from '@nestjs/config';
import type { Environment } from '../config/environment';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { normalizePhoneNumber } from '../common/auth/phone-number';
import {
  DomainError,
  ServiceUnavailableError,
} from '../common/errors/domain.error';
import { AuthTokensResponseDto } from '../dto/auth/auth-tokens.dto';
import type {
  PhoneOtpResponseDto,
  RequestPhoneOtpDto,
} from '../dto/auth/phone-otp.dto';
import type { VerifyPhoneOtpDto } from '../dto/auth/verify-phone-otp.dto';
import { UserResponseDto } from '../dto/user/user-response.dto';
import { AUTH_SESSION_REPOSITORY } from '../interfaces/repositories/auth-session-repository.interface';
import type { IAuthSessionRepository } from '../interfaces/repositories/auth-session-repository.interface';
import { CACHE_REPOSITORY } from '../interfaces/repositories/cache-repository.interface';
import type { ICacheRepository } from '../interfaces/repositories/cache-repository.interface';
import type {
  AuthRequestContext,
  IAuthSessionService,
} from '../interfaces/services/auth-session-service.interface';
import { AUTH_TOKEN_SERVICE } from '../interfaces/services/auth-token-service.interface';
import type { IAuthTokenService } from '../interfaces/services/auth-token-service.interface';
import { OTP_SENDER_SERVICE } from '../interfaces/services/otp-sender-service.interface';
import type { IOtpSenderService } from '../interfaces/services/otp-sender-service.interface';
import type { User } from '../models/user.model';
import type { UserSession } from '../models/user-session.model';

const SECOND = 1000;
const DAY = 24 * 60 * 60 * SECOND;

/** Spec §5.3 limits. */
const OTP_TTL_SECONDS = 300;
const OTP_RESEND_SECONDS = 60;
const OTP_MAX_SENDS_PER_HOUR = 5;
const OTP_MAX_SENDS_PER_IP_HOUR = 20;
const OTP_MAX_ATTEMPTS = 5;
const OTP_LOCK_SECONDS = 15 * 60;
/** Spec §5.1: refresh tokens slide 90 days, absolute one year. */
const REFRESH_SLIDING_MS = 90 * DAY;
const REFRESH_ABSOLUTE_MS = 365 * DAY;
/** NOT NULL placeholder until AUTH-04 saves the real display name. */
const INITIAL_DISPLAY_NAME = 'Baby Family';

function rateLimited(message: string): DomainError {
  return new DomainError(message, 'RATE_LIMITED', 429);
}

@Injectable()
export class AuthSessionService implements IAuthSessionService {
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(AUTH_TOKEN_SERVICE) private readonly tokens: IAuthTokenService,
    @Inject(OTP_SENDER_SERVICE) private readonly otpSender: IOtpSenderService,
    @Inject(CACHE_REPOSITORY) private readonly cache: ICacheRepository,
    @Inject(AUTH_SESSION_REPOSITORY)
    private readonly repository: IAuthSessionRepository,
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly profileImages: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}

  async requestPhoneOtp(
    input: RequestPhoneOtpDto,
    context: AuthRequestContext,
  ): Promise<PhoneOtpResponseDto> {
    this.assertSignInAvailable();
    if (!this.otpSender.isConfigured())
      throw new ServiceUnavailableError('Sign-in codes cannot be sent now.');
    const phone = this.normalize(input.phone);
    const phoneKey = this.tokens.keyedHash('phone', phone).toString('hex');
    if (await this.cache.get(`otp:lock:${phoneKey}`))
      throw rateLimited('Too many wrong codes. Try again in 15 minutes.');
    if (
      !(await this.cache.setIfAbsent(
        `otp:cool:${phoneKey}`,
        '1',
        OTP_RESEND_SECONDS * SECOND,
      ))
    )
      throw rateLimited('Please wait before requesting another code.');
    const sends = await this.cache.increment(
      `otp:send:${phoneKey}`,
      3600 * SECOND,
    );
    if (sends > OTP_MAX_SENDS_PER_HOUR)
      throw rateLimited('Too many codes requested for this number.');
    if (context.ip) {
      const ipKey = this.tokens.keyedHash('phone', `ip:${context.ip}`);
      const perIp = await this.cache.increment(
        `otp:ip:${ipKey.toString('hex')}`,
        3600 * SECOND,
      );
      if (perIp > OTP_MAX_SENDS_PER_IP_HOUR)
        throw rateLimited('Too many codes requested from this network.');
    }
    const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
    await this.cache.set(
      `otp:${phoneKey}`,
      this.otpDigest(phoneKey, code).toString('hex'),
      { ttlMs: OTP_TTL_SECONDS * SECOND },
    );
    await this.cache.delete(`otp:att:${phoneKey}`);
    const { channelUsed } = await this.otpSender.send({
      phoneE164: phone,
      code,
      locale: 'vi',
      requestedChannel: input.channel ?? 'ZALO',
    });
    return {
      expiresIn: OTP_TTL_SECONDS,
      resendIn: OTP_RESEND_SECONDS,
      channelUsed,
    };
  }

  async verifyPhoneOtp(
    input: VerifyPhoneOtpDto,
    context: AuthRequestContext,
  ): Promise<AuthTokensResponseDto> {
    this.assertSignInAvailable();
    const phone = this.normalize(input.phone);
    const phoneKey = this.tokens.keyedHash('phone', phone).toString('hex');
    if (await this.cache.get(`otp:lock:${phoneKey}`))
      throw rateLimited('Too many wrong codes. Try again in 15 minutes.');
    const stored = await this.cache.get(`otp:${phoneKey}`);
    if (!stored) throw this.invalidCode();
    const attempts = await this.cache.increment(
      `otp:att:${phoneKey}`,
      OTP_TTL_SECONDS * SECOND,
    );
    // Concurrent guesses past the limit never reach the comparison.
    if (attempts > OTP_MAX_ATTEMPTS) {
      await this.lockOtp(phoneKey);
      throw rateLimited('Too many wrong codes. Try again in 15 minutes.');
    }
    const expected = Buffer.from(stored, 'hex');
    const actual = this.otpDigest(phoneKey, input.code);
    const matches =
      expected.length === actual.length && timingSafeEqual(expected, actual);
    if (!matches) {
      if (attempts >= OTP_MAX_ATTEMPTS) {
        await this.lockOtp(phoneKey);
        throw rateLimited('Too many wrong codes. Try again in 15 minutes.');
      }
      throw this.invalidCode();
    }
    // Single use: delete before issuing so a replay cannot sign in twice.
    if (!(await this.cache.delete(`otp:${phoneKey}`))) throw this.invalidCode();
    await this.cache.delete(`otp:att:${phoneKey}`);

    const now = new Date();
    const refresh = this.tokens.newRefreshToken();
    const result = await this.repository.signInWithPhone({
      phoneE164: phone,
      initialDisplayName: INITIAL_DISPLAY_NAME,
      locale: input.device?.locale ?? 'vi',
      timezone: input.device?.timezone ?? 'Asia/Ho_Chi_Minh',
      session: {
        refreshTokenHash: refresh.hash,
        expiresAt: new Date(now.getTime() + REFRESH_SLIDING_MS),
        absoluteExpiresAt: new Date(now.getTime() + REFRESH_ABSOLUTE_MS),
        platform: input.device?.platform ?? null,
        appVersion: input.device?.appVersion ?? null,
        ip: context.ip,
      },
      now,
    });
    if (result.kind !== 'SIGNED_IN')
      throw new DomainError(
        'This account cannot sign in.',
        'AUTH_ACCOUNT_UNAVAILABLE',
        403,
      );
    return this.tokensResponse(
      result.user,
      result.session,
      refresh.value,
      result.created,
    );
  }

  async refresh(refreshToken: string): Promise<AuthTokensResponseDto> {
    this.assertSignInAvailable();
    const now = new Date();
    const next = this.tokens.newRefreshToken();
    const result = await this.repository.rotateSession({
      refreshTokenHash: this.tokens.hashRefreshToken(refreshToken),
      newRefreshTokenHash: next.hash,
      slidingExpiresAt: new Date(now.getTime() + REFRESH_SLIDING_MS),
      now,
    });
    if (result.kind === 'REUSED')
      throw new DomainError(
        'The session was revoked. Please sign in again.',
        'AUTH_SESSION_REVOKED',
        401,
      );
    if (result.kind === 'INVALID')
      throw new DomainError(
        'The refresh token is invalid or expired.',
        'AUTH_REFRESH_INVALID',
        401,
      );
    return this.tokensResponse(result.user, result.session, next.value, false);
  }

  async logout(actor: AuthPrincipal): Promise<void> {
    await this.repository.revokeSession(
      actor.userId,
      actor.sessionId,
      'LOGOUT',
      new Date(),
    );
  }

  private async tokensResponse(
    user: User,
    session: UserSession,
    refreshToken: string,
    isNewUser: boolean,
  ): Promise<AuthTokensResponseDto> {
    const access = await this.tokens.issueAccessToken({
      userId: user.id,
      sessionId: session.id,
      tokenVersion: user.tokenVersion,
    });
    return Object.assign(new AuthTokensResponseDto(), {
      accessToken: access.token,
      refreshToken,
      expiresIn: access.expiresIn,
      user: Object.assign(
        UserResponseDto.fromModel(user),
        await this.profileImages.userAvatar(user.id),
      ),
      isNewUser,
    });
  }

  private assertSignInAvailable(): void {
    if (!this.tokens.isConfigured() || !this.cache.isConfigured())
      throw new ServiceUnavailableError('Sign-in is not configured.');
  }

  private normalize(phone: string): string {
    const normalized = normalizePhoneNumber(
      phone,
      this.config.get('AUTH_OTP_ALLOWED_COUNTRY_CODES', { infer: true }),
    );
    if (!normalized)
      throw new DomainError(
        'This phone number is not supported.',
        'PHONE_NOT_SUPPORTED',
        400,
      );
    return normalized;
  }

  private async lockOtp(phoneKey: string): Promise<void> {
    await this.cache.delete(`otp:${phoneKey}`);
    await this.cache.set(`otp:lock:${phoneKey}`, '1', {
      ttlMs: OTP_LOCK_SECONDS * SECOND,
    });
  }

  private otpDigest(phoneKey: string, code: string): Buffer {
    return this.tokens.keyedHash('otp', `${phoneKey}:${code}`);
  }

  private invalidCode(): DomainError {
    return new DomainError(
      'The code is incorrect or has expired.',
      'OTP_INVALID',
      400,
    );
  }
}
