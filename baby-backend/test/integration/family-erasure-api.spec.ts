import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe, type INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { FAMILY_ERASURE_JOB } from '../../src/config/family-erasure-policy';
import { FamilyErasureController } from '../../src/controllers/family-erasure.controller';
import { FamilySettingsController } from '../../src/controllers/family-settings.controller';
import { FamilySettingsService } from '../../src/services/family-settings.service';
import { FamilySettingsRepository } from '../../src/repositories/family-settings.repository';
import { FAMILY_SETTINGS_SERVICE } from '../../src/interfaces/services/family-settings-service.interface';
import { FAMILY_SETTINGS_REPOSITORY } from '../../src/interfaces/repositories/family-settings-repository.interface';
import { PrismaService } from '../../src/database/prisma.service';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTH_SESSION_REPOSITORY } from '../../src/interfaces/repositories/auth-session-repository.interface';
import { CACHE_REPOSITORY } from '../../src/interfaces/repositories/cache-repository.interface';
import { FAMILY_ERASURE_REPOSITORY } from '../../src/interfaces/repositories/family-erasure-repository.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AUTH_TOKEN_SERVICE } from '../../src/interfaces/services/auth-token-service.interface';
import { FAMILY_ERASURE_SERVICE } from '../../src/interfaces/services/family-erasure-service.interface';
import { OTP_SENDER_SERVICE } from '../../src/interfaces/services/otp-sender-service.interface';
import { REAUTH_SERVICE } from '../../src/interfaces/services/reauth-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { FamilyErasureRepository } from '../../src/repositories/family-erasure.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { FamilyErasureService } from '../../src/services/family-erasure.service';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { ReauthService } from '../../src/services/reauth.service';

interface DeletionView {
  id: string | null;
  status: 'NONE' | 'AWAITING_PARTNER' | 'SCHEDULED' | 'CANCELLED';
  requestedBy: string | null;
  scheduledFor: string | null;
  cancelledAt: string | null;
  policyVersion: string | null;
  graceDays: number;
}
interface Actor extends AuthPrincipal {
  bearer: string;
  reauthToken: string;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }): string =>
  (response.body as { error: { code: string } }).error.code;

