import { randomBytes, randomUUID } from 'node:crypto';
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
import { CareBadgeSeedRepository } from '../../src/repositories/care-badge-seed.repository';
import type { HeartsMeResponseDto } from '../../src/dto/care/hearts-me.dto';
import type { FamilyTreeResponseDto } from '../../src/dto/care/family-tree.dto';
import type { CareBadgesResponseDto } from '../../src/dto/care/care-badge.dto';
import type { CareMissionHistoryResponseDto } from '../../src/dto/care/care-mission-history.dto';
import type {
  PartnerMissionDto,
  MyMissionDto,
} from '../../src/dto/mission/mission.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;

describe('Care progress API (Hearts, Family tree, Badges, Mission history)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;

  const parentA = randomUUID();
  const parentB = randomUUID();
  const circle = randomUUID();
  const outsider = randomUUID();
  const revParentA = randomUUID();
  const revParentB = randomUUID();
  const users = [parentA, parentB, circle, outsider, revParentA, revParentB];
  const sessions = new Map(users.map((id) => [id, randomUUID()]));
  const tokens = new Map<string, string>();

  const familyId = randomUUID();
  const coupleSpaceId = randomUUID();
  const planId = randomUUID();
  const planVersionId = randomUUID();
  const licenseId = randomUUID();
  const childId = randomUUID();
  const revFamilyId = randomUUID();
  const revCoupleSpaceId = randomUUID();
  const revLicenseId = randomUUID();

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
    method: 'get' | 'post',
    userId: string,
    route: string,
    body?: Record<string, unknown>,
  ) {
    const client = request(app.getHttpServer());
    const req = client[method](`/api/v1${route}`).set(
      'Authorization',
      tokens.get(userId) ?? '',
    );
    return body === undefined ? req : req.send(body);
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test')) {
      throw new Error('Integration tests require a *_test database.');
    }

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
        displayName: 'Care progress fixture user',
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
        name: 'Care Progress Family',
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
        callName: 'Ba',
      },
    });
    const b = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mẹ',
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
        displayName: 'Caregiver Circle',
        invitedBy: parentA,
      },
    });

    await prisma.plan.create({
      data: {
        id: planId,
        code: `CARE_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Care Plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: {},
        features: {},
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
        name: 'Bé Mầm',
        birthDate: new Date(Date.now() - 100 * 86_400_000),
        colorIndex: 1,
        createdBy: parentA,
      },
    });

    // Secondary isolated family for clean reversal test
    await prisma.family.create({
      data: {
        id: revFamilyId,
        name: 'Rev Family',
        createdBy: revParentA,
        status: 'ACTIVE',
        activatedAt: past(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    const revA = await prisma.familyParent.create({
      data: {
        familyId: revFamilyId,
        userId: revParentA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Ba Rev',
      },
    });
    const revB = await prisma.familyParent.create({
      data: {
        familyId: revFamilyId,
        userId: revParentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mẹ Rev',
      },
    });
    await prisma.coupleSpace.create({
      data: {
        id: revCoupleSpaceId,
        familyId: revFamilyId,
        parentAUserId: revParentA,
        parentBUserId: revParentB,
        parentAMembershipId: revA.id,
        parentBMembershipId: revB.id,
      },
    });
    await prisma.familyLicense.create({
      data: { id: revLicenseId, familyId: revFamilyId },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId: revFamilyId,
        licenseId: revLicenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });

    const badgeSeeder = new CareBadgeSeedRepository(prisma);
    await badgeSeeder.seedFromFile(
      join(process.cwd(), 'prisma/seeds/badges.json'),
    );
  });

  async function clearCareData() {
    await prisma.$transaction(async (tx) => {
      await tx.heartDailyCounter.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.missionEvent.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.missionCompletion.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.missionChild.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.mission.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.dailyMissionBoardParent.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.dailyMissionBoard.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.familyBadge.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
      await tx.familyTree.deleteMany({
        where: { familyId: { in: [familyId, revFamilyId] } },
      });
    });
  }

  beforeEach(clearCareData);

  afterAll(async () => {
    try {
      if (prisma) {
        await clearCareData();
        await prisma.child.deleteMany({ where: { familyId } });
        await prisma.coupleSpace.deleteMany({
          where: { familyId: { in: [familyId, revFamilyId] } },
        });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({
          where: { familyId: { in: [familyId, revFamilyId] } },
        });
        await prisma.familyParent.deleteMany({
          where: { familyId: { in: [familyId, revFamilyId] } },
        });
        await prisma.familyLicense.updateMany({
          where: { id: { in: [licenseId, revLicenseId] } },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: { in: [familyId, revFamilyId] } },
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
      await app?.close();
    }
  });

  describe('1. Hearts Ledger Privacy (H-01)', () => {
    it('returns caller ledger only, partner ledger never leaks', async () => {
      const todayDate = new Date(`${today()}T00:00:00Z`);

      // Ledger for ParentA: 2 entries = 10 + 5 = 15
      await prisma.heartLedger.create({
        data: {
          familyId,
          userId: parentA,
          sourceType: 'MISSION',
          sourceId: randomUUID(),
          reason: 'DAILY_MISSION',
          amount: 10,
          localDate: todayDate,
        },
      });
      await prisma.heartLedger.create({
        data: {
          familyId,
          userId: parentA,
          sourceType: 'PHOTO',
          sourceId: randomUUID(),
          reason: 'FIRST_MOMENTS',
          amount: 5,
          localDate: todayDate,
        },
      });

      // Ledger for ParentB: 1 entry = 25
      await prisma.heartLedger.create({
        data: {
          familyId,
          userId: parentB,
          sourceType: 'MISSION',
          sourceId: randomUUID(),
          reason: 'DAILY_MISSION',
          amount: 25,
          localDate: todayDate,
        },
      });

      // ParentA calls /hearts/me
      const resA = await call(
        'get',
        parentA,
        `/families/${familyId}/hearts/me`,
      ).expect(200);
      const dataA = data<HeartsMeResponseDto>(resA);
      expect(dataA.today).toBe(15);
      expect(dataA.week).toBe(15);
      expect(dataA.total).toBe(15);
      expect(dataA.dailyCap).toBe(75);
      expect(dataA.history).toHaveLength(2);
      expect(dataA.history.map((h) => h.amount)).toEqual([5, 10]); // newest first

      // ParentB calls /hearts/me
      const resB = await call(
        'get',
        parentB,
        `/families/${familyId}/hearts/me`,
      ).expect(200);
      const dataB = data<HeartsMeResponseDto>(resB);
      expect(dataB.today).toBe(25);
      expect(dataB.total).toBe(25);
      expect(dataB.history).toHaveLength(1);
      expect(dataB.history[0]?.amount).toBe(25);
    });

    it('rejects ?userId= query parameter with HTTP 400 (H-01)', async () => {
      await call(
        'get',
        parentA,
        `/families/${familyId}/hearts/me?userId=${parentB}`,
      ).expect(400);
    });

    it('rejects other hearts route like /families/:fid/hearts/:userId with HTTP 404', async () => {
      await call(
        'get',
        parentA,
        `/families/${familyId}/hearts/${parentB}`,
      ).expect(404);
    });

    it('handles reversals cleanly without displaying negative amounts in history', async () => {
      const todayDate = new Date(`${today()}T00:00:00Z`);
      const original = await prisma.heartLedger.create({
        data: {
          familyId: revFamilyId,
          userId: revParentA,
          sourceType: 'MISSION',
          sourceId: randomUUID(),
          reason: 'DAILY_MISSION',
          amount: 10,
          localDate: todayDate,
        },
      });
      // Reversal
      await prisma.heartLedger.create({
        data: {
          familyId: revFamilyId,
          userId: revParentA,
          sourceType: 'MISSION',
          sourceId: randomUUID(),
          reason: 'REVERSAL',
          amount: -10,
          reversalOf: original.id,
          localDate: todayDate,
        },
      });

      const res = await call(
        'get',
        revParentA,
        `/families/${revFamilyId}/hearts/me`,
      ).expect(200);
      const body = data<HeartsMeResponseDto>(res);
      expect(body.today).toBe(0);
      expect(body.total).toBe(0);
      // Reversed entry net is 0, so it is filtered out (no negative numbers shown)
      expect(body.history).toHaveLength(0);
    });
  });

  describe('2. Family Tree Privacy and Thresholds', () => {
    it('returns tree state without any Hearts numbers in the response', async () => {
      // Seed a FamilyTree row with totalHearts = 216 (Level 2: Mầm non, 100..300)
      await prisma.familyTree.create({
        data: {
          familyId,
          totalHearts: 216,
          level: 2,
          fruits: 0,
          flowers: 3,
        },
      });

      // Daily boards this week (Mon–Sun): on a Monday, "yesterday" is last week,
      // so the bloomed day is tomorrow instead.
      const isMonday = new Date(`${today()}T00:00:00Z`).getUTCDay() === 1;
      const bloomedDay = isMonday ? day(1) : day(-1);
      await prisma.dailyMissionBoard.create({
        data: {
          familyId,
          boardDate: new Date(`${bloomedDay}T00:00:00Z`),
          level: 'MEDIUM',
          perParentCount: 3,
          togetherCount: 1,
          balanceDiff: 0,
          generatorVersion: 1,
          seed: 12345n,
          bloomedAt: new Date(`${bloomedDay}T12:00:00Z`),
        },
      });
      await prisma.dailyMissionBoard.create({
        data: {
          familyId,
          boardDate: new Date(`${today()}T00:00:00Z`),
          level: 'MEDIUM',
          perParentCount: 3,
          togetherCount: 1,
          balanceDiff: 0,
          generatorVersion: 1,
          seed: 12346n,
          bloomedAt: null,
        },
      });

      const todayDate = new Date(`${today()}T00:00:00Z`);
      await prisma.mission.create({
        data: {
          familyId,
          boardDate: todayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentA,
          source: 'CUSTOM',
          title: 'Mission 1',
          category: 'CARE',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'DONE',
          completedBy: parentA,
          completedAt: new Date(),
          createdBy: parentA,
        },
      });
      await prisma.mission.create({
        data: {
          familyId,
          boardDate: todayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentA,
          source: 'CUSTOM',
          title: 'Mission 2',
          category: 'PLAY',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'TODO',
          createdBy: parentA,
        },
      });
      await prisma.mission.create({
        data: {
          familyId,
          boardDate: todayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentB,
          source: 'CUSTOM',
          title: 'Mission 3',
          category: 'PREP',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'TODO',
          createdBy: parentB,
        },
      });

      const res = await call(
        'get',
        parentA,
        `/families/${familyId}/family-tree`,
      ).expect(200);
      const tree = data<FamilyTreeResponseDto>(res);

      expect(tree.level).toBe(2);
      expect(tree.levelName).toBe('Mầm non');
      expect(typeof tree.progressPercent).toBe('number');
      expect(Number.isInteger(tree.progressPercent)).toBe(true);
      // Progress in level 2 (span 200..800 -> span 600, 550 - 200 = 350. 350/600 = 58.33% -> floor 58)
      expect(tree.progressPercent).toBe(58);
      expect(tree.flowers).toBe(3);
      expect(tree.fruits).toBe(0);
      expect(tree.bloomedDaysThisWeek).toBe(1);
      expect(tree.today).toEqual({
        leaves: 1,
        total: 3,
        bloomed: false,
      });

      // Strict privacy assertion: NO hearts property anywhere in response
      const rawJson = JSON.stringify(res.body);
      expect(rawJson).not.toMatch(/"hearts"/i);
      expect(rawJson).not.toMatch(/"totalHearts"/i);
      expect(
        (tree as unknown as Record<string, unknown>).totalHearts,
      ).toBeUndefined();
      expect(
        (tree as unknown as Record<string, unknown>).hearts,
      ).toBeUndefined();
    });

    it('defaults gracefully when family_trees row does not exist yet', async () => {
      const res = await call(
        'get',
        parentB,
        `/families/${familyId}/family-tree`,
      ).expect(200);
      const tree = data<FamilyTreeResponseDto>(res);
      expect(tree.level).toBe(1);
      expect(tree.levelName).toBe('Hạt mầm');
      expect(tree.progressPercent).toBe(0);
      expect(tree.fruits).toBe(0);
      expect(tree.flowers).toBe(0);
      expect(tree.bloomedDaysThisWeek).toBe(0);
      expect(tree.today.bloomed).toBe(false);
    });
  });

  describe('3. Badges Catalog & Evaluation', () => {
    it('returns earned badges first, then upcoming with integer progress', async () => {
      // Award one badge manually to FamilyBadge
      await prisma.familyBadge.create({
        data: {
          familyId,
          badgeCode: 'WARM_BEDTIME',
          subjectUserId: null,
          achievedAt: past(),
        },
      });

      const res = await call(
        'get',
        parentA,
        `/families/${familyId}/badges`,
      ).expect(200);
      const result = data<CareBadgesResponseDto>(res);

      expect(result.items.length).toBeGreaterThanOrEqual(1);

      // First badge must be the earned one
      const earned = result.items.filter((b) => b.achieved);
      const upcoming = result.items.filter((b) => !b.achieved);

      expect(earned).toHaveLength(1);
      expect(earned[0]?.code).toBe('WARM_BEDTIME');
      expect(earned[0]?.achievedAt).not.toBeNull();
      expect(earned[0]?.progress.percent).toBe(100);

      // Ensure ordering: earned badges appear before upcoming ones
      const firstUpcomingIndex = result.items.findIndex((b) => !b.achieved);
      if (firstUpcomingIndex !== -1) {
        expect(firstUpcomingIndex).toBeGreaterThanOrEqual(earned.length);
      }

      // Check an upcoming badge progress
      for (const badge of upcoming) {
        expect(badge.achieved).toBe(false);
        expect(badge.achievedAt).toBeNull();
        if (badge.progress) {
          expect(Number.isInteger(badge.progress.percent)).toBe(true);
          expect(badge.progress.percent).toBeGreaterThanOrEqual(0);
          expect(badge.progress.percent).toBeLessThanOrEqual(100);
        }
      }
    });
  });

  describe('4. Mission History (CARE-07/08 & Partner Privacy)', () => {
    it('rejects invalid date range (from > to or span > 92 days) with HTTP 400', async () => {
      // from > to
      await call(
        'get',
        parentA,
        `/families/${familyId}/missions?from=2026-10-18&to=2026-10-10`,
      ).expect(400);

      // span > 92 days
      await call(
        'get',
        parentA,
        `/families/${familyId}/missions?from=2026-01-01&to=2026-05-01`,
      ).expect(400);
    });

    it('returns own missions with hearts, and partner missions ONLY when DONE without hearts', async () => {
      const todayDate = new Date(`${today()}T00:00:00Z`);
      const yesterdayDate = new Date(`${day(-1)}T00:00:00Z`);

      // ParentA mission: DONE with hearts & note
      const m1 = await prisma.mission.create({
        data: {
          familyId,
          boardDate: todayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentA,
          source: 'CUSTOM',
          title: 'Cho con uống sữa sáng',
          category: 'CARE',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'DONE',
          completedBy: parentA,
          completedAt: new Date(),
          note: 'Bé uống hết 180ml',
          createdBy: parentA,
        },
      });

      // ParentA mission: TODO
      await prisma.mission.create({
        data: {
          familyId,
          boardDate: todayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentA,
          source: 'CUSTOM',
          title: 'Đọc truyện cho con',
          category: 'PLAY',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'TODO',
          createdBy: parentA,
        },
      });

      // ParentB mission: DONE
      const m3 = await prisma.mission.create({
        data: {
          familyId,
          boardDate: todayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentB,
          source: 'CUSTOM',
          title: 'Tắm cho bé buổi chiều',
          category: 'CARE',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'DONE',
          completedBy: parentB,
          completedAt: new Date(),
          note: 'Mẹ tắm nước ấm',
          createdBy: parentB,
        },
      });

      // ParentB mission: TODO (Partner should NOT see this in history)
      await prisma.mission.create({
        data: {
          familyId,
          boardDate: yesterdayDate,
          ownerKind: 'PARENT',
          ownerUserId: parentB,
          source: 'CUSTOM',
          title: 'Chuẩn bị quần áo cho bé',
          category: 'PREP',
          targetScope: 'FAMILY',
          hearts: 2,
          status: 'TODO',
          createdBy: parentB,
        },
      });

      // 1. ParentA queries owner=ME: returns both DONE and TODO with hearts
      const resMe = await call(
        'get',
        parentA,
        `/families/${familyId}/missions?owner=ME`,
      ).expect(200);
      const dataMe = data<CareMissionHistoryResponseDto>(resMe);
      expect(dataMe.items).toHaveLength(2);
      const meDone = dataMe.items.find((m) => m.id === m1.id) as MyMissionDto;
      expect(meDone).toBeDefined();
      expect(meDone.hearts).toBe(2);
      expect(meDone.note).toBe('Bé uống hết 180ml');

      // 2. ParentA queries owner=PARTNER: returns ONLY DONE, formatted as PartnerMissionDto (NO hearts, NO note)
      const resPartner = await call(
        'get',
        parentA,
        `/families/${familyId}/missions?owner=PARTNER`,
      ).expect(200);
      const dataPartner = data<CareMissionHistoryResponseDto>(resPartner);
      expect(dataPartner.items).toHaveLength(1);
      const partnerMission = dataPartner.items[0] as PartnerMissionDto;
      expect(partnerMission.id).toBe(m3.id);
      expect(partnerMission.title).toBe('Tắm cho bé buổi chiều');
      expect(partnerMission.status).toBe('DONE');
      // Partner mission privacy verification:
      expect(
        (partnerMission as unknown as Record<string, unknown>).hearts,
      ).toBeUndefined();
      expect(
        (partnerMission as unknown as Record<string, unknown>).note,
      ).toBeUndefined();
      expect(
        (partnerMission as unknown as Record<string, unknown>).source,
      ).toBeUndefined();
    });
  });

  describe('5. Access Control (Circle & Outsider)', () => {
    it('blocks Circle member with HTTP 403 or 404 on all care progress routes', async () => {
      const res1 = await call('get', circle, `/families/${familyId}/hearts/me`);
      expect([403, 404]).toContain(res1.status);

      const res2 = await call(
        'get',
        circle,
        `/families/${familyId}/family-tree`,
      );
      expect([403, 404]).toContain(res2.status);

      const res3 = await call('get', circle, `/families/${familyId}/badges`);
      expect([403, 404]).toContain(res3.status);

      const res4 = await call('get', circle, `/families/${familyId}/missions`);
      expect([403, 404]).toContain(res4.status);
    });

    it('blocks Outsider user on all care progress routes', async () => {
      // Non-member gets 403 or 404
      const res1 = await call(
        'get',
        outsider,
        `/families/${familyId}/hearts/me`,
      );
      expect([403, 404]).toContain(res1.status);

      const res2 = await call(
        'get',
        outsider,
        `/families/${familyId}/family-tree`,
      );
      expect([403, 404]).toContain(res2.status);

      const res3 = await call('get', outsider, `/families/${familyId}/badges`);
      expect([403, 404]).toContain(res3.status);

      const res4 = await call(
        'get',
        outsider,
        `/families/${familyId}/missions`,
      );
      expect([403, 404]).toContain(res4.status);
    });
  });
});
