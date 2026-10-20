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
import { MemoryPromptController } from '../../src/controllers/memory-prompt.controller';
import { MemoryPromptService } from '../../src/services/memory-prompt.service';
import { MemoryPromptRepository } from '../../src/repositories/memory-prompt.repository';
import { MEMORY_PROMPT_SERVICE } from '../../src/interfaces/services/memory-prompt-service.interface';
import { MEMORY_PROMPT_REPOSITORY } from '../../src/interfaces/repositories/memory-prompt-repository.interface';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import type { MemoryPromptResponseDto } from '../../src/dto/memory-library/memory-prompt.dto';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { MemoryPromptSeedRepository } from '../../src/repositories/memory-prompt-seed.repository';
import { join } from 'node:path';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
describe('Memory prompts API (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let config: ConfigService;
  const familyId = randomUUID();
  const parentB = randomUUID();
  const childId = randomUUID();
  const infantId = randomUUID();
  const pregnancyId = randomUUID();
  const parent = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const tokens = new Map<string, string>();
  const url = `/api/v1/families/${familyId}/memory-prompts`;

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
      controllers: [MemoryPromptController],
      providers: [
        PrismaService,
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: MEMORY_PROMPT_SERVICE, useClass: MemoryPromptService },
        {
          provide: MEMORY_PROMPT_REPOSITORY,
          useClass: MemoryPromptRepository,
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
    await new MemoryPromptSeedRepository(prisma).seedFromFile(
      join(process.cwd(), 'prisma/seeds/memory-prompts.json'),
    );
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        createdBy: parent,
        name: 'Synthetic toddler',
        birthDate: new Date(Date.now() - 500 * 86400000),
        colorIndex: 1,
      },
    });
    await prisma.child.create({
      data: {
        id: infantId,
        familyId,
        createdBy: parent,
        name: 'Synthetic infant',
        birthDate: new Date(Date.now() - 20 * 86400000),
        colorIndex: 2,
      },
    });
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic pregnancy',
        dueDate: new Date(Date.now() + 140 * 86400000),
        createdBy: parent,
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
  const get = (child = childId, who = parent) =>
    request(app.getHttpServer())
      .get(url)
      .query({ childId: child })
      .set('Authorization', tokens.get(who)!);

  it('seeds idempotently without rewriting the same published version', async () => {
    const before = await prisma.memoryPromptTemplate.findUniqueOrThrow({
      where: { code: 'pr-quote' },
    });
    await new MemoryPromptSeedRepository(prisma).seedFromFile(
      join(process.cwd(), 'prisma/seeds/memory-prompts.json'),
    );
    expect(
      await prisma.memoryPromptTemplate.findUniqueOrThrow({
        where: { code: 'pr-quote' },
      }),
    ).toEqual(before);
  });

  it('requires a Parent and rejects strangers and unauthenticated calls', async () => {
    await get(childId, outsider).expect(404);
    await get(childId, circle).expect(404);
    await request(app.getHttpServer()).get(url).expect(401);
  });

  it('matches age, records one active delivery under concurrent requests, and keeps prompt deliveries personal', async () => {
    const responses = await Promise.all([get().expect(200), get().expect(200)]);
    const first = data<MemoryPromptResponseDto>(responses[0]);
    expect(first.items).toHaveLength(1);
    expect(first.items[0]).toMatchObject({
      code: 'pr-quote',
      childId,
      pregnancyId: null,
      targetKind: 'QUOTE',
    });
    expect(data(responses[1])).toEqual(first);
    expect(
      await prisma.memoryPromptDelivery.count({
        where: { userId: parent, status: 'SHOWN', deletedAt: null },
      }),
    ).toBe(1);
    const infant = data<MemoryPromptResponseDto>(
      await get(infantId, parentB).expect(200),
    );
    expect(infant.items).toHaveLength(1);
    expect(infant.items[0]?.targetKind).toBe('DIARY');
  });

  it('dismiss is idempotent and excludes further prompts today for only that caller', async () => {
    const shown = data<MemoryPromptResponseDto>(await get().expect(200))
      .items[0]!;
    const dismiss = () =>
      request(app.getHttpServer())
        .post(`/api/v1/memory-prompts/${shown.code}/dismiss`)
        .set('Authorization', tokens.get(parent)!)
        .send({ childId });
    await dismiss().expect(201);
    await dismiss().expect(201);
    expect(data(await get().expect(200))).toEqual({ items: [] });
    expect(
      data<MemoryPromptResponseDto>(await get(infantId, parentB).expect(200))
        .items,
    ).toHaveLength(1);
    expect(
      await prisma.memoryPromptDelivery.count({
        where: { userId: parent, status: 'DISMISSED', deletedAt: null },
      }),
    ).toBe(1);
  });

  it('excludes recent templates and respects disabled prompts and subject isolation', async () => {
    await prisma.memoryPromptDelivery.updateMany({
      where: { userId: parentB },
      data: { localDate: new Date(Date.now() - 86400000), status: 'DISMISSED' },
    });
    const shown = data<MemoryPromptResponseDto>(
      await get(infantId, parentB).expect(200),
    ).items[0]!;
    expect(shown.code).not.toBe('diary-01');
    await prisma.userSetting.create({
      data: { userId: parentB, memoryPromptsEnabled: false },
    });
    expect(data(await get(infantId, parentB).expect(200))).toEqual({
      items: [],
    });
    await get(randomUUID(), parent).expect(404);
    await request(app.getHttpServer())
      .get(url)
      .query({ childId, pregnancyId })
      .set('Authorization', tokens.get(parent)!)
      .expect(400);
  });

  it('matches pregnancy week and never delivers for ended pregnancy', async () => {
    const code = `pw-${randomUUID().slice(0, 8)}`;
    await prisma.memoryPromptTemplate.create({
      data: {
        code,
        stage: 'PREGNANCY',
        minPregWeek: 19,
        maxPregWeek: 21,
        targetKind: 'BUMP',
        textI18n: { vi: 'Synthetic', en: 'Synthetic' },
      },
    });
    await prisma.memoryPromptDelivery.updateMany({
      where: { userId: parent },
      data: { localDate: new Date(Date.now() - 86400000) },
    });
    const result = data<MemoryPromptResponseDto>(
      await request(app.getHttpServer())
        .get(url)
        .query({ pregnancyId })
        .set('Authorization', tokens.get(parent)!)
        .expect(200),
    );
    expect(result.items[0]).toMatchObject({
      targetKind: 'BUMP',
      pregnancyId,
      childId: null,
    });
    const selected = await prisma.memoryPromptTemplate.findUniqueOrThrow({
      where: { code: result.items[0]!.code },
    });
    expect(selected.minPregWeek).toBeLessThanOrEqual(20);
    expect(selected.maxPregWeek).toBeGreaterThanOrEqual(20);
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { status: 'ENDED_PRIVATE' },
    });
    await request(app.getHttpServer())
      .get(url)
      .query({ pregnancyId })
      .set('Authorization', tokens.get(parent)!)
      .expect(404);
    await prisma.memoryPromptTemplate.update({
      where: { code },
      data: { deletedAt: new Date() },
    });
  });
});
