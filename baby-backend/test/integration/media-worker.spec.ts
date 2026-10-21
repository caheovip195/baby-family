import { execFileSync } from 'node:child_process';
import { createHash, randomUUID } from 'node:crypto';
import {
  existsSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import type { INestApplicationContext } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { parse } from 'dotenv';
import { ListObjectVersionsCommand, S3Client } from '@aws-sdk/client-s3';
import exifr from 'exifr';
import sharp from 'sharp';
import { validateEnvironment } from '../../src/config/environment';
import { mediaStorageKey } from '../../src/config/media-policy';
import { PrismaService } from '../../src/database/prisma.service';
import { JOBS } from '../../src/config/jobs';
import {
  JOB_RUNNER_SERVICE,
  type IJobRunnerService,
} from '../../src/interfaces/services/job-runner-service.interface';
import {
  MEDIA_PROCESSING_SERVICE,
  type IMediaProcessingService,
} from '../../src/interfaces/services/media-processing-service.interface';
import { JOB_QUEUE_SERVICE } from '../../src/interfaces/services/job-queue-service.interface';
import { MEDIA_REPOSITORY } from '../../src/interfaces/repositories/media-repository.interface';
import type { IMediaRepository } from '../../src/interfaces/repositories/media-repository.interface';
import { MEDIA_MAINTENANCE_SERVICE } from '../../src/interfaces/services/media-maintenance-service.interface';
import type { IMediaMaintenanceService } from '../../src/interfaces/services/media-maintenance-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../../src/interfaces/services/object-storage-service.interface';

// Legacy processing against PostgreSQL, MinIO and ffmpeg. Global worker lifecycle
// loops stay stopped: durable jobs execute only for assets owned by this spec.
const VARIABLES = [
  'REDIS_URL',
  'S3_ENDPOINT',
  'S3_PUBLIC_ENDPOINT',
  'S3_ACCESS_KEY_ID',
  'S3_SECRET_ACCESS_KEY',
] as const;
const envFile = path.resolve(__dirname, '../../.env');
const fileValues = existsSync(envFile)
  ? parse(readFileSync(envFile, 'utf8'))
  : {};
const stack = Object.fromEntries(
  VARIABLES.map((name) => [
    name,
    process.env[`TEST_${name}`] ?? fileValues[name] ?? '',
  ]),
);
if (stack.REDIS_URL && !process.env.TEST_REDIS_URL) {
  const url = new URL(stack.REDIS_URL);
  url.pathname = '/15'; // isolated from a locally running worker (DB 0)
  stack.REDIS_URL = url.toString();
}
const hasFfmpeg = (() => {
  try {
    execFileSync('ffmpeg', ['-version'], { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
})();
const describeStack =
  stack.REDIS_URL && stack.S3_ENDPOINT && hasFfmpeg ? describe : describe.skip;

const sha256 = (body: Buffer) => createHash('sha256').update(body).digest();

describeStack(
  'Legacy media: scoped durable processing, purge, reconcile',
  () => {
    let app: INestApplicationContext;
    let prisma: PrismaService;
    let media: IMediaRepository;
    let storage: IObjectStorageService;
    let maintenance: IMediaMaintenanceService;
    let runner: IJobRunnerService;
    let processing: IMediaProcessingService;
    const enqueue = jest.fn().mockResolvedValue(undefined);
    const userId = randomUUID();
    const familyId = randomUUID();
    const planId = randomUUID();
    const versionId = randomUUID();
    const licenseId = randomUUID();
    const workDir = mkdtempSync(path.join(tmpdir(), 'bf-worker-test-'));
    const future = () => new Date(Date.now() + 24 * 60 * 60 * 1000);

    /** Reserve + store + confirm like the API does; returns the asset id. */
    async function stored(
      body: Buffer,
      kind: 'IMAGE' | 'VIDEO',
      mime: string,
      options: {
        declaredSha?: Buffer;
        confirm?: boolean;
        expiresAt?: Date;
      } = {},
    ): Promise<string> {
      const result = await media.reserveUpload({
        familyId,
        uploaderUserId: userId,
        idempotencyKey: randomUUID(),
        requestHash: sha256(Buffer.from(randomUUID())),
        kind,
        purpose: 'MEMORY',
        mime,
        declaredSize: BigInt(body.length),
        sha256: options.declaredSha ?? sha256(body),
        width: null,
        height: null,
        durationMs: kind === 'VIDEO' ? 2000 : null,
        storageBucket: storage.bucketName('media'),
        storageKey: (id) => mediaStorageKey(familyId, id),
        reservedBytes: BigInt(body.length),
        storageLimitBytes: 64n * 1024n * 1024n,
        checksumVerifiedMaxBytes: 20n * 1024n * 1024n,
        reservationExpiresAt: options.expiresAt ?? future(),
      });
      if (result.outcome === 'duplicate')
        throw new Error('unexpected duplicate');
      const asset = result.upload.asset;
      const file = path.join(workDir, `${asset.id}.bin`);
      writeFileSync(file, body);
      await storage.uploadFile(
        { bucket: 'media', key: asset.storageKey },
        file,
        mime,
      );
      if (options.confirm !== false)
        await media.confirmUpload(asset.id, BigInt(body.length));
      return asset.id;
    }

    async function settled(assetId: string, timeoutMs = 60_000) {
      await runner
        .execute(
          JOBS.processAsset,
          {
            scopeKey: assetId,
            familyId,
            scheduledFor: new Date(),
            idempotencyKey: `${JOBS.processAsset.name}:${assetId}`,
            inputReference: { assetId },
          },
          (context) => processing.processAsset(assetId, context),
        )
        .catch(async (error: unknown) => {
          const asset = await prisma.asset.findUniqueOrThrow({
            where: { id: assetId },
          });
          if (asset.status !== 'FAILED') throw error;
        });
      const deadline = Date.now() + timeoutMs;
      for (;;) {
        const asset = await prisma.asset.findUniqueOrThrow({
          where: { id: assetId },
        });
        if (['READY', 'FAILED'].includes(asset.status)) return asset;
        if (Date.now() > deadline)
          throw new Error(`Asset stuck in ${asset.status}`);
        await new Promise((resolve) => setTimeout(resolve, 250));
      }
    }

    /** The asset settles slightly before the run records its outcome. */
    async function finishedRun(assetId: string, timeoutMs = 30_000) {
      const deadline = Date.now() + timeoutMs;
      for (;;) {
        const run = await prisma.jobRun.findFirst({
          where: { jobName: 'media.process-asset', scopeKey: assetId },
          include: { jobAttempts: true },
        });
        if (run && ['SUCCEEDED', 'FAILED'].includes(run.status)) return run;
        if (Date.now() > deadline) throw new Error('Job run did not finish');
        await new Promise((resolve) => setTimeout(resolve, 200));
      }
    }

    async function download(key: string): Promise<string> {
      const file = path.join(workDir, `${randomUUID()}.out`);
      await storage.downloadToFile({ bucket: 'media', key }, file);
      return file;
    }

    beforeAll(async () => {
      const database = new URL(process.env.DATABASE_URL ?? '').pathname;
      if (!database.endsWith('_test'))
        throw new Error(
          'Worker integration requires a dedicated *_test database.',
        );
      const configuration = new ConfigService(
        validateEnvironment({
          ...process.env,
          ...stack,
          MEDIA_WORKER_CONCURRENCY: '2',
          MEDIA_SERVER_PROCESSING: 'legacy',
        }),
      );
      const { WorkerModule } =
        await import('../../src/workers/worker.module.js');
      const module = await Test.createTestingModule({ imports: [WorkerModule] })
        .overrideProvider(JOB_QUEUE_SERVICE)
        .useValue({ enqueue, isConfigured: () => true, schedule: jest.fn() })
        .overrideProvider(ConfigService)
        .useValue(configuration)
        .compile();
      // Never call app.init(): it starts global relay, queues and schedules.
      app = module;
      prisma = app.get(PrismaService);
      await prisma.onModuleInit();
      runner = app.get(JOB_RUNNER_SERVICE);
      processing = app.get(MEDIA_PROCESSING_SERVICE);
      media = app.get(MEDIA_REPOSITORY);
      storage = app.get(OBJECT_STORAGE_SERVICE);
      maintenance = app.get(MEDIA_MAINTENANCE_SERVICE);

      await prisma.user.create({
        data: {
          id: userId,
          displayName: 'Synthetic worker fixture',
          status: 'ACTIVE',
        },
      });
      await prisma.family.create({
        data: {
          id: familyId,
          name: 'Synthetic worker family',
          createdBy: userId,
          status: 'ACTIVE',
          activatedAt: new Date(),
        },
      });
      await prisma.plan.create({
        data: {
          id: planId,
          code: `WORKER_PLAN_${randomUUID().replaceAll('-', '').slice(0, 12)}`,
          displayNameI18n: { vi: 'Synthetic worker plan' },
          purchaseEnabled: false,
          active: true,
        },
      });
      await prisma.planVersion.create({
        data: {
          id: versionId,
          planId,
          version: 1,
          quotas: {
            storageBytes: 64 * 1024 * 1024,
            videoMaxSec: 5,
            audioMaxSec: 60,
          },
          features: { 'media.keepOriginal': false },
          availableFrom: new Date(Date.now() - 60_000),
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
    }, 60_000);

    afterAll(async () => {
      try {
        if (prisma) {
          const assets = await prisma.asset.findMany({ where: { familyId } });
          const variants = await prisma.assetVariant.findMany({
            where: { familyId },
          });
          for (const object of [...assets, ...variants])
            await storage.deleteObject({
              bucket: 'media',
              key: object.storageKey,
            });
          const runs = await prisma.jobRun.findMany({
            where: { scopeKey: { in: assets.map((asset) => asset.id) } },
          });
          // Pending/running runs may not be deleted; settle leftovers first.
          await prisma.jobRun.updateMany({
            where: {
              id: { in: runs.map((run) => run.id) },
              status: { in: ['PENDING', 'RUNNING', 'RETRY_WAIT'] },
            },
            data: {
              status: 'SKIPPED',
              finishedAt: new Date(),
              leaseOwner: null,
              leaseExpiresAt: null,
            },
          });
          await prisma.jobAttempt.deleteMany({
            where: { runId: { in: runs.map((run) => run.id) } },
          });
          await prisma.jobRun.deleteMany({
            where: { id: { in: runs.map((run) => run.id) } },
          });
          await prisma.outboxEvent.deleteMany({ where: { familyId } });
          await prisma.idempotencyRecord.deleteMany({ where: { familyId } });
          await prisma.assetVariant.deleteMany({ where: { familyId } });
          await prisma.storageReservation.deleteMany({ where: { familyId } });
          await prisma.asset.deleteMany({ where: { familyId } });
          await prisma.familyUsage.deleteMany({ where: { familyId } });
          await prisma.familyEntitlement.deleteMany({ where: { familyId } });
          await prisma.familyLicense.updateMany({
            where: { id: licenseId },
            data: { deletedAt: new Date() },
          });
          await prisma.family.updateMany({
            where: { id: familyId },
            data: { deletedAt: new Date() },
          });
          await prisma.user.updateMany({
            where: { id: userId },
            data: { deletedAt: new Date(), status: 'DELETED' },
          });
          await prisma.planVersion.deleteMany({ where: { planId } });
          await prisma.plan.deleteMany({ where: { id: planId } });
        }
      } finally {
        if (app) await app.close();
        rmSync(workDir, { recursive: true, force: true });
      }
    }, 60_000);

    /** Every version (and delete marker) of a key, to prove raw uploads are erased. */
    async function versionsOf(key: string): Promise<number> {
      const client = new S3Client({
        endpoint: stack.S3_ENDPOINT,
        region: 'us-east-1',
        forcePathStyle: true,
        credentials: {
          accessKeyId: stack.S3_ACCESS_KEY_ID!,
          secretAccessKey: stack.S3_SECRET_ACCESS_KEY!,
        },
      });
      const page = await client.send(
        new ListObjectVersionsCommand({
          Bucket: storage.bucketName('media'),
          Prefix: key,
        }),
      );
      client.destroy();
      return [...(page.Versions ?? []), ...(page.DeleteMarkers ?? [])].filter(
        (entry) => entry.Key === key,
      ).length;
    }

    const prefixOf = (key: string) => `${path.posix.dirname(key)}/`;

    it('processes an image: verified hash, metadata-free renditions, raw erased', async () => {
      const photo = await sharp({
        create: {
          width: 1600,
          height: 1200,
          channels: 3,
          background: '#88aacc',
        },
      })
        .jpeg()
        .withExif({
          IFD0: { Make: 'SyntheticCam' },
          IFD2: { DateTimeOriginal: '2026:03:12 08:30:00' },
          IFD3: { GPSLatitudeRef: 'N', GPSLatitude: '10/1 46/1 0/1' },
        })
        .toBuffer();
      expect((await sharp(photo).metadata()).exif).toBeDefined();
      const assetId = await stored(photo, 'IMAGE', 'image/jpeg');

      const asset = await settled(assetId);
      expect(asset).toMatchObject({
        status: 'READY',
        width: 1600,
        height: 1200,
      });
      expect(asset.blurhash).toBeTruthy();
      expect(asset.capturedAt?.getUTCFullYear()).toBe(2026);
      await finishedRun(assetId);
      const variants = await prisma.assetVariant.findMany({
        where: { assetId },
      });
      expect(variants.map((v) => v.variantCode).sort()).toEqual([
        'l2048',
        'm1080',
        'orig',
        't320',
      ]);
      const m1080 = variants.find((v) => v.variantCode === 'm1080')!;
      expect(m1080).toMatchObject({
        width: 1080,
        height: 810,
        mime: 'image/webp',
      });
      for (const variant of variants.filter((v) =>
        v.mime.startsWith('image/'),
      )) {
        const metadata = await sharp(
          await download(variant.storageKey),
        ).metadata();
        expect(metadata.exif).toBeUndefined(); // GPS/EXIF stripped (spec §10.3)
      }
      // The raw upload (with GPS) is gone, including noncurrent versions.
      expect(await versionsOf(asset.storageKey)).toBe(0);
      const keys = await storage.listKeys('media', prefixOf(asset.storageKey));
      expect(keys.sort()).toEqual(variants.map((v) => v.storageKey).sort());
      const usage = await prisma.familyUsage.findUniqueOrThrow({
        where: { familyId },
      });
      expect(usage.storageBytes).toBe(asset.sizeBytes);
      expect(asset.sizeBytes).toBe(
        variants.reduce((sum, variant) => sum + variant.sizeBytes, 0n),
      );
      const run = await finishedRun(assetId);
      expect(run).toMatchObject({ status: 'SUCCEEDED', attempts: 1 });
      expect(run.jobAttempts.map((a) => a.status)).toEqual(['SUCCEEDED']);
      const event = await prisma.outboxEvent.findFirstOrThrow({
        where: { aggregateId: assetId },
      });
      // The global relay stays stopped; delivery remains durably pending.
      expect(event).toMatchObject({
        familyId,
        eventType: 'media.asset_uploaded',
        publishedAt: null,
      });
      // Simulate a crash after READY committed but before the raw/stale object cleanup.
      const replayFile = path.join(workDir, `${assetId}-replayed.bin`);
      writeFileSync(replayFile, Buffer.from('raw upload with metadata'));
      await storage.uploadFile(
        { bucket: 'media', key: asset.storageKey },
        replayFile,
        'image/jpeg',
      );
      const staleKey = `${path.posix.dirname(asset.storageKey)}/stalled-attempt/t320.webp`;
      await storage.uploadFile(
        { bucket: 'media', key: staleKey },
        replayFile,
        'image/webp',
      );
      expect(await versionsOf(asset.storageKey)).toBeGreaterThan(0);
      const recovery = jest.fn(
        (context: Parameters<IMediaProcessingService['processAsset']>[1]) =>
          processing.processAsset(assetId, context),
      );
      await runner.execute(
        JOBS.processAsset,
        {
          scopeKey: assetId,
          familyId,
          scheduledFor: new Date(),
          idempotencyKey: `cleanup-recovery:${assetId}`,
          inputReference: { assetId },
        },
        recovery,
      );
      expect(recovery).toHaveBeenCalledTimes(1);
      await expect(recovery.mock.results[0]!.value).resolves.toEqual({
        cleaned: 1,
      });
      expect(await versionsOf(asset.storageKey)).toBe(0);
      expect(
        await storage.listKeys('media', prefixOf(asset.storageKey)),
      ).toEqual(expect.arrayContaining(variants.map((v) => v.storageKey)));
      await expect(
        storage.headObject({ bucket: 'media', key: staleKey }),
      ).resolves.toBeNull();
    }, 90_000);

    it('keeps original pixels without GPS when the plan keeps originals', async () => {
      // Plan versions are immutable: switch the entitlement to a version that keeps originals.
      const keepVersion = await prisma.planVersion.create({
        data: {
          planId,
          version: 2,
          quotas: {
            storageBytes: 64 * 1024 * 1024,
            videoMaxSec: 5,
            audioMaxSec: 60,
          },
          features: { 'media.keepOriginal': true },
          availableFrom: new Date(Date.now() - 60_000),
        },
      });
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { effectivePlanVersionId: keepVersion.id },
      });
      try {
        const photo = await sharp({
          create: {
            width: 300,
            height: 200,
            channels: 3,
            background: '#aa3311',
          },
        })
          .jpeg({ quality: 70 })
          .withMetadata({ orientation: 6 })
          .withExifMerge({
            IFD0: { Make: 'SyntheticCam' },
            IFD3: { GPSLatitudeRef: 'N', GPSLatitude: '10/1 46/1 0/1' },
          })
          .toBuffer();
        const assetId = await stored(photo, 'IMAGE', 'image/jpeg');
        const asset = await settled(assetId);
        // Display size follows the EXIF orientation.
        expect(asset).toMatchObject({
          status: 'READY',
          keepOriginal: true,
          width: 200,
          height: 300,
        });
        const orig = await prisma.assetVariant.findFirstOrThrow({
          where: { assetId, variantCode: 'orig' },
        });
        const file = await download(orig.storageKey);
        const kept = await sharp(file).metadata();
        expect(kept.orientation).toBe(6);
        const pixels = await sharp(file).raw().toBuffer();
        expect(pixels.equals(await sharp(photo).raw().toBuffer())).toBe(true);
        const exif = (await exifr.parse(readFileSync(file), true)) as Record<
          string,
          unknown
        >;
        expect(exif.GPSLatitude).toBeUndefined();
        expect(exif.Make).toBeUndefined();
      } finally {
        await prisma.familyEntitlement.update({
          where: { familyId },
          data: { effectivePlanVersionId: versionId },
        });
      }
    }, 90_000);

    it('fails media whose content does not match the declared SHA-256, then purges it', async () => {
      const body = await sharp({
        create: { width: 64, height: 64, channels: 3, background: '#000' },
      })
        .png()
        .toBuffer();
      const assetId = await stored(body, 'IMAGE', 'image/png', {
        declaredSha: sha256(Buffer.from('something else')),
      });
      const asset = await settled(assetId);
      expect(asset).toMatchObject({
        status: 'FAILED',
        failureReason: 'CHECKSUM_MISMATCH',
      });
      const run = await finishedRun(assetId);
      expect(run).toMatchObject({
        status: 'FAILED',
        attempts: 1,
        lastErrorCode: 'CHECKSUM_MISMATCH',
      });

      // purge-orphans retires FAILED assets after retention and refunds stored bytes.
      const before = await prisma.familyUsage.findUniqueOrThrow({
        where: { familyId },
      });
      const stats = await maintenance.purgeOrphans(
        new Date(Date.now() + 2 * 60 * 60 * 1000),
        undefined,
        familyId,
      );
      expect(stats.failed).toBeGreaterThanOrEqual(1);
      expect(stats.objectsPurged).toBeGreaterThanOrEqual(1);
      const purged = await prisma.asset.findUniqueOrThrow({
        where: { id: assetId },
      });
      expect(purged).toMatchObject({ status: 'DELETED', purgeAfter: null });
      const after = await prisma.familyUsage.findUniqueOrThrow({
        where: { familyId },
      });
      expect(before.storageBytes - after.storageBytes).toBe(
        BigInt(body.length),
      );
      await expect(
        storage.listKeys('media', prefixOf(purged.storageKey)),
      ).resolves.toEqual([]);
    }, 90_000);

    it('transcodes video: v1080 + poster + t320 without location metadata', async () => {
      const source = path.join(workDir, 'source.mp4');
      execFileSync('ffmpeg', [
        '-v',
        'error',
        '-f',
        'lavfi',
        '-i',
        'testsrc=duration=2:size=1920x1080:rate=24',
        '-f',
        'lavfi',
        '-i',
        'sine=frequency=440:duration=2',
        '-metadata',
        'location=+10.7769+106.7009/',
        '-shortest',
        '-c:v',
        'libx264',
        '-pix_fmt',
        'yuv420p',
        '-c:a',
        'aac',
        source,
      ]);
      const assetId = await stored(readFileSync(source), 'VIDEO', 'video/mp4');
      const asset = await settled(assetId, 120_000);
      expect(asset).toMatchObject({
        status: 'READY',
        width: 1920,
        height: 1080,
      });
      expect(asset.durationMs).toBeGreaterThan(1500);
      await finishedRun(assetId);
      const variants = await prisma.assetVariant.findMany({
        where: { assetId },
      });
      expect(variants.map((v) => v.variantCode).sort()).toEqual([
        'poster',
        't320',
        'v1080',
      ]);
      const v1080 = variants.find((v) => v.variantCode === 'v1080')!;
      const tags = execFileSync('ffprobe', [
        '-v',
        'error',
        '-show_entries',
        'format_tags',
        '-of',
        'json',
        await download(v1080.storageKey),
      ]).toString();
      expect(tags).not.toContain('location');
      // Non-keepOriginal plans keep no raw original (which carries GPS atoms).
      expect(await versionsOf(asset.storageKey)).toBe(0);
    }, 150_000);

    it('purges expired uploads, reconciles uncompleted ones and re-enqueues lost jobs', async () => {
      const usageOf = () =>
        prisma.familyUsage.findUniqueOrThrow({ where: { familyId } });
      const pendingBody = Buffer.from('never completed');
      const expiredId = await stored(pendingBody, 'IMAGE', 'image/jpeg', {
        confirm: false,
        expiresAt: new Date(Date.now() + 1500),
      });
      const reservedBefore = (await usageOf()).reservedStorageBytes;
      await new Promise((resolve) => setTimeout(resolve, 1600));
      const stats = await maintenance.purgeOrphans(
        new Date(),
        undefined,
        familyId,
      );
      expect(stats.expired).toBeGreaterThanOrEqual(1);
      const expired = await prisma.asset.findUniqueOrThrow({
        where: { id: expiredId },
        include: { storageReservation: true },
      });
      expect(expired.status).toBe('DELETED');
      expect(expired.storageReservation[0]?.status).toBe('EXPIRED');
      expect((await usageOf()).reservedStorageBytes).toBe(
        reservedBefore - BigInt(pendingBody.length),
      );
      await expect(
        storage.listKeys('media', prefixOf(expired.storageKey)),
      ).resolves.toEqual([]);

      const photo = () =>
        sharp({
          create: {
            width: 200,
            height: 100,
            channels: 3,
            background: `#${randomUUID().slice(0, 6)}`,
          },
        })
          .jpeg()
          .toBuffer();
      const forgottenId = await stored(await photo(), 'IMAGE', 'image/jpeg', {
        confirm: false,
      });
      const reconciled = await maintenance.reconcileUploads(
        new Date(Date.now() + 11 * 60 * 1000),
        familyId,
      );
      expect(reconciled.confirmed).toBeGreaterThanOrEqual(1);
      // Confirmation emits the same outbox event, so the worker processes it too.
      await expect(settled(forgottenId)).resolves.toMatchObject({
        status: 'READY',
      });

      // An UPLOADED asset whose queue job was lost (no outbox event, no run).
      const lostBody = await photo();
      const lostId = await stored(lostBody, 'IMAGE', 'image/jpeg', {
        confirm: false,
      });
      await prisma.asset.update({
        where: { id: lostId },
        data: { status: 'UPLOADED', sizeBytes: BigInt(lostBody.length) },
      });
      const requeued = await maintenance.reconcileUploads(
        new Date(Date.now() + 16 * 60 * 1000),
        familyId,
      );
      expect(requeued.requeued).toBeGreaterThanOrEqual(1);
      expect(enqueue).toHaveBeenCalledWith(
        JOBS.processAsset,
        expect.any(String),
        { assetId: lostId },
      );
      await expect(settled(lostId)).resolves.toMatchObject({ status: 'READY' });
    }, 120_000);
  },
);
