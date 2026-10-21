import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe, type INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';
import { MemoryController } from '../../src/controllers/memory.controller';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { CATALOG_QUERY_REPOSITORY } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import { MEDIA_REPOSITORY } from '../../src/interfaces/repositories/media-repository.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';
import { MediaRepository } from '../../src/repositories/media.repository';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { MediaService } from '../../src/services/media.service';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { ObjectStorageService } from '../../src/services/object-storage.service';

interface MemoryJson {
  id: string;
  kind: string;
  status: string;
  durationSec: number | null;
  assets: {
    assetId: string;
    durationMs: number;
    urls: Record<string, string>;
  }[];
}
const memory = (r: { body: unknown }) => (r.body as { data: MemoryJson }).data;
const errorCode = (r: { body: unknown }) =>
  (r.body as { error: { code: string } }).error.code;

describe('VOICE (isolated Nest module, PostgreSQL and signed media URLs)', () => {
  const partnerId = randomUUID();
  let catalogVersion = 1;
  async function changeQuotas(next: Record<string, number>) {
    const id = randomUUID();
    await prisma.planVersion.create({
      data: {
        id,
        planId,
        version: ++catalogVersion,
        quotas: next,
        features: { 'circle.enabled': false },
        availableFrom: new Date(),
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: id },
    });
  }
  let app: INestApplication<Server>, prisma: PrismaService;
  const familyId = randomUUID(),
    userId = randomUUID(),
    sessionId = randomUUID();
  const childId = randomUUID(),
    planId = randomUUID(),
    versionId = randomUUID(),
    licenseId = randomUUID();
  let authorization: string, voiceId: string, audioId: string;
  const future = () => new Date(Date.now() + 86_400_000);
  const quotas = {
    storageBytes: 1_073_741_824,
    photosPerMemory: 10,
    audioMaxSec: 300,
  };
  function create(body: Record<string, unknown>, key = randomUUID()) {
    return request(app.getHttpServer())
      .post('/api/v1/memories')
      .set('Authorization', authorization)
      .set('Idempotency-Key', key)
      .send({
        familyId,
        kind: 'VOICE',
        childIds: [childId],
        visibility: 'PARENTS',
        occurredAt: '2026-10-01T00:00:00Z',
        ...body,
      });
  }
  async function asset(
    kind: 'AUDIO' | 'IMAGE' = 'AUDIO',
    status: 'READY' | 'PROCESSING' = 'READY',
    durationMs: number | null = 12_345,
  ) {
    const id = randomUUID();
    await prisma.asset.create({
      data: {
        id,
        familyId,
        uploaderUserId: userId,
        kind,
        purpose: 'MEMORY',
        status,
        mime: kind === 'AUDIO' ? 'audio/mp4' : 'image/jpeg',
        durationMs,
        storageKey: `test/voice/${familyId}/${id}/raw`,
        declaredSize: 1000n,
        sizeBytes: 1000n,
      },
    });
    if (status === 'READY')
      await prisma.assetVariant.create({
        data: {
          familyId,
          assetId: id,
          variantCode: 'a',
          storageBucket: 'bf-media',
          storageKey: `test/voice/${familyId}/${id}/a`,
          mime: 'audio/mp4',
          sizeBytes: 1000n,
          durationMs,
        },
      });
    return id;
  }
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('VOICE requires baby_family_test.');
    const keys = await generateKeyPair('ES256');
    const config = new ConfigService({
      ...validateEnvironment({
        ...process.env,
        S3_ENDPOINT: 'http://127.0.0.1:9000',
        S3_PUBLIC_ENDPOINT: 'http://127.0.0.1:9000',
        S3_ACCESS_KEY_ID: 'synthetic-voice',
        S3_SECRET_ACCESS_KEY: 'synthetic-voice-secret',
      }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MemoryController],
      providers: [
        PrismaService,
        { provide: ConfigService, useValue: config },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        { provide: MEDIA_REPOSITORY, useClass: MediaRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        { provide: MEDIA_SERVICE, useClass: MediaService },
        { provide: OBJECT_STORAGE_SERVICE, useClass: ObjectStorageService },
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
    await prisma.user.create({
      data: {
        id: userId,
        displayName: 'Synthetic voice parent',
        status: 'ACTIVE',
        tokenVersion: 1,
      },
    });
    await prisma.user.create({
      data: {
        id: partnerId,
        displayName: 'Synthetic voice partner',
        status: 'ACTIVE',
        tokenVersion: 1,
      },
    });
    await prisma.userSession.create({
      data: {
        id: sessionId,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: future(),
        absoluteExpiresAt: future(),
      },
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic voice family',
        createdBy: userId,
        status: 'ACTIVE',
        activatedAt: new Date(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    await prisma.familyParent.create({
      data: { familyId, userId, slot: 'A', kind: 'FATHER', callName: 'A' },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: partnerId,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'B',
      },
    });
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        nickname: 'Synthetic',
        birthDate: new Date('2026-01-01'),
        colorIndex: 1,
        createdBy: userId,
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `VOICE_${planId.replaceAll('-', '').slice(0, 12)}`,
        displayNameI18n: { vi: 'Synthetic' },
        active: true,
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: versionId,
        planId,
        version: 1,
        quotas,
        features: { 'circle.enabled': false },
        availableFrom: new Date(),
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
    const iat = Math.floor(Date.now() / 1000);
    authorization = `Bearer ${await new SignJWT({ sub: userId, sid: sessionId, ver: 1, iat, exp: iat + 900, iss: 'baby-family', aud: 'baby-family-app' }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).sign(keys.privateKey)}`;
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.outboxEvent.deleteMany({ where: { familyId } });
        await prisma.idempotencyRecord.deleteMany({ where: { familyId } });
        await prisma.memoryAsset.deleteMany({ where: { familyId } });
        await prisma.memoryChild.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.assetVariant.deleteMany({ where: { familyId } });
        await prisma.asset.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.child.deleteMany({ where: { familyId } });
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
        await prisma.userSession.deleteMany({ where: { userId } });
        await prisma.user.updateMany({
          where: { id: { in: [userId, partnerId] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
      }
    } finally {
      if (app) await app.close();
    }
  });
  it('creates, replays, and projects trusted duration + signed playable URL in detail/feed/timeline', async () => {
    audioId = await asset();
    const key = randomUUID();
    const result = memory(
      await create({ assetIds: [audioId] }, key).expect(201),
    );
    voiceId = result.id;
    expect(result).toMatchObject({
      kind: 'VOICE',
      status: 'PUBLISHED',
      durationSec: 12.345,
      assets: [{ assetId: audioId, durationMs: 12345 }],
    });
    const url = new URL(result.assets[0]!.urls.a!);
    expect(url.searchParams.get('X-Amz-Signature')).toBeTruthy();
    expect(url.searchParams.get('X-Amz-Expires')).toBe('3600');
    expect(
      memory(await create({ assetIds: [audioId] }, key).expect(201)).id,
    ).toBe(voiceId);
    expect(
      memory(
        await request(app.getHttpServer())
          .get(`/api/v1/memories/${voiceId}`)
          .set('Authorization', authorization)
          .expect(200),
      ).durationSec,
    ).toBe(12.345);
    const feed = await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/feed`)
      .set('Authorization', authorization)
      .expect(200);
    expect((feed.body as { data: MemoryJson[] }).data).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ id: voiceId, durationSec: 12.345 }),
      ]),
    );
    const timeline = await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/timeline`)
      .set('Authorization', authorization)
      .query({ childId })
      .expect(200);
    expect((timeline.body as { data: unknown[] }).data).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          type: 'MEMORY',
          memory: expect.objectContaining({ id: voiceId, durationSec: 12.345 }),
        }),
      ]),
    );
  });
  it('requires exactly one READY AUDIO with valid metadata, including edit', async () => {
    for (const ids of [[], [audioId, await asset()]])
      expect(
        errorCode(
          await create({ body: 'Synthetic', assetIds: ids }).expect(422),
        ),
      ).toBe('MEMORY_VOICE_ASSET_REQUIRED');
    for (const id of [
      await asset('IMAGE'),
      await asset('AUDIO', 'PROCESSING'),
      await asset('AUDIO', 'READY', null),
      await asset('AUDIO', 'READY', 0),
    ])
      expect(errorCode(await create({ assetIds: [id] }).expect(422))).toBe(
        'MEMORY_VOICE_ASSET_INVALID',
      );
    const r = await request(app.getHttpServer())
      .patch(`/api/v1/memories/${voiceId}`)
      .set('Authorization', authorization)
      .set('If-Match', '1')
      .send({ addAssetIds: [await asset()] })
      .expect(422);
    expect(errorCode(r)).toBe('MEMORY_VOICE_ASSET_REQUIRED');
  });
  it('rejects client duration and enforces stored duration/current quota on create/draft/publish/edit', async () => {
    await create({ assetIds: [audioId], durationSec: 1 }).expect(400);
    const over = await asset('AUDIO', 'READY', 300001);
    expect(errorCode(await create({ assetIds: [over] }).expect(422))).toBe(
      'QUOTA_AUDIO_DURATION_EXCEEDED',
    );
    await create({ status: 'DRAFT', assetIds: [over] }).expect(422);
    expect(
      memory(
        await create({
          assetIds: [await asset('AUDIO', 'READY', 300000)],
        }).expect(201),
      ).durationSec,
    ).toBe(300);
    const draft = memory(
      await create({ status: 'DRAFT', assetIds: [audioId] }).expect(201),
    );
    await changeQuotas({ ...quotas, audioMaxSec: 10 });
    expect(
      errorCode(
        await request(app.getHttpServer())
          .post(`/api/v1/memories/${draft.id}/publish`)
          .set('Authorization', authorization)
          .expect(422),
      ),
    ).toBe('QUOTA_AUDIO_DURATION_EXCEEDED');
    expect(
      errorCode(
        await request(app.getHttpServer())
          .patch(`/api/v1/memories/${voiceId}`)
          .set('Authorization', authorization)
          .set('If-Match', '1')
          .send({ body: 'Synthetic' })
          .expect(422),
      ),
    ).toBe('QUOTA_AUDIO_DURATION_EXCEEDED');
    await changeQuotas(quotas);
  });
  it('does not apply photo quota to VOICE create, publish or edit', async () => {
    await changeQuotas({ ...quotas, photosPerMemory: 0 });
    const saved = memory(await create({ assetIds: [audioId] }).expect(201));
    const draft = memory(
      await create({ status: 'DRAFT', assetIds: [audioId] }).expect(201),
    );
    await request(app.getHttpServer())
      .post(`/api/v1/memories/${draft.id}/publish`)
      .set('Authorization', authorization)
      .expect(200);
    await request(app.getHttpServer())
      .patch(`/api/v1/memories/${saved.id}`)
      .set('Authorization', authorization)
      .set('If-Match', '1')
      .send({ body: 'Synthetic' })
      .expect(200);
    await changeQuotas(quotas);
  });
  it('fails closed without audio quota while preserving other memory kinds', async () => {
    await changeQuotas({ photosPerMemory: 10 });
    expect(errorCode(await create({ assetIds: [audioId] }).expect(402))).toBe(
      'SUBSCRIPTION_REQUIRED',
    );
    for (const kind of ['MOMENT', 'DIARY', 'QUOTE', 'KEEPSAKE']) {
      const result = memory(
        await create({
          kind,
          body: 'Synthetic text',
          assetIds: kind === 'KEEPSAKE' ? [await asset('IMAGE')] : [],
        }).expect(201),
      );
      expect(result.kind).toBe(kind);
      expect(result.durationSec).toBeNull();
    }
    await changeQuotas(quotas);
  });
});
