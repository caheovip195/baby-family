import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { io } from 'socket.io-client';
import type { Socket } from 'socket.io-client';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';

interface Conversation {
  id: string;
  kind: 'FAMILY' | 'COUPLE';
  lastSeq: number;
  readSeq: number;
  unreadCount: number;
  lastMessage: Message | null;
  members: { userId: string; role: string; lastReadSeq: number }[];
}
interface Message {
  id: string;
  conversationId: string;
  seq: number;
  senderUserId: string;
  body: string;
  isMine: boolean;
  clientKey: string | null;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** BF-20261101-001: Nhắn tin cả nhà + Papa & Mama, REST + WebSocket. */
describe('Chat API + realtime (PostgreSQL + ES256 + Socket.IO)', () => {
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
  const base = () => `/api/v1/families/${familyId}/chats`;
  const bearer = (userId: string) => tokens.get(userId) ?? '';
  const list = (userId: string) =>
    request(app.getHttpServer())
      .get(base())
      .set('Authorization', bearer(userId));
  const send = (
    userId: string,
    conversationId: string,
    body: string,
    key = randomUUID(),
  ) =>
    request(app.getHttpServer())
      .post(`${base()}/${conversationId}/messages`)
      .set('Authorization', bearer(userId))
      .set('Idempotency-Key', key)
      .send({ body });
  const page = (userId: string, conversationId: string, query = '') =>
    request(app.getHttpServer())
      .get(`${base()}/${conversationId}/messages${query}`)
      .set('Authorization', bearer(userId));
  const read = (userId: string, conversationId: string, seq: number) =>
    request(app.getHttpServer())
      .post(`${base()}/${conversationId}/read`)
      .set('Authorization', bearer(userId))
      .send({ seq });
  const conversations = async (userId: string) =>
    data<Conversation[]>(await list(userId).expect(200));
  const sockets: Socket[] = [];
  let url = '';
  const connect = (token: string) =>
    new Promise<Socket>((resolve, reject) => {
      const socket = io(url, {
        transports: ['websocket'],
        auth: { token },
        reconnection: false,
      });
      sockets.push(socket);
      socket.once('ready', () => resolve(socket));
      socket.once('auth.error', () => reject(new Error('auth.error')));
      socket.once('connect_error', reject);
    });
  const next = <T>(socket: Socket, event: string) =>
    new Promise<T>((resolve, reject) => {
      const timer = setTimeout(
        () => reject(new Error(`timeout ${event}`)),
        5000,
      );
      socket.once(event, (payload: T) => {
        clearTimeout(timer);
        resolve(payload);
      });
    });
  async function clean() {
    const ids = (
      await prisma.chatConversation.findMany({
        where: { familyId },
        select: { id: true },
      })
    ).map((c) => c.id);
    await prisma.chatReadState.deleteMany({
      where: { conversationId: { in: ids } },
    });
    await prisma.chatMessage.deleteMany({ where: { familyId } });
    await prisma.chatConversation.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({
      where: { familyId, eventType: 'chat.message.created' },
    });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Chat integration requires a *_test database.');
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
    await app.listen(0, '127.0.0.1');
    url = await app.getUrl();
    prisma = app.get(PrismaService);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Synthetic chat fixture',
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
        name: 'Synthetic chat family',
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
        code: `CHAT_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic chat plan' },
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
        name: 'Synthetic chat child',
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
    for (const socket of sockets) socket.disconnect();
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

  it('gives Parents the family + couple chat and relatives only the family chat', async () => {
    const a = await conversations(parentA);
    expect(a.map((c) => c.kind).sort()).toEqual(['COUPLE', 'FAMILY']);
    const family = a.find((c) => c.kind === 'FAMILY')!;
    const couple = a.find((c) => c.kind === 'COUPLE')!;
    expect(family.members.map((m) => m.userId).sort()).toEqual(
      [parentA, parentB, circle, granted].sort(),
    );
    expect(couple.members.map((m) => m.userId).sort()).toEqual(
      [parentA, parentB].sort(),
    );
    // Gọi lại không tạo cuộc trò chuyện thứ hai.
    expect((await conversations(parentB)).map((c) => c.id).sort()).toEqual(
      a.map((c) => c.id).sort(),
    );
    const relative = await conversations(granted);
    expect(relative).toHaveLength(1);
    expect(relative[0]!.id).toBe(family.id);
    await list(outsider).expect(404);
    // Người thân không thấy, không gửi được vào chat riêng Papa & Mama.
    expect(code(await page(granted, couple.id).expect(404))).toBe('NOT_FOUND');
    await send(granted, couple.id, 'xin chào').expect(404);
  });

  it('sends idempotently with increasing seq, pages by seq and tracks reads', async () => {
    const family = (await conversations(parentA)).find(
      (c) => c.kind === 'FAMILY',
    )!;
    const key = randomUUID();
    const first = data<Message>(
      await send(granted, family.id, '  Bà nhớ cháu quá  ', key).expect(201),
    );
    expect(first).toMatchObject({
      seq: 1,
      body: 'Bà nhớ cháu quá',
      isMine: true,
      clientKey: key,
      senderUserId: granted,
    });
    // Gửi lại khi offline cùng Idempotency-Key: không tạo bản trùng.
    const replay = data<Message>(
      await send(granted, family.id, 'Bà nhớ cháu quá', key).expect(201),
    );
    expect(replay.id).toBe(first.id);
    for (let i = 2; i <= 5; i++)
      await send(parentA, family.id, `tin ${i}`).expect(201);
    await send(parentA, family.id, '   ').expect(400);
    const latest = data<{ items: Message[]; hasMore: boolean }>(
      await page(parentB, family.id, '?limit=2').expect(200),
    );
    expect(latest.items.map((m) => m.seq)).toEqual([4, 5]);
    expect(latest.hasMore).toBe(true);
    expect(latest.items[0]).toMatchObject({ isMine: false, clientKey: null });
    const older = data<{ items: Message[]; hasMore: boolean }>(
      await page(parentB, family.id, '?beforeSeq=4&limit=5').expect(200),
    );
    expect(older.items.map((m) => m.seq)).toEqual([1, 2, 3]);
    expect(older.hasMore).toBe(false);
    const newer = data<{ items: Message[]; hasMore: boolean }>(
      await page(parentB, family.id, '?afterSeq=3').expect(200),
    );
    expect(newer.items.map((m) => m.seq)).toEqual([4, 5]);
    await page(parentB, family.id, '?afterSeq=1&beforeSeq=3').expect(400);

    let b = (await conversations(parentB)).find((c) => c.id === family.id)!;
    expect(b).toMatchObject({ lastSeq: 5, readSeq: 0, unreadCount: 5 });
    expect(b.lastMessage?.body).toBe('tin 5');
    expect(
      data<{ readSeq: number }>(await read(parentB, family.id, 99).expect(200))
        .readSeq,
    ).toBe(5);
    // Chỉ tiến lên.
    expect(
      data<{ readSeq: number }>(await read(parentB, family.id, 2).expect(200))
        .readSeq,
    ).toBe(5);
    b = (await conversations(parentB)).find((c) => c.id === family.id)!;
    expect(b.unreadCount).toBe(0);
    // Outbox chỉ mang định danh, không có nội dung tin.
    const events = await prisma.outboxEvent.findMany({
      where: { familyId, eventType: 'chat.message.created' },
    });
    expect(events).toHaveLength(5);
    expect(JSON.stringify(events.map((e) => e.payload))).not.toContain('tin');
  });

  it('encrypts the Papa & Mama chat at rest', async () => {
    const couple = (await conversations(parentA)).find(
      (c) => c.kind === 'COUPLE',
    )!;
    const sent = data<Message>(
      await send(parentA, couple.id, 'Tối nay anh trông con nhé').expect(201),
    );
    const stored = await prisma.chatMessage.findUniqueOrThrow({
      where: { id: sent.id },
    });
    expect(stored.body).toBeNull();
    expect(Buffer.from(stored.bodyEnc!).toString('utf8')).not.toContain(
      'trông con',
    );
    const seen = data<{ items: Message[] }>(
      await page(parentB, couple.id).expect(200),
    );
    expect(seen.items[0]).toMatchObject({
      body: 'Tối nay anh trông con nhé',
      isMine: false,
    });
  });

  it('authenticates sockets and pushes small realtime signals to members only', async () => {
    await expect(connect('not-a-token')).rejects.toThrow();
    const family = (await conversations(parentA)).find(
      (c) => c.kind === 'FAMILY',
    )!;
    const couple = (await conversations(parentA)).find(
      (c) => c.kind === 'COUPLE',
    )!;
    const token = (userId: string) => bearer(userId).slice('Bearer '.length);
    const b = await connect(token(parentB));
    const relative = await connect(token(granted));
    const a = await connect(token(parentA));

    const signal = next<Record<string, unknown>>(b, 'chat.message');
    const relativeSignal = next<Record<string, unknown>>(
      relative,
      'chat.message',
    );
    const sent = data<Message>(
      await send(parentA, family.id, 'Cả nhà ơi').expect(201),
    );
    const payload = await signal;
    expect(payload).toEqual({
      familyId,
      conversationId: family.id,
      id: sent.id,
      seq: sent.seq,
      senderUserId: parentA,
    });
    expect(await relativeSignal).toMatchObject({ id: sent.id });
    // Không có nội dung trong tín hiệu realtime (§12).
    expect(JSON.stringify(payload)).not.toContain('Cả nhà');

    // Chat riêng: người thân không nhận tín hiệu.
    let leaked = false;
    relative.once('chat.message', () => {
      leaked = true;
    });
    const coupleSignal = next<Record<string, unknown>>(b, 'chat.message');
    await send(parentA, couple.id, 'riêng tư').expect(201);
    expect(await coupleSignal).toMatchObject({ conversationId: couple.id });
    await new Promise((resolve) => setTimeout(resolve, 300));
    expect(leaked).toBe(false);

    const typing = next<Record<string, unknown>>(b, 'chat.typing');
    a.emit('chat.typing', { familyId, conversationId: family.id });
    expect(await typing).toEqual({
      familyId,
      conversationId: family.id,
      userId: parentA,
    });

    const seen = next<Record<string, unknown>>(a, 'chat.read');
    await read(parentB, family.id, sent.seq).expect(200);
    expect(await seen).toMatchObject({ userId: parentB, seq: sent.seq });

    const refreshed = await new Promise<{ ok: boolean }>((resolve) =>
      a.emit('auth.refresh', { token: token(parentA) }, resolve),
    );
    expect(refreshed.ok).toBe(true);
    const refused = await new Promise<{ ok: boolean }>((resolve) =>
      a.emit('auth.refresh', { token: token(parentB) }, resolve),
    );
    expect(refused.ok).toBe(false);
  });
});
