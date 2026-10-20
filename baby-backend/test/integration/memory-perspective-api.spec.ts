import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { getStorageToken, ThrottlerStorageService } from '@nestjs/throttler';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { MemoryPerspectiveContentController } from '../../src/controllers/memory-perspective-content.controller';
import { MemoryPerspectiveContentService } from '../../src/services/memory-perspective-content.service';
import { MemoryPerspectiveContentRepository } from '../../src/repositories/memory-perspective-content.repository';
import { MEMORY_PERSPECTIVE_CONTENT_SERVICE } from '../../src/interfaces/services/memory-perspective-content-service.interface';
import { MEMORY_PERSPECTIVE_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-perspective-content-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import { MemoryLibraryService } from '../../src/services/memory-library.service';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { MEMORY_LIBRARY_SERVICE } from '../../src/interfaces/services/memory-library-service.interface';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Memory perspectives API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  const familyId = randomUUID();
  const memoryId = randomUUID();
  const childId = randomUUID();
  const parentB = randomUUID();
  const parent = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const tokens = new Map<string, string>();
  const url = `/api/v1/memories/${memoryId}`;

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    keys = await generateKeyPair('ES256', { extractable: true });
    config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MemoryPerspectiveContentController],
      providers: [
        PrismaService,
        { provide: getStorageToken(), useClass: ThrottlerStorageService },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: MEMORY_LIBRARY_SERVICE, useClass: MemoryLibraryService },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        { provide: OBJECT_STORAGE_SERVICE, useValue: {} },
        {
          provide: MEDIA_SERVICE,
          useValue: { signViewUrls: () => Promise.resolve({ items: [] }) },
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: MEMORY_PERSPECTIVE_CONTENT_SERVICE,
          useClass: MemoryPerspectiveContentService,
        },
        {
          provide: MEMORY_PERSPECTIVE_CONTENT_REPOSITORY,
          useClass: MemoryPerspectiveContentRepository,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
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
    for (const userId of [parent, parentB, circle, outsider]) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic settings fixture' },
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
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer(config.get<string>('AUTH_JWT_ISSUER')!).setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!).setIssuedAt().setExpirationTime('5m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic settings family',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date(),
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: parent,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `SETTINGS_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic settings' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: {},
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
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
      },
    });
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic child',
        birthDate: new Date('2025-01-01'),
        colorIndex: 1,
        createdBy: parent,
      },
    });
    const member = await prisma.circleMember.findFirstOrThrow({
      where: { familyId, userId: circle },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
    await prisma.memory.create({
      data: {
        id: memoryId,
        familyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'MOMENT',
        body: 'Synthetic memory',
        visibility: 'FAMILY',
        status: 'PUBLISHED',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        publishedAt: new Date(),
      },
    });
    await prisma.memoryChild.create({
      data: { memoryId, familyId, childId, ageMonth: 1 },
    });
  });
  afterAll(async () => {
    await app?.close();
  });
  const put = (who: string, body: object) =>
    request(app.getHttpServer())
      .put(`${url}/perspective`)
      .set('Authorization', tokens.get(who)!)
      .send(body);
  const get = (who: string) =>
    request(app.getHttpServer())
      .get(`${url}/perspectives`)
      .set('Authorization', tokens.get(who)!);

  it('only the other Parent creates; upsert is unique; hidden perspective stays private from Circle', async () => {
    await put(parent, { body: 'Original author' }).expect(403);
    await put(circle, { body: 'Circle' }).expect(404);
    await put(outsider, { body: 'Outsider' }).expect(404);
    await put(parentB, {}).expect(422);
    const created = data<{ id: string }>(
      await put(parentB, {
        body: 'Other perspective',
        hiddenFromCircle: true,
      }).expect(200),
    );
    expect(
      data<{ items: unknown[] }>(await get(circle).expect(200)).items,
    ).toEqual([]);
    expect(
      data<{ items: unknown[] }>(await get(parent).expect(200)).items,
    ).toHaveLength(1);
    const updated = data<{ id: string }>(
      await put(parentB, { hiddenFromCircle: false }).expect(200),
    );
    expect(updated.id).toBe(created.id);
    expect(
      data<{ items: unknown[] }>(await get(circle).expect(200)).items,
    ).toHaveLength(1);
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memoryId } }))
        .perspectiveCount,
    ).toBe(1);
  });
  it('inherits narrowed visibility and granted child scope on every read', async () => {
    await prisma.memory.update({
      where: { id: memoryId },
      data: { visibility: 'PARENTS' },
    });
    await get(circle).expect(404);
    await get(parentB).expect(200);
    await prisma.memory.update({
      where: { id: memoryId },
      data: { visibility: 'PRIVATE' },
    });
    await get(parentB).expect(404);
    await prisma.memory.update({
      where: { id: memoryId },
      data: { visibility: 'FAMILY' },
    });
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { status: 'PAUSED' },
    });
    await get(circle).expect(404);
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { status: 'ACTIVE' },
    });
  });
  it('validates uploaded same-family audio and text limit', async () => {
    await put(parentB, { audioAssetId: randomUUID() }).expect(422);
    await put(parentB, { body: 'x'.repeat(1001) }).expect(400);
    const audio = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: parentB,
        kind: 'AUDIO',
        status: 'PENDING_UPLOAD',
        storageKey: `synthetic/${randomUUID()}`,
        mime: 'audio/aac',
        declaredSize: BigInt(1),
      },
    });
    await put(parentB, { audioAssetId: audio.id }).expect(422);
    await prisma.asset.update({
      where: { id: audio.id },
      data: { status: 'UPLOADED' },
    });
    await put(parentB, { body: null, audioAssetId: audio.id }).expect(200);
  });
  it('rejects another Parent private-memory audio and non-memory purpose assets', async () => {
    const audio = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: parent,
        kind: 'AUDIO',
        status: 'READY',
        purpose: 'MEMORY',
        storageKey: `synthetic/${randomUUID()}`,
        mime: 'audio/aac',
        declaredSize: BigInt(1),
      },
    });
    const privateMemory = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'VOICE',
        body: 'Private audio',
        visibility: 'PRIVATE',
        status: 'PUBLISHED',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        publishedAt: new Date(),
      },
    });
    await prisma.memoryAsset.create({
      data: {
        memoryId: privateMemory.id,
        familyId,
        assetId: audio.id,
        sortOrder: 0,
      },
    });
    await put(parentB, { audioAssetId: audio.id }).expect(422);
    await prisma.memory.update({
      where: { id: privateMemory.id },
      data: { visibility: 'PARENTS' },
    });
    await put(parentB, { audioAssetId: audio.id }).expect(200);
    const privateAsset = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: parentB,
        privateOwnerUserId: parentB,
        kind: 'AUDIO',
        status: 'READY',
        purpose: 'JOURNAL',
        storageKey: `synthetic/${randomUUID()}`,
        mime: 'audio/aac',
        declaredSize: BigInt(1),
      },
    });
    await put(parentB, { audioAssetId: privateAsset.id }).expect(422);
    const avatar = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: parentB,
        kind: 'AUDIO',
        status: 'READY',
        purpose: 'AVATAR',
        storageKey: `synthetic/${randomUUID()}`,
        mime: 'audio/aac',
        declaredSize: BigInt(1),
      },
    });
    await put(parentB, { audioAssetId: avatar.id }).expect(422);
  });
  it('soft deletes idempotently and restores same unique row with atomic count and outbox', async () => {
    const remove = () =>
      request(app.getHttpServer())
        .delete(`${url}/perspective`)
        .set('Authorization', tokens.get(parentB)!);
    await remove().expect(204);
    await remove().expect(204);
    expect(
      data<{ items: unknown[] }>(await get(parent).expect(200)).items,
    ).toEqual([]);
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memoryId } }))
        .perspectiveCount,
    ).toBe(0);
    const old = await prisma.memoryPerspective.findFirstOrThrow({
      where: { memoryId },
    });
    expect(old.deletedAt).not.toBeNull();
    const restored = data<{ id: string }>(
      await put(parentB, { body: 'Restored' }).expect(200),
    );
    expect(restored.id).toBe(old.id);
    expect(await prisma.memoryPerspective.count({ where: { memoryId } })).toBe(
      1,
    );
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'memory.perspective.changed' },
      }),
    ).toBeGreaterThanOrEqual(5);
  });
});
