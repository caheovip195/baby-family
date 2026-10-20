import { randomBytes, randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';
import type { Prisma } from '../../src/generated/prisma/client';
import type {
  MyMissionDto,
  MissionBoardResponseDto,
} from '../../src/dto/mission/mission.dto';
import type { MissionTemplateView } from '../../src/models/mission-board-view.model';
import { HEARTS_POLICY } from '../../src/config/hearts-policy';
import { MissionBoardCatalogSeedRepository } from '../../src/repositories/mission-board-catalog-seed.repository';
import { MISSION_BOARD_REPOSITORY } from '../../src/interfaces/repositories/mission-board-repository.interface';
import type { IMissionBoardRepository } from '../../src/interfaces/repositories/mission-board-repository.interface';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
interface CompletionResponse {
  mission: MyMissionDto;
  myHeartsAwarded: number;
  memoryId: null;
  tree: { leaves: number; total: number; bloomed: boolean };
}
const missionData = (response: { body: unknown }): MyMissionDto => {
  const result = data<MyMissionDto | { mission: MyMissionDto }>(response);
  return 'mission' in result ? result.mission : result;
};
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Daily missions API (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const parentA = randomUUID(),
    parentB = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const users = [parentA, parentB, circle, outsider];
  const sessions = new Map(users.map((id) => [id, randomUUID()]));
  const tokens = new Map<string, string>();
  const familyId = randomUUID(),
    coupleSpaceId = randomUUID(),
    planId = randomUUID(),
    planVersionId = randomUUID(),
    licenseId = randomUUID();
  const basePath = `/families/${familyId}/missions/board`;
  const childId = randomUUID();
  const fixtureCodes = Array.from(
    { length: 8 },
    (_, index) => `MT-${randomUUID().slice(0, 10)}-${index}`,
  );
  let swapTemplateIds: string[] = [];
  const today = () =>
    new Intl.DateTimeFormat('sv-SE', {
      timeZone: 'Asia/Ho_Chi_Minh',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).format(new Date());
  const day = (offset: number) => {
    const value = new Date(`${today()}T00:00:00Z`);
    value.setUTCDate(value.getUTCDate() + offset);
    return value.toISOString().slice(0, 10);
  };
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);
  function call(
    method: 'get' | 'post' | 'patch' | 'delete',
    userId: string,
    route = basePath,
    body?: Record<string, unknown>,
  ) {
    const client = request(app.getHttpServer());
    const result = client[method](`/api/v1${route}`).set(
      'Authorization',
      tokens.get(userId) ?? '',
    );
    return body === undefined ? result : result.send(body);
  }
  function create(
    userId = parentA,
    body: Record<string, unknown> = {},
    key = randomUUID(),
  ) {
    return call('post', userId, '/missions', {
      familyId,
      owner: 'ME',
      title: 'Synthetic mission',
      ...body,
    }).set('Idempotency-Key', key);
  }
  const created = async (
    body: Record<string, unknown> = {},
    userId = parentA,
  ) => {
    const result = data<{ mission: MyMissionDto; seriesId: null }>(
      await create(userId, body).expect(201),
    );
    expect(result.seriesId).toBeNull();
    expect(result.mission.id).toEqual(expect.any(String));
    return result.mission;
  };
  const action = (
    id: string,
    name: string,
    userId: string = parentA,
    body?: Record<string, unknown>,
    key = randomUUID(),
  ) =>
    call('post', userId, `/missions/${id}/${name}`, body).set(
      'Idempotency-Key',
      key,
    );
  const detail = async (id: string, userId = parentA) =>
    missionData(await call('get', userId, `/missions/${id}`).expect(200));
  const board = async (userId = parentA, query = '') =>
    data<MissionBoardResponseDto>(
      await call('get', userId, `${basePath}${query}`).expect(200),
    );
  let ledgerAfter = 0n;
  const ledger = () =>
    prisma.heartLedger.findMany({
      where: { familyId, id: { gt: ledgerAfter } },
    });
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Daily missions integration requires a *_test database.');
    const keys = await generateKeyPair('ES256');
    const configuration = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
      COUPLE_CHECKIN_ENCRYPTION_KEY: randomBytes(32).toString('base64'),
    });
    const { AppModule } = await import('../../src/app.module.js');
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(ConfigService)
      .useValue(configuration)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    prisma = app.get(PrismaService);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Synthetic mission fixture',
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });
    await prisma.userSession.createMany({
      data: [...sessions].map(([userId, id]) => ({
        id,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: future(),
        absoluteExpiresAt: future(),
      })),
    });
    for (const userId of users) {
      const issued = Math.floor(Date.now() / 1000);
      const token = await new SignJWT({
        sub: userId,
        sid: sessions.get(userId),
        ver: 1,
        iat: issued,
        exp: issued + 900,
        iss: 'baby-family',
        aud: 'baby-family-app',
      })
        .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
        .sign(keys.privateKey);
      tokens.set(userId, `Bearer ${token}`);
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic mission family',
        createdBy: parentA,
        status: 'ACTIVE',
        activatedAt: past(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    const a = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'A',
      },
    });
    const b = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'B',
      },
    });
    await prisma.coupleSpace.create({
      data: {
        id: coupleSpaceId,
        familyId,
        parentAUserId: parentA,
        parentBUserId: parentB,
        parentAMembershipId: a.id,
        parentBMembershipId: b.id,
      },
    });
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'CAREGIVER',
        displayName: 'Synthetic Circle',
        invitedBy: parentA,
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `MISSION_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic mission plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        // CARE-06 creates a memory: the memory plan schema needs these.
        quotas: { storageBytes: 1024 * 1024 * 1024, photosPerMemory: 2 },
        features: { 'circle.enabled': false },
        availableFrom: past(),
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic child',
        birthDate: new Date(Date.now() - 300 * 86_400_000),
        colorIndex: 1,
        createdBy: parentA,
      },
    });
    const catalog = JSON.parse(
      await readFile(join(process.cwd(), 'prisma/seeds/missions.json'), 'utf8'),
    ) as { templates: Prisma.MissionTemplateCreateManyInput[] };
    // The fixture explicitly installs its catalog; no dependence on db:seed.
    await prisma.missionTemplate.createMany({
      data: catalog.templates,
      skipDuplicates: true,
    });
    await prisma.missionTemplate.createMany({
      data: fixtureCodes.map((code) => ({
        code,
        stage: 'ANY',
        category: 'CARE',
        suggestedScope: 'FAMILY',
        roleFit: 'ANY_PARENT',
        hearts: 5,
        durationMin: 10,
        titleI18n: { vi: 'Synthetic swap option', en: 'Synthetic swap option' },
      })),
    });
    swapTemplateIds = (
      await prisma.missionTemplate.findMany({
        where: { code: { in: fixtureCodes } },
        orderBy: { code: 'asc' },
      })
    ).map((item) => item.id);
  });
  async function clearMissions() {
    // Ledger retention is mandatory; assertions isolate entries created by this test.
    ledgerAfter =
      (
        await prisma.heartLedger.findFirst({
          where: { familyId },
          orderBy: { id: 'desc' },
        })
      )?.id ?? 0n;
    await prisma.$transaction(async (tx) => {
      await tx.requestChild.deleteMany({ where: { familyId } });
      await tx.request.deleteMany({ where: { familyId } });
      await tx.heartDailyCounter.deleteMany({ where: { familyId } });
      await tx.missionEvent.deleteMany({ where: { familyId } });
      await tx.missionCompletion.deleteMany({ where: { familyId } });
      await tx.missionChild.deleteMany({ where: { familyId } });
      await tx.mission.deleteMany({ where: { familyId } });
      await tx.missionSeriesChild.deleteMany({ where: { familyId } });
      await tx.missionSeries.deleteMany({ where: { familyId } });
      await tx.missionPreference.deleteMany({ where: { familyId } });
      await tx.missionFamilySetting.deleteMany({ where: { familyId } });
      await tx.dailyMissionBoardParent.deleteMany({ where: { familyId } });
      await tx.dailyMissionBoard.deleteMany({ where: { familyId } });
      await tx.familyTree.deleteMany({ where: { familyId } });
      await tx.idempotencyRecord.deleteMany({ where: { familyId } });
      await tx.outboxEvent.deleteMany({ where: { familyId } });
    });
  }
  beforeEach(clearMissions);
  afterAll(async () => {
    try {
      if (prisma) {
        await clearMissions();
        await prisma.child.deleteMany({ where: { familyId } });
        await prisma.missionTemplate.deleteMany({
          where: { code: { in: fixtureCodes } },
        });
        await prisma.coupleSpace.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: licenseId },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: users } },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('runs the explicit catalog seed twice without changing published templates', async () => {
    const path = join(process.cwd(), 'prisma/seeds/missions.json');
    const catalog = JSON.parse(await readFile(path, 'utf8')) as {
      templates: { code: string }[];
    };
    const where = { code: { in: catalog.templates.map((item) => item.code) } };
    const seed = new MissionBoardCatalogSeedRepository(prisma);
    await seed.seedFromFile(path);
    const before = await prisma.missionTemplate.findMany({
      where,
      orderBy: { code: 'asc' },
    });
    await seed.seedFromFile(path);
    const after = await prisma.missionTemplate.findMany({
      where,
      orderBy: { code: 'asc' },
    });
    expect(after).toHaveLength(catalog.templates.length);
    expect(after).toEqual(before);
  });

  it('lays out today once under concurrency with equal Parent quotas and balanced Hearts', async () => {
    const responses = await Promise.all(
      Array.from({ length: 6 }, (_, index) =>
        call('get', index % 2 ? parentA : parentB),
      ),
    );
    for (const response of responses) expect(response.status).toBe(200);
    expect(await prisma.dailyMissionBoard.count({ where: { familyId } })).toBe(
      1,
    );
    const rows = await prisma.mission.findMany({
      where: { familyId, source: 'SYSTEM', deletedAt: null },
    });
    expect(rows).toHaveLength(7);
    const a = rows.filter((item) => item.ownerUserId === parentA);
    const b = rows.filter((item) => item.ownerUserId === parentB);
    expect(a).toHaveLength(3);
    expect(b).toHaveLength(3);
    expect(
      Math.abs(
        a.reduce((total, item) => total + item.hearts, 0) -
          b.reduce((total, item) => total + item.hearts, 0),
      ),
    ).toBeLessThanOrEqual(2);
    expect(rows.filter((item) => item.ownerKind === 'TOGETHER')).toHaveLength(
      1,
    );
    expect(new Set(rows.map((item) => item.templateId)).size).toBe(7);
    const first = data<MissionBoardResponseDto>(responses[0]!);
    expect(first.tabs).toEqual({
      mine: { done: 0, total: 3 },
      partner: { done: 0, total: 3 },
      together: { done: 0, total: 1 },
    });
    expect(first).toMatchObject({
      myHeartsToday: 0,
      swapsLeft: 3,
      openRequestCount: 0,
    });
    const second = await board();
    expect(second.items.map((item) => item.id).sort()).toEqual(
      data<MissionBoardResponseDto>(responses[1]!)
        .items.map((item) => item.id)
        .sort(),
    );
  });

  it('blooms once when all system missions finish and retains the flower after undo and redo', async () => {
    await board();
    const rows = await prisma.mission.findMany({
      where: { familyId, source: 'SYSTEM' },
      orderBy: { ownerKind: 'asc' },
    });
    for (const row of rows)
      await action(row.id, 'complete', row.ownerUserId ?? parentA).expect(201);
    expect((await board()).tree.bloomed).toBe(true);
    expect(
      (await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }))
        .flowers,
    ).toBe(1);
    const last = rows[rows.length - 1]!;
    await action(last.id, 'undo', last.ownerUserId ?? parentA).expect(201);
    expect(
      (await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }))
        .flowers,
    ).toBe(1);
    await action(last.id, 'complete', last.ownerUserId ?? parentA).expect(201);
    expect((await board()).tree.bloomed).toBe(true);
    expect(
      (await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }))
        .flowers,
    ).toBe(1);
  });

  it('keeps the board from blooming when a system mission was skipped', async () => {
    await board();
    const rows = await prisma.mission.findMany({
      where: { familyId, source: 'SYSTEM' },
    });
    const skipped = rows.find((row) => row.ownerUserId === parentA)!;
    await action(skipped.id, 'remove').expect(201);
    for (const row of rows.filter((row) => row.id !== skipped.id))
      await action(row.id, 'complete', row.ownerUserId ?? parentA).expect(201);
    expect((await board()).tree.bloomed).toBe(false);
    expect(
      (await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }))
        .flowers,
    ).toBe(0);
  });

  it('projects partner items with an exact privacy whitelist and hides expired partner missions', async () => {
    const own = await created(
      { note: 'Synthetic private mission note' },
      parentB,
    );
    const expectedKeys = [
      'id',
      'title',
      'category',
      'childIds',
      'status',
      'completedAt',
      'late',
      'thanked',
    ].sort();
    const partner = await detail(own.id);
    expect(Object.keys(partner).sort()).toEqual(expectedKeys);
    expect((await detail(own.id, parentB)).hearts).toBe(2);
    const view = await board(parentA, '?tab=PARTNER');
    expect(view).not.toHaveProperty('myHeartsToday');
    for (const item of view.items)
      expect(Object.keys(item).sort()).toEqual(expectedKeys);
    const together = await board(parentA, '?tab=TOGETHER');
    expect(together).not.toHaveProperty('myHeartsToday');
    await prisma.mission.update({
      where: { id: own.id },
      data: { status: 'EXPIRED' },
    });
    await call('get', parentA, `/missions/${own.id}`).expect(404);
    expect(
      (await board(parentA, '?tab=PARTNER')).items.map((item) => item.id),
    ).not.toContain(own.id);
  });

  it('rejects partner ownership and partner mutations with the required errors', async () => {
    for (const owner of ['PARTNER', parentB])
      expect(code(await create(parentA, { owner }).expect(422))).toBe(
        'MISSION_OWNER_INVALID',
      );
    expect(
      code(await create(parentA, { ownerUserId: parentB }).expect(422)),
    ).toBe('MISSION_OWNER_INVALID');
    const own = await created({}, parentB);
    for (const name of ['complete', 'undo', 'remove', 'swap']) {
      const body =
        name === 'swap'
          ? { templateId: swapTemplateIds[0], optionsToken: randomUUID() }
          : undefined;
      expect(code(await action(own.id, name, parentA, body).expect(403))).toBe(
        'MISSION_NOT_OWNER',
      );
    }
    expect(
      code(
        await call('get', parentA, `/missions/${own.id}/swap-options`).expect(
          403,
        ),
      ),
    ).toBe('MISSION_NOT_OWNER');
  });

  it('requires completion idempotency and awards once on repeated and concurrent completion', async () => {
    const own = await created();
    await call('post', parentA, `/missions/${own.id}/complete`).expect(400);
    const key = randomUUID();
    const responses = await Promise.all([
      action(own.id, 'complete', parentA, undefined, key),
      action(own.id, 'complete', parentA, undefined, key),
    ]);
    for (const response of responses) expect(response.status).toBe(201);
    expect(data<CompletionResponse>(responses[0])).toEqual(
      data<CompletionResponse>(responses[1]),
    );
    expect(data<CompletionResponse>(responses[0])).toMatchObject({
      myHeartsAwarded: 2,
      memoryId: null,
      mission: { status: 'DONE' },
    });
    expect(missionData(responses[0]).status).toBe('DONE');
    expect(
      await prisma.missionCompletion.count({
        where: { familyId, missionId: own.id },
      }),
    ).toBe(1);
    expect((await ledger()).map((item) => item.amount)).toEqual([2]);
    expect(code(await action(own.id, 'complete').expect(409))).toBe(
      'INVALID_MISSION_TRANSITION',
    );
    const events = await prisma.outboxEvent.findMany({ where: { familyId } });
    expect(events).toHaveLength(2);
    for (const event of events) {
      expect(event.eventType).toBe('mission.changed');
      expect(Object.keys(event.payload as object).sort()).toEqual([
        'familyId',
        'missionId',
        'version',
      ]);
      expect(JSON.stringify(event.payload)).not.toContain('Synthetic');
    }
    expect((await board()).myHeartsToday).toBe(2);
  });

  it('replays the original completion response after undo without awarding again', async () => {
    const own = await created();
    const key = randomUUID();
    const original = data<CompletionResponse>(
      await action(own.id, 'complete', parentA, undefined, key).expect(201),
    );
    await action(own.id, 'undo').expect(201);
    expect((await detail(own.id)).status).toBe('TODO');
    const replay = data<CompletionResponse>(
      await action(own.id, 'complete', parentA, undefined, key).expect(201),
    );
    expect(replay).toEqual(original);
    expect(replay.mission.status).toBe('DONE');
    expect(replay.myHeartsAwarded).toBe(2);
    expect((await detail(own.id)).status).toBe('TODO');
    expect(
      await prisma.missionCompletion.count({
        where: { familyId, missionId: own.id },
      }),
    ).toBe(1);
    expect(await ledger()).toHaveLength(2);
    expect(
      (await ledger()).reduce((total, item) => total + item.amount, 0),
    ).toBe(0);
  });

  it('caps custom awards at three per day and shares the global daily Hearts cap', async () => {
    for (let index = 0; index < 4; index++) {
      const own = await created({ title: `Synthetic custom ${index}` });
      await action(own.id, 'complete').expect(201);
    }
    expect(
      (await ledger())
        .filter((item) => item.userId === parentA)
        .reduce((total, item) => total + item.amount, 0),
    ).toBe(6);
    const counter = await prisma.heartDailyCounter.findFirstOrThrow({
      where: { familyId, userId: parentA },
    });
    expect(counter.customCount).toBe(3);
    await prisma.heartDailyCounter.update({
      where: {
        userId_localDate: { userId: parentA, localDate: counter.localDate },
      },
      data: { total: HEARTS_POLICY.dailyHeartCap - 1 },
    });
    const before = (await ledger()).reduce(
      (total, item) => total + item.amount,
      0,
    );
    const capped = await created({
      title: undefined,
      templateId: swapTemplateIds[0],
      targetScope: 'FAMILY',
    });
    expect(
      data<CompletionResponse>(await action(capped.id, 'complete').expect(201))
        .myHeartsAwarded,
    ).toBe(1);
    expect(
      (await ledger()).reduce((total, item) => total + item.amount, 0) - before,
    ).toBe(1);
    const full = await created({
      title: undefined,
      templateId: swapTemplateIds[1],
      targetScope: 'FAMILY',
    });
    expect(
      data<CompletionResponse>(await action(full.id, 'complete').expect(201))
        .myHeartsAwarded,
    ).toBe(0);
    expect((await board()).myHeartsToday).toBe(HEARTS_POLICY.dailyHeartCap);
    expect(
      (await ledger()).reduce((total, item) => total + item.amount, 0) - before,
    ).toBe(1);
  });

  it('completes TOGETHER for both Parents once and reverses both awards on undo', async () => {
    const own = await created({ owner: 'TOGETHER' });
    expect(
      data<CompletionResponse>(
        await action(own.id, 'complete', parentB).expect(201),
      ).myHeartsAwarded,
    ).toBe(2);
    expect(await detail(own.id)).toMatchObject({
      status: 'DONE',
      ownerKind: 'TOGETHER',
    });
    const entries = await ledger();
    expect(entries).toHaveLength(2);
    expect(entries.map((item) => item.userId).sort()).toEqual(
      [parentA, parentB].sort(),
    );
    expect(entries.every((item) => item.amount === 2)).toBe(true);
    expect(code(await action(own.id, 'complete', parentA).expect(409))).toBe(
      'INVALID_MISSION_TRANSITION',
    );
    expect(code(await action(own.id, 'undo', parentA).expect(403))).toBe(
      'MISSION_NOT_OWNER',
    );
    expect(
      missionData(await action(own.id, 'undo', parentB).expect(201)).status,
    ).toBe('TODO');
    const reversed = await ledger();
    expect(reversed.filter((item) => item.reversalOf !== null)).toHaveLength(2);
    expect(reversed.reduce((total, item) => total + item.amount, 0)).toBe(0);
    expect(
      (await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }))
        .totalHearts,
    ).toBe(0);
  });

  it('permits undo within thirty seconds and blocks it after the server window', async () => {
    const own = await created();
    await action(own.id, 'complete').expect(201);
    expect(missionData(await action(own.id, 'undo').expect(201)).status).toBe(
      'TODO',
    );
    const reversed = await ledger();
    expect(reversed).toHaveLength(2);
    expect(reversed.reduce((total, item) => total + item.amount, 0)).toBe(0);
    expect(reversed.find((item) => item.reversalOf !== null)?.amount).toBe(-2);
    const closed = await created({ title: 'Synthetic late undo' });
    await action(closed.id, 'complete').expect(201);
    await prisma.mission.update({
      where: { id: closed.id },
      data: { completedAt: new Date(Date.now() - 31_000) },
    });
    expect(code(await action(closed.id, 'undo').expect(409))).toBe(
      'MISSION_UNDO_WINDOW_CLOSED',
    );
    expect((await detail(closed.id)).status).toBe('DONE');
  });

  it('accepts yesterday EXPIRED completion as late and rejects older missions', async () => {
    const own = await created();
    await prisma.mission.update({
      where: { id: own.id },
      data: { boardDate: new Date(`${day(-1)}T00:00:00Z`), status: 'EXPIRED' },
    });
    expect(
      missionData(await action(own.id, 'complete').expect(201)),
    ).toMatchObject({ status: 'DONE', late: true });
    expect(
      (await ledger()).reduce((total, item) => total + item.amount, 0),
    ).toBe(2);
    const old = await created({ title: 'Synthetic old mission' });
    await prisma.mission.update({
      where: { id: old.id },
      data: { boardDate: new Date(`${day(-2)}T00:00:00Z`), status: 'EXPIRED' },
    });
    expect(code(await action(old.id, 'complete').expect(422))).toBe(
      'MISSION_LATE_WINDOW_CLOSED',
    );
  });

  it('validates swap tokens, replaces softly, and enforces three swaps per day', async () => {
    await board();
    const currentTemplates = (
      await prisma.mission.findMany({
        where: { familyId, source: 'SYSTEM', deletedAt: null },
      })
    ).map((item) => item.templateId);
    const availableId = swapTemplateIds.find(
      (id) => !currentTemplates.includes(id),
    )!;
    let own = await prisma.mission.create({
      data: {
        familyId,
        ownerKind: 'PARENT',
        ownerUserId: parentA,
        boardDate: new Date(`${today()}T00:00:00Z`),
        source: 'SYSTEM',
        templateId: availableId,
        title: 'Synthetic swappable',
        category: 'CARE',
        targetScope: 'FAMILY',
        hearts: 5,
      },
    });
    expect(
      code(
        await action(own.id, 'swap', parentA, {
          templateId: swapTemplateIds[0],
          optionsToken: randomUUID(),
        }).expect(422),
      ),
    ).toBe('MISSION_SWAP_NOT_ALLOWED');
    const stale = data<{
      options: MissionTemplateView[];
      optionsToken: string;
    }>(
      await call('get', parentA, `/missions/${own.id}/swap-options`).expect(
        200,
      ),
    );
    expect(stale.options.length).toBeGreaterThan(0);
    own = await prisma.mission.update({
      where: { id: own.id },
      data: { version: { increment: 1 } },
    });
    expect(
      code(
        await action(own.id, 'swap', parentA, {
          templateId: stale.options[0]!.id,
          optionsToken: stale.optionsToken,
        }).expect(422),
      ),
    ).toBe('MISSION_SWAP_NOT_ALLOWED');
    for (let count = 0; count < 3; count++) {
      const options = data<{
        options: MissionTemplateView[];
        optionsToken: string;
        swapsLeft: number;
      }>(
        await call('get', parentA, `/missions/${own.id}/swap-options`).expect(
          200,
        ),
      );
      expect(options.swapsLeft).toBe(3 - count);
      expect(options.options.length).toBeGreaterThan(0);
      expect(options.options.length).toBeLessThanOrEqual(3);
      expect(
        options.options.every(
          (item) => Math.abs(item.hearts - own.hearts) <= 1,
        ),
      ).toBe(true);
      const oldId = own.id;
      const swapped = data<{ removedId: string; mission: MyMissionDto }>(
        await action(own.id, 'swap', parentA, {
          templateId: options.options[0]!.id,
          optionsToken: options.optionsToken,
        }).expect(201),
      );
      expect(swapped.removedId).toBe(oldId);
      const replacement = swapped.mission;
      expect(replacement.id).not.toBe(oldId);
      expect(
        await prisma.mission.findUniqueOrThrow({ where: { id: oldId } }),
      ).toMatchObject({
        status: 'REMOVED',
        removedReason: 'SWAPPED',
        deletedAt: expect.any(Date),
      });
      await call('get', parentA, `/missions/${oldId}`).expect(404);
      own = await prisma.mission.findUniqueOrThrow({
        where: { id: replacement.id },
      });
    }
    expect(
      code(
        await call('get', parentA, `/missions/${own.id}/swap-options`).expect(
          422,
        ),
      ),
    ).toBe('MISSION_SWAP_LIMIT');
    expect(
      code(
        await action(own.id, 'swap', parentA, {
          templateId: swapTemplateIds[0],
          optionsToken: randomUUID(),
        }).expect(422),
      ),
    ).toBe('MISSION_SWAP_LIMIT');
    expect((await board()).swapsLeft).toBe(0);
  });

  it('soft-removes missions without Hearts and excludes them from reads', async () => {
    const own = await created();
    expect(missionData(await action(own.id, 'remove').expect(201)).status).toBe(
      'REMOVED',
    );
    expect(
      await prisma.mission.findUniqueOrThrow({ where: { id: own.id } }),
    ).toMatchObject({
      deletedAt: expect.any(Date),
      removedAt: expect.any(Date),
    });
    expect((await board()).items.map((item) => item.id)).not.toContain(own.id);
    await call('get', parentA, `/missions/${own.id}`).expect(404);
    expect(await ledger()).toHaveLength(0);
    expect(
      await prisma.missionEvent.count({
        where: { familyId, missionId: own.id },
      }),
    ).toBe(2);
  });

  it('filters the template library and child board and supports dated custom missions', async () => {
    expect(code(await create(parentA, { date: day(61) }).expect(422))).toBe(
      'MISSION_DATE_INVALID',
    );
    const library = data<{ items: MissionTemplateView[] }>(
      await call(
        'get',
        parentA,
        `/missions/templates?familyId=${familyId}&category=CARE&childId=${childId}`,
      ).expect(200),
    );
    expect(library.items.length).toBeGreaterThan(0);
    expect(library.items.every((item) => item.category === 'CARE')).toBe(true);
    const own = await created({
      childIds: [childId],
      date: day(1),
      scheduledTime: '09:30',
    });
    expect(own).toMatchObject({
      boardDate: day(1),
      targetScope: 'CHILD',
      childIds: [childId],
      scheduledTime: '09:30:00',
    });
    expect(own.dueAt).toBe(`${day(1)}T02:30:00.000Z`);
    const filtered = await board(parentA, `?date=${day(1)}&childId=${childId}`);
    expect(filtered.items.map((item) => item.id)).toEqual([own.id]);
    expect(filtered.level).toBeNull();
    const libraryMission = await created({
      title: undefined,
      templateId: library.items[0]!.id,
      childIds: [childId],
      targetScope: 'CHILD',
    });
    expect(libraryMission.source).toBe('LIBRARY');
  });

  it('counts open requests without leaking their content', async () => {
    await call('post', parentA, `/families/${familyId}/us/requests`, {
      kind: 'TASK',
      title: 'Synthetic request not in board',
      dueKind: 'NOW',
    })
      .set('Idempotency-Key', randomUUID())
      .expect(201);
    const own = await board();
    expect(own.openRequestCount).toBe(1);
    expect(JSON.stringify(own)).not.toContain('Synthetic request not in board');
  });

  it('blocks Circle and outsiders from every mission route', async () => {
    const own = await created();
    for (const userId of [circle, outsider]) {
      await call('get', userId).expect(404);
      await call('get', userId, `/missions/${own.id}`).expect(404);
      await call(
        'get',
        userId,
        `/missions/templates?familyId=${familyId}`,
      ).expect(404);
      await call('get', userId, `/missions/${own.id}/swap-options`).expect(404);
      await create(userId).expect(404);
      for (const name of ['complete', 'undo', 'remove', 'swap']) {
        const body =
          name === 'swap'
            ? { templateId: swapTemplateIds[0], optionsToken: randomUUID() }
            : undefined;
        await action(own.id, name, userId, body).expect(404);
      }
    }
  });

  it('CARE-06 saves a DONE mission as one family moment, idempotently', async () => {
    const own = await created({ title: 'Đọc truyện trước khi ngủ' });
    const moment = (userId: string, key = randomUUID()) =>
      call('post', userId, `/missions/${own.id}/moment`, {
        body: 'Con nghe chăm chú',
      }).set('Idempotency-Key', key);
    const notDone = await moment(parentA).expect(409);
    expect(code(notDone)).toBe('MISSION_NOT_DONE');
    await action(own.id, 'complete').expect(201);
    const partner = await moment(parentB).expect(403);
    expect(code(partner)).toBe('MISSION_NOT_OWNER');
    expect((await moment(circle)).status).toBeGreaterThanOrEqual(403);
    const saved = await moment(parentA);
    expect(saved.status).toBe(201);
    const first = data<{ id: string; kind: string; title: string }>(saved);
    expect(first).toMatchObject({
      kind: 'MOMENT',
      title: 'Đọc truyện trước khi ngủ',
    });
    // A second save (new key) returns the moment already linked.
    const again = data<{ id: string }>(await moment(parentA).expect(201));
    expect(again.id).toBe(first.id);
    const completion = await prisma.missionCompletion.findFirst({
      where: { missionId: own.id, undoneAt: null, deletedAt: null },
    });
    expect(completion?.memoryId).toBe(first.id);
  });

  it('prepares the morning board once per family and date', async () => {
    // The job's hour/timezone gating is unit-tested; this checks the write path
    // on this family only (the job itself scans every ACTIVE family).
    const repository = app.get<IMissionBoardRepository>(
      MISSION_BOARD_REPOSITORY,
    );
    const boards = () =>
      prisma.dailyMissionBoard.count({
        where: { familyId, boardDate: new Date(`${today()}T00:00:00Z`) },
      });
    const missions = () =>
      prisma.mission.count({
        where: { familyId, boardDate: new Date(`${today()}T00:00:00Z`) },
      });
    const [first, second] = await Promise.all([
      repository.prepareBoard(familyId, today()),
      repository.prepareBoard(familyId, today()),
    ]);
    expect([first, second].filter(Boolean)).toHaveLength(1);
    expect(await boards()).toBe(1);
    const generated = await missions();
    expect(generated).toBeGreaterThan(0);
    // Opening the board afterwards reuses it instead of generating again.
    await board();
    expect(await missions()).toBe(generated);
    expect(await boards()).toBe(1);
  });

  it('materializes a repeating mission once a day, for its owner only', async () => {
    const weekdays = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
    const weekday = weekdays[new Date(`${today()}T00:00:00Z`).getUTCDay()];
    const other = weekday === 'MO' ? 'TU' : 'MO';
    const createSeries = (body: Record<string, unknown>, userId = parentA) =>
      call('post', userId, `/families/${familyId}/mission-series`, {
        owner: 'ME',
        startDate: today(),
        ...body,
      });
    const daily = data<{ id: string; days: string[] }>(
      await createSeries({
        title: 'Uống vitamin',
        scheduledTime: '08:30',
      }).expect(201),
    );
    expect(daily.days).toHaveLength(7);
    await createSeries({ title: 'Ngày khác', days: [other] }).expect(201);
    const invalid = await createSeries({
      title: 'Hôm qua',
      startDate: day(-1),
    }).expect(422);
    expect(code(invalid)).toBe('MISSION_SERIES_DATES_INVALID');

    await board();
    await board();
    const series = await prisma.mission.findMany({
      where: {
        familyId,
        source: 'SERIES',
        boardDate: new Date(`${today()}T00:00:00Z`),
      },
    });
    expect(series.map((row) => row.title)).toEqual(['Uống vitamin']);
    expect(series[0]).toMatchObject({ hearts: 2, ownerUserId: parentA });

    // The partner neither sees nor edits my series.
    const listed = data<{ items: { id: string }[] }>(
      await call('get', parentB, `/families/${familyId}/mission-series`).expect(
        200,
      ),
    );
    expect(listed.items).toHaveLength(0);
    await call('post', parentB, `/mission-series/${daily.id}/pause`, {
      from: day(1),
      to: day(2),
    }).expect(404);
    const paused = data<{ pausedRanges: unknown[] }>(
      await call('post', parentA, `/mission-series/${daily.id}/pause`, {
        from: day(1),
        to: day(2),
      }).expect(200),
    );
    expect(paused.pausedRanges).toEqual([{ from: day(1), to: day(2) }]);

    // Ending the series removes today's TODO occurrence.
    await call('delete', parentA, `/mission-series/${daily.id}`).expect(204);
    const after = await prisma.mission.findFirstOrThrow({
      where: { id: series[0]!.id },
    });
    expect(after.status).toBe('REMOVED');
    expect(
      (await call('get', circle, `/families/${familyId}/mission-series`))
        .status,
    ).toBeGreaterThanOrEqual(403);
  });

  it('CARE-12 keeps the board level per family and preferences per Parent', async () => {
    const path = `/families/${familyId}/mission-settings`;
    const initial = data<{ boardLevel: string }>(
      await call('get', parentA, path).expect(200),
    );
    expect(initial.boardLevel).toBe('MEDIUM');
    await call('patch', parentB, path, { boardLevel: 'LIGHT' }).expect(200);
    await call('patch', parentA, `/families/${familyId}/mission-preferences`, {
      disabledCategories: ['PLAY'],
      boardPushTime: '06:30',
      eveningCarryOver: false,
    }).expect(200);
    const mine = data<Record<string, unknown>>(
      await call('get', parentA, path).expect(200),
    );
    expect(mine).toEqual({
      boardLevel: 'LIGHT',
      preferences: {
        disabledCategories: ['PLAY'],
        boardPushTime: '06:30',
        eveningCarryOver: false,
        defaultReminderMin: null,
      },
    });
    const partner = data<{ preferences: { disabledCategories: string[] } }>(
      await call('get', parentB, path).expect(200),
    );
    expect(partner.preferences.disabledCategories).toEqual([]);
    expect(
      (await call('patch', circle, path, { boardLevel: 'HEAVY' })).status,
    ).toBeGreaterThanOrEqual(403);
    // LIGHT = 2 system missions per Parent on a new board.
    await board();
    const systemA = await prisma.mission.count({
      where: {
        familyId,
        source: 'SYSTEM',
        ownerUserId: parentA,
        boardDate: new Date(`${today()}T00:00:00Z`),
      },
    });
    expect(systemA).toBe(2);
  });
});
