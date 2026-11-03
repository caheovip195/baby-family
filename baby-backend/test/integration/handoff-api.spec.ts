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

interface HandoffView {
  id: string;
  direction: 'SENT' | 'RECEIVED';
  childIds: string[];
  fedAt: string | null;
  sleptAt: string | null;
  note: string | null;
  requestId: string | null;
  acknowledgedAt: string | null;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** BF-20261028-007: Bàn giao ca giữa hai Parent. */
describe('Care handoff API (PostgreSQL + ES256)', () => {
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
  const base = () => `/api/v1/families/${familyId}/us/handoffs`;
  const send = (userId: string, body: object, key = randomUUID()) =>
    request(app.getHttpServer())
      .post(base())
      .set('Authorization', tokens.get(userId) ?? '')
      .set('Idempotency-Key', key)
      .send(body);
  const list = (userId: string) =>
    request(app.getHttpServer())
      .get(base())
      .set('Authorization', tokens.get(userId) ?? '');
  const ack = (userId: string, id: string) =>
    request(app.getHttpServer())
      .post(`${base()}/${id}/acknowledge`)
      .set('Authorization', tokens.get(userId) ?? '');
  async function clean() {
    await prisma.careHandoff.deleteMany({ where: { familyId } });
    await prisma.request.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Handoff integration requires a *_test database.');
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
        displayName: 'Synthetic handoff fixture',
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
        name: 'Synthetic handoff family',
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
        code: `HANDOFF_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic handoff plan' },
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
        name: 'Synthetic handoff child',
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

  it('hands the baby over to the partner once, with an encrypted note', async () => {
    const fedAt = new Date(Date.now() - 30 * 60_000).toISOString();
    const key = randomUUID();
    const body = {
      childIds: [childId],
      fedAt,
      note: '  Bé hơi quấy, đã uống thuốc hạ sốt lúc 2h  ',
    };
    const sent = data<HandoffView>(await send(parentA, body, key).expect(201));
    expect(sent).toMatchObject({
      direction: 'SENT',
      childIds: [childId],
      fedAt,
      note: 'Bé hơi quấy, đã uống thuốc hạ sốt lúc 2h',
      acknowledgedAt: null,
    });
    // Gửi lại (offline) cùng key: không tạo bản thứ hai.
    const replay = data<HandoffView>(
      await send(parentA, body, key).expect(201),
    );
    expect(replay.id).toBe(sent.id);
    const stored = await prisma.careHandoff.findUniqueOrThrow({
      where: { id: sent.id },
    });
    expect(Buffer.from(stored.noteEnc!).toString('utf8')).not.toContain(
      'thuốc',
    );
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: sent.id, eventType: 'us.handoff.created' },
      }),
    ).toBe(1);
    const received = data<HandoffView[]>(await list(parentB).expect(200));
    expect(received).toHaveLength(1);
    expect(received[0]).toMatchObject({
      id: sent.id,
      direction: 'RECEIVED',
      note: 'Bé hơi quấy, đã uống thuốc hạ sốt lúc 2h',
    });
    // Người gửi không tự “Đã nhận”.
    await ack(parentA, sent.id).expect(404);
    const acked = data<HandoffView>(await ack(parentB, sent.id).expect(200));
    expect(acked.acknowledgedAt).not.toBeNull();
    expect(
      data<HandoffView>(await ack(parentB, sent.id).expect(200)).acknowledgedAt,
    ).toBe(acked.acknowledgedAt);
  });

  it('validates times, children, the attached request and the content', async () => {
    await send(parentA, {}).expect(400);
    await send(parentA, { note: '   ' }).expect(400);
    expect(
      code(
        await send(parentA, {
          sleptAt: new Date(Date.now() + 3_600_000).toISOString(),
        }).expect(400),
      ),
    ).toBe('HANDOFF_TIME_INVALID');
    expect(
      code(
        await send(parentA, {
          sleptAt: new Date(Date.now() - 2 * 86_400_000).toISOString(),
        }).expect(400),
      ),
    ).toBe('HANDOFF_TIME_INVALID');
    await send(parentA, { note: 'x', childIds: [randomUUID()] }).expect(400);
    await send(parentA, { note: 'x', requestId: randomUUID() }).expect(400);
    await request(app.getHttpServer())
      .post(base())
      .set('Authorization', tokens.get(parentA) ?? '')
      .send({ note: 'x' })
      .expect(400);
    // Lời nhờ của chính tôi gửi bạn đời: gắn được.
    const own = await prisma.request.create({
      data: {
        familyId,
        coupleSpaceId,
        senderUserId: parentA,
        receiverUserId: parentB,
        kind: 'NEED',
        needCode: 'HUG',
        contentKey: randomBytes(32),
        status: 'SENT',
        expiresAt: future(),
      },
    });
    const linked = data<HandoffView>(
      await send(parentA, {
        note: 'Nhờ anh tắm cho con',
        requestId: own.id,
      }).expect(201),
    );
    expect(linked.requestId).toBe(own.id);
    await send(parentB, { note: 'x', requestId: own.id }).expect(400);
  });

  it('is only for the two parents', async () => {
    for (const viewer of [circle, granted, outsider]) {
      await list(viewer).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
      await send(viewer, { note: 'x' }).expect((response) =>
        expect([403, 404]).toContain(response.status),
      );
    }
  });
});
