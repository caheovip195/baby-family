import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportPKCS8, exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { CircleController } from '../../src/controllers/circle.controller';
import { InviteController } from '../../src/controllers/invite.controller';
import { FamilyCircleService } from '../../src/services/family-circle.service';
import { FamilyCircleRepository } from '../../src/repositories/family-circle.repository';
import { FAMILY_CIRCLE_SERVICE } from '../../src/interfaces/services/family-circle-service.interface';
import { FAMILY_CIRCLE_REPOSITORY } from '../../src/interfaces/repositories/family-circle-repository.interface';
import { OnboardingService } from '../../src/services/onboarding.service';
import { OnboardingRepository } from '../../src/repositories/onboarding.repository';
import { ONBOARDING_SERVICE } from '../../src/interfaces/services/onboarding-service.interface';
import { ONBOARDING_REPOSITORY } from '../../src/interfaces/repositories/onboarding-repository.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AuthTokenService } from '../../src/services/auth-token.service';
import { AUTH_TOKEN_SERVICE } from '../../src/interfaces/services/auth-token-service.interface';
import { UserRepository } from '../../src/repositories/user.repository';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import { FamilyBillingService } from '../../src/services/family-billing.service';
import { FAMILY_BILLING_SERVICE } from '../../src/interfaces/services/family-billing-service.interface';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';
import { CATALOG_QUERY_REPOSITORY } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type { CircleCreatedInvite } from '../../src/interfaces/services/family-circle-service.interface';
interface Member {
  id: string;
  userId: string;
  displayName: string;
  grants: {
    childId?: string;
    pregnancyId?: string;
    allowDownload: boolean;
    permission: string;
  }[];
}
interface Mine {
  items: {
    familyId: string;
    status: string;
    children: { id: string; name: string }[];
    allowDownload: boolean;
  }[];
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const error = (response: { body: unknown }): string =>
  (response.body as { error: { code: string } }).error.code;
describe('Family Circle API (focused Nest module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let versionId: string;
  let planId: string;
  let catalogVersion = 1;
  const fid = randomUUID();
  const parent = randomUUID(),
    parentB = randomUUID(),
    relative = randomUUID(),
    relativeB = randomUUID(),
    stranger = randomUUID(),
    waiting = randomUUID(),
    third = randomUUID();
  const users = [
    parent,
    parentB,
    relative,
    relativeB,
    stranger,
    waiting,
    third,
  ];
  const tokens = new Map<string, string>();
  let childA: string,
    childB: string,
    pregnancy: string,
    privatePregnancy: string;
  const root = `/families/${fid}`;
  const http = () => request(app.getHttpServer());
  const get = (path: string, user = parent) =>
    http().get(`/api/v1${path}`).set('Authorization', tokens.get(user)!);
  const post = (path: string, body: object = {}, user = parent) =>
    http()
      .post(`/api/v1${path}`)
      .set('Authorization', tokens.get(user)!)
      .send(body);
  const patch = (id: string, body: object, user = parent) =>
    http()
      .patch(`/api/v1/circle-members/${id}`)
      .set('Authorization', tokens.get(user)!)
      .send(body);
  const grant = (id = childA) => ({ childId: id, allowDownload: false });
  const invite = async (overrides: object = {}) =>
    data<CircleCreatedInvite>(
      await post(`${root}/invites/circle`, {
        relation: 'GRANDMOTHER_PATERNAL',
        displayName: 'Synthetic relative',
        grants: [grant()],
        requireFinalApproval: false,
        ...overrides,
      }).expect(201),
    );
  const accept = (i: CircleCreatedInvite, user = relative) =>
    post('/invites/accept', { code: i.code }, user);
  const members = async () =>
    data<{ members: Member[] }>(await get(`${root}/circle`).expect(200))
      .members;
  const mine = async (user = relative) =>
    data<Mine>(await get('/me/circles', user).expect(200)).items.filter(
      (i) => i.familyId === fid,
    );
  const changeCatalog = async (quota: number | 'missing', enabled = true) => {
    const version = await prisma.planVersion.create({
      data: {
        planId,
        version: ++catalogVersion,
        quotas: quota === 'missing' ? {} : { circleMax: quota },
        features: { 'circle.enabled': enabled },
        availableFrom: new Date(),
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId: fid },
      data: { effectivePlanVersionId: version.id, version: { increment: 1 } },
    });
  };
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
      AUTH_JWT_PRIVATE_KEY: await exportPKCS8(keys.privateKey),
      AUTH_SECRET_PEPPER: 'synthetic-circle-integration-secret',
      INVITE_LINK_BASE_URL: 'https://example.test/invite/',
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'error' } })],
      controllers: [CircleController, InviteController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: FAMILY_CIRCLE_SERVICE, useClass: FamilyCircleService },
        { provide: FAMILY_CIRCLE_REPOSITORY, useClass: FamilyCircleRepository },
        { provide: ONBOARDING_SERVICE, useClass: OnboardingService },
        { provide: ONBOARDING_REPOSITORY, useClass: OnboardingRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: AUTH_TOKEN_SERVICE, useClass: AuthTokenService },
        { provide: USER_REPOSITORY, useClass: UserRepository },
        { provide: FAMILY_BILLING_SERVICE, useClass: FamilyBillingService },
        { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
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
    for (const userId of users) {
      const sid = randomUUID();
      await prisma.user.create({
        data: {
          id: userId,
          displayName: 'Synthetic Circle fixture',
          onboardingRole: userId === parent ? 'PARENT_FATHER' : 'CIRCLE',
        },
      });
      await prisma.userSession.create({
        data: {
          id: sid,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + 86400000),
          absoluteExpiresAt: new Date(Date.now() + 86400000),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer(config.get<string>('AUTH_JWT_ISSUER')!).setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!).setIssuedAt().setExpirationTime('5m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: fid,
        name: 'Synthetic Circle family',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date(),
      },
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId: fid,
          userId: parent,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId: fid,
          userId: parentB,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    const plan = await prisma.plan.create({
      data: {
        code: `CIRCLE_${randomUUID().slice(0, 20)}`,
        displayNameI18n: { vi: 'Synthetic Circle' },
      },
    });
    planId = plan.id;
    versionId = (
      await prisma.planVersion.create({
        data: {
          planId: plan.id,
          version: 1,
          quotas: { circleMax: 100 },
          features: { 'circle.enabled': true },
          availableFrom: new Date(),
        },
      })
    ).id;
    const license = await prisma.familyLicense.create({
      data: { familyId: fid },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId: fid,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: versionId,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    childA = (
      await prisma.child.create({
        data: {
          familyId: fid,
          colorIndex: 1,
          createdBy: parent,
          name: 'Granted synthetic child',
          birthDate: new Date('2025-01-01'),
        },
      })
    ).id;
    childB = (
      await prisma.child.create({
        data: {
          familyId: fid,
          colorIndex: 2,
          createdBy: parent,
          name: 'Ungranted synthetic child',
          birthDate: new Date('2025-02-01'),
        },
      })
    ).id;
    pregnancy = (
      await prisma.pregnancy.create({
        data: {
          familyId: fid,
          createdBy: parent,
          seqNo: 1,
          nickname: 'Granted synthetic pregnancy',
        },
      })
    ).id;
    privatePregnancy = (
      await prisma.pregnancy.create({
        data: {
          familyId: fid,
          createdBy: parent,
          seqNo: 2,
          nickname: 'Private synthetic pregnancy',
          status: 'ENDED_PRIVATE',
        },
      })
    ).id;
  });
  afterEach(async () => {
    if (!prisma) return;
    await prisma.familyEntitlement.update({
      where: { familyId: fid },
      data: { effectivePlanVersionId: versionId, version: { increment: 1 } },
    });
    await prisma.familyInvite.updateMany({
      where: {
        familyId: fid,
        type: 'CIRCLE',
        status: { in: ['PENDING', 'AWAITING_APPROVAL'] },
      },
      data: { status: 'REVOKED', decidedAt: new Date() },
    });
  });
  afterAll(async () => {
    await app?.close();
  });

  it('creates a hashed 14-day invite; resolves only granted subjects; accepts idempotently with member and grants', async () => {
    const i = await invite({
      grants: [
        grant(),
        { pregnancyId: pregnancy, allowDownload: true, permission: 'COMMENT' },
      ],
    });
    expect(i.url).toContain('https://example.test/invite/');
    expect(i.code).toMatch(/^[A-Z2-9]{8}$/);
    expect(new Date(i.expiresAt).getTime() - Date.now()).toBeGreaterThan(
      13.9 * 86400000,
    );
    const row = await prisma.familyInvite.findUniqueOrThrow({
      where: { id: i.inviteId },
    });
    expect(Buffer.from(row.codeHash).toString()).not.toBe(i.code);
    const preview = data<{
      children: { id: string; name: string }[];
      type: string;
      relation: string;
    }>(
      await post('/invites/resolve', { token: i.url.split('/').pop() }).expect(
        200,
      ),
    );
    expect(preview.type).toBe('CIRCLE');
    expect(preview.relation).toBe('GRANDMOTHER_PATERNAL');
    expect(preview.children.map((c) => c.id).sort()).toEqual(
      [childA, pregnancy].sort(),
    );
    expect(JSON.stringify(preview)).not.toContain(childB);
    expect(JSON.stringify(preview)).not.toContain(privatePregnancy);
    expect(data(await accept(i).expect(200))).toEqual({
      status: 'JOINED',
      familyId: fid,
      trialEndsAt: null,
    });
    await accept(i).expect(200);
    const m = (await members()).find((m) => m.userId === relative)!;
    expect(m.grants).toHaveLength(2);
    expect(m.grants).toContainEqual({
      childId: childA,
      allowDownload: false,
      permission: 'VIEW',
    });
    const current = (await mine())[0]!;
    expect(current.status).toBe('ACTIVE');
    expect(current.children.map((c) => c.id).sort()).toEqual(
      [childA, pregnancy].sort(),
    );
    expect(current.allowDownload).toBe(true);
    // The relative app reads its own per-subject rights (comment/post).
    expect(current.children).toContainEqual(
      expect.objectContaining({ id: childA, permission: 'VIEW' }),
    );
    expect(
      await prisma.circleMember.count({
        where: { familyId: fid, userId: relative, deletedAt: null },
      }),
    ).toBe(1);
  });
  it('restricts all management to Parents and does not expose other relatives through /me/circles', async () => {
    const i = await invite();
    await accept(i, relativeB).expect(200);
    const m = (await members()).find((m) => m.userId === relativeB)!;
    for (const path of [
      `${root}/circle`,
      `${root}/overview`,
      `${root}/invites/circle`,
    ]) {
      await get(path, relative).expect(404);
      await get(path, stranger).expect(404);
    }
    await patch(m.id, { grants: [grant(childB)] }, relative).expect(404);
    await post(`/circle-members/${m.id}/pause`, {}, relative).expect(404);
    await post(
      `${root}/invites/circle`,
      { relation: 'OTHER', displayName: 'Invalid caller', grants: [grant()] },
      relative,
    ).expect(404);
    await post(`/invites/${i.inviteId}/renew`, {}, relative).expect(404);
    await post(`/invites/${i.inviteId}/revoke`, {}, relative).expect(404);
    const own = await mine();
    expect(JSON.stringify(own)).not.toContain(relativeB);
    expect(JSON.stringify(own)).not.toContain(m.id);
    expect(await mine(stranger)).toEqual([]);
    await http().get(`/api/v1${root}/circle`).expect(401);
  });
  it('requires final approval, supports rejection without altering account settings, and permits the waiting relative to leave', async () => {
    const i = await invite({ requireFinalApproval: true });
    expect(data(await accept(i, waiting).expect(200))).toMatchObject({
      status: 'AWAITING_APPROVAL',
    });
    await accept(i, waiting).expect(200);
    expect((await members()).some((m) => m.userId === waiting)).toBe(false);
    expect((await mine(waiting))[0]).toMatchObject({
      status: 'AWAITING_APPROVAL',
      children: [],
      allowDownload: false,
    });
    await post(`/invites/${i.inviteId}/approve`, {}, relative).expect(404);
    expect(
      data(
        await post(`/invites/${i.inviteId}/approve`, {}, parentB).expect(200),
      ),
    ).toMatchObject({ status: 'JOINED' });
    expect(
      (await members()).find((m) => m.userId === waiting)?.grants,
    ).toHaveLength(1);
    const rejected = await invite({ requireFinalApproval: true });
    await accept(rejected, third).expect(200);
    await post(`/invites/${rejected.inviteId}/reject`).expect(200);
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: third } }))
        .onboardingRole,
    ).toBe('CIRCLE');
    expect(await mine(third)).toEqual([]);
    const withdraw = await invite({ requireFinalApproval: true });
    await accept(withdraw, third).expect(200);
    await post(`${root}/circle/leave`, {}, third).expect(204);
    expect(await mine(third)).toEqual([]);
  });
  it('replaces grants atomically, bumps accessVersion, pauses/resumes, then self-leaves and revokes grants', async () => {
    const m = (await members()).find((m) => m.userId === relative)!;
    const before = (
      await prisma.family.findUniqueOrThrow({ where: { id: fid } })
    ).accessVersion;
    await patch(m.id, {
      displayName: 'Updated synthetic relative',
      allowDownload: false,
      grants: [
        { childId: childB, allowDownload: true, permission: 'CONTRIBUTE' },
      ],
    }).expect(204);
    expect((await mine())[0]?.children.map((c) => c.id)).toEqual([childB]);
    await patch(m.id, { grants: [grant()] }).expect(204);
    expect((await mine())[0]?.children.map((c) => c.id)).toEqual([childA]);
    await patch(m.id, { allowDownload: true }).expect(204);
    expect(
      await prisma.circleGrant.count({
        where: { circleMemberId: m.id, deletedAt: null, allowDownload: true },
      }),
    ).toBe(1);
    await patch(m.id, { allowDownload: false }).expect(204);
    expect(
      await prisma.circleGrant.count({
        where: { circleMemberId: m.id, deletedAt: null, allowDownload: true },
      }),
    ).toBe(0);
    expect(
      await prisma.circleGrant.count({
        where: {
          circleMemberId: m.id,
          status: 'REVOKED',
          deletedAt: { not: null },
        },
      }),
    ).toBe(3);
    await post(`/circle-members/${m.id}/pause`).expect(204);
    expect((await mine())[0]).toMatchObject({
      status: 'PAUSED',
      children: [],
      allowDownload: false,
    });
    await post(`/circle-members/${m.id}/resume`).expect(204);
    expect((await mine())[0]?.status).toBe('ACTIVE');
    await post(`${root}/circle/leave`, {}, relative).expect(204);
    await post(`${root}/circle/leave`, {}, relative).expect(204);
    expect(await mine()).toEqual([]);
    expect(
      (await prisma.circleMember.findUniqueOrThrow({ where: { id: m.id } }))
        .status,
    ).toBe('LEFT');
    expect(
      await prisma.circleGrant.count({
        where: { circleMemberId: m.id, deletedAt: null, status: 'ACTIVE' },
      }),
    ).toBe(0);
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: fid } }))
        .accessVersion,
    ).toBe(before + 7);
  });
  it('rejects revoked/expired credentials and rotates both code and token on renewal, preserving grants', async () => {
    const i = await invite();
    const oldToken = i.url.split('/').pop();
    const renewed = data<CircleCreatedInvite>(
      await post(`/invites/${i.inviteId}/renew`).expect(200),
    );
    expect(renewed.code).not.toBe(i.code);
    expect(renewed.url).not.toBe(i.url);
    await post('/invites/resolve', { code: i.code }).expect(404);
    await post('/invites/accept', { token: oldToken }, third).expect(404);
    expect(
      data<{ children: { id: string }[] }>(
        await post('/invites/resolve', { code: renewed.code }).expect(200),
      ).children.map((c) => c.id),
    ).toEqual([childA]);
    await post(`/invites/${i.inviteId}/revoke`).expect(200);
    expect(error(await accept(renewed, third).expect(409))).toBe(
      'INVITE_ALREADY_USED',
    );
    await post('/invites/resolve', { code: renewed.code }).expect(409);
    const expired = await invite();
    await prisma.familyInvite.update({
      where: { id: expired.inviteId },
      data: { expiresAt: new Date(Date.now() - 1000) },
    });
    expect(error(await accept(expired, third).expect(410))).toBe(
      'INVITE_EXPIRED',
    );
    await post('/invites/resolve', { code: expired.code }).expect(410);
    const listed = data<{
      items: {
        inviteId: string;
        status: string;
        code?: string;
        tokenHash?: unknown;
      }[];
    }>(await get(`${root}/invites/circle`).expect(200)).items;
    expect(listed[0]).toMatchObject({
      inviteId: expired.inviteId,
      status: 'EXPIRED',
    });
    expect(listed[0]).not.toHaveProperty('tokenHash');
    expect(listed[0]).not.toHaveProperty('code');
    await post(`/invites/${expired.inviteId}/renew`).expect(200);
  });
  it('blocks Parent accepting own family Circle invite with 409', async () => {
    const i = await invite();
    expect(error(await accept(i, parentB).expect(409))).toBe(
      'ALREADY_PARENT_OF_FAMILY',
    );
    await accept(i, parent).expect(409);
  });
  it('fails closed for missing capability/quota and enforces reservations under concurrent creates', async () => {
    await changeCatalog(100, false);
    const input = {
      relation: 'OTHER',
      displayName: 'Quota fixture',
      grants: [grant()],
    };
    expect(error(await post(`${root}/invites/circle`, input).expect(402))).toBe(
      'PLAN_REQUIRED_FAMILY',
    );
    await changeCatalog('missing');
    await post(`${root}/invites/circle`, input).expect(402);
    const count = await prisma.circleMember.count({
      where: { familyId: fid, deletedAt: null },
    });
    await changeCatalog(count + 1);
    const results = await Promise.all([
      post(`${root}/invites/circle`, input),
      post(`${root}/invites/circle`, input),
    ]);
    expect(results.map((r) => r.status).sort()).toEqual([201, 422]);
    expect(error(results.find((r) => r.status === 422)!)).toBe(
      'CIRCLE_LIMIT_REACHED',
    );
  });
  it('validates exact grant target, duplicate/null fields, private or unknown subjects and empty updates', async () => {
    const input = {
      relation: 'OTHER',
      displayName: 'Validation fixture',
      grants: [grant()],
    };
    for (const grants of [
      [{ allowDownload: false }],
      [{ childId: childA, pregnancyId: pregnancy, allowDownload: false }],
      [grant(), grant()],
      [{ childId: childA, allowDownload: null }],
    ])
      await post(`${root}/invites/circle`, { ...input, grants }).expect(400);
    for (const overrides of [
      { displayName: ' ' },
      { grants: null },
      { requireFinalApproval: null },
      { relation: 'UNKNOWN' },
      { allowDownload: null },
    ])
      await post(`${root}/invites/circle`, { ...input, ...overrides }).expect(
        400,
      );
    for (const grants of [
      [grant(randomUUID())],
      [{ pregnancyId: privatePregnancy, allowDownload: false }],
    ])
      expect(
        error(
          await post(`${root}/invites/circle`, { ...input, grants }).expect(
            422,
          ),
        ),
      ).toBe('CHILD_NOT_IN_FAMILY');
    const m = (await members()).find((m) => m.userId === relativeB)!;
    await patch(m.id, {}).expect(400);
    await patch(m.id, { grants: [grant(), grant()] }).expect(400);
    await patch(m.id, { grants: [] }).expect(204);
    expect((await mine(relativeB))[0]?.children).toEqual([]);
  });
  it('filters pregnancies that become private after invitation and rechecks at accept/approve', async () => {
    const i = await invite({
      grants: [{ pregnancyId: pregnancy, allowDownload: false }],
    });
    await prisma.pregnancy.update({
      where: { id: pregnancy },
      data: { status: 'ENDED_PRIVATE' },
    });
    try {
      expect(
        data<{ children: unknown[] }>(
          await post('/invites/resolve', { code: i.code }).expect(200),
        ).children,
      ).toEqual([]);
      await accept(i, third).expect(422);
    } finally {
      await prisma.pregnancy.update({
        where: { id: pregnancy },
        data: { status: 'ACTIVE' },
      });
    }
    const approval = await invite({
      requireFinalApproval: true,
      grants: [{ pregnancyId: pregnancy, allowDownload: false }],
    });
    await accept(approval, third).expect(200);
    await prisma.pregnancy.update({
      where: { id: pregnancy },
      data: { status: 'ENDED_PRIVATE' },
    });
    try {
      await post(`/invites/${approval.inviteId}/approve`).expect(422);
    } finally {
      await prisma.pregnancy.update({
        where: { id: pregnancy },
        data: { status: 'ACTIVE' },
      });
    }
  });
  it('rechecks license/capability at accept and approval, and permits self-leave after subscription expiry', async () => {
    const immediate = await invite();
    const approval = await invite({ requireFinalApproval: true });
    await prisma.user.update({
      where: { id: third },
      data: { onboardingRole: null },
    });
    await accept(approval, third).expect(200);
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: third } }))
        .onboardingRole,
    ).toBe('CIRCLE');
    await prisma.familyLicense.update({
      where: { familyId: fid },
      data: { blockReasonCode: 'SYNTHETIC_TEST_BLOCK' },
    });
    try {
      expect(error(await accept(immediate, relative).expect(403))).toBe(
        'LICENSE_BLOCKED',
      );
      expect(
        error(await post(`/invites/${approval.inviteId}/approve`).expect(403)),
      ).toBe('LICENSE_BLOCKED');
      expect((await mine(relativeB))[0]).toMatchObject({
        status: 'PAUSED',
        children: [],
        allowDownload: false,
      });
    } finally {
      await prisma.familyLicense.update({
        where: { familyId: fid },
        data: { blockReasonCode: null },
      });
    }
    await changeCatalog(100, false);
    expect(error(await accept(immediate, relative).expect(402))).toBe(
      'PLAN_REQUIRED_FAMILY',
    );
    expect(
      error(await post(`/invites/${approval.inviteId}/approve`).expect(402)),
    ).toBe('PLAN_REQUIRED_FAMILY');
    await changeCatalog(100);
    await post(`/invites/${approval.inviteId}/approve`).expect(200);
    await prisma.familyEntitlement.update({
      where: { familyId: fid },
      data: { accessPhase: 'EXPIRED', validUntil: new Date(Date.now() - 1000) },
    });
    try {
      expect(error(await accept(immediate, relative).expect(402))).toBe(
        'SUBSCRIPTION_REQUIRED',
      );
      expect((await mine(third))[0]).toMatchObject({
        status: 'PAUSED',
        children: [],
        allowDownload: false,
      });
      await post(`${root}/circle/leave`, {}, third).expect(204);
      expect(await mine(third)).toEqual([]);
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId: fid },
        data: {
          accessPhase: 'PAID',
          validUntil: new Date(Date.now() + 86400000),
        },
      });
    }
  });
  it('does not approve an account that became unavailable while awaiting approval', async () => {
    const i = await invite({ requireFinalApproval: true });
    await accept(i, third).expect(200);
    await prisma.user.update({
      where: { id: third },
      data: { status: 'DELETION_PENDING' },
    });
    try {
      await post(`/invites/${i.inviteId}/approve`).expect(404);
      expect(
        await prisma.circleMember.count({
          where: { familyId: fid, userId: third, deletedAt: null },
        }),
      ).toBe(0);
      await post(`/invites/${i.inviteId}/reject`).expect(200);
    } finally {
      await prisma.user.update({
        where: { id: third },
        data: { status: 'ACTIVE' },
      });
    }
  });
  it('returns an allowlisted overview without private content and soft-removes membership immediately', async () => {
    const overview = data<Record<string, unknown>>(
      await get(`${root}/overview`).expect(200),
    );
    expect(Object.keys(overview).sort()).toEqual(
      ['family', 'parents', 'children', 'circle', 'plan'].sort(),
    );
    // AUTH-04 (BF-20261019-007): no avatar yet → null URL fields.
    const noAvatar = { avatarUrl: null, avatarUrlExpiresAt: null };
    expect(overview.parents).toEqual([
      { userId: parent, callName: 'Papa', ...noAvatar },
      { userId: parentB, callName: 'Mama', ...noAvatar },
    ]);
    expect(overview.family).toEqual({
      id: fid,
      name: 'Synthetic Circle family',
      status: 'ACTIVE',
    });
    for (const key of [
      'mood',
      'journal',
      'conflict',
      'appreciation',
      'request',
      'hearts',
      'body',
      'settings',
    ])
      expect(JSON.stringify(overview)).not.toContain(`"${key}"`);
    const m = (await members()).find((m) => m.userId === waiting)!;
    await http()
      .delete(`/api/v1/circle-members/${m.id}`)
      .set('Authorization', tokens.get(relativeB)!)
      .expect(404);
    await http()
      .delete(`/api/v1/circle-members/${m.id}`)
      .set('Authorization', tokens.get(parent)!)
      .expect(204);
    expect(await mine(waiting)).toEqual([]);
    const row = await prisma.circleMember.findUniqueOrThrow({
      where: { id: m.id },
    });
    expect(row.status).toBe('REMOVED');
    expect(row.endedAt).not.toBeNull();
    expect(row.deletedAt).not.toBeNull();
    expect(
      await prisma.circleGrant.count({
        where: { circleMemberId: m.id, status: 'ACTIVE', deletedAt: null },
      }),
    ).toBe(0);
  });
});
