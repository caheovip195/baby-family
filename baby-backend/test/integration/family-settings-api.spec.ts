import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
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
import { FamilySettingsController } from '../../src/controllers/family-settings.controller';
import { FamilySettingsService } from '../../src/services/family-settings.service';
import { FamilySettingsRepository } from '../../src/repositories/family-settings.repository';
import { FAMILY_SETTINGS_SERVICE } from '../../src/interfaces/services/family-settings-service.interface';
import { FAMILY_SETTINGS_REPOSITORY } from '../../src/interfaces/repositories/family-settings-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type { FamilySettingsResponseDto } from '../../src/dto/family/family-settings.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Family settings API (focused module + PostgreSQL)', () => {
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
  const url = `/api/v1/families/${familyId}/settings`;

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
      controllers: [FamilySettingsController],
      providers: [
        PrismaService,
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: FAMILY_SETTINGS_SERVICE, useClass: FamilySettingsService },
        {
          provide: FAMILY_SETTINGS_REPOSITORY,
          useClass: FamilySettingsRepository,
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
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
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
  const patch = (input: object, who = parent) =>
    request(app.getHttpServer())
      .patch(url)
      .set('Authorization', tokens.get(who)!)
      .send(input);

  it('returns Parent defaults and Circle only showLunar; strangers get 404 and missing auth 401', async () => {
    expect(data(await get().expect(200))).toEqual({
      showLunar: true,
      circleCanSeeTree: false,
      defaultVisibility: null,
      requireCircleReview: true,
      traditionalUseLunar: false,
      milestoneSuggestions: true,
    });
    expect(data(await get(circle).expect(200))).toEqual({ showLunar: true });
    await get(outsider).expect(404);
    await request(app.getHttpServer()).get(url).expect(401);
  });

  it('rejects unknown keys, wrong types, invalid visibility, empty updates and Circle PATCH', async () => {
    for (const input of [
      { unknown: true },
      { showLunar: 'false' },
      { showLunar: null },
      { defaultVisibility: 'PUBLIC' },
      { defaultVisibility: false },
      {},
    ])
      await patch(input).expect(400);
    const denied = await patch({ showLunar: false }, circle).expect(403);
    expect((denied.body as { error: { code: string } }).error.code).toBe(
      'PARENT_REQUIRED',
    );
    await patch({ showLunar: false }, outsider).expect(404);
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'family.settings.changed' },
      }),
    ).toBe(0);
  });

  it('merges settings without dropping existing or future keys and emits a transactional outbox event', async () => {
    await prisma.family.update({
      where: { id: familyId },
      data: {
        settings: {
          showLunar: true,
          circleCanSeeTree: false,
          defaultVisibility: null,
          requireCircleReview: true,
          traditionalUseLunar: false,
          milestoneSuggestions: true,
          futureSetting: { retained: true },
        },
      },
    });
    const response = data<FamilySettingsResponseDto>(
      await patch({ showLunar: false, defaultVisibility: 'PARENTS' }).expect(
        200,
      ),
    );
    expect(response).toMatchObject({
      showLunar: false,
      defaultVisibility: 'PARENTS',
      requireCircleReview: true,
      milestoneSuggestions: true,
    });
    expect(response).not.toHaveProperty('futureSetting');
    const row = await prisma.family.findUniqueOrThrow({
      where: { id: familyId },
    });
    expect(row.settings).toMatchObject({
      futureSetting: { retained: true },
      showLunar: false,
      defaultVisibility: 'PARENTS',
    });
    const events = await prisma.outboxEvent.findMany({
      where: {
        familyId,
        eventType: 'family.settings.changed',
        deletedAt: null,
      },
    });
    expect(events).toHaveLength(1);
    expect(events[0]?.payload).toEqual({
      familyId,
      keys: ['defaultVisibility', 'showLunar'],
    });
    expect(data(await get(circle).expect(200))).toEqual({ showLunar: false });
  });

  it('accepts each supported default visibility and null, preserving independent concurrent keys', async () => {
    for (const value of ['PRIVATE', 'PARENTS', 'FAMILY', null])
      expect(
        data<FamilySettingsResponseDto>(
          await patch({ defaultVisibility: value }).expect(200),
        ).defaultVisibility,
      ).toBe(value);
    await Promise.all([
      patch({ traditionalUseLunar: true }).expect(200),
      patch({ milestoneSuggestions: false }).expect(200),
    ]);
    expect(data(await get().expect(200))).toMatchObject({
      traditionalUseLunar: true,
      milestoneSuggestions: false,
      defaultVisibility: null,
    });
  });

  it('bumps accessVersion only when Circle tree permission changes and blocks inactive writes', async () => {
    const before = await prisma.family.findUniqueOrThrow({
      where: { id: familyId },
    });
    await patch({ circleCanSeeTree: true }).expect(200);
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: familyId } }))
        .accessVersion,
    ).toBe(before.accessVersion + 1);
    await patch({ circleCanSeeTree: true }).expect(200);
    expect(
      (await prisma.family.findUniqueOrThrow({ where: { id: familyId } }))
        .accessVersion,
    ).toBe(before.accessVersion + 1);
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'PARTNER_LEFT' },
    });
    const inactive = await patch({ showLunar: true }).expect(403);
    expect((inactive.body as { error: { code: string } }).error.code).toBe(
      'FAMILY_NOT_ACTIVE',
    );
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
    await patch({ showLunar: true }).expect(402);
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'PAID',
        validUntil: new Date(Date.now() + 86400000),
      },
    });
  });

  it('blocks membership immediately when Circle is paused or removed', async () => {
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { status: 'PAUSED' },
    });
    await get(circle).expect(403);
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { status: 'REMOVED', endedAt: new Date(), deletedAt: new Date() },
    });
    await get(circle).expect(403);
  });
  it('rejects expired family reads and writes outside the allowlist', async () => {
    await prisma.circleMember.updateMany({
      where: { familyId, userId: circle },
      data: { status: 'ACTIVE', endedAt: null, deletedAt: null },
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
      const writeDenied = await patch({ showLunar: true }).expect(402);
      expect((writeDenied.body as { error: { code: string } }).error.code).toBe(
        'SUBSCRIPTION_REQUIRED',
      );
      const circleDenied = await get(circle).expect(403);
      expect(
        (circleDenied.body as { error: { code: string } }).error.code,
      ).toBe('CIRCLE_PAUSED');
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase: 'PAID' },
      });
    }
  });
});
