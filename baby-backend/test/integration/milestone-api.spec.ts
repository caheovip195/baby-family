import { MemoryController } from '../../src/controllers/memory.controller';
import { MemoryContentService } from '../../src/services/memory-content.service';
import { MemoryContentRepository } from '../../src/repositories/memory-content.repository';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { MEDIA_SERVICE } from '../../src/interfaces/services/media-service.interface';
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
import { MilestoneController } from '../../src/controllers/milestone.controller';
import { MilestoneCatalogService } from '../../src/services/milestone-catalog.service';
import { MilestoneCatalogRepository } from '../../src/repositories/milestone-catalog.repository';
import { MilestoneSeedRepository } from '../../src/repositories/milestone-seed.repository';
import { MILESTONE_CATALOG_SERVICE } from '../../src/interfaces/services/milestone-catalog-service.interface';
import { MILESTONE_CATALOG_REPOSITORY } from '../../src/interfaces/repositories/milestone-catalog-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import type {
  MilestoneCatalogResponseDto,
  MilestoneListResponseDto,
} from '../../src/dto/milestone/milestone-response.dto';
import { join } from 'node:path';

const data = <T>(response: { body: unknown }): T =>
  (Array.isArray((response.body as { data: unknown }).data)
    ? response.body
    : (response.body as { data: T }).data) as T;
