import { randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe, type INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { Reflector, HttpAdapterHost } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import type { PinoLogger } from 'nestjs-pino';
import request from 'supertest';
import { OfflineSyncController } from '../../src/controllers/offline-sync.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import {
  OFFLINE_SYNC_SERVICE,
  type ChangesResponse,
} from '../../src/interfaces/services/offline-sync-service.interface';
import { OFFLINE_SYNC_REPOSITORY } from '../../src/interfaces/repositories/offline-sync-repository.interface';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { OfflineSyncService } from '../../src/services/offline-sync.service';
import { OfflineSyncRepository } from '../../src/repositories/offline-sync.repository';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';

/** Fixtures and all mutations are scoped exclusively to this spec's family. */
describe('Offline changes (isolated Nest module + baby_family_test)', () => {
  let app: INestApplication<Server>, db: PrismaService;
  const familyId = randomUUID(),
    parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const childId = randomUUID(),
    otherChild = randomUUID(),
    memory = randomUUID(),
    hidden = randomUUID(),
    privateId = randomUUID(),
    sealed = randomUUID(),
    pending = randomUUID(),
    draft = randomUUID();
  let planId: string, versionId: string, grantId: string, memberId: string;
  let emptyCircleCursor: string;
  const get = (user = parent, cursor?: string, limit = 100) =>
    request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/changes`)
      .set('Authorization', `Bearer ${user}`)
      .query({ limit, ...(cursor ? { cursor } : {}) });
  const body = (response: { body: unknown }) =>
    response.body as ChangesResponse;
  const makeMemory = (id: string, input: object = {}) =>
    db.memory.create({
      data: {
        id,
        familyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'MOMENT',
        status: 'PUBLISHED',
        visibility: 'FAMILY',
        body: 'Synthetic sync',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        ...input,
      },
    });
  beforeAll(async () => {
    if (new URL(process.env.DATABASE_URL!).pathname !== '/baby_family_test')
      throw new Error('Requires baby_family_test');
    const module = await Test.createTestingModule({
      controllers: [OfflineSyncController],
      providers: [
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 4,
          }),
        },
        PrismaService,
        { provide: OFFLINE_SYNC_SERVICE, useClass: OfflineSyncService },
        { provide: OFFLINE_SYNC_REPOSITORY, useClass: OfflineSyncRepository },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        {
          provide: AUTHENTICATION_SERVICE,
          useValue: {
            verifyAccessToken: (userId: string) =>
              Promise.resolve({
                userId,
                sessionId: randomUUID(),
                tokenVersion: 1,
              }),
          },
        },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.useGlobalInterceptors(
      new ResponseEnvelopeInterceptor(app.get(Reflector)),
    );
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );
    app.useGlobalFilters(
      new HttpExceptionFilter(app.get(HttpAdapterHost), {
        error: () => undefined,
      } as unknown as PinoLogger),
    );
    await app.init();
    db = app.get(PrismaService);
    for (const id of [parent, partner, circle, outsider])
      await db.user.create({
        data: { id, displayName: 'Synthetic sync', status: 'ACTIVE' },
      });
    await db.family.create({
      data: {
        id: familyId,
        name: 'Synthetic offline family',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date(),
      },
    });
    await db.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parent,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: partner,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    for (const id of [childId, otherChild])
      await db.child.create({
        data: {
          id,
          familyId,
          nickname: 'Synthetic',
          birthDate: new Date('2026-01-01'),
          colorIndex: 1,
          createdBy: parent,
        },
      });
    const member = await db.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic',
      },
    });
    memberId = member.id;
    const grant = await db.circleGrant.create({
      data: {
        familyId,
        circleMemberId: memberId,
        childId,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
    grantId = grant.id;
    const plan = await db.plan.create({
      data: {
        code: `SYNC_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic' },
      },
    });
    planId = plan.id;
    const version = await db.planVersion.create({
      data: {
        planId,
        version: 1,
        quotas: {},
        features: { 'circle.enabled': true },
        availableFrom: new Date(),
      },
    });
    versionId = version.id;
    const license = await db.familyLicense.create({ data: { familyId } });
    await db.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: versionId,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    await makeMemory(memory);
    await makeMemory(hidden);
    await makeMemory(privateId, { visibility: 'PRIVATE' });
    await makeMemory(sealed, {
      kind: 'LETTER',
      unlockAt: new Date(Date.now() + 86400000),
    });
    await makeMemory(pending, { status: 'PENDING_REVIEW' });
    await makeMemory(draft, { status: 'DRAFT' });
    await db.memoryChild.createMany({
      data: [
        { familyId, memoryId: memory, childId, ageMonth: 1 },
        { familyId, memoryId: hidden, childId: otherChild, ageMonth: 1 },
        { familyId, memoryId: sealed, childId, ageMonth: 1 },
        { familyId, memoryId: pending, childId, ageMonth: 1 },
      ],
    });
  });
  afterAll(async () => {
    if (db) {
      await db.$executeRaw`DELETE FROM app.offline_memory_changes WHERE family_id=${familyId}::uuid`;
      await db.reaction.deleteMany({ where: { familyId } });
      await db.comment.deleteMany({ where: { familyId } });
      await db.memoryChild.deleteMany({ where: { familyId } });
      await db.memory.deleteMany({ where: { familyId } });
      await db.circleGrant.deleteMany({ where: { familyId } });
      await db.circleMember.deleteMany({ where: { familyId } });
      await db.child.deleteMany({ where: { familyId } });
      await db.familyEntitlement.deleteMany({ where: { familyId } });
      await db.familyLicense.updateMany({
        where: { familyId },
        data: { deletedAt: new Date() },
      });
      await db.familyParent.deleteMany({ where: { familyId } });
      await db.family.updateMany({
        where: { id: familyId },
        data: { deletedAt: new Date() },
      });
      if (versionId)
        await db.planVersion.deleteMany({ where: { id: versionId } });
      if (planId) await db.plan.deleteMany({ where: { id: planId } });
      await db.user.updateMany({
        where: { id: { in: [parent, partner, circle, outsider] } },
        data: { deletedAt: new Date(), status: 'DELETED' },
      });
    }
    await app?.close();
  });
  it('empty initial cursor remains usable on the next poll and after new visibility', async () => {
    await db.circleGrant.update({
      where: { id: grantId },
      data: { status: 'PAUSED' },
    });
    const first = body(await get(circle).expect(200));
    expect(first.items).toEqual([]);
    emptyCircleCursor = first.nextCursor;
    expect(
      body(await get(circle, emptyCircleCursor).expect(200)).items,
    ).toEqual([]);
    await db.circleGrant.update({
      where: { id: grantId },
      data: { status: 'ACTIVE' },
    });
  });
  it('stable cursor across timestamp ties; no missing or repeated receipts, limit validation and empty continuation', async () => {
    let cursor: string | undefined;
    const items: ChangesResponse['items'] = [];
    for (let i = 0; i < 20; i++) {
      const page = body(await get(parent, cursor, 1).expect(200));
      items.push(...page.items);
      cursor = page.nextCursor;
      if (!page.hasMore) break;
    }
    expect(items.map((i) => i.id).sort()).toEqual(
      [memory, hidden, privateId, sealed, pending].sort(),
    );
    expect(new Set(items.map((i) => i.id)).size).toBe(items.length);
    expect(body(await get(parent, cursor).expect(200)).items).toEqual([]);
    await get(parent, undefined, 0).expect(400);
    await get(parent, undefined, 201).expect(400);
    await get(parent, 'bad-cursor').expect(400);
    await get(circle, cursor).expect(400);
  });
  it('changes after create/update/delete/restore for memory, comment and reaction; metadata-only memories', async () => {
    let cursor = body(await get().expect(200)).nextCursor;
    await db.memory.update({
      where: { id: memory },
      data: { body: 'Synthetic edit', version: { increment: 1 } },
    });
    const comment = await db.comment.create({
      data: {
        familyId,
        memoryId: memory,
        authorUserId: parent,
        body: 'Synthetic comment',
      },
    });
    await db.reaction.create({
      data: { familyId, memoryId: memory, userId: parent, type: 'LOVE' },
    });
    let page = body(await get(parent, cursor).expect(200));
    cursor = page.nextCursor;
    expect(page.items).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          entity: 'memory',
          id: memory,
          op: 'upsert',
          version: 2,
          data: { id: memory, version: 2 },
        }),
        expect.objectContaining({
          entity: 'memoryComment',
          id: comment.id,
          op: 'upsert',
        }),
        expect.objectContaining({
          entity: 'memoryReaction',
          id: `${memory}:${parent}`,
          op: 'upsert',
        }),
      ]),
    );
    await db.comment.update({
      where: { id: comment.id },
      data: { body: 'Edited', editedAt: new Date() },
    });
    await db.reaction.update({
      where: { memoryId_userId: { memoryId: memory, userId: parent } },
      data: { type: 'CLAP' },
    });
    page = body(await get(parent, cursor).expect(200));
    cursor = page.nextCursor;
    expect(page.items).toHaveLength(2);
    await db.comment.update({
      where: { id: comment.id },
      data: { deletedAt: new Date(), status: 'DELETED' },
    });
    await db.reaction.update({
      where: { memoryId_userId: { memoryId: memory, userId: parent } },
      data: { deletedAt: new Date() },
    });
    page = body(await get(parent, cursor).expect(200));
    cursor = page.nextCursor;
    expect(page.items).toHaveLength(2);
    expect(page.items.every((i) => i.op === 'delete' && !('data' in i))).toBe(
      true,
    );
    await db.comment.update({
      where: { id: comment.id },
      data: { deletedAt: null, status: 'ACTIVE' },
    });
    await db.reaction.update({
      where: { memoryId_userId: { memoryId: memory, userId: parent } },
      data: { deletedAt: null },
    });
    page = body(await get(parent, cursor).expect(200));
    cursor = page.nextCursor;
    expect(page.items).toHaveLength(2);
    expect(page.items.every((i) => i.op === 'upsert')).toBe(true);
    await db.memory.update({
      where: { id: memory },
      data: {
        status: 'TRASHED',
        deletedAt: new Date(),
        trashedAt: new Date(),
        purgeAfter: new Date(Date.now() + 86400000),
        version: { increment: 1 },
      },
    });
    page = body(await get(parent, cursor).expect(200));
    cursor = page.nextCursor;
    expect(page.items).toHaveLength(3);
    expect(page.items.every((i) => i.op === 'delete' && !('data' in i))).toBe(
      true,
    );
    await db.memory.update({
      where: { id: memory },
      data: {
        status: 'PUBLISHED',
        deletedAt: null,
        trashedAt: null,
        purgeAfter: null,
        version: { increment: 1 },
      },
    });
    page = body(await get(parent, cursor).expect(200));
    expect(page.items).toHaveLength(3);
    expect(page.items.every((i) => i.op === 'upsert')).toBe(true);
  });
  it('Circle grants, PRIVATE owner, sealed letters, pending review, revoked grants tombstones, outsiders/revoked members 404', async () => {
    const oldMemory = randomUUID();
    await makeMemory(oldMemory, {
      updatedAt: new Date('2020-01-01T00:00:00Z'),
    });
    await db.memoryChild.create({
      data: { familyId, memoryId: oldMemory, childId, ageMonth: 1 },
    });
    const page = body(await get(circle, emptyCircleCursor).expect(200));
    expect(
      page.items
        .filter((i) => i.entity === 'memory')
        .map((i) => i.id)
        .sort(),
    ).toEqual([memory, oldMemory].sort());
    const partnerIds = body(await get(partner).expect(200)).items.map(
      (i) => i.id,
    );
    for (const hiddenId of [privateId, sealed, draft])
      expect(partnerIds).not.toContain(hiddenId);
    const cursor = page.nextCursor;
    await db.circleGrant.update({
      where: { id: grantId },
      data: { deletedAt: new Date(), status: 'REVOKED' },
    });
    const revoked = body(await get(circle, cursor).expect(200));
    expect(revoked.items.length).toBeGreaterThan(0);
    expect(
      revoked.items.every((i) => i.op === 'delete' && !('data' in i)),
    ).toBe(true);
    expect(revoked.items.some((i) => i.id === hidden)).toBe(false);
    expect(revoked.items).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ id: oldMemory, op: 'delete' }),
      ]),
    );
    const backlog = body(await get(circle, emptyCircleCursor).expect(200));
    expect(
      backlog.items.every((i) => i.op === 'delete' && !('data' in i)),
    ).toBe(true);
    await get(outsider).expect(404);
    await db.circleMember.update({
      where: { id: memberId },
      data: { status: 'REMOVED', endedAt: new Date() },
    });
    await get(circle).expect(404);
  });
});
