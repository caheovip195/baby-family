import { createHash, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import {
  createLocalJWKSet,
  exportJWK,
  exportPKCS8,
  exportSPKI,
  generateKeyPair,
  SignJWT,
} from 'jose';
import type { JWTPayload } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { AuthController } from '../../src/controllers/auth.controller';
import { AUTH_SESSION_SERVICE } from '../../src/interfaces/services/auth-session-service.interface';
import { AuthSessionService } from '../../src/services/auth-session.service';
import { SocialAuthController } from '../../src/controllers/social-auth.controller';
import { SignInMethodsController } from '../../src/controllers/sign-in-methods.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTH_SESSION_REPOSITORY } from '../../src/interfaces/repositories/auth-session-repository.interface';
import { CACHE_REPOSITORY } from '../../src/interfaces/repositories/cache-repository.interface';
import { SOCIAL_IDENTITY_REPOSITORY } from '../../src/interfaces/repositories/social-identity-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AUTH_TOKEN_SERVICE } from '../../src/interfaces/services/auth-token-service.interface';
import {
  EXTERNAL_IDENTITY_KEY_RESOLVER,
  EXTERNAL_IDENTITY_VERIFIER,
} from '../../src/interfaces/services/external-identity-verifier.interface';
import { OTP_SENDER_SERVICE } from '../../src/interfaces/services/otp-sender-service.interface';
import { REAUTH_SERVICE } from '../../src/interfaces/services/reauth-service.interface';
import { SOCIAL_IDENTITY_SERVICE } from '../../src/interfaces/services/social-identity-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AuthSessionRepository } from '../../src/repositories/auth-session.repository';
import { SocialIdentityRepository } from '../../src/repositories/social-identity.repository';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthTokenService } from '../../src/services/auth-token.service';
import { ExternalIdentityVerifierService } from '../../src/services/external-identity-verifier.service';
import { ReauthService } from '../../src/services/reauth.service';
import { SocialIdentityService } from '../../src/services/social-identity.service';

