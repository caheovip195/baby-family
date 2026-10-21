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
import { AdminCmsCatalogPublishingController } from '../../src/controllers/admin-cms-catalog-publishing.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { AdminCmsCatalogController } from '../../src/controllers/admin-cms-catalog.controller';
import { AdminCmsCatalogService } from '../../src/services/admin-cms-catalog.service';
import { AdminCmsCatalogRepository } from '../../src/repositories/admin-cms-catalog.repository';
import { ADMIN_CMS_CATALOG_SERVICE } from '../../src/interfaces/services/admin-cms-catalog-service.interface';
import { ADMIN_CMS_CATALOG_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-catalog-repository.interface';
import { ADMIN_CMS_AUTH_SERVICE } from '../../src/interfaces/services/admin-cms-auth-service.interface';
import { ADMIN_CMS_CATALOG_PUBLISHING_SERVICE } from '../../src/interfaces/services/admin-cms-catalog-publishing-service.interface';
import { ADMIN_CMS_CATALOG_PUBLISHING_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-catalog-publishing-repository.interface';
import { AdminCmsCatalogPublishingService } from '../../src/services/admin-cms-catalog-publishing.service';
import { AdminCmsCatalogPublishingRepository } from '../../src/repositories/admin-cms-catalog-publishing.repository';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';

const data = (response: { body: unknown }) =>
  (response.body as { data: { item: Record<string, unknown> } }).data.item;
const errorCode = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Admin catalog draft and immutable publication (isolated PostgreSQL module)', () => {
  let app: INestApplication<Server>, prisma: PrismaService;
  const roles = [
    'CONTENT',
    'BILLING_OPS',
    'OPS',
    'SUPER_ADMIN',
    'SUPPORT',
    'ADMIN',
  ] as const;
  const admins = Object.fromEntries(roles.map((role) => [role, randomUUID()]));
  const prefix = `cp${randomUUID().slice(0, 8)}`;
  const planId = randomUUID();
  const missionCodes: string[] = [];
  const reason = 'Synthetic catalog publication spec';
  const call = (
    method: 'post' | 'get',
    path: string,
    role: string = 'CONTENT',
  ) => {
    const client = request(app.getHttpServer());
    return client[method](`/admin/v1/catalog${path}`).set(
      'Authorization',
      `Bearer ${role}`,
    );
  };
  const mission = (suffix: string) => {
    const code = `${prefix}-${suffix}`;
    missionCodes.push(code);
    return {
      code,
      stage: 'CHILD',
      minAgeDays: 0,
      maxAgeDays: 365,
      minPregWeek: null,
      maxPregWeek: null,
      category: 'CARE',
      suggestedScope: 'CHILD',
      roleFit: 'ANY_PARENT',
      hearts: 3,
      durationMin: 5,
      multiChildOk: true,
      requestable: true,
      titleI18n: { vi: 'Chơi cùng bé', en: 'Play together' },
      descI18n: { vi: 'Dành thời gian bên bé', en: 'Spend time together' },
      tags: ['synthetic'],
      weight: 10,
      version: 1,
      reason,
    };
  };
  const publish = (availableFrom = new Date().toISOString()) => ({
    reason,
    availableFrom,
  });
  const draftPlan = (version: number) => ({
    planId,
    version,
    quotas: { children: 3, storageBytes: 1000 },
    features: { circle: true },
    entitlementRank: 10,
    reason,
  });

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [
        AdminCmsCatalogPublishingController,
        AdminCmsCatalogController,
      ],
      providers: [
        {
          provide: ADMIN_CMS_CATALOG_SERVICE,
          useClass: AdminCmsCatalogService,
        },
        {
          provide: ADMIN_CMS_CATALOG_REPOSITORY,
          useClass: AdminCmsCatalogRepository,
        },
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
            authenticate: (role: keyof typeof admins) => ({
              id: admins[role],
              roles: [role],
              sessionId: randomUUID(),
            }),
            recordDenied: () => Promise.resolve(),
          },
        },
        {
          provide: ADMIN_CMS_CATALOG_PUBLISHING_SERVICE,
          useClass: AdminCmsCatalogPublishingService,
        },
        {
          provide: ADMIN_CMS_CATALOG_PUBLISHING_REPOSITORY,
          useClass: AdminCmsCatalogPublishingRepository,
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
    await prisma.adminUser.createMany({
      data: roles.map((role) => ({
        id: admins[role],
        email: `${prefix}-${role}@example.invalid`,
        roles: [role],
        passwordHash: 'synthetic-unused-auth-boundary',
        totpSecretEnc: new Uint8Array([0]),
      })),
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: prefix,
        displayNameI18n: { vi: 'Gói kiểm thử', en: 'Synthetic plan' },
      },
    });
  });

  afterAll(async () => {
    if (prisma) {
      await prisma.adminAuditEvent.deleteMany({
        where: { adminId: { in: Object.values(admins) } },
      });
      await prisma.appConfig.deleteMany({
        where: { updatedBy: { in: Object.values(admins) } },
      });
      await prisma.trialPolicy.deleteMany({
        where: { code: { startsWith: prefix } },
      });
      await prisma.planVersion.deleteMany({ where: { planId } });
      await prisma.plan.deleteMany({ where: { id: planId } });
      await prisma.missionTemplate.deleteMany({
        where: { code: { in: missionCodes } },
      });
      await prisma.adminUser.deleteMany({
        where: { id: { in: Object.values(admins) } },
      });
    }
    if (app) await app.close();
  });

  it('creates a mission draft, publishes once, retires without changing content or deleting history', async () => {
    const body = mission('main');
    const created = await call('post', '/missions').send(body).expect(201);
    expect(data(created)).toMatchObject({
      code: body.code,
      status: 'DRAFT',
      rolloutPct: 0,
    });
    const before = await prisma.missionTemplate.findUniqueOrThrow({
      where: { code: body.code },
    });
    const published = await call('post', `/missions/${body.code}/publish`)
      .send({ reason, rolloutPct: 80 })
      .expect(201);
    expect(data(published)).toMatchObject({
      code: body.code,
      status: 'PUBLISHED',
      rolloutPct: 80,
    });
    await call('post', `/missions/${body.code}/publish`)
      .send({ reason, rolloutPct: 10 })
      .expect(409);
    await call('post', '/missions')
      .send({ ...body, hearts: 9 })
      .expect(409);
    const retired = await call('post', `/missions/${body.code}/retire`)
      .send({ reason })
      .expect(201);
    expect(data(retired)).toMatchObject({ status: 'RETIRED' });
    await call('post', `/missions/${body.code}/publish`)
      .send({ reason })
      .expect(409);
    const after = await prisma.missionTemplate.findUniqueOrThrow({
      where: { code: body.code },
    });
    expect(after.titleI18n).toEqual(before.titleI18n);
    expect(after.hearts).toBe(before.hearts);
    expect(after.deletedAt).toBeNull();
    expect(after.createdAt).toEqual(before.createdAt);
    const events = await prisma.adminAuditEvent.findMany({
      where: { adminId: admins.CONTENT, entityId: body.code },
    });
    expect(events.length).toBeGreaterThanOrEqual(3);
    expect(events.every((event) => event.reasonCode === reason)).toBe(true);
  });

  it('validates mission schema, ranges, bilingual content, hearts and mandatory reason', async () => {
    const body = mission('invalid');
    for (const invalid of [
      { ...body, hearts: 11 },
      { ...body, minAgeDays: 10, maxAgeDays: 2 },
      { ...body, minPregWeek: 43 },
      { ...body, category: 'CUSTOM' },
      { ...body, suggestedScope: 'COUPLE', roleFit: 'ANY_PARENT' },
      { ...body, titleI18n: { vi: 'Thiếu bản dịch' } },
      { ...body, reason: '   ' },
      { ...body, unknown: true },
      { ...body, version: 0 },
    ]) {
      await call('post', '/missions').send(invalid).expect(400);
    }
    await call('post', '/missions')
      .send({ ...body, reason: undefined })
      .expect(400);
    expect(
      await prisma.missionTemplate.count({ where: { code: body.code } }),
    ).toBe(0);
  });

  it('rejects writes across CONTENT/billing roles and legacy ADMIN; permits SUPER_ADMIN', async () => {
    const body = mission('rbac');
    for (const role of ['BILLING_OPS', 'OPS', 'SUPPORT', 'ADMIN']) {
      const denied = await call('post', '/missions', role)
        .send(body)
        .expect(403);
      expect(errorCode(denied)).toBe('ADMIN_FORBIDDEN');
    }
    for (const role of ['CONTENT', 'SUPPORT', 'ADMIN'])
      await call('post', '/plan-versions', role).send(draftPlan(1)).expect(403);
    await call('post', '/missions', 'SUPER_ADMIN').send(body).expect(201);
    await call('post', `/missions/${body.code}/publish`, 'SUPER_ADMIN')
      .send({ reason })
      .expect(201);
    await call('post', `/missions/${body.code}/retire`, 'SUPER_ADMIN')
      .send({ reason })
      .expect(201);
  });
  it('keeps plan drafts out of public catalog, publishes availableFrom, rejects mutation and retires softly', async () => {
    const body = draftPlan(1);
    const created = await call('post', '/plan-versions', 'BILLING_OPS')
      .send(body)
      .expect(201);
    const id = String(data(created).id);
    expect(data(created)).toMatchObject({ version: 1, status: 'DRAFT' });
    expect(await prisma.planVersion.findUnique({ where: { id } })).toBeNull();
    const drafts = await call('get', '/publishing/plan-versions', 'OPS').expect(
      200,
    );
    expect(
      (drafts.body as { data: { items: { id: string }[] } }).data.items.some(
        (item) => item.id === id,
      ),
    ).toBe(true);
    const availableFrom = new Date(Date.now() - 1000).toISOString();
    await call('post', `/plan-versions/${id}/publish`, 'OPS')
      .send(publish(availableFrom))
      .expect(201);
    const row = await prisma.planVersion.findUniqueOrThrow({ where: { id } });
    expect(row.availableFrom.toISOString()).toBe(availableFrom);
    const publicCatalog = await new CatalogQueryRepository(prisma).findCatalog(
      new Date(),
    );
    expect(publicCatalog.plans.some((plan) => plan.versionId === id)).toBe(
      true,
    );
    await call('post', `/plan-versions/${id}/publish`, 'BILLING_OPS')
      .send(publish())
      .expect(409);
    await call('post', '/plan-versions', 'OPS')
      .send({ ...body, quotas: { children: 99 } })
      .expect(409);
    await call('post', `/plan-versions/${id}/retire`, 'BILLING_OPS')
      .send({ reason })
      .expect(201);
    const retired = await prisma.planVersion.findUniqueOrThrow({
      where: { id },
    });
    expect(retired.retiredAt).not.toBeNull();
    expect(retired.deletedAt).toBeNull();
    expect(retired.quotas).toEqual(body.quotas);
    expect(retired.features).toEqual(body.features);
    await call('post', `/plan-versions/${id}/publish`, 'OPS')
      .send(publish())
      .expect(409);
  });

  it('publishes a new plan version in the future and retires it without making it visible', async () => {
    const created = await call('post', '/plan-versions', 'SUPER_ADMIN')
      .send(draftPlan(2))
      .expect(201);
    const id = String(data(created).id);
    const future = new Date(Date.now() + 86400000).toISOString();
    await call('post', `/plan-versions/${id}/publish`, 'SUPER_ADMIN')
      .send(publish(future))
      .expect(201);
    const catalog = await new CatalogQueryRepository(prisma).findCatalog(
      new Date(),
    );
    expect(catalog.plans.some((plan) => plan.versionId === id)).toBe(false);
    await call('post', `/plan-versions/${id}/retire`, 'OPS')
      .send({ reason })
      .expect(201);
    const row = await prisma.planVersion.findUniqueOrThrow({ where: { id } });
    expect(row.retiredAt?.getTime()).toBeGreaterThanOrEqual(
      row.availableFrom.getTime(),
    );
  });

  it('creates and publishes trial policies with frozen duration; active-code conflicts never retire the old policy implicitly', async () => {
    const version = await prisma.planVersion.create({
      data: {
        planId,
        version: 3,
        availableFrom: new Date(Date.now() - 60000),
        quotas: { children: 5 },
        features: { circle: true },
      },
    });
    const body = {
      code: `${prefix}-trial`,
      version: 1,
      planVersionId: version.id,
      durationSeconds: 604800,
      reminderOffsetsSeconds: [86400],
      reason,
    };
    const draft = await call('post', '/trial-policies', 'OPS')
      .send(body)
      .expect(201);
    const id = String(data(draft).id);
    expect(await prisma.trialPolicy.findUnique({ where: { id } })).toBeNull();
    const availableFrom = new Date(Date.now() - 500).toISOString();
    const published = await call(
      'post',
      `/trial-policies/${id}/publish`,
      'BILLING_OPS',
    )
      .send(publish(availableFrom))
      .expect(201);
    expect(data(published)).toMatchObject({
      id,
      status: 'PUBLISHED',
      durationSeconds: '604800',
    });
    await call('post', `/plan-versions/${version.id}/retire`, 'OPS')
      .send({ reason })
      .expect(409);
    const row = await prisma.trialPolicy.findUniqueOrThrow({ where: { id } });
    expect(row.publishedAt?.toISOString()).toBe(availableFrom);
    expect(row.active).toBe(true);
    await call('post', `/trial-policies/${id}/publish`, 'OPS')
      .send(publish())
      .expect(409);
    await call('post', '/trial-policies', 'OPS')
      .send({ ...body, durationSeconds: 100000 })
      .expect(409);
    const second = await call('post', '/trial-policies', 'OPS')
      .send({ ...body, version: 2, durationSeconds: 1209600 })
      .expect(201);
    const nextId = String(data(second).id);
    await call('post', `/trial-policies/${nextId}/publish`, 'OPS')
      .send(publish())
      .expect(409);
    expect(
      (await prisma.trialPolicy.findUniqueOrThrow({ where: { id } })).active,
    ).toBe(true);
    await call('post', `/trial-policies/${id}/retire`, 'OPS')
      .send({ reason })
      .expect(201);
    await call('post', `/trial-policies/${nextId}/publish`, 'OPS')
      .send(publish())
      .expect(201);
    const previous = await prisma.trialPolicy.findUniqueOrThrow({
      where: { id },
    });
    expect(previous.durationSeconds).toBe(604800n);
    expect(previous.active).toBe(false);
    expect(previous.deletedAt).toBeNull();
    const active = await prisma.trialPolicy.findUniqueOrThrow({
      where: { id: nextId },
    });
    expect(active.durationSeconds).toBe(1209600n);
    await call('post', `/trial-policies/${nextId}/retire`, 'BILLING_OPS')
      .send({ reason })
      .expect(201);
  });

  it('validates billing inputs, nonexistent references and unsupported unversioned catalogs', async () => {
    for (const body of [
      { ...draftPlan(9), quotas: { children: -1 } },
      { ...draftPlan(9), features: { circle: 'yes' } },
      { ...draftPlan(9), reason: '' },
    ])
      await call('post', '/plan-versions', 'OPS').send(body).expect(400);
    await call('post', '/plan-versions', 'OPS')
      .send({ ...draftPlan(9), planId: randomUUID() })
      .expect(404);
    await call('post', '/trial-policies', 'OPS')
      .send({
        code: prefix,
        version: 1,
        planVersionId: randomUUID(),
        durationSeconds: 100,
        reminderOffsetsSeconds: [100],
        reason,
      })
      .expect(400);
    for (const kind of ['milestones', 'notification-templates']) {
      const response = await call('post', `/${kind}`, 'CONTENT')
        .send({ reason })
        .expect(422);
      expect(errorCode(response)).toBe('ADMIN_CATALOG_UNSUPPORTED');
    }
    await call('post', `/missions/${prefix}-missing/publish`)
      .send({ reason })
      .expect(404);
    await call('post', `/plan-versions/${randomUUID()}/publish`, 'OPS')
      .send(publish())
      .expect(404);
  });
  it('rejects unauthenticated requests and does not leak drafts across role groups', async () => {
    await request(app.getHttpServer())
      .post('/admin/v1/catalog/missions')
      .send(mission('no-auth'))
      .expect(401);
    await call('get', '/publishing/plan-versions', 'CONTENT').expect(403);
    await call('get', '/publishing/missions', 'BILLING_OPS').expect(403);
    await call('get', '/publishing/trial-policies', 'SUPPORT').expect(403);
  });

  it('publishes only once under concurrent requests, preserving one audit for the successful transition', async () => {
    const body = mission('race');
    await call('post', '/missions').send(body).expect(201);
    const responses = await Promise.all([
      call('post', `/missions/${body.code}/publish`).send({ reason }),
      call('post', `/missions/${body.code}/publish`).send({ reason }),
    ]);
    expect(responses.map((response) => response.status).sort()).toEqual([
      201, 409,
    ]);
    expect(
      (
        await prisma.missionTemplate.findUniqueOrThrow({
          where: { code: body.code },
        })
      ).status,
    ).toBe('ACTIVE');
  });

  it('rolls back the catalog write if its audit cannot be recorded', async () => {
    const { reason: auditReason, ...input } = mission('rollback');
    await expect(
      new AdminCmsCatalogPublishingRepository(prisma).create(
        randomUUID(),
        'missions',
        input as Parameters<AdminCmsCatalogPublishingRepository['create']>[2],
        auditReason,
      ),
    ).rejects.toThrow();
    expect(
      await prisma.missionTemplate.count({ where: { code: input.code } }),
    ).toBe(0);
  });
  it('enforces role and reason on every publish/retire operation', async () => {
    for (const action of ['publish', 'retire']) {
      for (const role of ['BILLING_OPS', 'OPS', 'SUPPORT', 'ADMIN'])
        await call('post', `/missions/${prefix}-main/${action}`, role)
          .send({ reason })
          .expect(403);
      for (const kind of ['plan-versions', 'trial-policies'])
        for (const role of ['CONTENT', 'SUPPORT', 'ADMIN'])
          await call('post', `/${kind}/${randomUUID()}/${action}`, role)
            .send(publish())
            .expect(403);
      await call('post', `/missions/${prefix}-main/${action}`)
        .send({ reason: '  ' })
        .expect(400);
      for (const kind of ['plan-versions', 'trial-policies'])
        await call('post', `/${kind}/${randomUUID()}/${action}`, 'OPS')
          .send({ reason: '  ' })
          .expect(400);
    }
  });
  it('allows OPS to read the catalog used by the billing CMS forms', async () => {
    for (const kind of ['plan-versions', 'trial-policies'])
      await call('get', `/${kind}`, 'OPS').expect(200);
  });

  it('retires unpublished billing drafts without inserting real versions', async () => {
    const created = await call('post', '/plan-versions', 'OPS')
      .send(draftPlan(4))
      .expect(201);
    const id = String(data(created).id);
    await call('post', `/plan-versions/${id}/retire`, 'OPS')
      .send({ reason })
      .expect(201);
    await call('post', `/plan-versions/${id}/publish`, 'OPS')
      .send(publish())
      .expect(409);
    expect(await prisma.planVersion.findUnique({ where: { id } })).toBeNull();
  });

  it('schedules a new-code trial and can cancel it before availability', async () => {
    const plan = await prisma.planVersion.findUniqueOrThrow({
      where: { planId_version: { planId, version: 3 } },
    });
    const created = await call('post', '/trial-policies', 'SUPER_ADMIN')
      .send({
        code: `${prefix}-future`,
        version: 1,
        planVersionId: plan.id,
        durationSeconds: 604800,
        reminderOffsetsSeconds: [],
        reason,
      })
      .expect(201);
    const id = String(data(created).id);
    const future = new Date(Date.now() + 86400000).toISOString();
    await call('post', `/trial-policies/${id}/publish`, 'SUPER_ADMIN')
      .send(publish(future))
      .expect(201);
    const catalog = await new CatalogQueryRepository(prisma).findCatalog(
      new Date(),
    );
    expect(
      catalog.trialPolicies.some(
        (policy) => policy.code === `${prefix}-future`,
      ),
    ).toBe(false);
    await call('post', `/trial-policies/${id}/retire`, 'OPS')
      .send({ reason })
      .expect(201);
    const row = await prisma.trialPolicy.findUniqueOrThrow({ where: { id } });
    expect(row.active).toBe(false);
    expect(row.retiredAt?.getTime()).toBe(row.publishedAt?.getTime());
  });
});
