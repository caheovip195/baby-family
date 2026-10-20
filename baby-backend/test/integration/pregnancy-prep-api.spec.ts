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
import { PregnancyPrepController } from '../../src/controllers/pregnancy-prep.controller';
import { PregnancyPrepService } from '../../src/services/pregnancy-prep.service';
import { PregnancyPrepRepository } from '../../src/repositories/pregnancy-prep.repository';
import { PREGNANCY_PREP_SERVICE } from '../../src/interfaces/services/pregnancy-prep-service.interface';
import { PREGNANCY_PREP_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-prep-repository.interface';
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
  PregnancyPrepGroupDto,
  PregnancyPrepItemDto,
} from '../../src/dto/pregnancy/prep.dto';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Pregnancy prep API (focused module + PostgreSQL)', () => {
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
  const contentCode = `TEST_${randomUUID().slice(0, 20)}`;
  const pregnancyId = randomUUID();
  const url = `/api/v1/pregnancies/${pregnancyId}/prep-items`;

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
      controllers: [PregnancyPrepController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: ConfigService, useValue: config },
        { provide: PREGNANCY_PREP_SERVICE, useClass: PregnancyPrepService },
        {
          provide: PREGNANCY_PREP_REPOSITORY,
          useClass: PregnancyPrepRepository,
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
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic baby',
        createdBy: parent,
      },
    });
    await prisma.contentItem.create({
      data: {
        type: 'PREP_DEFAULT',
        code: contentCode,
        locale: 'vi',
        data: {
          groupCode: 'TEST_DEFAULT',
          title: 'Synthetic default item',
          sortOrder: 0,
        },
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
    if (prisma)
      await prisma.contentItem.updateMany({
        where: { type: 'PREP_DEFAULT', code: contentCode, locale: 'vi' },
        data: { deletedAt: new Date() },
      });
    await app?.close();
  });
  const get = (who = parent) =>
    request(app.getHttpServer())
      .get(url)
      .set('Authorization', tokens.get(who)!);
  const post = (input: object, who = parent) =>
    request(app.getHttpServer())
      .post(url)
      .set('Authorization', tokens.get(who)!)
      .send(input);
  const patch = (id: string, input: object, who = parent) =>
    request(app.getHttpServer())
      .patch(`/api/v1/prep-items/${id}`)
      .set('Authorization', tokens.get(who)!)
      .send(input);
  const remove = (id: string, who = parent) =>
    request(app.getHttpServer())
      .delete(`/api/v1/prep-items/${id}`)
      .set('Authorization', tokens.get(who)!);

  it('seeds defaults once even for concurrent first GETs, groups and sorts items', async () => {
    const responses = await Promise.all([get().expect(200), get().expect(200)]);
    const groups = data<PregnancyPrepGroupDto[]>(responses[0]);
    expect(
      groups.find((group) => group.groupCode === 'TEST_DEFAULT')?.items.length,
    ).toBeGreaterThan(0);
    const count = groups.reduce((sum, group) => sum + group.items.length, 0);
    expect(count).toBeGreaterThan(0);
    expect(await prisma.prepItem.count({ where: { pregnancyId } })).toBe(count);
    expect(data(responses[1])).toEqual(groups);
    expect(groups.map((group) => group.groupCode)).toEqual(
      groups.map((group) => group.groupCode).sort(),
    );
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'pregnancy.prep.changed' },
      }),
    ).toBe(1);
    await get().expect(200);
    expect(await prisma.prepItem.count({ where: { pregnancyId } })).toBe(count);
  });

  it('adds items, assigns doneBy to caller, clears completion and supports ordering/title changes', async () => {
    const item = data<PregnancyPrepItemDto>(
      await post({
        groupCode: 'CUSTOM',
        title: '  Synthetic checklist  ',
      }).expect(201),
    );
    expect(item).toMatchObject({
      pregnancyId,
      groupCode: 'CUSTOM',
      title: 'Synthetic checklist',
      done: false,
      doneAt: null,
      doneBy: null,
    });
    const done = data<PregnancyPrepItemDto>(
      await patch(item.id, { done: true }, parentB).expect(200),
    );
    expect(done.done).toBe(true);
    expect(done.doneBy).toBe(parentB);
    expect(done.doneAt).toEqual(expect.any(String));
    expect(
      data(
        await patch(item.id, {
          done: false,
          title: 'Revised',
          sortOrder: 12,
        }).expect(200),
      ),
    ).toMatchObject({
      done: false,
      doneAt: null,
      doneBy: null,
      title: 'Revised',
      sortOrder: 12,
    });
    expect(
      await prisma.outboxEvent.count({
        where: {
          familyId,
          eventType: 'pregnancy.prep.changed',
          payload: { path: ['itemId'], equals: item.id },
        },
      }),
    ).toBe(3);
  });

  it('blocks Circle read/write and outsiders, with no mutation or event', async () => {
    const item = data<PregnancyPrepItemDto>(
      await post({ groupCode: 'CUSTOM', title: 'Permission fixture' }).expect(
        201,
      ),
    );
    const before = await prisma.outboxEvent.count({ where: { familyId } });
    for (const who of [circle, outsider]) {
      await get(who).expect(404);
      await post({ groupCode: 'CUSTOM', title: 'Denied' }, who).expect(404);
      await patch(item.id, { done: true }, who).expect(404);
      await remove(item.id, who).expect(404);
    }
    expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(
      before,
    );
    await request(app.getHttpServer()).get(url).expect(401);
  });

  it('returns 404 for an item belonging to another family', async () => {
    const otherFamily = await prisma.family.create({
      data: { name: 'Other synthetic family', createdBy: outsider },
    });
    const otherPregnancy = await prisma.pregnancy.create({
      data: {
        familyId: otherFamily.id,
        seqNo: 1,
        nickname: 'Other pregnancy',
        createdBy: outsider,
      },
    });
    const otherItem = await prisma.prepItem.create({
      data: {
        pregnancyId: otherPregnancy.id,
        familyId: otherFamily.id,
        groupCode: 'CUSTOM',
        title: 'Other item',
      },
    });
    await patch(otherItem.id, { done: true }).expect(404);
    await remove(otherItem.id).expect(404);
    expect(
      (await prisma.prepItem.findUniqueOrThrow({ where: { id: otherItem.id } }))
        .doneAt,
    ).toBeNull();
  });

  it('rejects invalid/unknown/empty input and soft deletes without reseeding after all rows are removed', async () => {
    for (const input of [
      { groupCode: 'CUSTOM', title: ' ' },
      { groupCode: 'bad group', title: 'Title' },
      { groupCode: 'CUSTOM', title: 'Title', done: true },
    ])
      await post(input).expect(400);
    const groups = data<PregnancyPrepGroupDto[]>(await get().expect(200));
    const items = groups.flatMap((group) => group.items);
    for (const input of [
      {},
      { done: null },
      { done: 'true' },
      { sortOrder: -1 },
      { sortOrder: 1.5 },
      { title: '' },
      { unknown: true },
    ])
      await patch(items[0]!.id, input).expect(400);
    for (const item of items) await remove(item.id).expect(204);
    expect(data(await get().expect(200))).toEqual([]);
    expect(
      await prisma.prepItem.count({ where: { pregnancyId, deletedAt: null } }),
    ).toBe(0);
    expect(
      await prisma.prepItem.count({
        where: { pregnancyId, deletedAt: { not: null } },
      }),
    ).toBe(items.length);
    await patch(items[0]!.id, { done: true }).expect(404);
    await remove(items[0]!.id).expect(404);
  });
});
