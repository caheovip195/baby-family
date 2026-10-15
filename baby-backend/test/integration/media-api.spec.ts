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
  deduplicated: boolean;
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
const body = (response: { body: unknown }) => response.body as ApiBody;
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
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  const [parentA, parentB, outsider] = [
    randomUUID(),
    randomUUID(),
    randomUUID(),
  ];
  const sessions = new Map<string, string>([
    [parentA, randomUUID()],
    [parentB, randomUUID()],
    [outsider, randomUUID()],
  ]);
  const familyId = randomUUID();
  const planId = randomUUID();
  const versionId = randomUUID();
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
        await prisma.memoryAsset.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.assetVariant.deleteMany({ where: { familyId } });
        await prisma.storageReservation.deleteMany({ where: { familyId } });
        await prisma.asset.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
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
    await intent(parentA, { ...payload, width: 1 }, key).expect(201); // dimensions are not identity
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

  it('deduplicates identical content per family and purpose', async () => {
    const response = await intent(parentB, {
      kind: 'IMAGE',
      mime: 'image/jpeg',
      size: photo.length,
      sha256: sha256(photo),
    }).expect(201);
    expect(body(response)).toEqual({
      assetId: photoId,
      status: 'UPLOADED',
      deduplicated: true,
    });
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
    await intent(parentA, { ...base, purpose: 'JOURNAL' }).expect(400);
    await intent(parentA, { ...base, kind: 'VIDEO', mime: 'video/mp4' }).expect(
      400,
    );
    const duration = await intent(parentA, {
      ...base,
      kind: 'VIDEO',
      mime: 'video/mp4',
      durationMs: 6000,
    }).expect(402);
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
    const pending = await intent(parentB, video).expect(409);
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
    // Once linked, even the uploader needs memory access (trash is not a §6.3 view).
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
    await getMedia(parentA, photoId).expect(404);
  });
});
