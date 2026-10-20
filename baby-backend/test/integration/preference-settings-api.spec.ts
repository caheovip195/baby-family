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
import { PreferenceSettingsController } from '../../src/controllers/preference-settings.controller';
import { PreferenceSettingsService } from '../../src/services/preference-settings.service';
import { PreferenceSettingsRepository } from '../../src/repositories/preference-settings.repository';
import { PREFERENCE_SETTINGS_SERVICE } from '../../src/interfaces/services/preference-settings-service.interface';
import { PREFERENCE_SETTINGS_REPOSITORY } from '../../src/interfaces/repositories/preference-settings-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type {
  AiSettingsResponseDto,
  NotificationSettingsResponseDto,
} from '../../src/dto/preferences/preference-settings.dto';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

describe('Notification & AI settings API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  const user = randomUUID(),
    noRow = randomUUID();
  const tokens = new Map<string, string>();

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
      controllers: [PreferenceSettingsController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: PREFERENCE_SETTINGS_SERVICE,
          useClass: PreferenceSettingsService,
        },
        {
          provide: PREFERENCE_SETTINGS_REPOSITORY,
          useClass: PreferenceSettingsRepository,
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
    for (const userId of [user, noRow]) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic preferences fixture' },
      });
      if (userId === user)
        await prisma.userSetting.create({
          // A legacy alias and a muted user must survive category updates.
          data: {
            userId,
            notificationPrefs: { MEMORY: false, mutedUserIds: ['x'] },
          },
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
  });
  afterAll(async () => {
    await app?.close();
  });
  const call = (
    method: 'get' | 'patch',
    path: string,
    input?: object,
    who = user,
  ) => {
    const server = request(app.getHttpServer());
    const req = (method === 'get' ? server.get : server.patch)
      .call(server, `/api/v1/me/${path}`)
      .set('Authorization', tokens.get(who)!);
    return input ? req.send(input) : req;
  };

  it('reads notification defaults, honouring the legacy alias', async () => {
    expect(
      data<NotificationSettingsResponseDto>(
        await call('get', 'notification-settings').expect(200),
      ),
    ).toEqual({
      policyVersion: 1,
      quietStart: '22:00',
      quietEnd: '06:30',
      hideSensitivePreview: true,
      categories: {
        MEMORIES: false,
        REQUESTS: true,
        US: true,
        APPRECIATION: true,
        PROMOTIONS: false,
      },
      circleDigestMode: 'DIGEST',
      circleDigestTime: '19:00',
    });
    await request(app.getHttpServer())
      .get('/api/v1/me/notification-settings')
      .expect(401);
  });

  it('patches only the given fields and keeps other prefs keys', async () => {
    const saved = data<NotificationSettingsResponseDto>(
      await call('patch', 'notification-settings', {
        quietStart: '21:30',
        categories: { REQUESTS: false },
        circleDigestMode: 'INSTANT',
      }).expect(200),
    );
    expect(saved).toMatchObject({
      quietStart: '21:30',
      quietEnd: '06:30',
      circleDigestMode: 'INSTANT',
      categories: { REQUESTS: false, MEMORIES: false, US: true },
    });
    const row = await prisma.userSetting.findUniqueOrThrow({
      where: { userId: user },
    });
    expect(row.notificationPrefs).toMatchObject({
      version: 1,
      mutedUserIds: ['x'],
      categories: { REQUESTS: false },
    });
  });

  it('rejects unknown categories, bad times and empty patches', async () => {
    expect(
      code(
        await call('patch', 'notification-settings', {
          categories: { SECURITY: false },
        }).expect(400),
      ),
    ).toBe('VALIDATION_ERROR');
    await call('patch', 'notification-settings', { quietEnd: '25:00' }).expect(
      400,
    );
    await call('patch', 'notification-settings', {
      circleDigestMode: 'HOURLY',
    }).expect(400);
    await call('patch', 'notification-settings', {}).expect(400);
  });

  it('creates the settings row for older accounts', async () => {
    await call('get', 'notification-settings', undefined, noRow).expect(200);
    expect(await prisma.userSetting.count({ where: { userId: noRow } })).toBe(
      1,
    );
  });

  it('reads and patches AI settings from the feature catalog', async () => {
    const initial = data<AiSettingsResponseDto>(
      await call('get', 'ai-settings').expect(200),
    );
    expect(initial.aiEnabled).toBe(true);
    expect(initial.features.caption).toBe(true);
    const saved = data<AiSettingsResponseDto>(
      await call('patch', 'ai-settings', {
        aiEnabled: false,
        features: { dailyStory: false },
      }).expect(200),
    );
    expect(saved.aiEnabled).toBe(false);
    expect(saved.features).toMatchObject({ dailyStory: false, caption: true });
    await call('patch', 'ai-settings', { features: { faceScan: true } }).expect(
      400,
    );
  });
});
