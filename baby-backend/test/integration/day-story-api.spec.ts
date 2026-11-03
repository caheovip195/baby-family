import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';

interface StoryView {
  childId: string;
  date: string;
  memories: {
    memoryId: string;
    kind: string;
    title: string | null;
    assetIds: string[];
  }[];
  saved: {
    id: string;
    title: string;
    body: string | null;
    coverAssetId: string | null;
    memoryIds: string[];
    assetIds: string[];
    visibility: string;
  } | null;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const localDay = () =>
  new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Asia/Ho_Chi_Minh',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(new Date());

/** BF-20261028-006: REC-01 Câu chuyện ngày (không AI). */
describe('Day story API (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const parentA = randomUUID(),
    parentB = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID(),
    granted = randomUUID();
  const users = [parentA, parentB, circle, outsider, granted];
  const sessions = new Map(users.map((id) => [id, randomUUID()]));
  const tokens = new Map<string, string>();
  const familyId = randomUUID(),
    coupleSpaceId = randomUUID(),
    childId = randomUUID(),
    planId = randomUUID(),
    planVersionId = randomUUID(),
    licenseId = randomUUID();
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);
  const story = (userId: string, query = '') =>
    request(app.getHttpServer())
      .get(`/api/v1/children/${childId}/day-story${query}`)
      .set('Authorization', tokens.get(userId) ?? '');
  const save = (userId: string, day: string, body: object) =>
    request(app.getHttpServer())
      .put(`/api/v1/children/${childId}/day-story/${day}`)
      .set('Authorization', tokens.get(userId) ?? '')
      .send(body);
  const remove = (userId: string, day: string) =>
    request(app.getHttpServer())
      .delete(`/api/v1/children/${childId}/day-story/${day}`)
      .set('Authorization', tokens.get(userId) ?? '');

  async function memory(
    day: string,
    options: { visibility?: string; photo?: boolean; title?: string } = {},
  ) {
    const row = await prisma.memory.create({
      data: {
        familyId,
        kind: 'MOMENT',
        title: options.title ?? null,
        body: 'Một khoảnh khắc trong ngày',
        authorUserId: parentA,
        authorRole: 'PARENT',
        occurredAt: new Date(`${day}T03:00:00.000Z`),
        occurredLocalDate: new Date(`${day}T00:00:00.000Z`),
        visibility: (options.visibility ?? 'FAMILY') as never,
        status: 'PUBLISHED',
        publishedAt: new Date(),
      },
    });
    await prisma.memoryChild.create({
      data: { memoryId: row.id, childId, familyId, ageMonth: 1 },
    });
    let assetId: string | null = null;
    if (options.photo) {
      const asset = await prisma.asset.create({
        data: {
          familyId,
          uploaderUserId: parentA,
          kind: 'IMAGE',
          status: 'READY',
          storageKey: `fam/${familyId}/a/${randomUUID()}/orig`,
          mime: 'image/jpeg',
          declaredSize: 1000n,
        },
      });
      await prisma.memoryAsset.create({
        data: { memoryId: row.id, assetId: asset.id, familyId, sortOrder: 0 },
      });
      assetId = asset.id;
    }
    return { memoryId: row.id, assetId };
  }

