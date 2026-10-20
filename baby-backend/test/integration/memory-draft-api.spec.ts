import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { MemoryController } from '../../src/controllers/memory.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { MemoryContentService } from '../../src/services/memory-content.service';
import type { MemoryResponseDto } from '../../src/dto/memory/memory-response.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Memory drafts API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const author = randomUUID(),
    partner = randomUUID();
  const familyId = randomUUID(),
    otherFamilyId = randomUUID(),
    childId = randomUUID();
  const tokens = new Map<string, string>();
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MemoryController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        // URL signing is outside this suite; authorization and persistence use real implementations.
        {
          provide: MEDIA_SERVICE,
          useValue: {
            signViewUrls: () =>
              Promise.resolve({ items: [], unavailableIds: [] }),
          },
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
    prisma = module.get(PrismaService);
    for (const userId of [author, partner]) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic memory fixture' },
      });
      await prisma.userSession.create({
        data: {
          id: sessionId,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + 86400000),
          absoluteExpiresAt: new Date(Date.now() + 86400000),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer(config.get<string>('AUTH_JWT_ISSUER')!).setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!).setIssuedAt().setExpirationTime('15m').sign(keys.privateKey)}`,
      );
    }
    for (const id of [familyId, otherFamilyId])
      await prisma.family.create({
        data: {
          id,
          name: 'Synthetic memory family',
          createdBy: author,
          status: 'ACTIVE',
          activatedAt: new Date(),
        },
      });
    await prisma.familyParent.createMany({
      data: [
        { familyId, userId: author, slot: 'A', kind: 'FATHER', callName: 'A' },
        { familyId, userId: partner, slot: 'B', kind: 'MOTHER', callName: 'B' },
      ],
    });
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        nickname: 'Synthetic child',
        birthDate: new Date('2025-01-01'),
        colorIndex: 1,
        createdBy: author,
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `MEM_SPEC_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: { photosPerMemory: 2, storageBytes: 1073741824 },
        features: { 'circle.enabled': true },
        availableFrom: new Date(),
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: version.id,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
  });
  afterAll(async () => {
    await app?.close();
  });
  const call = (
    method: 'get' | 'post' | 'patch' | 'delete',
    path: string,
    who = author,
  ) => {
    const client = request(app.getHttpServer());
    return client[method](`/api/v1${path}`).set(
      'Authorization',
      tokens.get(who)!,
    );
  };
  const create = (body: object, who = author) =>
    call('post', '/memories', who)
      .set('Idempotency-Key', randomUUID())
      .send({
        familyId,
        kind: 'MOMENT',
        childIds: [childId],
        occurredAt: '2026-01-02T08:00:00Z',
        visibility: 'FAMILY',
        ...body,
      });
  async function asset(
    status: 'READY' | 'UPLOADED' | 'PROCESSING' = 'READY',
    family = familyId,
    purpose: 'MEMORY' | 'CHILD_AVATAR' = 'MEMORY',
  ) {
    const id = randomUUID();
    await prisma.asset.create({
      data: {
        id,
        familyId: family,
        uploaderUserId: author,
        kind: 'IMAGE',
        purpose,
        status,
        storageKey: `synthetic/${id}/raw`,
        mime: 'image/jpeg',
        declaredSize: 1024n,
        sizeBytes: 1024n,
      },
    });
    return id;
  }
  it('keeps drafts private in detail, feed, timeline and draft lists, then publishes once', async () => {
    const draft = data<MemoryResponseDto>(
      await create({ status: 'DRAFT', body: 'Unfinished story' }).expect(201),
    );
    expect(draft.status).toBe('DRAFT');
    await call('get', `/memories/${draft.id}`, partner).expect(404);
    const own = (
      await call('get', `/me/drafts?familyId=${familyId}`).expect(200)
    ).body as { data: MemoryResponseDto[] };
    expect(own.data.map((item) => item.id)).toContain(draft.id);
    const theirs = (
      await call('get', `/me/drafts?familyId=${familyId}`, partner).expect(200)
    ).body as { data: MemoryResponseDto[] };
    expect(theirs.data.map((item) => item.id)).not.toContain(draft.id);
    const feed = (
      await call('get', `/families/${familyId}/feed`, partner).expect(200)
    ).body as { data: MemoryResponseDto[] };
    expect(feed.data.map((item) => item.id)).not.toContain(draft.id);
    const timeline = (
      await call(
        'get',
        `/families/${familyId}/timeline?childId=${childId}`,
        partner,
      ).expect(200)
    ).body as { data: { type: string; memory?: MemoryResponseDto }[] };
    expect(timeline.data.some((item) => item.memory?.id === draft.id)).toBe(
      false,
    );
    await call('post', `/memories/${draft.id}/publish`, partner).expect(404);
    const published = data<MemoryResponseDto>(
      await call('post', `/memories/${draft.id}/publish`).expect(200),
    );
    expect(published.status).toBe('PUBLISHED');
    await call('post', `/memories/${draft.id}/publish`).expect(200);
    await call('get', `/memories/${draft.id}`, partner).expect(200);
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: draft.id, eventType: 'memory.published' },
      }),
    ).toBe(1);
    const after = (
      await call('get', `/me/drafts?familyId=${familyId}`).expect(200)
    ).body as { data: MemoryResponseDto[] };
    expect(after.data.map((item) => item.id)).not.toContain(draft.id);
  });
  it('keeps a deleted and restored draft private until its author publishes it', async () => {
    const draft = data<MemoryResponseDto>(
      await create({ status: 'DRAFT', body: 'Never published' }).expect(201),
    );
    await call('delete', `/memories/${draft.id}`).expect(204);
    const partnerTrash = (
      await call('get', `/families/${familyId}/trash`, partner).expect(200)
    ).body as { data: MemoryResponseDto[] };
    expect(partnerTrash.data.map((item) => item.id)).not.toContain(draft.id);
    await call('post', `/memories/${draft.id}/restore`, partner).expect(404);
    const restored = data<MemoryResponseDto>(
      await call('post', `/memories/${draft.id}/restore`).expect(200),
    );
    expect(restored.status).toBe('DRAFT');
    await call('get', `/memories/${draft.id}`, partner).expect(404);
    const own = (
      await call('get', `/me/drafts?familyId=${familyId}`).expect(200)
    ).body as { data: MemoryResponseDto[] };
    expect(own.data.map((item) => item.id)).toContain(draft.id);
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: draft.id, eventType: 'memory.published' },
      }),
    ).toBe(0);
    const published = data<MemoryResponseDto>(
      await call('post', `/memories/${draft.id}/publish`).expect(200),
    );
    expect(published.status).toBe('PUBLISHED');
    expect(published.visibility).toBe('FAMILY');
    await call('get', `/memories/${draft.id}`, partner).expect(200);
  });
  it('revalidates publishing and leaves media awaiting processing private', async () => {
    const photo = await asset('PROCESSING');
    const draft = data<MemoryResponseDto>(
      await create({ status: 'DRAFT', assetIds: [photo] }).expect(201),
    );
    expect(draft.status).toBe('DRAFT');
    const published = data<MemoryResponseDto>(
      await call('post', `/memories/${draft.id}/publish`).expect(200),
    );
    expect(published.status).toBe('PROCESSING');
    await call('get', `/memories/${draft.id}`, partner).expect(404);
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: draft.id, eventType: 'memory.published' },
      }),
    ).toBe(0);
    const ready = await asset();
    const invalid = data<MemoryResponseDto>(
      await create({ status: 'DRAFT', assetIds: [ready] }).expect(201),
    );
    await prisma.asset.update({
      where: { id: ready },
      data: { status: 'FAILED' },
    });
    const rejected = await call(
      'post',
      `/memories/${invalid.id}/publish`,
    ).expect(422);
    expect(code(rejected)).toBe('MEMORY_ASSET_INVALID');
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: invalid.id } }))
        .status,
    ).toBe('DRAFT');
  });
});
