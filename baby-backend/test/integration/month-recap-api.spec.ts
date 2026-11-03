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
import { monthStart } from '../../src/services/month-recap.service';

interface RecapView {
  childId: string;
  monthIndex: number;
  start: string;
  end: string;
  moments: number;
  firsts: number;
  voices: number;
  firstMemoryIds: string[];
  voiceMemoryIds: string[];
  currentPhoto: { memoryId: string; assetId: string } | null;
  previousPhoto: { memoryId: string; assetId: string } | null;
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

/** BF-20261027-003: REC-03 Tổng kết tháng tuổi. */
describe('Month recap API (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let birthDate: Date;
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
  const recap = (userId: string, query = '', id = childId) =>
    request(app.getHttpServer())
      .get(`/api/v1/children/${id}/month-recap${query}`)
      .set('Authorization', tokens.get(userId) ?? '');

  async function memory(
    kind: string,
    ageMonth: number | null,
    visibility = 'FAMILY',
  ): Promise<string> {
    const at = new Date();
    const row = await prisma.memory.create({
      data: {
        familyId,
        kind: kind as never,
        authorUserId: parentA,
        authorRole: 'PARENT',
        occurredAt: at,
        occurredLocalDate: new Date(`${localDay()}T00:00:00.000Z`),
        visibility: visibility as never,
        status: 'PUBLISHED',
        publishedAt: at,
      },
    });
    if (ageMonth !== null)
      await prisma.memoryChild.create({
        data: { memoryId: row.id, childId, familyId, ageMonth },
      });
    return row.id;
  }

  async function monthlyPhoto(monthIndex: number) {
    const memoryId = await memory('MONTHLY_PHOTO', null);
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
      data: { memoryId, assetId: asset.id, familyId, sortOrder: 0 },
    });
    await prisma.monthlyPhoto.create({
      data: {
        familyId,
        childId,
        monthIndex,
        memoryId,
        assetId: asset.id,
        setBy: parentA,
      },
    });
    return { memoryId, assetId: asset.id };
  }

  async function clean() {
    await prisma.monthlyPhoto.deleteMany({ where: { familyId } });
    await prisma.memoryAsset.deleteMany({ where: { familyId } });
    await prisma.memoryChild.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.asset.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Month recap integration requires a *_test database.');
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
        displayName: 'Synthetic month recap fixture',
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
        name: 'Synthetic month recap family',
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
        code: `MONTHRECAP_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic month recap plan' },
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
    birth.setUTCMonth(birth.getUTCMonth() - 2);
    birth.setUTCDate(birth.getUTCDate() - 5);
    if (birth.getUTCDate() > 28) birth.setUTCDate(28);
    birthDate = birth;
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic recap child',
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

  it('summarises the latest completed month of age with monthly photos', async () => {
    const first = await memory('MILESTONE', 1);
    const voice = await memory('VOICE', 1, 'PARENTS');
    await memory('MOMENT', 1);
    await memory('MOMENT', 0);
    const current = await monthlyPhoto(2);
    const previous = await monthlyPhoto(1);

    const view = data<RecapView>(await recap(parentB).expect(200));
    expect(view).toMatchObject({
      childId,
      monthIndex: 2,
      moments: 3,
      firsts: 1,
      voices: 1,
      firstMemoryIds: [first],
      voiceMemoryIds: [voice],
      currentPhoto: current,
      previousPhoto: previous,
    });
    expect(view.start).toBe(
      monthStart(birthDate, 1).toISOString().slice(0, 10),
    );
    const end = monthStart(birthDate, 2);
    end.setUTCDate(end.getUTCDate() - 1);
    expect(view.end).toBe(end.toISOString().slice(0, 10));

    // Tháng 1: chỉ ký ức của tháng đầu, ảnh tháng 1, chưa có ảnh tháng 0.
    const month1 = data<RecapView>(
      await recap(parentA, '?monthIndex=1').expect(200),
    );
    expect(month1).toMatchObject({
      monthIndex: 1,
      moments: 1,
      firsts: 0,
      currentPhoto: previous,
      previousPhoto: null,
    });
  });

  it('follows the viewer ACL and rejects months that are not complete', async () => {
    await memory('MILESTONE', 1);
    await memory('VOICE', 1, 'PARENTS');
    // Người thân được cấp bé: chỉ nội dung FAMILY.
    expect(data<RecapView>(await recap(granted).expect(200))).toMatchObject({
      moments: 1,
      firsts: 1,
      voices: 0,
    });
    expect(code(await recap(circle).expect(404))).toBe('NOT_FOUND');
    await recap(outsider).expect(404);
    await recap(parentA, '?monthIndex=3').expect(400);
    await recap(parentA, '?monthIndex=0').expect(400);
    await recap(parentA, '', randomUUID()).expect(404);
  });

  it('computes month starts like ageInMonths for end-of-month birthdays', () => {
    const born = new Date('2026-01-31T00:00:00.000Z');
    expect(monthStart(born, 1).toISOString().slice(0, 10)).toBe('2026-03-01');
    expect(monthStart(born, 2).toISOString().slice(0, 10)).toBe('2026-03-31');
    expect(monthStart(born, 0).toISOString().slice(0, 10)).toBe('2026-01-31');
  });
});
