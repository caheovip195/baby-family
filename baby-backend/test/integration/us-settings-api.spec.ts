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
import { UsSettingsController } from '../../src/controllers/us-settings.controller';
import { UsSettingsService } from '../../src/services/us-settings.service';
import { UsSettingsRepository } from '../../src/repositories/us-settings.repository';
import { US_SETTINGS_SERVICE } from '../../src/interfaces/services/us-settings-service.interface';
import { US_SETTINGS_REPOSITORY } from '../../src/interfaces/repositories/us-settings-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type { UsSettingsResponseDto } from '../../src/dto/us-settings/us-settings.dto';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Papa & Mama settings API (focused module + PostgreSQL)', () => {
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
  const url = '/api/v1/me/us-settings';

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    keys = await generateKeyPair('ES256', { extractable: true });
    config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [UsSettingsController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: ConfigService, useValue: config },
        { provide: US_SETTINGS_SERVICE, useClass: UsSettingsService },
        {
          provide: US_SETTINGS_REPOSITORY,
          useClass: UsSettingsRepository,
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
      await prisma.userSetting.create({ data: { userId } });
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
        features: {},
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

  it('returns only the caller settings and requires authentication', async () => {
    expect(data(await get().expect(200))).toEqual({
      usLockEnabled: false,
      moodShareDefault: 'ASK',
      requestSoonBypassQuiet: false,
      hideSensitivePreview: true,
    });
    await request(app.getHttpServer()).get(url).expect(401);
  });

  it('blocks Circle, outsiders and inactive parents', async () => {
    for (const userId of [circle, outsider]) {
      for (const response of [
        await get(userId).expect(403),
        await patch({ usLockEnabled: true }, userId).expect(403),
      ]) {
        expect((response.body as { error: { code: string } }).error.code).toBe(
          'PARENT_REQUIRED',
        );
      }
    }
    await prisma.familyParent.updateMany({
      where: { familyId, userId: parentB },
      data: { status: 'LEFT', leftAt: new Date() },
    });
    await get(parentB).expect(403);
    await prisma.familyParent.updateMany({
      where: { familyId, userId: parentB },
      data: { status: 'ACTIVE', leftAt: null },
    });
  });

  it('updates exactly the caller row and preserves unrelated and partner settings', async () => {
    await prisma.userSetting.update({
      where: { userId: parent },
      data: { theme: 'DARK' },
    });
    const partnerBefore = await prisma.userSetting.findUniqueOrThrow({
      where: { userId: parentB },
    });
    expect(
      data(
        await patch({
          usLockEnabled: true,
          moodShareDefault: 'NEVER',
          requestSoonBypassQuiet: true,
          hideSensitivePreview: false,
        }).expect(200),
      ),
    ).toEqual({
      usLockEnabled: true,
      moodShareDefault: 'NEVER',
      requestSoonBypassQuiet: true,
      hideSensitivePreview: false,
    });
    expect(
      await prisma.userSetting.findUniqueOrThrow({
        where: { userId: parentB },
      }),
    ).toEqual(partnerBefore);
    expect(
      (
        await prisma.userSetting.findUniqueOrThrow({
          where: { userId: parent },
        })
      ).theme,
    ).toBe('DARK');
    for (const moodShareDefault of ['ASK', 'ALWAYS', 'NEVER']) {
      expect(
        data<UsSettingsResponseDto>(
          await patch({ moodShareDefault }).expect(200),
        ).moodShareDefault,
      ).toBe(moodShareDefault);
    }
    await Promise.all([
      patch({ usLockEnabled: false }).expect(200),
      patch({ requestSoonBypassQuiet: false }).expect(200),
    ]);
    expect(data(await get().expect(200))).toMatchObject({
      usLockEnabled: false,
      requestSoonBypassQuiet: false,
    });
  });

  it('rejects empty, unknown, identity injection, null and incorrect types', async () => {
    for (const input of [
      {},
      { userId: parentB, usLockEnabled: true },
      { familyId, usLockEnabled: true },
      { unknown: true },
      { moodShareDefault: 'PRIVATE' },
      { moodShareDefault: null },
      { usLockEnabled: null },
      { requestSoonBypassQuiet: 'true' },
      { hideSensitivePreview: 1 },
    ])
      await patch(input).expect(400);
  });

  it('retains privacy settings when subscription expires and blocks non-active families', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'EXPIRED',
        validUntil: new Date(Date.now() - 60000),
      },
    });
    await patch({ hideSensitivePreview: true }).expect(200);
    await get().expect(200);
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'PARTNER_LEFT' },
    });
    await get().expect(403);
    await patch({ usLockEnabled: true }).expect(403);
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'ACTIVE' },
    });
  });

  it('does not expose or revive soft-deleted settings', async () => {
    await prisma.userSetting.update({
      where: { userId: parentB },
      data: { deletedAt: new Date() },
    });
    await get(parentB).expect(404);
    await patch({ usLockEnabled: true }, parentB).expect(404);
  });
});
