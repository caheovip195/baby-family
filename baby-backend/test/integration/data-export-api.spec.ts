import { createCipheriv, hkdfSync, randomBytes, randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { LoggerModule } from 'nestjs-pino';
import { DataExportController } from '../../src/controllers/data-export.controller';
import { DataExportService } from '../../src/services/data-export.service';
import { DataExportRepository } from '../../src/repositories/data-export.repository';
import { DATA_EXPORT_SERVICE } from '../../src/interfaces/services/data-export-service.interface';
import { DATA_EXPORT_REPOSITORY } from '../../src/interfaces/repositories/data-export-repository.interface';
import { PrismaService } from '../../src/database/prisma.service';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AuthenticationService } from '../../src/services/authentication.service';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import type { DataExportResponseDto } from '../../src/dto/account/data-export.dto';
import { ACCOUNT_DELETION_POLICY } from '../../src/config/account-deletion-policy';
import { JOBS } from '../../src/config/jobs';
import type { JobPolicy } from '../../src/config/jobs';
import { JobLease } from '../../src/models/job-lease.model';

const data = (res: { body: unknown }) =>
  (res.body as { data: DataExportResponseDto }).data;
const policy: JobPolicy = {
  queue: 'maintenance',
  name: 'test.data-export',
  maxAttempts: 3,
  backoffMs: 10,
  leaseMs: 120000,
};

