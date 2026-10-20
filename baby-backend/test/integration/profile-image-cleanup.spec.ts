import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { JOBS } from '../../src/config/jobs';
import { PrismaService } from '../../src/database/prisma.service';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { PROFILE_IMAGE_CLEANUP_REPOSITORY } from '../../src/interfaces/repositories/profile-image-cleanup-repository.interface';
import type { IJobRunnerService } from '../../src/interfaces/services/job-runner-service.interface';
import { JOB_RUNNER_SERVICE } from '../../src/interfaces/services/job-runner-service.interface';
import type { ObjectLocation } from '../../src/interfaces/services/object-storage-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import { PROFILE_IMAGE_CLEANUP_SERVICE } from '../../src/interfaces/services/profile-image-cleanup-service.interface';
import type { IProfileImageCleanupService } from '../../src/interfaces/services/profile-image-cleanup-service.interface';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { ProfileImageCleanupRepository } from '../../src/repositories/profile-image-cleanup.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { ProfileImageCleanupService } from '../../src/services/profile-image-cleanup.service';

/** Real persistence/history; storage versions are represented by a scoped in-memory map. */
describe('Profile image cleanup (durable media.purge-orphans)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let cleanup: IProfileImageCleanupService;
  let runner: IJobRunnerService;
  const owners: string[] = [];
  const runKeys: string[] = [];
  const versions = new Map<string, string[]>();
  let failNextErase = false;
  const erase = jest.fn((location: ObjectLocation) => {
    if (failNextErase) {
      failNextErase = false;
      return Promise.reject(new Error('Synthetic storage outage'));
    }
    versions.delete(location.key);
    return Promise.resolve();
  });
  const policy = { ...JOBS.purgeOrphans, backoffMs: 1 };
  const keyFor = (owner: string, asset: string) =>
    `usr/${owner}/avatar/${asset}/raw`;
  const makeAsset = async (
    status: 'READY' | 'PENDING_UPLOAD' | 'PROCESSING',
    attached = false,
    storageBucket = 'bf-user-media',
  ) => {
    const owner = randomUUID(),
      id = randomUUID();
    owners.push(owner);
    await prisma.user.create({
      data: { id: owner, displayName: 'Synthetic avatar cleanup fixture' },
    });
    const key = keyFor(owner, id);
    await prisma.userAsset.create({
      data: {
        id,
        ownerUserId: owner,
        purpose: 'AVATAR',
        status,
        mime: 'image/png',
        declaredSize: 20n,
        sizeBytes: status === 'READY' ? 10n : null,
        storageKey: key,
        storageBucket,
        purgeAfter: new Date(Date.now() - 120_000),
      },
    });
    if (attached)
      await prisma.user.update({
        where: { id: owner },
        data: { avatarAssetId: id },
      });
    versions.set(key, ['raw-upload-with-metadata', 'replayed-raw-upload']);
    versions.set(`${key}/avatar.webp`, ['processed-no-metadata']);
    return { owner, id, key };
  };
  const execution = (owner: string, now = new Date()) => {
    const key = `profile-cleanup-${randomUUID()}`;
    runKeys.push(key);
    const request = {
      scopeKey: key,
      scheduledFor: new Date(),
      idempotencyKey: key,
    };
    const run = () =>
      runner.execute(policy, request, (context) =>
        cleanup.purge(now, context, [owner]),
      );
    return { key, run };
  };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 2,
            WORKER_ID: `profile-cleanup-test-${randomUUID()}`,
          }),
        },
        { provide: JOB_RUNNER_SERVICE, useClass: JobRunnerService },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        {
          provide: PROFILE_IMAGE_CLEANUP_SERVICE,
          useClass: ProfileImageCleanupService,
        },
        {
          provide: PROFILE_IMAGE_CLEANUP_REPOSITORY,
          useClass: ProfileImageCleanupRepository,
        },
        {
          provide: OBJECT_STORAGE_SERVICE,
          useValue: {
            bucketOf: (bucket: string) =>
              bucket === 'bf-user-media' ? 'userMedia' : null,
            eraseObjectVersions: erase,
          },
        },
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    cleanup = module.get<IProfileImageCleanupService>(
      PROFILE_IMAGE_CLEANUP_SERVICE,
    );
    runner = module.get<IJobRunnerService>(JOB_RUNNER_SERVICE);
  });
  afterAll(async () => {
    if (prisma) {
      await prisma.user.updateMany({
        where: { id: { in: owners } },
        data: { avatarAssetId: null },
      });
      await prisma.userAsset.deleteMany({
        where: { ownerUserId: { in: owners } },
      });
      await prisma.user.deleteMany({ where: { id: { in: owners } } });
      // Preserve job run/attempt history; synthetic scope keys are unique per run.
    }
    await module?.close();
  });
  it('purges every replayed raw version after deadline while retaining an attached final image', async () => {
    const asset = await makeAsset('READY', true);
    const run = execution(asset.owner);
    expect(await run.run()).toBe('SUCCEEDED');
    expect(versions.has(asset.key)).toBe(false);
    expect(versions.get(`${asset.key}/avatar.webp`)).toEqual([
      'processed-no-metadata',
    ]);
    const row = await prisma.userAsset.findUniqueOrThrow({
      where: { id: asset.id },
    });
    expect(row.status).toBe('READY');
    expect(row.deletedAt).toBeNull();
    expect(row.purgeAfter).toBeNull();
    expect(await run.run()).toBe('ALREADY_FINISHED');
    expect(
      await prisma.jobAttempt.count({
        where: { jobRun: { idempotencyKey: run.key } },
      }),
    ).toBe(1);
  });
  it('records unavailable bucket as a failed attempt and retains the purge deadline', async () => {
    const asset = await makeAsset(
      'PENDING_UPLOAD',
      false,
      'unconfigured-bucket',
    );
    const run = execution(asset.owner);
    await expect(run.run()).rejects.toMatchObject({
      code: 'SERVICE_UNAVAILABLE',
    });
    const row = await prisma.userAsset.findUniqueOrThrow({
      where: { id: asset.id },
    });
    expect(row.purgeAfter).not.toBeNull();
    expect(versions.has(asset.key)).toBe(true);
    const attempt = await prisma.jobAttempt.findFirstOrThrow({
      where: { jobRun: { idempotencyKey: run.key } },
    });
    expect(attempt.status).toBe('FAILED');
  });
  it('recovers a storage outage using a second durable attempt without losing the purge marker', async () => {
    const asset = await makeAsset('PENDING_UPLOAD');
    const run = execution(asset.owner);
    failNextErase = true;
    await expect(run.run()).rejects.toThrow('Synthetic storage outage');
    const retired = await prisma.userAsset.findUniqueOrThrow({
      where: { id: asset.id },
    });
    expect(retired.status).toBe('DELETED');
    expect(retired.deletedAt).not.toBeNull();
    expect(retired.purgeAfter).not.toBeNull();
    expect(versions.has(asset.key)).toBe(true);
    expect(await run.run()).toBe('SUCCEEDED');
    expect(versions.has(asset.key)).toBe(false);
    expect(versions.has(`${asset.key}/avatar.webp`)).toBe(false);
    expect(
      (await prisma.userAsset.findUniqueOrThrow({ where: { id: asset.id } }))
        .purgeAfter,
    ).toBeNull();
    const attempts = await prisma.jobAttempt.findMany({
      where: { jobRun: { idempotencyKey: run.key } },
      orderBy: { attemptNumber: 'asc' },
    });
    expect(attempts.map((attempt) => attempt.status)).toEqual([
      'FAILED',
      'SUCCEEDED',
    ]);
  });
  it('keeps unexpired PUTs and live processing; recovers processing after six hours', async () => {
    const active = await makeAsset('PROCESSING');
    expect(await execution(active.owner).run()).toBe('SUCCEEDED');
    expect(versions.has(active.key)).toBe(true);
    expect(
      await execution(
        active.owner,
        new Date(Date.now() + 7 * 60 * 60 * 1000),
      ).run(),
    ).toBe('SUCCEEDED');
    expect(versions.has(active.key)).toBe(false);
    const fresh = await makeAsset('PENDING_UPLOAD');
    await prisma.userAsset.update({
      where: { id: fresh.id },
      data: { purgeAfter: new Date(Date.now() + 600_000) },
    });
    await execution(fresh.owner).run();
    expect(versions.has(fresh.key)).toBe(true);
    expect(
      (await prisma.userAsset.findUniqueOrThrow({ where: { id: fresh.id } }))
        .status,
    ).toBe('PENDING_UPLOAD');
  });
  it('reclaims the final image after detachment or owner deletion even after raw cleanup cleared its marker', async () => {
    const detached = await makeAsset('READY', true);
    await execution(detached.owner).run();
    await prisma.user.update({
      where: { id: detached.owner },
      data: { avatarAssetId: null },
    });
    await execution(detached.owner).run();
    expect(versions.has(`${detached.key}/avatar.webp`)).toBe(false);
    const removed = await makeAsset('READY', true);
    await execution(removed.owner).run();
    await prisma.user.update({
      where: { id: removed.owner },
      data: { deletedAt: new Date() },
    });
    await execution(removed.owner).run();
    expect(versions.has(`${removed.key}/avatar.webp`)).toBe(false);
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: removed.owner } }))
        .avatarAssetId,
    ).toBeNull();
    expect(
      (await prisma.userAsset.findUniqueOrThrow({ where: { id: removed.id } }))
        .status,
    ).toBe('DELETED');
  });
  it('does not touch support assets, unrelated avatar paths, or owners outside this run', async () => {
    const own = await makeAsset('PENDING_UPLOAD'),
      other = await makeAsset('PENDING_UPLOAD');
    const supportKey = `usr/${own.owner}/support/${randomUUID()}`;
    const unrelatedKey = `usr/${own.owner}/external-avatar/${randomUUID()}`;
    for (const [purpose, key] of [
      ['SUPPORT', supportKey],
      ['AVATAR', unrelatedKey],
    ] as const) {
      await prisma.userAsset.create({
        data: {
          ownerUserId: own.owner,
          purpose,
          status: 'PENDING_UPLOAD',
          mime: 'image/png',
          declaredSize: 1n,
          storageKey: key,
          purgeAfter: new Date(0),
        },
      });
      versions.set(key, ['preserve']);
    }
    await execution(own.owner).run();
    expect(versions.has(own.key)).toBe(false);
    for (const key of [other.key, supportKey, unrelatedKey])
      expect(versions.has(key)).toBe(true);
  });
});
