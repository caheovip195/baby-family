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
import { BirthConversionController } from '../../src/controllers/birth-conversion.controller';
import { BirthConversionWorkflowService } from '../../src/services/birth-conversion-workflow.service';
import { BirthConversionWorkflowRepository } from '../../src/repositories/birth-conversion-workflow.repository';
import { BIRTH_CONVERSION_WORKFLOW_SERVICE } from '../../src/interfaces/services/birth-conversion-workflow-service.interface';
import { BIRTH_CONVERSION_WORKFLOW_REPOSITORY } from '../../src/interfaces/repositories/birth-conversion-workflow-repository.interface';
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

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Birth conversion API (focused module + PostgreSQL)', () => {
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
  const pregnancyId = randomUUID();
  const url = `/api/v1/pregnancies/${pregnancyId}/birth`;
  const key = randomUUID();

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
      controllers: [BirthConversionController],
      providers: [
        PrismaService,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: BIRTH_CONVERSION_WORKFLOW_SERVICE,
          useClass: BirthConversionWorkflowService,
        },
        {
          provide: BIRTH_CONVERSION_WORKFLOW_REPOSITORY,
          useClass: BirthConversionWorkflowRepository,
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
        nickname: 'Synthetic twins',
        expectedCount: 2,
        createdBy: parent,
      },
    });
    const member = await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        pregnancyId,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
    await prisma.memory.create({
      data: {
        familyId,
        pregnancyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'MOMENT',
        body: 'Synthetic opening chapter',
        occurredAt: new Date('2026-09-01'),
        occurredLocalDate: new Date('2026-09-01'),
        visibility: 'FAMILY',
        status: 'PUBLISHED',
      },
    });
  });
  afterAll(async () => {
    await app?.close();
  });
  const input = {
    children: [
      {
        name: 'Synthetic A',
        gender: 'UNSPECIFIED',
        birthDate: '2026-10-01',
        birthTime: '09:30',
        birthStats: { weightG: 3000, lengthCm: 49.5 },
      },
      { name: 'Synthetic B', gender: 'FEMALE', birthDate: '2026-10-01' },
    ],
  };
  const post = (
    idempotencyKey: string = key,
    who = parent,
    body: object = input,
  ) =>
    request(app.getHttpServer())
      .post(url)
      .set('Authorization', tokens.get(who)!)
      .set('Idempotency-Key', idempotencyKey)
      .send(body);

  it('rejects missing auth, Circle, outsiders and invalid request before creating children', async () => {
    await request(app.getHttpServer())
      .post(url)
      .set('Idempotency-Key', key)
      .send(input)
      .expect(401);
    await post(key, circle).expect(404);
    await post(key, outsider).expect(404);
    await post('invalid').expect(400);
    for (const body of [
      { children: [] },
      { children: [...input.children, input.children[0]] },
      { children: [{ ...input.children[0], name: '  ' }] },
      { children: [{ ...input.children[0], birthDate: '2026-02-30' }] },
    ])
      await post(key, parent, body).expect(400);
    expect(await prisma.birthConversion.count({ where: { pregnancyId } })).toBe(
      0,
    );
  });

  it('creates twins atomically, completes pregnancy and replays without duplicate rows or events', async () => {
    const results = await Promise.all([post().expect(201), post().expect(201)]);
    const first = data<{ pregnancyId: string; children: { id: string }[] }>(
      results[0],
    );
    expect(data(results[1])).toEqual(first);
    expect(first.pregnancyId).toBe(pregnancyId);
    expect(first.children).toHaveLength(2);
    expect(data(await post().expect(201))).toEqual(first);
    const rows = await prisma.child.findMany({
      where: { pregnancyId },
      orderBy: { birthOrder: 'asc' },
    });
    expect(rows.map((row) => row.birthOrder)).toEqual([1, 2]);
    expect(rows.map((row) => row.colorIndex)).toEqual([1, 2]);
    expect(rows.map((row) => row.sortOrder)).toEqual([0, 1]);
    expect(rows[0]?.birthStats).toEqual({ weightGram: 3000, lengthMm: 495 });
    expect(
      await prisma.memory.count({ where: { familyId, pregnancyId } }),
    ).toBe(1);
    expect(
      await prisma.memoryChild.count({
        where: {
          familyId,
          childId: { in: first.children.map((child) => child.id) },
        },
      }),
    ).toBe(4);
    expect(
      await prisma.milestone.count({
        where: {
          familyId,
          childId: { in: first.children.map((child) => child.id) },
          customTitle: 'Chào đời',
        },
      }),
    ).toBe(2);
    expect(
      await prisma.circleGrant.count({
        where: {
          familyId,
          childId: { in: first.children.map((child) => child.id) },
          permission: 'VIEW',
        },
      }),
    ).toBe(2);
    expect(
      await prisma.birthConversionChild.count({ where: { pregnancyId } }),
    ).toBe(2);
    expect(
      (await prisma.pregnancy.findUniqueOrThrow({ where: { id: pregnancyId } }))
        .status,
    ).toBe('COMPLETED');
    const events = await prisma.outboxEvent.findMany({
      where: { familyId, eventType: 'pregnancy.birth_converted' },
    });
    expect(events).toHaveLength(1);
    expect(events[0]?.payload).toEqual({
      pregnancyId,
      childIds: first.children.map((child) => child.id),
    });
    await prisma.child.update({
      where: { id: first.children[0]!.id },
      data: { name: 'Changed after conversion' },
    });
    expect(data(await post().expect(201))).toEqual(first);
    const conflict = await post(randomUUID()).expect(409);
    expect((conflict.body as { error: { code: string } }).error.code).toBe(
      'PREGNANCY_ALREADY_CONVERTED',
    );
  });
});
