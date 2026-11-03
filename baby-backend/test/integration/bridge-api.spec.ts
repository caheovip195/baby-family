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
import { BRIDGE_REPOSITORY } from '../../src/interfaces/repositories/bridge-repository.interface';
import type { IBridgeRepository } from '../../src/interfaces/repositories/bridge-repository.interface';

interface BridgeView {
  id: string;
  status: string;
  initiatorUserId: string;
  contentPurged: boolean;
  shares: {
    userId: string;
    feelings: string[];
    needs: string[];
    topic: string | null;
    message: string | null;
    understood: boolean;
  }[];
  nextStep: {
    code: string;
    text: string | null;
    agreedUserIds: string[];
  } | null;
  closeAgreedUserIds: string[];
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** BF-20261028-008: US-08…12 Cầu nối (không AI). */
describe('Bridge API (PostgreSQL + ES256)', () => {
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
  const base = () => `/api/v1/families/${familyId}/us/bridges`;
  const auth = (userId: string) => tokens.get(userId) ?? '';
  const share = (userId: string, body: object, key = randomUUID()) =>
    request(app.getHttpServer())
      .post(base())
      .set('Authorization', auth(userId))
      .set('Idempotency-Key', key)
      .send(body);
  const get = (userId: string, id = '') =>
    request(app.getHttpServer())
      .get(id ? `${base()}/${id}` : base())
      .set('Authorization', auth(userId));
  const act = (userId: string, id: string, action: string, body?: object) =>
    request(app.getHttpServer())
      .post(`${base()}/${id}/${action}`)
      .set('Authorization', auth(userId))
      .send(body ?? {});
  const next = (userId: string, id: string, body: object) =>
    request(app.getHttpServer())
      .put(`${base()}/${id}/next-step`)
      .set('Authorization', auth(userId))
      .send(body);
  async function clean() {
    await prisma.conflictConfirmation.deleteMany({ where: { familyId } });
    await prisma.conflictEntry.deleteMany({ where: { familyId } });
    await prisma.conflictSession.deleteMany({ where: { familyId } });
  }
  const invite = {
    feelings: ['exhausted'],
    needs: ['practical_help'],
    topic: 'Chia việc nhà',
    message: 'Em cần anh phụ tắm cho con buổi tối',
  };

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Bridge integration requires a *_test database.');
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
        displayName: 'Synthetic bridge fixture',
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
        name: 'Synthetic bridge family',
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
        code: `BRIDGE_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic bridge plan' },
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
        name: 'Synthetic bridge child',
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

  it('runs invite → both share → understood → next step → close, privately', async () => {
    const key = randomUUID();
    const created = data<BridgeView>(
      await share(parentA, invite, key).expect(201),
    );
    expect(created.status).toBe('INVITED');
    expect(
      data<BridgeView>(await share(parentA, invite, key).expect(201)).id,
    ).toBe(created.id);
    // Gửi lại khi phiên còn mở: vẫn đúng phiên đó (một phiên mở mỗi cặp).
    expect(data<BridgeView>(await share(parentA, invite).expect(201)).id).toBe(
      created.id,
    );
    const stored = await prisma.conflictEntry.findFirstOrThrow({
      where: { sessionId: created.id },
    });
    expect(Buffer.from(stored.sharedPointsEnc!).toString('utf8')).not.toContain(
      'tắm',
    );
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: created.id, eventType: 'us.bridge.invited' },
      }),
    ).toBe(1);
    const seen = data<BridgeView>(await get(parentB, created.id).expect(200));
    expect(seen.shares).toEqual([
      {
        userId: parentA,
        feelings: ['exhausted'],
        needs: ['practical_help'],
        topic: 'Chia việc nhà',
        message: 'Em cần anh phụ tắm cho con buổi tối',
        understood: false,
      },
    ]);
    // Bạn đời góp ý của mình → ACTIVE.
    const joined = data<BridgeView>(
      await share(parentB, {
        feelings: ['misunderstood'],
        needs: ['listened'],
      }).expect(201),
    );
    expect(joined).toMatchObject({ id: created.id, status: 'ACTIVE' });
    expect(joined.shares.map((item) => item.userId).sort()).toEqual(
      [parentA, parentB].sort(),
    );
    await act(parentA, created.id, 'understood').expect(200);
    expect(
      data<BridgeView>(await act(parentB, created.id, 'understood').expect(200))
        .status,
    ).toBe('NEXT_STEP');
    // “Mình cần nói rõ hơn” → người kia đọc lại.
    const clarified = data<BridgeView>(
      await act(parentA, created.id, 'clarify', {
        message: 'Chỉ cần 3 tối mỗi tuần',
      }).expect(200),
    );
    expect(clarified.status).toBe('ACTIVE');
    expect(
      clarified.shares.find((item) => item.userId === parentB)?.understood,
    ).toBe(false);
    await act(parentB, created.id, 'understood').expect(200);
    await act(parentA, created.id, 'understood').expect(200);
    await next(parentA, created.id, { code: 'custom' }).expect(400);
    await next(parentA, created.id, { code: 'fight_more' }).expect(400);
    const step = data<BridgeView>(
      await next(parentA, created.id, { code: 'talk_after_sleep' }).expect(200),
    );
    expect(step.nextStep).toMatchObject({
      code: 'talk_after_sleep',
      agreedUserIds: [parentA],
    });
    const agreed = data<BridgeView>(
      await act(parentB, created.id, 'confirm').expect(200),
    );
    expect(agreed.nextStep?.agreedUserIds.sort()).toEqual(
      [parentA, parentB].sort(),
    );
    expect(
      data<BridgeView>(await act(parentA, created.id, 'close').expect(200))
        .status,
    ).toBe('NEXT_STEP');
    const closed = data<BridgeView>(
      await act(parentB, created.id, 'close').expect(200),
    );
    expect(closed.status).toBe('CLOSED');
    expect(closed.shares).toHaveLength(2);
    expect(code(await act(parentA, created.id, 'pause').expect(409))).toBe(
      'BRIDGE_STATE_CONFLICT',
    );
  });

  it('joins and pauses without negative signals; only the partner joins', async () => {
    const created = data<BridgeView>(await share(parentA, invite).expect(201));
    await act(parentA, created.id, 'join').expect(409);
    expect(
      data<BridgeView>(await act(parentB, created.id, 'join').expect(200))
        .status,
    ).toBe('ACTIVE');
    expect(
      data<BridgeView>(await act(parentB, created.id, 'pause').expect(200))
        .status,
    ).toBe('PAUSED');
    expect(
      data<BridgeView>(await act(parentB, created.id, 'join').expect(200))
        .status,
    ).toBe('ACTIVE');
    // Chỉ “Mình hiểu” khi chưa góp ý vẫn được (tạo ý trống).
    await act(parentB, created.id, 'understood').expect(200);
  });

  it('erases shared content right away when the retention is 0, and expires idle sessions', async () => {
    const created = data<BridgeView>(
      await share(parentA, { ...invite, retentionDays: 0 }).expect(201),
    );
    await act(parentB, created.id, 'join').expect(200);
    await act(parentA, created.id, 'close').expect(200);
    const closed = data<BridgeView>(
      await act(parentB, created.id, 'close').expect(200),
    );
    expect(closed).toMatchObject({
      status: 'CLOSED',
      contentPurged: true,
      shares: [],
      nextStep: null,
    });
    const rows = await prisma.conflictEntry.findMany({
      where: { sessionId: created.id },
    });
    expect(
      rows.every(
        (row) => row.deletedAt !== null && row.sharedPointsEnc === null,
      ),
    ).toBe(true);

    const idle = data<BridgeView>(await share(parentA, invite).expect(201));
    await prisma.conflictSession.update({
      where: { id: idle.id },
      data: { lastActivityAt: new Date(Date.now() - 15 * 86_400_000) },
    });
    const list = data<BridgeView[]>(await get(parentA).expect(200));
    expect(list.find((item) => item.id === idle.id)?.status).toBe('EXPIRED');
    // Phiên hết hạn → được mời phiên mới.
    await share(parentA, invite).expect(201);
  });

  it('BF-20261028-009: the scheduled housekeeping erases content after the retention period', async () => {
    const created = data<BridgeView>(
      await share(parentA, { ...invite, retentionDays: 7 }).expect(201),
    );
    await act(parentB, created.id, 'join').expect(200);
    await act(parentA, created.id, 'close').expect(200);
    await act(parentB, created.id, 'close').expect(200);
    const repository = app.get<IBridgeRepository>(BRIDGE_REPOSITORY);
    // Chưa tới hạn: còn nội dung.
    await repository.housekeep(null, new Date());
    expect(
      data<BridgeView>(await get(parentA, created.id).expect(200)).shares,
    ).toHaveLength(1);
    const later = new Date(Date.now() + 8 * 86_400_000);
    const result = await repository.housekeep(null, later);
    expect(result.purged).toBeGreaterThanOrEqual(1);
    const rows = await prisma.conflictEntry.findMany({
      where: { sessionId: created.id },
    });
    expect(
      rows.every(
        (row) => row.deletedAt !== null && row.sharedPointsEnc === null,
      ),
    ).toBe(true);
  });

  it('validates choices and keeps the bridge between the two parents', async () => {
    await share(parentA, { feelings: [], needs: [] }).expect(400);
    await share(parentA, { feelings: ['furious'], needs: [] }).expect(400);
    await share(parentA, { ...invite, retentionDays: 5 }).expect(400);
    for (const viewer of [circle, granted, outsider]) {
      await get(viewer).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
      await share(viewer, invite).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
    }
    await get(parentA, randomUUID()).expect(404);
  });
});