type Provider = 'apple' | 'google';
interface Tokens {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  user: { id: string; displayName: string };
  isNewUser: boolean;
}
interface Methods {
  provider: string;
  linkedAt: string;
  maskedHint: string | null;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Social identity API (focused PostgreSQL module, local JWKS)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let rsa: Awaited<ReturnType<typeof generateKeyPair>>;
  let wrongRsa: Awaited<ReturnType<typeof generateKeyPair>>;
  const users = new Set<string>();
  const subjects = new Set<string>();
  const prefix = '/api/v1';
  const issuer = (provider: Provider) => `https://${provider}.identity.test`;
  const clientId = 'baby-family-social-integration';
  const http = () => request(app.getHttpServer());
  const subject = () => {
    const value = `social-spec-${randomUUID()}`;
    subjects.add(value);
    return value;
  };

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test database');
    const sessionKeys = await generateKeyPair('ES256', { extractable: true });
    rsa = await generateKeyPair('RS256', { extractable: true });
    wrongRsa = await generateKeyPair('RS256', { extractable: true });
    const jwk = {
      ...(await exportJWK(rsa.publicKey)),
      kid: 'social-test-key',
      alg: 'RS256',
      use: 'sig',
    };
    const local = createLocalJWKSet({ keys: [jwk] });
    const config = new ConfigService(
      validateEnvironment({
        ...process.env,
        AUTH_SECRET_PEPPER: `integration-social-${randomUUID()}`,
        AUTH_JWT_PRIVATE_KEY: await exportPKCS8(sessionKeys.privateKey),
        AUTH_JWT_PUBLIC_KEY: await exportSPKI(sessionKeys.publicKey),
        AUTH_APPLE_JWKS_URL: `${issuer('apple')}/jwks`,
        AUTH_APPLE_ISSUER: issuer('apple'),
        AUTH_APPLE_CLIENT_ID: clientId,
        AUTH_GOOGLE_JWKS_URL: `${issuer('google')}/jwks`,
        AUTH_GOOGLE_ISSUER: issuer('google'),
        AUTH_GOOGLE_CLIENT_ID: clientId,
      }),
    );
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [
        SocialAuthController,
        SignInMethodsController,
        AuthController,
      ],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: SOCIAL_IDENTITY_SERVICE, useClass: SocialIdentityService },
        {
          provide: SOCIAL_IDENTITY_REPOSITORY,
          useClass: SocialIdentityRepository,
        },
        {
          provide: EXTERNAL_IDENTITY_VERIFIER,
          useClass: ExternalIdentityVerifierService,
        },
        {
          provide: EXTERNAL_IDENTITY_KEY_RESOLVER,
          useValue: { getKeySet: () => local },
        },
        { provide: AUTH_TOKEN_SERVICE, useClass: AuthTokenService },
        { provide: AUTH_SESSION_SERVICE, useClass: AuthSessionService },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTH_SESSION_REPOSITORY, useClass: AuthSessionRepository },
        { provide: REAUTH_SERVICE, useClass: ReauthService },
        { provide: CACHE_REPOSITORY, useValue: { isConfigured: () => true } },
        {
          provide: OTP_SENDER_SERVICE,
          useValue: { isConfigured: () => false },
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
    prisma = module.get(PrismaService);
  });

  afterAll(async () => {
    if (prisma) {
      const owned = await prisma.authIdentity.findMany({
        where: { providerUid: { in: [...subjects] } },
        select: { userId: true },
      });
      owned.forEach((row) => users.add(row.userId));
      const ids = [...users],
        now = new Date();
      await prisma.userSession.updateMany({
        where: { userId: { in: ids } },
        data: { deletedAt: now, revokedAt: now },
      });
      await prisma.authIdentity.updateMany({
        where: { userId: { in: ids } },
        data: { deletedAt: now },
      });
      await prisma.user.updateMany({
        where: { id: { in: ids } },
        data: { deletedAt: now },
      });
    }
    await app?.close();
  });

  async function jwt(
    provider: Provider,
    sub: string,
    claims: JWTPayload = {},
    wrongKey = false,
  ) {
    const now = Math.floor(Date.now() / 1000);
    return new SignJWT({
      sub,
      iss: issuer(provider),
      aud: clientId,
      iat: now,
      exp: now + 300,
      ...claims,
    })
      .setProtectedHeader({ alg: 'RS256', kid: 'social-test-key' })
      .sign(wrongKey ? wrongRsa.privateKey : rsa.privateKey);
  }
  const body = (provider: Provider, token: string) =>
    provider === 'apple' ? { identityToken: token } : { idToken: token };
  async function signIn(
    provider: Provider,
    sub = subject(),
    claims: JWTPayload = {},
  ) {
    const token = await jwt(provider, sub, claims);
    const response = await http()
      .post(`${prefix}/auth/${provider}`)
      .send(body(provider, token))
      .expect(200);
    const result = data<Tokens>(response);
    users.add(result.user.id);
    return { ...result, sub, token, provider };
  }
  async function proof(who: Awaited<ReturnType<typeof signIn>>) {
    const response = await http()
      .post(`${prefix}/auth/reauth/${who.provider}`)
      .auth(who.accessToken, { type: 'bearer' })
      .send(body(who.provider, who.token))
      .expect(200);
    return data<{ reauthToken: string }>(response).reauthToken;
  }

  it.each<Provider>(['apple', 'google'])(
    'creates and then reuses a %s account with the established session shape',
    async (provider) => {
      const first = await signIn(provider);
      expect(first.isNewUser).toBe(true);
      expect(first.expiresIn).toBe(900);
      expect(first.refreshToken).toEqual(expect.any(String));
      const second = await signIn(provider, first.sub);
      expect(second.isNewUser).toBe(false);
      expect(second.user.id).toBe(first.user.id);
      expect(second.refreshToken).not.toBe(first.refreshToken);
      const response = await http()
        .get(`${prefix}/me/sign-in-methods`)
        .auth(second.accessToken, { type: 'bearer' })
        .expect(200);
      expect(data<Methods[]>(response)).toEqual([
        {
          provider: provider.toUpperCase(),
          linkedAt: expect.any(String) as string,
          maskedHint: null,
        },
      ]);
      expect(
        await prisma.userSession.count({
          where: { userId: first.user.id, deletedAt: null },
        }),
      ).toBe(2);
    },
  );

  it.each<Provider>(['apple', 'google'])(
    'rejects invalid %s signature, audience, issuer and expiration without creating identities',
    async (provider) => {
      const sub = subject();
      const now = Math.floor(Date.now() / 1000);
      for (const token of [
        await jwt(provider, sub, {}, true),
        await jwt(provider, sub, { aud: 'wrong' }),
        await jwt(provider, sub, { iss: 'https://wrong.test' }),
        await jwt(provider, sub, { iat: now - 600, exp: now - 1 }),
      ]) {
        const response = await http()
          .post(`${prefix}/auth/${provider}`)
          .send(body(provider, token))
          .expect(401);
        expect(code(response)).toBe('AUTH_IDENTITY_INVALID');
      }
      expect(
        await prisma.authIdentity.count({ where: { providerUid: sub } }),
      ).toBe(0);
    },
  );

  it('compares Apple nonce to SHA-256 of the supplied raw value', async () => {
    const sub = subject(),
      nonce = randomUUID();
    const token = await jwt('apple', sub, {
      nonce: createHash('sha256').update(nonce).digest('hex'),
    });
    const invalid = await http()
      .post(`${prefix}/auth/apple`)
      .send({ identityToken: token, nonce: 'wrong' })
      .expect(401);
    expect(code(invalid)).toBe('AUTH_IDENTITY_INVALID');
    const response = await http()
      .post(`${prefix}/auth/apple`)
      .send({ identityToken: token, nonce, fullName: 'Social integration' })
      .expect(200);
    users.add(data<Tokens>(response).user.id);
    expect(data<Tokens>(response).user.displayName).toBe('Social integration');
  });

  it('stores only verified email and never merges separate subjects with the same email', async () => {
    const email = `${randomUUID()}@social.test`;
    const apple = await signIn('apple', subject(), {
      email,
      email_verified: 'true',
    });
    const google = await signIn('google', subject(), {
      email,
      email_verified: true,
    });
    const unverified = await signIn('google', subject(), {
      email,
      email_verified: false,
    });
    expect(
      new Set([apple.user.id, google.user.id, unverified.user.id]).size,
    ).toBe(3);
    const rows = await prisma.authIdentity.findMany({
      where: {
        userId: { in: [apple.user.id, google.user.id, unverified.user.id] },
      },
    });
    expect(rows.find((row) => row.userId === apple.user.id)?.email).toBe(email);
    expect(rows.find((row) => row.userId === google.user.id)?.email).toBe(
      email,
    );
    expect(
      rows.find((row) => row.userId === unverified.user.id)?.email,
    ).toBeNull();
    const response = await http()
      .get(`${prefix}/me/sign-in-methods`)
      .auth(apple.accessToken, { type: 'bearer' })
      .expect(200);
    expect(data<Methods[]>(response)[0]?.maskedHint).toBe(
      `${email[0]}***@social.test`,
    );
  });

  it('requires reauth, links/unlinks, restores own soft-deleted identity and rejects conflicts and final-method removal', async () => {
    const who = await signIn('apple'),
      other = await signIn('google');
    const reauthToken = await proof(who);
    const ownGoogle = await jwt('google', subject());
    const link = (token: string, reauth = reauthToken) =>
      http()
        .post(`${prefix}/me/identities/google`)
        .auth(who.accessToken, { type: 'bearer' })
        .send({ idToken: token, reauthToken: reauth });
    expect(code(await link(ownGoogle, who.accessToken).expect(401))).toBe(
      'REAUTH_REQUIRED',
    );
    expect(code(await link(other.token).expect(409))).toBe('IDENTITY_IN_USE');
    await link(ownGoogle).expect(204);
    const methods = data<Methods[]>(
      await http()
        .get(`${prefix}/me/sign-in-methods`)
        .auth(who.accessToken, { type: 'bearer' })
        .expect(200),
    );
    expect(methods.map((row) => row.provider).sort()).toEqual([
      'APPLE',
      'GOOGLE',
    ]);
    await http()
      .delete(`${prefix}/me/identities/google`)
      .auth(who.accessToken, { type: 'bearer' })
      .send({ reauthToken })
      .expect(204);
    expect(
      code(
        await http()
          .delete(`${prefix}/me/identities/apple`)
          .auth(who.accessToken, { type: 'bearer' })
          .send({ reauthToken })
          .expect(409),
      ),
    ).toBe('LAST_SIGN_IN_METHOD');
    expect(
      code(
        await http()
          .post(`${prefix}/auth/google`)
          .send({ idToken: ownGoogle })
          .expect(403),
      ),
    ).toBe('AUTH_ACCOUNT_UNAVAILABLE');
    await link(ownGoogle).expect(204);
    expect(
      await prisma.authIdentity.count({
        where: { userId: who.user.id, deletedAt: null },
      }),
    ).toBe(2);
  });

  it('cannot use another identity or session to obtain or reuse reauth proof', async () => {
    const who = await signIn('apple'),
      other = await signIn('apple');
    expect(
      code(
        await http()
          .post(`${prefix}/auth/reauth/apple`)
          .auth(who.accessToken, { type: 'bearer' })
          .send({ identityToken: other.token })
          .expect(401),
      ),
    ).toBe('REAUTH_IDENTITY_REQUIRED');
    const otherProof = await proof(other);
    expect(
      code(
        await http()
          .post(`${prefix}/me/identities/google`)
          .auth(who.accessToken, { type: 'bearer' })
          .send({
            idToken: await jwt('google', subject()),
            reauthToken: otherProof,
          })
          .expect(401),
      ),
    ).toBe('REAUTH_REQUIRED');
  });

  it('serializes concurrent unlink requests and keeps one active sign-in method', async () => {
    const who = await signIn('apple'),
      reauthToken = await proof(who);
    await http()
      .post(`${prefix}/me/identities/google`)
      .auth(who.accessToken, { type: 'bearer' })
      .send({ idToken: await jwt('google', subject()), reauthToken })
      .expect(204);
    const responses = await Promise.all(
      (['apple', 'google'] as const).map((provider) =>
        http()
          .delete(`${prefix}/me/identities/${provider}`)
          .auth(who.accessToken, { type: 'bearer' })
          .send({ reauthToken }),
      ),
    );
    expect(responses.map((response) => response.status).sort()).toEqual([
      204, 409,
    ]);
    expect(code(responses.find((response) => response.status === 409)!)).toBe(
      'LAST_SIGN_IN_METHOD',
    );
    expect(
      await prisma.authIdentity.count({
        where: { userId: who.user.id, deletedAt: null },
      }),
    ).toBe(1);
  });
  it('rotates social refresh tokens through the existing refresh endpoint and revokes reuse', async () => {
    const who = await signIn('google');
    const result = data<Tokens>(
      await http()
        .post(`${prefix}/auth/refresh`)
        .send({ refreshToken: who.refreshToken })
        .expect(200),
    );
    expect(result.user.id).toBe(who.user.id);
    expect(result.isNewUser).toBe(false);
    expect(result.refreshToken).not.toBe(who.refreshToken);
    await http()
      .get(`${prefix}/me/sign-in-methods`)
      .auth(result.accessToken, { type: 'bearer' })
      .expect(200);
    expect(
      code(
        await http()
          .post(`${prefix}/auth/refresh`)
          .send({ refreshToken: who.refreshToken })
          .expect(401),
      ),
    ).toBe('AUTH_SESSION_REVOKED');
    await http()
      .get(`${prefix}/me/sign-in-methods`)
      .auth(result.accessToken, { type: 'bearer' })
      .expect(401);
  });

  it('returns stable unavailable error when provider configuration is absent', async () => {
    const config = app.get(ConfigService);
    const original = config.get<string>('AUTH_GOOGLE_CLIENT_ID');
    config.set('AUTH_GOOGLE_CLIENT_ID', '');
    try {
      expect(
        code(
          await http()
            .post(`${prefix}/auth/google`)
            .send({ idToken: await jwt('google', subject()) })
            .expect(503),
        ),
      ).toBe('AUTH_PROVIDER_UNAVAILABLE');
    } finally {
      config.set('AUTH_GOOGLE_CLIENT_ID', original);
    }
  });

  it('serializes concurrent first sign-ins and rejects unavailable accounts', async () => {
    const sub = subject(),
      token = await jwt('google', sub);
    const responses = await Promise.all([
      http().post(`${prefix}/auth/google`).send({ idToken: token }),
      http().post(`${prefix}/auth/google`).send({ idToken: token }),
    ]);
    expect(responses.map((response) => response.status)).toEqual([200, 200]);
    const results = responses.map((response) => data<Tokens>(response));
    users.add(results[0]!.user.id);
    expect(new Set(results.map((result) => result.user.id)).size).toBe(1);
    expect(results.filter((result) => result.isNewUser)).toHaveLength(1);
    await prisma.user.update({
      where: { id: results[0]!.user.id },
      data: { deletedAt: new Date() },
    });
    expect(
      code(
        await http()
          .post(`${prefix}/auth/google`)
          .send({ idToken: token })
          .expect(403),
      ),
    ).toBe('AUTH_ACCOUNT_UNAVAILABLE');
  });
});
