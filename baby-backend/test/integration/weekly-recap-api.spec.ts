import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT, jwtVerify } from 'jose';
import request from 'supertest';
import { ValidationPipe } from '@nestjs/common';
import { HttpAdapterHost, Reflector } from '@nestjs/core';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { LoggerModule, PinoLogger } from 'nestjs-pino';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { WeeklyRecapController } from '../../src/controllers/weekly-recap.controller';
import { WeeklyRecapRepository } from '../../src/repositories/weekly-recap.repository';
import {
  WeeklyRecapService,
  weekStart,
  shiftWeekDate,
} from '../../src/services/weekly-recap.service';
import { WEEKLY_RECAP_REPOSITORY } from '../../src/interfaces/repositories/weekly-recap-repository.interface';
import { WEEKLY_RECAP_SERVICE } from '../../src/interfaces/services/weekly-recap-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { WEEKLY_RECAP_JOB } from '../../src/config/weekly-recap-policy';
import type {
  WeeklyRecapResponse,
  WeekStats,
} from '../../src/dto/recap/weekly-recap.dto';
import type { Visibility } from '../../src/common/database.enums';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** BF-20261019-007: only this synthetic family is scanned by the job. */
describe('BF-20261019-007 weekly recaps (isolated Nest module + PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID();
  const childA = randomUUID(),
    childB = randomUUID();
  const tokens = new Map<string, string>();
  const ids = new Map<string, string>();

  const future = () => new Date(Date.now() + 86400000);
  const call = (
    method: 'get' | 'post' | 'delete',
    route: string,
    user = parent,
  ) => {
    const server = request(app.getHttpServer());
    const url = `/api/v1${route}`;
    const req =
      method === 'get'
        ? server.get(url)
        : method === 'post'
          ? server.post(url)
          : server.delete(url);
    return req.set('Authorization', tokens.get(user)!);
  };
  const current = weekStart(new Date(), 'Asia/Ho_Chi_Minh');
  const previous = shiftWeekDate(current, -7);
  const path = '/families/' + familyId;
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires *_test database');
    const keys = await generateKeyPair('ES256');
    const config = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [WeeklyRecapController],
      providers: [
        { provide: ConfigService, useValue: config },
        PrismaService,
        { provide: WEEKLY_RECAP_REPOSITORY, useClass: WeeklyRecapRepository },
        { provide: WEEKLY_RECAP_SERVICE, useClass: WeeklyRecapService },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        JobRunnerService,
        {
          provide: AUTHENTICATION_SERVICE,
          useValue: {
            verifyAccessToken: async (token: string) => {
              const { payload } = await jwtVerify(token, keys.publicKey, {
                issuer: 'baby-family',
                audience: 'baby-family-app',
              });
              return {
                userId: payload.sub,
                sessionId: payload.sid,
                tokenVersion: 1,
              };
            },
          },
        },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalInterceptors(
      new ResponseEnvelopeInterceptor(app.get(Reflector)),
    );
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );
    app.useGlobalFilters(
      new HttpExceptionFilter(
        app.get(HttpAdapterHost),
        await app.resolve(PinoLogger),
      ),
    );
    await app.init();
    prisma = app.get(PrismaService);
    for (const userId of [parent, partner, circle]) {
      const sid = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic recap fixture' },
      });
      await prisma.userSession.create({
        data: {
          id: sid,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: future(),
          absoluteExpiresAt: future(),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer('baby-family').setAudience('baby-family-app').setIssuedAt().setExpirationTime('15m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic recap family',
        createdBy: parent,
        status: 'ACTIVE',
        createdAt: new Date('2023-01-01'),
        activatedAt: new Date('2023-01-01'),
      },
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parent,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: partner,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    for (const id of [childA, childB])
      await prisma.child.create({
        data: {
          id,
          familyId,
          nickname: 'Synthetic child',
          birthDate: new Date('2023-01-01'),
          colorIndex: 1,
          createdBy: parent,
        },
      });
    const member = await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic relative',
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId: childA,
        permission: 'COMMENT',
        createdBy: parent,
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `RECAP_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic recap plan' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: { storageBytes: 10000000 },
        features: { 'circle.enabled': true },
        availableFrom: new Date('2023-01-01'),
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: version.id,
        validUntil: future(),
      },
    });
    const rows: {
      name: string;
      body: string;
      day: string;
      child: string;
      author?: string;
      visibility?: Visibility;
    }[] = [
      {
        name: 'walk',
        body: 'Bé tập đi những bước đầu tiên',
        day: previous,
        child: childA,
      },
      {
        name: 'beach',
        body: 'Đi biển cùng ông bà',
        day: previous,
        child: childB,
      },
      {
        name: 'meal',
        body: 'Bữa ăn dặm đầu tiên',
        day: previous,
        child: childA,
        visibility: 'PARENTS',
      },
      {
        name: 'mama',
        body: 'Tập đi cùng Mama',
        day: current,
        child: childA,
        author: partner,
      },
    ];
    for (const row of rows) {
      const id = randomUUID();
      ids.set(row.name, id);
      const at = new Date(`${row.day}T03:00:00Z`);
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: row.author ?? parent,
          authorRole: 'PARENT',
          kind: 'MOMENT',
          body: row.body,
          visibility: row.visibility ?? 'FAMILY',
          status: 'PUBLISHED',
          occurredAt: at,
          occurredLocalDate: new Date(row.day),
          publishedAt: at,
        },
      });
      await prisma.memoryChild.create({
        data: { memoryId: id, familyId, childId: row.child, ageMonth: 9 },
      });
    }

    const memberships = await prisma.familyParent.findMany({
      where: { familyId },
    });
    const space = await prisma.coupleSpace.create({
      data: {
        familyId,
        parentAUserId: parent,
        parentBUserId: partner,
        parentAMembershipId: memberships.find((m) => m.userId === parent)!.id,
        parentBMembershipId: memberships.find((m) => m.userId === partner)!.id,
      },
    });
    await prisma.appreciation.create({
      data: {
        familyId,
        coupleSpaceId: space.id,
        fromUserId: parent,
        toUserId: partner,
        bodyEnc: Buffer.from('synthetic encrypted fixture'),
        createdAt: new Date(previous + 'T03:00:00Z'),
      },
    });
    const mission = await prisma.mission.create({
      data: {
        familyId,
        boardDate: new Date(previous),
        ownerKind: 'TOGETHER',
        source: 'CUSTOM',
        createdBy: parent,
        title: 'Synthetic task',
        category: 'CARE',
        targetScope: 'FAMILY',
        hearts: 2,
        status: 'DONE',
        completedBy: parent,
        completedAt: new Date(previous + 'T03:00:00Z'),
      },
    });
    await prisma.missionCompletion.create({
      data: {
        familyId,
        missionId: mission.id,
        completedBy: parent,
        completedAt: new Date(previous + 'T03:00:00Z'),
        idempotencyKey: randomUUID(),
      },
    });
    for (const kind of ['IMAGE', 'VIDEO'] as const) {
      const asset = await prisma.asset.create({
        data: {
          familyId,
          uploaderUserId: parent,
          kind,
          status: 'READY',
          storageKey: 'recap-fixture/' + randomUUID(),
          mime: kind === 'IMAGE' ? 'image/jpeg' : 'video/mp4',
          declaredSize: 100n,
          sizeBytes: 100n,
        },
      });
      await prisma.memoryAsset.create({
        data: {
          familyId,
          memoryId: ids.get('walk')!,
          assetId: asset.id,
          sortOrder: kind === 'IMAGE' ? 0 : 1,
        },
      });
    }
    await prisma.milestone.create({
      data: {
        familyId,
        childId: childA,
        memoryId: ids.get('walk')!,
        customTitle: 'Synthetic milestone',
        occurredOn: new Date(previous),
        createdBy: parent,
      },
    });
    await prisma.careWeeklySnapshot.create({
      data: {
        familyId,
        weekStart: new Date(previous),
        metrics: { byCategory: { CARE: 7 } },
      },
    });
    await prisma.comment.create({
      data: {
        familyId,
        memoryId: ids.get('walk')!,
        authorUserId: partner,
        body: 'Giỏi quá con',
      },
    });
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.updateMany({
          where: { userId: { in: [parent, partner, circle] } },
          data: { deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: [parent, partner, circle] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
      }
    } finally {
      await app?.close();
    }
  });

  async function run(tick: number) {
    const repo = app.get<WeeklyRecapRepository>(WEEKLY_RECAP_REPOSITORY);
    const family = await prisma.family.findUniqueOrThrow({
      where: { id: familyId },
    });
    // Scope the job's family scan to this spec; all persistence/fencing remains real.
    const scan = jest.spyOn(repo, 'families').mockResolvedValue([
      {
        id: familyId,
        timezone: family.timezone,
        createdAt: family.createdAt,
      },
    ]);
    try {
      const at = new Date(Date.now() + tick * 3600000);
      return await app.get(JobRunnerService).execute(
        WEEKLY_RECAP_JOB,
        {
          scopeKey: familyId,
          familyId,
          scheduledFor: at,
          idempotencyKey: 'weekly-spec:' + familyId + ':' + tick,
        },
        (context) =>
          app
            .get<WeeklyRecapService>(WEEKLY_RECAP_SERVICE)
            .build(new Date(), context),
      );
    } finally {
      scan.mockRestore();
    }
  }
  it('builds twice without duplicate recap/snapshot and records job attempts', async () => {
    await call('get', path + '/recaps/weekly/latest').expect(404);
    expect(await run(0)).toBe('SUCCEEDED');
    expect(await run(1)).toBe('SUCCEEDED');
    expect(await run(1)).toBe('ALREADY_FINISHED');
    expect(await prisma.recap.count({ where: { familyId } })).toBe(1);
    expect(await prisma.careWeeklySnapshot.count({ where: { familyId } })).toBe(
      1,
    );
    expect(
      await prisma.jobRun.count({ where: { familyId, status: 'SUCCEEDED' } }),
    ).toBe(2);
    const recap = await prisma.recap.findFirstOrThrow({ where: { familyId } });
    expect(recap.periodStart.toISOString().slice(0, 10)).toBe(previous);
    expect(recap.visibility).toBe('PARENTS');
    const latest = data<WeeklyRecapResponse>(
      await call('get', path + '/recaps/weekly/latest').expect(200),
    );
    expect(latest.content.stats.memoryCount).toBe(3);
    expect(latest.contentParentsOnly).toEqual({
      version: 1,
      appreciationCount: 1,
    });
  });

  it('counts media/milestones/missions, preserves snapshot keys and rejects stale job writes', async () => {
    const recap = data<WeeklyRecapResponse>(
      await call('get', path + '/recaps/weekly/latest').expect(200),
    );
    expect(recap.content.stats).toMatchObject({
      photoCount: 1,
      videoCount: 1,
      milestoneCount: 1,
      missionsDone: 1,
    });
    expect(recap.coverAssetId).toEqual(expect.any(String));
    expect(
      (
        await prisma.careWeeklySnapshot.findFirstOrThrow({
          where: { familyId },
        })
      ).metrics,
    ).toMatchObject({
      byCategory: { CARE: 7 },
      recapWeekly: { version: 1, memoryCount: 3 },
    });
    const repo = app.get<WeeklyRecapRepository>(WEEKLY_RECAP_REPOSITORY);
    const result = await repo.aggregate(
      familyId,
      previous,
      shiftWeekDate(previous, 6),
      'Asia/Ho_Chi_Minh',
    );
    const run = await prisma.jobRun.findFirstOrThrow({ where: { familyId } });
    await expect(
      repo.save(
        familyId,
        shiftWeekDate(previous, -7),
        shiftWeekDate(previous, -1),
        result,
        {
          signal: new AbortController().signal,
          lease: {
            runId: run.id,
            attemptNumber: 1,
            fencingToken: 0n,
            maxAttempts: 3,
            workerId: 'stale',
            isLastAttempt: () => false,
          },
        },
      ),
    ).rejects.toThrow('lease lost');
    expect(await prisma.recap.count({ where: { familyId } })).toBe(1);
  });

  it('excludes private/sealed recap memories and counts only viewer-visible private memories on home', async () => {
    for (const [day, author, kind] of [
      [previous, parent, 'MOMENT'],
      [previous, partner, 'LETTER'],
      [previous, parent, 'LETTER'],
      [current, parent, 'MOMENT'],
      [current, partner, 'MOMENT'],
    ] as const) {
      await prisma.memory.create({
        data: {
          familyId,
          authorUserId: author,
          authorRole: 'PARENT',
          kind,
          status: 'PUBLISHED',
          visibility: kind === 'LETTER' ? 'PARENTS' : 'PRIVATE',
          familyMoment: true,
          occurredAt: new Date(day + 'T03:00:00Z'),
          occurredLocalDate: new Date(day),
          publishedAt: new Date(day + 'T03:00:00Z'),
          ...(kind === 'LETTER' ? { unlockAt: future() } : {}),
        },
      });
    }
    const latest = data<WeeklyRecapResponse>(
      await call('get', path + '/recaps/weekly/latest').expect(200),
    );
    expect(latest.content.stats.memoryCount).toBe(3);
    const stats = data<WeekStats>(
      await call('get', path + '/home/week-stats').expect(200),
    );
    expect(stats.memoryCount).toBe(2);
    expect(
      data<WeekStats>(
        await call('get', path + '/home/week-stats', circle).expect(200),
      ).memoryCount,
    ).toBe(1);
  });
  it('filters Circle recap visibility, mixed-child ACL, and strips parent-only fields', async () => {
    await call('get', path + '/recaps/weekly/latest', circle).expect(404);
    await prisma.recap.updateMany({
      where: { familyId },
      data: { visibility: 'FAMILY' },
    });
    const latest = data<WeeklyRecapResponse>(
      await call('get', path + '/recaps/weekly/latest', circle).expect(200),
    );
    expect(latest.content.stats.memoryCount).toBe(1);
    expect(latest.content.stats).toMatchObject({
      photoCount: 1,
      videoCount: 1,
      milestoneCount: 1,
    });
    expect(latest.content.topMemories).toEqual([{ id: ids.get('walk') }]);
    expect(latest).not.toHaveProperty('contentParentsOnly');
    expect(latest.content.stats).not.toHaveProperty('missionsDone');
    await prisma.memoryChild.create({
      data: {
        memoryId: ids.get('walk')!,
        familyId,
        childId: childB,
        ageMonth: 9,
      },
    });
    const filtered = data<WeeklyRecapResponse>(
      await call('get', path + '/recaps/weekly/latest', circle).expect(200),
    );
    expect(filtered.content.stats.memoryCount).toBe(0);
    expect(filtered.content.topMemories).toEqual([]);
    expect(filtered.coverAssetId).toBeNull();
    await prisma.memoryChild.deleteMany({
      where: { memoryId: ids.get('walk'), childId: childB },
    });
  });
  it('serves this week with ACL, validates paging and gates expired Parents outside the data allowlist', async () => {
    const stats = data<WeekStats>(
      await call('get', path + '/home/week-stats', circle).expect(200),
    );
    expect(stats.weekStart).toBe(current);
    expect(stats.memoryCount).toBe(1);
    expect(stats.byChild).toEqual([{ childId: childA, memoryCount: 1 }]);
    const page = data<{
      items: WeeklyRecapResponse[];
      nextCursor: string | null;
    }>(await call('get', path + '/recaps/weekly?limit=1').expect(200));
    expect(page.items).toHaveLength(1);
    expect(page.nextCursor).toBeNull();
    await call('get', path + '/recaps/weekly?cursor=' + previous)
      .expect(200)
      .then((r) => expect(data<{ items: unknown[] }>(r).items).toEqual([]));
    await call('get', path + '/recaps/weekly?limit=0').expect(400);
    await call('get', path + '/recaps/weekly?cursor=2026-02-31').expect(400);
    await call('get', '/families/' + randomUUID() + '/recaps/weekly').expect(
      404,
    );
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'EXPIRED', validUntil: new Date('2024-01-01') },
    });
    expect(
      code(await call('get', path + '/recaps/weekly/latest').expect(402)),
    ).toBe('SUBSCRIPTION_REQUIRED');
    expect(
      code(
        await call('get', path + '/recaps/weekly/latest', circle).expect(403),
      ),
    ).toBe('CIRCLE_PAUSED');
  });
  it('uses local Mondays across UTC boundaries and DST', () => {
    expect(
      weekStart(new Date('2026-10-18T17:00:00Z'), 'Asia/Ho_Chi_Minh'),
    ).toBe('2026-10-19');
    expect(
      weekStart(new Date('2026-10-19T03:00:00Z'), 'America/Los_Angeles'),
    ).toBe('2026-10-12');
    expect(
      weekStart(new Date('2026-03-09T04:00:00Z'), 'America/New_York'),
    ).toBe('2026-03-09');
  });
});
