import { SUBSCRIPTION_REMINDER_SERVICE } from '../../src/interfaces/services/subscription-reminder-service.interface';
import { SUBSCRIPTION_REMINDER_REPOSITORY } from '../../src/interfaces/repositories/subscription-reminder-repository.interface';
import { SubscriptionReminderService } from '../../src/services/subscription-reminder.service';
import { SubscriptionReminderRepository } from '../../src/repositories/subscription-reminder.repository';
import { SafetyController } from '../../src/controllers/safety.controller';
import { SafetyService } from '../../src/services/safety.service';
import { SafetyRepository } from '../../src/repositories/safety.repository';
import { SAFETY_SERVICE } from '../../src/interfaces/services/safety-service.interface';
import { SAFETY_REPOSITORY } from '../../src/interfaces/repositories/safety-repository.interface';
import { BillingCatalogController } from '../../src/controllers/billing-catalog.controller';
import { BILLING_CATALOG_SERVICE } from '../../src/interfaces/services/billing-catalog-service.interface';
import { BillingCatalogService } from '../../src/services/billing-catalog.service';
import { MemoryCapsuleRepository } from '../../src/repositories/memory-capsule.repository';
import { MEMORY_CAPSULE_REPOSITORY } from '../../src/interfaces/repositories/memory-capsule-repository.interface';
import { FamilyCircleRepository } from '../../src/repositories/family-circle.repository';
import { FAMILY_CIRCLE_REPOSITORY } from '../../src/interfaces/repositories/family-circle-repository.interface';
import { FamilyPrivacyRepository } from '../../src/repositories/family-privacy.repository';
import { FAMILY_PRIVACY_REPOSITORY } from '../../src/interfaces/repositories/family-privacy-repository.interface';
import { FamilySettingsRepository } from '../../src/repositories/family-settings.repository';
import { FAMILY_SETTINGS_REPOSITORY } from '../../src/interfaces/repositories/family-settings-repository.interface';
import { FamilyRepository } from '../../src/repositories/family.repository';
import { FAMILY_REPOSITORY } from '../../src/interfaces/repositories/family-repository.interface';
import { WeeklyRecapRepository } from '../../src/repositories/weekly-recap.repository';
import { WEEKLY_RECAP_REPOSITORY } from '../../src/interfaces/repositories/weekly-recap-repository.interface';
import { DataExportRepository } from '../../src/repositories/data-export.repository';
import { DATA_EXPORT_REPOSITORY } from '../../src/interfaces/repositories/data-export-repository.interface';
import { AccountRepository } from '../../src/repositories/account.repository';
import { ACCOUNT_REPOSITORY } from '../../src/interfaces/repositories/account-repository.interface';
import { UserRepository } from '../../src/repositories/user.repository';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import { OnboardingRepository } from '../../src/repositories/onboarding.repository';
import { ONBOARDING_REPOSITORY } from '../../src/interfaces/repositories/onboarding-repository.interface';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';
import { CATALOG_QUERY_REPOSITORY } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import { MediaRepository } from '../../src/repositories/media.repository';
import { MEDIA_REPOSITORY } from '../../src/interfaces/repositories/media-repository.interface';
import { MemoryCapsuleService } from '../../src/services/memory-capsule.service';
import { MEMORY_CAPSULE_SERVICE } from '../../src/interfaces/services/memory-capsule-service.interface';
import { FamilyCircleService } from '../../src/services/family-circle.service';
import { FAMILY_CIRCLE_SERVICE } from '../../src/interfaces/services/family-circle-service.interface';
import { FamilyPrivacyService } from '../../src/services/family-privacy.service';
import { FAMILY_PRIVACY_SERVICE } from '../../src/interfaces/services/family-privacy-service.interface';
import { FamilySettingsService } from '../../src/services/family-settings.service';
import { FAMILY_SETTINGS_SERVICE } from '../../src/interfaces/services/family-settings-service.interface';
import { FamilyService } from '../../src/services/family.service';
import { FAMILY_SERVICE } from '../../src/interfaces/services/family-service.interface';
import { WeeklyRecapService } from '../../src/services/weekly-recap.service';
import { WEEKLY_RECAP_SERVICE } from '../../src/interfaces/services/weekly-recap-service.interface';
import { AuthTokenService } from '../../src/services/auth-token.service';
import { AUTH_TOKEN_SERVICE } from '../../src/interfaces/services/auth-token-service.interface';
import { UserService } from '../../src/services/user.service';
import { USER_SERVICE } from '../../src/interfaces/services/user-service.interface';
import { DataExportService } from '../../src/services/data-export.service';
import { DATA_EXPORT_SERVICE } from '../../src/interfaces/services/data-export-service.interface';
import { OnboardingService } from '../../src/services/onboarding.service';
import { ONBOARDING_SERVICE } from '../../src/interfaces/services/onboarding-service.interface';
import { FamilyBillingService } from '../../src/services/family-billing.service';
import { FAMILY_BILLING_SERVICE } from '../../src/interfaces/services/family-billing-service.interface';
import { MediaService } from '../../src/services/media.service';
import { MemoryLetterController } from '../../src/controllers/memory-letter.controller';
import { CircleController } from '../../src/controllers/circle.controller';
import { FamilyPrivacyController } from '../../src/controllers/family-privacy.controller';
import { FamilySettingsController } from '../../src/controllers/family-settings.controller';
import { FamilyController } from '../../src/controllers/family.controller';
import { WeeklyRecapController } from '../../src/controllers/weekly-recap.controller';
import { UserController } from '../../src/controllers/user.controller';
import { DataExportController } from '../../src/controllers/data-export.controller';
import { FamilyOnboardingController } from '../../src/controllers/family-onboarding.controller';
import { FamilyBillingController } from '../../src/controllers/family-billing.controller';
import { MediaController } from '../../src/controllers/media.controller';
import { MemoryController } from '../../src/controllers/memory.controller';
import { MemoryLibraryController } from '../../src/controllers/memory-library.controller';
import { getStorageToken, ThrottlerStorageService } from '@nestjs/throttler';
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
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MEMORY_LIBRARY_SERVICE } from '../../src/interfaces/services/memory-library-service.interface';
import { MemoryLibraryService } from '../../src/services/memory-library.service';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';

