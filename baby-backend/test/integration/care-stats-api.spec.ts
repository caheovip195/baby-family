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
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { CareStatsController } from '../../src/controllers/care-stats.controller';
import { PrismaService } from '../../src/database/prisma.service';
import type { CareStatsResponseDto } from '../../src/dto/care/care-stats.dto';
import type {
  MissionCategory,
  MissionScope,
  MissionStatus,
  Prisma,
} from '../../src/generated/prisma/client';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { CARE_STATS_REPOSITORY } from '../../src/interfaces/repositories/care-stats-repository.interface';
import { CATALOG_QUERY_REPOSITORY } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { CARE_STATS_SERVICE } from '../../src/interfaces/services/care-stats-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { CareStatsRepository } from '../../src/repositories/care-stats.repository';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { CareStatsService } from '../../src/services/care-stats.service';

const DAY_MS = 86_400_000;
const dateLabel = (date: Date) => date.toISOString().slice(0, 10);
const addDays = (date: Date, days: number) =>
  new Date(date.getTime() + days * DAY_MS);
const mondayIn = (timezone: string) => {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-CA', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    })
      .formatToParts(new Date())
      .map((part) => [part.type, part.value]),
  );
  const today = new Date(`${parts.year}-${parts.month}-${parts.day}T00:00:00Z`);
  return addDays(today, -((today.getUTCDay() + 6) % 7));
};
const data = (response: { body: unknown }) =>
  (response.body as { data: CareStatsResponseDto }).data;
const errorCode = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

// An explicit contract list also catches an accidental enum/catalog reordering.
const CATEGORY_CODES = [
  'CARE',
  'BONDING',
  'PLAY',
  'OUTDOOR',
  'MEMORY',
  'TOGETHER',
  'SUPPORT',
  'SELF',
  'PREP',
  'HOME',
  'CUSTOM',
];
const expectedCategories = (counts: Record<string, number>) =>
  CATEGORY_CODES.map((code) => ({ code, count: counts[code] ?? 0 }));

