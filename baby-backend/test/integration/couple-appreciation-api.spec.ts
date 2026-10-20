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
import type {
  AppreciationViewDto,
  AppreciationWallDto,
} from '../../src/dto/us/appreciation.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Couple appreciation API (PostgreSQL + ES256)', () => {
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

  // Second family for cross-family link rejection test
  const otherFamilyId = randomUUID(),
    otherParent = randomUUID(),
    otherLicenseId = randomUUID();

  let missionId: string;
  let requestId: string;
  let otherMissionId: string;

  const basePath = `/families/${familyId}/us/appreciations`;
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

  function create(
    userId = parentA,
    body: Record<string, unknown> = {},
    route = basePath,
  ) {
    const payload = body.quick
      ? { sticker: 'HEART', ...body }
      : {
          body: 'Cảm ơn em đã chăm con chu đáo hôm nay!',
          sticker: 'HEART',
          ...body,
        };
    return call('post', userId, route, payload);
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test')) {
      throw new Error(
        'Couple appreciation integration requires a *_test database.',
      );
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

    const allUsers = [...users, otherParent];
    await prisma.user.createMany({
      data: allUsers.map((id) => ({
        id,
        displayName: 'Appreciation test user',
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });

    const allSessions = [
      ...sessions,
      [otherParent, randomUUID()] as [string, string],
    ];
    await prisma.userSession.createMany({
      data: allSessions.map(([userId, id]) => ({
        id,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: future(),
        absoluteExpiresAt: future(),
      })),
    });

    for (const [userId, sid] of allSessions) {
      const issued = Math.floor(Date.now() / 1000);
      const token = await new SignJWT({
        sub: userId,
        sid,
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
        name: 'Appreciation test family',
        createdBy: parentA,
        status: 'ACTIVE',
        activatedAt: past(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });

    const parentARow = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Bố',
      },
    });

    const parentBRow = await prisma.familyParent.create({
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
        parentAMembershipId: parentARow.id,
        parentBMembershipId: parentBRow.id,
      },
    });

    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'CAREGIVER',
        displayName: 'Circle member',
        invitedBy: parentA,
      },
    });

    await prisma.plan.create({
      data: {
        id: planId,
        code: `APPRECIATION_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Plan test' },
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

    // Seed mission and request in the family
    const mission = await prisma.mission.create({
      data: {
        familyId,
        source: 'CUSTOM',
        category: 'CARE',
        targetScope: 'FAMILY',
        title: 'Tắm cho con',
        status: 'TODO',
        createdBy: parentA,
        ownerKind: 'PARENT',
        ownerUserId: parentA,
        hearts: 2,
        boardDate: new Date(),
      },
    });
    missionId = mission.id;

    const req = await prisma.request.create({
      data: {
        familyId,
        coupleSpaceId,
        senderUserId: parentA,
        receiverUserId: parentB,
        kind: 'TASK',
        titleEnc: Buffer.from('test title'),
        contentKey: randomBytes(32),
        status: 'DONE',
        urgency: 'NORMAL',
        expiresAt: future(),
      },
    });
    requestId = req.id;

    // Second family setup for cross-family validation
    await prisma.family.create({
      data: {
        id: otherFamilyId,
        name: 'Other family',
        createdBy: otherParent,
        status: 'ACTIVE',
        activatedAt: past(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    await prisma.familyLicense.create({
      data: { id: otherLicenseId, familyId: otherFamilyId },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId: otherFamilyId,
        licenseId: otherLicenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });
    const otherMission = await prisma.mission.create({
      data: {
        familyId: otherFamilyId,
        source: 'CUSTOM',
        category: 'CARE',
        targetScope: 'FAMILY',
        title: 'Khác gia đình',
        status: 'TODO',
        createdBy: otherParent,
        ownerKind: 'PARENT',
        ownerUserId: otherParent,
        hearts: 2,
        boardDate: new Date(),
      },
    });
    otherMissionId = otherMission.id;
  });

  beforeEach(async () => {
    await prisma.appreciation.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.familyUsage.deleteMany({ where: { familyId } });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: planVersionId },
    });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.appreciation.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.outboxEvent.deleteMany({
          where: { familyId: { in: [familyId, otherFamilyId] } },
        });
        await prisma.request.deleteMany({ where: { familyId } });
        await prisma.mission.deleteMany({
          where: { familyId: { in: [familyId, otherFamilyId] } },
        });
        await prisma.coupleSpace.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({
          where: { familyId: { in: [familyId, otherFamilyId] } },
        });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: { in: [licenseId, otherLicenseId] } },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: { in: [familyId, otherFamilyId] } },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: [...users, otherParent] } },
        });
        await prisma.user.updateMany({
          where: { id: { in: [...users, otherParent] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('enforces body ≤ 500 characters validation', async () => {
    const validBody = 'x'.repeat(500);
    const created = data<AppreciationViewDto>(
      await create(parentA, { body: validBody }).expect(201),
    );
    expect(created.body).toBe(validBody);

    const invalidBody = 'x'.repeat(501);
    await create(parentA, { body: invalidBody }).expect(400);

    // Empty body when not quick returns error
    await create(parentA, { body: '   ' }).expect(422);
  });

  it('supports quick 💛 with server default text when quick: true', async () => {
    // Quick with mission link
    const res1 = data<AppreciationViewDto>(
      await create(parentA, {
        linkedType: 'MISSION',
        linkedId: missionId,
        quick: true,
      }).expect(201),
    );
    expect(res1.body).toBe('Cảm ơn bạn đời nhiều lắm! 💛');
    expect(res1.linkedType).toBe('MISSION');
    expect(res1.linkedId).toBe(missionId);

    // Quick with request link
    const res2 = data<AppreciationViewDto>(
      await create(parentA, {
        linkedType: 'REQUEST',
        linkedId: requestId,
        quick: true,
      }).expect(201),
    );
    expect(res2.body).toBe('Cảm ơn bạn đời nhiều lắm! 💛');
    expect(res2.linkedType).toBe('REQUEST');
    expect(res2.linkedId).toBe(requestId);

    // Quick without linkedType/linkedId fails
    await create(parentA, { quick: true }).expect(422);
  });

  it('links to a mission/request of the same family only', async () => {
    // Same family mission link succeeds
    await create(parentA, {
      body: 'Cảm ơn đã hoàn thành nhiệm vụ!',
      linkedType: 'MISSION',
      linkedId: missionId,
    }).expect(201);

    // Same family request link succeeds
    await create(parentA, {
      body: 'Cảm ơn đã giúp lời nhờ!',
      linkedType: 'REQUEST',
      linkedId: requestId,
    }).expect(201);

    // Other family mission link fails
    const errCrossFamily = await create(parentA, {
      body: 'Thử gắn nhiệm vụ gia đình khác',
      linkedType: 'MISSION',
      linkedId: otherMissionId,
    }).expect(422);
    expect(code(errCrossFamily)).toBe('APPRECIATION_LINK_NOT_FOUND');

    // Non-existent link ID fails
    const errNotFound = await create(parentA, {
      body: 'Thử gắn ID không tồn tại',
      linkedType: 'MISSION',
      linkedId: randomUUID(),
    }).expect(422);
    expect(code(errNotFound)).toBe('APPRECIATION_LINK_NOT_FOUND');
  });

  it('displays a two-way wall with newest first, cursor pagination, and optional month filter', async () => {
    const aToB = data<AppreciationViewDto>(
      await create(parentA, { body: 'Từ Bố gửi Mẹ' }).expect(201),
    );
    const bToA = data<AppreciationViewDto>(
      await create(parentB, { body: 'Từ Mẹ gửi Bố' }).expect(201),
    );

    // Parent A sees both
    const wallA = data<AppreciationWallDto>(
      await call('get', parentA).expect(200),
    );
    expect(wallA.items).toHaveLength(2);
    expect(wallA.items[0]!.id).toBe(bToA.id);
    expect(wallA.items[1]!.id).toBe(aToB.id);
    expect(wallA.items[1]!.isMine).toBe(true);
    expect(wallA.items[0]!.isMine).toBe(false);

    // Parent B sees both
    const wallB = data<AppreciationWallDto>(
      await call('get', parentB).expect(200),
    );
    expect(wallB.items).toHaveLength(2);
    expect(wallB.items[0]!.id).toBe(bToA.id);
    expect(wallB.items[0]!.isMine).toBe(true);
    expect(wallB.items[1]!.isMine).toBe(false);

    // Month filter matching current month
    const currentMonth = new Date().toISOString().slice(0, 7);
    const wallMonth = data<AppreciationWallDto>(
      await call('get', parentA, `${basePath}?month=${currentMonth}`).expect(
        200,
      ),
    );
    expect(wallMonth.items).toHaveLength(2);

    // Month filter for past month returns empty
    const wallPastMonth = data<AppreciationWallDto>(
      await call('get', parentA, `${basePath}?month=2020-01`).expect(200),
    );
    expect(wallPastMonth.items).toHaveLength(0);

    // Cursor pagination: limit 1
    const p1 = data<AppreciationWallDto>(
      await call('get', parentA, `${basePath}?limit=1`).expect(200),
    );
    expect(p1.items).toHaveLength(1);
    expect(p1.items[0]!.id).toBe(bToA.id);
    expect(p1.nextCursor).toBe(bToA.id);

    // Page 2 using cursor
    const p2 = data<AppreciationWallDto>(
      await call(
        'get',
        parentA,
        `${basePath}?limit=1&cursor=${p1.nextCursor}`,
      ).expect(200),
    );
    expect(p2.items).toHaveLength(1);
    expect(p2.items[0]!.id).toBe(aToB.id);
    expect(p2.nextCursor).toBeNull();
  });

  it('allows partner to react / thank back, blocks self-react', async () => {
    const item = data<AppreciationViewDto>(
      await create(parentA, { body: 'Cảm ơn em nhiều!' }).expect(201),
    );

    // Sender trying to react to own appreciation gets 422
    const selfReact = await call(
      'post',
      parentA,
      `${basePath}/${item.id}/react`,
      { reaction: 'LOVE' },
    ).expect(422);
    expect(code(selfReact)).toBe('APPRECIATION_REACT_PARTNER_ONLY');

    // Partner reacts successfully
    const reacted = data<AppreciationViewDto>(
      await call('post', parentB, `${basePath}/${item.id}/react`, {
        reaction: 'LOVE',
      }).expect(200),
    );
    expect(reacted.reaction).toBe('LOVE');
    expect(reacted.seenAt).not.toBeNull();

    // Verify outbox event created
    const outbox = await prisma.outboxEvent.findFirst({
      where: {
        familyId,
        eventType: 'us.appreciation.reacted',
        aggregateId: item.id,
      },
    });
    expect(outbox).not.toBeNull();
  });

  it('requires partner approval before posting as family moment (share-request -> share-respond)', async () => {
    const item = data<AppreciationViewDto>(
      await create(parentA, { body: 'Khoảnh khắc đáng nhớ' }).expect(201),
    );
    expect(item.familyShareStatus).toBe('NONE');

    // Parent A requests share
    const requested = data<AppreciationViewDto>(
      await call(
        'post',
        parentA,
        `${basePath}/${item.id}/share-request`,
      ).expect(200),
    );
    expect(requested.familyShareStatus).toBe('REQUESTED');

    // Duplicate request fails
    await call('post', parentA, `${basePath}/${item.id}/share-request`).expect(
      409,
    );

    // Parent A trying to approve own request fails
    const selfApprove = await call(
      'post',
      parentA,
      `${basePath}/${item.id}/share-respond`,
      { approve: true },
    ).expect(422);
    expect(code(selfApprove)).toBe('APPRECIATION_SHARE_SELF_APPROVAL');

    // Concurrent approvals and retries produce one linked moment and one event set.
    const responses = await Promise.all(
      Array.from({ length: 2 }, () =>
        call('post', parentB, `${basePath}/${item.id}/share-respond`, {
          approve: true,
        }).expect(200),
      ),
    );
    const approved = data<AppreciationViewDto>(responses[0]!);
    expect(data<AppreciationViewDto>(responses[1]!).familyMemoryId).toBe(
      approved.familyMemoryId,
    );
    expect(approved.familyShareStatus).toBe('APPROVED');
    expect(approved.familyMemoryId).not.toBeNull();
    const memories = await prisma.memory.findMany({ where: { familyId } });
    expect(memories).toHaveLength(1);
    expect(memories[0]).toMatchObject({
      id: approved.familyMemoryId,
      familyId,
      authorUserId: parentA,
      authorRole: 'PARENT',
      body: 'Khoảnh khắc đáng nhớ',
      kind: 'MOMENT',
      visibility: 'PARENTS',
      status: 'PUBLISHED',
      familyMoment: true,
      sourceType: 'APPRECIATION',
      sourceId: item.id,
    });
    const replay = data<AppreciationViewDto>(
      await call('post', parentB, `${basePath}/${item.id}/share-respond`, {
        approve: true,
      }).expect(200),
    );
    expect(replay.familyMemoryId).toBe(approved.familyMemoryId);
    expect(await prisma.memory.count({ where: { familyId } })).toBe(1);
    expect(
      await prisma.familyUsage.findUnique({ where: { familyId } }),
    ).toMatchObject({ memoryCount: 1, version: 2n });
    for (const eventType of [
      'us.appreciation.share_approved',
      'memory.created',
      'memory.published',
    ]) {
      expect(
        await prisma.outboxEvent.count({ where: { familyId, eventType } }),
      ).toBe(1);
    }

    // Verify outbox event created
    const outbox = await prisma.outboxEvent.findFirst({
      where: {
        familyId,
        eventType: 'us.appreciation.share_approved',
        aggregateId: item.id,
      },
    });
    expect(outbox).not.toBeNull();

    // Test rejection flow on another appreciation
    const item2 = data<AppreciationViewDto>(
      await create(parentA, { body: 'Tin nhắn riêng tư khác' }).expect(201),
    );
    await call('post', parentA, `${basePath}/${item2.id}/share-request`).expect(
      200,
    );

    const rejected = data<AppreciationViewDto>(
      await call('post', parentB, `${basePath}/${item2.id}/share-respond`, {
        approve: false,
      }).expect(200),
    );
    expect(rejected.familyShareStatus).toBe('REJECTED');
    expect(rejected.familyMemoryId).toBeNull();
    expect(await prisma.memory.count({ where: { familyId } })).toBe(1);
  });

  it('rolls back approval, memory and usage when catalog memoryCount is exhausted', async () => {
    const limited = await prisma.planVersion.create({
      data: {
        planId,
        version: 2,
        quotas: { memoryCount: 0 },
        features: {},
        availableFrom: past(),
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: limited.id },
    });
    const item = data<AppreciationViewDto>(await create().expect(201));
    await call('post', parentA, `${basePath}/${item.id}/share-request`).expect(
      200,
    );
    const response = await call(
      'post',
      parentB,
      `${basePath}/${item.id}/share-respond`,
      { approve: true },
    ).expect(402);
    expect(code(response)).toBe('QUOTA_MEMORY_COUNT_EXCEEDED');
    expect(await prisma.memory.count({ where: { familyId } })).toBe(0);
    expect(
      await prisma.familyUsage.findUnique({ where: { familyId } }),
    ).toBeNull();
    expect(
      await prisma.appreciation.findUnique({ where: { id: item.id } }),
    ).toMatchObject({ familyShareStatus: 'REQUESTED', familyMemoryId: null });
    expect(
      await prisma.outboxEvent.count({
        where: {
          familyId,
          eventType: {
            in: [
              'memory.created',
              'memory.published',
              'us.appreciation.share_approved',
            ],
          },
        },
      }),
    ).toBe(0);
  });

  it('handles soft deletion: actor deletion hides item for actor; full soft delete when both delete', async () => {
    const item = data<AppreciationViewDto>(
      await create(parentA, { body: 'Lời cảm ơn cần xoá' }).expect(201),
    );

    // Parent A deletes
    await call('delete', parentA, `${basePath}/${item.id}`).expect(204);

    // Parent A no longer sees it in wall
    const wallA = data<AppreciationWallDto>(
      await call('get', parentA).expect(200),
    );
    expect(wallA.items.find((i) => i.id === item.id)).toBeUndefined();

    // Parent B still sees it
    const wallB = data<AppreciationWallDto>(
      await call('get', parentB).expect(200),
    );
    expect(wallB.items.find((i) => i.id === item.id)).toBeDefined();

    // In DB, not fully soft-deleted yet
    const rowMiddle = await prisma.appreciation.findUnique({
      where: { id: item.id },
    });
    expect(rowMiddle?.deletedByFromAt).not.toBeNull();
    expect(rowMiddle?.deletedByToAt).toBeNull();
    expect(rowMiddle?.deletedAt).toBeNull();

    // Parent B deletes too
    await call('delete', parentB, `${basePath}/${item.id}`).expect(204);

    // Now fully soft-deleted in DB
    const rowFinal = await prisma.appreciation.findUnique({
      where: { id: item.id },
    });
    expect(rowFinal?.deletedAt).not.toBeNull();
  });

  it('blocks Circle and outsiders with 403/404', async () => {
    // Circle member blocked
    const resCircleGet = await call('get', circle);
    expect([403, 404]).toContain(resCircleGet.status);
    const resCircleCreate = await create(circle);
    expect([403, 404]).toContain(resCircleCreate.status);

    // Outsider blocked
    const resOutsiderGet = await call('get', outsider);
    expect([403, 404]).toContain(resOutsiderGet.status);
    const resOutsiderCreate = await create(outsider);
    expect([403, 404]).toContain(resOutsiderCreate.status);
  });
});
