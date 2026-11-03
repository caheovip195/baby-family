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
import { AI_PROVIDER } from '../../src/interfaces/services/ai-provider.interface';
import type { IAiProvider } from '../../src/interfaces/services/ai-provider.interface';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** Nhà cung cấp giả: trả JSON theo tính năng, ghi nội dung được gửi. */
const sent: string[] = [];
/** Câu trả lời ép cho các lần gọi tới (xếp hàng), rỗng = mặc định. */
const queued: string[] = [];
const provider: IAiProvider = {
  configured: () => true,
  model: () => 'openrouter/free',
  complete: ({ system, user }) => {
    sent.push(user);
    const answer =
      queued.shift() ??
      (system.includes('"suggestions"')
        ? '{"suggestions":["Nụ cười đầu","Buổi sáng vui","Con lớn rồi"]}'
        : system.includes('"story"')
          ? 'Đây: {"story":"Hôm nay con đi công viên và cười rất tươi."}'
          : system.includes('"neutral"')
            ? '{"neutral":"Em đang mệt, mình chia việc nhé.","warm":"Anh ơi, em cần anh một tay.","short":"Mình chia việc nhé."}'
            : system.includes('"picks"')
              ? '{"picks":[{"index":1,"reason":"Nhóm này tuần qua ít làm"},{"index":2,"reason":"Vui cho cả nhà"},{"index":99,"reason":"bịa"},{"index":1,"reason":"trùng"}]}'
              : '{"summary":"Một người đang kiệt sức và cần giúp đỡ thực tế."}');
    return Promise.resolve({
      text: answer,
      model: 'openrouter/free',
      inputTokens: 12,
      outputTokens: 34,
    });
  },
};

