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
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../../src/interfaces/services/object-storage-service.interface';

// Real PostgreSQL (*_test) + MinIO from ../baby-storage. S3 settings come from TEST_*
// or the developer's .env; the suite is skipped when object storage is not configured.
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

const MIB = 1024 * 1024;

interface PartUrl {
  n: number;
  url: string;
}
/** Loose view of the JSON responses used by this suite. */
interface ApiBody {
  assetId: string;
  status: string;
  source?: { sha256: string; key: string; capturedAt: string | null } | null;
  deduplicated: boolean;
  variantUploads: {
    code: string;
    upload: {
      mode: string;
      url: string;
      method: string;
      headers: Record<string, string>;
    };
  }[];
  upload: {
    mode: string;
    url: string;
    headers: Record<string, string>;
    partCount: number;
    parts: PartUrl[];
  };
  parts: PartUrl[];
  urls: Record<string, string>;
  urlsExpireAt: string | null;
  items: unknown[];
  unavailableIds: string[];
  error: { code: string };
}
// Success payloads arrive in the spec §11.1 `{ data }` envelope; errors stay `{ error }`.
const body = (response: { body: unknown }) => {
  const raw = response.body as { data?: ApiBody; error?: unknown };
  return (raw.error === undefined ? raw.data : raw) as ApiBody;
};
const reserved = (size: number) => {
  const declared = BigInt(size);
  return declared + (declared * 5n + 99n) / 100n;
};
const sha256 = (body: Buffer) =>
  createHash('sha256').update(body).digest('hex');

