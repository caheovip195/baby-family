import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
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
import { FamilyPrivacyController } from '../../src/controllers/family-privacy.controller';
import { FamilyPrivacyService } from '../../src/services/family-privacy.service';
import { FamilyPrivacyRepository } from '../../src/repositories/family-privacy.repository';
import { FAMILY_PRIVACY_SERVICE } from '../../src/interfaces/services/family-privacy-service.interface';
import { FAMILY_PRIVACY_REPOSITORY } from '../../src/interfaces/repositories/family-privacy-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type { FamilyPrivacyOverview } from '../../src/interfaces/services/family-privacy-service.interface';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Family privacy API (focused module + PostgreSQL)', () => {
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
  const url = `/api/v1/families/${familyId}/privacy-overview`;

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test database');
    keys = await generateKeyPair('ES256', { extractable: true });
    config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [FamilyPrivacyController],
      providers: [
        PrismaService,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: FAMILY_PRIVACY_SERVICE, useClass: FamilyPrivacyService },
        {
          provide: FAMILY_PRIVACY_REPOSITORY,
          useClass: FamilyPrivacyRepository,
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
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `PRIVACY_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic privacy' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: {},
        features: {},
        availableFrom: new Date(),
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'TRIAL',
        effectivePlanVersionId: version.id,
        trialEndsAt: new Date(Date.now() + 86400000),
        validUntil: new Date(Date.now() + 86400000),
      },
    });
  });
  afterAll(async () => {
    await app?.close();
  });
  const get = (who = parent) =>
    request(app.getHttpServer())
      .get(url)
      .set('Authorization', tokens.get(who)!);
  it('permits only current Parents with an active trial entitlement', async () => {
    await get().expect(200);
    await get(parentB).expect(200);
    const denied = await get(circle).expect(403);
    expect((denied.body as { error: { code: string } }).error.code).toBe(
      'PARENT_REQUIRED',
    );
    await get(outsider).expect(404);
    await request(app.getHttpServer()).get(url).expect(401);
    await request(app.getHttpServer())
      .get('/api/v1/families/not-a-uuid/privacy-overview')
      .set('Authorization', tokens.get(parent)!)
      .expect(400);
  });
  it('projects safe defaults and no private content', async () => {
    const result = data<FamilyPrivacyOverview>(await get().expect(200));
    expect(result.defaults).toEqual({
      defaultVisibility: null,
      requireCircleReview: true,
      circleCanSeeTree: false,
    });
    expect(result.circle).toHaveLength(1);
    expect(result.circle[0]).toMatchObject({
      displayName: 'Synthetic Circle',
      relation: 'OTHER',
      status: 'ACTIVE',
      grants: [],
    });
    expect(result.pendingInvites).toBe(0);
    expect(result.blockedCount).toBe(0);
    expect(result.dataExport).toBeNull();
    expect(result.deletion.status).toBe('NONE');
    expect(result.papaMamaPrivate.excludedFromCircle).toBe(true);
    expect(result.papaMamaPrivate.excludedFromFamilyExport).toBe(true);
    expect(result).not.toHaveProperty('journal');
  });
  it('counts only active family metadata and selects my latest export, omitting storage keys', async () => {
    const member = await prisma.circleMember.findFirstOrThrow({
      where: { familyId, userId: circle },
    });
    const child = await prisma.child.create({
      data: {
        familyId,
        nickname: 'Synthetic child',
        createdBy: parent,
        birthDate: new Date('2025-01-01'),
        colorIndex: 1,
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId: child.id,
        createdBy: parent,
        permission: 'CONTRIBUTE',
        allowDownload: true,
      },
    });
    for (const [status, future] of [
      ['PENDING', true],
      ['AWAITING_APPROVAL', true],
      ['PENDING', false],
      ['REVOKED', true],
    ] as const) {
      await prisma.familyInvite.create({
        data: {
          familyId,
          type: 'CIRCLE',
          inviterUserId: parent,
          status,
          tokenHash: randomBytes(32),
          codeHash: randomBytes(32),
          payload: {},
          expiresAt: new Date(Date.now() + (future ? 86400000 : -86400000)),
        },
      });
    }
    await prisma.block.create({
      data: { familyId, blockerUserId: parent, blockedUserId: circle },
    });
    await prisma.block.create({
      data: { familyId, blockerUserId: parentB, blockedUserId: circle },
    });
    const job = await prisma.exportJob.create({
      data: {
        familyId,
        requesterId: parent,
        scope: 'FAMILY',
        status: 'COMPLETED',
        storageKey: 'secret-storage-key',
        completedAt: new Date(),
        createdAt: new Date(Date.now() - 1000),
      },
    });
    await prisma.exportJob.create({
      data: {
        familyId,
        requesterId: parentB,
        scope: 'FAMILY',
        status: 'QUEUED',
      },
    });
    await prisma.family.update({
      where: { id: familyId },
      data: {
        settings: {
          defaultVisibility: 'PARENTS',
          requireCircleReview: false,
          circleCanSeeTree: true,
          futureSecret: 'never expose',
        },
      },
    });
    const result = data<FamilyPrivacyOverview>(await get().expect(200));
    expect(result.pendingInvites).toBe(2);
    expect(result.blockedCount).toBe(1);
    expect(result.circle[0]?.grants).toEqual([
      { childId: child.id, permission: 'CONTRIBUTE', allowDownload: true },
    ]);
    expect(result.dataExport?.id).toBe(job.id);
    expect(result.dataExport).not.toHaveProperty('storageKey');
    expect(result.defaults).toEqual({
      defaultVisibility: 'PARENTS',
      requireCircleReview: false,
      circleCanSeeTree: true,
    });
    await prisma.circleMember.update({
      where: { id: member.id },
      data: { status: 'PAUSED' },
    });
    expect(
      data<FamilyPrivacyOverview>(await get().expect(200)).circle[0]?.status,
    ).toBe('PAUSED');
    await prisma.child.update({
      where: { id: child.id },
      data: { deletedAt: new Date() },
    });
    expect(
      data<FamilyPrivacyOverview>(await get().expect(200)).circle[0]?.grants,
    ).toEqual([]);
    await prisma.familyInvite.updateMany({
      where: { familyId },
      data: { deletedAt: new Date() },
    });
    await prisma.block.updateMany({
      where: { familyId, blockerUserId: parent },
      data: { deletedAt: new Date() },
    });
    expect(data<FamilyPrivacyOverview>(await get().expect(200))).toMatchObject({
      pendingInvites: 0,
      blockedCount: 0,
    });
  });
  it('projects deletion state and retains Parent access while scheduled, denies former Parents', async () => {
    const deletion = await prisma.familyDeletionRequest.create({
      data: {
        familyId,
        requestedBy: parent,
        steps: { policyVersion: 1, graceDays: 30 },
      },
    });
    expect(
      data<FamilyPrivacyOverview>(await get().expect(200)).deletion,
    ).toMatchObject({ status: 'AWAITING_PARTNER', requestedBy: parent });
    const scheduledFor = new Date(Date.now() + 86400000);
    await prisma.familyDeletionRequest.update({
      where: { id: deletion.id },
      data: { status: 'SCHEDULED', executeAfter: scheduledFor },
    });
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'DELETION_SCHEDULED' },
    });
    expect(
      data<FamilyPrivacyOverview>(await get().expect(200)).deletion,
    ).toMatchObject({
      status: 'SCHEDULED',
      scheduledFor: scheduledFor.toISOString(),
    });
    await prisma.familyDeletionRequest.update({
      where: { id: deletion.id },
      data: { status: 'CANCELLED', cancelledAt: new Date() },
    });
    expect(
      data<FamilyPrivacyOverview>(await get().expect(200)).deletion.status,
    ).toBe('CANCELLED');
    await prisma.familyParent.updateMany({
      where: { familyId, userId: parentB },
      data: { status: 'LEFT', leftAt: new Date() },
    });
    await get(parentB).expect(403);
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'PARTNER_LEFT' },
    });
    await get().expect(200);
  });
  it('rejects expired family reads outside the allowlist', async () => {
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'ACTIVE' },
    });
    await prisma.familyParent.updateMany({
      where: { familyId, userId: parentB },
      data: { status: 'ACTIVE', leftAt: null },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'EXPIRED' },
    });
    try {
      const denied = await get().expect(402);
      expect((denied.body as { error: { code: string } }).error.code).toBe(
        'SUBSCRIPTION_REQUIRED',
      );
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase: 'TRIAL' },
      });
    }
  });
});
