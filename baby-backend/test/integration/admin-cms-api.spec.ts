import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import {
  UnauthorizedException,
  ValidationPipe,
  type INestApplication,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AdminCmsGuard } from '../../src/common/auth/admin-cms.guard';
import {
  hashAdminPassword,
  encryptAdminTotpSecret,
  adminTotpCode,
} from '../../src/common/auth/admin-cms-crypto';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { AdminCmsAuthController } from '../../src/controllers/admin-cms-auth.controller';
import { AdminCmsOperationsController } from '../../src/controllers/admin-cms-operations.controller';
import { AdminCmsHelpdeskController } from '../../src/controllers/admin-cms-helpdesk.controller';
import { AdminCmsCatalogController } from '../../src/controllers/admin-cms-catalog.controller';
import { FamilyController } from '../../src/controllers/family.controller';
import { SupportHelpdeskController } from '../../src/controllers/support-helpdesk.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { ADMIN_CMS_AUTH_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-auth-repository.interface';
import { ADMIN_CMS_OPERATIONS_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-operations-repository.interface';
import { ADMIN_CMS_HELPDESK_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-helpdesk-repository.interface';
import { ADMIN_CMS_CATALOG_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-catalog-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { FAMILY_REPOSITORY } from '../../src/interfaces/repositories/family-repository.interface';
import { SUPPORT_HELPDESK_REPOSITORY } from '../../src/interfaces/repositories/support-helpdesk-repository.interface';
import { ADMIN_CMS_AUTH_SERVICE } from '../../src/interfaces/services/admin-cms-auth-service.interface';
import { ADMIN_CMS_OPERATIONS_SERVICE } from '../../src/interfaces/services/admin-cms-operations-service.interface';
import { ADMIN_CMS_HELPDESK_SERVICE } from '../../src/interfaces/services/admin-cms-helpdesk-service.interface';
import { ADMIN_CMS_CATALOG_SERVICE } from '../../src/interfaces/services/admin-cms-catalog-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { FAMILY_SERVICE } from '../../src/interfaces/services/family-service.interface';
import { SUPPORT_HELPDESK_SERVICE } from '../../src/interfaces/services/support-helpdesk-service.interface';
import { AdminCmsAuthRepository } from '../../src/repositories/admin-cms-auth.repository';
import { AdminCmsOperationsRepository } from '../../src/repositories/admin-cms-operations.repository';
import { AdminCmsHelpdeskRepository } from '../../src/repositories/admin-cms-helpdesk.repository';
import { AdminCmsCatalogRepository } from '../../src/repositories/admin-cms-catalog.repository';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { FamilyRepository } from '../../src/repositories/family.repository';
import { SupportHelpdeskRepository } from '../../src/repositories/support-helpdesk.repository';
import { AdminCmsAuthService } from '../../src/services/admin-cms-auth.service';
import { AdminCmsOperationsService } from '../../src/services/admin-cms-operations.service';
import { AdminCmsHelpdeskService } from '../../src/services/admin-cms-helpdesk.service';
import { AdminCmsCatalogService } from '../../src/services/admin-cms-catalog.service';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { FamilyService } from '../../src/services/family.service';
import { SupportHelpdeskService } from '../../src/services/support-helpdesk.service';
const data = <T>(r: { body: unknown }) => (r.body as { data: T }).data;
const code = (r: { body: unknown }) =>
  (r.body as { error: { code: string } }).error.code;
describe('Admin CMS isolated auth and app interoperability (PostgreSQL)', () => {
  let app: INestApplication<Server>, prisma: PrismaService;
  const adminId = randomUUID(),
    supportId = randomUUID(),
    owner = randomUUID(),
    partner = randomUUID(),
    familyId = randomUUID();
  const planId = randomUUID(),
    planVersionId = randomUUID();
  const totp = 'JBSWY3DPEHPK3PXP',
    password = 'Synthetic-test-password-583!';
  const key = randomBytes(32).toString('base64');
  const previousTotpKey = process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY;
  const previousTokenKey = process.env.ADMIN_CMS_TOKEN_SECRET;
  const email = `cms-${adminId}@example.invalid`,
    supportEmail = `cms-${supportId}@example.invalid`;
  let adminToken = '',
    supportToken = '',
    ticketId = '';
  const admin = (
    method: 'get' | 'post' | 'patch',
    path: string,
    token = adminToken,
  ) => {
    const client = request(app.getHttpServer());
    return client[method](`/admin/v1${path}`).set(
      'Authorization',
      `Bearer ${token}`,
    );
  };
  const user = (method: 'get' | 'post', path: string) => {
    const client = request(app.getHttpServer());
    return client[method](`/api/v1${path}`).set(
      'Authorization',
      `Bearer ${owner}`,
    );
  };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY = key;
    process.env.ADMIN_CMS_TOKEN_SECRET = key;
    const config = new ConfigService({
      DATABASE_URL: process.env.DATABASE_URL,
      DATABASE_POOL_SIZE: 3,
      SUPPORT_ENCRYPTION_KEY: key,
      ADMIN_CMS_TOTP_ENCRYPTION_KEY: key,
      ADMIN_CMS_TOKEN_SECRET: key,
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [
        AdminCmsAuthController,
        AdminCmsOperationsController,
        AdminCmsHelpdeskController,
        AdminCmsCatalogController,
        FamilyController,
        SupportHelpdeskController,
      ],
      providers: [
        PrismaService,
        AdminCmsGuard,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: ADMIN_CMS_AUTH_REPOSITORY,
          useClass: AdminCmsAuthRepository,
        },
        { provide: ADMIN_CMS_AUTH_SERVICE, useClass: AdminCmsAuthService },
        {
          provide: ADMIN_CMS_OPERATIONS_REPOSITORY,
          useClass: AdminCmsOperationsRepository,
        },
        {
          provide: ADMIN_CMS_OPERATIONS_SERVICE,
          useClass: AdminCmsOperationsService,
        },
        {
          provide: ADMIN_CMS_HELPDESK_REPOSITORY,
          useClass: AdminCmsHelpdeskRepository,
        },
        {
          provide: ADMIN_CMS_HELPDESK_SERVICE,
          useClass: AdminCmsHelpdeskService,
        },
        {
          provide: ADMIN_CMS_CATALOG_REPOSITORY,
          useClass: AdminCmsCatalogRepository,
        },
        {
          provide: ADMIN_CMS_CATALOG_SERVICE,
          useClass: AdminCmsCatalogService,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: FAMILY_REPOSITORY, useClass: FamilyRepository },
        { provide: FAMILY_SERVICE, useClass: FamilyService },
        {
          provide: SUPPORT_HELPDESK_REPOSITORY,
          useClass: SupportHelpdeskRepository,
        },
        { provide: SUPPORT_HELPDESK_SERVICE, useClass: SupportHelpdeskService },
        {
          provide: AUTHENTICATION_SERVICE,
          useValue: {
            verifyAccessToken: (token: string) => {
              if (token !== owner) throw new UnauthorizedException();
              return {
                userId: owner,
                sessionId: randomUUID(),
                tokenVersion: 1,
              };
            },
          },
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1', { exclude: ['admin/v1/{*path}'] });
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
      data: await Promise.all(
        [
          [adminId, email, ['MODERATOR', 'OPS', 'CONTENT']],
          [supportId, supportEmail, ['SUPPORT']],
        ].map(async ([id, email, roles]) => ({
          id: id as string,
          email: email as string,
          roles: roles as string[],
          passwordHash: await hashAdminPassword(password),
          totpSecretEnc: new Uint8Array(encryptAdminTotpSecret(totp)),
        })),
      ),
    });
    await prisma.user.createMany({
      data: [owner, partner].map((id) => ({
        id,
        displayName: 'Synthetic CMS user',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic CMS family',
        createdBy: owner,
        status: 'ACTIVE',
      },
    });
    await prisma.familyParent.createMany({
      data: [owner, partner].map((userId, i) => ({
        familyId,
        userId,
        slot: i ? 'B' : 'A',
        kind: i ? 'MOTHER' : 'FATHER',
        callName: 'Parent',
      })),
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `cms-${planId}`,
        displayNameI18n: { en: 'Synthetic CMS' },
      },
    });
    await prisma.planVersion.create({
      data: { id: planVersionId, planId, version: 1, quotas: {}, features: {} },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
  });
  afterAll(async () => {
    try {
      if (prisma) {
        const deletedAt = new Date();
        await prisma.supportTicketMessage.updateMany({
          where: { supportTicket: { familyId } },
          data: { deletedAt },
        });
        await prisma.supportTicket.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.familyEntitlement.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.planVersion.updateMany({
          where: { id: planVersionId },
          data: { deletedAt },
        });
        await prisma.plan.updateMany({
          where: { id: planId },
          data: { deletedAt },
        });
        await prisma.familyLicense.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.familyParent.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt },
        });
        await prisma.user.updateMany({
          where: { id: { in: [owner, partner] } },
          data: { deletedAt },
        });
        await prisma.adminSession.updateMany({
          where: { adminId: { in: [adminId, supportId] } },
          data: { revokedAt: deletedAt },
        });
        await prisma.adminUser.updateMany({
          where: { id: { in: [adminId, supportId] } },
          data: { deletedAt },
        });
      }
    } finally {
      await app?.close();
      if (previousTotpKey === undefined)
        delete process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY;
      else process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY = previousTotpKey;
      if (previousTokenKey === undefined)
        delete process.env.ADMIN_CMS_TOKEN_SECRET;
      else process.env.ADMIN_CMS_TOKEN_SECRET = previousTokenKey;
    }
  });
  it('requires password + TOTP, separates app/admin tokens and enforces RBAC', async () => {
    await request(app.getHttpServer())
      .post('/admin/v1/auth/login')
      .send({ email, password: 'wrong', totp: adminTotpCode(totp) })
      .expect(401);
    await request(app.getHttpServer())
      .post('/admin/v1/auth/login')
      .send({ email, password, totp: '000000' })
      .expect(401);
    adminToken = data<{ accessToken: string }>(
      await request(app.getHttpServer())
        .post('/admin/v1/auth/login')
        .send({ email, password, totp: adminTotpCode(totp) })
        .expect(200),
    ).accessToken;
    supportToken = data<{ accessToken: string }>(
      await request(app.getHttpServer())
        .post('/admin/v1/auth/login')
        .send({ email: supportEmail, password, totp: adminTotpCode(totp) })
        .expect(200),
    ).accessToken;
    await admin('get', '/moderation/cases', owner).expect(401);
    await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}`)
      .set('Authorization', `Bearer ${adminToken}`)
      .expect(401);
    await admin('post', `/families/${familyId}/license/block`, supportToken)
      .send({ reason: 'CASE_REVIEW', reasonCode: 'SAFETY' })
      .expect(403);
  });
  it('blocks license immediately for app and records atomic audit, then unblocks', async () => {
    await user('get', `/families/${familyId}`).expect(200);
    await admin('post', `/families/${familyId}/license/block`)
      .send({ reason: 'CASE_REVIEW', reasonCode: 'SAFETY' })
      .expect(201);
    expect(code(await user('get', `/families/${familyId}`).expect(403))).toBe(
      'LICENSE_BLOCKED',
    );
    expect(
      await prisma.adminAuditEvent.count({
        where: {
          adminId,
          entityId: (
            await prisma.familyLicense.findUniqueOrThrow({
              where: { familyId },
            })
          ).id,
        },
      }),
    ).toBeGreaterThan(0);
    await admin('post', `/families/${familyId}/license/unblock`)
      .send({ reason: 'CASE_RESOLVED', reasonCode: 'CASE_RESOLVED' })
      .expect(201);
    const unblockAudit = await prisma.adminAuditEvent.findFirst({
      where: {
        adminId,
        action: 'LICENSE_UNBLOCK',
        reasonCode: 'CASE_RESOLVED',
      },
    });
    expect(unblockAudit).not.toBeNull();
    expect(unblockAudit?.redactedChanges).toMatchObject({
      familyId,
      blocked: false,
      reasonProvided: true,
    });
    await user('get', `/families/${familyId}`).expect(200);
  });
  it('replies to encrypted tickets and the app receives SUPPORT message', async () => {
    ticketId = data<{ id: string }>(
      await user('post', '/support/tickets')
        .send({
          familyId,
          category: 'MEDIA',
          subject: 'Synthetic subject',
          body: 'Synthetic body',
        })
        .expect(201),
    ).id;
    await admin(
      'get',
      `/support/tickets/${ticketId}?reasonCode=CASE_REVIEW`,
      supportToken,
    ).expect(200);
    await admin('post', `/support/tickets/${ticketId}/messages`, supportToken)
      .send({ body: 'Synthetic support response', reasonCode: 'CASE_REPLY' })
      .expect(201);
    const result = data<{ messages: { sender: string; body: string }[] }>(
      await user('get', `/support/tickets/${ticketId}`).expect(200),
    );
    expect(result.messages).toContainEqual(
      expect.objectContaining({
        sender: 'SUPPORT',
        body: 'Synthetic support response',
      }),
    );
    await admin('patch', `/support/tickets/${ticketId}/status`, supportToken)
      .send({ status: 'RESOLVED', reasonCode: 'CASE_RESOLVED' })
      .expect(200);
    const audits = await prisma.adminAuditEvent.findMany({
      where: { adminId: supportId, entityId: ticketId },
    });
    expect(audits.length).toBeGreaterThanOrEqual(3);
    expect(
      JSON.stringify(
        audits.map(({ redactedChanges, reasonCode }) => ({
          redactedChanges,
          reasonCode,
        })),
      ),
    ).not.toContain('Synthetic support response');
  });
  it('validates sensitive reasons, all ticket states and read-only catalogs', async () => {
    await admin('get', `/support/tickets/${ticketId}`, supportToken).expect(
      400,
    );
    await admin('post', `/support/tickets/${ticketId}/messages`, supportToken)
      .send({ body: 'Closed reply', reasonCode: 'CASE_REPLY' })
      .expect(409);
    for (const status of [
      'CLOSED',
      'OPEN',
      'IN_PROGRESS',
      'WAITING_USER',
      'RESOLVED',
    ]) {
      const result = data<{ status: string }>(
        await admin(
          'patch',
          `/support/tickets/${ticketId}/status`,
          supportToken,
        )
          .send({ status, reasonCode: 'STATE_REVIEW' })
          .expect(200),
      );
      expect(result.status).toBe(status);
    }
    for (const kind of [
      'missions',
      'milestones',
      'notification-templates',
      'plan-versions',
      'trial-policies',
    ]) {
      const result = data<{ mutationSupported: boolean }>(
        await admin('get', `/catalog/${kind}`).expect(200),
      );
      expect(result.mutationSupported).toBe(false);
    }
  });
  it('exposes catalog metadata and revokes sessions', async () => {
    await admin('get', '/catalog/missions').expect(200);
    await admin('get', '/catalog/missions', supportToken).expect(403);
    await admin('post', '/auth/logout').expect(204);
    await admin('get', '/moderation/cases').expect(401);
  });
});
