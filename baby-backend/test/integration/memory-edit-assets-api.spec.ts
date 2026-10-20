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

describe('Memory edit assets API (focused module + PostgreSQL)', () => {
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
    method: 'get' | 'post' | 'patch',
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
  const patch = (id: string, version: number, body: object, who = author) =>
    call('patch', `/memories/${id}`, who)
      .set('If-Match', `"${version}"`)
      .send(body);
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
  it('adds, removes, restores links and selects a cover with optimistic locking', async () => {
    const [first, second] = await Promise.all([asset(), asset()]);
    const memory = data<MemoryResponseDto>(
      await create({ assetIds: [first] }).expect(201),
    );
    await call('patch', `/memories/${memory.id}`)
      .send({ addAssetIds: [second] })
      .expect(428);
    const added = data<MemoryResponseDto>(
      await patch(memory.id, memory.version, {
        addAssetIds: [second],
        coverAssetId: second,
      }).expect(200),
    );
    expect(added.version).toBe(memory.version + 1);
    expect(added.coverAssetId).toBe(second);
    const stale = await patch(memory.id, memory.version, {
      removeAssetIds: [first],
    }).expect(412);
    expect(code(stale)).toBe('VERSION_CONFLICT');
    const removed = data<MemoryResponseDto>(
      await patch(memory.id, added.version, { removeAssetIds: [first] }).expect(
        200,
      ),
    );
    expect(
      await prisma.memoryAsset.count({
        where: { memoryId: memory.id, deletedAt: null },
      }),
    ).toBe(1);
    const restored = data<MemoryResponseDto>(
      await patch(memory.id, removed.version, {
        addAssetIds: [first],
        coverAssetId: first,
      }).expect(200),
    );
    expect(restored.coverAssetId).toBe(first);
    expect(
      await prisma.memoryAsset.count({
        where: { memoryId: memory.id, deletedAt: null },
      }),
    ).toBe(2);
    expect(
      await prisma.outboxEvent.count({
        where: { aggregateId: memory.id, eventType: 'memory.changed' },
      }),
    ).toBe(3);
  });
  it('rejects the last photo, invalid cover, foreign assets, quota overflow and partner edits', async () => {
    const first = await asset(),
      second = await asset(),
      third = await asset();
    const memory = data<MemoryResponseDto>(
      await create({ assetIds: [first], body: 'Keep the photo' }).expect(201),
    );
    expect(
      code(
        await patch(memory.id, memory.version, {
          removeAssetIds: [first],
        }).expect(422),
      ),
    ).toBe('MEMORY_ASSET_REQUIRED');
    expect(
      code(
        await patch(memory.id, memory.version, { coverAssetId: second }).expect(
          422,
        ),
      ),
    ).toBe('MEMORY_COVER_INVALID');
    const foreign = await asset('READY', otherFamilyId);
    expect(
      code(
        await patch(memory.id, memory.version, {
          addAssetIds: [foreign],
        }).expect(422),
      ),
    ).toBe('MEMORY_ASSET_INVALID');
    const wrongPurpose = await asset('READY', familyId, 'CHILD_AVATAR');
    expect(
      code(
        await patch(memory.id, memory.version, {
          addAssetIds: [wrongPurpose],
        }).expect(422),
      ),
    ).toBe('MEMORY_ASSET_INVALID');
    expect(
      code(
        await patch(memory.id, memory.version, {
          addAssetIds: [second, third],
        }).expect(402),
      ),
    ).toBe('QUOTA_PHOTOS_PER_MEMORY');
    expect(
      code(
        await patch(
          memory.id,
          memory.version,
          { addAssetIds: [second] },
          partner,
        ).expect(403),
      ),
    ).toBe('MEMORY_FIELD_NOT_EDITABLE');
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memory.id } }))
        .version,
    ).toBe(memory.version);
    expect(
      await prisma.memoryAsset.count({
        where: { memoryId: memory.id, deletedAt: null },
      }),
    ).toBe(1);
  });
  it.each(['UPLOADED', 'PROCESSING'] as const)(
    'accepts %s assets and keeps the edited memory author-only until processing completes',
    async (status) => {
      const first = await asset(),
        pending = await asset(status);
      const memory = data<MemoryResponseDto>(
        await create({ assetIds: [first] }).expect(201),
      );
      const edited = data<MemoryResponseDto>(
        await patch(memory.id, memory.version, {
          addAssetIds: [pending],
        }).expect(200),
      );
      expect(edited.status).toBe('PROCESSING');
      await call('get', `/memories/${memory.id}`, partner).expect(404);
      expect(
        await prisma.memoryAsset.count({
          where: { memoryId: memory.id, assetId: pending, deletedAt: null },
        }),
      ).toBe(1);
    },
  );
});
