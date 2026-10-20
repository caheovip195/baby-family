import { MemoryLibraryController } from '../../src/controllers/memory-library.controller';
import type { OriginalDownloadResponse } from '../../src/dto/memory-library/library-query.dto';
import { MEMORY_LIBRARY_POLICY } from '../../src/config/memory-library-policy';
import { getStorageToken, ThrottlerStorageService } from '@nestjs/throttler';
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
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MEMORY_LIBRARY_SERVICE } from '../../src/interfaces/services/memory-library-service.interface';
import { MemoryLibraryService } from '../../src/services/memory-library.service';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { MemoryFeedResponseDto } from '../../src/dto/memory/memory-response.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const feedData = (response: { body: unknown }): MemoryFeedResponseDto =>
  response.body as MemoryFeedResponseDto;
describe('Memory library API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  const familyId = randomUUID();
  const parentB = randomUUID();
  const parent = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const tokens = new Map<string, string>();
  const childId = randomUUID(),
    hiddenChildId = randomUUID();
  const sharedId = randomUUID(),
    privateId = randomUUID(),
    parentsId = randomUUID(),
    hiddenId = randomUUID();
  const assetId = randomUUID();
  const storage = {
    bucketOf: () => 'media',
    createDownloadUrl: jest.fn(
      (input: { key: string; expiresInSeconds: number }) =>
        Promise.resolve({
          url: `https://storage.invalid/${input.key}`,
          expiresAt: new Date(Date.now() + input.expiresInSeconds * 1000),
        }),
    ),
  };
  const url = `/api/v1/families/${familyId}/favorites`;

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
      controllers: [MemoryLibraryController],
      providers: [
        PrismaService,
        { provide: getStorageToken(), useClass: ThrottlerStorageService },
        AccessTokenGuard,
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
        {
          provide: MEDIA_SERVICE,
          useValue: {
            signViewUrls: jest
              .fn()
              .mockResolvedValue({ items: [], unavailableIds: [] }),
          },
        },
        { provide: OBJECT_STORAGE_SERVICE, useValue: storage },
        { provide: ConfigService, useValue: config },
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
  });
  beforeAll(async () => {
    await prisma.child.createMany({
      data: [childId, hiddenChildId].map((id, index) => ({
        id,
        familyId,
        birthDate: new Date('2025-01-01'),
        nickname: 'Synthetic',
        colorIndex: index + 1,
        createdBy: parent,
      })),
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
    for (const [id, visibility, child] of [
      [sharedId, 'FAMILY', childId],
      [privateId, 'PRIVATE', childId],
      [parentsId, 'PARENTS', childId],
      [hiddenId, 'FAMILY', hiddenChildId],
    ] as const) {
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: 'DIARY',
          body: 'Synthetic',
          visibility,
          status: 'PUBLISHED',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          publishedAt: new Date(),
        },
      });
      await prisma.memoryChild.create({
        data: { memoryId: id, familyId, childId: child, ageMonth: 12 },
      });
    }
    await prisma.asset.create({
      data: {
        id: assetId,
        familyId,
        uploaderUserId: parent,
        kind: 'IMAGE',
        status: 'READY',
        storageKey: `fam/${familyId}/raw`,
        storageBucket: 'bf-media',
        mime: 'image/jpeg',
        declaredSize: 100n,
        sizeBytes: 100n,
        keepOriginal: true,
      },
    });
    await prisma.assetVariant.create({
      data: {
        familyId,
        assetId,
        variantCode: 'orig',
        storageBucket: 'bf-media',
        storageKey: `fam/${familyId}/clean-original.jpg`,
        mime: 'image/jpeg',
        sizeBytes: 100n,
      },
    });
    await prisma.memoryAsset.create({
      data: {
        familyId,
        memoryId: sharedId,
        assetId,
        sortOrder: 0,
        isCover: true,
      },
    });
  });
  afterAll(async () => {
    await app?.close();
  });
  const http = (
    method: 'get' | 'post' | 'put' | 'delete',
    path: string,
    who = parent,
  ) => {
    const client = request(app.getHttpServer());
    return client[method](path).set('Authorization', tokens.get(who)!);
  };
  it('keeps favorites personal, idempotent and soft deleted; checks membership and pagination', async () => {
    await request(app.getHttpServer()).get(url).expect(401);
    await http('get', url, outsider).expect(404);
    for (let i = 0; i < 2; i++)
      await http('put', `/api/v1/memories/${sharedId}/favorite`).expect(204);
    await http('put', `/api/v1/memories/${privateId}/favorite`).expect(204);
    expect(feedData(await http('get', url).expect(200)).data).toHaveLength(2);
    expect(feedData(await http('get', url, parentB).expect(200)).data).toEqual(
      [],
    );
    expect(feedData(await http('get', url, circle).expect(200)).data).toEqual(
      [],
    );
    const first = feedData(await http('get', url + '?limit=1').expect(200));
    const second = feedData(
      await http('get', url + '?limit=1&cursor=' + first.nextCursor!).expect(
        200,
      ),
    );
    expect(first.data[0]!.id).not.toBe(second.data[0]!.id);
    await http('get', url + '?cursor=bad').expect(400);
    await http('delete', `/api/v1/memories/${privateId}/favorite`).expect(204);
    expect(
      (
        await prisma.favorite.findUniqueOrThrow({
          where: { userId_memoryId: { userId: parent, memoryId: privateId } },
        })
      ).deletedAt,
    ).not.toBeNull();
    await http('put', `/api/v1/memories/${privateId}/favorite`).expect(204);
    expect(
      await prisma.favorite.count({
        where: { userId: parent, memoryId: privateId },
      }),
    ).toBe(1);
  });
  it('enforces Circle visibility and live grants on favorites', async () => {
    await http('put', `/api/v1/memories/${sharedId}/favorite`, circle).expect(
      204,
    );
    for (const id of [privateId, parentsId, hiddenId])
      await http('put', `/api/v1/memories/${id}/favorite`, circle).expect(404);
    expect(
      feedData(await http('get', url, circle).expect(200)).data.map(
        (m) => m.id,
      ),
    ).toEqual([sharedId]);
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { status: 'REVOKED' },
    });
    expect(feedData(await http('get', url, circle).expect(200)).data).toEqual(
      [],
    );
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { status: 'ACTIVE' },
    });
  });
  it('blocks forbidden downloads and signs only retained sanitized originals, with attachment TTL and audit', async () => {
    const path = `/api/v1/memories/${sharedId}/download-urls`;
    await http('post', path, circle).expect(403);
    await http(
      'post',
      `/api/v1/memories/${privateId}/download-urls`,
      parentB,
    ).expect(404);
    await http(
      'post',
      `/api/v1/memories/${parentsId}/download-urls`,
      circle,
    ).expect(404);
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { allowDownload: true },
    });
    const result = data<OriginalDownloadResponse>(
      await http('post', path, circle).expect(200),
    );
    expect(result.items).toHaveLength(1);
    expect(result.items[0]).toMatchObject({
      assetId,
      kind: 'IMAGE',
      url: `https://storage.invalid/fam/${familyId}/clean-original.jpg`,
    });
    expect(storage.createDownloadUrl).toHaveBeenLastCalledWith(
      expect.objectContaining({
        key: `fam/${familyId}/clean-original.jpg`,
        expiresInSeconds: 600,
        downloadFileName: expect.stringMatching(
          /^BabyFamily_.*_1\.jpg$/,
        ) as unknown,
      }),
    );
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'memory.original.downloaded' },
      }),
    ).toBe(1);
    await http('post', path, parentB).expect(200);
    await prisma.assetVariant.updateMany({
      where: { assetId },
      data: { deletedAt: new Date() },
    });
    expect(
      data<OriginalDownloadResponse>(await http('post', path).expect(200))
        .items,
    ).toEqual([]);
  });
  it('rechecks ended membership, redacts ungranted pregnancy and hides sensitive pregnancy content', async () => {
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { endedAt: new Date() },
    });
    await http('get', url, circle).expect(403);
    await http(
      'post',
      `/api/v1/memories/${sharedId}/download-urls`,
      circle,
    ).expect(404);
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { endedAt: null },
    });
    const pregnancy = await prisma.pregnancy.create({
      data: { familyId, seqNo: 1, nickname: 'Synthetic', createdBy: parent },
    });
    await prisma.memory.update({
      where: { id: sharedId },
      data: { pregnancyId: pregnancy.id, pregnancyWeek: 20 },
    });
    const page = feedData(await http('get', url, circle).expect(200));
    expect(page.data[0]).toMatchObject({
      pregnancyId: null,
      pregnancyWeek: null,
    });
    await prisma.pregnancy.update({
      where: { id: pregnancy.id },
      data: { status: 'ENDED_PRIVATE' },
    });
    expect(feedData(await http('get', url, circle).expect(200)).data).toEqual(
      [],
    );
    await http(
      'post',
      `/api/v1/memories/${sharedId}/download-urls`,
      circle,
    ).expect(404);
    await prisma.memory.update({
      where: { id: sharedId },
      data: { pregnancyId: null, pregnancyWeek: null },
    });
  });
  it('rate limits by actor across requests and permits expired Parent download access only', async () => {
    const path = `/api/v1/memories/${sharedId}/download-urls`;
    for (let i = 1; i < MEMORY_LIBRARY_POLICY.downloadsPerWindow; i++)
      await http('post', path, parentB).expect(200);
    const denied = await http('post', path, parentB).expect(429);
    expect((denied.body as { error: { code: string } }).error.code).toBe(
      'MEMORY_DOWNLOAD_RATE_LIMITED',
    );
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'EXPIRED', validUntil: new Date(Date.now() - 1000) },
    });
    await http('post', path).expect(200);
    await http('post', path, circle).expect(403);
    await http('get', url).expect(402);
  });
});
