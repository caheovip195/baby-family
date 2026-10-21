import { randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { UnauthorizedException, ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { MeFamiliesController } from '../../src/controllers/me-families.controller';
import { PrismaService } from '../../src/database/prisma.service';
import type { MeFamilyResponse } from '../../src/dto/me-families/me-families.dto';
import { ME_FAMILIES_REPOSITORY } from '../../src/interfaces/repositories/me-families-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { ME_FAMILIES_SERVICE } from '../../src/interfaces/services/me-families-service.interface';
import { PROFILE_IMAGE_SERVICE } from '../../src/interfaces/services/profile-image-service.interface';
import { MeFamiliesRepository } from '../../src/repositories/me-families.repository';
import { PreferenceSettingsRepository } from '../../src/repositories/preference-settings.repository';
import { MeFamiliesService } from '../../src/services/me-families.service';

const payload = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;

describe('FAM-08 my families (focused Nest + PostgreSQL)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let preferences: PreferenceSettingsRepository;
  const user = randomUUID(),
    owner = randomUUID();
  const own = randomUUID(),
    other = randomUUID(),
    unrelated = randomUUID();
  const child = randomUUID(),
    member = randomUUID();
  const covers = jest.fn((fid: string) =>
    Promise.resolve({
      coverUrl: `https://signed.example.test/${fid}?signature=synthetic`,
      coverUrlExpiresAt: new Date(),
    }),
  );
  const http = () => request(app.getHttpServer());
  const get = () =>
    http().get('/api/v1/me/families').set('Authorization', 'Bearer fixture');
  const select = (familyId: string) =>
    http()
      .put('/api/v1/me/default-family')
      .set('Authorization', 'Bearer fixture')
      .send({ familyId });
  const list = async () =>
    payload<{ items: MeFamilyResponse[] }>(await get().expect(200)).items;

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MeFamiliesController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        PreferenceSettingsRepository,
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 4,
          }),
        },
        {
          provide: AUTHENTICATION_SERVICE,
          useValue: {
            verifyAccessToken: (token: string) => {
              if (token !== 'fixture') throw new UnauthorizedException();
              return Promise.resolve({
                userId: user,
                sessionId: randomUUID(),
                tokenVersion: 1,
              });
            },
          },
        },
        { provide: ME_FAMILIES_SERVICE, useClass: MeFamiliesService },
        { provide: ME_FAMILIES_REPOSITORY, useClass: MeFamiliesRepository },
        { provide: PROFILE_IMAGE_SERVICE, useValue: { familyCover: covers } },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication();
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
    preferences = module.get(PreferenceSettingsRepository);
    await prisma.user.createMany({
      data: [
        { id: user, displayName: 'Synthetic switcher' },
        { id: owner, displayName: 'Synthetic owner' },
      ],
    });
    await prisma.family.createMany({
      data: [
        { id: own, name: 'Own waiting family', createdBy: user },
        {
          id: other,
          name: 'Other active family',
          createdBy: owner,
          status: 'ACTIVE',
          activatedAt: new Date(),
        },
        { id: unrelated, name: 'Unrelated family', createdBy: owner },
      ],
    });
    await prisma.familyParent.create({
      data: {
        familyId: own,
        userId: user,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await prisma.circleMember.create({
      data: {
        id: member,
        familyId: other,
        userId: user,
        relation: 'OTHER',
        displayName: 'Synthetic relative',
      },
    });
    await prisma.child.create({
      data: {
        id: child,
        familyId: other,
        name: 'Hidden synthetic child',
        colorIndex: 1,
        birthDate: new Date('2024-01-01'),
        createdBy: owner,
      },
    });
  });

  afterAll(async () => {
    if (prisma) {
      await prisma.circleGrant.deleteMany({
        where: { familyId: { in: [own, other, unrelated] } },
      });
      await prisma.child.deleteMany({ where: { id: child } });
      await prisma.circleMember.deleteMany({ where: { id: member } });
      await prisma.familyParent.deleteMany({ where: { familyId: own } });
      await prisma.userSetting.deleteMany({
        where: { userId: { in: [user, owner] } },
      });
      await prisma.family.deleteMany({
        where: { id: { in: [own, other, unrelated] } },
      });
      await prisma.user.deleteMany({ where: { id: { in: [user, owner] } } });
    }
    await app?.close();
  });

  it('requires authentication and validates UUID/unknown request keys', async () => {
    await http().get('/api/v1/me/families').expect(401);
    await select('invalid').expect(400);
    await http()
      .put('/api/v1/me/default-family')
      .set('Authorization', 'Bearer fixture')
      .send({ familyId: own, role: 'PARENT' })
      .expect(400);
  });

  it('lists Parent and Circle metadata without exposing children, defaults to Parent', async () => {
    const items = await list();
    expect(items).toHaveLength(2);
    expect(items[0]).toMatchObject({
      familyId: own,
      role: 'PARENT',
      status: { family: 'WAITING_PARTNER', membership: 'ACTIVE' },
      isDefault: true,
    });
    expect(items[1]).toEqual({
      familyId: other,
      name: 'Other active family',
      role: 'CIRCLE',
      status: { family: 'ACTIVE', membership: 'ACTIVE' },
      coverUrl: null,
      isDefault: false,
    });
    expect(JSON.stringify(items)).not.toContain(child);
  });

  it('never exposes a family cover to Circle, including with a partial grant', async () => {
    await prisma.circleGrant.create({
      data: {
        familyId: other,
        circleMemberId: member,
        childId: child,
        permission: 'VIEW',
        createdBy: owner,
      },
    });
    expect((await list())[1]?.coverUrl).toBeNull();
    expect(covers.mock.calls.every(([fid]) => fid === own)).toBe(true);
    await prisma.circleMember.update({
      where: { id: member },
      data: { status: 'PAUSED' },
    });
    expect((await list())[1]).toMatchObject({
      coverUrl: null,
      status: { family: 'ACTIVE', membership: 'PAUSED' },
    });
  });

  it('persists default context without transferring Parent membership (BR-057)', async () => {
    await select(other).expect(200, { data: { familyId: other } });
    expect(
      (await list())
        .filter((item) => item.isDefault)
        .map((item) => item.familyId),
    ).toEqual([other]);
    expect(
      await prisma.familyParent.count({
        where: { userId: user, familyId: own, status: 'ACTIVE' },
      }),
    ).toBe(1);
    expect(
      await prisma.familyParent.count({
        where: { userId: user, familyId: other },
      }),
    ).toBe(0);
  });

  it('preserves notification keys and context across stale/concurrent notification updates', async () => {
    await preferences.update(user, {
      notificationPrefs: { version: 1, categories: { MEMORY: false } },
    });
    await Promise.all([
      select(own).expect(200),
      preferences.update(user, {
        notificationPrefs: { version: 1, categories: { MEMORY: true } },
      }),
    ]);
    const settings = await prisma.userSetting.findUniqueOrThrow({
      where: { userId: user },
    });
    expect(settings.notificationPrefs).toMatchObject({
      categories: { MEMORY: true },
      familyContext: { version: 1, defaultFamilyId: own },
    });
  });

  it('rejects unrelated families without revealing their existence', async () => {
    for (const fid of [unrelated, randomUUID()]) {
      const response = await select(fid).expect(404);
      expect((response.body as { error: { code: string } }).error.code).toBe(
        'NOT_FOUND',
      );
    }
  });

  it('removes ended/revoked memberships and safely falls back from a stale default', async () => {
    await select(other).expect(200);
    await prisma.circleMember.update({
      where: { id: member },
      data: { status: 'LEFT', endedAt: new Date() },
    });
    expect(
      (await list()).map((item) => [item.familyId, item.isDefault]),
    ).toEqual([[own, true]]);
    await select(other).expect(404);
  });

  it('filters soft-deleted families and does not resurrect deleted settings', async () => {
    await prisma.family.update({
      where: { id: own },
      data: { deletedAt: new Date() },
    });
    expect(await list()).toEqual([]);
    await select(own).expect(404);
    await prisma.family.update({
      where: { id: own },
      data: { deletedAt: null },
    });
    await prisma.userSetting.update({
      where: { userId: user },
      data: { deletedAt: new Date() },
    });
    await select(own).expect(404);
  });
});
