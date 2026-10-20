import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import {
  BadRequestException,
  Controller,
  Get,
  UseGuards,
} from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { DomainError } from '../../src/common/errors/domain.error';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ERROR_MESSAGE_CATALOG } from '../../src/common/i18n/error-message-catalog';
import { requestLocaleContext } from '../../src/common/i18n/request-locale';
import { RequestLocaleInterceptor } from '../../src/common/i18n/request-locale.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { REQUEST_LOCALE_SERVICE } from '../../src/interfaces/services/request-locale-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { UserRepository } from '../../src/repositories/user.repository';
import { AuthenticationService } from '../../src/services/authentication.service';
import { RequestLocaleService } from '../../src/services/request-locale.service';
import { NotificationInboxController } from '../../src/controllers/notification-inbox.controller';
import { NOTIFICATION_INBOX_SERVICE } from '../../src/interfaces/services/notification-inbox-service.interface';
import { NOTIFICATION_INBOX_REPOSITORY } from '../../src/interfaces/repositories/notification-inbox-repository.interface';
import { NOTIFICATION_TEXT_SERVICE } from '../../src/interfaces/services/notification-text-service.interface';
import { NOTIFICATION_TEXT_REPOSITORY } from '../../src/interfaces/repositories/notification-text-repository.interface';
import { NotificationInboxService } from '../../src/services/notification-inbox.service';
import { NotificationTextService } from '../../src/services/notification-text.service';
import { NotificationInboxRepository } from '../../src/repositories/notification-inbox.repository';
import { NotificationTextRepository } from '../../src/repositories/notification-text.repository';
import type { NotificationListResponseDto } from '../../src/dto/notification/notification-inbox.dto';

@Controller('locale-fixture')
class LocaleFixtureController {
  @Get('error') error(): never {
    throw new DomainError(
      'This internal English string must not leak.',
      'FAMILY_NOT_ACTIVE',
      403,
    );
  }
  @Get('private-error') @UseGuards(AccessTokenGuard) privateError(): never {
    return this.error();
  }
  @Get('context')
  @UseGuards(AccessTokenGuard)
  async context(): Promise<{ locale: string | undefined }> {
    await Promise.resolve();
    return { locale: requestLocaleContext.getStore() };
  }
  @Get('validation')
  validation(): never {
    throw new BadRequestException(['fixtureField must be a string']);
  }

  @Get('unknown') unknown(): never {
    throw new DomainError(
      'Never expose infrastructure details.',
      'FUTURE_DOMAIN_ERROR',
      422,
    );
  }
}
type ErrorBody = {
  error: { code: string; message: string; details?: string[] };
  path: string;
  timestamp: string;
};
const error = (response: { body: unknown }): ErrorBody =>
  response.body as ErrorBody;