describe('Data export API (focused module, PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let service: DataExportService;
  const users = [randomUUID(), randomUUID()];
  const userA = users[0]!,
    userB = users[1]!;
  const familyId = randomUUID();
  const tokens = new Map<string, string>();
  const master = randomBytes(32);
  let uploaded: Record<string, unknown> | undefined;
  const storage = {
    listKeys: jest.fn(() => Promise.resolve([] as string[])),
    bucketOf: jest.fn(() => 'media'),
    createDownloadUrl: jest.fn(
      (input: { key: string; expiresInSeconds?: number }) =>
        Promise.resolve({
          method: 'GET',
          url: `https://storage.test/${input.key}`,
          headers: {},
          expiresAt: new Date(
            Date.now() + (input.expiresInSeconds ?? 900) * 1000,
          ),
        }),
    ),
    uploadFile: jest.fn(async (_location: unknown, path: string) => {
      uploaded = JSON.parse(await readFile(path, 'utf8')) as Record<
        string,
        unknown
      >;
    }),
    eraseObjectVersions: jest.fn(() => Promise.resolve()),
  };
  const post = (user = userA, body: Record<string, unknown> = {}) =>
    request(app.getHttpServer())
      .post('/api/v1/exports')
      .set('Authorization', tokens.get(user)!)
      .send(body);
  const get = (id: string, user = userA) =>
    request(app.getHttpServer())
      .get(`/api/v1/exports/${id}`)
      .set('Authorization', tokens.get(user)!);
  function encrypt(text: string, owner: string) {
    const scope = `user:${owner}`;
    const key = Buffer.from(
      hkdfSync('sha256', master, 'baby-family:us-journal:v1', scope, 32),
    );
    const iv = randomBytes(12),
      cipher = createCipheriv('aes-256-gcm', key, iv);
    cipher.setAAD(Buffer.from(scope));
    const body = Buffer.concat([cipher.update(text), cipher.final()]);
    return Buffer.concat([Buffer.from([1]), iv, cipher.getAuthTag(), body]);
  }
  async function run(id: string, kind: 'export' | 'purge' = 'export') {
    const job = await prisma.exportJob.findUniqueOrThrow({ where: { id } });
    return app.get(JobRunnerService).execute(
      policy,
      {
        familyId,
        scopeKey: `${kind}:${id}`,
        scheduledFor: job.createdAt,
        idempotencyKey: `${kind}:${id}`,
      },
      (context) =>
        kind === 'export'
          ? service.execute(id, context)
          : service.purgeExpired(context),
    );
  }
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Export tests require *_test database.');
    const keys = await generateKeyPair('ES256');
    const config = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
      COUPLE_CHECKIN_ENCRYPTION_KEY: master.toString('base64'),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [DataExportController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        JobRunnerService,
        { provide: ConfigService, useValue: config },
        { provide: DATA_EXPORT_SERVICE, useClass: DataExportService },
        { provide: DATA_EXPORT_REPOSITORY, useClass: DataExportRepository },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: OBJECT_STORAGE_SERVICE, useValue: storage },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );
    await app.init();
    prisma = app.get(PrismaService);
    service = app.get<DataExportService>(DATA_EXPORT_SERVICE);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Export test',
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Export test',
        createdBy: userA,
        status: 'PARTNER_LEFT',
      },
    });
    await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: userA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    for (const user of users) {
      const session = await prisma.userSession.create({
        data: {
          userId: user,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + 86400000),
          absoluteExpiresAt: new Date(Date.now() + 86400000),
        },
      });
      const now = Math.floor(Date.now() / 1000);
      tokens.set(
        user,
        `Bearer ${await new SignJWT({ sub: user, sid: session.id, ver: 1, iat: now, exp: now + 900, iss: 'baby-family', aud: 'baby-family-app' }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).sign(keys.privateKey)}`,
      );
    }
  });
  afterEach(async () => {
    await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
    await prisma.jobRun.updateMany({
      where: { familyId, status: { in: ['PENDING', 'RUNNING', 'RETRY_WAIT'] } },
      data: {
        status: 'SKIPPED',
        finishedAt: new Date(),
        leaseOwner: null,
        leaseExpiresAt: null,
      },
    });
    await prisma.jobRun.deleteMany({ where: { familyId } });
    await prisma.exportJob.deleteMany({
      where: { requesterId: { in: users } },
    });
    await prisma.journalEntry.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.asset.deleteMany({ where: { familyId } });
    uploaded = undefined;
    jest.clearAllMocks();
  });
  afterAll(async () => {
    if (prisma) {
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.familyLicense.updateMany({
        where: { familyId },
        data: { deletedAt: new Date() },
      });
      await prisma.family.updateMany({
        where: { id: familyId },
        data: { deletedAt: new Date(), status: 'DELETED' },
      });
      await prisma.userSession.deleteMany({ where: { userId: { in: users } } });
      await prisma.user.updateMany({
        where: { id: { in: users } },
        data: { deletedAt: new Date(), status: 'DELETED' },
      });
    }
    await app?.close();
  });
  it('requires authentication and validates actor/scope overrides', async () => {
    await request(app.getHttpServer())
      .post('/api/v1/exports')
      .send({})
      .expect(401);
    await post(userA, { userId: userB }).expect(400);
    await post(userA, { scope: 'OTHER' }).expect(400);
    await post(userA, { scope: 'FAMILY' }).expect(422);
    await post(userA, { familyId }).expect(422);
    await get('invalid').expect(400);
  });
  it('serializes concurrent create requests and hides foreign job ids', async () => {
    const responses = await Promise.all([post(), post()]);
    expect(responses.map((r) => r.status).sort()).toEqual([201, 409]);
    const created = data(responses.find((r) => r.status === 201)!);
    expect(created).toMatchObject({
      scope: 'PERSONAL',
      status: 'QUEUED',
      download: null,
    });
    expect((await post().expect(409)).body).toMatchObject({
      error: { code: 'EXPORT_ALREADY_ACTIVE' },
    });
    await get(created.id, userB).expect(404);
    expect(
      await prisma.exportJob.count({ where: { requesterId: userA } }),
    ).toBe(1);
  });
  it('enforces the configured rate limit across completed and soft-deleted jobs', async () => {
    await prisma.exportJob.createMany({
      data: Array.from(
        { length: ACCOUNT_DELETION_POLICY.export.maxRequests },
        () => ({
          requesterId: userA,
          scope: 'PERSONAL',
          status: 'COMPLETED',
          deletedAt: new Date(),
        }),
      ),
    });
    expect((await post().expect(429)).body).toMatchObject({
      error: { code: 'EXPORT_RATE_LIMITED' },
    });
  });
  it('exports only caller journal, decrypts it, uploads JSON, signs owner URL and records durable replay once', async () => {
    await prisma.journalEntry.createMany({
      data: [
        { familyId, userId: userA, bodyEnc: encrypt('My private text', userA) },
        {
          familyId,
          userId: userB,
          bodyEnc: encrypt('Partner private text', userB),
        },
      ],
    });
    const ownAssetId = randomUUID();
    await prisma.asset.createMany({
      data: users.map((user) => ({
        id: user === userA ? ownAssetId : randomUUID(),
        familyId,
        uploaderUserId: user,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        status: 'READY',
        storageBucket: 'bf-media',
        storageKey: `export-fixture/${user}/${randomUUID()}`,
        mime: 'image/jpeg',
        declaredSize: 10n,
        sizeBytes: 10n,
      })),
    });
    await prisma.heartLedger.createMany({
      data: users.map((user) => ({
        familyId,
        userId: user,
        sourceType: 'MEMORY',
        sourceId: randomUUID(),
        reason: 'MEMORY_CREATED',
        amount: user === userA ? 3 : 77,
        localDate: new Date(),
      })),
    });
    const created = data(await post().expect(201));
    expect(await run(created.id)).toBe('SUCCEEDED');
    expect(await run(created.id)).toBe('ALREADY_FINISHED');
    expect(storage.uploadFile).toHaveBeenCalledTimes(1);
    expect(uploaded?.media).toEqual([
      expect.objectContaining({
        assetId: ownAssetId,
        url: expect.stringContaining(userA),
      }),
    ]);
    expect(uploaded?.hearts).toEqual([expect.objectContaining({ amount: 3 })]);
    expect(JSON.stringify(uploaded)).toContain('My private text');
    expect(JSON.stringify(uploaded)).not.toContain('Partner private text');
    expect(JSON.stringify(uploaded)).not.toMatch(
      /bodyEnc|contentKey|refreshToken/,
    );
    const ready = data(await get(created.id).expect(200));
    expect(ready).toMatchObject({ status: 'COMPLETED', errorCode: null });
    expect(ready.download?.url).toContain(created.id);
    expect(
      new Date(ready.download!.expiresAt).getTime() - Date.now(),
    ).toBeLessThanOrEqual(900000);
    await get(created.id, userB).expect(404);
    expect(
      await prisma.jobAttempt.count({ where: { jobRun: { familyId } } }),
    ).toBe(1);
  });
  it('keeps FAMILY exports available to a remaining parent and excludes every private journal', async () => {
    await prisma.journalEntry.create({
      data: {
        familyId,
        userId: userA,
        bodyEnc: encrypt('Private family journal', userA),
      },
    });
    await post(userB, { scope: 'FAMILY', familyId }).expect(404);
    const created = data(
      await post(userA, { scope: 'FAMILY', familyId }).expect(201),
    );
    await run(created.id);
    expect(uploaded).not.toHaveProperty('myPrivate');
    expect(JSON.stringify(uploaded)).not.toContain('Private family journal');
  });
  it('allows EXPIRED family exports without restoring paid access', async () => {
    const membership = await prisma.familyParent.create({
      data: {
        familyId,
        userId: userB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });
    const license = await prisma.familyLicense.findUniqueOrThrow({
      where: { familyId },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'EXPIRED',
        validUntil: new Date(Date.now() - 86400000),
      },
    });
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'ACTIVE' },
    });
    try {
      const created = data(
        await post(userA, { scope: 'FAMILY', familyId }).expect(201),
      );
      await run(created.id);
      expect(data(await get(created.id).expect(200)).status).toBe('COMPLETED');
    } finally {
      await prisma.familyEntitlement.deleteMany({ where: { familyId } });
      await prisma.familyParent.delete({ where: { id: membership.id } });
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'PARTNER_LEFT' },
      });
    }
  });
  it('cleans a fenced upload when deletion retires the export before completion', async () => {
    const created = data(await post().expect(201));
    storage.uploadFile.mockImplementationOnce(async () => {
      await prisma.exportJob.update({
        where: { id: created.id },
        data: { deletedAt: new Date(), status: 'EXPIRED' },
      });
    });
    await expect(run(created.id)).rejects.toThrow('Export cannot be completed');
    expect(storage.eraseObjectVersions).toHaveBeenCalledTimes(1);
    expect(storage.eraseObjectVersions.mock.calls[0]).toEqual([
      { bucket: 'exports', key: expect.stringContaining(`/${created.id}/`) },
    ]);
    await get(created.id).expect(404);
  });
  it('reconciles exhausted durable runs so a caller can request another export', async () => {
    const created = data(await post().expect(201));
    await prisma.exportJob.update({
      where: { id: created.id },
      data: { status: 'PROCESSING' },
    });
    await prisma.jobRun.create({
      data: {
        jobName: JOBS.dataExport.name,
        scopeKey: created.id,
        scheduledFor: new Date(),
        idempotencyKey: `failed:${created.id}`,
        status: 'FAILED',
        finishedAt: new Date(),
        maxAttempts: 3,
        familyId,
      },
    });
    await run(created.id, 'purge');
    expect(data(await get(created.id).expect(200))).toMatchObject({
      status: 'FAILED',
      errorCode: 'EXPORT_BUILD_FAILED',
    });
    await post().expect(201);
  });
  it('does not sign expired exports and erases retained objects with a fenced job', async () => {
    const created = data(await post().expect(201));
    await run(created.id);
    await prisma.exportJob.update({
      where: { id: created.id },
      data: { expiresAt: new Date(Date.now() - 1000) },
    });
    storage.createDownloadUrl.mockClear();
    expect(data(await get(created.id).expect(200))).toMatchObject({
      status: 'EXPIRED',
      download: null,
    });
    expect(storage.createDownloadUrl).not.toHaveBeenCalled();
    await run(created.id, 'purge');
    expect(storage.eraseObjectVersions).toHaveBeenCalledTimes(1);
    await get(created.id).expect(404);
  });
  it('purges failed-attempt orphan keys even when no storageKey was checkpointed', async () => {
    const created = data(await post().expect(201));
    await prisma.exportJob.update({
      where: { id: created.id },
      data: { status: 'FAILED', expiresAt: new Date(Date.now() - 1000) },
    });
    storage.listKeys.mockResolvedValueOnce([
      `user/${userA}/exports/${created.id}/crashed-attempt.json`,
    ]);
    await run(created.id, 'purge');
    expect(storage.eraseObjectVersions).toHaveBeenCalledWith({
      bucket: 'exports',
      key: expect.stringContaining('crashed-attempt.json'),
    });
    await get(created.id).expect(404);
  });
  it('rejects missing durable lease before any upload', async () => {
    const created = data(await post().expect(201));
    await expect(
      service.execute(created.id, {
        signal: new AbortController().signal,
        lease: new JobLease(randomUUID(), 1, 1n, 3, 'missing'),
      }),
    ).rejects.toThrow('lease');
    expect(storage.uploadFile).not.toHaveBeenCalled();
  });
});
