import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe, type INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { MonthlyPhotoSelectionController } from '../../src/controllers/monthly-photo-selection.controller';
import { MonthlyPhotoSelectionService } from '../../src/services/monthly-photo-selection.service';
import { MonthlyPhotoSelectionRepository } from '../../src/repositories/monthly-photo-selection.repository';
import { MONTHLY_PHOTO_SELECTION_SERVICE } from '../../src/interfaces/services/monthly-photo-selection-service.interface';
import { MONTHLY_PHOTO_SELECTION_REPOSITORY } from '../../src/interfaces/repositories/monthly-photo-selection-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
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
import type { MonthlyPhotoSelectionDto } from '../../src/dto/monthly-photo/monthly-photo-selection.dto';
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;

describe('Monthly photo selection (focused module + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    childId = randomUUID(),
    otherChild = randomUUID();
  const parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const tokens = new Map<string, string>();
  const memories = [randomUUID(), randomUUID(), randomUUID()];
  const assets = memories.map(() => randomUUID());
  let grantId: string;
  const url = `/api/v1/children/${childId}/monthly-photos`;
  const send = (method: 'get' | 'put' | 'post', suffix = '', who = parent) => {
    const client = request(app.getHttpServer());
    return client[method](url + suffix).set('Authorization', tokens.get(who)!);
  };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MonthlyPhotoSelectionController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: MONTHLY_PHOTO_SELECTION_SERVICE,
          useClass: MonthlyPhotoSelectionService,
        },
        {
          provide: MONTHLY_PHOTO_SELECTION_REPOSITORY,
          useClass: MonthlyPhotoSelectionRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        {
          provide: MEDIA_SERVICE,
          useValue: {
            signViewUrls: (
              { userId }: { userId: string },
              { assetIds }: { assetIds: string[] },
            ) =>
              Promise.resolve({
                items: assetIds.map((assetId) => ({
                  assetId,
                  urls: {
                    m1080: `https://signed.invalid/${userId}/${assetId}?signature=fixture`,
                  },
                })),
                unavailableIds: [],
              }),
          },
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
          displayName: 'Synthetic monthly fixture',
          locale: 'vi',
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
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer(config.get<string>('AUTH_JWT_ISSUER')!).setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!).setIssuedAt().setExpirationTime('10m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic monthly',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date(),
      },
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parent,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: partner,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    for (const id of [childId, otherChild])
      await prisma.child.create({
        data: {
          id,
          familyId,
          nickname: 'Synthetic child',
          birthDate: new Date('2025-01-20'),
          colorIndex: 1,
          createdBy: parent,
        },
      });
    const plan = await prisma.plan.create({
      data: {
        code: `MONTHLY_${randomUUID().slice(0, 12)}`,
        displayNameI18n: { vi: 'Synthetic' },
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
    const member = await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic',
      },
    });
    grantId = (
      await prisma.circleGrant.create({
        data: {
          familyId,
          circleMemberId: member.id,
          childId,
          permission: 'VIEW',
          createdBy: parent,
        },
      })
    ).id;
    for (const [index, id] of memories.entries()) {
      const occurredAt = new Date('2025-03-21T10:00:00Z');
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: 'MOMENT',
          status: 'PUBLISHED',
          visibility: 'FAMILY',
          occurredAt,
          occurredLocalDate: new Date('2025-03-21'),
          publishedAt: occurredAt,
        },
      });
      await prisma.memoryChild.create({
        data: { familyId, memoryId: id, childId, ageMonth: 2 },
      });
      await prisma.asset.create({
        data: {
          id: assets[index]!,
          familyId,
          uploaderUserId: parent,
          kind: 'IMAGE',
          purpose: 'MEMORY',
          status: 'READY',
          storageKey: `test/monthly/${familyId}/${index}`,
          mime: 'image/jpeg',
          declaredSize: 100n,
          sizeBytes: 100n,
        },
      });
      await prisma.memoryAsset.create({
        data: {
          familyId,
          memoryId: id,
          assetId: assets[index]!,
          sortOrder: 0,
          isCover: true,
        },
      });
    }
  });
  afterAll(async () => {
    await app?.close();
  });
  const selection = (n: number) => ({
    memoryId: memories[n],
    assetId: assets[n],
  });
  it('selects with POST, replaces with PUT, preserves old photo as a MOMENT and signs current cover', async () => {
    expect(
      data<MonthlyPhotoSelectionDto>(
        await send('post')
          .send({ monthIndex: 2, ...selection(0) })
          .expect(201),
      ),
    ).toMatchObject({
      monthIndex: 2,
      memoryId: memories[0],
      occurredAt: '2025-03-21T10:00:00.000Z',
    });
    await send('put', '/2').send(selection(1)).expect(200);
    await send('put', '/2').send(selection(1)).expect(200);
    expect(
      await prisma.monthlyPhoto.count({
        where: { familyId, childId, monthIndex: 2, deletedAt: null },
      }),
    ).toBe(1);
    expect(
      await prisma.memory.findUnique({
        where: { id: memories[0] },
        select: { kind: true, status: true, deletedAt: true },
      }),
    ).toEqual({ kind: 'MOMENT', status: 'PUBLISHED', deletedAt: null });
    expect(
      data<MonthlyPhotoSelectionDto[]>(await send('get').expect(200)),
    ).toEqual([
      {
        monthIndex: 2,
        memoryId: memories[1],
        occurredAt: '2025-03-21T10:00:00.000Z',
        url: `https://signed.invalid/${parent}/${assets[1]}?signature=fixture`,
      },
    ]);
  });
  it('serializes simultaneous replacements into one primary row', async () => {
    const results = await Promise.all([
      send('put', '/2').send(selection(0)),
      send('put', '/2').send(selection(2)),
    ]);
    expect(results.map((r) => r.status)).toEqual([200, 200]);
    expect(
      await prisma.monthlyPhoto.count({
        where: { familyId, childId, monthIndex: 2, deletedAt: null },
      }),
    ).toBe(1);
    const rows = await prisma.memory.findMany({
      where: { familyId, kind: 'MONTHLY_PHOTO', deletedAt: null },
    });
    expect(rows).toHaveLength(1);
  });
  it('handles month ends, leap years and a Vietnamese leap lunar month', async () => {
    for (const [born, shot, lunar, month] of [
      ['2025-01-31', '2025-02-28', false, 1],
      ['2024-01-31', '2024-02-29', false, 1],
      ['2023-02-20', '2023-03-22', true, 1],
      ['2023-02-20', '2023-04-20', true, 2],
    ] as const) {
      await prisma.child.update({
        where: { id: otherChild },
        data: { birthDate: new Date(born), monthlyPhotoLunar: lunar },
      });
      const memoryId = randomUUID(),
        assetId = randomUUID();
      await prisma.memory.create({
        data: {
          id: memoryId,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: 'MOMENT',
          status: 'PUBLISHED',
          visibility: 'FAMILY',
          occurredAt: new Date(shot + 'T10:00:00Z'),
          occurredLocalDate: new Date(shot),
        },
      });
      await prisma.memoryChild.create({
        data: { familyId, childId: otherChild, memoryId, ageMonth: month },
      });
      await prisma.asset.create({
        data: {
          id: assetId,
          familyId,
          uploaderUserId: parent,
          kind: 'IMAGE',
          purpose: 'MEMORY',
          status: 'READY',
          storageKey: `test/monthly/${familyId}/${assetId}`,
          mime: 'image/jpeg',
          declaredSize: 100n,
          sizeBytes: 100n,
        },
      });
      await prisma.memoryAsset.create({
        data: { familyId, memoryId, assetId, sortOrder: 0 },
      });
      await request(app.getHttpServer())
        .put(`/api/v1/children/${otherChild}/monthly-photos/${month}`)
        .set('Authorization', tokens.get(parent)!)
        .send({ memoryId, assetId })
        .expect(200);
    }
  });
  it('rejects wrong months, invalid assets, ungranted children and Circle writes', async () => {
    expect(
      (
        (await send('put', '/1').send(selection(0)).expect(422)).body as {
          error: { code: string };
        }
      ).error.code,
    ).toBe('MONTH_INDEX_MISMATCH');
    await send('put', '/241').send(selection(0)).expect(422);
    await send('put', '/2')
      .send({ memoryId: memories[0], assetId: randomUUID() })
      .expect(422);
    await send('put', '/2', circle).send(selection(0)).expect(404);
    await send('get', '', outsider).expect(404);
    await request(app.getHttpServer())
      .get(`/api/v1/children/${otherChild}/monthly-photos`)
      .set('Authorization', tokens.get(circle)!)
      .expect(404);
  });
  it('filters private, hidden, trashed and revoked content before returning monthly rows', async () => {
    const current = await prisma.monthlyPhoto.findFirstOrThrow({
      where: { familyId, childId, deletedAt: null },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(
        await send('get', '', circle).expect(200),
      ),
    ).toHaveLength(1);
    await prisma.memoryChild.updateMany({
      where: { familyId, memoryId: current.memoryId },
      data: { childId: otherChild },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(await send('get').expect(200)),
    ).toEqual([]);
    await prisma.memoryChild.updateMany({
      where: { familyId, memoryId: current.memoryId },
      data: { childId },
    });
    await prisma.memory.update({
      where: { id: current.memoryId },
      data: { occurredLocalDate: new Date('2025-02-21') },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(await send('get').expect(200)),
    ).toEqual([]);
    await prisma.memory.update({
      where: { id: current.memoryId },
      data: { occurredLocalDate: new Date('2025-03-21') },
    });
    const hide = await prisma.reportHide.create({
      data: {
        userId: circle,
        targetType: 'MEMORY',
        targetId: current.memoryId,
      },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(
        await send('get', '', circle).expect(200),
      ),
    ).toEqual([]);
    await prisma.reportHide.update({
      where: {
        userId_targetType_targetId: {
          userId: hide.userId,
          targetType: hide.targetType,
          targetId: hide.targetId,
        },
      },
      data: { deletedAt: new Date() },
    });
    await prisma.memory.update({
      where: { id: current.memoryId },
      data: { visibility: 'PARENTS' },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(
        await send('get', '', circle).expect(200),
      ),
    ).toEqual([]);
    await prisma.memory.update({
      where: { id: current.memoryId },
      data: { visibility: 'PRIVATE', authorUserId: partner },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(await send('get').expect(200)),
    ).toEqual([]);
    await prisma.memory.update({
      where: { id: current.memoryId },
      data: {
        visibility: 'FAMILY',
        authorUserId: parent,
        deletedAt: new Date(),
        status: 'TRASHED',
        trashedAt: new Date(),
        purgeAfter: new Date(Date.now() + 86400000),
      },
    });
    expect(
      data<MonthlyPhotoSelectionDto[]>(
        await send('get', '', circle).expect(200),
      ),
    ).toEqual([]);
    await prisma.memory.update({
      where: { id: current.memoryId },
      data: {
        deletedAt: null,
        status: 'PUBLISHED',
        trashedAt: null,
        purgeAfter: null,
      },
    });
    await prisma.circleGrant.update({
      where: { id: grantId },
      data: { deletedAt: new Date() },
    });
    await send('get', '', circle).expect(404);
  });
});
