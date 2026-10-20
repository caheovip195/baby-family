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

interface CheckinView {
  id: string;
  mood?: string;
  energy?: number | null;
  needs?: string[];
  note?: string | null;
  shared?: boolean;
  expiresAt: string;
}
interface TodayView {
  mine: CheckinView | null;
  partner: CheckinView | null;
}
interface HistoryView {
  items: CheckinView[];
  nextCursor: string | null;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Couple check-in API (PostgreSQL + ES256)', () => {
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
  const basePath = `/families/${familyId}/us/checkins`;
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);
  function call(
    method: 'get' | 'post' | 'delete',
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
  function create(userId: string, body: Record<string, unknown> = {}) {
    return call('post', userId, basePath, {
      mood: 'TIRED',
      energy: 2,
      needs: ['BREAK', 'HUG'],
      note: 'Synthetic confidential note',
      share: { enabled: true, fields: ['mood', 'energy', 'needs'] },
      ...body,
    });
  }
  const respond = (userId: string, id: string, type = 'HUG') =>
    call('post', userId, `${basePath}/${id}/responses`, { type });
  const today = async (userId: string) =>
    data<TodayView>(await call('get', userId, `${basePath}/today`).expect(200));
  const history = async (userId: string, query = '') =>
    data<HistoryView>(
      await call('get', userId, `${basePath}${query}`).expect(200),
    );

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error(
        'Couple check-in integration requires a *_test database.',
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
        displayName: 'Synthetic check-in fixture',
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
        name: 'Synthetic check-in family',
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
        code: `CHECKIN_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic check-in plan' },
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
    await prisma.moodResponse.deleteMany({ where: { familyId } });
    await prisma.moodCheckin.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.moodResponse.deleteMany({ where: { familyId } });
        await prisma.moodCheckin.deleteMany({ where: { familyId } });
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

  it('projects only shared fields and keeps private moods and notes invisible', async () => {
    const own = data<CheckinView>(await create(parentA).expect(201));
    expect(own).toMatchObject({
      mood: 'TIRED',
      energy: 2,
      needs: ['BREAK', 'HUG'],
      note: 'Synthetic confidential note',
      shared: true,
    });
    expect((await today(parentA)).mine).toMatchObject({ id: own.id });
    const visible = (await today(parentB)).partner;
    expect(visible).toMatchObject({
      id: own.id,
      mood: 'TIRED',
      energy: 2,
      needs: ['BREAK', 'HUG'],
    });
    for (const field of ['note', 'noteEnc', 'sharedNoteEnc'])
      expect(visible).not.toHaveProperty(field);
    const selected = data<CheckinView>(
      await create(parentA, {
        share: { enabled: true, fields: ['energy'] },
      }).expect(201),
    );
    const energyOnly = (await today(parentB)).partner;
    expect(energyOnly).toMatchObject({ id: selected.id, energy: 2 });
    for (const field of ['mood', 'needs', 'note'])
      expect(energyOnly).not.toHaveProperty(field);
    const privateMood = data<CheckinView>(
      await create(parentA, {
        share: { enabled: false, fields: ['mood', 'note'] },
      }).expect(201),
    );
    expect((await today(parentA)).mine?.id).toBe(privateMood.id);
    expect((await today(parentB)).partner).toBeNull();
    expect(code(await respond(parentB, privateMood.id).expect(404))).toBe(
      'CHECKIN_NOT_FOUND',
    );
  });

  it('never shares “upset with partner”, even when the client asks to', async () => {
    const upset = data<CheckinView>(
      await create(parentA, {
        mood: 'UPSET_WITH_PARTNER',
        share: { enabled: true, fields: ['mood', 'note'] },
      }).expect(201),
    );
    expect(upset).toMatchObject({ shared: false });
    expect((await today(parentB)).partner).toBeNull();
    expect(code(await respond(parentB, upset.id).expect(404))).toBe(
      'CHECKIN_NOT_FOUND',
    );
  });

  it('shares notes only by explicit selection and emits ids-only events only when shared', async () => {
    const own = data<CheckinView>(
      await create(parentA, {
        share: { enabled: true, fields: ['note'] },
      }).expect(201),
    );
    const partner = (await today(parentB)).partner;
    expect(partner).toMatchObject({ id: own.id, note: own.note });
    expect(partner).not.toHaveProperty('mood');
    const events = await prisma.outboxEvent.findMany({
      where: { familyId, eventType: 'us.checkin.shared' },
    });
    expect(events).toHaveLength(1);
    const payload = events[0]!.payload as Record<string, unknown>;
    expect(Object.keys(payload).length).toBeGreaterThan(0);
    for (const [key, value] of Object.entries(payload)) {
      expect(key).toMatch(/Id$/);
      expect(value).toEqual(expect.any(String));
      expect(value).toMatch(/^[0-9a-f-]{36}$/i);
    }
    await create(parentA, { share: { enabled: false, fields: [] } }).expect(
      201,
    );
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'us.checkin.shared' },
      }),
    ).toBe(1);
    const stored = await prisma.moodCheckin.findUniqueOrThrow({
      where: { id: own.id },
    });
    expect(Buffer.from(stored.noteEnc!).toString()).not.toContain(
      'Synthetic confidential note',
    );
    expect(Buffer.from(stored.sharedNoteEnc!).toString()).not.toContain(
      'Synthetic confidential note',
    );
  });

  it.each([10, 23])(
    'expires at six hours or midnight (local hour %i)',
    async (localHour) => {
      // Fixed-offset IANA zones exercise both branches at any wall-clock hour.
      const now = new Date();
      const offset = ((localHour - now.getUTCHours() + 36) % 24) - 12;
      const timezone =
        offset === 0
          ? 'Etc/UTC'
          : `Etc/GMT${offset > 0 ? '-' : '+'}${Math.abs(offset)}`;
      await prisma.family.update({
        where: { id: familyId },
        data: { timezone },
      });
      try {
        const before = Date.now();
        const own = data<CheckinView>(await create(parentA).expect(201));
        const after = Date.now();
        const shifted = new Date(before + offset * 3_600_000);
        const midnight =
          Date.UTC(
            shifted.getUTCFullYear(),
            shifted.getUTCMonth(),
            shifted.getUTCDate() + 1,
          ) -
          offset * 3_600_000;
        const expiry = new Date(own.expiresAt).getTime();
        expect(expiry).toBeGreaterThanOrEqual(
          Math.min(before + 6 * 3_600_000, midnight),
        );
        expect(expiry).toBeLessThanOrEqual(
          Math.min(after + 6 * 3_600_000, midnight),
        );
        // expires_at must be later than immutable created_at: insert an old fixture.
        await prisma.moodCheckin.delete({ where: { id: own.id } });
        await prisma.moodCheckin.create({
          data: {
            id: own.id,
            familyId,
            coupleSpaceId,
            userId: parentA,
            mood: 'TIRED',
            shared: true,
            sharedFields: ['mood'],
            createdAt: new Date(Date.now() - 7 * 3_600_000),
            expiresAt: past(),
          },
        });
        expect((await today(parentA)).mine).toBeNull();
        expect((await today(parentB)).partner).toBeNull();
        expect(code(await respond(parentB, own.id).expect(422))).toBe(
          'CHECKIN_NOT_CURRENT',
        );
        expect((await history(parentA)).items.map((item) => item.id)).toContain(
          own.id,
        );
      } finally {
        await prisma.family.update({
          where: { id: familyId },
          data: { timezone: 'Asia/Ho_Chi_Minh' },
        });
      }
    },
  );

  it('allows only the partner to respond to shared current check-ins', async () => {
    const first = data<CheckinView>(await create(parentA).expect(201));
    expect(code(await respond(parentA, first.id).expect(422))).toBe(
      'CHECKIN_RESPONSE_SELF',
    );
    for (const type of ['SEEN', 'ASK', 'ON_IT', 'HUG'])
      expect(
        data<{ type: string }>(
          await respond(parentB, first.id, type).expect(201),
        ).type,
      ).toBe(type);
    await respond(parentB, first.id, 'INVALID').expect(400);
    await create(parentA).expect(201);
    expect(code(await respond(parentB, first.id).expect(422))).toBe(
      'CHECKIN_NOT_CURRENT',
    );
    expect(code(await respond(parentB, randomUUID()).expect(404))).toBe(
      'CHECKIN_NOT_FOUND',
    );
    expect(
      await prisma.moodResponse.count({
        where: { checkinId: first.id, userId: parentB },
      }),
    ).toBe(4);
  });

  it('denies Circle, outsiders and inactive families without exposing moods', async () => {
    const own = data<CheckinView>(await create(parentA).expect(201));
    for (const userId of [circle, outsider]) {
      await call('get', userId, `${basePath}/today`).expect(404);
      await call('get', userId).expect(404);
      await create(userId).expect(404);
      await respond(userId, own.id).expect(404);
      await call('delete', userId).expect(404);
    }
    await call(
      'get',
      parentA,
      `/families/${randomUUID()}/us/checkins/today`,
    ).expect(404);
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'PARTNER_LEFT' },
    });
    try {
      await create(parentA).expect(403);
      await call('get', parentA, `${basePath}/today`).expect(403);
    } finally {
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'ACTIVE' },
      });
    }
  });

  it('paginates only own history and soft deletes only own check-ins and their responses', async () => {
    const ownIds: string[] = [];
    for (let index = 0; index < 3; index++)
      ownIds.push(data<CheckinView>(await create(parentA).expect(201)).id);
    const partner = data<CheckinView>(await create(parentB).expect(201));
    await respond(parentB, ownIds[2]!).expect(201);
    const first = await history(parentA, '?limit=2');
    expect(first.items).toHaveLength(2);
    expect(first.nextCursor).toEqual(expect.any(String));
    expect(
      code(
        await call(
          'get',
          parentB,
          `${basePath}?cursor=${first.nextCursor!}`,
        ).expect(400),
      ),
    ).toBe('CHECKIN_CURSOR_INVALID');
    const second = await history(
      parentA,
      `?limit=2&cursor=${encodeURIComponent(first.nextCursor!)}`,
    );
    expect(second.items).toHaveLength(1);
    expect(second.nextCursor).toBeNull();
    expect(
      [...first.items, ...second.items].map((item) => item.id).sort(),
    ).toEqual([...ownIds].sort());
    expect((await history(parentB)).items.map((item) => item.id)).toEqual([
      partner.id,
    ]);
    await call('get', parentA, `${basePath}?cursor=invalid`).expect(400);
    await call('delete', parentA).expect(204);
    await call('delete', parentA).expect(204);
    expect((await history(parentA)).items).toEqual([]);
    expect((await today(parentA)).mine).toBeNull();
    expect((await today(parentB)).partner).toBeNull();
    expect((await today(parentB)).mine?.id).toBe(partner.id);
    const deleted = await prisma.moodCheckin.findMany({
      where: { familyId, userId: parentA },
    });
    expect(deleted).toHaveLength(3);
    expect(deleted.every((item) => item.deletedAt instanceof Date)).toBe(true);
    const responses = await prisma.moodResponse.findMany({
      where: { familyId },
    });
    expect(responses).toHaveLength(1);
    expect(responses[0]!.deletedAt).toEqual(expect.any(Date));
  });

  it('requires an active couple space resolved by the server', async () => {
    await prisma.coupleSpace.update({
      where: { id: coupleSpaceId },
      data: { status: 'DISABLED', disabledAt: new Date() },
    });
    try {
      expect(code(await create(parentA).expect(404))).toBe(
        'COUPLE_SPACE_NOT_FOUND',
      );
      expect(
        code(await call('get', parentA, `${basePath}/today`).expect(404)),
      ).toBe('COUPLE_SPACE_NOT_FOUND');
    } finally {
      await prisma.coupleSpace.update({
        where: { id: coupleSpaceId },
        data: { status: 'ACTIVE', disabledAt: null },
      });
    }
  });

  it('fails closed before persisting notes when encryption is not configured', async () => {
    const configuration = app.get(ConfigService);
    const key = configuration.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    configuration.set('COUPLE_CHECKIN_ENCRYPTION_KEY', undefined);
    try {
      expect(code(await create(parentA).expect(503))).toBe(
        'CHECKIN_ENCRYPTION_UNAVAILABLE',
      );
      expect(await prisma.moodCheckin.count({ where: { familyId } })).toBe(0);
      expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(0);
    } finally {
      configuration.set('COUPLE_CHECKIN_ENCRYPTION_KEY', key);
    }
  });

  it('rejects invalid codes, energy, notes and forged client scope', async () => {
    for (const invalid of [
      { mood: 'UNKNOWN' },
      { energy: 0 },
      { energy: 6 },
      { energy: 1.5 },
      { needs: ['UNKNOWN'] },
      { note: 'x'.repeat(501) },
      { share: { enabled: true, fields: ['UNKNOWN'] } },
      { share: { enabled: 'yes', fields: ['mood'] } },
      { coupleSpaceId: randomUUID() },
      { userId: parentB },
    ])
      await create(parentA, invalid).expect(400);
    await create(parentA, { note: 'x'.repeat(500), energy: 1 }).expect(201);
  });
});