  async function clean() {
    await prisma.dayStory.deleteMany({ where: { familyId } });
    await prisma.memoryAsset.deleteMany({ where: { familyId } });
    await prisma.memoryChild.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.asset.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Day story integration requires a *_test database.');
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
        displayName: 'Synthetic day story fixture',
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
        name: 'Synthetic day story family',
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
        code: `DAYSTORY_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic day story plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: {},
        features: { 'circle.enabled': true },
        availableFrom: past(),
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    const birth = new Date(`${localDay()}T00:00:00.000Z`);
    birth.setUTCMonth(birth.getUTCMonth() - 3);
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic day story child',
        birthDate: birth,
        colorIndex: 1,
        createdBy: parentA,
      },
    });
    const viewer = await prisma.circleMember.create({
      data: {
        familyId,
        userId: granted,
        relation: 'CAREGIVER',
        displayName: 'Synthetic granted relative',
        invitedBy: parentA,
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: viewer.id,
        childId,
        createdBy: parentA,
        permission: 'VIEW',
      },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });
  });
  beforeEach(async () => {
    await clean();
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await clean();
        await prisma.circleGrant.deleteMany({ where: { familyId } });
        await prisma.coupleSpace.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.child.updateMany({
          where: { familyId },
          data: { deletedAt: new Date() },
        });
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

  it('lists the day memories with photos and saves one story per day', async () => {
    const today = localDay();
    const a = await memory(today, { photo: true, title: 'Đi công viên' });
    const b = await memory(today, { photo: true });
    const c = await memory(today);
    const view = data<StoryView>(await story(parentA).expect(200));
    expect(view.date).toBe(today);
    expect(view.saved).toBeNull();
    expect(view.memories.map((m) => m.memoryId)).toEqual([
      a.memoryId,
      b.memoryId,
      c.memoryId,
    ]);
    expect(view.memories[0]).toMatchObject({
      title: 'Đi công viên',
      assetIds: [a.assetId],
    });
    const saved = data<{ id: string; coverAssetId: string }>(
      await save(parentA, today, {
        title: '  Ngày ở công viên ',
        body: 'Con chạy khắp nơi',
        memoryIds: [a.memoryId, c.memoryId],
        assetIds: [b.assetId, a.assetId],
        visibility: 'FAMILY',
      }).expect(200),
    );
    expect(saved.coverAssetId).toBe(b.assetId);
    const again = data<{ id: string; title: string }>(
      await save(parentB, today, {
        title: 'Ngày vui',
        memoryIds: [],
        assetIds: [a.assetId],
        coverAssetId: a.assetId,
        visibility: 'PARENTS',
      }).expect(200),
    );
    expect(again).toMatchObject({ id: saved.id, title: 'Ngày vui' });
    const after = data<StoryView>(
      await story(parentB, `?date=${today}`).expect(200),
    );
    expect(after.saved).toMatchObject({
      title: 'Ngày vui',
      assetIds: [a.assetId],
      visibility: 'PARENTS',
      body: null,
    });
    await remove(parentA, today).expect(204);
    expect(data<StoryView>(await story(parentA).expect(200)).saved).toBeNull();
  });

  it('only accepts photos and memories from that day and valid dates', async () => {
    const today = localDay();
    const yesterday = new Date(`${today}T00:00:00.000Z`);
    yesterday.setUTCDate(yesterday.getUTCDate() - 1);
    const other = await memory(yesterday.toISOString().slice(0, 10), {
      photo: true,
    });
    const mine = await memory(today, { photo: true });
    const base = {
      title: 'Hôm nay',
      memoryIds: [],
      assetIds: [],
      visibility: 'FAMILY',
    };
    await save(parentA, today, { ...base, assetIds: [other.assetId] }).expect(
      400,
    );
    await save(parentA, today, { ...base, memoryIds: [other.memoryId] }).expect(
      400,
    );
    await save(parentA, today, {
      ...base,
      assetIds: [mine.assetId],
      coverAssetId: other.assetId,
    }).expect(400);
    await save(parentA, today, { ...base, title: '   ' }).expect(400);
    await save(parentA, today, { ...base, visibility: 'PRIVATE' }).expect(400);
    const tomorrow = new Date(`${today}T00:00:00.000Z`);
    tomorrow.setUTCDate(tomorrow.getUTCDate() + 2);
    await save(parentA, tomorrow.toISOString().slice(0, 10), base).expect(400);
    await story(parentA, '?date=2026-02-30').expect(400);
    // Ngày trước: ký ức của đúng ngày đó.
    const before = data<StoryView>(
      await story(
        parentA,
        `?date=${yesterday.toISOString().slice(0, 10)}`,
      ).expect(200),
    );
    expect(before.memories.map((m) => m.memoryId)).toEqual([other.memoryId]);
  });

  it('is for parents only', async () => {
    await memory(localDay(), { photo: true });
    for (const viewer of [circle, granted, outsider]) {
      await story(viewer).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
      await save(viewer, localDay(), {
        title: 'x',
        memoryIds: [],
        assetIds: [],
        visibility: 'FAMILY',
      }).expect((response) => expect([403, 404]).toContain(response.status));
    }
  });
});