describe('Milestones API (focused module + PostgreSQL)', () => {
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
    hiddenChildId = randomUUID(),
    pregnancyId = randomUUID();

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
      controllers: [MilestoneController, MemoryController],
      providers: [
        PrismaService,
        { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
        {
          provide: MEMORY_CONTENT_REPOSITORY,
          useClass: MemoryContentRepository,
        },
        {
          provide: MEDIA_SERVICE,
          useValue: { signViewUrls: () => Promise.resolve({ items: [] }) },
        },
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: MILESTONE_CATALOG_SERVICE,
          useClass: MilestoneCatalogService,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        {
          provide: MILESTONE_CATALOG_REPOSITORY,
          useClass: MilestoneCatalogRepository,
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
        quotas: { photosPerMemory: 10 },
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
    for (const id of [childId, hiddenChildId])
      await prisma.child.create({
        data: {
          id,
          familyId,
          name: 'Synthetic milestone child',
          birthDate: new Date('2024-01-31'),
          colorIndex: id === childId ? 1 : 2,
          createdBy: parent,
        },
      });
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic pregnancy',
        createdBy: parent,
      },
    });
    const member = await prisma.circleMember.findFirstOrThrow({
      where: { familyId, userId: circle },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId,
        createdBy: parent,
        permission: 'VIEW',
      },
    });
    await new MilestoneSeedRepository(prisma).seedFromFile(
      join(process.cwd(), 'prisma/seeds/milestones.json'),
    );
    await new MilestoneSeedRepository(prisma).seedFromFile(
      join(process.cwd(), 'prisma/seeds/milestones.json'),
    );
  });
  afterAll(async () => {
    await app?.close();
  });
  const get = (path: string, who = parent) =>
    request(app.getHttpServer())
      .get('/api/v1/' + path)
      .set('Authorization', tokens.get(who)!);
  const record = async (
    visibility: 'FAMILY' | 'PARENTS' | 'PRIVATE',
    day: string,
    extra: {
      childId?: string;
      pregnancyId?: string;
      status?: 'DRAFT' | 'PUBLISHED';
    } = {},
  ) => {
    const memory = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: parent,
        authorRole: 'PARENT',
        kind: 'MILESTONE',
        title: 'Synthetic first',
        occurredAt: new Date(day),
        occurredLocalDate: new Date(day),
        visibility,
        status: extra.status ?? 'PUBLISHED',
        pregnancyId: extra.pregnancyId,
      },
    });
    // Mirror memory creation: a milestone's subject must also be tagged on its memory
    // so the shared memory ACL can validate every child before pagination.
    await prisma.memoryChild.create({
      data: {
        familyId,
        memoryId: memory.id,
        childId: extra.childId ?? childId,
        ageMonth: 0,
      },
    });
    return prisma.milestone.create({
      data: {
        familyId,
        memoryId: memory.id,
        childId: extra.childId ?? childId,
        customTitle: 'Synthetic custom first',
        occurredOn: new Date(day),
        createdBy: parent,
      },
    });
  };
  it('seeds idempotently and groups translated templates with clamped suggested dates without developmental deadlines', async () => {
    const catalog = data<MilestoneCatalogResponseDto>(
      await get(`milestone-templates?childId=${childId}`).expect(200),
    );
    const items = catalog.categories.flatMap((group) => group.templates);
    expect(items.find((item) => item.code === 'full_month')).toMatchObject({
      suggestedDate: '2024-02-29',
      titleI18n: { vi: 'Đầy tháng', en: 'One month celebration' },
      achieved: null,
    });
    expect(items.find((item) => item.code === 'first_step')).toMatchObject({
      suggestedDate: null,
    });
    expect(items.some((item) => item.code === 'heartbeat')).toBe(false);
    const pregnancy = data<MilestoneCatalogResponseDto>(
      await get(`milestone-templates?pregnancyId=${pregnancyId}`).expect(200),
    );
    expect(
      pregnancy.categories.every((group) => group.category === 'PREGNANCY'),
    ).toBe(true);
    await get(
      `milestone-templates?childId=${childId}&pregnancyId=${pregnancyId}`,
    ).expect(400);
    await get(`milestone-templates?childId=${hiddenChildId}`, circle).expect(
      404,
    );
    await get(`milestone-templates?childId=${childId}`, outsider).expect(404);
  });
  it('creates a milestone atomically through memory creation and maps duplicate template to 409', async () => {
    const payload = {
      familyId,
      kind: 'MILESTONE',
      childIds: [childId],
      title: 'Synthetic first laugh',
      body: 'Synthetic memory',
      occurredAt: '2025-02-01T10:00:00.000Z',
      visibility: 'FAMILY',
      milestone: { templateCode: 'laugh_aloud', occurredOn: '2025-02-01' },
    };
    const create = () =>
      request(app.getHttpServer())
        .post('/api/v1/memories')
        .set('Authorization', tokens.get(parent)!)
        .set('Idempotency-Key', randomUUID())
        .send(payload);
    const first = await create().expect(201);
    const duplicate = await create().expect(409);
    expect((duplicate.body as { error: { code: string } }).error.code).toBe(
      'MILESTONE_ALREADY_RECORDED',
    );
    expect(
      await prisma.milestone.count({
        where: { childId, templateCode: 'laugh_aloud', deletedAt: null },
      }),
    ).toBe(1);
    const catalog = data<MilestoneCatalogResponseDto>(
      await get(`milestone-templates?childId=${childId}`).expect(200),
    );
    expect(
      catalog.categories
        .flatMap((group) => group.templates)
        .find((item) => item.code === 'laugh_aloud')?.achieved?.memoryId,
    ).toBe(data<{ id: string }>(first).id);
  });
  it('applies Circle grants, FAMILY visibility, draft privacy and sensitive pregnancy exclusion with stable pagination', async () => {
    const family = await record('FAMILY', '2025-01-01');
    const parents = await record('PARENTS', '2025-01-02');
    await record('PRIVATE', '2025-01-03');
    await record('FAMILY', '2025-01-04', { status: 'DRAFT' });
    await record('FAMILY', '2025-01-05', { childId: hiddenChildId });
    await record('FAMILY', '2025-01-06', { pregnancyId });
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { status: 'ENDED_PRIVATE' },
    });
    const visible = data<MilestoneListResponseDto>(
      await get(`children/${childId}/milestones`, circle).expect(200),
    );
    expect(visible.data.map((item) => item.milestoneId)).toContain(family.id);
    expect(visible.data).toHaveLength(2);
    await get(`children/${hiddenChildId}/milestones`, circle).expect(404);
    const partner = data<MilestoneListResponseDto>(
      await get(`children/${childId}/milestones?limit=1`, parentB).expect(200),
    );
    expect(partner.data).toHaveLength(1);
    expect(partner.nextCursor).not.toBeNull();
    const remainder = data<MilestoneListResponseDto>(
      await get(
        `children/${childId}/milestones?cursor=${partner.nextCursor}&limit=100`,
        parentB,
      ).expect(200),
    );
    expect(remainder.data.map((item) => item.milestoneId)).toContain(
      parents.id,
    );
    await get(`children/${childId}/milestones?cursor=invalid`).expect(400);
  });
});
