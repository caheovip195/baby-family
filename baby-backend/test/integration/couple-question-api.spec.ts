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
import {
  localDay,
  zonedMidnight,
} from '../../src/services/couple-question.service';

interface QuestionView {
  date: string;
  code: string;
  textI18n: Record<string, string>;
  myAnswer: string | null;
  partnerAnswered: boolean;
  partnerAnswer: string | null;
}
interface WeekView {
  weekStart: string;
  weekEnd: string;
  checkins: number;
  requestsHelped: number;
  thanks: number;
  togetherMissions: number;
  together: { title: string; date: string }[];
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** BF-20261027-002: Câu hỏi kết nối + US-14 Tuần của hai ta. */
describe('Couple question & week API (PostgreSQL + ES256)', () => {
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
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);
  function call(
    method: 'get' | 'put',
    userId: string,
    route: string,
    body?: Record<string, unknown>,
  ) {
    const client = request(app.getHttpServer());
    const result = client[method](
      `/api/v1/families/${familyId}/us${route}`,
    ).set('Authorization', tokens.get(userId) ?? '');
    return body === undefined ? result : result.send(body);
  }
  const today = async (userId: string) =>
    data<QuestionView>(
      await call('get', userId, '/question/today').expect(200),
    );
  const answer = (userId: string, text: unknown) =>
    call('put', userId, '/question/today/answer', { answer: text });
  async function clean() {
    await prisma.connectionAnswer.deleteMany({ where: { familyId } });
    await prisma.missionCompletion.deleteMany({ where: { familyId } });
    await prisma.mission.deleteMany({ where: { familyId } });
    await prisma.request.deleteMany({ where: { familyId } });
    await prisma.appreciation.deleteMany({ where: { familyId } });
    await prisma.moodResponse.deleteMany({ where: { familyId } });
    await prisma.moodCheckin.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error(
        'Couple question integration requires a *_test database.',
      );
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
        displayName: 'Synthetic question fixture',
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
        name: 'Synthetic question family',
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
        code: `QUESTION_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic question plan' },
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
  });
  beforeEach(async () => {
    await clean();
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await clean();
        await prisma.outboxEvent.deleteMany({ where: { familyId } });
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

  it('gives both parents the same daily question and reveals answers only when both answered', async () => {
    const first = await today(parentA);
    const second = await today(parentB);
    expect(first.code).toBe(second.code);
    expect(first.textI18n.vi).toBeTruthy();
    expect(first.date).toBe(localDay(new Date(), 'Asia/Ho_Chi_Minh'));
    expect(first).toMatchObject({
      myAnswer: null,
      partnerAnswered: false,
      partnerAnswer: null,
    });

    const mine = data<QuestionView>(
      await answer(parentA, '  Con cười khi tắm  ').expect(200),
    );
    expect(mine).toMatchObject({
      myAnswer: 'Con cười khi tắm',
      partnerAnswered: false,
      partnerAnswer: null,
    });
    // B chưa trả lời: biết A đã trả lời nhưng không đọc được nội dung.
    expect(await today(parentB)).toMatchObject({
      myAnswer: null,
      partnerAnswered: true,
      partnerAnswer: null,
    });

    await answer(parentB, 'Cả nhà ăn tối cùng nhau').expect(200);
    expect(await today(parentA)).toMatchObject({
      myAnswer: 'Con cười khi tắm',
      partnerAnswer: 'Cả nhà ăn tối cùng nhau',
    });

    // Sửa trong ngày: vẫn một dòng mỗi người, nội dung được mã hoá.
    await answer(parentA, 'Con gọi Ba lần đầu').expect(200);
    expect((await today(parentB)).partnerAnswer).toBe('Con gọi Ba lần đầu');
    const rows = await prisma.connectionAnswer.findMany({
      where: { familyId },
    });
    expect(rows).toHaveLength(2);
    for (const row of rows)
      expect(Buffer.from(row.answerEnc).toString('utf8')).not.toContain('Con');
  });

  it('validates answers and hides the couple space from others', async () => {
    expect(code(await answer(parentA, '   ').expect(400))).toBe(
      'VALIDATION_ERROR',
    );
    expect(code(await answer(parentA, 'x'.repeat(501)).expect(400))).toBe(
      'VALIDATION_ERROR',
    );
    await call('get', circle, '/question/today').expect(404);
    await call('get', outsider, '/question/today').expect(404);
    await call('get', circle, '/week').expect(404);
  });

  it('counts the week of the two of us without per-person breakdown', async () => {
    const day = localDay(new Date(), 'Asia/Ho_Chi_Minh');
    const at = (offsetMs: number) =>
      new Date(zonedMidnight(day, 'Asia/Ho_Chi_Minh').getTime() + offsetMs);
    const hour = 3_600_000;
    const pair = { familyId, coupleSpaceId };
    await prisma.moodCheckin.createMany({
      data: [parentA, parentB].map((userId) => ({
        ...pair,
        userId,
        mood: 'TIRED',
        expiresAt: future(),
        createdAt: at(hour),
      })),
    });
    await prisma.appreciation.create({
      data: {
        ...pair,
        fromUserId: parentA,
        toUserId: parentB,
        bodyEnc: randomBytes(40),
        createdAt: at(2 * hour),
      },
    });
    await prisma.request.create({
      data: {
        ...pair,
        senderUserId: parentA,
        receiverUserId: parentB,
        kind: 'TASK',
        needCode: 'HELP_CHILD',
        contentKey: randomBytes(32),
        status: 'DONE',
        doneAt: at(3 * hour),
        expiresAt: future(),
      },
    });
    await prisma.request.create({
      data: {
        ...pair,
        senderUserId: parentB,
        receiverUserId: parentA,
        kind: 'NEED',
        needCode: 'HUG',
        contentKey: randomBytes(32),
        status: 'ACKNOWLEDGED',
        respondedAt: at(3 * hour),
        expiresAt: future(),
      },
    });
    const together = await prisma.mission.create({
      data: {
        familyId,
        boardDate: new Date(`${day}T00:00:00.000Z`),
        ownerKind: 'TOGETHER',
        source: 'CUSTOM',
        title: 'Tắm cho con cùng nhau',
        category: 'CARE',
        targetScope: 'FAMILY',
        hearts: 2,
        createdBy: parentA,
        status: 'DONE',
        completedAt: at(4 * hour),
        completedBy: parentA,
      },
    });
    await prisma.missionCompletion.create({
      data: {
        familyId,
        missionId: together.id,
        completedBy: parentA,
        idempotencyKey: randomUUID(),
        completedAt: at(4 * hour),
      },
    });
    const week = data<WeekView>(
      await call('get', parentB, '/week').expect(200),
    );
    expect(week).toMatchObject({
      checkins: 2,
      requestsHelped: 2,
      thanks: 1,
      togetherMissions: 1,
    });
    expect(week.together.map((item) => item.title)).toEqual([
      'Tắm cho con cùng nhau',
    ]);
    expect(JSON.stringify(week)).not.toContain(parentA);
    expect(JSON.stringify(week)).not.toContain(parentB);

    // Tuần trước: không có gì; thứ Hai sai / tương lai bị từ chối.
    const lastMonday = new Date(`${week.weekStart}T00:00:00.000Z`);
    lastMonday.setUTCDate(lastMonday.getUTCDate() - 7);
    const previous = data<WeekView>(
      await call(
        'get',
        parentA,
        `/week?weekStart=${lastMonday.toISOString().slice(0, 10)}`,
      ).expect(200),
    );
    expect(previous).toMatchObject({ checkins: 0, togetherMissions: 0 });
    const tuesday = new Date(lastMonday);
    tuesday.setUTCDate(tuesday.getUTCDate() + 1);
    await call(
      'get',
      parentA,
      `/week?weekStart=${tuesday.toISOString().slice(0, 10)}`,
    ).expect(400);
    const nextMonday = new Date(`${week.weekStart}T00:00:00.000Z`);
    nextMonday.setUTCDate(nextMonday.getUTCDate() + 7);
    await call(
      'get',
      parentA,
      `/week?weekStart=${nextMonday.toISOString().slice(0, 10)}`,
    ).expect(400);
  });

  it('computes local midnight across time zones', () => {
    expect(zonedMidnight('2026-10-26', 'Asia/Ho_Chi_Minh').toISOString()).toBe(
      '2026-10-25T17:00:00.000Z',
    );
    expect(zonedMidnight('2026-11-02', 'America/New_York').toISOString()).toBe(
      '2026-11-02T05:00:00.000Z',
    );
  });
});
