import { Inject, Injectable, Optional } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { importPKCS8, SignJWT } from 'jose';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { ACCOUNT_DELETION_POLICY } from '../config/account-deletion-policy';
import type {
  AppleSignInDto,
  GoogleSignInDto,
} from '../dto/auth/social-identity.dto';
import { UserResponseDto } from '../dto/user/user-response.dto';
import {
  SOCIAL_IDENTITY_REPOSITORY,
  type ISocialIdentityRepository,
} from '../interfaces/repositories/social-identity-repository.interface';
import {
  EXTERNAL_IDENTITY_VERIFIER,
  type IExternalIdentityVerifier,
  type ExternalProvider,
} from '../interfaces/services/external-identity-verifier.interface';
import {
  AUTH_TOKEN_SERVICE,
  type IAuthTokenService,
} from '../interfaces/services/auth-token-service.interface';
import {
  REAUTH_SERVICE,
  type IReauthService,
} from '../interfaces/services/reauth-service.interface';
import {
  PROFILE_IMAGE_SERVICE,
  type IProfileImageService,
} from '../interfaces/services/profile-image-service.interface';
import type { ISocialIdentityService } from '../interfaces/services/social-identity-service.interface';
import { NO_PROFILE_IMAGES } from './no-profile-images';
@Injectable()
export class SocialIdentityService implements ISocialIdentityService {
  constructor(
    private readonly config: ConfigService,
    @Inject(SOCIAL_IDENTITY_REPOSITORY)
    private readonly repository: ISocialIdentityRepository,
    @Inject(EXTERNAL_IDENTITY_VERIFIER)
    private readonly verifier: IExternalIdentityVerifier,
    @Inject(AUTH_TOKEN_SERVICE) private readonly tokens: IAuthTokenService,
    @Inject(REAUTH_SERVICE) private readonly reauth: IReauthService,
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly images: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}
  private verify(
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
  ) {
    return this.verifier.verify(
      provider,
      'identityToken' in input ? input.identityToken : input.idToken,
      'nonce' in input ? input.nonce : undefined,
    );
  }
  async signIn(
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
    ip: string | null,
  ) {
    if (!this.tokens.isConfigured())
      throw new DomainError(
        'Sign-in is not configured.',
        'AUTH_PROVIDER_UNAVAILABLE',
        503,
      );
    const identity = await this.verify(provider, input);
    const now = new Date(),
      refresh = this.tokens.newRefreshToken();
    const result = await this.repository.signIn(
      identity,
      'fullName' in input && input.fullName?.trim()
        ? input.fullName.trim()
        : 'Baby Family',
      {
        refreshTokenHash: refresh.hash,
        expiresAt: new Date(now.getTime() + 90 * 86400000),
        absoluteExpiresAt: new Date(now.getTime() + 365 * 86400000),
        platform: null,
        appVersion: null,
        ip,
      },
      now,
    );
    if (result.kind !== 'SIGNED_IN')
      throw new DomainError(
        'This account cannot sign in.',
        'AUTH_ACCOUNT_UNAVAILABLE',
        403,
      );
    const access = await this.tokens.issueAccessToken({
      userId: result.user.id,
      sessionId: result.session.id,
      tokenVersion: result.user.tokenVersion,
    });
    return {
      accessToken: access.token,
      refreshToken: refresh.value,
      expiresIn: access.expiresIn,
      user: Object.assign(
        UserResponseDto.fromModel(result.user),
        await this.images.userAvatar(result.user.id),
      ),
      isNewUser: result.created,
    };
  }
  async list(actor: AuthPrincipal) {
    return (await this.repository.list(actor)).map((row) => ({
      provider: row.provider,
      linkedAt: row.createdAt.toISOString(),
      maskedHint:
        row.provider === 'PHONE'
          ? `***${row.providerUid.slice(-4)}`
          : row.email
            ? `${row.email.slice(0, 1)}***@${row.email.split('@')[1]}`
            : null,
    }));
  }
  async link(
    actor: AuthPrincipal,
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
    reauthToken: string,
  ) {
    await this.reauth.verifyToken(actor, reauthToken);
    await this.repository.link(actor, await this.verify(provider, input));
  }
  async unlink(actor: AuthPrincipal, provider: string, reauthToken: string) {
    if (!['apple', 'google'].includes(provider))
      throw new DomainError(
        'Unsupported identity provider.',
        'IDENTITY_PROVIDER_INVALID',
        400,
      );
    await this.reauth.verifyToken(actor, reauthToken);
    await this.repository.unlink(
      actor,
      provider.toUpperCase() as ExternalProvider,
    );
  }
  async reauthenticate(
    actor: AuthPrincipal,
    provider: ExternalProvider,
    input: AppleSignInDto | GoogleSignInDto,
  ) {
    if (!this.tokens.isConfigured())
      throw new DomainError(
        'Reauthentication is not configured.',
        'REAUTH_UNAVAILABLE',
        503,
      );
    await this.repository.assertOwned(
      actor,
      await this.verify(provider, input),
    );
    const key = await importPKCS8(
      this.config.get<string>('AUTH_JWT_PRIVATE_KEY')!.replace(/\\n/g, '\n'),
      'ES256',
    );
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
      .sign(key);
    return { reauthToken, expiresAt: new Date(exp * 1000).toISOString() };
  }
}
