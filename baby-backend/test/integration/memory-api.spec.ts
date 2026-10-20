import { createHash, randomBytes, randomUUID } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import type { Server } from 'node:http';
import path from 'node:path';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { parse } from 'dotenv';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';
import { MEDIA_REPOSITORY } from '../../src/interfaces/repositories/media-repository.interface';
import type { IMediaRepository } from '../../src/interfaces/repositories/media-repository.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import type { IMemoryContentRepository } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MemoryMaintenanceService } from '../../src/services/memory-maintenance.service';
import { JobLease } from '../../src/models/job-lease.model';

/** Loose view of the JSON responses used by this suite. */
interface MemoryBody {
  id: string;
  status: string;
  version: number;
  title: string | null;
  body: string | null;
  occurredAt: string;
  visibility: string;
  childIds: string[];
  coverAssetId: string | null;
  assets: { assetId: string; status: string; urls: Record<string, string> }[];
  assetId: string;
  deduplicated: boolean;
  trashedAt: string | null;
  purgeAfter: string | null;
  error: { code: string };
}
interface FeedBody {
  data: MemoryBody[];
  nextCursor: string | null;
}
const data = (response: { body: unknown }) => {
  const raw = response.body as { data?: MemoryBody; error?: unknown };
  return (raw.error === undefined ? raw.data : raw) as MemoryBody;
};

// Real PostgreSQL (*_test) + object storage settings (URL signing only) from
// TEST_* or the developer's .env; skipped when object storage is not configured.
const S3_VARIABLES = [
  'S3_ENDPOINT',
  'S3_PUBLIC_ENDPOINT',
  'S3_ACCESS_KEY_ID',
  'S3_SECRET_ACCESS_KEY',
] as const;
const envFile = path.resolve(__dirname, '../../.env');
const fileValues = existsSync(envFile)
  ? parse(readFileSync(envFile, 'utf8'))
  : {};
const s3 = Object.fromEntries(
  S3_VARIABLES.map((name) => [
    name,
    process.env[`TEST_${name}`] ?? fileValues[name] ?? '',
  ]),
);
const describeStack = s3.S3_ENDPOINT ? describe : describe.skip;

