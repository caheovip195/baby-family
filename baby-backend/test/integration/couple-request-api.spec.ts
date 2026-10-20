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
import type { CreateRequestDto } from '../../src/dto/us/request.dto';
import { requestDueAt } from '../../src/services/couple-request.service';

interface RequestView {
  id: string;
  status: string;
  title?: string;
  message?: string;
  dueAt: string | null;
  expiresAt: string;
  heartsAwarded?: number;
}
interface CreatedView {
  request: RequestView;
  openCount: number;
  openLimit: number;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Couple request API (PostgreSQL + ES256)', () => {
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
  const basePath = `/families/${familyId}/us/requests`;
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);
  function call(
    method: 'get' | 'post',
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
    return call('post', userId, basePath, {
      kind: 'TASK',
      title: 'Synthetic private request',
      dueKind: 'NOW',
      ...body,
    }).set('Idempotency-Key', key);
  }
  const action = (
    id: string,
    name: string,
    userId = parentB,
    body?: Record<string, unknown>,
  ) => call('post', userId, `${basePath}/${id}/${name}`, body);
  const created = async (
    body: Record<string, unknown> = {},
    userId = parentA,
  ) => data<CreatedView>(await create(userId, body).expect(201)).request;
  const detail = async (id: string, userId = parentA) =>
    data<RequestView>(
      await call('get', userId, `${basePath}/${id}`).expect(200),
    );
  const list = async (userId = parentA, query = '') =>
    data<{ items: RequestView[]; nextCursor: string | null }>(
      await call('get', userId, `${basePath}${query}`).expect(200),
    );
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Couple request integration requires a *_test database.');
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
        displayName: 'Synthetic request fixture',
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
        name: 'Synthetic request family',
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
        code: `REQUEST_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic request plan' },
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
  async function clearRequests() {
    await prisma.requestChild.deleteMany({ where: { familyId } });
    await prisma.request.deleteMany({ where: { familyId } });
    await prisma.idempotencyRecord.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
  }
  beforeEach(clearRequests);
  afterAll(async () => {
    try {
      if (prisma) {
        await clearRequests();
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

  it('creates encrypted requests and lists both directions with ids-only outbox events', async () => {
    const first = data<CreatedView>(
      await create(parentA, {
        message: 'Synthetic confidential message',
      }).expect(201),
    );
    expect(first).toMatchObject({
      openCount: 1,
      openLimit: 5,
      request: {
        status: 'SENT',
        title: 'Synthetic private request',
        message: 'Synthetic confidential message',
      },
    });
    expect(first.request).not.toHaveProperty('heartsAwarded');
    expect(
      new Date(first.request.expiresAt).getTime() -
        new Date(first.request.dueAt!).getTime(),
    ).toBe(2 * 3_600_000);
    const second = await created(
      { kind: 'NEED', needCode: 'HUG', title: undefined, dueKind: undefined },
      parentB,
    );
    expect(new Date(second.expiresAt).getTime()).toBeGreaterThan(
      Date.now() + 12 * 3_600_000 - 10_000,
    );
    for (const userId of [parentA, parentB]) {
      expect((await list(userId)).items.map((item) => item.id).sort()).toEqual(
        [first.request.id, second.id].sort(),
      );
      expect(await detail(first.request.id, userId)).toMatchObject({
        id: first.request.id,
        title: 'Synthetic private request',
      });
    }
    const row = await prisma.request.findUniqueOrThrow({
      where: { id: first.request.id },
    });
    expect(Buffer.from(row.titleEnc!).toString()).not.toContain(
      'Synthetic private request',
    );
    expect(Buffer.from(row.messageEnc!).toString()).not.toContain(
      'Synthetic confidential message',
    );
    const events = await prisma.outboxEvent.findMany({ where: { familyId } });
    expect(events).toHaveLength(2);
    for (const event of events) {
      expect(event.eventType).toMatch(/^us\.request\./);
      const payload = event.payload as Record<string, unknown>;
      expect(Object.keys(payload).length).toBeGreaterThan(0);
      for (const key of Object.keys(payload))
        expect(key).toMatch(/Id$|^status$/);
      expect(JSON.stringify(payload)).not.toContain('Synthetic');
    }
  });

  it('enforces five open requests per sender and releases capacity after cancellation', async () => {
    const ids: string[] = [];
    for (let index = 0; index < 5; index++)
      ids.push((await created({ title: `Synthetic task ${index}` })).id);
    expect(
      code(await create(parentA, { title: 'Sixth request' }).expect(422)),
    ).toBe('REQUEST_OPEN_LIMIT');
    await create(parentB).expect(201);
    await action(ids[0]!, 'cancel', parentA).expect(201);
    await create(parentA, { title: 'Replacement request' }).expect(201);
  });

  it('blocks the same content for twelve hours after decline', async () => {
    const own = await created();
    await action(own.id, 'decline', parentB, {
      reasonCode: 'NOT_TODAY',
    }).expect(201);
    const blocked = await create(parentA, {
      title: '  SYNTHETIC   PRIVATE REQUEST  ',
      message: 'Changed synthetic message',
      urgency: 'SOON',
    }).expect(422);
    expect(code(blocked)).toBe('REQUEST_RESEND_BLOCKED');
    const retryAfter = (
      blocked.body as { error: { details: { retryAfter: string } } }
    ).error.details.retryAfter;
    expect(new Date(retryAfter).toISOString()).toBe(retryAfter);
    expect(new Date(retryAfter).getTime()).toBeGreaterThan(
      Date.now() + 12 * 3_600_000 - 10_000,
    );
    await prisma.request.update({
      where: { id: own.id },
      data: { respondedAt: new Date(Date.now() - 12 * 3_600_000 - 1000) },
    });
    await create().expect(201);
  });

  it('requires Idempotency-Key and replays creation without duplicate records or events', async () => {
    await call('post', parentA, basePath, {
      kind: 'TASK',
      title: 'Synthetic task',
      dueKind: 'NOW',
    }).expect(400);
    const key = randomUUID();
    const first = data<CreatedView>(await create(parentA, {}, key).expect(201));
    expect(
      code(
        await create(
          parentA,
          { title: 'Different synthetic request' },
          key,
        ).expect(409),
      ),
    ).toBe('IDEMPOTENCY_KEY_REUSED');
    const replay = data<CreatedView>(
      await create(parentA, {}, key).expect(201),
    );
    expect(replay).toEqual(first);
    expect(await prisma.request.count({ where: { familyId } })).toBe(1);
    expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(1);
  });

  it.each(['SENT', 'SEEN'])(
    'supports accept, decline and NEED acknowledge from %s',
    async (initial) => {
      const accepted = await created({ title: 'Synthetic accepted task' });
      const declined = await created({ title: 'Synthetic declined task' });
      const acknowledged = await created({
        kind: 'NEED',
        needCode: 'HUG',
        title: undefined,
        dueKind: undefined,
      });
      for (const item of [accepted, declined, acknowledged]) {
        if (initial === 'SEEN')
          expect(
            data<RequestView>(await action(item.id, 'seen').expect(201)).status,
          ).toBe('SEEN');
      }
      expect(
        data<RequestView>(await action(accepted.id, 'accept').expect(201))
          .status,
      ).toBe('ACCEPTED');
      expect(
        data<RequestView>(await action(accepted.id, 'done').expect(201)).status,
      ).toBe('DONE');
      expect(
        data<RequestView>(await action(declined.id, 'decline').expect(201))
          .status,
      ).toBe('DECLINED');
      expect(
        data<RequestView>(
          await action(acknowledged.id, 'acknowledge', parentB, {
            type: 'HUG',
          }).expect(201),
        ).status,
      ).toBe('ACKNOWLEDGED');
      expect(code(await action(accepted.id, 'accept').expect(409))).toBe(
        'INVALID_REQUEST_TRANSITION',
      );
      expect(code(await action(acknowledged.id, 'done').expect(409))).toBe(
        'INVALID_REQUEST_TRANSITION',
      );
      expect(await prisma.mission.count({ where: { familyId } })).toBe(0);
    },
  );

  it.each(['SENT', 'SEEN', 'ACCEPTED'])(
    'allows one recipient reminder and sender cancellation from %s',
    async (initial) => {
      const own = await created();
      if (initial === 'SEEN') await action(own.id, 'seen').expect(201);
      if (initial === 'ACCEPTED') await action(own.id, 'accept').expect(201);
      const at = new Date(Date.now() + 30 * 60_000).toISOString();
      const reminded = data<RequestView>(
        await action(own.id, 'remind-me', parentB, { at }).expect(201),
      );
      expect(reminded.status).toBe(initial);
      expect(
        code(await action(own.id, 'remind-me', parentB, { at }).expect(409)),
      ).toBe('REQUEST_REMINDER_USED');
      expect(
        data<RequestView>(await action(own.id, 'cancel', parentA).expect(201))
          .status,
      ).toBe('CANCELLED');
      expect(
        code(await action(own.id, 'remind-me', parentB, { at }).expect(409)),
      ).toBe('INVALID_REQUEST_TRANSITION');
    },
  );

  it('rejects wrong participant roles and incompatible kind transitions', async () => {
    const own = await created();
    for (const name of [
      'seen',
      'accept',
      'decline',
      'done',
      'acknowledge',
      'remind-me',
    ]) {
      const body =
        name === 'acknowledge'
          ? { type: 'HUG' }
          : name === 'remind-me'
            ? { at: future().toISOString() }
            : undefined;
      expect(code(await action(own.id, name, parentA, body).expect(403))).toBe(
        'REQUEST_NOT_PARTICIPANT',
      );
    }
    expect(code(await action(own.id, 'cancel', parentB).expect(403))).toBe(
      'REQUEST_NOT_PARTICIPANT',
    );
    expect(code(await action(own.id, 'done').expect(409))).toBe(
      'INVALID_REQUEST_TRANSITION',
    );
    expect(
      code(
        await action(own.id, 'acknowledge', parentB, { type: 'HUG' }).expect(
          409,
        ),
      ),
    ).toBe('INVALID_REQUEST_TRANSITION');
    const need = await created({
      kind: 'NEED',
      needCode: 'HUG',
      title: undefined,
      dueKind: undefined,
    });
    expect(code(await action(need.id, 'accept').expect(409))).toBe(
      'INVALID_REQUEST_TRANSITION',
    );
  });

  it('hides all request routes from Circle and outsiders and excludes soft-deleted rows', async () => {
    const own = await created();
    for (const userId of [circle, outsider]) {
      await call('get', userId).expect(404);
      await call('get', userId, `${basePath}/${own.id}`).expect(404);
      await create(userId).expect(404);
      for (const name of [
        'seen',
        'accept',
        'decline',
        'done',
        'cancel',
        'acknowledge',
        'remind-me',
      ]) {
        const body =
          name === 'acknowledge'
            ? { type: 'HUG' }
            : name === 'remind-me'
              ? { at: future().toISOString() }
              : undefined;
        await action(own.id, name, userId, body).expect(404);
      }
    }
    await prisma.request.update({
      where: { id: own.id },
      data: { deletedAt: new Date() },
    });
    expect((await list()).items).toEqual([]);
    await call('get', parentB, `${basePath}/${own.id}`).expect(404);
    await action(own.id, 'accept').expect(404);
  });

  it.each(['SENT', 'SEEN', 'ACCEPTED'])(
    'lazily expires %s in reads and rejects later transitions',
    async (initial) => {
      const own = await created();
      if (initial === 'SEEN') await action(own.id, 'seen').expect(201);
      if (initial === 'ACCEPTED') await action(own.id, 'accept').expect(201);
      await prisma.request.update({
        where: { id: own.id },
        data: {
          createdAt: new Date(Date.now() - 3 * 3_600_000),
          dueAt: new Date(Date.now() - 3 * 3_600_000),
          expiresAt: past(),
        },
      });
      expect((await detail(own.id)).status).toBe('EXPIRED');
      expect((await list(parentB, '?box=OPEN')).items).toEqual([]);
      expect(
        code(
          await action(
            own.id,
            initial === 'ACCEPTED' ? 'done' : 'accept',
          ).expect(409),
        ),
      ).toBe('INVALID_REQUEST_TRANSITION');
      expect(
        (await prisma.request.findUniqueOrThrow({ where: { id: own.id } }))
          .status,
      ).toBe('EXPIRED');
    },
  );

  it('validates due dates and calculates explicit TASK deadlines', async () => {
    for (const dueAt of [
      'not-a-date',
      past().toISOString(),
      new Date(Date.now() + 8 * 86_400_000).toISOString(),
    ]) {
      expect(
        code(await create(parentA, { dueKind: 'TODAY_AT', dueAt }).expect(422)),
      ).toBe('REQUEST_DUE_INVALID');
    }
    expect(
      code(await create(parentA, { dueKind: 'TODAY_AT' }).expect(422)),
    ).toBe('REQUEST_DUE_INVALID');
    const dueAt = new Date(Date.now() + 30 * 60_000).toISOString();
    const own = await created({ dueKind: 'TODAY_AT', dueAt });
    expect(own.dueAt).toBe(dueAt);
    expect(new Date(own.expiresAt).getTime()).toBe(
      new Date(dueAt).getTime() + 2 * 3_600_000,
    );
  });
  it('awards five Hearts once, keeps them private and observes the daily cap', async () => {
    const own = await created();
    await action(own.id, 'accept').expect(201);
    const done = data<RequestView>(await action(own.id, 'done').expect(201));
    expect(done.heartsAwarded).toBe(5);
    expect(await detail(own.id, parentA)).not.toHaveProperty('heartsAwarded');
    expect((await detail(own.id, parentB)).heartsAwarded).toBe(5);
    expect(code(await action(own.id, 'done').expect(409))).toBe(
      'INVALID_REQUEST_TRANSITION',
    );
    const awards = await prisma.heartLedger.findMany({
      where: { familyId, sourceType: 'REQUEST', sourceId: own.id },
    });
    expect(awards).toHaveLength(1);
    expect(awards[0]).toMatchObject({
      userId: parentB,
      reason: 'REQUEST_DONE',
      amount: 5,
    });
    const counter = await prisma.heartDailyCounter.findFirstOrThrow({
      where: { familyId, userId: parentB },
    });
    await prisma.heartDailyCounter.update({
      where: {
        userId_localDate: { userId: parentB, localDate: counter.localDate },
      },
      data: { total: 73 },
    });
    const capped = await created({ title: 'Synthetic capped task' });
    await action(capped.id, 'accept').expect(201);
    expect(
      data<RequestView>(await action(capped.id, 'done').expect(201))
        .heartsAwarded,
    ).toBe(2);
    const full = await created({ title: 'Synthetic full cap task' });
    await action(full.id, 'accept').expect(201);
    expect(
      data<RequestView>(await action(full.id, 'done').expect(201))
        .heartsAwarded,
    ).toBe(0);
  });
  it('serializes concurrent creations under the five-open limit', async () => {
    const responses = await Promise.all(
      Array.from({ length: 7 }, (_, index) =>
        create(parentA, { title: `Concurrent synthetic ${index}` }),
      ),
    );
    expect(
      responses.filter((response) => response.status === 201),
    ).toHaveLength(5);
    const blocked = responses.filter((response) => response.status !== 201);
    expect(blocked).toHaveLength(2);
    for (const response of blocked) {
      expect(response.status).toBe(422);
      expect(code(response)).toBe('REQUEST_OPEN_LIMIT');
    }
    expect(await prisma.request.count({ where: { familyId } })).toBe(5);
  });

  it('filters list boxes and paginates without duplication', async () => {
    const outgoing = await created({ title: 'Synthetic outgoing' });
    const incoming = await created({ title: 'Synthetic incoming' }, parentB);
    const closed = await created({ title: 'Synthetic closed' });
    await action(closed.id, 'cancel', parentA).expect(201);
    expect(
      (await list(parentA, '?box=OPEN')).items.map((item) => item.id).sort(),
    ).toEqual([outgoing.id, incoming.id].sort());
    expect(
      (await list(parentA, '?box=SENT')).items.map((item) => item.id).sort(),
    ).toEqual([outgoing.id, closed.id].sort());
    expect(
      (await list(parentA, '?box=RECEIVED')).items.map((item) => item.id),
    ).toEqual([incoming.id]);
    expect(
      (await list(parentA, '?box=HISTORY')).items.map((item) => item.id),
    ).toEqual([closed.id]);
    const first = await list(parentA, '?limit=2');
    expect(first.items).toHaveLength(2);
    expect(first.nextCursor).toEqual(expect.any(String));
    const second = await list(parentA, `?limit=2&cursor=${first.nextCursor!}`);
    expect(second.items).toHaveLength(1);
    expect(second.nextCursor).toBeNull();
    expect(
      new Set([...first.items, ...second.items].map((item) => item.id)).size,
    ).toBe(3);
    expect(
      code(
        await call('get', parentA, `${basePath}?cursor=${randomUUID()}`).expect(
          400,
        ),
      ),
    ).toBe('REQUEST_CURSOR_INVALID');
  });

  it('commits lazy expiry when the first access is a rejected transition', async () => {
    const own = await created();
    await prisma.request.update({
      where: { id: own.id },
      data: {
        createdAt: new Date(Date.now() - 3 * 3_600_000),
        dueAt: new Date(Date.now() - 3 * 3_600_000),
        expiresAt: past(),
      },
    });
    expect(code(await action(own.id, 'accept').expect(409))).toBe(
      'INVALID_REQUEST_TRANSITION',
    );
    expect(
      (await prisma.request.findUniqueOrThrow({ where: { id: own.id } }))
        .status,
    ).toBe('EXPIRED');
  });
  it.each(['SEEN', 'HUG', 'TALK_TIME', 'ENCOURAGED'])(
    'acknowledges a NEED with %s without Hearts',
    async (type) => {
      const own = await created({
        kind: 'NEED',
        needCode: type === 'TALK_TIME' ? 'TALK' : 'HUG',
        title: undefined,
        dueKind: undefined,
      });
      const talkAt = new Date(Date.now() + 60 * 60_000).toISOString();
      expect(
        data<RequestView>(
          await action(own.id, 'acknowledge', parentB, {
            type,
            ...(type === 'TALK_TIME' ? { talkAt } : {}),
          }).expect(201),
        ),
      ).toMatchObject({ status: 'ACKNOWLEDGED', heartsAwarded: 0 });
      const row = await prisma.request.findUniqueOrThrow({
        where: { id: own.id },
      });
      expect(row.ackType).toBe(type);
      expect(row.talkAt?.toISOString() ?? null).toBe(
        type === 'TALK_TIME' ? talkAt : null,
      );
      expect(
        await prisma.heartLedger.count({
          where: { familyId, sourceId: own.id },
        }),
      ).toBe(0);
    },
  );

  it('bounds TALK_TIME by request creation plus seven days', async () => {
    // The DB audit trigger preserves created_at on UPDATE, so insert an older
    // synthetic NEED instead of attempting to rewrite its creation time.
    const own = await prisma.request.create({
      data: {
        familyId,
        coupleSpaceId,
        senderUserId: parentA,
        receiverUserId: parentB,
        kind: 'NEED',
        needCode: 'TALK',
        contentKey: randomBytes(32),
        createdAt: new Date(Date.now() - 60 * 60_000),
        expiresAt: new Date(Date.now() + 11 * 3_600_000),
      },
    });
    const talkAt = new Date(
      Date.now() + 7 * 86_400_000 - 30 * 60_000,
    ).toISOString();
    expect(
      code(
        await action(own.id, 'acknowledge', parentB, {
          type: 'TALK_TIME',
          talkAt,
        }).expect(422),
      ),
    ).toBe('REQUEST_DUE_INVALID');
  });
});

describe('Request due dates in family timezone', () => {
  function expectInvalid(callback: () => Date) {
    let thrown: unknown;
    try {
      callback();
    } catch (error) {
      thrown = error;
    }
    expect(thrown).toMatchObject({
      code: 'REQUEST_DUE_INVALID',
      statusCode: 422,
    });
  }
  const timezone = 'Asia/Ho_Chi_Minh';
  const now = new Date('2026-10-18T03:00:00.000Z');
  const due = (
    dueKind: CreateRequestDto['dueKind'],
    dueAt?: string,
    instant = now,
    zone = timezone,
  ) => requestDueAt({ kind: 'TASK', dueKind, dueAt }, instant, zone);

  it('uses send time for NOW and today or tomorrow local dates for explicit times', () => {
    expect(due('NOW')).toBe(now);
    expect(due('TODAY_AT', '2026-10-18T11:00:00+07:00').toISOString()).toBe(
      '2026-10-18T04:00:00.000Z',
    );
    expect(due('TOMORROW', '2026-10-19T14:00:00+07:00').toISOString()).toBe(
      '2026-10-19T07:00:00.000Z',
    );
  });

  it.each([
    ['NOW', '2026-10-18T04:00:00.000Z'],
    ['TODAY_AT', '2026-10-19T04:00:00.000Z'],
    ['TOMORROW', '2026-10-18T04:00:00.000Z'],
    ['TOMORROW', '2026-10-20T04:00:00.000Z'],
    ['TODAY_AT', '2026-10-18T02:00:00.000Z'],
    ['TODAY_AT', '2026-10-18T11:00:00'],
    ['TODAY_AT', undefined],
    ['TONIGHT', '2026-10-18T13:00:00.000Z'],
  ] as const)(
    'rejects invalid %s due %s with the business error',
    (kind, at) => {
      expectInvalid(() => due(kind, at));
    },
  );

  it('defaults to 20:00 tonight and 09:00 tomorrow and rejects a passed tonight', () => {
    expect(due('TONIGHT').toISOString()).toBe('2026-10-18T13:00:00.000Z');
    expect(due('TOMORROW').toISOString()).toBe('2026-10-19T02:00:00.000Z');
    expectInvalid(() =>
      due('TONIGHT', undefined, new Date('2026-10-18T14:00:00.000Z')),
    );
  });

  it.each([
    [
      '2026-03-08T06:30:00.000Z',
      '2026-03-09T00:00:00.000Z',
      '2026-03-09T13:00:00.000Z',
    ],
    [
      '2026-11-01T04:30:00.000Z',
      '2026-11-02T01:00:00.000Z',
      '2026-11-02T14:00:00.000Z',
    ],
  ])(
    'handles DST boundaries in America/New_York from %s',
    (instant, tonight, tomorrow) => {
      expect(
        due(
          'TONIGHT',
          undefined,
          new Date(instant),
          'America/New_York',
        ).toISOString(),
      ).toBe(tonight);
      expect(
        due(
          'TOMORROW',
          undefined,
          new Date(instant),
          'America/New_York',
        ).toISOString(),
      ).toBe(tomorrow);
    },
  );
});
