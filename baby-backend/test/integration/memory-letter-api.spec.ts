import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { MemoryLetterController } from '../../src/controllers/memory-letter.controller';
import { MemoryController } from '../../src/controllers/memory.controller';
import { MemoryCapsuleService } from '../../src/services/memory-capsule.service';
import { MemoryCapsuleRepository } from '../../src/repositories/memory-capsule.repository';
import { MEMORY_CAPSULE_SERVICE } from '../../src/interfaces/services/memory-capsule-service.interface';
import { MEMORY_CAPSULE_REPOSITORY } from '../../src/interfaces/repositories/memory-capsule-repository.interface';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { JOB_RUNNER_SERVICE } from '../../src/interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../../src/interfaces/services/job-runner-service.interface';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { JOBS } from '../../src/config/jobs';
import type { CapsuleResponse } from '../../src/interfaces/services/memory-capsule-service.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Memory letters API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  const familyId = randomUUID();
  const parentB = randomUUID();
  const parent = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const tokens = new Map<string, string>();
  const attachmentId = randomUUID();
  const childId = randomUUID(),
    ungrantedChild = randomUUID();
  const url = `/api/v1/children/${childId}/letters`;
  let runner: IJobRunnerService;
  let capsules: MemoryCapsuleService;

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    keys = await generateKeyPair('ES256', { extractable: true });
    config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MemoryLetterController, MemoryController],
      providers: [
        PrismaService,
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: MEMORY_CAPSULE_SERVICE, useClass: MemoryCapsuleService },
        {
          provide: MEMORY_CAPSULE_REPOSITORY,
          useClass: MemoryCapsuleRepository,
        },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        {
          provide: MEDIA_SERVICE,
          useValue: { signViewUrls: () => Promise.resolve({ items: [] }) },
        },
        { provide: JOB_RUNNER_SERVICE, useClass: JobRunnerService },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
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
    runner = module.get(JOB_RUNNER_SERVICE);
    capsules = module.get(MEMORY_CAPSULE_SERVICE);
    for (const userId of [parent, parentB, circle, outsider]) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic settings fixture' },
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
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer(config.get<string>('AUTH_JWT_ISSUER')!).setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!).setIssuedAt().setExpirationTime('5m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic settings family',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date(),
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: parent,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `SETTINGS_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic settings' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: { photosPerMemory: 30 },
        features: { 'circle.enabled': true },
        availableFrom: new Date(),
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: version.id,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    const member = await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
      },
    });
    await prisma.asset.create({
      data: {
        id: attachmentId,
        familyId,
        uploaderUserId: parent,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        status: 'READY',
        storageKey: `test/letters/${attachmentId}/raw`,
        mime: 'image/jpeg',
        declaredSize: 1024n,
        sizeBytes: 1024n,
      },
    });
    await prisma.familyUsage.create({ data: { familyId } });
    for (const [i, id] of [childId, ungrantedChild].entries())
      await prisma.child.create({
        data: {
          id,
          familyId,
          name: 'Synthetic child',
          birthDate: new Date('2025-01-01'),
          colorIndex: i + 1,
          createdBy: parent,
        },
      });
    await prisma.circleGrant.create({
      data: {
        familyId,
        childId,
        circleMemberId: member.id,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
  });
  afterAll(async () => {
    await app?.close();
  });

  const get = (who = parent) =>
    request(app.getHttpServer())
      .get(url)
      .set('Authorization', tokens.get(who)!);
  const create = (letter: object) =>
    request(app.getHttpServer())
      .post('/api/v1/memories')
      .set('Authorization', tokens.get(parent)!)
      .set('Idempotency-Key', randomUUID())
      .send({
        familyId,
        kind: 'LETTER',
        assetIds: [attachmentId],
        title: 'A synthetic envelope',
        body: 'Synthetic sealed body',
        childIds: [childId],
        occurredAt: new Date().toISOString(),
        visibility: 'FAMILY',
        letter,
      });
  const rows = (response: { body: unknown }) =>
    data<CapsuleResponse[]>(response);
  let memoryId: string;
  it('creates sealed letter; author sees body, partner sees envelope and Circle sees nothing', async () => {
    const created = await create({
      childId,
      releaseRule: 'DATE',
      unlockAt: new Date(Date.now() + 86400000).toISOString(),
      releaseVisibility: 'FAMILY',
    }).expect(201);
    memoryId = data<{ id: string }>(created).id;
    expect(rows(await get().expect(200))[0]).toMatchObject({
      id: memoryId,
      sealed: true,
      body: 'Synthetic sealed body',
      assetIds: [attachmentId],
    });
    expect(rows(await get(circle).expect(200))).toEqual([]);
    for (const who of [parentB]) {
      const envelope = rows(await get(who).expect(200))[0];
      expect(envelope).toMatchObject({ id: memoryId, sealed: true });
      expect(envelope).not.toHaveProperty('body');
      expect(envelope).not.toHaveProperty('assetIds');
    }
    const detail = data<{ body: string | null; assets: unknown[] }>(
      await request(app.getHttpServer())
        .get(`/api/v1/memories/${memoryId}`)
        .set('Authorization', tokens.get(parentB)!)
        .expect(200),
    );
    expect(detail.body).toBeNull();
    expect(detail.assets).toEqual([]);
    await get(outsider).expect(404);
    await request(app.getHttpServer())
      .get(`/api/v1/children/${ungrantedChild}/letters`)
      .set('Authorization', tokens.get(circle)!)
      .expect(404);
  });
  it('past-due letter remains sealed until durable job releases; running twice produces one release event and history', async () => {
    await prisma.memory.update({
      where: { id: memoryId },
      data: { unlockAt: new Date(Date.now() - 1000) },
    });
    expect(rows(await get(parentB).expect(200))[0]).not.toHaveProperty('body');
    const dueDetail = data<{ body: string | null }>(
      await request(app.getHttpServer())
        .get(`/api/v1/memories/${memoryId}`)
        .set('Authorization', tokens.get(parentB)!)
        .expect(200),
    );
    expect(dueDetail.body).toBeNull();
    const now = new Date();
    const run = {
      scopeKey: familyId,
      scheduledFor: now,
      idempotencyKey: `letter-test:${familyId}`,
      familyId,
    };
    expect(
      await runner.execute(JOBS.releaseLetters, run, (ctx) =>
        capsules.release(now, ctx, familyId),
      ),
    ).toBe('SUCCEEDED');
    expect(
      await runner.execute(JOBS.releaseLetters, run, (ctx) =>
        capsules.release(now, ctx, familyId),
      ),
    ).toBe('ALREADY_FINISHED');
    // A distinct subsequent run also finds no work and emits no second event.
    await runner.execute(
      JOBS.releaseLetters,
      {
        ...run,
        scheduledFor: new Date(now.getTime() + 1),
        idempotencyKey: `letter-test-next:${familyId}`,
      },
      (ctx) => capsules.release(now, ctx, familyId),
    );
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: memoryId, eventType: 'memory.letter.released' },
      }),
    ).toBe(1);
    const persisted = await prisma.memory.findUniqueOrThrow({
      where: { id: memoryId },
    });
    expect(persisted.unlockAt).toBeNull();
    expect(persisted.visibility).toBe('FAMILY');
    for (const who of [parentB, circle])
      expect(rows(await get(who).expect(200))[0]).toMatchObject({
        id: memoryId,
        sealed: false,
        body: 'Synthetic sealed body',
      });
    const history = await prisma.jobRun.findUniqueOrThrow({
      where: { idempotencyKey: run.idempotencyKey },
      include: { jobAttempts: true },
    });
    expect(history.status).toBe('SUCCEEDED');
    expect(history.jobAttempts).toHaveLength(1);
  });
  it('does not reveal a released FAMILY letter tagged with an ungranted child', async () => {
    await prisma.memoryChild.create({
      data: { familyId, memoryId, childId: ungrantedChild, ageMonth: 0 },
    });
    try {
      expect(
        rows(await get(circle).expect(200)).some((row) => row.id === memoryId),
      ).toBe(false);
      expect(
        rows(await get(parentB).expect(200)).some((row) => row.id === memoryId),
      ).toBe(true);
    } finally {
      await prisma.memoryChild.update({
        where: { memoryId_childId: { memoryId, childId: ungrantedChild } },
        data: { deletedAt: new Date() },
      });
    }
  });
  it('accepts birthday rule, rejects unsupported release rules and hides drafts from partner and Circle', async () => {
    await create({
      childId,
      releaseRule: 'CHILD_BIRTHDAY',
      birthdayNumber: 18,
      releaseVisibility: 'PARENTS',
    }).expect(201);
    await create({
      childId,
      releaseRule: 'AGE',
      birthdayNumber: 18,
      releaseVisibility: 'PARENTS',
    }).expect(400);
    const draft = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'LETTER',
        body: 'Synthetic private draft',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        status: 'DRAFT',
        visibility: 'FAMILY',
      },
    });
    await prisma.memoryLetter.create({
      data: {
        familyId,
        childId,
        memoryId: draft.id,
        releaseRule: 'DATE',
        releaseVisibility: 'FAMILY',
      },
    });
    for (const who of [parentB, circle])
      expect(
        rows(await get(who).expect(200)).some((row) => row.id === draft.id),
      ).toBe(false);
  });
  it('enforces Circle current subscription and circle.enabled capability; inactive memberships lose access', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { validUntil: new Date(Date.now() - 1000) },
    });
    const paused = await get(circle).expect(403);
    expect((paused.body as { error: { code: string } }).error.code).toBe(
      'CIRCLE_PAUSED',
    );
    const denied = await get(parent).expect(402);
    expect((denied.body as { error: { code: string } }).error.code).toBe(
      'SUBSCRIPTION_REQUIRED',
    ); // Letter lists are outside §6.5; detail/download/export remain available.
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { validUntil: new Date(Date.now() + 86400000) },
    });
    const entitlement = await prisma.familyEntitlement.findUniqueOrThrow({
      where: { familyId },
    });
    const currentPlan = await prisma.planVersion.findUniqueOrThrow({
      where: { id: entitlement.effectivePlanVersionId! },
    });
    const noCircle = await prisma.planVersion.create({
      data: {
        planId: currentPlan.planId,
        version: 2,
        availableFrom: new Date(),
        quotas: { photosPerMemory: 30 },
        features: { 'circle.enabled': false },
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: noCircle.id },
    });
    await get(circle).expect(403);
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: currentPlan.id },
    });
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { status: 'PAUSED' },
    });
    await get(circle).expect(403);
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { status: 'ACTIVE' },
    });
  });
  it('does not expose sensitive pregnancy letters to Circle or release them; soft-deleted letters vanish', async () => {
    const pregnancy = await prisma.pregnancy.create({
      data: {
        familyId,
        seqNo: 1,
        nickname: 'Synthetic sensitive',
        status: 'ENDED_PRIVATE',
        createdBy: parent,
      },
    });
    await prisma.memory.update({
      where: { id: memoryId },
      data: {
        pregnancyId: pregnancy.id,
        unlockAt: new Date(Date.now() - 1000),
        visibility: 'PRIVATE',
      },
    });
    expect(
      rows(await get(circle).expect(200)).some((row) => row.id === memoryId),
    ).toBe(false);
    const now = new Date();
    await runner.execute(
      JOBS.releaseLetters,
      {
        scopeKey: familyId,
        scheduledFor: now,
        idempotencyKey: `letter-sensitive:${familyId}`,
      },
      (ctx) => capsules.release(now, ctx, familyId),
    );
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memoryId } }))
        .unlockAt,
    ).not.toBeNull();
    await prisma.memoryLetter.update({
      where: { memoryId },
      data: { deletedAt: new Date() },
    });
    expect(
      rows(await get(parent).expect(200)).some((row) => row.id === memoryId),
    ).toBe(false);
  });
});
