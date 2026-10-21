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
import { TimezoneCatalogController } from '../../src/controllers/timezone-catalog.controller';
import { TimezoneCatalogService } from '../../src/services/timezone-catalog.service';
import { TIMEZONE_CATALOG_SERVICE } from '../../src/interfaces/services/timezone-catalog-service.interface';
import { FamilyController } from '../../src/controllers/family.controller';
import { FamilyService } from '../../src/services/family.service';
import { FAMILY_SERVICE } from '../../src/interfaces/services/family-service.interface';
import { FamilyRepository } from '../../src/repositories/family.repository';
import { FAMILY_REPOSITORY } from '../../src/interfaces/repositories/family-repository.interface';
import {
  TIMEZONE_IDS,
  isCatalogTimezone,
} from '../../src/config/timezone-catalog';
import type { TimezoneCatalogResponseDto } from '../../src/dto/catalog/timezone-catalog.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Timezone catalog API (focused module + PostgreSQL)', () => {
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
  const url = `/api/v1/families/${familyId}`;

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
      controllers: [
        FamilySettingsController,
        FamilyController,
        TimezoneCatalogController,
      ],
      providers: [
        PrismaService,
        { provide: TIMEZONE_CATALOG_SERVICE, useClass: TimezoneCatalogService },
        { provide: FAMILY_SERVICE, useClass: FamilyService },
        { provide: FAMILY_REPOSITORY, useClass: FamilyRepository },
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

  it('returns a versioned IANA catalog with localized labels and current signed offsets', async () => {
    const list = async (locale: string) =>
      data<TimezoneCatalogResponseDto>(
        await request(app.getHttpServer())
          .get(`/api/v1/catalog/timezones?locale=${locale}`)
          .expect(200),
      );
    const vi = await list('vi'),
      en = await list('en');
    expect(vi.version).toBe('1');
    expect(vi.items.map((item) => item.id)).toEqual(TIMEZONE_IDS);
    expect(new Set(vi.items.map((item) => item.id)).size).toBe(vi.items.length);
    expect(vi.items.every((item) => isCatalogTimezone(item.id))).toBe(true);
    expect(
      vi.items.find((item) => item.id === 'Asia/Ho_Chi_Minh'),
    ).toMatchObject({ offsetMinutes: 420 });
    expect(vi.items.find((item) => item.id === 'UTC')).toMatchObject({
      offsetMinutes: 0,
    });
    expect(vi.items[0]?.label).not.toBe(en.items[0]?.label);
    const ny = en.items.find((item) => item.id === 'America/New_York')!;
    const parts = new Intl.DateTimeFormat('en', {
      timeZone: ny.id,
      timeZoneName: 'longOffset',
    }).formatToParts(new Date());
    expect(['GMT-04:00', 'GMT-05:00']).toContain(
      parts.find((part) => part.type === 'timeZoneName')?.value,
    );
    expect([-240, -300]).toContain(ny.offsetMinutes);
    await request(app.getHttpServer())
      .get('/api/v1/catalog/timezones?locale=ja')
      .expect(400);
    expect(
      data<TimezoneCatalogResponseDto>(
        await request(app.getHttpServer())
          .get('/api/v1/catalog/timezones')
          .expect(200),
      ).items[0]?.label,
    ).toBe(vi.items[0]?.label);
  });

  it('uses the same timezone validator for the existing Parent family PATCH and persists valid values', async () => {
    for (const timezone of ['Asia/Ho_Chi_Minh', 'America/New_York', 'UTC']) {
      expect(
        data<{ timezone: string }>(await patch({ timezone }).expect(200))
          .timezone,
      ).toBe(timezone);
      expect(
        (await prisma.family.findUniqueOrThrow({ where: { id: familyId } }))
          .timezone,
      ).toBe(timezone);
    }
    for (const timezone of [
      'Invalid/Zone',
      '+07:00',
      '-05:00',
      'EST',
      '',
      null,
    ])
      await patch({ timezone }).expect(400);
    await patch({ timezone: 'Asia/Tokyo' }, circle).expect(404);
    await patch({ timezone: 'Asia/Tokyo' }, outsider).expect(404);
    await request(app.getHttpServer())
      .patch(url)
      .send({ timezone: 'UTC' })
      .expect(401);
    expect(data<{ timezone: string }>(await get().expect(200)).timezone).toBe(
      'UTC',
    );
  });
});