describe('CARE-11 family statistics API (focused Nest module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID();
  const otherFamilyId = randomUUID();
  const familyIds = [familyId, otherFamilyId];
  const parentA = randomUUID();
  const parentB = randomUUID();
  const circle = randomUUID();
  const outsider = randomUUID();
  const users = [parentA, parentB, circle, outsider];
  const childA = randomUUID();
  const childB = randomUUID();
  const deletedChild = randomUUID();
  const deletedStatusChild = randomUUID();
  const foreignChild = randomUUID();
  const planId = randomUUID();
  const planVersionId = randomUUID();
  const tokens = new Map<string, string>();
  const timezone = 'Asia/Ho_Chi_Minh';
  const week = addDays(mondayIn(timezone), -7);
  const weekStart = dateLabel(week);
  const weekEnd = dateLabel(addDays(week, 6));
  const url = `/api/v1/families/${familyId}/care-stats`;
  const bloom = [true, true, false, false, true, false, false];
  const features = { 'care.statistics': true };

  const get = (query: Record<string, string> = { weekStart }, who = parentA) =>
    request(app.getHttpServer())
      .get(url)
      .query(query)
      .set('Authorization', tokens.get(who)!);

  async function createMission(
    options: {
      category?: MissionCategory;
      scope?: MissionScope;
      children?: string[];
      deletedChildLink?: string;
      owner?: string;
      together?: boolean;
      day?: number;
      status?: MissionStatus;
      deleted?: boolean;
      completion?: 'active' | 'undone' | 'deleted' | 'none';
      historicalCompletion?: boolean;
      completionDay?: number;
      family?: string;
    } = {},
  ) {
    const owner = options.owner ?? parentA;
    const scopedFamilyId = options.family ?? familyId;
    const status = options.status ?? 'DONE';
    const together = options.together ?? false;
    const completionDate = addDays(
      week,
      options.completionDay ?? options.day ?? 0,
    );
    return prisma.$transaction(async (tx) => {
      const mission = await tx.mission.create({
        data: {
          familyId: scopedFamilyId,
          boardDate: addDays(week, options.day ?? 0),
          ownerKind: together ? 'TOGETHER' : 'PARENT',
          ownerUserId: together ? null : owner,
          source: 'CUSTOM',
          title: 'Synthetic CARE-11 fixture',
          category: options.category ?? 'CARE',
          targetScope: options.scope ?? 'FAMILY',
          hearts: 2,
          status,
          completedBy: status === 'DONE' ? owner : null,
          completedAt: status === 'DONE' ? completionDate : null,
          createdBy: owner,
          deletedAt: options.deleted ? new Date() : null,
        },
      });
      for (const childId of options.children ?? []) {
        await tx.missionChild.create({
          data: { missionId: mission.id, familyId: scopedFamilyId, childId },
        });
      }
      if (options.deletedChildLink) {
        await tx.missionChild.create({
          data: {
            missionId: mission.id,
            familyId: scopedFamilyId,
            childId: options.deletedChildLink,
            deletedAt: new Date(),
          },
        });
      }
      const completion = options.completion ?? 'active';
      if (completion !== 'none') {
        await tx.missionCompletion.create({
          data: {
            familyId: scopedFamilyId,
            missionId: mission.id,
            completedBy: owner,
            completedAt: completionDate,
            idempotencyKey: randomUUID(),
            undoneAt: completion === 'undone' ? new Date() : null,
            deletedAt: completion === 'deleted' ? new Date() : null,
          },
        });
      }
      if (options.historicalCompletion) {
        await tx.missionCompletion.create({
          data: {
            familyId: scopedFamilyId,
            missionId: mission.id,
            completedBy: parentB,
            completedAt: completionDate,
            idempotencyKey: randomUUID(),
            undoneAt: new Date(),
          },
        });
      }
      return mission;
    });
  }

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('CARE-11 integration requires exactly baby_family_test');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [CareStatsController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: CARE_STATS_SERVICE, useClass: CareStatsService },
        { provide: CARE_STATS_REPOSITORY, useClass: CareStatsRepository },
        { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
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
    for (const userId of users) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic CARE-11 account' },
      });
      await prisma.userSession.create({
        data: {
          id: sessionId,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + DAY_MS),
          absoluteExpiresAt: new Date(Date.now() + DAY_MS),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 })
          .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
          .setSubject(userId)
          .setIssuer(config.get<string>('AUTH_JWT_ISSUER')!)
          .setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!)
          .setIssuedAt()
          .setExpirationTime('10m')
          .sign(keys.privateKey)}`,
      );
    }
    for (const id of familyIds) {
      await prisma.family.create({
        data: {
          id,
          name: 'Synthetic CARE-11 family',
          createdBy: parentA,
          status: 'ACTIVE',
          activatedAt: new Date(),
          timezone,
        },
      });
    }
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parentA,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: parentB,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic CARE-11 Circle',
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `STATS_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic third plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: {},
        features,
        availableFrom: new Date(Date.now() - DAY_MS),
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: new Date(Date.now() + 30 * DAY_MS),
      },
    });
    for (const [id, scopedFamilyId] of [
      [childA, familyId],
      [childB, familyId],
      [deletedChild, familyId],
      [deletedStatusChild, familyId],
      [foreignChild, otherFamilyId],
    ]) {
      await prisma.child.create({
        data: {
          id,
          familyId: scopedFamilyId!,
          createdBy: parentA,
          name: 'Synthetic CARE-11 child',
          birthDate: new Date('2025-01-01T00:00:00Z'),
          colorIndex: 1,
          deletedAt: id === deletedChild ? new Date() : null,
          status:
            id === deletedStatusChild
              ? 'DELETED'
              : id === childB
                ? 'ARCHIVED'
                : 'ACTIVE',
        },
      });
    }
    await prisma.familyTree.create({
      data: { familyId, totalHearts: 500, level: 2, flowers: 20 },
    });
    for (const offset of [0, 1, 2, 3, 4, -1, 7]) {
      await prisma.dailyMissionBoard.create({
        data: {
          familyId,
          boardDate: addDays(week, offset),
          level: 'MEDIUM',
          perParentCount: 3,
          togetherCount: 1,
          balanceDiff: 0,
          generatorVersion: 1,
          seed: BigInt(offset + 10),
          bloomedAt: offset === 2 ? null : addDays(week, offset),
          deletedAt: offset === 3 ? new Date() : null,
        },
      });
    }
    await createMission({
      scope: 'CHILD',
      children: [childA],
      historicalCompletion: true,
    });
    await createMission({
      scope: 'CHILD',
      children: [childB],
      owner: parentB,
      day: 2,
    });
    await createMission({
      category: 'BONDING',
      scope: 'MULTI_CHILD',
      children: [childA, childB],
      day: 1,
      completionDay: 8,
    });
    await createMission({
      category: 'TOGETHER',
      scope: 'MULTI_CHILD',
      children: [childA, childB],
      together: true,
      owner: parentB,
      day: 6,
    });
    await createMission({ category: 'SUPPORT', day: 3 });
    // A removed child association must not include this family mission in child A's filter.
    await createMission({ category: 'HOME', deletedChildLink: childA, day: 4 });
    await createMission({ category: 'COUPLE' });
    await createMission({ scope: 'COUPLE', together: true });
    await createMission({ completion: 'undone' });
    await createMission({ completion: 'deleted' });
    await createMission({ completion: 'none' });
    await createMission({ deleted: true });
    await createMission({ status: 'TODO' });
    await createMission({ day: -1 });
    await createMission({ day: 7 });
    await createMission({ family: otherFamilyId });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        const where = { familyId: { in: familyIds } };
        await prisma.$transaction(async (tx) => {
          await tx.missionCompletion.deleteMany({ where });
          // Both deletions share one transaction for deferred scope constraints.
          await tx.missionChild.deleteMany({ where });
          await tx.mission.deleteMany({ where });
          await tx.dailyMissionBoard.deleteMany({ where });
          await tx.familyTree.deleteMany({ where });
          await tx.child.deleteMany({ where });
          await tx.circleMember.deleteMany({ where });
          await tx.familyEntitlement.deleteMany({ where });
          await tx.familyParent.deleteMany({ where });
          await tx.familyLicense.updateMany({
            where,
            data: { deletedAt: new Date() },
          });
          await tx.family.updateMany({
            where: { id: { in: familyIds } },
            data: { deletedAt: new Date() },
          });
          await tx.userSession.deleteMany({ where: { userId: { in: users } } });
          await tx.user.updateMany({
            where: { id: { in: users } },
            data: { deletedAt: new Date(), status: 'DELETED' },
          });
          await tx.planVersion.deleteMany({ where: { planId } });
          await tx.plan.deleteMany({ where: { id: planId } });
        });
      }
    } finally {
      await app?.close();
    }
  });

  it('counts distinct completed family missions by board week/category and excludes Couple/undone/deleted rows', async () => {
    const result = data(await get().expect(200));
    expect(result).toEqual({
      weekStart,
      weekEnd,
      total: 6,
      categories: expectedCategories({
        CARE: 2,
        BONDING: 1,
        TOGETHER: 1,
        SUPPORT: 1,
        HOME: 1,
      }),
      bloomDays: 3,
      bloomed: bloom,
    });
  });

  it('filters each child through active mission-child links without multiplying multi-child missions', async () => {
    for (const childId of [childA, childB]) {
      expect(data(await get({ weekStart, childId }).expect(200))).toEqual({
        weekStart,
        weekEnd,
        total: 3,
        categories: expectedCategories({ CARE: 1, BONDING: 1, TOGETHER: 1 }),
        bloomDays: 3,
        bloomed: bloom,
      });
    }
  });

  it('returns identical family statistics to both Parents and never returns personal breakdowns or writes/pushes', async () => {
    const beforeBoards = await prisma.dailyMissionBoard.findMany({
      where: { familyId },
    });
    const beforeTree = await prisma.familyTree.findUniqueOrThrow({
      where: { familyId },
    });
    const beforeOutbox = await prisma.outboxEvent.count({
      where: { familyId },
    });
    const first = data(await get().expect(200));
    expect(data(await get({ weekStart }, parentB).expect(200))).toEqual(first);
    expect(Object.keys(first).sort()).toEqual(
      [
        'weekStart',
        'weekEnd',
        'total',
        'categories',
        'bloomDays',
        'bloomed',
      ].sort(),
    );
    for (const item of first.categories)
      expect(Object.keys(item).sort()).toEqual(['code', 'count']);
    const serialized = JSON.stringify(first);
    for (const id of [...users, childA, childB, familyId])
      expect(serialized).not.toContain(id);
    expect(serialized).not.toMatch(
      /userId|owner|completedBy|parentA|parentB|byPerson|byUser/i,
    );
    expect(
      await prisma.dailyMissionBoard.findMany({ where: { familyId } }),
    ).toEqual(beforeBoards);
    expect(
      await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }),
    ).toEqual(beforeTree);
    expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(
      beforeOutbox,
    );
  });

  it('requires an authenticated live Parent and hides stats from Circle and strangers with 404', async () => {
    await request(app.getHttpServer()).get(url).expect(401);
    for (const who of [circle, outsider]) {
      expect(errorCode(await get({ weekStart }, who).expect(404))).toBe(
        'NOT_FOUND',
      );
    }
    await prisma.familyParent.updateMany({
      where: { familyId, userId: parentA },
      data: { deletedAt: new Date() },
    });
    try {
      expect(errorCode(await get().expect(404))).toBe('NOT_FOUND');
    } finally {
      await prisma.familyParent.updateMany({
        where: { familyId, userId: parentA },
        data: { deletedAt: null },
      });
    }
  });

  it('returns 404 for unknown, foreign-family and soft-deleted children', async () => {
    for (const childId of [
      randomUUID(),
      foreignChild,
      deletedChild,
      deletedStatusChild,
    ]) {
      expect(errorCode(await get({ weekStart, childId }).expect(404))).toBe(
        'NOT_FOUND',
      );
    }
  });

  it.each([
    ['missing', {}, 2],
    ['disabled', { 'care.statistics': false }, 3],
    ['wrong type', { 'care.statistics': 'true' }, 4],
    ['nested impostor', { care: { statistics: true } }, 5],
  ] satisfies [string, Prisma.InputJsonValue, number][])(
    'fails closed when the catalog feature is %s, independent of the plan name',
    async (_label, invalidFeatures, version) => {
      const invalidPlanVersion = await prisma.planVersion.create({
        data: {
          planId,
          version,
          quotas: {},
          features: invalidFeatures,
          availableFrom: new Date(Date.now() - DAY_MS),
        },
      });
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { effectivePlanVersionId: invalidPlanVersion.id },
      });
      try {
        expect(errorCode(await get().expect(402))).toBe(
          'SUBSCRIPTION_REQUIRED',
        );
      } finally {
        await prisma.familyEntitlement.update({
          where: { familyId },
          data: { effectivePlanVersionId: planVersionId },
        });
      }
    },
  );

  it('blocks expired subscriptions and inactive families using existing errors', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { validUntil: new Date(Date.now() - DAY_MS) },
    });
    try {
      expect(errorCode(await get().expect(402))).toBe('SUBSCRIPTION_REQUIRED');
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { validUntil: new Date(Date.now() + 30 * DAY_MS) },
      });
    }
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'PARTNER_LEFT' },
    });
    try {
      expect(errorCode(await get().expect(403))).toBe('FAMILY_NOT_ACTIVE');
    } finally {
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'ACTIVE' },
      });
    }
  });

  it('defaults to the current Monday in the family timezone and supplies seven false days for empty weeks', async () => {
    const alternateTimezone = 'Pacific/Kiritimati';
    await prisma.family.update({
      where: { id: familyId },
      data: { timezone: alternateTimezone },
    });
    try {
      const currentWeek = mondayIn(alternateTimezone);
      const result = data(await get({}).expect(200));
      expect(result.weekStart).toBe(dateLabel(currentWeek));
      expect(result.weekEnd).toBe(dateLabel(addDays(currentWeek, 6)));
      const emptyWeek = dateLabel(addDays(currentWeek, 14));
      expect(data(await get({ weekStart: emptyWeek }).expect(200))).toEqual({
        weekStart: emptyWeek,
        weekEnd: dateLabel(addDays(currentWeek, 20)),
        total: 0,
        categories: expectedCategories({}),
        bloomDays: 0,
        bloomed: Array<boolean>(7).fill(false),
      });
    } finally {
      await prisma.family.update({
        where: { id: familyId },
        data: { timezone },
      });
    }
  });

  it.each([
    '',
    '2026-02-30',
    '2026-10-27',
    '2026-1-05',
    '2026-10-26T00:00:00Z',
    'not-a-date',
  ])(
    'rejects an invalid date or non-Monday weekStart %j with 400',
    async (invalidWeek) => {
      expect(errorCode(await get({ weekStart: invalidWeek }).expect(400))).toBe(
        'CARE_STATS_WEEK_INVALID',
      );
    },
  );

  it.each([-371, 371])(
    'rejects a Monday %i days away with 400',
    async (days) => {
      const distantWeek = dateLabel(addDays(mondayIn(timezone), days));
      expect(errorCode(await get({ weekStart: distantWeek }).expect(400))).toBe(
        'CARE_STATS_RANGE_INVALID',
      );
    },
  );

  it('rejects malformed UUIDs, repeated query values and unexpected filters', async () => {
    const invalidQueries: Record<string, string>[] = [
      { weekStart, childId: 'not-a-uuid' },
      { weekStart, childId: '' },
      { weekStart, userId: parentA },
    ];
    for (const query of invalidQueries)
      expect(errorCode(await get(query).expect(400))).toBe('VALIDATION_ERROR');
    expect(
      errorCode(
        await request(app.getHttpServer())
          .get(`${url}?weekStart=${weekStart}&weekStart=${weekStart}`)
          .set('Authorization', tokens.get(parentA)!)
          .expect(400),
      ),
    ).toBe('VALIDATION_ERROR');
    await request(app.getHttpServer())
      .get('/api/v1/families/not-a-uuid/care-stats')
      .set('Authorization', tokens.get(parentA)!)
      .expect(400);
  });
});