describe('Accept-Language (focused HTTP module + baby_family_test)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const englishUser = randomUUID(),
    vietnameseUser = randomUUID();
  const userIds = [englishUser, vietnameseUser];
  const tokens = new Map<string, string>();
  const prefix = `BF_LANG_${randomUUID().slice(0, 8)}`;
  const codes = {
    normal: `${prefix}_NORMAL`,
    fallback: `${prefix}_FALLBACK`,
    sensitive: `${prefix}_SENSITIVE`,
    missing: `${prefix}_MISSING`,
  };
  const templateCodes = Object.values(codes);
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test database');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [LocaleFixtureController, NotificationInboxController],
      providers: [
        {
          provide: NOTIFICATION_INBOX_SERVICE,
          useClass: NotificationInboxService,
        },
        {
          provide: NOTIFICATION_INBOX_REPOSITORY,
          useClass: NotificationInboxRepository,
        },
        {
          provide: NOTIFICATION_TEXT_SERVICE,
          useClass: NotificationTextService,
        },
        {
          provide: NOTIFICATION_TEXT_REPOSITORY,
          useClass: NotificationTextRepository,
        },
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: USER_REPOSITORY, useClass: UserRepository },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        { provide: REQUEST_LOCALE_SERVICE, useClass: RequestLocaleService },
        { provide: APP_INTERCEPTOR, useClass: RequestLocaleInterceptor },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    await app.init();
    prisma = module.get(PrismaService);
    for (const userId of userIds) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: {
          id: userId,
          displayName: 'Synthetic language fixture',
          locale: userId === englishUser ? 'en' : 'vi',
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
    for (const locale of ['vi', 'en'] as const) {
      await prisma.notificationTemplate.create({
        data: {
          code: codes.normal,
          locale,
          title: locale === 'vi' ? 'Ký ức mới' : 'New memory',
          body:
            locale === 'vi' ? 'Xin chào {actorName}.' : 'Hello {actorName}.',
          category: 'MEMORIES',
        },
      });
      await prisma.notificationTemplate.create({
        data: {
          code: codes.sensitive,
          locale,
          title: 'Private {actorName}',
          body: 'Secret {actorName}',
          hiddenTitle: 'Baby Family',
          hiddenBody:
            locale === 'vi' ? 'Có cập nhật mới.' : 'A new update is available.',
          category: 'MEMORIES',
          sensitive: true,
        },
      });
    }
    await prisma.notificationTemplate.create({
      data: {
        code: codes.fallback,
        locale: 'en',
        title: 'English fallback',
        body: 'A new update.',
        category: 'MEMORIES',
      },
    });
    await prisma.notificationTemplate.create({
      data: {
        code: codes.missing,
        locale: 'vi',
        title: 'Disabled copy',
        body: 'Must not be shown.',
        category: 'MEMORIES',
        enabled: false,
      },
    });
    await prisma.notificationTemplate.create({
      data: {
        code: codes.missing,
        locale: 'en',
        title: 'Deleted copy',
        body: 'Must not be shown.',
        category: 'MEMORIES',
        deletedAt: new Date(),
      },
    });
    for (const templateCode of templateCodes) {
      await prisma.notification.create({
        data: {
          recipientUserId: englishUser,
          eventId: randomUUID(),
          templateCode,
          category: 'MEMORIES',
          locale: 'vi',
          payloadReference: {
            params: {
              actorName: 'Fixture Actor',
              caption: 'Hidden raw caption',
            },
          },
        },
      });
    }
    await prisma.notification.create({
      data: {
        recipientUserId: vietnameseUser,
        eventId: randomUUID(),
        templateCode: codes.normal,
        category: 'MEMORIES',
      },
    });
  });
  afterAll(async () => {
    if (prisma) {
      await prisma.notification.deleteMany({
        where: { recipientUserId: { in: userIds } },
      });
      await prisma.notificationTemplate.deleteMany({
        where: { code: { in: templateCodes } },
      });
      await prisma.userSession.deleteMany({
        where: { userId: { in: userIds } },
      });
      await prisma.user.deleteMany({ where: { id: { in: userIds } } });
    }
    await app?.close();
  });
  const call = (path: string, language?: string, userId?: string) => {
    const result = request(app.getHttpServer()).get(
      `/api/v1/locale-fixture/${path}`,
    );
    if (language !== undefined) result.set('Accept-Language', language);
    if (userId) result.set('Authorization', tokens.get(userId)!);
    return result;
  };
  it('translates vi/en and preserves the code and envelope', async () => {
    for (const locale of ['vi', 'en'] as const) {
      const body = error(await call('error', locale).expect(403));
      expect(body.error).toEqual({
        code: 'FAMILY_NOT_ACTIVE',
        message: ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE[locale],
      });
      expect(body.path).toBe('/api/v1/locale-fixture/error');
      expect(Number.isNaN(Date.parse(body.timestamp))).toBe(false);
    }
  });
  it('preserves validation details while translating the summary message', async () => {
    const body = error(await call('validation', 'vi').expect(400));
    expect(body.error).toEqual({
      code: 'VALIDATION_ERROR',
      message: ERROR_MESSAGE_CATALOG.messages.VALIDATION_ERROR.vi,
      details: ['fixtureField must be a string'],
    });
  });

  it('defaults unsupported/missing language to vi for anonymous callers', async () => {
    for (const header of [undefined, 'ja-JP', 'en;q=0,vi;q=0', 'en;q=wrong']) {
      expect(error(await call('error', header).expect(403)).error.message).toBe(
        ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE.vi,
      );
    }
  });
  it('honours weighted regional tags and excludes q=0', async () => {
    expect(
      error(await call('error', 'fr-FR,en-US;q=0.9,vi;q=0.5').expect(403)).error
        .message,
    ).toBe(ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE.en);
    expect(
      error(await call('error', 'en;q=0,vi-VN;q=0.8').expect(403)).error
        .message,
    ).toBe(ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE.vi);
  });
  it('falls back to persisted users.locale and permits a header override', async () => {
    for (const header of [undefined, 'ja-JP']) {
      expect(
        error(await call('private-error', header, englishUser).expect(403))
          .error.message,
      ).toBe(ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE.en);
    }
    expect(
      error(await call('private-error', 'vi', englishUser).expect(403)).error
        .message,
    ).toBe(ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE.vi);
    expect(
      error(await call('private-error', 'en', vietnameseUser).expect(403)).error
        .message,
    ).toBe(ERROR_MESSAGE_CATALOG.messages.FAMILY_NOT_ACTIVE.en);
  });
  it('localizes guard failures before the interceptor can run', async () => {
    expect(error(await call('private-error', 'en').expect(401)).error).toEqual({
      code: 'UNAUTHORIZED',
      message: ERROR_MESSAGE_CATALOG.messages.UNAUTHORIZED.en,
    });
  });
  it('isolates AsyncLocalStorage between overlapping requests', async () => {
    const [en, vi] = await Promise.all([
      call('context', 'en', englishUser).expect(200),
      call('context', 'vi', vietnameseUser).expect(200),
    ]);
    expect(en.body).toEqual({ locale: 'en' });
    expect(vi.body).toEqual({ locale: 'vi' });
    expect(requestLocaleContext.getStore()).toBeUndefined();
  });
  it('renders inbox server templates in the request language with en/vi fallback', async () => {
    const en = await request(app.getHttpServer())
      .get('/api/v1/notifications')
      .set('Authorization', tokens.get(englishUser)!)
      .expect(200);
    const english = en.body as NotificationListResponseDto;
    expect(english.items).toHaveLength(4);
    expect(
      english.items.find((item) => item.templateCode === codes.normal),
    ).toMatchObject({
      title: 'New memory',
      body: 'Hello Fixture Actor.',
      locale: 'en',
    });
    const vi = await request(app.getHttpServer())
      .get('/api/v1/notifications')
      .set('Authorization', tokens.get(englishUser)!)
      .set('Accept-Language', 'vi')
      .expect(200);
    const vietnamese = vi.body as NotificationListResponseDto;
    expect(
      vietnamese.items.find((item) => item.templateCode === codes.normal),
    ).toMatchObject({
      title: 'Ký ức mới',
      body: 'Xin chào Fixture Actor.',
      locale: 'vi',
    });
    expect(
      vietnamese.items.find((item) => item.templateCode === codes.fallback),
    ).toMatchObject({ title: 'English fallback', locale: 'en' });
    expect(
      vietnamese.items.find((item) => item.templateCode === codes.missing),
    ).toMatchObject({ title: null, body: null, locale: 'vi' });
    expect(
      vietnamese.items.find((item) => item.templateCode === codes.sensitive),
    ).toMatchObject({
      title: 'Baby Family',
      body: 'Có cập nhật mới.',
      locale: 'vi',
    });
    expect(JSON.stringify(vietnamese)).not.toContain('Hidden raw caption');
    expect(JSON.stringify(vietnamese)).not.toContain('Private');
    expect(JSON.stringify(vietnamese)).not.toContain('Secret');
    const stored = await prisma.notification.findFirstOrThrow({
      where: { recipientUserId: englishUser, templateCode: codes.normal },
    });
    expect(stored.locale).toBe('vi');
  });

  it('uses a versioned translated fallback for future domain codes', async () => {
    expect(error(await call('unknown', 'vi').expect(422)).error).toEqual({
      code: 'FUTURE_DOMAIN_ERROR',
      message: ERROR_MESSAGE_CATALOG.messages.UNPROCESSABLE_ENTITY.vi,
    });
    expect(ERROR_MESSAGE_CATALOG.version).toBe(1);
    for (const translations of Object.values(ERROR_MESSAGE_CATALOG.messages))
      expect(Object.keys(translations).sort()).toEqual(['en', 'vi']);
  });
});
