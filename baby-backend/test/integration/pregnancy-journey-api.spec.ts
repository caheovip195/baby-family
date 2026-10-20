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
import { PregnancyJourneyController } from '../../src/controllers/pregnancy-journey.controller';
import { PregnancyJourneyService } from '../../src/services/pregnancy-journey.service';
import { PregnancyJourneyRepository } from '../../src/repositories/pregnancy-journey.repository';
import { PREGNANCY_JOURNEY_SERVICE } from '../../src/interfaces/services/pregnancy-journey-service.interface';
import { PREGNANCY_JOURNEY_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-journey-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type { MemoryResponseDto } from '../../src/dto/memory/memory-response.dto';

interface Journey {
  pregnancyId: string;
  dueDate: string | null;
  currentWeek: number | null;
  currentDay: number | null;
  daysLeft: number | null;
  trimester: number | null;
  week: {
    number: number | null;
    size: { label: string } | null;
    tip: string | null;
  };
}
interface Memories {
  data: (MemoryResponseDto & { week: number | null })[];
  nextCursor: string | null;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const memories = (response: { body: unknown }): Memories =>
  response.body as Memories;
const dayMs = 86400000;
const localDay = () =>
  new Date(
    new Intl.DateTimeFormat('en-CA', {
      timeZone: 'Asia/Ho_Chi_Minh',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).format(new Date()) + 'T00:00:00Z',
  );

describe('Pregnancy journey API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    pregnancyId = randomUUID(),
    otherPregnancy = randomUUID();
  const parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const tokens = new Map<string, string>();
  const bump = randomUUID(),
    ultrasound = randomUUID(),
    privatePartner = randomUUID(),
    otherBump = randomUUID(),
    oldBump = randomUUID();
  const url = `/api/v1/pregnancies/${pregnancyId}`;
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [PregnancyJourneyController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: PREGNANCY_JOURNEY_SERVICE,
          useClass: PregnancyJourneyService,
        },
        {
          provide: PREGNANCY_JOURNEY_REPOSITORY,
          useClass: PregnancyJourneyRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        {
          provide: MEDIA_SERVICE,
          useValue: { signViewUrls: () => Promise.resolve({ items: [] }) },
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
    for (const userId of [parent, partner, circle, outsider]) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: {
          id: userId,
          displayName: 'Synthetic journey fixture',
          locale: 'vi',
        },
      });
      await prisma.userSession.create({
        data: {
          id: sessionId,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: new Date(Date.now() + dayMs),
          absoluteExpiresAt: new Date(Date.now() + dayMs),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer(config.get<string>('AUTH_JWT_ISSUER')!).setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!).setIssuedAt().setExpirationTime('10m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic journey',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date(),
        timezone: 'Asia/Ho_Chi_Minh',
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
        userId: partner,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `JOURNEY_${randomUUID().slice(0, 12)}`,
        displayNameI18n: { vi: 'Synthetic journey' },
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
        validUntil: new Date(Date.now() + dayMs),
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
    for (const [index, id] of [pregnancyId, otherPregnancy].entries())
      await prisma.pregnancy.create({
        data: {
          id,
          familyId,
          seqNo: index + 1,
          nickname: 'Synthetic pregnancy',
          createdBy: parent,
          dueDate: new Date(localDay().getTime() + 112 * dayMs),
        },
      });
    for (const locale of ['vi', 'en'])
      await prisma.contentItem.upsert({
        where: {
          type_code_locale: { type: 'PREGNANCY_WEEK', code: 'W04', locale },
        },
        create: {
          type: 'PREGNANCY_WEEK',
          code: 'W04',
          locale,
          data: {
            emoji: '🌱',
            lengthCm: 0.2,
            label: locale === 'vi' ? 'Hạt nhỏ' : 'Little seed',
            tip:
              locale === 'vi'
                ? 'Ghi lại một điều vui hôm nay.'
                : 'Capture a happy moment today.',
          },
        },
        update: {},
      });
    for (const [id, kind, pregnancy, author, visibility, age] of [
      [bump, 'BUMP', pregnancyId, parent, 'PARENTS', 1],
      [ultrasound, 'ULTRASOUND', pregnancyId, parent, 'PARENTS', 2],
      [privatePartner, 'BUMP', pregnancyId, partner, 'PRIVATE', 3],
      [otherBump, 'BUMP', otherPregnancy, parent, 'PARENTS', 4],
      [oldBump, 'BUMP', pregnancyId, parent, 'PARENTS', 5],
    ] as const) {
      const occurredAt = new Date(
        localDay().getTime() - age * dayMs + 12 * 3600000,
      );
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: author,
          authorRole: 'PARENT',
          kind,
          pregnancyId: pregnancy,
          visibility,
          status: 'PUBLISHED',
          title: 'Synthetic journey memory',
          occurredAt,
          occurredLocalDate: new Date(localDay().getTime() - age * dayMs),
          createdAt: new Date(Date.now() - age * 1000),
          publishedAt: occurredAt,
        },
      });
    }
  });
  afterAll(async () => {
    await app?.close();
  });
  const get = (suffix: string, who = parent) =>
    request(app.getHttpServer())
      .get(url + suffix)
      .set('Authorization', tokens.get(who)!);

  it('computes the current gestation and respects browsing bounds', async () => {
    expect(data<Journey>(await get('/journey').expect(200))).toMatchObject({
      pregnancyId,
      currentWeek: 24,
      currentDay: 0,
      daysLeft: 112,
      trimester: 2,
      week: { number: 24 },
    });
    expect(
      data<Journey>(await get('/journey?week=4').expect(200)),
    ).toMatchObject({ currentWeek: 24, week: { number: 4 } });
    await get('/journey?week=42').expect(200);
    for (const week of ['3', '43', '4.5', 'abc', ''])
      await get(`/journey?week=${week}`).expect(400);
  });
  it('honors size suppression, Accept-Language and user locale with Vietnamese fallback', async () => {
    const content = async (locale: string) =>
      (
        await prisma.contentItem.findUniqueOrThrow({
          where: {
            type_code_locale: { type: 'PREGNANCY_WEEK', code: 'W04', locale },
          },
        })
      ).data as { label: string; tip: string };
    expect(
      data<Journey>(
        await get('/journey?week=4')
          .set('Accept-Language', 'en-US,en;q=0.9')
          .expect(200),
      ).week,
    ).toMatchObject({
      size: { label: (await content('en')).label },
      tip: (await content('en')).tip,
    });
    await prisma.user.update({ where: { id: parent }, data: { locale: 'en' } });
    expect(
      data<Journey>(await get('/journey?week=4').expect(200)).week.size?.label,
    ).toBe((await content('en')).label);
    await prisma.user.update({ where: { id: parent }, data: { locale: 'fr' } });
    expect(
      data<Journey>(
        await get('/journey?week=4')
          .set('Accept-Language', 'fr-FR')
          .expect(200),
      ).week.size?.label,
    ).toBe((await content('vi')).label);
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { showSizeContent: false },
    });
    expect(
      data<Journey>(await get('/journey?week=4').expect(200)).week.size,
    ).toBeNull();
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { showSizeContent: true },
    });
  });
  it('keeps early/overdue and unknown due dates honest and stops ended countdowns', async () => {
    for (const [daysLeft, week] of [
      [266, 2],
      [-15, 42],
    ] as const) {
      await prisma.pregnancy.update({
        where: { id: pregnancyId },
        data: { dueDate: new Date(localDay().getTime() + daysLeft * dayMs) },
      });
      expect(data<Journey>(await get('/journey').expect(200))).toMatchObject({
        currentWeek: week,
        daysLeft,
      });
    }
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { dueDate: null },
    });
    expect(data<Journey>(await get('/journey').expect(200))).toMatchObject({
      currentWeek: null,
      currentDay: null,
      daysLeft: null,
      trimester: null,
    });
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: {
        dueDate: new Date(localDay().getTime() + 112 * dayMs),
        status: 'ENDED_PRIVATE',
      },
    });
    expect(
      data<Journey>(await get('/journey?week=4').expect(200)),
    ).toMatchObject({
      currentWeek: null,
      currentDay: null,
      daysLeft: null,
      trimester: null,
      week: { number: 4 },
    });
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { status: 'ACTIVE' },
    });
  });
  it('filters kind/pregnancy and private partner memories, with stable pagination and feed projection', async () => {
    const page = memories(await get('/memories?kind=BUMP&limit=1').expect(200));
    expect(page.data.map((item) => item.id)).toEqual([bump]);
    expect(page.data[0]).toMatchObject({
      pregnancyId,
      kind: 'BUMP',
      week: 23,
      authorUserId: parent,
      assets: [],
      visibility: 'PARENTS',
    });
    expect(page.nextCursor).toEqual(expect.any(String));
    const next = memories(
      await get(
        `/memories?kind=BUMP&limit=1&cursor=${encodeURIComponent(page.nextCursor!)}`,
      ).expect(200),
    );
    expect(next.data.map((item) => item.id)).toEqual([oldBump]);
    expect(next.nextCursor).toBeNull();
    expect(
      memories(await get('/memories?kind=ULTRASOUND').expect(200)).data.map(
        (item) => item.id,
      ),
    ).toEqual([ultrasound]);
    expect(
      memories(await get('/memories?kind=BUMP', partner).expect(200)).data.map(
        (item) => item.id,
      ),
    ).toContain(privatePartner);
    for (const suffix of [
      '/memories?kind=MOMENT',
      '/memories?kind=BUMP&limit=0',
      '/memories?kind=BUMP&cursor=bad',
    ])
      await get(suffix).expect(400);
  });
  it('blocks ungranted Circle and other-family users on all pregnancy reads', async () => {
    for (const who of [circle, outsider])
      for (const suffix of ['/journey', '/memories?kind=BUMP'])
        await get(suffix, who).expect(404);
    await request(app.getHttpServer())
      .get(url + '/journey')
      .expect(401);
  });
});
