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

interface GrowthView {
  childId: string;
  birthDate: string;
  items: {
    id: string;
    measuredOn: string;
    weightGrams: number | null;
    heightMm: number | null;
    note: string | null;
  }[];
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;
const localDay = () =>
  new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Asia/Ho_Chi_Minh',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(new Date());

/** BF-20261028-004: CHD-06 Tăng trưởng — chỉ Parent, mỗi ngày một lần đo. */
describe('Growth API (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let birthDate: string;
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
  const growth = (userId: string, id = childId) =>
    request(app.getHttpServer())
      .get(`/api/v1/children/${id}/growth`)
      .set('Authorization', tokens.get(userId) ?? '');
  const put = (userId: string, day: string, body: object) =>
    request(app.getHttpServer())
      .put(`/api/v1/children/${childId}/growth/${day}`)
      .set('Authorization', tokens.get(userId) ?? '')
      .send(body);
  const remove = (userId: string, day: string) =>
    request(app.getHttpServer())
      .delete(`/api/v1/children/${childId}/growth/${day}`)
      .set('Authorization', tokens.get(userId) ?? '');
  async function clean() {
    await prisma.growthMeasurement.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Growth integration requires a *_test database.');
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
        displayName: 'Synthetic growth fixture',
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
        name: 'Synthetic growth family',
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
        code: `GROWTH_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic growth plan' },
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
    birthDate = birth.toISOString().slice(0, 10);
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic growth child',
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

  it('records one measurement per day, overwrites it and lists oldest first', async () => {
    const today = localDay();
    await put(parentA, birthDate, { weightGrams: 3200, heightMm: 500 }).expect(
      200,
    );
    const first = data<{ id: string; createdBy: string }>(
      await put(parentA, today, {
        weightGrams: 5400,
        note: '  Khám tháng  ',
      }).expect(200),
    );
    expect(first.createdBy).toBe(parentA);
    // Parent kia ghi lại cùng ngày → đè (gửi lại khi offline an toàn).
    const again = data<{
      id: string;
      heightMm: number;
      weightGrams: number | null;
      note: string | null;
    }>(
      await put(parentB, today, { weightGrams: 5450, heightMm: 600 }).expect(
        200,
      ),
    );
    expect(again).toMatchObject({
      id: first.id,
      weightGrams: 5450,
      heightMm: 600,
      note: null,
    });
    const list = data<GrowthView>(await growth(parentB).expect(200));
    expect(list.birthDate).toBe(birthDate);
    expect(list.items.map((item) => item.measuredOn)).toEqual([
      birthDate,
      today,
    ]);
    expect(list.items[0]).toMatchObject({ weightGrams: 3200, heightMm: 500 });
    await remove(parentA, today).expect(204);
    await remove(parentA, today).expect(204);
    expect(
      data<GrowthView>(await growth(parentA).expect(200)).items,
    ).toHaveLength(1);
  });

  it('validates values and dates', async () => {
    const today = localDay();
    await put(parentA, today, {}).expect(400);
    await put(parentA, today, { weightGrams: 10 }).expect(400);
    await put(parentA, today, { heightMm: 9999 }).expect(400);
    await put(parentA, today, { weightGrams: 3000.5 }).expect(400);
    await put(parentA, '2026-02-30', { weightGrams: 3000 }).expect(400);
    const tomorrow = new Date(`${today}T00:00:00.000Z`);
    tomorrow.setUTCDate(tomorrow.getUTCDate() + 2);
    expect(
      code(
        await put(parentA, tomorrow.toISOString().slice(0, 10), {
          weightGrams: 3000,
        }).expect(400),
      ),
    ).toBe('GROWTH_DATE_INVALID');
    const before = new Date(`${birthDate}T00:00:00.000Z`);
    before.setUTCDate(before.getUTCDate() - 1);
    expect(
      code(
        await put(parentA, before.toISOString().slice(0, 10), {
          weightGrams: 3000,
        }).expect(400),
      ),
    ).toBe('GROWTH_DATE_INVALID');
  });

  it('is visible to parents only', async () => {
    await put(parentA, localDay(), { weightGrams: 6000 }).expect(200);
    for (const viewer of [circle, granted, outsider]) {
      await growth(viewer).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
      await put(viewer, localDay(), { weightGrams: 6100 }).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
    }
    await growth(parentA, randomUUID()).expect(404);
    expect(
      data<GrowthView>(await growth(parentA).expect(200)).items[0]?.weightGrams,
    ).toBe(6000);
  });
});
