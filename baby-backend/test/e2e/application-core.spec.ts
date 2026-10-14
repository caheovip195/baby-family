import {
  ForbiddenException,
  UnauthorizedException,
  ValidationPipe,
} from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { APP_FILTER } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import type { Server } from 'node:http';
import { PinoLogger } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import { DatabaseDecimal } from '../../src/common/database.types';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ChildController } from '../../src/controllers/child.controller';
import { FamilyController } from '../../src/controllers/family.controller';
import { PregnancyController } from '../../src/controllers/pregnancy.controller';
import { UserController } from '../../src/controllers/user.controller';
import { UserSettingController } from '../../src/controllers/user-setting.controller';
import { CHILD_REPOSITORY } from '../../src/interfaces/repositories/child-repository.interface';
import type { IChildRepository } from '../../src/interfaces/repositories/child-repository.interface';
import { FAMILY_REPOSITORY } from '../../src/interfaces/repositories/family-repository.interface';
import type { IFamilyRepository } from '../../src/interfaces/repositories/family-repository.interface';
import { PREGNANCY_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-repository.interface';
import type { IPregnancyRepository } from '../../src/interfaces/repositories/pregnancy-repository.interface';
import { PREGNANCY_COMMAND_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-command-repository.interface';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import type { IUserRepository } from '../../src/interfaces/repositories/user-repository.interface';
import { USER_SETTING_REPOSITORY } from '../../src/interfaces/repositories/user-setting-repository.interface';
import type { IUserSettingRepository } from '../../src/interfaces/repositories/user-setting-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { CHILD_SERVICE } from '../../src/interfaces/services/child-service.interface';
import { FAMILY_SERVICE } from '../../src/interfaces/services/family-service.interface';
import { PREGNANCY_SERVICE } from '../../src/interfaces/services/pregnancy-service.interface';
import { USER_SERVICE } from '../../src/interfaces/services/user-service.interface';
import { USER_SETTING_SERVICE } from '../../src/interfaces/services/user-setting-service.interface';
import { Child } from '../../src/models/child.model';
import { Family } from '../../src/models/family.model';
import { Pregnancy } from '../../src/models/pregnancy.model';
import { User } from '../../src/models/user.model';
import { UserSetting } from '../../src/models/user-setting.model';
import { ChildService } from '../../src/services/child.service';
import { FamilyService } from '../../src/services/family.service';
import { PregnancyService } from '../../src/services/pregnancy.service';
import { UserService } from '../../src/services/user.service';
import { UserSettingService } from '../../src/services/user-setting.service';

const actor: AuthPrincipal = {
  userId: '11111111-1111-4111-8111-111111111111',
  sessionId: '44444444-4444-4444-8444-444444444444',
  tokenVersion: 1,
};
const at = new Date('2026-10-14T00:00:00.000Z');
const family = new Family({
  id: '019aaf21-19e0-7000-8000-000000000001',
  name: 'Family',
  coverAssetId: null,
  status: 'ACTIVE',
  activatedAt: at,
  timezone: 'Asia/Ho_Chi_Minh',
  contentLocale: 'vi',
  settings: {},
  accessVersion: 1,
  createdBy: actor.userId,
  createdAt: at,
  updatedAt: at,
  deletionScheduledAt: null,
  deletedAt: null,
});
const user = new User({
  id: actor.userId,
  displayName: 'Parent',
  avatarAssetId: null,
  locale: 'vi',
  timezone: 'Asia/Ho_Chi_Minh',
  status: 'ACTIVE',
  onboardingRole: 'PARENT_FATHER',
  tokenVersion: 99,
  lastActiveAt: at,
  createdAt: at,
  updatedAt: at,
  deletedAt: null,
});
const setting = new UserSetting({
  userId: actor.userId,
  notificationPrefs: {},
  quietStart: at,
  quietEnd: at,
  hideSensitivePreview: true,
  circleDigestMode: 'DIGEST',
  circleDigestTime: at,
  moodShareDefault: 'ASK',
  requestSoonBypassQuiet: false,
  usLockEnabled: false,
  aiEnabled: true,
  aiFeatures: { private: true },
  theme: 'SYSTEM',
  textScale: new DatabaseDecimal('1.25'),
  showLunar: true,
  memoryPromptsEnabled: true,
  perspectiveSuggest: true,
  dailyStorySuggest: true,
  createdAt: at,
  updatedAt: at,
  deletedAt: null,
});
const child = new Child({
  id: '019aaf21-19e0-7000-8000-000000000002',
  familyId: family.id,
  pregnancyId: null,
  birthOrder: null,
  name: 'Haru',
  nickname: 'Little',
  birthDate: new Date('2026-01-20T00:00:00.000Z'),
  birthTime: null,
  gender: 'UNSPECIFIED',
  colorIndex: 1,
  avatarAssetId: null,
  coverAssetId: null,
  profile: {},
  birthStats: null,
  status: 'ACTIVE',
  sortOrder: 0,
  monthlyPhotoMode: 'AUTO',
  monthlyPhotoLunar: false,
  createdBy: actor.userId,
  createdAt: at,
  updatedAt: at,
  archivedAt: null,
  version: 1,
  deletedAt: null,
  deletionRequestedAt: null,
  purgeAfter: null,
});
const pregnancy = new Pregnancy({
  id: '22222222-2222-4222-8222-222222222222',
  familyId: family.id,
  seqNo: 1,
  nickname: 'Baby',
  dueDate: null,
  expectedCount: 1,
  status: 'ACTIVE',
  coverAssetId: null,
  showSizeContent: true,
  carrierUserId: actor.userId,
  bumpPhotoCadence: 'WEEKLY',
  createdBy: actor.userId,
  createdAt: at,
  updatedAt: at,
  completedAt: null,
  version: 1,
  deletedAt: null,
});

function repositoryMock<T>(): jest.Mocked<T> {
  return {
    create: jest.fn(),
    findByKey: jest.fn(),
    list: jest.fn(),
    update: jest.fn(),
    softDelete: jest.fn(),
  } as unknown as jest.Mocked<T>;
}

describe('Authenticated application core HTTP boundary', () => {
  let app: INestApplication<Server>;
  const users = repositoryMock<IUserRepository>();
  const settings = repositoryMock<IUserSettingRepository>();
  const families = repositoryMock<IFamilyRepository>();
  const children = repositoryMock<IChildRepository>();
  const pregnancies = repositoryMock<IPregnancyRepository>();
  const commands = { createNext: jest.fn().mockResolvedValue(pregnancy) };
  const authorization = 'Bearer test.token.signature';
  const access: jest.Mocked<IApplicationAccessService> = {
    requireParent: jest
      .fn()
      .mockImplementation((_actor: AuthPrincipal, id: string) => {
        if (id !== family.id)
          return Promise.reject(
            new ForbiddenException('Parent membership required.'),
          );
        return Promise.resolve(family);
      }),
  };
  const authentication = {
    verifyAccessToken: jest.fn().mockImplementation((token: string) => {
      if (token !== 'test.token.signature')
        return Promise.reject(new UnauthorizedException());
      return Promise.resolve(actor);
    }),
  };

  beforeAll(async () => {
    users.findByKey.mockResolvedValue(user);
    users.update.mockImplementation((_scope, _key, input) =>
      Promise.resolve(new User({ ...user, ...input })),
    );
    settings.findByKey.mockResolvedValue(setting);
    settings.update.mockResolvedValue(setting);
    families.update.mockImplementation((_scope, _key, input) =>
      Promise.resolve(
        new Family({ ...family, ...input, settings: family.settings }),
      ),
    );
    children.findByKey.mockImplementation((_scope, key) =>
      Promise.resolve(key.id === child.id ? child : null),
    );
    children.list.mockResolvedValue({
      data: [child],
      meta: { page: 1, limit: 20, total: 1, totalPages: 1 },
    });
    children.create.mockImplementation((_scope, input) =>
      Promise.resolve(
        new Child({
          ...child,
          ...input,
          profile: child.profile,
          birthStats: child.birthStats,
        }),
      ),
    );
    children.update.mockImplementation((_scope, _key, input) =>
      Promise.resolve(
        new Child({
          ...child,
          ...input,
          profile: child.profile,
          birthStats: child.birthStats,
        }),
      ),
    );
    pregnancies.findByKey.mockResolvedValue(pregnancy);
    pregnancies.list.mockResolvedValue({
      data: [pregnancy],
      meta: { page: 1, limit: 20, total: 1, totalPages: 1 },
    });
    pregnancies.update.mockImplementation((_scope, _key, input) =>
      Promise.resolve(new Pregnancy({ ...pregnancy, ...input })),
    );
    const module = await Test.createTestingModule({
      controllers: [
        UserController,
        UserSettingController,
        FamilyController,
        ChildController,
        PregnancyController,
      ],
      providers: [
        AccessTokenGuard,
        { provide: AUTHENTICATION_SERVICE, useValue: authentication },
        { provide: APPLICATION_ACCESS_SERVICE, useValue: access },
        { provide: USER_REPOSITORY, useValue: users },
        { provide: USER_SETTING_REPOSITORY, useValue: settings },
        { provide: FAMILY_REPOSITORY, useValue: families },
        { provide: CHILD_REPOSITORY, useValue: children },
        { provide: PREGNANCY_REPOSITORY, useValue: pregnancies },
        { provide: PREGNANCY_COMMAND_REPOSITORY, useValue: commands },
        { provide: USER_SERVICE, useClass: UserService },
        { provide: USER_SETTING_SERVICE, useClass: UserSettingService },
        { provide: FAMILY_SERVICE, useClass: FamilyService },
        { provide: CHILD_SERVICE, useClass: ChildService },
        { provide: PREGNANCY_SERVICE, useClass: PregnancyService },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: PinoLogger, useValue: { error: jest.fn() } },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
        forbidUnknownValues: true,
      }),
    );
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('requires a verified principal, rather than accepting user IDs from headers', async () => {
    await request(app.getHttpServer())
      .get('/api/v1/me')
      .set('X-User-Id', actor.userId)
      .expect(401);
    await request(app.getHttpServer())
      .get('/api/v1/me')
      .set('Authorization', 'Bearer invalid.token.sig')
      .expect(401);
  });

  it('gets the current profile without token, role or state internals', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1/me')
      .set('Authorization', authorization)
      .expect(200);
    expect(response.body).toMatchObject({
      id: actor.userId,
      displayName: 'Parent',
    });
    expect(response.body).not.toHaveProperty('tokenVersion');
    expect(response.body).not.toHaveProperty('onboardingRole');
    expect(users.findByKey).toHaveBeenCalledWith(
      { privileged: true },
      { id: actor.userId },
    );
  });

  it('rejects mass assignment and validates self profile fields', async () => {
    for (const input of [
      { displayName: 'Parent', tokenVersion: 100 },
      { id: child.id },
      { displayName: null },
      { timezone: 'Wrong/Zone' },
      { locale: 'xx' },
      {},
    ]) {
      await request(app.getHttpServer())
        .patch('/api/v1/me')
        .set('Authorization', authorization)
        .send(input)
        .expect(400);
    }
    expect(users.update).not.toHaveBeenCalled();
  });

  it('trims an allowed profile update and always targets the verified user', async () => {
    const response = await request(app.getHttpServer())
      .patch('/api/v1/me')
      .set('Authorization', authorization)
      .send({ displayName: '  Updated  ', locale: 'en' })
      .expect(200);
    expect(response.body).toMatchObject({ displayName: 'Updated' });
    expect(users.update).toHaveBeenCalledWith(
      { privileged: true },
      { id: actor.userId },
      { displayName: 'Updated', locale: 'en' },
    );
  });

  it('rejects standalone timezone offsets for both profile endpoints', async () => {
    for (const path of ['/api/v1/me', '/api/v1/families/' + family.id]) {
      for (const timezone of ['+07:00', '-05:30']) {
        await request(app.getHttpServer())
          .patch(path)
          .set('Authorization', authorization)
          .send({ timezone })
          .expect(400);
      }
    }
    expect(users.update).not.toHaveBeenCalled();
    expect(families.update).not.toHaveBeenCalled();
  });

  it('accepts named timezones, including UTC and Etc/GMT aliases, through HTTP', async () => {
    for (const path of ['/api/v1/me', '/api/v1/families/' + family.id]) {
      for (const timezone of ['UTC', 'Asia/Ho_Chi_Minh', 'Etc/GMT+7']) {
        await request(app.getHttpServer())
          .patch(path)
          .set('Authorization', authorization)
          .send({ timezone })
          .expect(200);
      }
    }
  });

  it('exposes primitive personal settings while excluding AI/consent mutation', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1/me/settings')
      .set('Authorization', authorization)
      .expect(200);
    expect(response.body).toMatchObject({ textScale: 1.25 });
    expect(response.body).not.toHaveProperty('aiEnabled');
    await request(app.getHttpServer())
      .patch('/api/v1/me/settings')
      .set('Authorization', authorization)
      .send({ theme: 'DARK', textScale: 1.5 })
      .expect(200);
    expect(settings.update).toHaveBeenCalledWith(
      { userId: actor.userId },
      { userId: actor.userId },
      { theme: 'DARK', textScale: '1.50' },
    );
    await request(app.getHttpServer())
      .patch('/api/v1/me/settings')
      .set('Authorization', authorization)
      .send({ aiEnabled: true })
      .expect(400);
    await request(app.getHttpServer())
      .patch('/api/v1/me/settings')
      .set('Authorization', authorization)
      .send({ hideSensitivePreview: 'false' })
      .expect(400);
  });

  it('uses the family metadata gate and supports database UUIDv7 routes', async () => {
    await request(app.getHttpServer())
      .get('/api/v1/families/' + family.id)
      .set('Authorization', authorization)
      .expect(200);
    expect(access.requireParent).toHaveBeenCalledWith(
      actor,
      family.id,
      'metadata',
    );
    await request(app.getHttpServer())
      .patch('/api/v1/families/' + family.id)
      .set('Authorization', authorization)
      .send({ name: '  New family  ' })
      .expect(200);
    expect(access.requireParent).toHaveBeenCalledWith(
      actor,
      family.id,
      'family-profile-update',
    );
    expect(families.update).toHaveBeenCalledWith(
      { privileged: true },
      { id: family.id },
      { name: 'New family' },
    );
  });

  it('blocks cross-family reads before executing resource persistence', async () => {
    await request(app.getHttpServer())
      .get('/api/v1/families/33333333-3333-4333-8333-333333333333/children')
      .set('Authorization', authorization)
      .expect(403);
    expect(children.list).not.toHaveBeenCalled();
  });

  it('keeps family state and activation fields server-managed', async () => {
    await request(app.getHttpServer())
      .patch('/api/v1/families/' + family.id)
      .set('Authorization', authorization)
      .send({ status: 'ACTIVE', accessVersion: 9 })
      .expect(400);
    expect(families.update).not.toHaveBeenCalled();
  });

  it('creates a child with safe fields and a server-derived creator', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/v1/families/' + family.id + '/children')
      .set('Authorization', authorization)
      .send({ nickname: '  Little  ', birthDate: '2026-01-20', colorIndex: 2 })
      .expect(201);
    expect(response.body).toMatchObject({
      nickname: 'Little',
      birthDate: '2026-01-20',
      colorIndex: 2,
    });
    expect(response.body).not.toHaveProperty('createdBy');
    expect(children.create).toHaveBeenCalledWith(
      { familyId: family.id },
      expect.objectContaining({ createdBy: actor.userId, nickname: 'Little' }),
    );
  });

  it.each([
    { name: 'Haru', birthDate: '2026-02-30', colorIndex: 2 },
    { name: ' ', birthDate: '2026-01-20', colorIndex: 2 },
    { name: 'Haru', birthDate: '2026-01-20', colorIndex: 0 },
    {
      name: 'Haru',
      birthDate: '2026-01-20',
      colorIndex: 1,
      createdBy: 'forged',
    },
    { name: 'Haru', birthDate: '2026-01-20', colorIndex: 1, status: 'DELETED' },
  ])('rejects unsafe child creation %j', async (input) => {
    await request(app.getHttpServer())
      .post('/api/v1/families/' + family.id + '/children')
      .set('Authorization', authorization)
      .send(input)
      .expect(400);
    expect(children.create).not.toHaveBeenCalled();
  });

  it('validates pagination and resource identifiers and shapes child responses', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1/families/' + family.id + '/children?page=2&limit=5')
      .set('Authorization', authorization)
      .expect(200);
    expect(children.list).toHaveBeenCalledWith(
      { familyId: family.id },
      expect.objectContaining({ page: 2, limit: 5 }),
    );
    const body = response.body as { data: Record<string, unknown>[] };
    expect(body.data[0]).not.toHaveProperty('birthStats');
    await request(app.getHttpServer())
      .get('/api/v1/families/' + family.id + '/children?limit=101')
      .set('Authorization', authorization)
      .expect(400);
    await request(app.getHttpServer())
      .get('/api/v1/families/' + family.id + '/children/not-a-uuid')
      .set('Authorization', authorization)
      .expect(400);
    await request(app.getHttpServer())
      .get('/api/v1/families/' + family.id + '/children/' + child.id)
      .set('Authorization', authorization)
      .expect(200);
  });

  it('permits explicit pregnancy due-date clearing but rejects lifecycle/count changes', async () => {
    await request(app.getHttpServer())
      .patch('/api/v1/families/' + family.id + '/pregnancies/' + pregnancy.id)
      .set('Authorization', authorization)
      .send({ dueDate: null, expectedCount: 2 })
      .expect(200);
    expect(pregnancies.update).toHaveBeenCalledWith(
      { familyId: family.id },
      { id: pregnancy.id },
      { dueDate: null, expectedCount: 2 },
    );
    await request(app.getHttpServer())
      .patch('/api/v1/families/' + family.id + '/pregnancies/' + pregnancy.id)
      .set('Authorization', authorization)
      .send({ expectedCount: 5 })
      .expect(400);
    await request(app.getHttpServer())
      .patch('/api/v1/families/' + family.id + '/pregnancies/' + pregnancy.id)
      .set('Authorization', authorization)
      .send({ status: 'COMPLETED' })
      .expect(400);
  });

  it('creates pregnancy metadata through the sequence command repository', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/v1/families/' + family.id + '/pregnancies')
      .set('Authorization', authorization)
      .send({ nickname: '  Baby  ' })
      .expect(201);
    expect(response.body).toMatchObject({ seqNo: 1, nickname: 'Baby' });
    expect(response.body).not.toHaveProperty('createdBy');
    expect(commands.createNext).toHaveBeenCalledWith(family.id, {
      nickname: 'Baby',
      dueDate: null,
      expectedCount: 1,
      createdBy: actor.userId,
    });
    expect(pregnancies.create).not.toHaveBeenCalled();
  });

  it.each([
    { nickname: 'Baby', seqNo: 99 },
    { nickname: 'Baby', expectedCount: 5 },
    { nickname: ' ' },
    { nickname: 'Baby', createdBy: 'forged' },
  ])('rejects unsafe pregnancy creation %j', async (input) => {
    await request(app.getHttpServer())
      .post('/api/v1/families/' + family.id + '/pregnancies')
      .set('Authorization', authorization)
      .send(input)
      .expect(400);
    expect(commands.createNext).not.toHaveBeenCalled();
  });

  it('does not expose unsupported destructive or pregnancy-conversion endpoints', async () => {
    await request(app.getHttpServer())
      .post(
        '/api/v1/families/' +
          family.id +
          '/pregnancies/' +
          pregnancy.id +
          '/birth',
      )
      .set('Authorization', authorization)
      .send({})
      .expect(404);
    await request(app.getHttpServer())
      .delete('/api/v1/families/' + family.id + '/children/' + child.id)
      .set('Authorization', authorization)
      .expect(404);
    await request(app.getHttpServer())
      .post('/api/v1/families/' + family.id + '/activate')
      .set('Authorization', authorization)
      .send({})
      .expect(404);
  });
});
