import { AccountSecurityController } from '../../src/controllers/account-security.controller';
import { AccountSecurityService } from '../../src/services/account-security.service';
import { AccountSecurityRepository } from '../../src/repositories/account-security.repository';
import { ACCOUNT_SECURITY_SERVICE } from '../../src/interfaces/services/account-security-service.interface';
import { ACCOUNT_SECURITY_REPOSITORY } from '../../src/interfaces/repositories/account-security-repository.interface';
import { exportPKCS8 } from 'jose';
import { existsSync, readFileSync } from 'node:fs';
import { parse } from 'dotenv';
import { ReauthController } from '../../src/controllers/reauth.controller';
import { AuthController } from '../../src/controllers/auth.controller';
import { ReauthService } from '../../src/services/reauth.service';
import { AuthSessionService } from '../../src/services/auth-session.service';
import { AuthSessionRepository } from '../../src/repositories/auth-session.repository';
import { AuthTokenService } from '../../src/services/auth-token.service';
import { OtpSenderService } from '../../src/services/otp-sender.service';
import { MailService } from '../../src/services/mail.service';
import { CacheRepository } from '../../src/repositories/cache.repository';
import { ValkeyConnection } from '../../src/database/valkey.connection';
import { REAUTH_SERVICE } from '../../src/interfaces/services/reauth-service.interface';
import { AUTH_SESSION_SERVICE } from '../../src/interfaces/services/auth-session-service.interface';
import { AUTH_SESSION_REPOSITORY } from '../../src/interfaces/repositories/auth-session-repository.interface';
import { AUTH_TOKEN_SERVICE } from '../../src/interfaces/services/auth-token-service.interface';
import { OTP_SENDER_SERVICE } from '../../src/interfaces/services/otp-sender-service.interface';
import { MAIL_SERVICE } from '../../src/interfaces/services/mail-service.interface';
import { CACHE_REPOSITORY } from '../../src/interfaces/repositories/cache-repository.interface';
import type { OtpMessage } from '../../src/interfaces/services/otp-sender-service.interface';
import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { generateKeyPair, exportSPKI, SignJWT } from 'jose';
import request from 'supertest';
import { LoggerModule } from 'nestjs-pino';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Account security API (focused module + PostgreSQL + Valkey + SMTP)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  let sender: OtpSenderService;
  const delivered: OtpMessage[] = [];
  const prefix = '/api/v1/me';
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    keys = await generateKeyPair('ES256', { extractable: true });
    const fileValues = existsSync('.env') ? parse(readFileSync('.env')) : {};
    config = new ConfigService({
      ...validateEnvironment({
        ...fileValues,
        ...process.env,
        REDIS_URL: process.env.TEST_REDIS_URL ?? fileValues.REDIS_URL,
        SMTP_HOST: process.env.TEST_SMTP_HOST ?? '127.0.0.1',
        AUTH_OTP_DELIVERY: 'mail',
        AUTH_OTP_MAIL_TO: 'reauth-test@test.local',
        AUTH_SECRET_PEPPER: `test-${randomUUID()}`,
      }),
      AUTH_JWT_PRIVATE_KEY: await exportPKCS8(keys.privateKey),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [
        AccountSecurityController,
        ReauthController,
        AuthController,
      ],
      providers: [
        PrismaService,
        ValkeyConnection,
        { provide: REAUTH_SERVICE, useClass: ReauthService },
        { provide: AUTH_SESSION_SERVICE, useClass: AuthSessionService },
        { provide: AUTH_SESSION_REPOSITORY, useClass: AuthSessionRepository },
        { provide: AUTH_TOKEN_SERVICE, useClass: AuthTokenService },
        { provide: OTP_SENDER_SERVICE, useClass: OtpSenderService },
        { provide: MAIL_SERVICE, useClass: MailService },
        { provide: CACHE_REPOSITORY, useClass: CacheRepository },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: ACCOUNT_SECURITY_SERVICE, useClass: AccountSecurityService },
        {
          provide: ACCOUNT_SECURITY_REPOSITORY,
          useClass: AccountSecurityRepository,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
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
    sender = module.get(OTP_SENDER_SERVICE);
    const send = sender.send.bind(sender);
    jest.spyOn(sender, 'send').mockImplementation(async (message) => {
      delivered.push(message);
      return send(message);
    });
  });
  afterAll(async () => {
    await app?.close();
  });

  async function token(
    userId: string,
    sessionId: string,
    version = 1,
    reauth = false,
  ) {
    return new SignJWT({
      sid: sessionId,
      ver: version,
      ...(reauth ? { scope: 'reauth' } : {}),
    })
      .setProtectedHeader({
        alg: 'ES256',
        typ: reauth ? 'reauth+jwt' : 'at+jwt',
      })
      .setSubject(userId)
      .setIssuer(config.get<string>('AUTH_JWT_ISSUER')!)
      .setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!)
      .setIssuedAt()
      .setExpirationTime('5m')
      .sign(keys.privateKey);
  }
  async function actor() {
    const userId = randomUUID(),
      sessionId = randomUUID();
    await prisma.user.create({
      data: { id: userId, displayName: 'Security test' },
    });
    await prisma.userSession.create({
      data: {
        id: sessionId,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: new Date(Date.now() + 86400000),
        absoluteExpiresAt: new Date(Date.now() + 86400000),
      },
    });
    return {
      userId,
      sessionId,
      bearer: `Bearer ${await token(userId, sessionId)}`,
      reauthToken: await token(userId, sessionId, 1, true),
    };
  }
  async function phoneActor() {
    const who = await actor();
    const phone = `+849${Math.floor(Math.random() * 90000000 + 10000000)}`;
    await prisma.authIdentity.create({
      data: { userId: who.userId, provider: 'PHONE', providerUid: phone },
    });
    const tokens = app.get<AuthTokenService>(AUTH_TOKEN_SERVICE);
    const phoneKey = tokens.keyedHash('phone', phone).toString('hex');
    return { ...who, phone, phoneKey };
  }
  const http = () => request(app.getHttpServer());
  const newPhone = () =>
    `+849${Math.floor(Math.random() * 90000000 + 10000000)}`;
  const auth = (who: { bearer: string }) => ({ Authorization: who.bearer });
  const otp = (
    who: { bearer: string; reauthToken: string },
    phone: string,
    reauthToken = who.reauthToken,
  ) =>
    http()
      .post(`${prefix}/phone/otp`)
      .set(auth(who))
      .send({ phone, reauthToken });
  const verify = (who: { bearer: string }, phone: string, code: string) =>
    http().post(`${prefix}/phone/verify`).set(auth(who)).send({ phone, code });
  async function extraSession(userId: string) {
    const secret = app
      .get<AuthTokenService>(AUTH_TOKEN_SERVICE)
      .newRefreshToken();
    const row = await prisma.userSession.create({
      data: {
        userId,
        refreshTokenHash: new Uint8Array(secret.hash),
        expiresAt: new Date(Date.now() + 86400000),
        absoluteExpiresAt: new Date(Date.now() + 86400000),
      },
    });
    return {
      ...row,
      refreshToken: secret.value,
      bearer: `Bearer ${await token(userId, row.id)}`,
    };
  }
  it('lists only own live sessions, newest first, safe device projection and current flag', async () => {
    const who = await phoneActor();
    const other = await actor();
    const device = await prisma.userDevice.create({
      data: {
        userId: who.userId,
        platform: 'ANDROID',
        deviceModel: 'Test device',
        appVersion: '2.0',
      },
    });
    await prisma.userSession.update({
      where: { id: who.sessionId },
      data: { deviceId: device.id, lastUsedAt: new Date(Date.now() - 10000) },
    });
    const second = await extraSession(who.userId);
    await prisma.userSession.createMany({
      data: [
        {
          userId: who.userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() - 1000),
          absoluteExpiresAt: new Date(Date.now() + 86400000),
        },
        {
          userId: who.userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + 86400000),
          absoluteExpiresAt: new Date(Date.now() + 86400000),
          revokedAt: new Date(),
        },
        {
          userId: who.userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + 86400000),
          absoluteExpiresAt: new Date(Date.now() + 86400000),
          deletedAt: new Date(),
        },
      ],
    });
    const result = data<{
      items: Array<{
        id: string;
        current: boolean;
        deviceModel: string | null;
      }>;
    }>(await http().get(`${prefix}/sessions`).set(auth(who)).expect(200));
    expect(result.items.map((x) => x.id)).toEqual([second.id, who.sessionId]);
    expect(result.items).toContainEqual(
      expect.objectContaining({
        id: who.sessionId,
        current: true,
        deviceModel: 'Test device',
        platform: 'ANDROID',
      }),
    );
    expect(result.items[0]!.current).toBe(false);
    expect(JSON.stringify(result)).not.toMatch(
      /refreshTokenHash|ipCreated|pushToken/,
    );
    expect(result.items.map((x) => x.id)).not.toContain(other.sessionId);
  });
  it('returns 404 for another user session; revoke blocks refresh and access, allows current logout', async () => {
    const who = await phoneActor(),
      stranger = await actor(),
      second = await extraSession(who.userId);
    await http()
      .delete(`${prefix}/sessions/${stranger.sessionId}`)
      .set(auth(who))
      .expect(404);
    await http()
      .delete(`${prefix}/sessions/${second.id}`)
      .set(auth(who))
      .expect(204);
    await http()
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: second.refreshToken })
      .expect(401);
    await http().get(`${prefix}/sessions`).set(auth(second)).expect(401);
    await http()
      .delete(`${prefix}/sessions/${who.sessionId}`)
      .set(auth(who))
      .expect(204);
    await http().get(`${prefix}/sessions`).set(auth(who)).expect(401);
  });
  it('revoke others keeps current usable, revokes others access and refresh', async () => {
    const who = await phoneActor(),
      second = await extraSession(who.userId);
    const result = data<{ revokedCount: number }>(
      await http()
        .post(`${prefix}/sessions/revoke-others`)
        .set(auth(who))
        .send({})
        .expect(200),
    );
    expect(result.revokedCount).toBe(1);
    await http().get(`${prefix}/sessions`).set(auth(who)).expect(200);
    await http().get(`${prefix}/sessions`).set(auth(second)).expect(401);
    await http()
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: second.refreshToken })
      .expect(401);
  });
  it('requires fresh session-bound reauth and sends only to the new phone', async () => {
    const who = await phoneActor(),
      phone = newPhone(),
      stranger = await actor();
    await otp(who, phone, who.bearer.slice(7)).expect(401);
    await otp(who, phone, stranger.reauthToken).expect(401);
    const expired = await new SignJWT({
      sid: who.sessionId,
      ver: 1,
      scope: 'reauth',
    })
      .setProtectedHeader({ alg: 'ES256', typ: 'reauth+jwt' })
      .setSubject(who.userId)
      .setIssuer(config.get<string>('AUTH_JWT_ISSUER')!)
      .setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!)
      .setIssuedAt(Math.floor(Date.now() / 1000) - 302)
      .setExpirationTime(Math.floor(Date.now() / 1000) - 2)
      .sign(keys.privateKey);
    await otp(who, phone, expired).expect(401);
    await otp(who, phone).expect(202);
    expect(delivered.at(-1)!.phoneE164).toBe(phone);
    expect(delivered.at(-1)!.phoneE164).not.toBe(who.phone);
  });
  it('rejects another account phone generically', async () => {
    const who = await phoneActor(),
      other = await phoneActor();
    const result = await otp(who, other.phone).expect(409);
    expect((result.body as { error: { code: string } }).error.code).toBe(
      'PHONE_ALREADY_USED',
    );
  });
  it('login OTP cannot change phone; change consumes proof once, preserves identities and revokes other sessions', async () => {
    const who = await phoneActor(),
      phone = newPhone(),
      second = await extraSession(who.userId);
    await prisma.authIdentity.create({
      data: {
        userId: who.userId,
        provider: 'GOOGLE',
        providerUid: randomUUID(),
      },
    });
    await http().post('/api/v1/auth/phone/otp').send({ phone }).expect(202);
    const loginCode = delivered.at(-1)!.code;
    await verify(who, phone, loginCode).expect(400);
    const cache = app.get<CacheRepository>(CACHE_REPOSITORY),
      tokens = app.get<AuthTokenService>(AUTH_TOKEN_SERVICE);
    await cache.delete(
      `otp:cool:${tokens.keyedHash('phone', phone).toString('hex')}`,
    );
    await otp(who, phone).expect(202);
    const code = delivered.at(-1)!.code;
    if (code !== loginCode) await verify(who, phone, loginCode).expect(400);
    const result = data<{ phone: string }>(
      await verify(who, phone, code).expect(200),
    );
    expect(result.phone).not.toBe(phone);
    expect(result.phone).toContain(phone.slice(-3));
    await verify(who, phone, code).expect(400);
    expect(
      await prisma.authIdentity.count({
        where: { userId: who.userId, provider: 'GOOGLE', deletedAt: null },
      }),
    ).toBe(1);
    expect(
      await prisma.authIdentity.count({
        where: {
          userId: who.userId,
          provider: 'PHONE',
          providerUid: phone,
          deletedAt: null,
        },
      }),
    ).toBe(1);
    expect(
      await prisma.authIdentity.count({
        where: {
          userId: who.userId,
          provider: 'PHONE',
          providerUid: who.phone,
          deletedAt: null,
        },
      }),
    ).toBe(0);
    await http().get(`${prefix}/sessions`).set(auth(who)).expect(200);
    await http().get(`${prefix}/sessions`).set(auth(second)).expect(401);
    await http()
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: second.refreshToken })
      .expect(401);
    // The old phone can register a fresh account, but cannot authenticate as this user.
    await http()
      .post('/api/v1/auth/phone/otp')
      .send({ phone: who.phone })
      .expect(202);
    const oldLogin = data<{ user: { id: string } }>(
      await http()
        .post('/api/v1/auth/phone/verify')
        .send({ phone: who.phone, code: delivered.at(-1)!.code })
        .expect(200),
    );
    expect(oldLogin.user.id).not.toBe(who.userId);
  });
  it('binds phone OTP to the requesting session and consumes it atomically', async () => {
    const who = await phoneActor(),
      phone = newPhone(),
      second = await extraSession(who.userId);
    await otp(who, phone).expect(202);
    const code = delivered.at(-1)!.code;
    await verify(second, phone, code).expect(400);
    const results = await Promise.all([
      verify(who, phone, code),
      verify(who, phone, code),
    ]);
    expect(results.map((result) => result.status).sort()).toEqual([200, 400]);
  });
  it('limits wrong attempts and shares resend throttling with login', async () => {
    const who = await phoneActor(),
      phone = newPhone();
    await otp(who, phone).expect(202);
    await otp(who, phone).expect(429);
    await http().post('/api/v1/auth/phone/otp').send({ phone }).expect(429);
    const code = delivered.at(-1)!.code,
      wrong = code === '000000' ? '000001' : '000000';
    for (let attempt = 0; attempt < 4; attempt++)
      await verify(who, phone, wrong).expect(400);
    await verify(who, phone, wrong).expect(429);
    await verify(who, phone, code).expect(429);
  });
  it('rechecks phone ownership at verification and preserves old identity on conflict', async () => {
    const who = await phoneActor(),
      phone = newPhone(),
      other = await actor();
    await otp(who, phone).expect(202);
    const code = delivered.at(-1)!.code;
    await prisma.authIdentity.create({
      data: { userId: other.userId, provider: 'PHONE', providerUid: phone },
    });
    const result = await verify(who, phone, code).expect(409);
    expect((result.body as { error: { code: string } }).error.code).toBe(
      'PHONE_ALREADY_USED',
    );
    expect(
      await prisma.authIdentity.count({
        where: {
          userId: who.userId,
          provider: 'PHONE',
          providerUid: who.phone,
          deletedAt: null,
        },
      }),
    ).toBe(1);
  });
});
