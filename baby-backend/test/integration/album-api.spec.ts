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
import { AlbumCollectionController } from '../../src/controllers/album-collection.controller';
import { AlbumCollectionService } from '../../src/services/album-collection.service';
import { AlbumCollectionRepository } from '../../src/repositories/album-collection.repository';
import { ALBUM_COLLECTION_SERVICE } from '../../src/interfaces/services/album-collection-service.interface';
import { ALBUM_COLLECTION_REPOSITORY } from '../../src/interfaces/repositories/album-collection-repository.interface';
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
import type { AlbumCollectionResponseDto } from '../../src/dto/album/album-collection.dto';
import type { MemoryFeedResponseDto } from '../../src/dto/memory/memory-response.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const feedData = (response: { body: unknown }): MemoryFeedResponseDto =>
  response.body as MemoryFeedResponseDto;
describe('Albums API (focused module + PostgreSQL)', () => {
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
  const url = `/api/v1/families/${familyId}/albums`;

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
      controllers: [AlbumCollectionController],
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
        { provide: OBJECT_STORAGE_SERVICE, useValue: {} },
        { provide: ConfigService, useValue: config },
        { provide: ALBUM_COLLECTION_SERVICE, useClass: AlbumCollectionService },
        {
          provide: ALBUM_COLLECTION_REPOSITORY,
          useClass: AlbumCollectionRepository,
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
  });
  afterAll(async () => {
    await app?.close();
  });
  const http = (
    method: 'get' | 'post' | 'patch' | 'delete',
    path: string,
    who: string = parent,
    input?: object,
  ) => {
    const client = request(app.getHttpServer());
    const req = client[method](path).set('Authorization', tokens.get(who)!);
    return input ? req.send(input) : req;
  };
  let albumId: string;
  const childId = randomUUID();
  const hiddenChildId = randomUUID();
  const sharedId = randomUUID(),
    parentOnlyId = randomUUID(),
    privateId = randomUUID(),
    hiddenChildMemoryId = randomUUID();
  it('creates only for Parents, rejects invalid names, outsiders and missing authentication', async () => {
    await request(app.getHttpServer()).get(url).expect(401);
    await http('get', url, outsider).expect(404);
    await http('post', url, circle, { name: 'Circle album' }).expect(404);
    for (const name of ['', '   ', 'x'.repeat(61), null])
      await http('post', url, parent, { name }).expect(400);
    const result = data<AlbumCollectionResponseDto>(
      await http('post', url, parent, { name: '  Family memories  ' }).expect(
        201,
      ),
    );
    albumId = result.id;
    expect(result).toMatchObject({
      name: 'Family memories',
      memoryCount: 0,
      cover: null,
    });
    await prisma.child.createMany({
      data: [childId, hiddenChildId].map((id, index) => ({
        id,
        familyId,
        birthDate: new Date('2025-01-01'),
        colorIndex: index + 1,
        nickname: `Synthetic ${index}`,
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
      [parentOnlyId, 'PARENTS', childId],
      [privateId, 'PRIVATE', childId],
      [hiddenChildMemoryId, 'FAMILY', hiddenChildId],
    ] as const) {
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: 'DIARY',
          body: 'Synthetic album memory',
          visibility,
          status: 'PUBLISHED',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          publishedAt: new Date(),
        },
      });
      await prisma.memoryChild.create({
        data: {
          memoryId: id,
          familyId,
          childId: child,
          ageMonth: 12,
          addedBy: parent,
        },
      });
    }
  });
  it('adds idempotently and counts only memories visible to each caller, including safe cover fallback', async () => {
    const ids = [sharedId, parentOnlyId, privateId, hiddenChildMemoryId];
    for (let i = 0; i < 2; i++)
      await http('post', `/api/v1/albums/${albumId}/memories`, parent, {
        memoryIds: ids,
      }).expect(204);
    expect(
      await prisma.albumMemory.count({ where: { albumId, deletedAt: null } }),
    ).toBe(4);
    await http('patch', `/api/v1/albums/${albumId}`, parent, {
      coverMemoryId: privateId,
    }).expect(200);
    const listed = async (who: string) =>
      data<{ items: AlbumCollectionResponseDto[] }>(
        await http('get', url, who).expect(200),
      ).items.find((item) => item.id === albumId)!;
    expect((await listed(parent)).memoryCount).toBe(4);
    expect((await listed(parentB)).memoryCount).toBe(3);
    const visible = await listed(circle);
    expect(visible).toMatchObject({ memoryCount: 1, coverMemoryId: sharedId });
    expect(visible.cover?.childIds).toEqual([childId]);
    const feed = feedData(
      await http('get', `/api/v1/albums/${albumId}/memories`, circle).expect(
        200,
      ),
    );
    expect(feed.data.map((item) => item.id)).toEqual([sharedId]);
    await http('patch', `/api/v1/albums/${albumId}`, circle, {
      name: 'Denied',
    }).expect(403);
  });
  it('hides sensitive albums completely from Circle', async () => {
    const sensitive = await prisma.album.create({
      data: {
        familyId,
        ownerUserId: parent,
        name: 'Sensitive',
        isSensitive: true,
      },
    });
    const listed = data<{ items: AlbumCollectionResponseDto[] }>(
      await http('get', url, circle).expect(200),
    );
    expect(listed.items.some((item) => item.id === sensitive.id)).toBe(false);
    await http('get', `/api/v1/albums/${sensitive.id}/memories`, circle).expect(
      404,
    );
  });
  it('revalidates cover membership transactionally and serializes concurrent cover assignment/removal', async () => {
    const repository = new AlbumCollectionRepository(prisma);
    const album = await repository.create(
      familyId,
      parent,
      'Concurrent cover fixture',
    );
    await repository.addMemories(album.id, familyId, parent, [sharedId]);
    await repository.removeMemory(album.id, familyId, sharedId);
    // Reproduce a stale service validation followed by a committed removal.
    await expect(
      repository.update(album.id, familyId, { coverMemoryId: sharedId }),
    ).rejects.toMatchObject({ code: 'ALBUM_COVER_INVALID', statusCode: 422 });
    for (let attempt = 0; attempt < 5; attempt++) {
      await repository.addMemories(album.id, familyId, parent, [sharedId]);
      const results = await Promise.allSettled([
        repository.update(album.id, familyId, { coverMemoryId: sharedId }),
        repository.removeMemory(album.id, familyId, sharedId),
      ]);
      expect(results[1].status).toBe('fulfilled');
      if (results[0].status === 'rejected')
        expect(results[0].reason).toMatchObject({
          code: 'ALBUM_COVER_INVALID',
        });
      expect(
        (await prisma.album.findUniqueOrThrow({ where: { id: album.id } }))
          .coverMemoryId,
      ).toBeNull();
      expect(
        (
          await prisma.albumMemory.findUniqueOrThrow({
            where: {
              albumId_memoryId: { albumId: album.id, memoryId: sharedId },
            },
          })
        ).deletedAt,
      ).not.toBeNull();
    }
  });
  it('supports pagination, Parent edits, removal/restore and soft deletion without deleting memories', async () => {
    const first = feedData(
      await http('get', `/api/v1/albums/${albumId}/memories?limit=1`).expect(
        200,
      ),
    );
    expect(first.data).toHaveLength(1);
    expect(first.nextCursor).toBe(first.data[0]!.id);
    const second = feedData(
      await http(
        'get',
        `/api/v1/albums/${albumId}/memories?limit=1&cursor=${first.nextCursor}`,
      ).expect(200),
    );
    expect(second.data[0]!.id).not.toBe(first.data[0]!.id);
    await http('patch', `/api/v1/albums/${albumId}`, parentB, {
      name: 'Renamed',
    }).expect(200);
    await http('patch', `/api/v1/albums/${albumId}`, parent, {}).expect(400);
    await http(
      'delete',
      `/api/v1/albums/${albumId}/memories/${privateId}`,
    ).expect(204);
    expect(
      (
        await prisma.albumMemory.findUniqueOrThrow({
          where: { albumId_memoryId: { albumId, memoryId: privateId } },
        })
      ).deletedAt,
    ).not.toBeNull();
    await http('post', `/api/v1/albums/${albumId}/memories`, parent, {
      memoryIds: [privateId],
    }).expect(204);
    await http('delete', `/api/v1/albums/${albumId}`).expect(204);
    expect(
      (await prisma.album.findUniqueOrThrow({ where: { id: albumId } }))
        .deletedAt,
    ).not.toBeNull();
    expect(
      await prisma.memory.count({
        where: {
          id: { in: [sharedId, parentOnlyId, privateId, hiddenChildMemoryId] },
          deletedAt: null,
        },
      }),
    ).toBe(4);
    await http('get', `/api/v1/albums/${albumId}/memories`).expect(404);
  });
});
