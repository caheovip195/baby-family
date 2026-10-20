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
  JournalEntryViewDto,
  JournalListDto,
  JournalShareResponseDto,
} from '../../src/dto/us/journal.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Couple journal API (PostgreSQL + ES256)', () => {
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

  let validAssetId: string;
  let invalidAssetId: string;

  const basePath = `/families/${familyId}/us/journal`;
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);

  function call(
    method: 'get' | 'post' | 'patch' | 'delete',
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

  function createEntry(userId = parentA, body: Record<string, unknown> = {}) {
    return call('post', userId, basePath, {
      title: 'Nhật ký buổi tối',
      body: 'Hôm nay tôi cảm thấy biết ơn vì thời tiết đẹp và con cười rất tươi.',
      mood: 'GOOD',
      ...body,
    });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test')) {
      throw new Error('Couple journal integration requires a *_test database.');
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
        displayName: 'Journal test user',
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

    for (const [userId, sid] of sessions) {
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
        name: 'Journal test family',
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
        code: `JOURNAL_${randomUUID().slice(0, 16)}`,
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

    // Seed assets: 1 valid JOURNAL asset by Parent A, 1 MEMORY asset (invalid for journal)
    const asset1 = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: parentA,
        privateOwnerUserId: parentA,
        kind: 'IMAGE',
        purpose: 'JOURNAL',
        status: 'READY',
        storageKey: `families/${familyId}/journal/${randomUUID()}.jpg`,
        mime: 'image/jpeg',
        declaredSize: 1024n,
        sizeBytes: 1024n,
      },
    });
    validAssetId = asset1.id;

    const asset2 = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: parentA,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        status: 'READY',
        storageKey: `families/${familyId}/memory/${randomUUID()}.jpg`,
        mime: 'image/jpeg',
        declaredSize: 2048n,
        sizeBytes: 2048n,
      },
    });
    invalidAssetId = asset2.id;
  });

  beforeEach(async () => {
    await prisma.journalShare.deleteMany({ where: { familyId } });
    await prisma.journalAsset.deleteMany({ where: { familyId } });
    await prisma.journalEntry.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.journalShare.deleteMany({ where: { familyId } });
        await prisma.journalAsset.deleteMany({ where: { familyId } });
        await prisma.journalEntry.deleteMany({ where: { familyId } });
        await prisma.asset.deleteMany({ where: { familyId } });
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

  it('creates a private journal entry with encrypted title and body, optional mood and photos', async () => {
    const entry = data<JournalEntryViewDto>(
      await createEntry(parentA, {
        title: 'Nhật ký bí mật',
        body: 'Hôm nay mình có nhiều suy nghĩ riêng.',
        mood: 'TIRED',
        assetIds: [validAssetId],
      }).expect(201),
    );

    expect(entry.title).toBe('Nhật ký bí mật');
    expect(entry.body).toBe('Hôm nay mình có nhiều suy nghĩ riêng.');
    expect(entry.mood).toBe('TIRED');
    expect(entry.assetIds).toEqual([validAssetId]);
    expect(entry.userId).toBe(parentA);

    // Verify stored encrypted in DB
    const stored = await prisma.journalEntry.findUnique({
      where: { id: entry.id },
    });
    expect(stored).not.toBeNull();
    expect(stored?.titleEnc).toBeInstanceOf(Uint8Array);
    expect(stored?.bodyEnc).toBeInstanceOf(Uint8Array);
    // Not plain text
    expect(stored?.bodyEnc.toString()).not.toContain('suy nghĩ riêng');

    // Verify outbox event created
    const outbox = await prisma.outboxEvent.findFirst({
      where: {
        familyId,
        eventType: 'us.journal.created',
        aggregateId: entry.id,
      },
    });
    expect(outbox).not.toBeNull();
  });

  it('is readable ONLY by its writer: partner gets 404 for every journal route', async () => {
    const entry = data<JournalEntryViewDto>(
      await createEntry(parentA, {
        title: 'Chỉ Bố được đọc',
        body: 'Nội dung riêng tư của Bố.',
      }).expect(201),
    );

    // Writer Parent A can read entry
    const readByA = data<JournalEntryViewDto>(
      await call('get', parentA, `${basePath}/${entry.id}`).expect(200),
    );
    expect(readByA.title).toBe('Chỉ Bố được đọc');
    expect(readByA.body).toBe('Nội dung riêng tư của Bố.');

    // Partner Parent B gets 404 on GET /:id
    const partnerGet = await call(
      'get',
      parentB,
      `${basePath}/${entry.id}`,
    ).expect(404);
    expect(code(partnerGet)).toBe('JOURNAL_ENTRY_NOT_FOUND');

    // Partner Parent B gets 404 on PATCH /:id
    const partnerPatch = await call(
      'patch',
      parentB,
      `${basePath}/${entry.id}`,
      { body: 'Thử sửa nhật ký của bạn đời' },
    ).expect(404);
    expect(code(partnerPatch)).toBe('JOURNAL_ENTRY_NOT_FOUND');

    // Partner Parent B gets 404 on DELETE /:id
    const partnerDelete = await call(
      'delete',
      parentB,
      `${basePath}/${entry.id}`,
    ).expect(404);
    expect(code(partnerDelete)).toBe('JOURNAL_ENTRY_NOT_FOUND');

    // Partner Parent B gets 404 on POST /:id/share
    const partnerShare = await call(
      'post',
      parentB,
      `${basePath}/${entry.id}/share`,
      { excerpt: 'Nội dung riêng tư' },
    ).expect(404);
    expect(code(partnerShare)).toBe('JOURNAL_ENTRY_NOT_FOUND');

    // In list GET /us/journal, Partner B sees only their own entries (empty for now)
    const listB = data<JournalListDto>(await call('get', parentB).expect(200));
    expect(listB.items).toHaveLength(0);

    // Parent A sees their own entry in list
    const listA = data<JournalListDto>(await call('get', parentA).expect(200));
    expect(listA.items).toHaveLength(1);
    expect(listA.items[0]!.id).toBe(entry.id);
  });

  it('shares excerpt with partner only if excerpt is an exact substring of the body', async () => {
    const fullText =
      'Hôm nay tôi cảm thấy biết ơn vì thời tiết đẹp và con cười rất tươi.';
    const entry = data<JournalEntryViewDto>(
      await createEntry(parentA, { body: fullText }).expect(201),
    );

    // Non-substring excerpt is rejected with 422
    const failRes = await call(
      'post',
      parentA,
      `${basePath}/${entry.id}/share`,
      { excerpt: 'con khóc rất nhiều' },
    ).expect(422);
    expect(code(failRes)).toBe('JOURNAL_EXCERPT_NOT_IN_BODY');

    // Exact substring succeeds
    const excerpt = 'con cười rất tươi';
    const shareRes = data<JournalShareResponseDto>(
      await call('post', parentA, `${basePath}/${entry.id}/share`, {
        excerpt,
      }).expect(201),
    );
    expect(shareRes.excerpt).toBe(excerpt);
    expect(shareRes.entryId).toBe(entry.id);

    // Verify stored JournalShare record
    const shareRecord = await prisma.journalShare.findUnique({
      where: { id: shareRes.id },
    });
    expect(shareRecord).not.toBeNull();
    expect(shareRecord?.ownerUserId).toBe(parentA);
    expect(shareRecord?.recipientUserId).toBe(parentB);
    expect(shareRecord?.coupleSpaceId).toBe(coupleSpaceId);
    expect(shareRecord?.snippetEnc).toBeInstanceOf(Uint8Array);

    // Outbox event created
    const outbox = await prisma.outboxEvent.findFirst({
      where: {
        familyId,
        eventType: 'us.journal.shared',
        aggregateId: shareRes.id,
      },
    });
    expect(outbox).not.toBeNull();
  });

  it('edits own journal entry and updates encrypted fields and assets', async () => {
    const entry = data<JournalEntryViewDto>(
      await createEntry(parentA, {
        title: 'Tiêu đề cũ',
        body: 'Nội dung cũ',
        mood: 'TIRED',
      }).expect(201),
    );

    const updated = data<JournalEntryViewDto>(
      await call('patch', parentA, `${basePath}/${entry.id}`, {
        title: 'Tiêu đề mới',
        body: 'Nội dung mới đã được cập nhật',
        mood: 'OKAY',
        assetIds: [validAssetId],
      }).expect(200),
    );

    expect(updated.title).toBe('Tiêu đề mới');
    expect(updated.body).toBe('Nội dung mới đã được cập nhật');
    expect(updated.mood).toBe('OKAY');
    expect(updated.assetIds).toEqual([validAssetId]);
  });

  it('soft deletes own journal entry and related assets/shares', async () => {
    const entry = data<JournalEntryViewDto>(
      await createEntry(parentA, {
        body: 'Bài viết sắp bị xoá để thử nghiệm',
        assetIds: [validAssetId],
      }).expect(201),
    );

    // Share excerpt first
    await call('post', parentA, `${basePath}/${entry.id}/share`, {
      excerpt: 'sắp bị xoá',
    }).expect(201);

    // Delete
    await call('delete', parentA, `${basePath}/${entry.id}`).expect(204);

    // Subsequent GET returns 404
    await call('get', parentA, `${basePath}/${entry.id}`).expect(404);

    // In DB, journalEntry is soft-deleted
    const entryInDb = await prisma.journalEntry.findUnique({
      where: { id: entry.id },
    });
    expect(entryInDb?.deletedAt).not.toBeNull();

    // Related journalAsset is soft-deleted
    const assetsInDb = await prisma.journalAsset.findMany({
      where: { entryId: entry.id },
    });
    expect(assetsInDb.length).toBeGreaterThan(0);
    expect(assetsInDb.every((a) => a.deletedAt !== null)).toBe(true);

    // Related journalShare is soft-deleted
    const sharesInDb = await prisma.journalShare.findMany({
      where: { entryId: entry.id },
    });
    expect(sharesInDb.length).toBeGreaterThan(0);
    expect(sharesInDb.every((s) => s.deletedAt !== null)).toBe(true);
  });

  it('validates assets: only accepts actor own READY JOURNAL assets', async () => {
    // Non-JOURNAL asset is rejected
    await createEntry(parentA, {
      body: 'Gắn ảnh ký ức vào nhật ký',
      assetIds: [invalidAssetId],
    }).expect(422);

    // Non-existent asset ID is rejected
    await createEntry(parentA, {
      body: 'Gắn ảnh không tồn tại',
      assetIds: [randomUUID()],
    }).expect(422);
  });

  it('blocks Circle and outsiders with 403/404', async () => {
    const resCircleGet = await call('get', circle);
    expect([403, 404]).toContain(resCircleGet.status);
    const resCircleCreate = await createEntry(circle);
    expect([403, 404]).toContain(resCircleCreate.status);

    const resOutsiderGet = await call('get', outsider);
    expect([403, 404]).toContain(resOutsiderGet.status);
    const resOutsiderCreate = await createEntry(outsider);
    expect([403, 404]).toContain(resOutsiderCreate.status);
  });
});
