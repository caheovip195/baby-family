import { randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe, type INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AdminCmsGuard } from '../../src/common/auth/admin-cms.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { AdminCmsOperationsController } from '../../src/controllers/admin-cms-operations.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { ADMIN_CMS_OPERATIONS_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-operations-repository.interface';
import { ADMIN_CMS_OPERATIONS_SERVICE } from '../../src/interfaces/services/admin-cms-operations-service.interface';
import { ADMIN_CMS_AUTH_SERVICE } from '../../src/interfaces/services/admin-cms-auth-service.interface';
import { AdminCmsOperationsRepository } from '../../src/repositories/admin-cms-operations.repository';
import { AdminCmsOperationsService } from '../../src/services/admin-cms-operations.service';
const payload = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const errorCode = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;
describe('Admin CMS moderation (isolated HTTP module, PostgreSQL)', () => {
  let app: INestApplication<Server>, prisma: PrismaService;
  const familyId = randomUUID(),
    userId = randomUUID(),
    adminId = randomUUID(),
    supportId = randomUUID();
  const memoryId = randomUUID(),
    commentId = randomUUID(),
    sealedId = randomUUID();
  const caseIds = [randomUUID(), randomUUID(), randomUUID()];
  const call = (
    method: 'get' | 'post' | 'patch',
    path: string,
    role = 'moderator',
  ) => {
    const client = request(app.getHttpServer());
    return client[method](`/admin/v1${path}`).set(
      'Authorization',
      `Bearer ${role}`,
    );
  };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [AdminCmsOperationsController],
      providers: [
        PrismaService,
        AdminCmsGuard,
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 3,
          }),
        },
        {
          provide: ADMIN_CMS_AUTH_SERVICE,
          useValue: {
            recordDenied: async (actor: { id: string }) => {
              await prisma.adminAuditEvent.create({
                data: {
                  adminId: actor.id,
                  action: 'AUTH_FORBIDDEN',
                  entityType: 'ADMIN_SESSION',
                  reasonCode: 'RBAC',
                  redactedChanges: {},
                },
              });
            },
            authenticate: (token: string) => ({
              id: token === 'support' ? supportId : adminId,
              roles: [token === 'support' ? 'SUPPORT' : 'MODERATOR'],
              sessionId: randomUUID(),
            }),
          },
        },
        {
          provide: ADMIN_CMS_OPERATIONS_REPOSITORY,
          useClass: AdminCmsOperationsRepository,
        },
        {
          provide: ADMIN_CMS_OPERATIONS_SERVICE,
          useClass: AdminCmsOperationsService,
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );
    await app.init();
    prisma = app.get(PrismaService);
    // Login throttling counts recent attempts per client IP; earlier admin specs
    // in the same run share 127.0.0.1, so retire their attempts (test DB only).
    await prisma.adminAuditEvent.updateMany({
      where: {
        action: { in: ['ADMIN_LOGIN_ATTEMPT', 'ADMIN_LOGIN_THROTTLED'] },
        deletedAt: null,
      },
      data: { deletedAt: new Date() },
    });
    await prisma.adminUser.createMany({
      data: [adminId, supportId].map((id) => ({
        id,
        email: `moderation-${id}@example.invalid`,
        passwordHash: 'synthetic-unusable',
        totpSecretEnc: Buffer.from('synthetic'),
        roles: [id === adminId ? 'MODERATOR' : 'SUPPORT'],
      })),
    });
    await prisma.user.create({
      data: { id: userId, displayName: 'Synthetic moderation fixture' },
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic admin moderation',
        createdBy: userId,
      },
    });
    for (const id of [memoryId, sealedId])
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: userId,
          authorRole: 'PARENT',
          status: 'PUBLISHED',
          kind: id === sealedId ? 'LETTER' : 'MOMENT',
          visibility: 'FAMILY',
          body:
            id === sealedId
              ? 'Sealed synthetic content'
              : 'Reported synthetic content',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          publishedAt: new Date(),
          commentCount: id === memoryId ? 1 : 0,
          ...(id === sealedId
            ? { unlockAt: new Date(Date.now() + 86400000) }
            : {}),
        },
      });
    await prisma.comment.create({
      data: {
        id: commentId,
        familyId,
        memoryId,
        authorUserId: userId,
        body: 'Reported synthetic comment',
      },
    });
    for (const [index, targetId] of [memoryId, commentId, sealedId].entries()) {
      const targetType = index === 1 ? 'COMMENT' : 'MEMORY';
      const report = await prisma.report.create({
        data: {
          reporterUserId: userId,
          familyId,
          targetType,
          targetId,
          reason: 'OTHER',
          detail: 'Synthetic report note',
          slaDueAt: new Date(Date.now() + 86400000),
        },
      });
      await prisma.moderationCase.create({
        data: {
          id: caseIds[index],
          targetId,
          targetType,
          priority: 2,
          slaDueAt: new Date(Date.now() + 86400000),
        },
      });
      await prisma.moderationCaseReport.create({
        data: { caseId: caseIds[index]!, reportId: report.id },
      });
    }
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.moderationAction.deleteMany({
          where: { caseId: { in: caseIds } },
        });
        await prisma.moderationCaseReport.deleteMany({
          where: { caseId: { in: caseIds } },
        });
        await prisma.moderationCase.deleteMany({
          where: { id: { in: caseIds } },
        });
        await prisma.report.deleteMany({ where: { familyId } });
        await prisma.comment.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.family.deleteMany({ where: { id: familyId } });
        await prisma.user.deleteMany({ where: { id: userId } });
        await prisma.adminAuditEvent.deleteMany({
          where: { adminId: { in: [adminId, supportId] } },
        });
        await prisma.adminUser.deleteMany({
          where: { id: { in: [adminId, supportId] } },
        });
      }
    } finally {
      await app?.close();
    }
  });
  it('returns metadata/reports without target body, audits reads, denies SUPPORT content', async () => {
    const list = await call(
      'get',
      '/moderation/cases?limit=100',
      'support',
    ).expect(200);
    expect(
      payload<{ items: { id: string }[] }>(list).items.some(
        (row) => row.id === caseIds[0],
      ),
    ).toBe(true);
    const sentinel = 'PRIVATE_MODERATOR_NOTE_SENTINEL';
    await prisma.moderationAction.create({
      data: {
        caseId: caseIds[0]!,
        adminId,
        action: 'VIEW_CONTENT',
        reasonNote: sentinel,
      },
    });
    const detail = await call(
      'get',
      `/moderation/cases/${caseIds[0]}`,
      'support',
    ).expect(200);
    expect(JSON.stringify(detail.body)).not.toContain(
      'Reported synthetic content',
    );
    expect(JSON.stringify(detail.body)).not.toContain(sentinel);
    expect(JSON.stringify(detail.body)).not.toContain('reasonNote');
    const denied = await call(
      'post',
      `/moderation/cases/${caseIds[0]}/content`,
      'support',
    )
      .send({ reason: 'Review report' })
      .expect(403);
    expect(errorCode(denied)).toBe('ADMIN_FORBIDDEN');
    expect(
      await prisma.adminAuditEvent.count({
        where: { adminId: supportId, action: 'AUTH_FORBIDDEN' },
      }),
    ).toBe(1);
    expect(
      await prisma.adminAuditEvent.count({
        where: {
          adminId: supportId,
          action: 'MODERATION_CASE_READ',
          entityId: caseIds[0],
        },
      }),
    ).toBe(1);
  });
  it('requires reason, returns only reported content, audits without private body', async () => {
    await call('post', `/moderation/cases/${caseIds[0]}/content`)
      .send({})
      .expect(400);
    const response = await call(
      'post',
      `/moderation/cases/${caseIds[0]}/content`,
    )
      .send({ reason: 'Review report' })
      .expect(201);
    expect(payload<{ content: { body: string } }>(response).content.body).toBe(
      'Reported synthetic content',
    );
    const audit = await prisma.adminAuditEvent.findFirstOrThrow({
      where: {
        adminId,
        action: 'MODERATION_CONTENT_READ',
        entityId: caseIds[0],
      },
    });
    expect(JSON.stringify(audit.redactedChanges)).not.toContain(
      'Reported synthetic content',
    );
    expect(audit.redactedChanges).toEqual({ reasonProvided: true });
  });
  it('rejects sealed content and unsupported permission for status', async () => {
    const sealed = await call('post', `/moderation/cases/${caseIds[2]}/content`)
      .send({ reason: 'Review report' })
      .expect(404);
    expect(errorCode(sealed)).toBe('ADMIN_REPORTED_CONTENT_UNAVAILABLE');
    await call('patch', `/moderation/cases/${caseIds[0]}/status`, 'support')
      .send({ status: 'IN_REVIEW', reason: 'Review report' })
      .expect(403);
  });
  it('hides a reported comment once and preserves active comment count', async () => {
    for (let i = 0; i < 2; i++)
      await call('post', `/moderation/cases/${caseIds[1]}/actions`)
        .send({ action: 'HIDE', reason: 'Confirmed violation' })
        .expect(201);
    expect(
      (await prisma.comment.findUniqueOrThrow({ where: { id: commentId } }))
        .status,
    ).toBe('HIDDEN');
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memoryId } }))
        .commentCount,
    ).toBe(0);
    expect(
      await prisma.adminAuditEvent.count({
        where: {
          adminId,
          action: 'MODERATION_CONTENT_HIDE',
          entityId: caseIds[1],
        },
      }),
    ).toBe(2);
  });
  it('archives reported memory, resolves case, rejects reopening', async () => {
    await call('patch', `/moderation/cases/${caseIds[0]}/status`)
      .send({ status: 'IN_REVIEW', reason: 'Review report' })
      .expect(200);
    await call('post', `/moderation/cases/${caseIds[0]}/actions`)
      .send({ action: 'HIDE', reason: 'Confirmed violation' })
      .expect(201);
    expect(
      (await prisma.memory.findUniqueOrThrow({ where: { id: memoryId } }))
        .status,
    ).toBe('ARCHIVED');
    await call('patch', `/moderation/cases/${caseIds[0]}/status`)
      .send({ status: 'RESOLVED', reason: 'Completed review' })
      .expect(200);
    const reopen = await call('patch', `/moderation/cases/${caseIds[0]}/status`)
      .send({ status: 'IN_REVIEW', reason: 'Review again' })
      .expect(409);
    expect(errorCode(reopen)).toBe('ADMIN_CASE_STATE_INVALID');
  });
});