describe('Subscription allowlist API (focused module + PostgreSQL)', () => {
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
    hiddenChildId = randomUUID();
  const sharedId = randomUUID(),
    privateId = randomUUID(),
    parentsId = randomUUID(),
    hiddenId = randomUUID();
  const assetId = randomUUID();
  const storage = {
    bucketOf: () => 'media',
    createDownloadUrl: jest.fn(
      (input: { key: string; expiresInSeconds: number }) =>
        Promise.resolve({
          url: `https://storage.invalid/${input.key}`,
          expiresAt: new Date(Date.now() + input.expiresInSeconds * 1000),
        }),
    ),
  };
  const root = `/api/v1/families/${familyId}`;

  beforeAll(async () => {
    if (
      !new URL(process.env.DATABASE_URL ?? '').pathname.endsWith(
        '/baby_family_test',
      )
    )
      throw new Error('Requires *_test database');
    keys = await generateKeyPair('ES256', { extractable: true });
    config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
      AUTH_SECRET_PEPPER: randomBytes(32).toString('base64'),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [
        SafetyController,
        BillingCatalogController,
        MemoryLibraryController,
        MemoryController,
        MediaController,
        FamilyBillingController,
        FamilyOnboardingController,
        DataExportController,
        UserController,
        WeeklyRecapController,
        FamilyController,
        FamilySettingsController,
        FamilyPrivacyController,
        CircleController,
        MemoryLetterController,
      ],
      providers: [
        PrismaService,
        {
          provide: SUBSCRIPTION_REMINDER_SERVICE,
          useClass: SubscriptionReminderService,
        },
        {
          provide: SUBSCRIPTION_REMINDER_REPOSITORY,
          useClass: SubscriptionReminderRepository,
        },
        { provide: SAFETY_SERVICE, useClass: SafetyService },
        { provide: SAFETY_REPOSITORY, useClass: SafetyRepository },
        { provide: BILLING_CATALOG_SERVICE, useClass: BillingCatalogService },
        { provide: getStorageToken(), useClass: ThrottlerStorageService },
        AccessTokenGuard,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: MEMORY_LIBRARY_SERVICE, useClass: MemoryLibraryService },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        { provide: MEDIA_SERVICE, useClass: MediaService },
        { provide: FAMILY_BILLING_SERVICE, useClass: FamilyBillingService },
        { provide: ONBOARDING_SERVICE, useClass: OnboardingService },
        { provide: DATA_EXPORT_SERVICE, useClass: DataExportService },
        { provide: USER_SERVICE, useClass: UserService },
        { provide: AUTH_TOKEN_SERVICE, useClass: AuthTokenService },
        { provide: WEEKLY_RECAP_SERVICE, useClass: WeeklyRecapService },
        { provide: FAMILY_SERVICE, useClass: FamilyService },
        { provide: FAMILY_SETTINGS_SERVICE, useClass: FamilySettingsService },
        { provide: FAMILY_PRIVACY_SERVICE, useClass: FamilyPrivacyService },
        { provide: FAMILY_CIRCLE_SERVICE, useClass: FamilyCircleService },
        { provide: MEMORY_CAPSULE_SERVICE, useClass: MemoryCapsuleService },
        { provide: MEDIA_REPOSITORY, useClass: MediaRepository },
        { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
        { provide: ONBOARDING_REPOSITORY, useClass: OnboardingRepository },
        { provide: USER_REPOSITORY, useClass: UserRepository },
        { provide: ACCOUNT_REPOSITORY, useClass: AccountRepository },
        { provide: DATA_EXPORT_REPOSITORY, useClass: DataExportRepository },
        { provide: WEEKLY_RECAP_REPOSITORY, useClass: WeeklyRecapRepository },
        { provide: FAMILY_REPOSITORY, useClass: FamilyRepository },
        {
          provide: FAMILY_SETTINGS_REPOSITORY,
          useClass: FamilySettingsRepository,
        },
        {
          provide: FAMILY_PRIVACY_REPOSITORY,
          useClass: FamilyPrivacyRepository,
        },
        { provide: FAMILY_CIRCLE_REPOSITORY, useClass: FamilyCircleRepository },
        {
          provide: MEMORY_CAPSULE_REPOSITORY,
          useClass: MemoryCapsuleRepository,
        },
        { provide: OBJECT_STORAGE_SERVICE, useValue: storage },
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
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
      },
    });
  });
  beforeAll(async () => {
    await prisma.child.createMany({
      data: [childId, hiddenChildId].map((id, index) => ({
        id,
        familyId,
        birthDate: new Date('2025-01-01'),
        nickname: 'Synthetic',
        colorIndex: index + 1,
        createdBy: parent,
      })),
    });
    const member = await prisma.circleMember.findFirstOrThrow({
      where: { familyId, userId: circle },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
    for (const [id, visibility, child] of [
      [sharedId, 'FAMILY', childId],
      [privateId, 'PRIVATE', childId],
      [parentsId, 'PARENTS', childId],
      [hiddenId, 'FAMILY', hiddenChildId],
    ] as const) {
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: 'DIARY',
          body: 'Synthetic',
          visibility,
          status: 'PUBLISHED',
          occurredAt: new Date(),
          occurredLocalDate: new Date(),
          publishedAt: new Date(),
        },
      });
      await prisma.memoryChild.create({
        data: { memoryId: id, familyId, childId: child, ageMonth: 12 },
      });
    }
    await prisma.asset.create({
      data: {
        id: assetId,
        familyId,
        uploaderUserId: parent,
        kind: 'IMAGE',
        status: 'READY',
        storageKey: `fam/${familyId}/raw`,
        storageBucket: 'bf-media',
        mime: 'image/jpeg',
        declaredSize: 100n,
        sizeBytes: 100n,
        keepOriginal: true,
      },
    });
    await prisma.assetVariant.create({
      data: {
        familyId,
        assetId,
        variantCode: 'orig',
        storageBucket: 'bf-media',
        storageKey: `fam/${familyId}/clean-original.jpg`,
        mime: 'image/jpeg',
        sizeBytes: 100n,
      },
    });
    await prisma.memoryAsset.create({
      data: {
        familyId,
        memoryId: sharedId,
        assetId,
        sortOrder: 0,
        isCover: true,
      },
    });
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.exportJob.updateMany({
          where: { familyId, status: { in: ['QUEUED', 'PROCESSING'] } },
          data: { status: 'FAILED' },
        });
        await prisma.userSession.updateMany({
          where: { userId: { in: [parent, parentB, circle, outsider] } },
          data: { revokedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { status: 'DELETED', deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: [parent, parentB, circle, outsider] } },
          data: { status: 'DELETED', deletedAt: new Date() },
        });
      }
    } finally {
      await app?.close();
    }
  });
  const http = (
    method: 'get' | 'post' | 'put' | 'delete' | 'patch',
    path: string,
    who = parent,
  ) => {
    const client = request(app.getHttpServer());
    return client[method](path).set('Authorization', tokens.get(who)!);
  };

  beforeEach(async () => {
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'ACTIVE' },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'EXPIRED',
        validUntil: new Date(Date.now() - 60000),
      },
    });
    await prisma.familyLicense.updateMany({
      where: { familyId },
      data: { blockedAt: null, blockReasonCode: null },
    });
  });
  it.each(['EXPIRED', 'BLOCKED'] as const)(
    'preserves the Parent data/safety allowlist for %s',
    async (phase) => {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase: phase },
      });
      await http('get', root + '/bootstrap').expect(200);
      const billing = await http('get', root + '/billing').expect(200);
      expect(billing.body).toMatchObject({
        data: {
          accessPhase: phase,
          statusBanner: {
            kind: phase,
            remainingSeconds: 0,
            dismissible: false,
          },
        },
      });
      await http('get', '/api/v1/billing/plans').expect(200);
      await http('get', `/api/v1/me/drafts?familyId=${familyId}`).expect(200);
      await http('get', '/api/v1/me').expect(200);
      await http('post', '/api/v1/reports')
        .send({
          familyId,
          targetType: 'USER',
          targetId: circle,
          reason: 'OTHER',
        })
        .expect(201);
      await http('get', root + '/media-grid').expect(200);
      await http('get', `/api/v1/memories/${sharedId}`).expect(200);
      await http('post', `/api/v1/memories/${sharedId}/download-urls`).expect(
        200,
      );
      const exporter = phase === 'BLOCKED' ? parentB : parent;
      const created = await http('post', '/api/v1/exports', exporter)
        .send({ scope: 'FAMILY', familyId })
        .expect(201);
      const exported = (created.body as { data: { id: string } }).data;
      await http('get', `/api/v1/exports/${exported.id}`, exporter).expect(200);
      await http('get', `/api/v1/memories/${privateId}`, parentB).expect(404);
      await http('get', `/api/v1/memories/${sharedId}`, outsider).expect(404);
    },
  );
  it.each(['EXPIRED', 'BLOCKED'] as const)(
    'denies business reads/writes and pauses Circle for %s',
    async (phase) => {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase: phase },
      });
      const status = phase === 'BLOCKED' ? 403 : 402;
      const code =
        phase === 'BLOCKED' ? 'LICENSE_BLOCKED' : 'SUBSCRIPTION_REQUIRED';
      for (const path of [
        root,
        root + '/feed',
        root + '/timeline',
        root + '/search?q=synthetic',
        root + '/on-this-day',
        root + '/favorites',
        root + '/settings',
        root + '/privacy-overview',
        root + '/overview',
        root + '/circle',
        root + '/invites/circle',
        root + '/invites/partner',
        root + '/recaps/weekly',
        root + '/home/week-stats',
        `/api/v1/children/${childId}/letters`,
      ]) {
        const res = await http('get', path).expect(status);
        expect(res.body).toMatchObject({ error: { code } });
      }
      for (const [path, body] of [
        [root, { name: 'Denied' }],
        [root + '/settings', { requireCircleReview: true }],
      ] as const) {
        const res = await http('patch', path).send(body).expect(status);
        expect(res.body).toMatchObject({ error: { code } });
      }
      const invite = await http('post', root + '/invites/partner')
        .send({})
        .expect(status);
      expect(invite.body).toMatchObject({ error: { code } });
      const blocked = await http('post', '/api/v1/blocks')
        .send({ familyId, userId: circle })
        .expect(status);
      expect(blocked.body).toMatchObject({ error: { code } });
      const unblocked = await http(
        'delete',
        `/api/v1/blocks/${circle}?familyId=${familyId}`,
      ).expect(status);
      expect(unblocked.body).toMatchObject({ error: { code } });
      const before = await prisma.memory.count({ where: { familyId } });
      const res = await http('post', '/api/v1/memories')
        .set('Idempotency-Key', randomUUID())
        .send({
          familyId,
          kind: 'DIARY',
          visibility: 'PARENTS',
          body: 'Denied',
          occurredAt: new Date().toISOString(),
          childIds: [childId],
        })
        .expect(status);
      expect(res.body).toMatchObject({ error: { code } });
      expect(await prisma.memory.count({ where: { familyId } })).toBe(before);
      for (const path of [
        root + '/media-grid',
        root + '/feed',
        root + '/settings',
        `/api/v1/memories/${sharedId}`,
      ]) {
        const paused = await http('get', path, circle).expect(403);
        expect(paused.body).toMatchObject({ error: { code: 'CIRCLE_PAUSED' } });
      }
      const paused = await http(
        'post',
        `/api/v1/memories/${sharedId}/download-urls`,
        circle,
      ).expect(403);
      expect(paused.body).toMatchObject({ error: { code: 'CIRCLE_PAUSED' } });
    },
  );
  it('preserves data download while an active paid license is blocked', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'PAID',
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    await prisma.familyLicense.updateMany({
      where: { familyId },
      data: { blockedAt: new Date(), blockReasonCode: 'SPEC_BLOCK' },
    });
    await http('get', root + '/media-grid').expect(200);
    await http('get', `/api/v1/memories/${sharedId}`).expect(200);
    await http('post', `/api/v1/memories/${sharedId}/download-urls`).expect(
      200,
    );
    await prisma.exportJob.updateMany({
      where: { familyId, requesterId: parent, status: 'QUEUED' },
      data: { status: 'FAILED' },
    });
    const created = await http('post', '/api/v1/exports')
      .send({ scope: 'FAMILY', familyId })
      .expect(201);
    await http(
      'get',
      `/api/v1/exports/${(created.body as { data: { id: string } }).data.id}`,
    ).expect(200);
    const denied = await http('get', root + '/feed').expect(403);
    expect(denied.body).toMatchObject({ error: { code: 'LICENSE_BLOCKED' } });
    await http('get', root + '/media-grid', circle).expect(403);
  });
  it('does not reopen expired business reads after scheduling deletion', async () => {
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'DELETION_SCHEDULED' },
    });
    await http('get', root + '/media-grid').expect(200);
    await http('get', `/api/v1/memories/${sharedId}`).expect(200);
    const denied = await http('get', root + '/feed').expect(402);
    expect(denied.body).toMatchObject({
      error: { code: 'SUBSCRIPTION_REQUIRED' },
    });
    await http('get', root + '/media-grid', circle).expect(403);
  });
  it('checks clock expiry immediately before cron recomputation', async () => {
    for (const phase of ['TRIAL', 'PAID'] as const) {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase: phase, trialEndsAt: new Date(Date.now() - 60000) },
      });
      await http('get', root + '/media-grid').expect(200);
      await http('get', `/api/v1/memories/${sharedId}`).expect(200);
      const denied = await http('get', root + '/feed').expect(402);
      expect(denied.body).toMatchObject({
        error: { code: 'SUBSCRIPTION_REQUIRED' },
      });
    }
  });
  it('keeps partner invitations available after PARTNER_LEFT despite the expired entitlement', async () => {
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'PARTNER_LEFT' },
    });
    await prisma.familyParent.updateMany({
      where: { familyId, userId: parentB },
      data: { leftAt: new Date() },
    });
    const created = await http('post', root + '/invites/partner')
      .send({})
      .expect(201);
    expect(
      (created.body as { data: { inviteId: string } }).data.inviteId,
    ).toBeTruthy();
    await http('get', root + '/invites/partner').expect(200);
  });
});
