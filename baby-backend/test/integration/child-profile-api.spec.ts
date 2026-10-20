import { MemoryController } from '../../src/controllers/memory.controller';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { PregnancyController } from '../../src/controllers/pregnancy.controller';
import { PregnancyService } from '../../src/services/pregnancy.service';
import { PregnancyRepository } from '../../src/repositories/pregnancy.repository';
import { PregnancyCommandRepository } from '../../src/repositories/pregnancy-command.repository';
import { PREGNANCY_SERVICE } from '../../src/interfaces/services/pregnancy-service.interface';
import { PREGNANCY_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-repository.interface';
import { PREGNANCY_COMMAND_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-command-repository.interface';
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
import { ChildProfileController } from '../../src/controllers/child-profile.controller';
import { ChildProfileService } from '../../src/services/child-profile.service';
import { ChildProfileRepository } from '../../src/repositories/child-profile.repository';
import { CHILD_PROFILE_SERVICE } from '../../src/interfaces/services/child-profile-service.interface';
import { CHILD_PROFILE_REPOSITORY } from '../../src/interfaces/repositories/child-profile-repository.interface';
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

import { PregnancyLifecycleController } from '../../src/controllers/pregnancy-lifecycle.controller';
import { PregnancyLifecycleService } from '../../src/services/pregnancy-lifecycle.service';
import { PregnancyLifecycleRepository } from '../../src/repositories/pregnancy-lifecycle.repository';
import { PREGNANCY_LIFECYCLE_SERVICE } from '../../src/interfaces/services/pregnancy-lifecycle-service.interface';
import { PREGNANCY_LIFECYCLE_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-lifecycle-repository.interface';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Child profile and pregnancy lifecycle API (focused module + PostgreSQL)', () => {
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
  const pregnancyId = randomUUID();
  const childA = randomUUID(),
    childB = randomUUID();
  const otherFamily = randomUUID();
  let memberId: string;

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
      controllers: [
        ChildProfileController,
        PregnancyLifecycleController,
        PregnancyController,
        MemoryController,
      ],
      providers: [
        PrismaService,
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        // These assertions exercise denied Circle reads before media projection.
        { provide: MEDIA_SERVICE, useValue: {} },
        { provide: PREGNANCY_SERVICE, useClass: PregnancyService },
        { provide: PREGNANCY_REPOSITORY, useClass: PregnancyRepository },
        {
          provide: PREGNANCY_COMMAND_REPOSITORY,
          useClass: PregnancyCommandRepository,
        },
        {
          provide: PREGNANCY_LIFECYCLE_SERVICE,
          useClass: PregnancyLifecycleService,
        },
        {
          provide: PREGNANCY_LIFECYCLE_REPOSITORY,
          useClass: PregnancyLifecycleRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: CHILD_PROFILE_SERVICE,
          useClass: ChildProfileService,
        },
        {
          provide: CHILD_PROFILE_REPOSITORY,
          useClass: ChildProfileRepository,
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
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic twins',
        expectedCount: 2,
        createdBy: parent,
      },
    });
    memberId = (
      await prisma.circleMember.create({
        data: {
          familyId,
          userId: circle,
          relation: 'OTHER',
          displayName: 'Synthetic Circle',
        },
      })
    ).id;
    await prisma.family.create({
      data: { id: otherFamily, name: 'Synthetic other', createdBy: parent },
    });
    for (const [i, id] of [childA, childB].entries())
      await prisma.child.create({
        data: {
          id,
          familyId,
          name: 'Synthetic child ' + i,
          birthDate: new Date('2026-01-01'),
          colorIndex: i + 1,
          sortOrder: i,
          createdBy: parent,
        },
      });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: memberId,
        childId: childA,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
  });
  afterAll(async () => {
    await app?.close();
  });

  const api = (
    method: 'post' | 'put' | 'patch' | 'delete' | 'get',
    path: string,
    body?: object,
    who = parent,
  ) => {
    const client = request(app.getHttpServer());
    const req = client[method]('/api/v1' + path).set(
      'Authorization',
      tokens.get(who)!,
    );
    return body === undefined ? req : req.send(body);
  };
  const memory = async (
    visibility: 'FAMILY' | 'PARENTS' | 'PRIVATE',
    childIds: string[],
    extra: object = {},
  ) => {
    const row = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'MOMENT',
        occurredAt: new Date('2026-01-02'),
        occurredLocalDate: new Date('2026-01-02'),
        status: 'PUBLISHED',
        visibility,
        ...extra,
      },
    });
    for (const childId of childIds)
      await prisma.memoryChild.create({
        data: { familyId, childId, memoryId: row.id, ageMonth: 0 },
      });
    return row;
  };
  it('validates a complete active-child permutation and rejects Circle/outsiders', async () => {
    for (const childIds of [
      [childA],
      [childA, childA],
      [childA, randomUUID()],
      [],
    ])
      await api('patch', `/families/${familyId}/children/order`, {
        childIds,
      }).expect(400);
    const response = data<{ id: string; sortOrder: number }[]>(
      await api('patch', `/families/${familyId}/children/order`, {
        childIds: [childB, childA],
      }).expect(200),
    );
    expect(response.map((c) => [c.id, c.sortOrder])).toEqual([
      [childB, 0],
      [childA, 1],
    ]);
    await api(
      'patch',
      `/families/${familyId}/children/order`,
      { childIds: [childB, childA] },
      circle,
    ).expect(404);
    await api('post', `/children/${childA}/archive`, {}, outsider).expect(404);
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'child.order_changed' },
      }),
    ).toBe(1);
  });
  it('validates child avatar/cover and pregnancy cover assets and supports null removal', async () => {
    const asset = async (
      purpose: string,
      status: 'READY' | 'PENDING_UPLOAD' = 'READY',
      fid = familyId,
      privateOwnerUserId: string | null = null,
    ) =>
      prisma.asset.create({
        data: {
          familyId: fid,
          uploaderUserId: parentB,
          purpose,
          status,
          kind: 'IMAGE',
          storageKey: `synthetic/${randomUUID()}`,
          mime: 'image/jpeg',
          declaredSize: 100n,
          privateOwnerUserId,
        },
      });
    const avatar = await asset('AVATAR'),
      cover = await asset('COVER');
    for (const bad of [
      await asset('MEMORY'),
      await asset('AVATAR', 'PENDING_UPLOAD'),
      await asset('AVATAR', 'READY', otherFamily),
      await asset('JOURNAL', 'READY', familyId, parentB),
    ])
      await api('put', `/children/${childA}/avatar`, {
        assetId: bad.id,
      }).expect(400);
    expect(
      data<{ avatarAssetId: string }>(
        await api('put', `/children/${childA}/avatar`, {
          assetId: avatar.id,
        }).expect(200),
      ).avatarAssetId,
    ).toBe(avatar.id);
    await api('put', `/children/${childA}/cover`, {
      assetId: avatar.id,
    }).expect(400);
    expect(
      data<{ coverAssetId: string }>(
        await api('put', `/children/${childA}/cover`, {
          assetId: cover.id,
        }).expect(200),
      ).coverAssetId,
    ).toBe(cover.id);
    await api('put', `/pregnancies/${pregnancyId}/cover`, {
      assetId: avatar.id,
    }).expect(400);
    expect(
      data<{ coverAssetId: string }>(
        await api('put', `/pregnancies/${pregnancyId}/cover`, {
          assetId: cover.id,
        }).expect(200),
      ).coverAssetId,
    ).toBe(cover.id);
    await api(
      'put',
      `/children/${childA}/avatar`,
      { assetId: avatar.id },
      circle,
    ).expect(404);
    for (const path of [
      `/children/${childA}/avatar`,
      `/children/${childA}/cover`,
      `/pregnancies/${pregnancyId}/cover`,
    ]) {
      await api('put', path, {}).expect(400);
      await api('put', path, { assetId: null }).expect(200);
    }
  });
  it('counts only visible memories, milestones and ready photos for each caller', async () => {
    const shared = await memory('FAMILY', [childA]);
    const parents = await memory('PARENTS', [childA]);
    await memory('PRIVATE', [childA]);
    await memory('PRIVATE', [childA], { authorUserId: parentB });
    await memory('FAMILY', [childA], {
      status: 'DRAFT',
      authorUserId: parentB,
    });
    await memory('FAMILY', [childA], {
      kind: 'LETTER',
      unlockAt: new Date(Date.now() + 86400000),
      authorUserId: parentB,
    });
    for (const m of [shared, parents]) {
      await prisma.milestone.create({
        data: {
          familyId,
          childId: childA,
          memoryId: m.id,
          customTitle: 'Synthetic first',
          occurredOn: new Date('2026-01-02'),
          createdBy: parent,
        },
      });
      const a = await prisma.asset.create({
        data: {
          familyId,
          uploaderUserId: parent,
          kind: 'IMAGE',
          status: 'READY',
          storageKey: `synthetic/${randomUUID()}`,
          mime: 'image/jpeg',
          declaredSize: 100n,
        },
      });
      await prisma.memoryAsset.create({
        data: { familyId, memoryId: m.id, assetId: a.id, sortOrder: 0 },
      });
    }
    expect(
      data(
        await api(
          'get',
          `/children/${childA}/profile-stats`,
          undefined,
          circle,
        ).expect(200),
      ),
    ).toEqual({
      memoryCount: 1,
      milestoneCount: 1,
      photoCount: 1,
      firstMemoryAt: '2026-01-02T00:00:00.000Z',
    });
    expect(
      data(await api('get', `/children/${childA}/profile-stats`).expect(200)),
    ).toEqual({
      memoryCount: 3,
      milestoneCount: 2,
      photoCount: 2,
      firstMemoryAt: '2026-01-02T00:00:00.000Z',
    });
    await api(
      'get',
      `/children/${childB}/profile-stats`,
      undefined,
      circle,
    ).expect(404);
    await api(
      'get',
      `/children/${childA}/profile-stats`,
      undefined,
      outsider,
    ).expect(404);
  });
  it('keeps ended-private pregnancy content away from Circle and restores without widening privacy', async () => {
    const shared = await memory('FAMILY', [], { pregnancyId });
    const privateMemory = await memory('PRIVATE', [], { pregnancyId });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: memberId,
        pregnancyId,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
    await api(
      'post',
      `/pregnancies/${pregnancyId}/archive`,
      { reason: 'ENDED_PRIVATE' },
      circle,
    ).expect(404);
    await api('post', `/pregnancies/${pregnancyId}/archive`, {
      reason: 'UNKNOWN',
    }).expect(400);
    expect(
      data<{ status: string }>(
        await api('post', `/pregnancies/${pregnancyId}/archive`, {
          reason: 'ENDED_PRIVATE',
        }).expect(200),
      ).status,
    ).toBe('ENDED_PRIVATE');
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: shared.id } }))
        .visibility,
    ).toBe('PARENTS');
    expect(
      (
        await prisma.memory.findUniqueOrThrow({
          where: { id: privateMemory.id },
        })
      ).visibility,
    ).toBe('PRIVATE');
    await api(
      'get',
      `/families/${familyId}/pregnancies/${pregnancyId}`,
      undefined,
      circle,
    ).expect(404);
    await api('get', `/memories/${shared.id}`, undefined, circle).expect(404);
    await api(
      'get',
      `/families/${familyId}/feed?pregnancyId=${pregnancyId}`,
      undefined,
      circle,
    ).expect(404);
    expect(
      (await prisma.circleGrant.findFirstOrThrow({ where: { pregnancyId } }))
        .status,
    ).toBe('REVOKED');
    expect(
      data<{ id: string }[]>(
        await api('get', `/families/${familyId}/pregnancies/archived`).expect(
          200,
        ),
      ).map((p) => p.id),
    ).toContain(pregnancyId);
    await api(
      'get',
      `/families/${familyId}/pregnancies/archived`,
      undefined,
      circle,
    ).expect(404);
    expect(
      (
        await prisma.outboxEvent.findFirstOrThrow({
          where: { familyId, eventType: 'pregnancy.status_changed' },
        })
      ).payload,
    ).toEqual({ pregnancyId });
    expect(
      data<{ status: string }>(
        await api('post', `/pregnancies/${pregnancyId}/restore`).expect(200),
      ).status,
    ).toBe('ACTIVE');
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: shared.id } }))
        .visibility,
    ).toBe('PARENTS');
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
  });
  it('archives/restores, requires exact confirmName and seven days, soft-deletes with retained shared memories', async () => {
    const shared = await memory('FAMILY', [childA, childB]);
    const exclusive = await memory('PARENTS', [childB]);
    await api('post', `/children/${childB}/archive`).expect(201);
    await api('post', `/children/${childB}/restore`).expect(201);
    await api('delete', `/children/${childB}`, { confirmName: 'wrong' }).expect(
      400,
    );
    await api('delete', `/children/${childB}`, {
      confirmName: 'Synthetic child 1',
    }).expect(409);
    await api('post', `/children/${childB}/archive`).expect(201);
    await api('delete', `/children/${childB}`, {
      confirmName: 'Synthetic child 1',
    }).expect(409);
    await prisma.child.update({
      where: { id: childB },
      data: { archivedAt: new Date(Date.now() - 8 * 86400000) },
    });
    await prisma.familyUsage.upsert({
      where: { familyId },
      create: { familyId, memoryCount: 20 },
      update: { memoryCount: 20 },
    });
    await api(
      'delete',
      `/children/${childB}`,
      { confirmName: 'Synthetic child 1' },
      parentB,
    ).expect(200);
    expect(
      (await prisma.familyUsage.findUniqueOrThrow({ where: { familyId } }))
        .memoryCount,
    ).toBe(19);
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: exclusive.id } }))
        .trashedBy,
    ).toBe(parentB);
    const child = await prisma.child.findUniqueOrThrow({
      where: { id: childB },
    });
    expect(child.status).toBe('DELETED');
    expect(child.deletedAt).not.toBeNull();
    expect(child.purgeAfter).not.toBeNull();
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: shared.id } }))
        .status,
    ).toBe('PUBLISHED');
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: exclusive.id } }))
        .status,
    ).toBe('TRASHED');
    await api('post', `/children/${childB}/restore`).expect(404);
    await api('post', `/children/${childA}/archive`).expect(201);
    await api(
      'get',
      `/children/${childA}/profile-stats`,
      undefined,
      circle,
    ).expect(404);
    await api('post', `/children/${childA}/restore`).expect(201);
  });
});
