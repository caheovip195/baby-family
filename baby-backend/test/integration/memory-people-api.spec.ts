import type { Server } from 'node:http';
import { randomUUID } from 'node:crypto';
import { ValidationPipe } from '@nestjs/common';
import type { ExecutionContext, INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpAdapterHost, Reflector } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import type { PinoLogger } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { AUTH_PRINCIPAL } from '../../src/common/auth/auth-principal';
import type { AuthenticatedRequest } from '../../src/common/auth/current-actor.decorator';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { MemoryController } from '../../src/controllers/memory.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MemoryContentService } from '../../src/services/memory-content.service';

interface Person {
  memberId: string | null;
  userId: string | null;
  displayName: string;
}
interface MemoryResponse {
  id: string;
  version: number;
  people: Person[];
  feeling: string | null;
  locationLabel: string | null;
}
interface Envelope<T> {
  data: T;
  error?: { code: string };
}

// Own Nest composition root; bypass JWT only, retaining real family ACL and persistence.
describe('Memory people/location/feeling (PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    otherFamily = randomUUID(),
    parentA = randomUUID(),
    parentB = randomUUID(),
    outsider = randomUUID(),
    circle = randomUUID();
  const childId = randomUUID(),
    memberId = randomUUID(),
    planId = randomUUID(),
    versionId = randomUUID(),
    licenseId = randomUUID();
  let created: MemoryResponse;
  const get = (path: string, actor = parentA) =>
    request(app.getHttpServer()).get(path).set('x-test-actor', actor);
  const create = (body: Record<string, unknown>, key = randomUUID()) =>
    request(app.getHttpServer())
      .post('/memories')
      .set('x-test-actor', parentA)
      .set('Idempotency-Key', key)
      .send({
        familyId,
        kind: 'MOMENT',
        body: 'Synthetic fixture',
        childIds: [childId],
        visibility: 'FAMILY',
        occurredAt: '2026-10-01T01:00:00Z',
        ...body,
      });
  const patch = (
    body: Record<string, unknown>,
    actor = parentA,
    version = created.version,
  ) =>
    request(app.getHttpServer())
      .patch(`/memories/${created.id}`)
      .set('x-test-actor', actor)
      .set('If-Match', String(version))
      .send(body);

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test.');
    const module = await Test.createTestingModule({
      controllers: [MemoryController],
      providers: [
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 3,
          }),
        },
        PrismaService,
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        { provide: MEDIA_SERVICE, useValue: {} },
      ],
    })
      .overrideGuard(AccessTokenGuard)
      .useValue({
        canActivate(context: ExecutionContext) {
          const req = context.switchToHttp().getRequest<AuthenticatedRequest>();
          req[AUTH_PRINCIPAL] = {
            userId: req.headers['x-test-actor'] as string,
            sessionId: randomUUID(),
            tokenVersion: 1,
          };
          return true;
        },
      })
      .compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );
    app.useGlobalFilters(
      new HttpExceptionFilter(app.get(HttpAdapterHost), {
        error() {},
        warn() {},
      } as unknown as PinoLogger),
    );
    app.useGlobalInterceptors(
      new ResponseEnvelopeInterceptor(app.get(Reflector)),
    );
    await app.init();
    prisma = app.get(PrismaService);
    await prisma.user.createMany({
      data: [parentA, parentB, outsider, circle].map((id) => ({
        id,
        displayName: 'Synthetic',
      })),
    });
    await prisma.family.createMany({
      data: [familyId, otherFamily].map((id) => ({
        id,
        name: 'Synthetic people family',
        createdBy: parentA,
        activatedAt: new Date(),
        status: 'ACTIVE',
      })),
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parentA,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: parentB,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
        {
          familyId: otherFamily,
          userId: outsider,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Foreign parent',
        },
      ],
    });
    await prisma.circleMember.create({
      data: {
        id: memberId,
        familyId,
        userId: circle,
        displayName: 'Grandma',
        relation: 'GRANDMOTHER_PATERNAL',
      },
    });
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        nickname: 'Synthetic child',
        birthDate: new Date('2025-01-01'),
        colorIndex: 1,
        createdBy: parentA,
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `PEOPLE_${planId.slice(0, 16)}`,
        displayNameI18n: { en: 'Synthetic' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: versionId,
        planId,
        version: 1,
        quotas: { photosPerMemory: 10 },
        features: { 'circle.enabled': true },
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
        validUntil: new Date(Date.now() + 86400000),
      },
    });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.outboxEvent.deleteMany({ where: { familyId } });
        await prisma.idempotencyRecord.deleteMany({ where: { familyId } });
        await prisma.memoryPerson.deleteMany({ where: { familyId } });
        await prisma.memoryChild.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.child.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({
          where: { familyId: { in: [familyId, otherFamily] } },
        });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: licenseId },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: { in: [familyId, otherFamily] } },
          data: { deletedAt: new Date() },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
        await prisma.user.updateMany({
          where: { id: { in: [parentA, parentB, outsider, circle] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('creates ordered people atomically and replays the same request', async () => {
    const key = randomUUID();
    const input = {
      people: [
        { userId: parentB },
        { memberId },
        { displayName: '  Synthetic guest  ' },
      ],
      feeling: 'JOY',
      locationLabel: 'Synthetic park',
    };
    const response = await create(input, key).expect(201);
    created = (response.body as Envelope<MemoryResponse>).data;
    expect(created).toMatchObject({
      feeling: 'JOY',
      locationLabel: 'Synthetic park',
      people: [
        { userId: parentB, displayName: 'Mama' },
        { memberId, userId: circle, displayName: 'Grandma' },
        { memberId: null, userId: null, displayName: 'Synthetic guest' },
      ],
    });
    expect((await create(input, key).expect(201)).body).toEqual(response.body);
    expect(
      await prisma.memoryPerson.count({ where: { familyId, deletedAt: null } }),
    ).toBe(3);
  });

  it.each([
    [{ userId: outsider }],
    [{ memberId: randomUUID() }],
    [{ userId: parentB, memberId }],
    [{}],
    [{ displayName: '  ' }],
    [{ userId: parentB }, { userId: parentB }],
  ])(
    'rejects invalid/foreign/duplicate people with full rollback: %j',
    async (...people) => {
      const before = await prisma.memory.count({ where: { familyId } });
      const response = await create({ people }).expect(422);
      expect((response.body as Envelope<unknown>).error?.code).toBe(
        'MEMORY_PEOPLE_INVALID',
      );
      expect(await prisma.memory.count({ where: { familyId } })).toBe(before);
    },
  );

  it('rejects unknown fields, null people and overlong names', async () => {
    await create({ people: null }).expect(400);
    await create({ people: [{ displayName: 'a'.repeat(41) }] }).expect(400);
    await create({
      people: [{ displayName: 'Name', email: 'hidden@example.test' }],
    }).expect(400);
  });

  it('returns people/location/feeling in detail, feed and timeline', async () => {
    const detail = (await get(`/memories/${created.id}`, parentB).expect(200))
      .body as Envelope<MemoryResponse>;
    expect(detail.data.people).toEqual(created.people);
    const feed = (await get(`/families/${familyId}/feed`).expect(200)).body as {
      data: MemoryResponse[];
    };
    expect(feed.data.find((m) => m.id === created.id)).toMatchObject({
      people: created.people,
      feeling: 'JOY',
      locationLabel: 'Synthetic park',
    });
    const timeline = await get(`/families/${familyId}/timeline`).expect(200);
    expect(JSON.stringify(timeline.body)).toContain('Synthetic park');
    expect(JSON.stringify(timeline.body)).toContain('Synthetic guest');
  });

  it('suggests current members and names from readable memories only', async () => {
    await create({
      visibility: 'PRIVATE',
      people: [{ displayName: 'Secret private guest' }],
    }).expect(201);
    const result = (
      await get(`/families/${familyId}/people-suggestions`, parentB).expect(200)
    ).body as Envelope<{ items: Person[] }>;
    expect(result.data.items).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ memberId, userId: circle }),
        { memberId: null, userId: null, displayName: 'Synthetic guest' },
      ]),
    );
    expect(JSON.stringify(result)).not.toContain('Secret private guest');
    await get(`/families/${familyId}/people-suggestions`, outsider).expect(404);
    await get(`/families/${familyId}/people-suggestions`, circle).expect(404);
  });

  it('allows only author to replace people; patches are versioned and soft-delete old links', async () => {
    await patch({ people: [] }, parentB).expect(403);
    const response = await patch({
      people: [{ displayName: 'New guest' }],
      feeling: null,
      locationLabel: null,
    }).expect(200);
    created = (response.body as Envelope<MemoryResponse>).data;
    expect(created.people).toEqual([
      { memberId: null, userId: null, displayName: 'New guest' },
    ]);
    expect(created).toMatchObject({ feeling: null, locationLabel: null });
    expect(
      await prisma.memoryPerson.count({
        where: { familyId, memoryId: created.id, deletedAt: { not: null } },
      }),
    ).toBe(3);
    await patch({ people: [] }, parentA, created.version - 1).expect(412);
    const kept = await patch({ locationLabel: 'Elsewhere' }).expect(200);
    created = (kept.body as Envelope<MemoryResponse>).data;
    expect(created.people[0]?.displayName).toBe('New guest');
  });

  it('anonymizes former members and clears people explicitly', async () => {
    created = (
      (await patch({ people: [{ memberId }] }).expect(200))
        .body as Envelope<MemoryResponse>
    ).data;
    await prisma.circleMember.update({
      where: { id: memberId },
      data: { status: 'LEFT', endedAt: new Date() },
    });
    const result = (await get(`/memories/${created.id}`).expect(200))
      .body as Envelope<MemoryResponse>;
    expect(result.data.people).toEqual([
      { memberId: null, userId: null, displayName: 'Người dùng đã rời' },
    ]);
    await patch({ people: [{ memberId }] }).expect(422);
    const cleared = (await patch({ people: [] }).expect(200))
      .body as Envelope<MemoryResponse>;
    expect(cleared.data.people).toEqual([]);
  });
});