describeStack('Memory create/feed (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let media: IMediaRepository;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  const [parentA, parentB] = [randomUUID(), randomUUID()];
  const sessions = new Map<string, string>([
    [parentA, randomUUID()],
    [parentB, randomUUID()],
  ]);
  const familyId = randomUUID();
  const otherFamilyId = randomUUID();
  const [childOne, childTwo, foreignChild] = [
    randomUUID(),
    randomUUID(),
    randomUUID(),
  ];
  const planId = randomUUID();
  const versionId = randomUUID();
  const quotaVersionId = randomUUID();
  const licenseId = randomUUID();
  const suffix = randomUUID().replaceAll('-', '').slice(0, 16);
  const future = () => new Date(Date.now() + 24 * 60 * 60 * 1000);
  const past = () => new Date(Date.now() - 60 * 1000);
  const tokens = new Map<string, string>();

  async function bearer(userId: string) {
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
    return `Bearer ${token}`;
  }

  async function asset(
    uploader: string,
    status: 'PROCESSING' | 'READY',
    content?: Buffer,
  ): Promise<string> {
    const id = randomUUID();
    await prisma.asset.create({
      data: {
        id,
        familyId,
        uploaderUserId: uploader,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        status,
        storageKey: `test/${suffix}/${id}/raw`,
        mime: 'image/jpeg',
        declaredSize: 1024n,
        sizeBytes: 1024n,
        sha256: content ? createHash('sha256').update(content).digest() : null,
      },
    });
    return id;
  }

  function create(
    userId: string,
    body: Record<string, unknown>,
    key: string = randomUUID(),
  ) {
    return request(app.getHttpServer())
      .post('/api/v1/memories')
      .set('Authorization', tokens.get(userId) ?? '')
      .set('Idempotency-Key', key)
      .send({
        familyId,
        kind: 'MOMENT',
        occurredAt: '2026-10-05T09:12:00+07:00',
        visibility: 'FAMILY',
        ...body,
      });
  }

  function intent(userId: string, content: Buffer) {
    return request(app.getHttpServer())
      .post('/api/v1/media/upload-intents')
      .set('Authorization', tokens.get(userId) ?? '')
      .set('Idempotency-Key', randomUUID())
      .send({
        familyId,
        purpose: 'MEMORY',
        kind: 'IMAGE',
        mime: 'image/jpeg',
        size: content.length,
        sha256: createHash('sha256').update(content).digest('hex'),
      });
  }

  function detail(userId: string, memoryId: string) {
    return request(app.getHttpServer())
      .get(`/api/v1/memories/${memoryId}`)
      .set('Authorization', tokens.get(userId) ?? '');
  }

  function call(
    method: 'delete' | 'post' | 'get',
    userId: string,
    path: string,
  ) {
    const server = request(app.getHttpServer());
    return server[method](`/api/v1${path}`).set(
      'Authorization',
      tokens.get(userId) ?? '',
    );
  }

  function patch(
    userId: string,
    memoryId: string,
    body: Record<string, unknown>,
    version?: number | string,
  ) {
    const call = request(app.getHttpServer())
      .patch(`/api/v1/memories/${memoryId}`)
      .set('Authorization', tokens.get(userId) ?? '');
    return (
      version === undefined ? call : call.set('If-Match', `${version}`)
    ).send(body);
  }

  function send(
    method: 'post' | 'patch' | 'put' | 'delete' | 'get',
    userId: string,
    path: string,
    body?: Record<string, unknown>,
  ) {
    const server = request(app.getHttpServer());
    const call = server[method](`/api/v1${path}`).set(
      'Authorization',
      tokens.get(userId) ?? '',
    );
    return body ? call.send(body) : call;
  }

  const usageCount = async () =>
    (await prisma.familyUsage.findUniqueOrThrow({ where: { familyId } }))
      .memoryCount;

  function feed(userId: string, query = '') {
    return request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/feed${query}`)
      .set('Authorization', tokens.get(userId) ?? '');
  }

  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error(
        'Memory integration requires a dedicated *_test database.',
      );
    keys = await generateKeyPair('ES256');
    const configuration = new ConfigService({
      ...validateEnvironment({ ...process.env, ...s3 }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
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
    media = app.get(MEDIA_REPOSITORY);
    for (const userId of sessions.keys())
      tokens.set(userId, await bearer(userId));

    await prisma.user.createMany({
      data: [...sessions.keys()].map((id) => ({
        id,
        displayName: 'Synthetic memory fixture',
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
    for (const [id, name] of [
      [familyId, 'Synthetic memory family'],
      [otherFamilyId, 'Synthetic other family'],
    ] as const)
      await prisma.family.create({
        data: {
          id,
          name,
          createdBy: parentA,
          status: 'ACTIVE',
          activatedAt: past(),
          timezone: 'Asia/Ho_Chi_Minh',
        },
      });
    await prisma.familyParent.createMany({
      data: [
        { familyId, userId: parentA, slot: 'A', kind: 'FATHER', callName: 'A' },
        { familyId, userId: parentB, slot: 'B', kind: 'MOTHER', callName: 'B' },
      ],
    });
    await prisma.child.createMany({
      data: [
        {
          id: childOne,
          familyId,
          nickname: 'One',
          birthDate: new Date('2026-01-20T00:00:00Z'),
          colorIndex: 1,
          createdBy: parentA,
        },
        {
          id: childTwo,
          familyId,
          nickname: 'Two',
          birthDate: new Date('2024-06-02T00:00:00Z'),
          colorIndex: 2,
          createdBy: parentA,
        },
        {
          id: foreignChild,
          familyId: otherFamilyId,
          nickname: 'Foreign',
          birthDate: new Date('2025-01-01T00:00:00Z'),
          colorIndex: 1,
          createdBy: parentA,
        },
      ],
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `MEMORY_PLAN_${suffix}`,
        displayNameI18n: { vi: 'Synthetic memory plan' },
        purchaseEnabled: false,
        active: true,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: versionId,
        planId,
        version: 1,
        quotas: { storageBytes: 1024 * 1024 * 1024, photosPerMemory: 2 },
        features: { 'circle.enabled': false },
        availableFrom: past(),
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: versionId,
        validUntil: future(),
      },
    });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        const families = [familyId, otherFamilyId];
        await prisma.outboxEvent.deleteMany({
          where: { familyId: { in: families } },
        });
        await prisma.idempotencyRecord.deleteMany({
          where: { familyId: { in: families } },
        });
        // Running runs may not be deleted; settle them first.
        const runs = { scopeKey: `memory-test-${suffix}` };
        await prisma.jobRun.updateMany({
          where: { ...runs, status: { in: ['PENDING', 'RUNNING'] } },
          data: {
            status: 'SKIPPED',
            finishedAt: new Date(),
            leaseOwner: null,
            leaseExpiresAt: null,
          },
        });
        await prisma.jobRun.deleteMany({ where: runs });
        await prisma.comment.deleteMany({ where: { familyId } });
        await prisma.reaction.deleteMany({ where: { familyId } });
        await prisma.memoryAsset.deleteMany({ where: { familyId } });
        await prisma.memoryChild.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.assetVariant.deleteMany({ where: { familyId } });
        await prisma.storageReservation.deleteMany({ where: { familyId } });
        await prisma.asset.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.child.deleteMany({
          where: { familyId: { in: families } },
        });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: licenseId },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: { in: families } },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: [...sessions.keys()] } },
        });
        await prisma.user.updateMany({
          where: { id: { in: [...sessions.keys()] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
      }
    } finally {
      if (app) await app.close();
    }
  });

  let publishedId = '';
  let processedId = '';

  it('publishes a memory with READY media at once and replays it idempotently', async () => {
    const photo = await asset(parentA, 'READY');
    const key = randomUUID();
    const payload = {
      assetIds: [photo],
      body: 'First smile',
      childIds: [childOne],
    };
    const created = await create(parentA, payload, key).expect(201);
    const memory = data(created);
    expect(memory).toMatchObject({
      status: 'PUBLISHED',
      // No Circle sharing on this plan: FAMILY is stored as PARENTS (spec §11.5).
      visibility: 'PARENTS',
      childIds: [childOne],
      coverAssetId: photo,
    });
    publishedId = memory.id;
    const child = await prisma.memoryChild.findFirstOrThrow({
      where: { memoryId: memory.id },
    });
    expect(child.ageMonth).toBe(8); // 2026-01-20 → 2026-10-05
    const events = await prisma.outboxEvent.findMany({
      where: { aggregateId: memory.id },
      orderBy: { id: 'asc' },
    });
    expect(events.map((event) => event.eventType)).toEqual([
      'memory.created',
      'memory.published',
    ]);

    const replay = await create(parentA, payload, key).expect(201);
    expect(data(replay).id).toBe(memory.id);
    const reused = await create(
      parentA,
      { ...payload, body: 'Other' },
      key,
    ).expect(409);
    expect(data(reused).error.code).toBe('IDEMPOTENCY_KEY_REUSED');
    // An asset may belong to several memories (deduplicated uploads).
    const again = await create(parentA, payload).expect(201);
    expect(data(again).id).not.toBe(memory.id);
  });

  it('rejects invalid subjects, foreign media and plan limits', async () => {
    const untagged = await create(parentA, { body: 'Who?' }).expect(422);
    expect(data(untagged).error.code).toBe('FAMILY_MOMENT_REQUIRED');
    await create(parentA, { body: 'All of us', familyMoment: true }).expect(
      201,
    );
    const foreign = await create(parentA, {
      body: 'x',
      childIds: [foreignChild],
    }).expect(422);
    expect(data(foreign).error.code).toBe('CHILD_NOT_IN_FAMILY');
    const partnerPhoto = await asset(parentB, 'READY');
    const notMine = await create(parentA, {
      assetIds: [partnerPhoto],
      childIds: [childOne],
    }).expect(422);
    expect(data(notMine).error.code).toBe('MEMORY_ASSET_INVALID');
    const many = await Promise.all([
      asset(parentA, 'READY'),
      asset(parentA, 'READY'),
      asset(parentA, 'READY'),
    ]);
    const tooMany = await create(parentA, {
      assetIds: many,
      childIds: [childOne],
    }).expect(402);
    expect(data(tooMany).error.code).toBe('QUOTA_PHOTOS_PER_MEMORY');
    const empty = await create(parentA, { childIds: [childOne] }).expect(422);
    expect(data(empty).error.code).toBe('MEMORY_EMPTY');
    await create(parentA, {
      kind: 'QUOTE',
      body: 'x'.repeat(281),
      childIds: [childOne],
    }).expect(422);
  });

  it('keeps processing memories to their author until the worker marks media READY', async () => {
    const photo = await asset(parentA, 'PROCESSING');
    const created = await create(parentA, {
      assetIds: [photo],
      childIds: [childTwo],
      visibility: 'PARENTS',
    }).expect(201);
    const memory = data(created);
    processedId = memory.id;
    expect(memory.status).toBe('PROCESSING');

    const own = (await feed(parentA).expect(200)).body as FeedBody;
    expect(own.data.map((item) => item.id)).toContain(memory.id);
    const partner = (await feed(parentB).expect(200)).body as FeedBody;
    expect(partner.data.map((item) => item.id)).not.toContain(memory.id);
    expect(partner.data.map((item) => item.id)).toContain(publishedId);
    await request(app.getHttpServer())
      .get(`/api/v1/memories/${memory.id}`)
      .set('Authorization', tokens.get(parentB) ?? '')
      .expect(404);

    const run = await prisma.jobRun.create({
      data: {
        jobName: 'media.process-asset',
        scopeKey: `memory-test-${suffix}`,
        scheduledFor: new Date(),
        idempotencyKey: `memory-test-${suffix}-${photo}`,
        status: 'RUNNING',
        leaseOwner: 'memory-test',
        leaseExpiresAt: future(),
        fencingToken: 1n,
      },
    });
    const commit = await media.completeProcessing(
      photo,
      {
        width: 10,
        height: 10,
        durationMs: null,
        capturedAt: null,
        blurhash: null,
        keepOriginal: false,
        variants: [
          {
            code: 't320',
            storageBucket: 'bf-media',
            storageKey: `test/${suffix}/${photo}/t320.webp`,
            mime: 'image/webp',
            sizeBytes: 100n,
            width: 10,
            height: 10,
            durationMs: null,
          },
        ],
      },
      new JobLease(run.id, 1, 1n, 3, 'memory-test'),
    );
    expect(commit).toBe('COMPLETED');
    const detail = await request(app.getHttpServer())
      .get(`/api/v1/memories/${memory.id}`)
      .set('Authorization', tokens.get(parentB) ?? '')
      .expect(200);
    expect(data(detail)).toMatchObject({
      status: 'PUBLISHED',
      assets: [{ assetId: photo, status: 'READY' }],
    });
    const published = await prisma.outboxEvent.count({
      where: { aggregateId: memory.id, eventType: 'memory.published' },
    });
    expect(published).toBe(1);
  });

  it('pages the feed with an opaque cursor and filters by child', async () => {
    const first = (await feed(parentA, '?limit=1').expect(200))
      .body as FeedBody;
    expect(first.data).toHaveLength(1);
    expect(first.nextCursor).toBeTruthy();
    const second = (
      await feed(
        parentA,
        `?limit=1&cursor=${encodeURIComponent(first.nextCursor ?? '')}`,
      ).expect(200)
    ).body as FeedBody;
    expect(second.data[0]?.id).not.toBe(first.data[0]?.id);
    const byChild = (await feed(parentA, `?childId=${childOne}`).expect(200))
      .body as FeedBody;
    expect(byChild.data.map((item) => item.id)).toContain(publishedId);
    expect(byChild.data).toHaveLength(2);
    await feed(parentA, '?cursor=not-a-cursor').expect(400);
  });

  it('does not recreate a trashed memory when its Idempotency-Key is replayed', async () => {
    const key = randomUUID();
    const payload = { body: 'To trash', childIds: [childOne] };
    const created = data(await create(parentA, payload, key).expect(201));
    await prisma.memory.update({
      where: { id: created.id },
      data: {
        status: 'TRASHED',
        trashedAt: new Date(),
        purgeAfter: future(),
        deletedAt: new Date(),
      },
    });
    await create(parentA, payload, key).expect(404);
    expect(
      await prisma.memory.count({ where: { familyId, body: 'To trash' } }),
    ).toBe(1);
  });
  it("reuses the partner's visible verified copy, never a private or unshared one", async () => {
    const sharedPhoto = randomBytes(64);
    const partnerAsset = await asset(parentB, 'READY', sharedPhoto);
    await create(parentB, {
      assetIds: [partnerAsset],
      childIds: [childOne],
      visibility: 'PARENTS',
    }).expect(201);
    // B's memory is visible to A: the upload intent returns B's stored copy...
    const deduplicated = data(await intent(parentA, sharedPhoto).expect(201));
    expect(deduplicated).toMatchObject({
      assetId: partnerAsset,
      deduplicated: true,
    });
    // ...and A may attach it to their own memory (spec §6.3).
    const reused = data(
      await create(parentA, {
        assetIds: [partnerAsset],
        childIds: [childOne],
      }).expect(201),
    );
    expect(reused).toMatchObject({
      status: 'PUBLISHED',
      assets: [{ assetId: partnerAsset }],
    });

    const privatePhoto = randomBytes(64);
    const privateAsset = await asset(parentB, 'READY', privatePhoto);
    await create(parentB, {
      assetIds: [privateAsset],
      childIds: [childOne],
      visibility: 'PRIVATE',
    }).expect(201);
    const separate = data(await intent(parentA, privatePhoto).expect(201));
    expect(separate.deduplicated).toBe(false);
    expect(separate.assetId).not.toBe(privateAsset);
    const leaked = await create(parentA, {
      assetIds: [privateAsset],
      childIds: [childOne],
    }).expect(422);
    expect(data(leaked).error.code).toBe('MEMORY_ASSET_INVALID');
  });

  it('keeps memories and their media readable after the subscription expired', async () => {
    await prisma.familyEntitlement.updateMany({
      where: { familyId },
      data: { accessPhase: 'EXPIRED', validUntil: past() },
    });
    try {
      const memory = data(await detail(parentB, processedId).expect(200));
      expect(memory.assets[0]?.urls.t320).toEqual(expect.any(String));
      // Only the spec §6.5 download allowlist stays open.
      const blocked = await feed(parentA).expect(402);
      expect(data(blocked).error.code).toBe('SUBSCRIPTION_REQUIRED');
      await create(parentA, { body: 'Late', childIds: [childOne] }).expect(402);
      await request(app.getHttpServer())
        .post('/api/v1/media/urls')
        .set('Authorization', tokens.get(parentB) ?? '')
        .send({ assetIds: [memory.assets[0]?.assetId] })
        .expect(200)
        .expect((response) =>
          expect(
            (response.body as { data: { items: unknown[] } }).data.items,
          ).toHaveLength(0),
        );
    } finally {
      await prisma.familyEntitlement.updateMany({
        where: { familyId },
        data: { accessPhase: 'PAID', validUntil: future() },
      });
    }
  });

  it('counts memories atomically and enforces the plan memoryCount quota', async () => {
    const usage = await prisma.familyUsage.findUniqueOrThrow({
      where: { familyId },
    });
    expect(usage.memoryCount).toBeGreaterThan(0);
    await prisma.planVersion.create({
      data: {
        id: quotaVersionId,
        planId,
        version: 2,
        quotas: {
          storageBytes: 1024 * 1024 * 1024,
          photosPerMemory: 2,
          memoryCount: usage.memoryCount + 1,
        },
        features: { 'circle.enabled': false },
        availableFrom: past(),
      },
    });
    await prisma.familyEntitlement.updateMany({
      where: { familyId },
      data: { effectivePlanVersionId: quotaVersionId },
    });
    try {
      // One slot left, two concurrent requests: exactly one wins.
      const results = await Promise.all([
        create(parentA, { body: 'Race A', childIds: [childOne] }),
        create(parentB, { body: 'Race B', childIds: [childOne] }),
      ]);
      expect(results.map((result) => result.status).sort()).toEqual([201, 402]);
      const loser = results.find((result) => result.status === 402)!;
      expect(data(loser).error.code).toBe('QUOTA_MEMORY_COUNT_EXCEEDED');
      const after = await prisma.familyUsage.findUniqueOrThrow({
        where: { familyId },
      });
      expect(after.memoryCount).toBe(usage.memoryCount + 1);
    } finally {
      await prisma.familyEntitlement.updateMany({
        where: { familyId },
        data: { effectivePlanVersionId: versionId },
      });
    }
    // Without a memoryCount quota the plan sets no limit (still counted).
    await create(parentA, { body: 'Unlimited', childIds: [childOne] }).expect(
      201,
    );
  });
  it('moves a memory to the trash, lists it for Parents and restores it', async () => {
    const photo = await asset(parentA, 'READY');
    const memory = data(
      await create(parentA, {
        assetIds: [photo],
        body: 'To the trash',
        childIds: [childOne],
        visibility: 'PARENTS',
      }).expect(201),
    );
    const before = await usageCount();
    // canDeleteMemory: any Parent who sees the memory (spec §6.2).
    await call('delete', parentB, `/memories/${memory.id}`).expect(204);
    await call('delete', parentB, `/memories/${memory.id}`).expect(204);
    expect(await usageCount()).toBe(before - 1);
    await detail(parentA, memory.id).expect(404);
    const live = (await feed(parentA).expect(200)).body as FeedBody;
    expect(live.data.map((item) => item.id)).not.toContain(memory.id);

    const trash = (
      await call('get', parentA, `/families/${familyId}/trash`).expect(200)
    ).body as FeedBody;
    const item = trash.data.find((entry) => entry.id === memory.id);
    expect(item).toMatchObject({ status: 'TRASHED' });
    const keptFor =
      new Date(item!.purgeAfter!).getTime() -
      new Date(item!.trashedAt!).getTime();
    expect(Math.round(keptFor / 86_400_000)).toBe(30);
    // Thumbnails of the trash are still signed for the same audience.
    expect(item!.assets[0]?.assetId).toBe(photo);

    const restored = data(
      await call('post', parentA, `/memories/${memory.id}/restore`).expect(200),
    );
    expect(restored).toMatchObject({
      status: 'PUBLISHED',
      trashedAt: null,
      purgeAfter: null,
    });
    expect(await usageCount()).toBe(before);
    await call('post', parentA, `/memories/${memory.id}/restore`).expect(200);
    const events = await prisma.outboxEvent.findMany({
      where: { aggregateId: memory.id },
      orderBy: { id: 'asc' },
    });
    expect(events.map((event) => event.eventType)).toEqual([
      'memory.created',
      'memory.published',
      'memory.trashed',
      'memory.restored',
    ]);
  });

  it("never exposes or deletes the partner's private memory", async () => {
    const secret = data(
      await create(parentA, {
        body: 'Only me',
        childIds: [childOne],
        visibility: 'PRIVATE',
      }).expect(201),
    );
    await call('delete', parentB, `/memories/${secret.id}`).expect(404);
    await call('delete', parentA, `/memories/${secret.id}`).expect(204);
    const partnerTrash = (
      await call('get', parentB, `/families/${familyId}/trash`).expect(200)
    ).body as FeedBody;
    expect(partnerTrash.data.map((item) => item.id)).not.toContain(secret.id);
    await call('post', parentB, `/memories/${secret.id}/restore`).expect(404);
    await call('delete', parentB, `/memories/${secret.id}/purge`).expect(404);
    const ownTrash = (
      await call('get', parentA, `/families/${familyId}/trash`).expect(200)
    ).body as FeedBody;
    expect(ownTrash.data.map((item) => item.id)).toContain(secret.id);
  });

  it('purges permanently on request and after 30 days, then retires unused media', async () => {
    const photo = await asset(parentA, 'READY');
    const manual = data(
      await create(parentA, {
        assetIds: [photo],
        body: 'Purge me',
        childIds: [childOne],
      }).expect(201),
    );
    // Not in the trash yet: purge is refused.
    await call('delete', parentA, `/memories/${manual.id}/purge`).expect(404);
    await call('delete', parentA, `/memories/${manual.id}`).expect(204);
    await call('delete', parentA, `/memories/${manual.id}/purge`).expect(204);
    expect(
      await prisma.memory.findUniqueOrThrow({ where: { id: manual.id } }),
    ).toMatchObject({ status: 'PURGED', deletedAt: expect.any(Date) });
    await call('post', parentA, `/memories/${manual.id}/restore`).expect(404);
    expect(
      await media.findPurgeCandidates('DETACHED', new Date(), 1000),
    ).toContain(photo);
    expect(await media.retireAsset(photo, 'DETACHED', new Date())).toBe(true);

    const expiring = data(
      await create(parentA, { body: 'Expires', childIds: [childOne] }).expect(
        201,
      ),
    );
    await call('delete', parentA, `/memories/${expiring.id}`).expect(204);
    await prisma.memory.update({
      where: { id: expiring.id },
      data: { purgeAfter: past() },
    });
    // Expired trash is no longer listed or restorable, even before the job runs.
    await call('post', parentA, `/memories/${expiring.id}/restore`).expect(404);
    const job = new MemoryMaintenanceService(
      app.get<IMemoryContentRepository>(MEMORY_CONTENT_REPOSITORY),
    );
    expect(
      (await job.purgeExpiredTrash(new Date(), familyId)).purged,
    ).toBeGreaterThan(0);
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: expiring.id } }))
        .status,
    ).toBe('PURGED');
  });
  it('lets the author edit a memory with If-Match and rejects stale versions', async () => {
    const memory = data(
      await create(parentA, {
        body: 'Before',
        childIds: [childOne],
        visibility: 'PARENTS',
      }).expect(201),
    );
    await patch(parentA, memory.id, { body: 'x' }).expect(428);
    await patch(parentA, memory.id, { body: 'x' }, 'v1').expect(400);
    const edited = data(
      await patch(
        parentA,
        memory.id,
        {
          title: 'Ngày đầu',
          body: '  After  ',
          childIds: [childOne, childTwo],
          occurredAt: '2026-06-02T08:00:00+07:00',
        },
        `"${memory.version}"`,
      ).expect(200),
    );
    expect(edited).toMatchObject({
      version: memory.version + 1,
      title: 'Ngày đầu',
      body: 'After',
      childIds: expect.arrayContaining([childOne, childTwo]),
      occurredAt: '2026-06-02T01:00:00.000Z',
    });
    // age_month follows the new date: childTwo born 2024-06-02 → 24 months.
    const two = await prisma.memoryChild.findUniqueOrThrow({
      where: { memoryId_childId: { memoryId: memory.id, childId: childTwo } },
    });
    expect(two.ageMonth).toBe(24);
    const stale = await patch(
      parentA,
      memory.id,
      { body: 'Lost update' },
      memory.version,
    ).expect(412);
    expect(data(stale).error.code).toBe('VERSION_CONFLICT');

    // Removing then re-adding a child restores the same link row.
    const removed = data(
      await patch(
        parentA,
        memory.id,
        { childIds: [childTwo] },
        edited.version,
      ).expect(200),
    );
    expect(removed.childIds).toEqual([childTwo]);
    const back = data(
      await patch(
        parentA,
        memory.id,
        { childIds: [childOne, childTwo] },
        removed.version,
      ).expect(200),
    );
    expect(back.childIds).toHaveLength(2);
    const emptied = await patch(
      parentA,
      memory.id,
      { title: null, body: ' ' },
      back.version,
    ).expect(422);
    expect(data(emptied).error.code).toBe('MEMORY_EMPTY');
    const foreign = await patch(
      parentA,
      memory.id,
      { childIds: [foreignChild] },
      back.version,
    ).expect(422);
    expect(data(foreign).error.code).toBe('CHILD_NOT_IN_FAMILY');
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: memory.id, eventType: 'memory.updated' },
      }),
    ).toBe(3);
  });

  it('lets the other Parent only re-tag children and change visibility', async () => {
    const memory = data(
      await create(parentA, {
        body: 'By A',
        childIds: [childOne],
        visibility: 'PARENTS',
      }).expect(201),
    );
    const locked = await patch(
      parentB,
      memory.id,
      { body: 'Rewritten by B' },
      memory.version,
    ).expect(403);
    expect(data(locked).error.code).toBe('MEMORY_FIELD_NOT_EDITABLE');
    const hidden = await patch(
      parentB,
      memory.id,
      { visibility: 'PRIVATE' },
      memory.version,
    ).expect(422);
    expect(data(hidden).error.code).toBe('MEMORY_VISIBILITY_INVALID');
    const retagged = data(
      await patch(
        parentB,
        memory.id,
        { childIds: [childTwo], visibility: 'FAMILY' },
        memory.version,
      ).expect(200),
    );
    // No Circle on this plan: FAMILY is stored as PARENTS (spec §11.5 (4)).
    expect(retagged).toMatchObject({
      childIds: [childTwo],
      visibility: 'PARENTS',
      body: 'By A',
    });
    const secret = data(
      await create(parentA, {
        body: 'Private',
        childIds: [childOne],
        visibility: 'PRIVATE',
      }).expect(201),
    );
    await patch(
      parentB,
      secret.id,
      { childIds: [childTwo] },
      secret.version,
    ).expect(404);
  });
  it('threads comments one level deep with edit window and Parent removal', async () => {
    const memory = data(
      await create(parentA, {
        body: 'Comment me',
        childIds: [childOne],
        visibility: 'PARENTS',
      }).expect(201),
    );
    const path = `/memories/${memory.id}/comments`;
    const root = data(
      await send('post', parentA, path, { body: '  Đáng yêu quá  ' }).expect(
        201,
      ),
    ) as unknown as { id: string; body: string; parentCommentId: string };
    expect(root.body).toBe('Đáng yêu quá');
    const reply = data(
      await send('post', parentB, path, {
        body: 'Giống bố',
        parentCommentId: root.id,
      }).expect(201),
    ) as unknown as { id: string; parentCommentId: string };
    expect(reply.parentCommentId).toBe(root.id);
    // A reply to a reply joins the root thread (one level, spec §7.12).
    const nested = data(
      await send('post', parentA, path, {
        body: 'Ừ',
        parentCommentId: reply.id,
      }).expect(201),
    ) as unknown as { parentCommentId: string };
    expect(nested.parentCommentId).toBe(root.id);
    const empty = await send('post', parentA, path, { body: '   ' }).expect(
      422,
    );
    expect(data(empty).error.code).toBe('COMMENT_EMPTY');
    await send('post', parentA, path, { body: 'x'.repeat(1001) }).expect(400);

    const list = (await send('get', parentB, path).expect(200)).body as {
      data: { id: string }[];
    };
    expect(list.data.map((item) => item.id)).toEqual([
      root.id,
      reply.id,
      expect.any(String),
    ]);
    expect(
      (
        data(await detail(parentA, memory.id).expect(200)) as unknown as {
          commentCount: number;
        }
      ).commentCount,
    ).toBe(3);

    const edited = data(
      await send('patch', parentA, `/comments/${root.id}`, {
        body: 'Đáng yêu',
      }).expect(200),
    ) as unknown as { body: string; editedAt: string | null };
    expect(edited).toMatchObject({
      body: 'Đáng yêu',
      editedAt: expect.any(String),
    });
    const notMine = await send('patch', parentB, `/comments/${root.id}`, {
      body: 'x',
    }).expect(403);
    expect(data(notMine).error.code).toBe('COMMENT_NOT_AUTHOR');
    // created_at is immutable on UPDATE (DB trigger): insert an old comment.
    const old = await prisma.comment.create({
      data: {
        familyId,
        memoryId: memory.id,
        authorUserId: parentB,
        body: 'Old',
        createdAt: new Date(Date.now() - 16 * 60 * 1000),
      },
    });
    const late = await send('patch', parentB, `/comments/${old.id}`, {
      body: 'x',
    }).expect(403);
    expect(data(late).error.code).toBe('COMMENT_EDIT_EXPIRED');
    await prisma.comment.delete({ where: { id: old.id } });

    // A Parent removes any comment of the family; replies go with it.
    await send('delete', parentB, `/comments/${root.id}`).expect(204);
    const after = (await send('get', parentA, path).expect(200)).body as {
      data: unknown[];
    };
    expect(after.data).toHaveLength(0);
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memory.id } }))
        .commentCount,
    ).toBe(0);
    await send('delete', parentB, `/comments/${root.id}`).expect(404);
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'comment.created' },
      }),
    ).toBeGreaterThanOrEqual(3);
  });

  it('refuses comments on hidden or comment-disabled memories', async () => {
    const quiet = data(
      await create(parentA, {
        body: 'No comments',
        childIds: [childOne],
        commentsEnabled: false,
      }).expect(201),
    );
    const disabled = await send(
      'post',
      parentB,
      `/memories/${quiet.id}/comments`,
      { body: 'Hi' },
    ).expect(403);
    expect(data(disabled).error.code).toBe('COMMENTS_DISABLED');
    const secret = data(
      await create(parentA, {
        body: 'Mine',
        childIds: [childOne],
        visibility: 'PRIVATE',
      }).expect(201),
    );
    const own = data(
      await send('post', parentA, `/memories/${secret.id}/comments`, {
        body: 'Note to self',
      }).expect(201),
    ) as unknown as { id: string };
    await send('get', parentB, `/memories/${secret.id}/comments`).expect(404);
    await send('delete', parentB, `/comments/${own.id}`).expect(404);
    await send('patch', parentB, `/comments/${own.id}`, { body: 'x' }).expect(
      404,
    );
  });

  it('keeps one changeable reaction per person with exact counts', async () => {
    const memory = data(
      await create(parentA, {
        body: 'React',
        childIds: [childOne],
        visibility: 'PARENTS',
      }).expect(201),
    );
    const path = `/memories/${memory.id}/reaction`;
    expect(
      data(await send('put', parentA, path, { type: 'LOVE' }).expect(200)),
    ).toMatchObject({
      reactions: { LOVE: 1 },
      myReaction: 'LOVE',
      reactionCount: 1,
    });
    expect(
      data(await send('put', parentA, path, { type: 'CLAP' }).expect(200)),
    ).toMatchObject({ reactions: { CLAP: 1 }, reactionCount: 1 });
    await send('put', parentA, path, { type: 'CLAP' }).expect(200);
    await send('put', parentB, path, { type: 'LOVE' }).expect(200);
    await send('put', parentB, path, { type: 'WOW' }).expect(400);
    expect(data(await detail(parentA, memory.id).expect(200))).toMatchObject({
      reactions: { CLAP: 1, LOVE: 1 },
      myReaction: 'CLAP',
      reactionCount: 2,
    });
    expect(data(await send('delete', parentA, path).expect(200))).toMatchObject(
      { reactions: { LOVE: 1 }, myReaction: null, reactionCount: 1 },
    );
    await send('delete', parentA, path).expect(200);
    // Re-reacting after removal restores the same row and counts it again.
    expect(
      data(await send('put', parentA, path, { type: 'HAHA' }).expect(200)),
    ).toMatchObject({ reactionCount: 2 });
  });
});
