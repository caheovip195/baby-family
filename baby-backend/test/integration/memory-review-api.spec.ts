import { MemoryController } from '../../src/controllers/memory.controller';
import { MemoryReviewController } from '../../src/controllers/memory-review.controller';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MemoryReviewService } from '../../src/services/memory-review.service';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MemoryReviewRepository } from '../../src/repositories/memory-review.repository';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MEMORY_REVIEW_SERVICE } from '../../src/interfaces/services/memory-review-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MEMORY_REVIEW_REPOSITORY } from '../../src/interfaces/repositories/memory-review-repository.interface';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
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

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Memory review API (focused module + PostgreSQL)', () => {
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
    ungrantedChildId = randomUUID();

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
      controllers: [MemoryController, MemoryReviewController],
      providers: [
        PrismaService,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: MEMORY_REVIEW_SERVICE, useClass: MemoryReviewService },
        { provide: MEMORY_REVIEW_REPOSITORY, useClass: MemoryReviewRepository },
        {
          provide: MEDIA_SERVICE,
          useValue: {
            signViewUrls: () =>
              Promise.resolve({ items: [], unavailableIds: [] }),
          },
        },
        AccessTokenGuard,
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
        quotas: { photosPerMemory: 10 },
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
    for (const id of [childId, ungrantedChildId])
      await prisma.child.create({
        data: {
          id,
          familyId,
          name: 'Synthetic child',
          colorIndex: 1,
          createdBy: parent,
          birthDate: new Date('2025-01-01'),
        },
      });
    for (const userId of [circle, outsider]) {
      const member =
        userId === circle
          ? await prisma.circleMember.findFirstOrThrow({
              where: { familyId, userId },
            })
          : await prisma.circleMember.create({
              data: {
                familyId,
                userId,
                relation: 'OTHER',
                displayName: 'Synthetic relative',
              },
            });
      await prisma.circleGrant.create({
        data: {
          familyId,
          circleMemberId: member.id,
          childId,
          permission: 'CONTRIBUTE',
          createdBy: parent,
        },
      });
    }
  });
  afterAll(async () => {
    await app?.close();
  });

  const call = (
    method: 'get' | 'post',
    route: string,
    who = parent,
    input?: object,
  ) => {
    const server = request(app.getHttpServer());
    const req = server[method]('/api/v1' + route).set(
      'Authorization',
      tokens.get(who)!,
    );
    return input ? req.send(input) : req;
  };
  const create = (input: object = {}, who = circle, key = randomUUID()) =>
    request(app.getHttpServer())
      .post('/api/v1/memories')
      .set('Authorization', tokens.get(who)!)
      .set('Idempotency-Key', key)
      .send({
        familyId,
        kind: 'MOMENT',
        body: 'Synthetic Circle moment',
        occurredAt: '2026-10-01T00:00:00Z',
        visibility: 'FAMILY',
        childIds: [childId],
        ...input,
      });
  const feed = (who = outsider) =>
    call('get', '/families/' + familyId + '/feed', who);
  const pending = () =>
    call('get', '/families/' + familyId + '/memories/pending-review');
  const idOf = (r: { body: unknown }) => data<{ id: string }>(r).id;
  it('Circle post stays pending, author/Parents can read, other relatives cannot see it until approved', async () => {
    const key = randomUUID();
    const response = await create({}, circle, key).expect(201);
    const id = idOf(response);
    expect(data(response)).toMatchObject({
      status: 'PENDING_REVIEW',
      authorRole: 'CIRCLE',
      visibility: 'FAMILY',
      publishedAt: null,
    });
    expect(idOf(await create({}, circle, key).expect(201))).toBe(id);
    const submitted = await prisma.outboxEvent.findMany({
      where: {
        familyId,
        aggregateId: id,
        eventType: 'memory.review_requested',
      },
    });
    expect(submitted).toHaveLength(1);
    expect(submitted[0]!.payload).toMatchObject({
      memoryId: id,
      familyId,
      authorUserId: circle,
      status: 'PENDING_REVIEW',
    });

    await call('get', '/memories/' + id, circle).expect(200);
    await call('get', '/memories/' + id, parent).expect(200);
    await call('get', '/memories/' + id, outsider).expect(404);
    expect(
      data<{ id: string }[]>(await feed().expect(200)).map((x) => x.id),
    ).not.toContain(id);
    expect(
      data<{ id: string }[]>(await pending().expect(200)).map((x) => x.id),
    ).toContain(id);
    for (const who of [circle, outsider])
      await call('post', '/memories/' + id + '/approve', who, {}).expect(403);
    await call('post', '/memories/' + id + '/approve', parent, {
      childIds: [ungrantedChildId],
    }).expect(200);
    await call('get', '/memories/' + id, circle).expect(404);
    // Parent may add a child outside the original contributor grant.
    const row = await prisma.memory.findUniqueOrThrow({ where: { id } });
    expect(row.status).toBe('PUBLISHED');
    expect(row.reviewedBy).toBe(parent);
    const approved = await prisma.outboxEvent.findFirstOrThrow({
      where: { familyId, aggregateId: id, eventType: 'memory.approved' },
    });
    expect(approved.payload).toMatchObject({
      memoryId: id,
      familyId,
      authorUserId: circle,
      recipientUserId: circle,
      reviewedBy: parent,
      status: 'PUBLISHED',
    });

    await call('post', '/memories/' + id + '/approve', parent, {}).expect(200);
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, aggregateId: id, eventType: 'memory.approved' },
      }),
    ).toBe(1);
  });
  it('approval publishes to other granted relatives/feed exactly once under concurrent retries', async () => {
    const id = idOf(await create().expect(201));
    const results = await Promise.all([
      call('post', '/memories/' + id + '/approve', parent, {}),
      call('post', '/memories/' + id + '/approve', parentB, {}),
    ]);
    expect(results.map((r) => r.status)).toEqual([200, 200]);
    await call('get', '/memories/' + id, outsider).expect(200);
    expect(
      data<{ id: string }[]>(await feed().expect(200)).map((x) => x.id),
    ).toContain(id);
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, aggregateId: id, eventType: 'memory.published' },
      }),
    ).toBe(1);
  });
  it('reject is Parent-only, REJECTED remains author-only and notifies via one transactional outbox event', async () => {
    const id = idOf(await create().expect(201));
    await call('post', '/memories/' + id + '/reject', circle, {
      reason: 'Synthetic reason',
    }).expect(403);
    await call('post', '/memories/' + id + '/reject', parent, {
      reason: 'Synthetic reason',
    }).expect(200);
    await call('post', '/memories/' + id + '/reject', parent, {
      reason: 'Retry',
    }).expect(200);
    await call('get', '/memories/' + id, outsider).expect(404);
    expect(
      data(await call('get', '/memories/' + id, circle).expect(200)),
    ).toMatchObject({ status: 'REJECTED' });
    const events = await prisma.outboxEvent.findMany({
      where: { familyId, aggregateId: id, eventType: 'memory.rejected' },
    });
    expect(events).toHaveLength(1);
    expect(events[0]?.payload).toMatchObject({
      memoryId: id,
      familyId,
      authorUserId: circle,
      recipientUserId: circle,
      reviewedBy: parent,
      status: 'REJECTED',
      reason: 'Synthetic reason',
    });
  });
  it('rejects private/parents posts, other kinds, drafts, ungranted children and VIEW-only grants', async () => {
    for (const input of [
      { visibility: 'PRIVATE' },
      { visibility: 'PARENTS' },
      { kind: 'DIARY' },
      { status: 'DRAFT' },
      { familyMoment: true, childIds: [] },
    ])
      await create(input).expect(422);
    await create({ childIds: [ungrantedChildId] }).expect(403);
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { permission: 'VIEW' },
    });
    await create().expect(403);
    await prisma.circleGrant.updateMany({
      where: { familyId, childId },
      data: { permission: 'CONTRIBUTE' },
    });
  });

  it('keeps Circle photo pending until Parent review and does not publish unready assets', async () => {
    const asset = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: circle,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        status: 'PROCESSING',
        storageKey: 'synthetic/review/' + randomUUID(),
        mime: 'image/jpeg',
        declaredSize: 10n,
      },
    });
    const id = idOf(await create({ assetIds: [asset.id] }).expect(201));
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, aggregateId: id, eventType: 'memory.published' },
      }),
    ).toBe(0);
    expect(
      data(
        await call('post', '/memories/' + id + '/approve', parent, {}).expect(
          200,
        ),
      ),
    ).toMatchObject({ status: 'PROCESSING', publishedAt: null });
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, aggregateId: id, eventType: 'memory.published' },
      }),
    ).toBe(0);
    const ready = await prisma.asset.create({
      data: {
        familyId,
        uploaderUserId: circle,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        status: 'READY',
        storageKey: 'synthetic/review/' + randomUUID(),
        mime: 'image/jpeg',
        declaredSize: 10n,
      },
    });
    const readyId = idOf(await create({ assetIds: [ready.id] }).expect(201));
    expect(
      data(
        await call(
          'post',
          '/memories/' + readyId + '/approve',
          parent,
          {},
        ).expect(200),
      ),
    ).toMatchObject({ status: 'PUBLISHED' });
  });

  it('restoring a pending Circle post keeps it pending until explicit review', async () => {
    const id = idOf(await create().expect(201));
    await request(app.getHttpServer())
      .delete('/api/v1/memories/' + id)
      .set('Authorization', tokens.get(parent)!)
      .expect(204);
    expect(
      data(
        await call('post', '/memories/' + id + '/restore', parent, {}).expect(
          200,
        ),
      ),
    ).toMatchObject({ status: 'PENDING_REVIEW', publishedAt: null });
    await call('get', '/memories/' + id, outsider).expect(404);
    await call('post', '/memories/' + id + '/approve', parent, {}).expect(200);
  });
  it('requires granted pregnancy and honors review disabled', async () => {
    const pregnancy = await prisma.pregnancy.create({
      data: {
        familyId,
        nickname: 'Synthetic pregnancy',
        seqNo: 1,
        createdBy: parent,
        dueDate: new Date('2027-01-01'),
      },
    });
    await create({ childIds: [], pregnancyId: pregnancy.id }).expect(403);
    const member = await prisma.circleMember.findFirstOrThrow({
      where: { familyId, userId: circle },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        pregnancyId: pregnancy.id,
        permission: 'CONTRIBUTE',
        createdBy: parent,
      },
    });
    expect(
      data(
        await create({ childIds: [], pregnancyId: pregnancy.id }).expect(201),
      ),
    ).toMatchObject({ status: 'PENDING_REVIEW' });
    await prisma.family.update({
      where: { id: familyId },
      data: { settings: { requireCircleReview: false } },
    });
    expect(data(await create().expect(201))).toMatchObject({
      status: 'PUBLISHED',
    });
    await prisma.family.update({
      where: { id: familyId },
      data: { settings: { requireCircleReview: true } },
    });
  });
});