describeStack('Media upload + view URLs (PostgreSQL + MinIO + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let storage: IObjectStorageService;
  let configuration: ConfigService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  const [parentA, parentB, outsider, relative] = [
    randomUUID(),
    randomUUID(),
    randomUUID(),
    randomUUID(),
  ];
  const sessions = new Map<string, string>([
    [parentA, randomUUID()],
    [parentB, randomUUID()],
    [outsider, randomUUID()],
    [relative, randomUUID()],
  ]);
  const familyId = randomUUID();
  const childId = randomUUID();
  const memberId = randomUUID();
  const planId = randomUUID();
  const versionId = randomUUID();
  const noCircleVersionId = randomUUID();
  const licenseId = randomUUID();
  const suffix = randomUUID().replaceAll('-', '').slice(0, 16);
  const future = () => new Date(Date.now() + 24 * 60 * 60 * 1000);
  const past = () => new Date(Date.now() - 60 * 1000);

  const tokens = new Map<string, string>();
  const auth = (userId: string) => tokens.get(userId) ?? '';

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

  function intent(
    userId: string,
    body: Record<string, unknown>,
    key: string = randomUUID(),
  ) {
    return request(app.getHttpServer())
      .post('/api/v1/media/upload-intents')
      .set('Authorization', auth(userId))
      .set('Idempotency-Key', key)
      .send({ familyId, purpose: 'MEMORY', ...body });
  }

  function complete(userId: string, assetId: string, body = {}) {
    return request(app.getHttpServer())
      .post(`/api/v1/media/${assetId}/complete`)
      .set('Authorization', auth(userId))
      .send(body);
  }

  function getMedia(userId: string, assetId: string) {
    return request(app.getHttpServer())
      .get(`/api/v1/media/${assetId}`)
      .set('Authorization', auth(userId));
  }

  async function usage() {
    return prisma.familyUsage.findUniqueOrThrow({ where: { familyId } });
  }

  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error(
        'Media integration requires a dedicated *_test database.',
      );
    keys = await generateKeyPair('ES256');
    configuration = new ConfigService({
      ...validateEnvironment({ ...process.env, ...s3 }),
      MEDIA_SERVER_PROCESSING: 'legacy',
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
    storage = app.get(OBJECT_STORAGE_SERVICE);
    for (const userId of sessions.keys())
      tokens.set(userId, await bearer(userId));

    await prisma.user.createMany({
      data: [...sessions.keys()].map((id) => ({
        id,
        displayName: 'Synthetic media fixture',
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
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic media family',
        createdBy: parentA,
        status: 'ACTIVE',
        activatedAt: past(),
      },
    });
    await prisma.familyParent.createMany({
      data: [
        { familyId, userId: parentA, slot: 'A', kind: 'FATHER', callName: 'A' },
        { familyId, userId: parentB, slot: 'B', kind: 'MOTHER', callName: 'B' },
      ],
    });
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic child',
        birthDate: new Date('2025-01-01'),
        colorIndex: 1,
        createdBy: parentA,
      },
    });
    await prisma.circleMember.create({
      data: {
        id: memberId,
        familyId,
        userId: relative,
        relation: 'OTHER',
        displayName: 'Synthetic relative',
      },
    });
    await prisma.circleGrant.create({
      data: {
        circleMemberId: memberId,
        familyId,
        childId,
        permission: 'CONTRIBUTE',
        createdBy: parentA,
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `MEDIA_PLAN_${suffix}`,
        displayNameI18n: { vi: 'Synthetic media plan' },
        purchaseEnabled: false,
        active: true,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: versionId,
        planId,
        version: 1,
        quotas: { storageBytes: 64 * MIB, videoMaxSec: 5, audioMaxSec: 60 },
        features: { 'circle.enabled': true },
        availableFrom: past(),
      },
    });
    await prisma.planVersion.create({
      data: {
        id: noCircleVersionId,
        planId,
        version: 2,
        quotas: { storageBytes: 64 * MIB, videoMaxSec: 5, audioMaxSec: 60 },
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
        effectivePlanVersionId: versionId,
        validUntil: future(),
      },
    });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        const assets = await prisma.asset.findMany({ where: { familyId } });
        const variants = await prisma.assetVariant.findMany({
          where: { familyId },
        });
        for (const object of [...assets, ...variants]) {
          const bucket = storage.bucketOf(object.storageBucket);
          if (bucket)
            await storage.deleteObject({ bucket, key: object.storageKey });
        }
        for (const asset of assets)
          if (asset.multipartUploadId)
            await storage.abortMultipartUpload(
              { bucket: 'media', key: asset.storageKey },
              asset.multipartUploadId,
            );
        await prisma.outboxEvent.deleteMany({ where: { familyId } });
        await prisma.memoryChild.deleteMany({ where: { familyId } });
        await prisma.memoryAsset.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.assetVariant.deleteMany({ where: { familyId } });
        await prisma.storageReservation.deleteMany({ where: { familyId } });
        await prisma.asset.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.circleGrant.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.child.deleteMany({ where: { familyId } });
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

  const photo = randomBytes(64 * 1024);
  let photoId = '';

  it('creates a signed single upload, replays it idempotently and completes it', async () => {
    const key = randomUUID();
    const payload = {
      kind: 'IMAGE',
      mime: 'image/jpeg',
      size: photo.length,
      sha256: sha256(photo),
      width: 640,
      height: 480,
    };
    const created = await intent(parentA, payload, key).expect(201);
    expect(body(created)).toMatchObject({
      status: 'PENDING_UPLOAD',
      deduplicated: false,
      upload: { mode: 'single', method: 'PUT' },
    });
    photoId = body(created).assetId;
    expect((await usage()).reservedStorageBytes).toBe(reserved(photo.length));

    const replay = await intent(parentA, payload, key).expect(201);
    expect(body(replay).assetId).toBe(photoId);
    await intent(parentA, payload, key).expect(201);
    const reused = await intent(parentA, { ...payload, size: 10 }, key).expect(
      409,
    );
    expect(body(reused).error.code).toBe('IDEMPOTENCY_KEY_REUSED');

    const upload = body(created).upload as {
      url: string;
      headers: Record<string, string>;
    };
    expect(upload.headers['x-amz-checksum-sha256']).toBeTruthy();
    // The signed checksum makes storage reject any other body.
    const tampered = await fetch(upload.url, {
      method: 'PUT',
      headers: upload.headers,
      body: randomBytes(photo.length),
    });
    expect(tampered.ok).toBe(false);
    const put = await fetch(upload.url, {
      method: 'PUT',
      headers: upload.headers,
      body: photo,
    });
    expect(put.status).toBe(200);

    await complete(parentB, photoId).expect(403);
    await complete(outsider, photoId).expect(404);
    const done = await complete(parentA, photoId).expect(202);
    expect(body(done)).toEqual({ assetId: photoId, status: 'UPLOADED' });
    await complete(parentA, photoId).expect(202); // idempotent
    // Replaying the intent after completion reports state but never re-signs a PUT.
    const finished = await intent(parentA, payload, key).expect(201);
    expect(body(finished)).toEqual({
      assetId: photoId,
      status: 'UPLOADED',
      deduplicated: false,
    });
    const after = await usage();
    expect(after.reservedStorageBytes).toBe(0n);
    expect(after.storageBytes).toBe(BigInt(photo.length));
    expect(
      await prisma.outboxEvent.count({
        where: {
          familyId,
          eventType: 'media.asset_uploaded',
          aggregateId: photoId,
        },
      }),
    ).toBe(1);
    const reservation = await prisma.storageReservation.findFirstOrThrow({
      where: { assetId: photoId },
    });
    expect(reservation).toMatchObject({ status: 'CONFIRMED' });
  });

  it("deduplicates per uploader and never hands out the partner's unshared copy", async () => {
    const same = {
      kind: 'IMAGE',
      mime: 'image/jpeg',
      size: photo.length,
      sha256: sha256(photo),
    };
    const own = await intent(parentA, same).expect(201);
    expect(body(own)).toEqual({
      assetId: photoId,
      status: 'UPLOADED',
      deduplicated: true,
    });
    // Parent A's upload is not linked to any memory B can see: knowing the hash
    // must not grant access to it, so B gets an upload of their own.
    const partner = await intent(parentB, same).expect(201);
    expect(body(partner)).toMatchObject({ deduplicated: false });
    expect(body(partner).assetId).not.toBe(photoId);
  });

  it('validates input, plan duration and storage quota', async () => {
    const base = {
      kind: 'IMAGE',
      mime: 'image/jpeg',
      size: 10,
      sha256: sha256(randomBytes(8)),
    };
    await request(app.getHttpServer())
      .post('/api/v1/media/upload-intents')
      .set('Authorization', auth(parentA))
      .send({ familyId, purpose: 'MEMORY', ...base })
      .expect(400); // Idempotency-Key required
    const unsupported = await intent(parentA, {
      ...base,
      mime: 'image/heic',
    }).expect(422);
    expect(body(unsupported).error.code).toBe('MEDIA_TYPE_UNSUPPORTED');
    const purpose = await intent(parentA, {
      ...base,
      kind: 'VIDEO',
      mime: 'video/mp4',
      purpose: 'AVATAR',
      durationMs: 1000,
    }).expect(422);
    expect(body(purpose).error.code).toBe('MEDIA_PURPOSE_INVALID');
    await intent(parentA, { ...base, purpose: 'RECAP' }).expect(400);
    await intent(parentA, { ...base, kind: 'VIDEO', mime: 'video/mp4' }).expect(
      400,
    );
    const duration = await intent(parentA, {
      ...base,
      kind: 'VIDEO',
      mime: 'video/mp4',
      durationMs: 6000,
    }).expect(422);
    expect(body(duration).error.code).toBe('MEDIA_DURATION_EXCEEDED');
    const quota = await intent(parentA, {
      ...base,
      kind: 'VIDEO',
      mime: 'video/mp4',
      size: 65 * MIB,
      durationMs: 1000,
    }).expect(402);
    expect(body(quota).error.code).toBe('QUOTA_STORAGE_EXCEEDED');
    await intent(outsider, base).expect(404);
  });

  it('runs multipart uploads, re-signs parts and rejects oversized objects', async () => {
    const size = 21 * MIB; // parts of 8 + 8 + 5 MiB
    const video = {
      kind: 'VIDEO',
      mime: 'video/mp4',
      size,
      sha256: sha256(randomBytes(8)),
      durationMs: 3000,
    };
    const created = await intent(parentA, video).expect(201);
    expect(body(created).upload).toMatchObject({
      mode: 'multipart',
      partCount: 3,
    });
    const assetId = body(created).assetId;
    const resigned = await request(app.getHttpServer())
      .post(`/api/v1/media/${assetId}/parts`)
      .set('Authorization', auth(parentA))
      .send({ partNumbers: [3] })
      .expect(200);
    expect(body(resigned).parts).toHaveLength(1);

    const sizes = [8 * MIB, 8 * MIB, size - 16 * MIB];
    const parts = body(created).upload.parts as { n: number; url: string }[];
    const etags: { n: number; etag: string }[] = [];
    for (const part of parts) {
      const url =
        part.n === 3 ? (body(resigned).parts[0]?.url ?? '') : part.url;
      const response = await fetch(url, {
        method: 'PUT',
        body: randomBytes(sizes[part.n - 1]!),
      });
      expect(response.status).toBe(200);
      etags.push({ n: part.n, etag: response.headers.get('etag')! });
    }
    await complete(parentA, assetId, { parts: etags.slice(0, 2) }).expect(400);
    await complete(parentA, assetId).expect(400);
    const done = await complete(parentA, assetId, { parts: etags }).expect(202);
    expect(body(done).status).toBe('UPLOADED');
    // The multipart hash is unverified until the worker runs: no dedup yet.
    const pending = await intent(parentA, video).expect(409);
    expect(body(pending).error.code).toBe('UPLOAD_PENDING_VERIFICATION');

    // Oversized: parts total more than declared + 5 %.
    const declared = { ...video, sha256: sha256(randomBytes(8)) };
    const oversized = await intent(parentA, declared).expect(201);
    const oversizedId = body(oversized).assetId;
    const reservedBefore = (await usage()).reservedStorageBytes;
    const bigParts: { n: number; etag: string }[] = [];
    for (const part of body(oversized).upload.parts as {
      n: number;
      url: string;
    }[]) {
      const response = await fetch(part.url, {
        method: 'PUT',
        body: randomBytes(8 * MIB), // 24 MiB > 21 MiB + 5 %
      });
      bigParts.push({ n: part.n, etag: response.headers.get('etag')! });
    }
    const rejected = await complete(parentA, oversizedId, {
      parts: bigParts,
    }).expect(422);
    expect(body(rejected).error.code).toBe('UPLOAD_SIZE_MISMATCH');
    expect((await usage()).reservedStorageBytes).toBe(
      reservedBefore - reserved(size),
    );
    const failed = await prisma.asset.findUniqueOrThrow({
      where: { id: oversizedId },
    });
    expect(failed).toMatchObject({
      status: 'FAILED',
      failureReason: 'SIZE_MISMATCH',
    });
    await expect(
      storage.headObject({ bucket: 'media', key: failed.storageKey }),
    ).resolves.toBeNull();
  });

  it('signs view URLs only for media the Parent may see (spec §6.3)', async () => {
    // Not READY and not attached: only the uploader sees it, without URLs.
    const own = await getMedia(parentA, photoId).expect(200);
    expect(body(own)).toMatchObject({
      status: 'UPLOADED',
      urls: {},
      urlsExpireAt: null,
    });
    await getMedia(parentB, photoId).expect(404);
    await getMedia(outsider, photoId).expect(404);

    // Simulate the media worker: READY + one processed variant.
    const asset = await prisma.asset.update({
      where: { id: photoId },
      data: { status: 'READY', readyAt: new Date(), blurhash: 'LKO2?U%2Tw=w' },
    });
    const variantKey = `fam/${familyId}/a/${photoId}/t320.webp`;
    const thumbnail = randomBytes(1024);
    const upload = await storage.createUploadUrl({
      bucket: 'media',
      key: variantKey,
      contentType: 'image/webp',
    });
    await fetch(upload.url, {
      method: 'PUT',
      headers: upload.headers,
      body: thumbnail,
    });
    await prisma.assetVariant.create({
      data: {
        familyId,
        assetId: photoId,
        variantCode: 't320',
        storageBucket: asset.storageBucket,
        storageKey: variantKey,
        mime: 'image/webp',
        sizeBytes: BigInt(thumbnail.length),
      },
    });
    const memory = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: parentA,
        authorRole: 'PARENT',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        visibility: 'PARENTS',
        status: 'PUBLISHED',
        publishedAt: new Date(),
      },
    });
    await prisma.memoryAsset.create({
      data: { memoryId: memory.id, assetId: photoId, familyId, sortOrder: 0 },
    });

    const shared = await getMedia(parentB, photoId).expect(200);
    expect(Object.keys(body(shared).urls)).toEqual(['t320']);
    expect(body(shared).urlsExpireAt).toBeTruthy();
    expect(body(shared).urls.t320).not.toContain('/orig');
    const fetched = await fetch(body(shared).urls.t320 as string);
    expect(Buffer.from(await fetched.arrayBuffer()).equals(thumbnail)).toBe(
      true,
    );

    const batch = await request(app.getHttpServer())
      .post('/api/v1/media/urls')
      .set('Authorization', auth(parentB))
      .send({ assetIds: [photoId, randomUUID()] })
      .expect(200);
    expect(body(batch).items).toHaveLength(1);
    expect(body(batch).unavailableIds).toHaveLength(1);
    const outsiderBatch = await request(app.getHttpServer())
      .post('/api/v1/media/urls')
      .set('Authorization', auth(outsider))
      .send({ assetIds: [photoId] })
      .expect(200);
    expect(body(outsiderBatch)).toEqual({
      items: [],
      unavailableIds: [photoId],
    });

    // PRIVATE memory of the partner and sealed letters hide the media again.
    await prisma.memory.update({
      where: { id: memory.id },
      data: { visibility: 'PRIVATE' },
    });
    await getMedia(parentB, photoId).expect(404);
    await getMedia(parentA, photoId).expect(200);
    await prisma.memory.update({
      where: { id: memory.id },
      data: { visibility: 'PARENTS', kind: 'LETTER', unlockAt: future() },
    });
    await getMedia(parentB, photoId).expect(404);
    // Trash (MEM-17) keeps its thumbnails for the same audience until purge_after.
    await prisma.memory.update({
      where: { id: memory.id },
      data: {
        kind: 'MOMENT',
        unlockAt: null,
        status: 'TRASHED',
        trashedAt: new Date(),
        deletedAt: new Date(),
        trashedBy: parentA,
        purgeAfter: future(),
      },
    });
    await getMedia(parentA, photoId).expect(200);
    // Once linked, even the uploader needs memory access: expired trash hides it.
    await prisma.memory.update({
      where: { id: memory.id },
      data: { purgeAfter: new Date(Date.now() - 1000) },
    });
    await getMedia(parentA, photoId).expect(404);
  });

  it('allows Circle MEMORY uploads, rechecks grants and charges the family quota', async () => {
    const bytes = randomBytes(32);
    const payload = {
      kind: 'IMAGE',
      mime: 'image/jpeg',
      size: bytes.length,
      sha256: sha256(bytes),
    };
    const before = await usage();
    const created = body(await intent(relative, payload).expect(201));
    expect((await usage()).reservedStorageBytes).toBe(
      before.reservedStorageBytes + reserved(bytes.length),
    );
    expect(
      (await prisma.asset.findUniqueOrThrow({ where: { id: created.assetId } }))
        .uploaderUserId,
    ).toBe(relative);
    for (const purpose of ['AVATAR', 'COVER', 'JOURNAL']) {
      expect(
        body(await intent(relative, { ...payload, purpose }).expect(403)).error
          .code,
      ).toBe('MEDIA_PARENT_REQUIRED');
    }
    await intent(relative, {
      ...payload,
      kind: 'AUDIO',
      mime: 'audio/mp4',
      durationMs: 1000,
    }).expect(422);
    const video = body(
      await intent(relative, {
        ...payload,
        kind: 'VIDEO',
        mime: 'video/mp4',
        durationMs: 1000,
        sha256: sha256(randomBytes(8)),
      }).expect(201),
    );
    expect(video.status).toBe('PENDING_UPLOAD');
    await prisma.circleGrant.updateMany({
      where: { familyId, circleMemberId: memberId },
      data: { permission: 'VIEW' },
    });
    expect(body(await intent(relative, payload).expect(403)).error.code).toBe(
      'CIRCLE_CONTRIBUTE_REQUIRED',
    );
    expect(
      body(await complete(relative, created.assetId).expect(403)).error.code,
    ).toBe('CIRCLE_CONTRIBUTE_REQUIRED');
    await prisma.circleGrant.updateMany({
      where: { familyId, circleMemberId: memberId },
      data: { permission: 'CONTRIBUTE' },
    });
    await prisma.familyEntitlement.updateMany({
      where: { familyId },
      data: { effectivePlanVersionId: noCircleVersionId },
    });
    expect(body(await intent(relative, payload).expect(403)).error.code).toBe(
      'CIRCLE_PAUSED',
    );
    expect(
      body(await complete(relative, created.assetId).expect(403)).error.code,
    ).toBe('CIRCLE_PAUSED');
    await request(app.getHttpServer())
      .post('/api/v1/media/urls')
      .set('Authorization', auth(relative))
      .send({ assetIds: [created.assetId] })
      .expect(403);
    await prisma.familyEntitlement.updateMany({
      where: { familyId },
      data: { effectivePlanVersionId: versionId },
    });
    await prisma.familyEntitlement.updateMany({
      where: { familyId },
      data: { validUntil: past() },
    });
    expect(body(await intent(relative, payload).expect(403)).error.code).toBe(
      'CIRCLE_PAUSED',
    );
    await prisma.familyEntitlement.updateMany({
      where: { familyId },
      data: { validUntil: future() },
    });
    expect(
      (
        await fetch(created.upload.url, {
          method: 'PUT',
          headers: created.upload.headers,
          body: bytes,
        })
      ).status,
    ).toBe(200);
    await complete(parentA, created.assetId).expect(403);
    await complete(relative, photoId).expect(403);
    await complete(relative, created.assetId).expect(202);
    await complete(relative, created.assetId).expect(202);
    await getMedia(relative, created.assetId).expect(404); // Unattached uploads are not shared media.
    const memory = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: relative,
        authorRole: 'CIRCLE',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        visibility: 'FAMILY',
        status: 'PUBLISHED',
        publishedAt: new Date(),
      },
    });
    await prisma.memoryChild.create({
      data: { familyId, memoryId: memory.id, childId, ageMonth: 0 },
    });
    await prisma.memoryAsset.create({
      data: {
        familyId,
        memoryId: memory.id,
        assetId: created.assetId,
        sortOrder: 0,
      },
    });
    await prisma.asset.update({
      where: { id: created.assetId },
      data: { status: 'READY', keepOriginal: true },
    });
    await prisma.assetVariant.createMany({
      data: ['t320', 'orig'].map((variantCode) => ({
        familyId,
        assetId: created.assetId,
        variantCode,
        storageBucket: 'bf-media',
        storageKey: `circle/${created.assetId}/${variantCode}`,
        mime: 'image/jpeg',
        sizeBytes: 32n,
      })),
    });
    expect(
      Object.keys(
        body(await getMedia(relative, created.assetId).expect(200)).urls,
      ),
    ).toEqual(['t320']);
    const batch = body(
      await request(app.getHttpServer())
        .post('/api/v1/media/urls')
        .set('Authorization', auth(relative))
        .send({ assetIds: [created.assetId, photoId] })
        .expect(200),
    );
    expect(batch.items).toHaveLength(1);
    expect(batch.unavailableIds).toEqual([photoId]);
    await prisma.memory.update({
      where: { id: memory.id },
      data: { status: 'PENDING_REVIEW' },
    });
    await getMedia(relative, created.assetId).expect(200); // Authors may preview their own submission.
    await prisma.memory.update({
      where: { id: memory.id },
      data: { authorUserId: parentA, authorRole: 'PARENT' },
    });
    await getMedia(relative, created.assetId).expect(404);
    await prisma.memory.update({
      where: { id: memory.id },
      data: {
        authorUserId: relative,
        authorRole: 'CIRCLE',
        status: 'PUBLISHED',
      },
    });
    const hiddenChild = await prisma.child.create({
      data: {
        familyId,
        name: 'Synthetic hidden child',
        birthDate: new Date('2025-01-01'),
        colorIndex: 2,
        createdBy: parentA,
      },
    });
    await prisma.memoryChild.create({
      data: {
        familyId,
        memoryId: memory.id,
        childId: hiddenChild.id,
        ageMonth: 0,
      },
    });
    await getMedia(relative, created.assetId).expect(404);
    await prisma.memoryChild.update({
      where: {
        memoryId_childId: { memoryId: memory.id, childId: hiddenChild.id },
      },
      data: { deletedAt: new Date() },
    });
    await getMedia(relative, created.assetId).expect(200);
    // Originals use the dedicated memory download route and its per-child grant.
    const download = () =>
      request(app.getHttpServer())
        .post(`/api/v1/memories/${memory.id}/download-urls`)
        .set('Authorization', auth(relative))
        .send({});
    expect(body(await download().expect(403)).error.code).toBe(
      'MEMORY_DOWNLOAD_FORBIDDEN',
    );
    await prisma.circleGrant.updateMany({
      where: { familyId, circleMemberId: memberId },
      data: { allowDownload: true },
    });
    expect(body(await download().expect(200)).items).toHaveLength(1);
    await prisma.memory.update({
      where: { id: memory.id },
      data: { visibility: 'PARENTS' },
    });
    await getMedia(relative, created.assetId).expect(404);
  });

  it('uploads private journal photos owned by the uploader only (US-07)', async () => {
    const bytes = Buffer.from(`journal-${randomUUID()}`);
    const payload = {
      purpose: 'JOURNAL',
      kind: 'IMAGE',
      mime: 'image/jpeg',
      size: bytes.length,
      sha256: sha256(bytes),
    };
    const mine = await intent(parentA, payload).expect(201);
    const asset = await prisma.asset.findUniqueOrThrow({
      where: { id: body(mine).assetId },
    });
    expect(asset).toMatchObject({
      purpose: 'JOURNAL',
      privateOwnerUserId: parentA,
      uploaderUserId: parentA,
    });
    // The partner uploading the same bytes never gets the private copy back.
    const partner = await intent(parentB, payload).expect(201);
    expect(body(partner).assetId).not.toBe(asset.id);
    expect(body(partner).deduplicated).toBe(false);
    // Journal photos are not general family media.
    await getMedia(parentB, asset.id).expect(404);
    await intent(parentA, {
      ...payload,
      kind: 'VIDEO',
      mime: 'video/mp4',
      durationMs: 1000,
    }).expect(422);
  });
  describe('client-created variants (server processing disabled)', () => {
    beforeAll(() => configuration.set('MEDIA_SERVER_PROCESSING', 'disabled'));
    afterAll(() => configuration.set('MEDIA_SERVER_PROCESSING', 'legacy'));

    function clientFile(
      kind: 'IMAGE' | 'VIDEO' | 'AUDIO' = 'IMAGE',
      purpose = 'MEMORY',
    ) {
      const bytes = randomBytes(2048);
      const variantBytes = randomBytes(256);
      const codes =
        kind === 'IMAGE'
          ? ['m1080', 't320']
          : kind === 'VIDEO'
            ? ['poster', 't320']
            : [];
      return {
        bytes,
        variantBytes,
        payload: {
          purpose,
          kind,
          mime:
            kind === 'IMAGE'
              ? 'image/jpeg'
              : kind === 'VIDEO'
                ? 'video/mp4'
                : 'audio/mp4',
          size: bytes.length,
          sha256: sha256(bytes),
          ...(kind !== 'AUDIO' ? { width: 640, height: 480 } : {}),
          ...(kind !== 'IMAGE' ? { durationMs: 1000 } : {}),
          variants: codes.map((code) => ({
            code,
            mime: 'image/jpeg',
            size: variantBytes.length,
            sha256: sha256(variantBytes),
            width: code === 't320' ? 320 : 640,
            height: code === 't320' ? 240 : 480,
          })),
        },
      };
    }

    async function put(
      upload: { url: string; headers: Record<string, string> },
      bytes: Buffer,
    ) {
      const response = await fetch(upload.url, {
        method: 'PUT',
        headers: upload.headers,
        body: bytes,
      });
      expect(response.status).toBe(200);
    }

    for (const kind of ['IMAGE', 'VIDEO', 'AUDIO'] as const) {
      it(`completes ${kind} immediately, charges every object and never queues processing`, async () => {
        const file = clientFile(kind);
        const before = await usage();
        const result = body(await intent(parentA, file.payload).expect(201));
        expect(result.variantUploads.map((item) => item.code).sort()).toEqual(
          file.payload.variants.map((item) => item.code).sort(),
        );
        const declared =
          file.bytes.length +
          file.variantBytes.length * file.payload.variants.length;
        expect((await usage()).reservedStorageBytes).toBe(
          before.reservedStorageBytes +
            reserved(file.bytes.length) +
            BigInt(file.payload.variants.length) *
              reserved(file.variantBytes.length),
        );
        await put(result.upload, file.bytes);
        for (const item of result.variantUploads) {
          expect(item.upload).toMatchObject({ mode: 'single', method: 'PUT' });
          expect(item.upload.headers['x-amz-checksum-sha256']).toBeTruthy();
          expect(new URL(item.upload.url).pathname).toContain(
            `/fam/${familyId}/a/${result.assetId}/${item.code}`,
          );
          await put(item.upload, file.variantBytes);
        }
        const done = body(await complete(parentA, result.assetId).expect(202));
        expect(done).toEqual({ assetId: result.assetId, status: 'READY' });
        await complete(parentA, result.assetId).expect(202);
        const asset = await prisma.asset.findUniqueOrThrow({
          where: { id: result.assetId },
        });
        expect(asset).toMatchObject({
          status: 'READY',
          durationMs: kind === 'IMAGE' ? null : 1000,
          width: kind === 'AUDIO' ? null : 640,
        });
        const variants = await prisma.assetVariant.findMany({
          where: { assetId: result.assetId, deletedAt: null },
        });
        expect(variants.map((variant) => variant.variantCode).sort()).toEqual(
          (kind === 'IMAGE'
            ? ['orig', 'm1080', 't320']
            : kind === 'VIDEO'
              ? ['v1080', 'poster', 't320']
              : ['a']
          ).sort(),
        );
        const alias = variants.find(
          (variant) =>
            variant.variantCode ===
            (kind === 'IMAGE' ? 'orig' : kind === 'VIDEO' ? 'v1080' : 'a'),
        );
        expect(alias?.storageKey).toBe(asset.storageKey);
        if (kind !== 'IMAGE') {
          const memory = await prisma.memory.create({
            data: {
              familyId,
              authorUserId: parentA,
              authorRole: 'PARENT',
              occurredAt: new Date(),
              occurredLocalDate: new Date(),
              visibility: 'PARENTS',
              status: 'PUBLISHED',
              publishedAt: new Date(),
            },
          });
          await prisma.memoryAsset.create({
            data: {
              familyId,
              memoryId: memory.id,
              assetId: asset.id,
              sortOrder: 0,
            },
          });
          const download = body(
            await request(app.getHttpServer())
              .post(`/api/v1/memories/${memory.id}/download-urls`)
              .set('Authorization', auth(parentA))
              .send({})
              .expect(200),
          );
          expect(download.items).toHaveLength(1);
          const item = download.items[0] as { assetId: string; url: string };
          expect(item.assetId).toBe(asset.id);
          expect(new URL(item.url).pathname).toContain(`/${asset.storageKey}`);
          const response = await fetch(item.url);
          expect(response.status).toBe(200);
          expect(Buffer.from(await response.arrayBuffer())).toEqual(file.bytes);
        }

        const after = await usage();
        expect(after.storageBytes).toBe(before.storageBytes + BigInt(declared));
        expect(after.reservedStorageBytes).toBe(before.reservedStorageBytes);
        expect(
          await prisma.outboxEvent.count({
            where: {
              familyId,
              aggregateId: result.assetId,
              eventType: 'media.asset_uploaded',
            },
          }),
        ).toBe(0);
        const view = body(await getMedia(parentA, result.assetId).expect(200));
        expect(Object.keys(view.urls).sort()).toEqual(
          (kind === 'IMAGE'
            ? ['m1080', 't320']
            : kind === 'VIDEO'
              ? ['v1080', 'poster', 't320']
              : ['a']
          ).sort(),
        );
      });
    }

    it('publishes a PROCESSING memory atomically when its final client asset becomes READY', async () => {
      const file = clientFile();
      const result = body(await intent(parentA, file.payload).expect(201));
      const secondFile = clientFile();
      const second = body(
        await intent(parentA, secondFile.payload).expect(201),
      );
      const memory = await prisma.memory.create({
        data: {
          familyId,
          authorUserId: parentA,
          authorRole: 'PARENT',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          visibility: 'PARENTS',
          status: 'PROCESSING',
        },
      });
      await prisma.memoryAsset.create({
        data: {
          familyId,
          memoryId: memory.id,
          assetId: result.assetId,
          sortOrder: 0,
        },
      });
      await prisma.memoryAsset.create({
        data: {
          familyId,
          memoryId: memory.id,
          assetId: second.assetId,
          sortOrder: 1,
        },
      });
      await put(result.upload, file.bytes);
      for (const item of result.variantUploads)
        await put(item.upload, file.variantBytes);
      await complete(parentA, result.assetId).expect(202);
      await complete(parentA, result.assetId).expect(202);
      expect(
        await prisma.memory.findUniqueOrThrow({ where: { id: memory.id } }),
      ).toMatchObject({ status: 'PROCESSING' });
      expect(
        await prisma.outboxEvent.count({
          where: {
            familyId,
            aggregateId: memory.id,
            eventType: 'memory.published',
          },
        }),
      ).toBe(0);
      await put(second.upload, secondFile.bytes);
      for (const item of second.variantUploads)
        await put(item.upload, secondFile.variantBytes);
      await complete(parentA, second.assetId).expect(202);
      await complete(parentA, second.assetId).expect(202);
      expect(
        await prisma.memory.findUniqueOrThrow({ where: { id: memory.id } }),
      ).toMatchObject({ status: 'PUBLISHED', publishedAt: expect.any(Date) });
      expect(
        await prisma.outboxEvent.count({
          where: {
            familyId,
            aggregateId: memory.id,
            eventType: 'memory.published',
          },
        }),
      ).toBe(1);
    });

    it('replays identical variant declarations regardless of object field order or list order', async () => {
      const file = clientFile();
      const key = randomUUID();
      const first = body(await intent(parentA, file.payload, key).expect(201));
      const variants = [...file.payload.variants].reverse().map((v) => ({
        height: v.height,
        width: v.width,
        sha256: v.sha256,
        size: v.size,
        mime: v.mime,
        code: v.code,
      }));
      const replay = body(
        await intent(parentA, { ...file.payload, variants }, key).expect(201),
      );
      expect(replay.assetId).toBe(first.assetId);
      expect(replay.variantUploads.map((v) => v.code).sort()).toEqual([
        'm1080',
        't320',
      ]);
      const changed = body(
        await intent(parentA, { ...file.payload, width: 641 }, key).expect(409),
      );
      expect(changed.error.code).toBe('IDEMPOTENCY_KEY_REUSED');
    });

    it('stores the device original fingerprint and returns it with the asset (BF-20261021-008)', async () => {
      const file = clientFile();
      const original = createHash('sha256')
        .update(`original-${randomUUID()}`)
        .digest('hex');
      const source = {
        sha256: original,
        key: 'IMAGE|3024x4032|0',
        capturedAt: '2026-10-01T08:00:00.000Z',
      };
      const key = randomUUID();
      const result = body(
        await intent(parentA, { ...file.payload, source }, key).expect(201),
      );
      await put(result.upload, file.bytes);
      for (const item of result.variantUploads)
        await put(item.upload, file.variantBytes);
      await complete(parentA, result.assetId).expect(202);
      const view = body(await getMedia(parentA, result.assetId).expect(200));
      expect(view.source).toEqual(source);
      const changed = body(
        await intent(
          parentA,
          { ...file.payload, source: { ...source, key: 'IMAGE|1x1|0' } },
          key,
        ).expect(409),
      );
      expect(changed.error.code).toBe('IDEMPOTENCY_KEY_REUSED');
      const plain = clientFile();
      const other = body(await intent(parentA, plain.payload).expect(201));
      await put(other.upload, plain.bytes);
      for (const item of other.variantUploads)
        await put(item.upload, plain.variantBytes);
      await complete(parentA, other.assetId).expect(202);
      expect(
        body(await getMedia(parentA, other.assetId).expect(200)).source,
      ).toBeNull();
      await intent(parentA, {
        ...clientFile().payload,
        source: { ...source, sha256: 'xyz' },
      }).expect(400);
    });

    it('rejects absent required variant declarations and all legacy kinds by default', async () => {
      for (const kind of ['IMAGE', 'VIDEO', 'AUDIO'] as const) {
        const file = clientFile(kind);
        const legacy: Record<string, unknown> = { ...file.payload };
        delete legacy.variants;
        expect(body(await intent(parentA, legacy).expect(422)).error.code).toBe(
          'MEDIA_VARIANTS_REQUIRED',
        );
      }
      const file = clientFile();
      expect(
        body(
          await intent(parentA, {
            ...file.payload,
            variants: file.payload.variants.slice(0, 1),
          }).expect(422),
        ).error.code,
      ).toBe('MEDIA_VARIANTS_REQUIRED');
    });

    it('rejects declared video duration beyond the current plan with 422', async () => {
      const file = clientFile('VIDEO');
      expect(
        body(
          await intent(parentA, { ...file.payload, durationMs: 5001 }).expect(
            422,
          ),
        ).error.code,
      ).toBe('MEDIA_DURATION_EXCEEDED');
    });

    for (const purpose of ['AVATAR', 'COVER', 'JOURNAL']) {
      it(`accepts the same client IMAGE contract for ${purpose}`, async () => {
        const file = clientFile('IMAGE', purpose);
        const result = body(await intent(parentA, file.payload).expect(201));
        await put(result.upload, file.bytes);
        for (const item of result.variantUploads)
          await put(item.upload, file.variantBytes);
        expect(
          body(await complete(parentA, result.assetId).expect(202)).status,
        ).toBe('READY');
      });
    }

    for (const mismatch of ['missing', 'size'] as const) {
      it(`fails and removes every uploaded object when a variant has ${mismatch} data`, async () => {
        const file = clientFile();
        const payload =
          mismatch === 'size'
            ? {
                ...file.payload,
                variants: file.payload.variants.map((variant) => ({
                  ...variant,
                  size: 1,
                })),
              }
            : file.payload;
        const before = await usage();
        const result = body(await intent(parentA, payload).expect(201));
        await put(result.upload, file.bytes);
        for (const item of result.variantUploads) {
          if (mismatch === 'missing' && item.code === 't320') continue;
          await put(item.upload, file.variantBytes);
        }
        expect(
          body(await complete(parentA, result.assetId).expect(422)).error.code,
        ).toBe(
          mismatch === 'missing'
            ? 'UPLOAD_VARIANT_MISSING'
            : 'UPLOAD_VARIANT_SIZE_MISMATCH',
        );
        const failed = await prisma.asset.findUniqueOrThrow({
          where: { id: result.assetId },
        });
        expect(failed.status).toBe('FAILED');
        const variants = await prisma.assetVariant.findMany({
          where: { assetId: result.assetId },
        });
        for (const object of [failed, ...variants])
          await expect(
            storage.headObject({
              bucket: storage.bucketOf(object.storageBucket)!,
              key: object.storageKey,
            }),
          ).resolves.toBeNull();
        expect((await usage()).reservedStorageBytes).toBe(
          before.reservedStorageBytes,
        );
        expect((await usage()).storageBytes).toBe(before.storageBytes);
      });
    }
  });
});