/** BF-20261028-010: AI 1.2 (OpenRouter) — quyền, đồng ý, hạn mức, an toàn. */
describe('AI API (PostgreSQL + ES256, fake provider)', () => {
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
  const localDay = () =>
    new Intl.DateTimeFormat('en-CA', {
      timeZone: 'Asia/Ho_Chi_Minh',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).format(new Date());
  const ai = (userId: string, path: string, body?: object) => {
    const client = request(app.getHttpServer());
    const url = `/api/v1/families/${familyId}/ai/${path}`;
    return body === undefined
      ? client.get(url).set('Authorization', tokens.get(userId) ?? '')
      : client
          .post(url)
          .set('Authorization', tokens.get(userId) ?? '')
          .send(body);
  };
  const consent = (userId: string, feature: string) =>
    ai(userId, 'consents', { feature }).expect(200);
  async function clean() {
    const reports = await prisma.report.findMany({
      where: { familyId },
      select: { id: true },
    });
    await prisma.moderationCaseReport.deleteMany({
      where: { reportId: { in: reports.map((row) => row.id) } },
    });
    await prisma.report.deleteMany({ where: { familyId } });
    await prisma.aiUsageReservation.deleteMany({ where: { familyId } });
    await prisma.aiInvocation.deleteMany({ where: { familyId } });
    await prisma.aiUsageMonthly.deleteMany({ where: { familyId } });
    await prisma.userConsent.deleteMany({ where: { userId: { in: users } } });
    await prisma.userSetting.deleteMany({ where: { userId: { in: users } } });
    await prisma.conflictConfirmation.deleteMany({ where: { familyId } });
    await prisma.conflictEntry.deleteMany({ where: { familyId } });
    await prisma.conflictSession.deleteMany({ where: { familyId } });
    await prisma.memoryChild.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    sent.length = 0;
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('AI integration requires a *_test database.');
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
      .overrideProvider(AI_PROVIDER)
      .useValue(provider)
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
        displayName: 'Synthetic AI fixture',
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
        name: 'Synthetic AI family',
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
        code: `AIPLAN_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic AI plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: { aiPerMonth: 3 },
        features: { 'circle.enabled': true, 'ai.enabled': true },
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
        name: 'Synthetic AI child',
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
        await prisma.userConsent.deleteMany({
          where: { userId: { in: users } },
        });
        await prisma.userSetting.deleteMany({
          where: { userId: { in: users } },
        });
        await prisma.outboxEvent.deleteMany({ where: { familyId } });
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

  it('needs consent per feature, suggests captions and logs metadata only', async () => {
    expect(
      data<{ available: boolean; total: number; consented: string[] }>(
        await ai(parentA, 'status').expect(200),
      ),
    ).toMatchObject({ available: true, total: 3, consented: [] });
    expect(
      code(
        await ai(parentA, 'captions', {
          kind: 'photo',
          hint: 'bé cười',
        }).expect(428),
      ),
    ).toBe('AI_CONSENT_REQUIRED');
    expect(
      data<{ consented: string[] }>(await consent(parentA, 'caption'))
        .consented,
    ).toEqual(['caption']);
    const result = data<{ suggestions: string[] }>(
      await ai(parentA, 'captions', { kind: 'photo', hint: 'bé cười' }).expect(
        200,
      ),
    );
    expect(result.suggestions).toHaveLength(3);
    expect(sent.at(-1)).toContain('bé cười');
    const invocations = await prisma.aiInvocation.findMany({
      where: { familyId },
    });
    expect(invocations).toHaveLength(1);
    expect(invocations[0]).toMatchObject({
      featureCode: 'caption',
      status: 'SUCCEEDED',
      inputTokens: 12,
      outputTokens: 34,
      modelId: 'openrouter/free',
    });
    expect(JSON.stringify(invocations[0])).not.toContain('bé cười');
    expect(
      data<{ used: number }>(await ai(parentA, 'status').expect(200)).used,
    ).toBe(1);
  });

  it('BF-20261028-011: only the requester can report an AI draft, with the text they saw', async () => {
    await consent(parentA, 'caption');
    const result = data<{ invocationId: string; suggestions: string[] }>(
      await ai(parentA, 'captions', { kind: 'photo' }).expect(200),
    );
    expect(result.invocationId).toMatch(/^[0-9a-f-]{36}$/);
    const report = (userId: string) =>
      request(app.getHttpServer())
        .post('/api/v1/reports')
        .set('Authorization', tokens.get(userId) ?? '')
        .send({
          familyId,
          targetType: 'AI_OUTPUT',
          targetId: result.invocationId,
          reason: 'AI_CONTENT',
          note: result.suggestions[0],
        });
    await report(parentB).expect(404);
    await report(parentA).expect(201);
    const stored = await prisma.report.findFirstOrThrow({
      where: { targetId: result.invocationId },
    });
    expect(stored).toMatchObject({
      targetType: 'AI_OUTPUT',
      reason: 'AI_CONTENT',
      targetOwnerId: null,
      detail: result.suggestions[0],
    });
    await prisma.moderationCaseReport.deleteMany({
      where: { reportId: stored.id },
    });
    await prisma.report.deleteMany({
      where: { targetId: result.invocationId },
    });
  });

  it('enforces the monthly quota, releases failed calls and never sends unsafe text', async () => {
    await consent(parentA, 'gentleRewrite');
    // Hai lần trả sai định dạng → 502, trả lại lượt.
    queued.push('không phải JSON', 'User Safety: safe');
    expect(
      code(
        await ai(parentA, 'rewrite', {
          text: 'Anh chẳng bao giờ giúp em',
        }).expect(502),
      ),
    ).toBe('AI_BAD_OUTPUT');
    expect(
      data<{ used: number }>(await ai(parentA, 'status').expect(200)).used,
    ).toBe(0);
    // Lần đầu rỗng, lần sau đúng → thành công, chỉ tính một lượt.
    queued.push('');
    await ai(parentA, 'rewrite', { text: 'Anh chẳng bao giờ giúp em' }).expect(
      200,
    );
    expect(
      data<{ used: number }>(await ai(parentA, 'status').expect(200)).used,
    ).toBe(1);

    for (let i = 0; i < 2; i += 1) {
      const rewrite = data<{ safety: boolean; warm: string }>(
        await ai(parentA, 'rewrite', {
          text: 'Anh chẳng bao giờ giúp em',
        }).expect(200),
      );
      expect(rewrite).toMatchObject({
        safety: false,
        warm: 'Anh ơi, em cần anh một tay.',
      });
    }
    expect(
      code(
        await ai(parentA, 'rewrite', {
          text: 'Anh chẳng bao giờ giúp em',
        }).expect(429),
      ),
    ).toBe('AI_QUOTA_EXCEEDED');
    const before = sent.length;
    const unsafe = data<{ safety: boolean; neutral: string | null }>(
      await ai(parentA, 'rewrite', { text: 'Em sợ anh sẽ đánh em' }).expect(
        200,
      ),
    );
    expect(unsafe).toEqual({
      invocationId: null,
      safety: true,
      neutral: null,
      warm: null,
      short: null,
    });
    expect(sent.length).toBe(before);
  });

  it('respects the user AI switches', async () => {
    await consent(parentB, 'caption');
    await prisma.userSetting.upsert({
      where: { userId: parentB },
      update: { aiFeatures: { caption: false } },
      create: { userId: parentB, aiFeatures: { caption: false } },
    });
    expect(code(await ai(parentB, 'captions', {}).expect(403))).toBe(
      'AI_DISABLED',
    );
    await prisma.userSetting.update({
      where: { userId: parentB },
      data: { aiEnabled: false, aiFeatures: {} },
    });
    expect(code(await ai(parentB, 'captions', {}).expect(403))).toBe(
      'AI_DISABLED',
    );
  });

  it('writes a day story only from the chosen memories', async () => {
    await consent(parentA, 'dailyStory');
    const day = localDay();
    const make = async (title: string) => {
      const row = await prisma.memory.create({
        data: {
          familyId,
          kind: 'MOMENT',
          title,
          authorUserId: parentA,
          authorRole: 'PARENT',
          occurredAt: new Date(`${day}T03:00:00.000Z`),
          occurredLocalDate: new Date(`${day}T00:00:00.000Z`),
          visibility: 'FAMILY',
          status: 'PUBLISHED',
          publishedAt: new Date(),
        },
      });
      await prisma.memoryChild.create({
        data: { memoryId: row.id, childId, familyId, ageMonth: 1 },
      });
      return row.id;
    };
    const park = await make('Đi công viên');
    await make('Bí mật không chọn');
    expect(
      code(
        await ai(parentA, 'day-story', {
          childId,
          date: day,
          memoryIds: [],
        }).expect(400),
      ),
    ).toBe('AI_INPUT_EMPTY');
    const story = data<{ story: string }>(
      await ai(parentA, 'day-story', {
        childId,
        date: day,
        memoryIds: [park],
      }).expect(200),
    );
    expect(story.story).toContain('công viên');
    expect(sent.at(-1)).toContain('Đi công viên');
    expect(sent.at(-1)).not.toContain('Bí mật');
  });

  it('summarises only what was shared in a bridge session', async () => {
    const invite = await request(app.getHttpServer())
      .post(`/api/v1/families/${familyId}/us/bridges`)
      .set('Authorization', tokens.get(parentA) ?? '')
      .set('Idempotency-Key', randomUUID())
      .send({
        feelings: ['exhausted'],
        needs: ['practical_help'],
        message: 'Em cần anh phụ buổi tối',
      })
      .expect(201);
    const sessionId = data<{ id: string }>(invite).id;
    await consent(parentB, 'bridgeSummary');
    const summary = data<{ summary: string }>(
      await ai(parentB, 'bridge-summary', { sessionId }).expect(200),
    );
    expect(summary.summary).toContain('kiệt sức');
    expect(sent.at(-1)).toContain('Em cần anh phụ buổi tối');
  });

  it('BF-20261028-012: suggests missions only from the real catalog', async () => {
    const codes = [0, 1, 2, 3].map((i) => `AIS${randomUUID().slice(0, 8)}${i}`);
    await prisma.missionTemplate.createMany({
      data: codes.map((code, i) => ({
        code,
        stage: 'ANY',
        category: i % 2 ? 'PLAY' : 'CARE',
        suggestedScope: 'FAMILY',
        roleFit: 'ANY_PARENT',
        hearts: 3,
        durationMin: 10,
        titleI18n: { vi: `Việc mẫu AI ${i}`, en: `AI sample ${i}` },
      })),
    });
    try {
      await consent(parentA, 'missionSuggest');
      const result = data<{
        invocationId: string;
        missions: { templateId: string; title: string; reason: string }[];
      }>(await ai(parentA, 'mission-suggestions', {}).expect(200));
      // Số thứ tự không có trong danh sách và lựa chọn trùng bị bỏ.
      expect(result.missions).toHaveLength(2);
      expect(result.missions[0]?.reason).toBe('Nhóm này tuần qua ít làm');
      const catalog = await request(app.getHttpServer())
        .get(`/api/v1/missions/templates?familyId=${familyId}`)
        .set('Authorization', tokens.get(parentA) ?? '')
        .expect(200);
      const ids = data<{ items: { id: string }[] }>(catalog).items.map(
        (item) => item.id,
      );
      for (const mission of result.missions)
        expect(ids).toContain(mission.templateId);
      expect(sent.at(-1)).toContain('Đã xong 14 ngày qua theo nhóm');
    } finally {
      await prisma.missionTemplate.deleteMany({
        where: { code: { in: codes } },
      });
    }
  });

  it('is for parents only', async () => {
    for (const viewer of [circle, granted, outsider]) {
      await ai(viewer, 'status').expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
      await ai(viewer, 'captions', {}).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
    }
  });
});