/** BF-20261019-008: all mutations and job scans are limited to this spec's families. */
describe('Family erasure (focused Nest module + PostgreSQL + real ES256 auth)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let service: FamilyErasureService;
  let access: ApplicationAccessService;
  let runner: JobRunnerService;
  let runs: JobExecutionRepository;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  let planVersionId: string;

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test database');
    keys = await generateKeyPair('ES256');
    config = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [FamilyErasureController, FamilySettingsController],
      providers: [
        PrismaService,
        { provide: FAMILY_SETTINGS_SERVICE, useClass: FamilySettingsService },
        {
          provide: FAMILY_SETTINGS_REPOSITORY,
          useClass: FamilySettingsRepository,
        },
        AccessTokenGuard,
        JobRunnerService,
        { provide: ConfigService, useValue: config },
        { provide: FAMILY_ERASURE_SERVICE, useClass: FamilyErasureService },
        {
          provide: FAMILY_ERASURE_REPOSITORY,
          useClass: FamilyErasureRepository,
        },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        { provide: REAUTH_SERVICE, useClass: ReauthService },
        // verifyToken performs real cryptographic verification; OTP issuance is not exercised here.
        { provide: AUTH_SESSION_REPOSITORY, useValue: {} },
        { provide: CACHE_REPOSITORY, useValue: {} },
        { provide: AUTH_TOKEN_SERVICE, useValue: {} },
        { provide: OTP_SENDER_SERVICE, useValue: {} },
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
    service = module.get(FAMILY_ERASURE_SERVICE);
    access = module.get(APPLICATION_ACCESS_SERVICE);
    runner = module.get(JobRunnerService);
    runs = module.get(JOB_EXECUTION_REPOSITORY);
    const plan = await prisma.plan.create({
      data: {
        code: `ERASE_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic test plan' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        features: { 'circle.enabled': true },
        quotas: {},
        availableFrom: new Date('2023-01-01'),
      },
    });
    planVersionId = version.id;
  });
  afterAll(async () => {
    await app?.close();
  });

  async function actor(): Promise<Actor> {
    const userId = randomUUID(),
      sessionId = randomUUID();
    await prisma.user.create({
      data: { id: userId, displayName: 'Synthetic erasure actor' },
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
    const jwt = (reauth: boolean) =>
      new SignJWT({
        sid: sessionId,
        ver: 1,
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
    return {
      userId,
      sessionId,
      tokenVersion: 1,
      bearer: `Bearer ${await jwt(false)}`,
      reauthToken: await jwt(true),
    };
  }
  async function fixture(single = false) {
    const parent = await actor(),
      partner = await actor(),
      circle = await actor();
    const family = await prisma.family.create({
      data: {
        name: 'Synthetic erasure family',
        createdBy: parent.userId,
        status: single ? 'PARTNER_LEFT' : 'ACTIVE',
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId: family.id,
        userId: parent.userId,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    if (!single)
      await prisma.familyParent.create({
        data: {
          familyId: family.id,
          userId: partner.userId,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      });
    await prisma.circleMember.create({
      data: {
        familyId: family.id,
        userId: circle.userId,
        relation: 'OTHER',
        displayName: 'Synthetic relative',
      },
    });
    const license = await prisma.familyLicense.create({
      data: { familyId: family.id },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId: family.id,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    return {
      family,
      parent,
      partner,
      circle,
      path: `/api/v1/families/${family.id}/deletion`,
    };
  }
  const http = () => request(app.getHttpServer());
  const submit = (
    f: Awaited<ReturnType<typeof fixture>>,
    who = f.parent,
    extra = {},
  ) =>
    http()
      .post(f.path)
      .set('Authorization', who.bearer)
      .send({ reauthToken: who.reauthToken, ...extra });
  const confirm = (f: Awaited<ReturnType<typeof fixture>>, who = f.partner) =>
    http()
      .post(`${f.path}/confirm`)
      .set('Authorization', who.bearer)
      .send({ reauthToken: who.reauthToken });
  const cancel = (f: Awaited<ReturnType<typeof fixture>>, who = f.parent) =>
    http().post(`${f.path}/cancel`).set('Authorization', who.bearer).send({});
  async function dueFixture() {
    const f = await fixture(true);
    const view = data<DeletionView>(await submit(f).expect(202));
    const due = new Date(Date.now() - 1000);
    await prisma.familyDeletionRequest.update({
      where: { id: view.id! },
      data: { executeAfter: due },
    });
    await prisma.family.update({
      where: { id: f.family.id },
      data: { deletionScheduledAt: due },
    });
    return { ...f, view };
  }

  it('starts at NONE and requires both live authentication and session-bound reauth', async () => {
    const f = await fixture();
    await http().get(f.path).expect(401);
    expect(
      data<DeletionView>(
        await http()
          .get(f.path)
          .set('Authorization', f.parent.bearer)
          .expect(200),
      ),
    ).toMatchObject({ status: 'NONE', requestedBy: null, scheduledFor: null });
    const invalid = await submit(f, f.parent, {
      reauthToken: f.parent.bearer.slice(7),
    }).expect(401);
    expect(code(invalid)).toBe('REAUTH_REQUIRED');
    await submit(f, f.parent, { reauthToken: f.partner.reauthToken }).expect(
      401,
    );
    await submit(f, f.parent, { actorUserId: f.partner.userId }).expect(400);
    expect(
      await prisma.familyDeletionRequest.count({
        where: { familyId: f.family.id },
      }),
    ).toBe(0);
  });

  it('requires the other Parent consent, keeps ACTIVE while waiting and schedules versioned grace', async () => {
    const f = await fixture();
    const start = Date.now();
    const waiting = data<DeletionView>(
      await submit(f, f.parent, { reason: 'OTHER' }).expect(202),
    );
    expect(waiting).toMatchObject({
      status: 'AWAITING_PARTNER',
      requestedBy: f.parent.userId,
      scheduledFor: null,
    });
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }))
        .status,
    ).toBe('ACTIVE');
    expect(code(await confirm(f, f.parent).expect(403))).toBe(
      'FAMILY_DELETION_PARTNER_REQUIRED',
    );
    const scheduled = data<DeletionView>(await confirm(f).expect(200));
    expect(scheduled.status).toBe('SCHEDULED');
    expect(scheduled.policyVersion).toBe('2026-10-19.v1');
    expect(scheduled.graceDays).toBe(30);
    expect(new Date(scheduled.scheduledFor!).getTime()).toBeGreaterThanOrEqual(
      start + scheduled.graceDays * 86400000,
    );
    expect(
      await prisma.familyDeletionApproval.count({
        where: { requestId: waiting.id! },
      }),
    ).toBe(2);
  });

  it.each(['parent', 'partner'] as const)(
    'allows %s to cancel pending consent and create a new request',
    async (who) => {
      const f = await fixture();
      await submit(f).expect(202);
      const cancelled = data<DeletionView>(await cancel(f, f[who]).expect(200));
      expect(cancelled).toMatchObject({
        status: 'CANCELLED',
        scheduledFor: null,
      });
      expect(cancelled.cancelledAt).not.toBeNull();
      expect(
        (await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }))
          .status,
      ).toBe('ACTIVE');
      expect(data<DeletionView>(await submit(f).expect(202)).status).toBe(
        'AWAITING_PARTNER',
      );
    },
  );

  it.each(['parent', 'partner'] as const)(
    'allows %s cancellation during grace and restores ACTIVE',
    async (who) => {
      const f = await fixture();
      await submit(f).expect(202);
      await confirm(f).expect(200);
      await cancel(f, f[who]).expect(200);
      expect(
        await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }),
      ).toMatchObject({ status: 'ACTIVE', deletionScheduledAt: null });
      await expect(
        access.requireParent(f.parent, f.family.id, 'write'),
      ).resolves.toHaveProperty('id', f.family.id);
      await expect(
        access.requireContentAccess(f.circle, f.family.id, 'read'),
      ).resolves.toHaveProperty('isParent', false);
    },
  );

  it('schedules PARTNER_LEFT with one Parent and restores PARTNER_LEFT on cancellation', async () => {
    const f = await fixture(true);
    expect(data<DeletionView>(await submit(f).expect(202)).status).toBe(
      'SCHEDULED',
    );
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }))
        .status,
    ).toBe('DELETION_SCHEDULED');
    await cancel(f).expect(200);
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }))
        .status,
    ).toBe('PARTNER_LEFT');
  });

  it('revokes Circle immediately when scheduled, permits Parent read/download and blocks writes', async () => {
    const f = await fixture();
    await http().get(f.path).set('Authorization', f.circle.bearer).expect(404);
    await submit(f, f.circle).expect(404);
    await expect(
      access.requireContentAccess(f.circle, f.family.id, 'read'),
    ).resolves.toHaveProperty('isParent', false);
    await submit(f).expect(202);
    await confirm(f).expect(200);
    await confirm(f, f.circle).expect(404);
    await cancel(f, f.circle).expect(404);
    await expect(
      access.requireContentAccess(f.circle, f.family.id, 'read'),
    ).rejects.toMatchObject({ statusCode: 403 });
    for (const mode of ['read', 'download'] as const)
      await expect(
        access.requireParent(f.parent, f.family.id, mode),
      ).resolves.toHaveProperty('id', f.family.id);
    await expect(
      access.requireParent(f.parent, f.family.id, 'write'),
    ).rejects.toMatchObject({
      statusCode: 403,
      code: 'FAMILY_DELETION_SCHEDULED',
    });
  });

  it('freezes family settings and Circle metadata during grace, then restores settings updates on cancellation', async () => {
    const f = await fixture();
    const settingsPath = `/api/v1/families/${f.family.id}/settings`;
    await http()
      .patch(settingsPath)
      .set('Authorization', f.parent.bearer)
      .send({ showLunar: false })
      .expect(200);
    expect(
      data<{ showLunar: boolean }>(
        await http()
          .get(settingsPath)
          .set('Authorization', f.circle.bearer)
          .expect(200),
      ),
    ).toEqual({ showLunar: false });
    await submit(f).expect(202);
    await confirm(f).expect(200);
    // Simulates a PATCH that passed its service check before confirmation committed.
    await expect(
      new FamilySettingsRepository(prisma).merge(f.family.id, f.parent.userId, {
        showLunar: true,
      }),
    ).resolves.toBeNull();
    expect(
      code(
        await http()
          .patch(settingsPath)
          .set('Authorization', f.parent.bearer)
          .send({ showLunar: true })
          .expect(403),
      ),
    ).toBe('FAMILY_DELETION_SCHEDULED');
    expect(
      code(
        await http()
          .get(settingsPath)
          .set('Authorization', f.circle.bearer)
          .expect(403),
      ),
    ).toBe('CIRCLE_PAUSED');
    expect(
      data<{ showLunar: boolean }>(
        await http()
          .get(settingsPath)
          .set('Authorization', f.parent.bearer)
          .expect(200),
      ).showLunar,
    ).toBe(false);
    await cancel(f, f.partner).expect(200);
    expect(
      data<{ showLunar: boolean }>(
        await http()
          .patch(settingsPath)
          .set('Authorization', f.parent.bearer)
          .send({ showLunar: true })
          .expect(200),
      ).showLunar,
    ).toBe(true);
    expect(
      data<{ showLunar: boolean }>(
        await http()
          .get(settingsPath)
          .set('Authorization', f.circle.bearer)
          .expect(200),
      ),
    ).toEqual({ showLunar: true });
  });

  it('executes only the scoped overdue family, queues media cleanup and remains idempotent across distinct runs', async () => {
    const f = await dueFixture(),
      untouched = await dueFixture();
    const asset = await prisma.asset.create({
      data: {
        familyId: f.family.id,
        uploaderUserId: f.parent.userId,
        kind: 'IMAGE',
        status: 'READY',
        storageKey: `fam/${f.family.id}/synthetic`,
        mime: 'image/jpeg',
        declaredSize: 100n,
      },
    });
    const run = {
      scopeKey: f.family.id,
      familyId: f.family.id,
      scheduledFor: new Date(),
      idempotencyKey: `family-erasure-test:${randomUUID()}`,
    };
    expect(
      await runner.execute(FAMILY_ERASURE_JOB, run, (context) =>
        service.executeDue(new Date(), context, f.family.id),
      ),
    ).toBe('SUCCEEDED');
    const family = await prisma.family.findUniqueOrThrow({
      where: { id: f.family.id },
    });
    expect(family.status).toBe('DELETED');
    expect(family.deletedAt).not.toBeNull();
    const requestRow = await prisma.familyDeletionRequest.findUniqueOrThrow({
      where: { id: f.view.id! },
    });
    expect(requestRow.status).toBe('COMPLETED');
    expect(requestRow.completedAt).not.toBeNull();
    const deletedAsset = await prisma.asset.findUniqueOrThrow({
      where: { id: asset.id },
    });
    expect(deletedAsset.status).toBe('DELETED');
    expect(deletedAsset.deletedAt).not.toBeNull();
    expect(deletedAsset.purgeAfter).not.toBeNull();
    const eventCount = await prisma.outboxEvent.count({
      where: { familyId: f.family.id },
    });
    expect(eventCount).toBeGreaterThan(0);
    expect(
      await runner.execute(
        FAMILY_ERASURE_JOB,
        {
          ...run,
          scheduledFor: new Date(Date.now() + 1),
          idempotencyKey: `family-erasure-test:${randomUUID()}`,
        },
        (context) => service.executeDue(new Date(), context, f.family.id),
      ),
    ).toBe('SUCCEEDED');
    expect(
      await prisma.outboxEvent.count({ where: { familyId: f.family.id } }),
    ).toBe(eventCount);
    expect(
      (
        await prisma.family.findUniqueOrThrow({
          where: { id: untouched.family.id },
        })
      ).deletedAt,
    ).toBeNull();
    expect(
      await prisma.jobRun.count({
        where: {
          familyId: f.family.id,
          jobName: FAMILY_ERASURE_JOB.name,
          status: 'SUCCEEDED',
        },
      }),
    ).toBe(2);
    expect(
      await prisma.jobAttempt.count({
        where: {
          jobRun: { familyId: f.family.id, jobName: FAMILY_ERASURE_JOB.name },
          status: 'SUCCEEDED',
        },
      }),
    ).toBe(2);
  });

  it('rejects writes by an expired/stale job lease and records lease recovery', async () => {
    const f = await dueFixture();
    const definition = {
      jobName: FAMILY_ERASURE_JOB.name,
      scopeKey: f.family.id,
      familyId: f.family.id,
      scheduledFor: new Date(),
      idempotencyKey: `family-erasure-stale:${randomUUID()}`,
      maxAttempts: 3,
      inputReference: {},
    };
    const first = await runs.claim(definition, 'erasure-old-worker', 60000);
    if (first.kind !== 'claimed') throw new Error('Fixture lease not claimed');
    await prisma.jobRun.update({
      where: { id: first.lease.runId },
      data: { leaseExpiresAt: new Date(Date.now() - 1000) },
    });
    const second = await runs.claim(definition, 'erasure-new-worker', 60000);
    if (second.kind !== 'claimed')
      throw new Error('Expired lease not recovered');
    expect(second.lease.fencingToken).toBeGreaterThan(first.lease.fencingToken);
    await expect(
      service.executeDue(
        new Date(),
        { lease: first.lease, signal: new AbortController().signal },
        f.family.id,
      ),
    ).rejects.toThrow();
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }))
        .deletedAt,
    ).toBeNull();
    expect(
      await prisma.jobAttempt.findUniqueOrThrow({
        where: {
          runId_attemptNumber: { runId: first.lease.runId, attemptNumber: 1 },
        },
      }),
    ).toMatchObject({ status: 'TIMED_OUT' });
    await service.executeDue(
      new Date(),
      { lease: second.lease, signal: new AbortController().signal },
      f.family.id,
    );
    await runs.succeed(second.lease, {});
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: f.family.id } }))
        .status,
    ).toBe('DELETED');
  });
});
