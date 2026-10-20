import { existsSync, readFileSync } from 'node:fs';
import { parse } from 'dotenv';
import { exportPKCS8, decodeJwt } from 'jose';
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
import { AccountDeletionController } from '../../src/controllers/account-deletion.controller';
import { AccountDeletionService } from '../../src/services/account-deletion.service';
import { AccountDeletionRepository } from '../../src/repositories/account-deletion.repository';
import { ACCOUNT_DELETION_SERVICE } from '../../src/interfaces/services/account-deletion-service.interface';
import { ACCOUNT_DELETION_REPOSITORY } from '../../src/interfaces/repositories/account-deletion-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Reauthentication API (focused module + PostgreSQL + Valkey + SMTP)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  let sender: OtpSenderService;
  const delivered: OtpMessage[] = [];
  const prefix = '/api/v1/me';
  const storageAvailable = true;
  const erased: string[] = [];
  const storage = {
    isConfigured: () => storageAvailable,
    bucketOf: () => 'media',
    listKeys: () => Promise.resolve([]),
    eraseObjectVersions: (object: { key: string }) => {
      erased.push(object.key);
      return Promise.resolve();
    },
  };

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
        AccountDeletionController,
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
        JobRunnerService,
        { provide: ConfigService, useValue: config },
        { provide: ACCOUNT_DELETION_SERVICE, useClass: AccountDeletionService },
        {
          provide: ACCOUNT_DELETION_REPOSITORY,
          useClass: AccountDeletionRepository,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        { provide: OBJECT_STORAGE_SERVICE, useValue: storage },
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
      data: { id: userId, displayName: 'Deletion test' },
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
  function submit(
    who: { bearer: string; reauthToken: string },
    extra: Record<string, unknown> = {},
  ) {
    return request(app.getHttpServer())
      .post(`${prefix}/deletion`)
      .set('Authorization', who.bearer)
      .send({
        familyChoice: 'NONE',
        sharedContentChoice: 'KEEP_ANONYMIZED',
        reauthToken: who.reauthToken,
        ...extra,
      });
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
  async function sendOtp(who: { bearer: string }) {
    await http()
      .post('/api/v1/auth/reauth/otp')
      .set('Authorization', who.bearer)
      .send({})
      .expect(202);
    return delivered.at(-1)!.code;
  }
  function verify(who: { bearer: string }, code: string) {
    return http()
      .post('/api/v1/auth/reauth/verify')
      .set('Authorization', who.bearer)
      .send({ code });
  }
  it('requires access authentication, a verified own phone and rejects caller-selected phones', async () => {
    await http().post('/api/v1/auth/reauth/otp').send({}).expect(401);
    const noPhone = await actor();
    await http()
      .post('/api/v1/auth/reauth/otp')
      .set('Authorization', noPhone.bearer)
      .send({})
      .expect(403);
    const who = await phoneActor();
    await http()
      .post('/api/v1/auth/reauth/otp')
      .set('Authorization', who.bearer)
      .send({ phone: '+84912345678' })
      .expect(400);
    await sendOtp(who);
    expect(delivered.at(-1)!.phoneE164).toBe(who.phone);
    expect(
      await prisma.userSession.count({ where: { userId: who.userId } }),
    ).toBe(1);
  });
  it('separates login and REAUTH codes in both directions', async () => {
    const who = await phoneActor();
    await http()
      .post('/api/v1/auth/phone/otp')
      .send({ phone: who.phone })
      .expect(202);
    const loginCode = delivered.at(-1)!.code;
    await verify(who, loginCode).expect(400);
    const cache = app.get<CacheRepository>(CACHE_REPOSITORY);
    await cache.delete(`otp:cool:${who.phoneKey}`);
    const reauthCode = await sendOtp(who);
    await verify(who, loginCode === reauthCode ? 'abcdef' : loginCode).expect(
      400,
    );
    // Remove the unrelated login challenge so numeric coincidence cannot make the test flaky.
    await cache.delete(`otp:${who.phoneKey}`);
    await http()
      .post('/api/v1/auth/phone/verify')
      .send({ phone: who.phone, code: reauthCode })
      .expect(400);
    await verify(who, reauthCode).expect(200);
  });
  it('binds proof to current session and version, rejects used OTP and reauth as access', async () => {
    const who = await phoneActor();
    const code = await sendOtp(who);
    const secondSession = await prisma.userSession.create({
      data: {
        userId: who.userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: new Date(Date.now() + 86400000),
        absoluteExpiresAt: new Date(Date.now() + 86400000),
      },
    });
    const other = {
      ...who,
      bearer: `Bearer ${await token(who.userId, secondSession.id)}`,
    };
    await verify(other, code).expect(400);
    const response = data<{ reauthToken: string; expiresAt: string }>(
      await verify(who, code).expect(200),
    );
    expect(decodeJwt(response.reauthToken)).toMatchObject({
      sub: who.userId,
      sid: who.sessionId,
      ver: 1,
      scope: 'reauth',
    });
    expect(new Date(response.expiresAt).getTime()).toBeGreaterThan(Date.now());
    await verify(who, code).expect(400);
    await http()
      .post('/api/v1/auth/reauth/otp')
      .set('Authorization', `Bearer ${response.reauthToken}`)
      .send({})
      .expect(401);
    await submit(other, { reauthToken: response.reauthToken }).expect(401);
    await submit(who, {
      reauthToken: await token(who.userId, who.sessionId, 2, true),
    }).expect(401);
    await prisma.user.update({
      where: { id: who.userId },
      data: { tokenVersion: { increment: 1 } },
    });
    await verify(who, code).expect(401);
  });
  it('rejects expired OTP and expired reauth JWT, retains rejection of access JWT as reauth', async () => {
    const who = await phoneActor();
    const code = await sendOtp(who);
    const redis = app.get(ValkeyConnection).client!;
    const key = `otp:REAUTH:v1:${who.phoneKey}:${who.userId}:${who.sessionId}:1`;
    await redis.pexpire(key, 1);
    await new Promise((resolve) => setTimeout(resolve, 10));
    await verify(who, code).expect(400);
    await submit(who, { reauthToken: who.bearer.slice(7) }).expect(401);
    const expired = await new SignJWT({
      sid: who.sessionId,
      ver: 1,
      scope: 'reauth',
    })
      .setProtectedHeader({ alg: 'ES256', typ: 'reauth+jwt' })
      .setSubject(who.userId)
      .setIssuer(config.get<string>('AUTH_JWT_ISSUER')!)
      .setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!)
      .setIssuedAt(Math.floor(Date.now() / 1000) - 301)
      .setExpirationTime(Math.floor(Date.now() / 1000) - 1)
      .sign(keys.privateKey);
    await submit(who, { reauthToken: expired }).expect(401);
  });
  it('consumes the OTP once under concurrent verification', async () => {
    const who = await phoneActor(),
      code = await sendOtp(who);
    const results = await Promise.all([verify(who, code), verify(who, code)]);
    expect(results.map((result) => result.status).sort()).toEqual([200, 400]);
  });

  it('uses existing OTP_INVALID and RATE_LIMITED lockout codes', async () => {
    const who = await phoneActor();
    const code = await sendOtp(who),
      wrong = code === '000000' ? '000001' : '000000';
    for (let attempt = 0; attempt < 4; attempt++) {
      const response = await verify(who, wrong).expect(400);
      expect((response.body as { error: { code: string } }).error.code).toBe(
        'OTP_INVALID',
      );
    }
    const response = await verify(who, wrong).expect(429);
    expect((response.body as { error: { code: string } }).error.code).toBe(
      'RATE_LIMITED',
    );
    await verify(who, code).expect(429);
  });
});
