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
import { JobLease } from '../../src/models/job-lease.model';
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
import { JOBS } from '../../src/config/jobs';

interface DeletionResponse {
  id: string;
  status: string;
  executeAfter: string;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Account deletion API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let service: AccountDeletionService;
  let repository: AccountDeletionRepository;
  let runner: JobRunnerService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  let sender: OtpSenderService;
  const delivered: OtpMessage[] = [];
  const prefix = '/api/v1/me';
  let storageAvailable = true;
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
    service = module.get(ACCOUNT_DELETION_SERVICE);
    repository = module.get(ACCOUNT_DELETION_REPOSITORY);
    runner = module.get(JobRunnerService);
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
  async function recoveryToken(userId: string, version: number) {
    const session = await prisma.userSession.create({
      data: {
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: new Date(Date.now() + 86400000),
        absoluteExpiresAt: new Date(Date.now() + 86400000),
      },
    });
    return token(userId, session.id, version, true);
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

  it('uses OTP → issued reauthToken → deletion 202, then signs in during grace to reauth and cancel', async () => {
    const who = await actor();
    const phone = `+849${Math.floor(Math.random() * 90000000 + 10000000)}`;
    await prisma.authIdentity.create({
      data: { userId: who.userId, provider: 'PHONE', providerUid: phone },
    });
    const http = () => request(app.getHttpServer());
    await http()
      .post('/api/v1/auth/reauth/otp')
      .set('Authorization', who.bearer)
      .send({})
      .expect(202);
    const code = delivered.at(-1)!.code;
    expect(delivered.at(-1)!.phoneE164).toBe(phone);
    const verified = data<{ reauthToken: string }>(
      await http()
        .post('/api/v1/auth/reauth/verify')
        .set('Authorization', who.bearer)
        .send({ code })
        .expect(200),
    );
    expect(decodeJwt(verified.reauthToken)).toMatchObject({
      sub: who.userId,
      sid: who.sessionId,
      ver: 1,
      scope: 'reauth',
    });
    await submit({ ...who, reauthToken: verified.reauthToken }).expect(202);
    // Clear only this fixture's resend cooldown, avoiding a 60-second test delay.
    const tokens = app.get<AuthTokenService>(AUTH_TOKEN_SERVICE);
    const cache = app.get<CacheRepository>(CACHE_REPOSITORY);
    const phoneKey = tokens.keyedHash('phone', phone).toString('hex');
    await cache.delete(`otp:cool:${phoneKey}`);
    await http().post('/api/v1/auth/phone/otp').send({ phone }).expect(202);
    const login = data<{ accessToken: string }>(
      await http()
        .post('/api/v1/auth/phone/verify')
        .send({ phone, code: delivered.at(-1)!.code })
        .expect(200),
    );
    await cache.delete(`otp:cool:${phoneKey}`);
    await http()
      .post('/api/v1/auth/reauth/otp')
      .set('Authorization', `Bearer ${login.accessToken}`)
      .send({})
      .expect(202);
    const fresh = data<{ reauthToken: string }>(
      await http()
        .post('/api/v1/auth/reauth/verify')
        .set('Authorization', `Bearer ${login.accessToken}`)
        .send({ code: delivered.at(-1)!.code })
        .expect(200),
    );
    expect(decodeJwt(fresh.reauthToken).ver).toBe(2);
    const cancelled = data<DeletionResponse>(
      await http()
        .post(`${prefix}/deletion/cancel`)
        .send({ reauthToken: fresh.reauthToken })
        .expect(200),
    );
    expect(cancelled.status).toBe('CANCELLED');
  });

  it('requires a verified session for preview', async () => {
    await request(app.getHttpServer())
      .get(`${prefix}/deletion-preview`)
      .expect(401);
  });
  it('allows deletion preview without entitlement and explains retention', async () => {
    const who = await actor();
    const response = await request(app.getHttpServer())
      .get(`${prefix}/deletion-preview`)
      .set('Authorization', who.bearer)
      .expect(200);
    expect(
      data<{ graceDays: number; familyChoices: string[] }>(response),
    ).toMatchObject({ graceDays: 30, familyChoices: ['NONE'] });
  });
  it('rejects regular access JWT as reauthentication', async () => {
    const who = await actor();
    await submit(who, { reauthToken: who.bearer.slice(7) }).expect(401);
    expect(
      await prisma.deletionRequest.count({ where: { userId: who.userId } }),
    ).toBe(0);
  });
  it('rejects reauth for another actor and unknown body fields', async () => {
    const who = await actor(),
      other = await actor();
    await submit(who, { reauthToken: other.reauthToken }).expect(401);
    await submit(who, { userId: other.userId }).expect(400);
  });
  it('schedules 30 days, revokes sessions immediately, and restores only with fresh pending version', async () => {
    const who = await actor();
    const start = Date.now();
    const scheduled = data<DeletionResponse>(await submit(who).expect(202));
    expect(new Date(scheduled.executeAfter).getTime()).toBeGreaterThanOrEqual(
      start + 30 * 86400000,
    );
    expect(
      await prisma.user.findUniqueOrThrow({ where: { id: who.userId } }),
    ).toMatchObject({ status: 'DELETION_PENDING', tokenVersion: 2 });
    expect(
      (
        await prisma.userSession.findUniqueOrThrow({
          where: { id: who.sessionId },
        })
      ).revokedAt,
    ).not.toBeNull();
    await request(app.getHttpServer())
      .get(`${prefix}/deletion-preview`)
      .set('Authorization', who.bearer)
      .expect(401);
    await request(app.getHttpServer())
      .post(`${prefix}/deletion/cancel`)
      .send({ reauthToken: who.reauthToken })
      .expect(401);
    const reauth = await recoveryToken(who.userId, 2);
    const restored = data<DeletionResponse>(
      await request(app.getHttpServer())
        .post(`${prefix}/deletion/cancel`)
        .send({ reauthToken: reauth })
        .expect(200),
    );
    expect(restored.status).toBe('CANCELLED');
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: who.userId } }))
        .status,
    ).toBe('ACTIVE');
    expect(
      (
        await prisma.userSession.findUniqueOrThrow({
          where: { id: who.sessionId },
        })
      ).revokedAt,
    ).not.toBeNull();
  });
  it('rejects cancellation proof from a revoked recovery session', async () => {
    const who = await actor();
    await submit(who).expect(202);
    const proof = await recoveryToken(who.userId, 2);
    const sid = decodeJwt(proof).sid as string;
    await prisma.userSession.update({
      where: { id: sid },
      data: { revokedAt: new Date() },
    });
    await request(app.getHttpServer())
      .post(`${prefix}/deletion/cancel`)
      .send({ reauthToken: proof })
      .expect(401);
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: who.userId } }))
        .status,
    ).toBe('DELETION_PENDING');
  });

  it('requires the sole Parent to select family deletion', async () => {
    const who = await actor();
    const family = await prisma.family.create({
      data: { name: 'Sole parent', createdBy: who.userId },
    });
    await prisma.familyParent.create({
      data: {
        familyId: family.id,
        userId: who.userId,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await submit(who).expect(422);
    const scheduled = data<DeletionResponse>(
      await submit(who, { familyChoice: 'DELETE_FAMILY' }).expect(202),
    );
    await prisma.deletionRequest.update({
      where: { id: scheduled.id },
      data: { executeAfter: new Date(Date.now() - 1000) },
    });
    await runner.execute(
      JOBS.deletionExecutor,
      {
        scopeKey: scheduled.id,
        scheduledFor: new Date(),
        idempotencyKey: `deletion-test:${scheduled.id}`,
      },
      (context) => service.executeDue(new Date(), context),
    );
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: family.id } }))
        .status,
    ).toBe('DELETED');
  });
  it.each(['KEEP_ANONYMIZED', 'DELETE'] as const)(
    'keeps partner content and purges the deleted owner journal with %s',
    async (choice) => {
      const who = await actor(),
        partner = await actor();
      const family = await prisma.family.create({
        data: {
          name: 'Partner retained',
          createdBy: who.userId,
          status: 'ACTIVE',
        },
      });
      await prisma.familyParent.create({
        data: {
          familyId: family.id,
          userId: who.userId,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
      });
      await prisma.familyParent.create({
        data: {
          familyId: family.id,
          userId: partner.userId,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      });
      const ownJournal = await prisma.journalEntry.create({
        data: {
          familyId: family.id,
          userId: who.userId,
          bodyEnc: Buffer.from('private owner ciphertext'),
        },
      });
      const partnerJournal = await prisma.journalEntry.create({
        data: {
          familyId: family.id,
          userId: partner.userId,
          bodyEnc: Buffer.from('partner ciphertext'),
        },
      });
      const memory = await prisma.memory.create({
        data: {
          familyId: family.id,
          authorUserId: who.userId,
          authorRole: 'PARENT',
          status: 'PUBLISHED',
          body: 'Shared memory',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          visibility: 'PARENTS',
        },
      });
      const draft = await prisma.memory.create({
        data: {
          familyId: family.id,
          authorUserId: who.userId,
          authorRole: 'PARENT',
          status: 'DRAFT',
          body: 'Private unpublished draft',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          visibility: 'PARENTS',
        },
      });
      const partnerComment = await prisma.comment.create({
        data: {
          familyId: family.id,
          memoryId: memory.id,
          authorUserId: partner.userId,
          body: 'Partner comment remains',
        },
      });
      const partnerPerspective = await prisma.memoryPerspective.create({
        data: {
          familyId: family.id,
          memoryId: memory.id,
          authorUserId: partner.userId,
          body: 'Partner perspective remains',
        },
      });
      const heart = await prisma.heartLedger.create({
        data: {
          familyId: family.id,
          userId: who.userId,
          sourceType: 'MEMORY',
          sourceId: memory.id,
          reason: 'MEMORY_CREATED',
          amount: 1,
          localDate: new Date(),
        },
      });
      const preview = data<{ familyAfterDeletion: string }>(
        await request(app.getHttpServer())
          .get(`${prefix}/deletion-preview`)
          .set('Authorization', who.bearer)
          .expect(200),
      );
      expect(preview.familyAfterDeletion).toBe('PARTNER_LEFT');
      const scheduled = data<DeletionResponse>(
        await submit(who, {
          familyChoice: 'PARTNER_CONTINUES',
          sharedContentChoice: choice,
        }).expect(202),
      );
      await prisma.deletionRequest.update({
        where: { id: scheduled.id },
        data: { executeAfter: new Date(Date.now() - 1000) },
      });
      await runner.execute(
        JOBS.deletionExecutor,
        {
          scopeKey: scheduled.id,
          scheduledFor: new Date(),
          idempotencyKey: `deletion-test:${scheduled.id}`,
        },
        (context) => service.executeDue(new Date(), context),
      );
      expect(
        (await prisma.family.findUniqueOrThrow({ where: { id: family.id } }))
          .status,
      ).toBe('PARTNER_LEFT');
      expect(
        await prisma.journalEntry.findUnique({ where: { id: ownJournal.id } }),
      ).toBeNull();
      expect(
        await prisma.journalEntry.findUnique({
          where: { id: partnerJournal.id },
        }),
      ).not.toBeNull();
      expect(
        await prisma.memory.findUniqueOrThrow({ where: { id: memory.id } }),
      ).toMatchObject({
        body: choice === 'DELETE' ? null : 'Shared memory',
        status: choice === 'DELETE' ? 'PURGED' : 'PUBLISHED',
      });
      expect(
        await prisma.memory.findUniqueOrThrow({ where: { id: draft.id } }),
      ).toMatchObject({ body: null, status: 'PURGED' });
      expect(
        await prisma.comment.findUniqueOrThrow({
          where: { id: partnerComment.id },
        }),
      ).toMatchObject({ body: 'Partner comment remains', deletedAt: null });
      expect(
        await prisma.memoryPerspective.findUniqueOrThrow({
          where: { id: partnerPerspective.id },
        }),
      ).toMatchObject({ body: 'Partner perspective remains', deletedAt: null });
      expect(
        await prisma.heartLedger.findUniqueOrThrow({ where: { id: heart.id } }),
      ).toMatchObject({ amount: 1, deletedAt: null });
      expect(
        (await prisma.user.findUniqueOrThrow({ where: { id: partner.userId } }))
          .status,
      ).toBe('ACTIVE');
    },
  );

  it('refuses cancellation once grace has elapsed', async () => {
    const who = await actor();
    const scheduled = data<DeletionResponse>(await submit(who).expect(202));
    await prisma.deletionRequest.update({
      where: { id: scheduled.id },
      data: { executeAfter: new Date(Date.now() - 1000) },
    });
    await request(app.getHttpServer())
      .post(`${prefix}/deletion/cancel`)
      .send({ reauthToken: await recoveryToken(who.userId, 2) })
      .expect(401);
    await expect(
      repository.cancel(who.userId, 2, new Date()),
    ).rejects.toMatchObject({ code: 'DELETION_CANNOT_CANCEL' });
    // Restore future due time so this fixture does not enter another test's executor batch.
    await prisma.deletionRequest.update({
      where: { id: scheduled.id },
      data: { executeAfter: new Date(Date.now() + 86400000) },
    });
  });

  it('records a storage failure and resumes without restoring purged private data or skipping identity', async () => {
    const who = await actor();
    const exportKey = `user/${who.userId}/exports/previous.json`;
    await prisma.exportJob.create({
      data: {
        requesterId: who.userId,
        scope: 'PERSONAL',
        status: 'COMPLETED',
        storageKey: exportKey,
        expiresAt: new Date(Date.now() + 86400000),
      },
    });
    const scheduled = data<DeletionResponse>(await submit(who).expect(202));
    await prisma.deletionRequest.update({
      where: { id: scheduled.id },
      data: { executeAfter: new Date(Date.now() - 1000) },
    });
    storageAvailable = false;
    try {
      await expect(
        runner.execute(
          JOBS.deletionExecutor,
          {
            scopeKey: scheduled.id,
            scheduledFor: new Date(),
            idempotencyKey: `deletion-fail:${scheduled.id}`,
          },
          (context) => service.executeDue(new Date(), context),
        ),
      ).rejects.toThrow('Storage is unavailable.');
      expect(
        (await prisma.user.findUniqueOrThrow({ where: { id: who.userId } }))
          .status,
      ).toBe('DELETION_PENDING');
      const failed = await prisma.deletionRequest.findUniqueOrThrow({
        where: { id: scheduled.id },
      });
      expect(failed.failureCode).toBe('DELETION_STORAGE_UNAVAILABLE');
      expect(failed.steps).not.toHaveProperty('IDENTITY');
    } finally {
      storageAvailable = true;
    }
    await runner.execute(
      JOBS.deletionExecutor,
      {
        scopeKey: scheduled.id,
        scheduledFor: new Date(),
        idempotencyKey: `deletion-resume:${scheduled.id}`,
      },
      (context) => service.executeDue(new Date(), context),
    );
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: who.userId } }))
        .status,
    ).toBe('DELETED');
    expect(erased).toContain(exportKey);
    expect(
      (
        await prisma.deletionRequest.findUniqueOrThrow({
          where: { id: scheduled.id },
        })
      ).status,
    ).toBe('COMPLETED');
    expect(
      (
        await prisma.exportJob.findFirstOrThrow({
          where: { requesterId: who.userId },
        })
      ).storageKey,
    ).toBeNull();
  });

  it('rejects an unowned executor lease before changing steps', async () => {
    const who = await actor();
    const scheduled = data<DeletionResponse>(await submit(who).expect(202));
    const lease = new JobLease(randomUUID(), 1, 1n, 3, 'stale-worker');
    await expect(
      repository.completeStep(scheduled.id, 'PRIVATE_DATA', new Date(), lease),
    ).rejects.toMatchObject({ code: 'JOB_LEASE_LOST' });
    const row = await prisma.deletionRequest.findUniqueOrThrow({
      where: { id: scheduled.id },
    });
    expect(row.status).toBe('SCHEDULED');
    expect(row.steps).not.toHaveProperty('PRIVATE_DATA');
  });

  it('executes due requests with durable runs and steps, safely replaying a completed run', async () => {
    const who = await actor();
    const scheduled = data<DeletionResponse>(await submit(who).expect(202));
    await prisma.deletionRequest.update({
      where: { id: scheduled.id },
      data: { executeAfter: new Date(Date.now() - 1000) },
    });
    const run = {
      scopeKey: scheduled.id,
      scheduledFor: new Date(),
      idempotencyKey: `deletion-test:${scheduled.id}`,
    };
    expect(
      await runner.execute(JOBS.deletionExecutor, run, (context) =>
        service.executeDue(new Date(), context),
      ),
    ).toBe('SUCCEEDED');
    const deleted = await prisma.user.findUniqueOrThrow({
      where: { id: who.userId },
    });
    expect(deleted).toMatchObject({
      status: 'DELETED',
      displayName: 'Người dùng đã rời',
    });
    const finished = await prisma.deletionRequest.findUniqueOrThrow({
      where: { id: scheduled.id },
    });
    expect(finished.status).toBe('COMPLETED');
    expect(finished.steps).toHaveProperty('IDENTITY');
    expect(
      await runner.execute(JOBS.deletionExecutor, run, (context) =>
        service.executeDue(new Date(), context),
      ),
    ).toBe('ALREADY_FINISHED');
    expect(
      await prisma.jobAttempt.count({
        where: { jobRun: { idempotencyKey: run.idempotencyKey } },
      }),
    ).toBe(1);
    await request(app.getHttpServer())
      .post(`${prefix}/deletion/cancel`)
      .send({
        reauthToken: await token(
          who.userId,
          who.sessionId,
          deleted.tokenVersion,
          true,
        ),
      })
      .expect(401);
  });
});
