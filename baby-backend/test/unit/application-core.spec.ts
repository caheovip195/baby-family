import { ForbiddenException } from '@nestjs/common';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import { DatabaseDecimal } from '../../src/common/database.types';
import {
  ConflictError,
  NotFoundError,
  ValidationError,
} from '../../src/common/errors/domain.error';
import type { CreateChildDto } from '../../src/dto/child/create-child.dto';
import type { CreatePregnancyDto } from '../../src/dto/pregnancy/create-pregnancy.dto';
import type { PrismaService } from '../../src/database/prisma.service';
import type { UpdateUserDto } from '../../src/dto/user/update-user.dto';
import type { UpdateUserSettingDto } from '../../src/dto/user-setting/update-user-setting.dto';
import type { IChildRepository } from '../../src/interfaces/repositories/child-repository.interface';
import type { IFamilyRepository } from '../../src/interfaces/repositories/family-repository.interface';
import type { IPregnancyRepository } from '../../src/interfaces/repositories/pregnancy-repository.interface';
import type { IPregnancyCommandRepository } from '../../src/interfaces/repositories/pregnancy-command-repository.interface';
import type { IUserRepository } from '../../src/interfaces/repositories/user-repository.interface';
import type { IUserSettingRepository } from '../../src/interfaces/repositories/user-setting-repository.interface';
import type { IApplicationAccessService } from '../../src/interfaces/services/application-access-service.interface';
import { Child } from '../../src/models/child.model';
import { Family } from '../../src/models/family.model';
import { Pregnancy } from '../../src/models/pregnancy.model';
import { User } from '../../src/models/user.model';
import { UserSetting } from '../../src/models/user-setting.model';
import { ChildService } from '../../src/services/child.service';
import { FamilyService } from '../../src/services/family.service';
import { PregnancyService } from '../../src/services/pregnancy.service';
import { PregnancyCommandRepository } from '../../src/repositories/pregnancy-command.repository';
import { UserService } from '../../src/services/user.service';
import { UserSettingService } from '../../src/services/user-setting.service';

const actor: AuthPrincipal = {
  userId: 'user-a',
  sessionId: 'session-a',
  tokenVersion: 1,
};
const at = new Date('2026-10-14T00:00:00.000Z');
const family = new Family({
  id: 'family-a',
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
  id: 'child-a',
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
  id: 'pregnancy-a',
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

describe('Application core services', () => {
  let users: jest.Mocked<IUserRepository>;
  let settings: jest.Mocked<IUserSettingRepository>;
  let families: jest.Mocked<IFamilyRepository>;
  let children: jest.Mocked<IChildRepository>;
  let pregnancies: jest.Mocked<IPregnancyRepository>;
  let access: jest.Mocked<IApplicationAccessService>;
  let commands: jest.Mocked<IPregnancyCommandRepository>;

  beforeEach(() => {
    users = repositoryMock<IUserRepository>();
    settings = repositoryMock<IUserSettingRepository>();
    families = repositoryMock<IFamilyRepository>();
    children = repositoryMock<IChildRepository>();
    pregnancies = repositoryMock<IPregnancyRepository>();
    access = { requireParent: jest.fn().mockResolvedValue(family) };
    commands = { createNext: jest.fn().mockResolvedValue(pregnancy) };
    users.findByKey.mockResolvedValue(user);
    users.update.mockResolvedValue(user);
    settings.findByKey.mockResolvedValue(setting);
    settings.update.mockResolvedValue(setting);
    families.update.mockResolvedValue(family);
    children.findByKey.mockResolvedValue(child);
    children.create.mockResolvedValue(child);
    children.update.mockResolvedValue(child);
    pregnancies.findByKey.mockResolvedValue(pregnancy);
    pregnancies.update.mockResolvedValue(pregnancy);
  });

  it('reads only the current user and projects out authentication metadata', async () => {
    const result = await new UserService(users).getMe(actor);
    expect(users.findByKey).toHaveBeenCalledWith(
      { privileged: true },
      { id: actor.userId },
    );
    expect(result).toMatchObject({ id: actor.userId, displayName: 'Parent' });
    expect(result).not.toHaveProperty('tokenVersion');
    expect(result).not.toHaveProperty('status');
    expect(result.createdAt).toBe(at.toISOString());
  });

  it('writes only allowed self profile fields, ignoring forged actor/state fields outside HTTP', async () => {
    await new UserService(users).updateMe(actor, {
      displayName: '  New Name  ',
      status: 'BANNED',
      id: 'another-user',
    } as UpdateUserDto);
    expect(users.update).toHaveBeenCalledWith(
      { privileged: true },
      { id: actor.userId },
      { displayName: 'New Name' },
    );
  });

  it.each([
    { displayName: '   ' },
    { displayName: null },
    { locale: 'xx' },
    { timezone: 'Invalid/Zone' },
    {},
  ])(
    'rejects invalid self profile updates %j before persistence',
    async (input) => {
      await expect(
        new UserService(users).updateMe(actor, input as UpdateUserDto),
      ).rejects.toBeInstanceOf(ValidationError);
      expect(users.update).not.toHaveBeenCalled();
    },
  );

  it('rejects standalone timezone offsets at the self service boundary', async () => {
    const service = new UserService(users);
    for (const timezone of ['+07:00', '-05:30']) {
      await expect(
        service.updateMe(actor, { timezone }),
      ).rejects.toBeInstanceOf(ValidationError);
    }
    expect(users.update).not.toHaveBeenCalled();
  });

  it('accepts UTC and IANA timezone names for the self profile', async () => {
    const service = new UserService(users);
    for (const timezone of ['UTC', 'Asia/Ho_Chi_Minh', 'Etc/GMT+7']) {
      await service.updateMe(actor, { timezone });
      expect(users.update).toHaveBeenLastCalledWith(
        { privileged: true },
        { id: actor.userId },
        { timezone },
      );
    }
  });

  it('rejects standalone timezone offsets at the family service boundary', async () => {
    const service = new FamilyService(families, access);
    for (const timezone of ['+07:00', '-05:30']) {
      await expect(
        service.update(actor, family.id, { timezone }),
      ).rejects.toBeInstanceOf(ValidationError);
    }
    expect(families.update).not.toHaveBeenCalled();
  });

  it('accepts UTC and IANA timezone names for family metadata', async () => {
    const service = new FamilyService(families, access);
    for (const timezone of ['UTC', 'Asia/Ho_Chi_Minh', 'Etc/GMT+7']) {
      await service.update(actor, family.id, { timezone });
      expect(families.update).toHaveBeenLastCalledWith(
        { privileged: true },
        { id: family.id },
        { timezone },
      );
    }
  });

  it('returns not-found for settings that have not been provisioned, without creating them on GET', async () => {
    settings.findByKey.mockResolvedValue(null);
    await expect(
      new UserSettingService(settings).getMe(actor),
    ).rejects.toBeInstanceOf(NotFoundError);
    expect(settings.create).not.toHaveBeenCalled();
  });

  it('keeps settings self-scoped and serializes decimal preferences explicitly', async () => {
    const service = new UserSettingService(settings);
    const result = await service.getMe(actor);
    expect(settings.findByKey).toHaveBeenCalledWith(
      { userId: actor.userId },
      { userId: actor.userId },
    );
    expect(result.textScale).toBe(1.25);
    expect(result).not.toHaveProperty('aiFeatures');
    await service.updateMe(actor, {
      theme: 'DARK',
      textScale: 1.5,
      aiEnabled: false,
    } as UpdateUserSettingDto);
    expect(settings.update).toHaveBeenCalledWith(
      { userId: actor.userId },
      { userId: actor.userId },
      { theme: 'DARK', textScale: '1.50' },
    );
  });

  it.each([
    { hideSensitivePreview: null },
    { theme: 'UNKNOWN' },
    { textScale: 2.1 },
    { textScale: 1.234 },
    {},
  ])('rejects unsupported settings values %j', async (input) => {
    await expect(
      new UserSettingService(settings).updateMe(
        actor,
        input as UpdateUserSettingDto,
      ),
    ).rejects.toBeInstanceOf(ValidationError);
    expect(settings.update).not.toHaveBeenCalled();
  });

  it('uses metadata and family-profile-update modes rather than a content gate for family profile', async () => {
    const service = new FamilyService(families, access);
    const result = await service.getById(actor, family.id);
    expect(access.requireParent).toHaveBeenLastCalledWith(
      actor,
      family.id,
      'metadata',
    );
    expect(result).not.toHaveProperty('settings');
    await service.update(actor, family.id, {
      name: '  New family  ',
      timezone: 'UTC',
    });
    expect(access.requireParent).toHaveBeenLastCalledWith(
      actor,
      family.id,
      'family-profile-update',
    );
    expect(families.update).toHaveBeenCalledWith(
      { privileged: true },
      { id: family.id },
      { name: 'New family', timezone: 'UTC' },
    );
  });

  it('stops before reading child data when family access is denied', async () => {
    access.requireParent.mockRejectedValue(new ForbiddenException());
    await expect(
      new ChildService(children, access).getById(actor, family.id, child.id),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(children.findByKey).not.toHaveBeenCalled();
  });

  it('creates a scoped child using the actor and valid calendar values, never client lifecycle fields', async () => {
    const service = new ChildService(children, access);
    const result = await service.create(actor, family.id, {
      name: '  Haru  ',
      birthDate: '2026-01-20',
      birthTime: '09:30',
      colorIndex: 8,
      createdBy: 'forged',
      status: 'DELETED',
      version: 99,
    } as CreateChildDto);
    expect(access.requireParent).toHaveBeenCalledWith(
      actor,
      family.id,
      'write',
    );
    expect(children.create).toHaveBeenCalledWith(
      { familyId: family.id },
      {
        name: 'Haru',
        nickname: null,
        birthDate: new Date('2026-01-20T00:00:00.000Z'),
        birthTime: new Date('1970-01-01T09:30:00.000Z'),
        colorIndex: 8,
        createdBy: actor.userId,
      },
    );
    expect(result).not.toHaveProperty('createdBy');
    expect(result).not.toHaveProperty('purgeAfter');
  });

  it.each([
    { name: ' ', birthDate: '2026-01-20', colorIndex: 1 },
    { name: 'Haru', birthDate: '2026-02-30', colorIndex: 1 },
    { name: 'Haru', birthDate: '2026-01-20T00:00:00Z', colorIndex: 1 },
    { name: 'Haru', birthDate: '2026-01-20', colorIndex: 9 },
  ])('rejects invalid child creation %j at service boundary', async (input) => {
    await expect(
      new ChildService(children, access).create(actor, family.id, input),
    ).rejects.toBeInstanceOf(ValidationError);
    expect(children.create).not.toHaveBeenCalled();
  });

  it('does not permit clearing both child names or changing inactive profile metadata', async () => {
    const service = new ChildService(children, access);
    await expect(
      service.update(actor, family.id, child.id, { name: null, nickname: ' ' }),
    ).rejects.toBeInstanceOf(ValidationError);
    children.findByKey.mockResolvedValue(
      new Child({ ...child, status: 'ARCHIVED' }),
    );
    await expect(
      service.update(actor, family.id, child.id, { name: 'New name' }),
    ).rejects.toBeInstanceOf(ConflictError);
    expect(children.update).not.toHaveBeenCalled();
  });

  it('retains tenant scope for lists and converts rows to response DTOs', async () => {
    const page = { page: 2, limit: 5 };
    children.list.mockResolvedValue({
      data: [child],
      meta: { ...page, total: 1, totalPages: 1 },
    });
    const result = await new ChildService(children, access).list(
      actor,
      family.id,
      page,
    );
    expect(access.requireParent).toHaveBeenCalledWith(actor, family.id, 'read');
    expect(children.list).toHaveBeenCalledWith({ familyId: family.id }, page);
    expect(result.data[0]?.birthDate).toBe('2026-01-20');
  });

  it('rejects edits to an ended pregnancy and preserves lifecycle ownership', async () => {
    pregnancies.findByKey.mockResolvedValue(
      new Pregnancy({ ...pregnancy, status: 'ENDED_PRIVATE' }),
    );
    await expect(
      new PregnancyService(pregnancies, access, commands).update(
        actor,
        family.id,
        pregnancy.id,
        { nickname: 'New' },
      ),
    ).rejects.toBeInstanceOf(ConflictError);
    expect(pregnancies.update).not.toHaveBeenCalled();
  });

  it('permits explicit due-date clearing and bounded count on active pregnancies', async () => {
    await new PregnancyService(pregnancies, access, commands).update(
      actor,
      family.id,
      pregnancy.id,
      { nickname: '  Baby  ', dueDate: null, expectedCount: 4 },
    );
    expect(access.requireParent).toHaveBeenCalledWith(
      actor,
      family.id,
      'write',
    );
    expect(pregnancies.update).toHaveBeenCalledWith(
      { familyId: family.id },
      { id: pregnancy.id },
      { nickname: 'Baby', dueDate: null, expectedCount: 4 },
    );
  });

  it.each([
    { expectedCount: 5 },
    { dueDate: '2026-02-30' },
    { nickname: '  ' },
    {},
  ])('rejects invalid pregnancy updates %j', async (input) => {
    await expect(
      new PregnancyService(pregnancies, access, commands).update(
        actor,
        family.id,
        pregnancy.id,
        input,
      ),
    ).rejects.toBeInstanceOf(ValidationError);
    expect(pregnancies.update).not.toHaveBeenCalled();
  });

  it('creates a pregnancy with server-controlled sequence/creator and normalized metadata', async () => {
    await new PregnancyService(pregnancies, access, commands).create(
      actor,
      family.id,
      {
        nickname: '  Baby  ',
        expectedCount: 2,
        dueDate: '2027-03-10',
        seqNo: 99,
        createdBy: 'forged',
      } as CreatePregnancyDto,
    );
    expect(access.requireParent).toHaveBeenCalledWith(
      actor,
      family.id,
      'write',
    );
    expect(commands.createNext).toHaveBeenCalledWith(family.id, {
      nickname: 'Baby',
      expectedCount: 2,
      dueDate: new Date('2027-03-10T00:00:00.000Z'),
      createdBy: actor.userId,
    });
    expect(pregnancies.create).not.toHaveBeenCalled();
  });

  it.each([
    { nickname: ' ' },
    { nickname: 'Baby', expectedCount: 0 },
    { nickname: 'Baby', expectedCount: null },
    { nickname: 'Baby', dueDate: '2026-02-30' },
  ])(
    'validates pregnancy creation %j before the command repository',
    async (input) => {
      await expect(
        new PregnancyService(pregnancies, access, commands).create(
          actor,
          family.id,
          input as CreatePregnancyDto,
        ),
      ).rejects.toBeInstanceOf(ValidationError);
      expect(commands.createNext).not.toHaveBeenCalled();
    },
  );
});

describe('Pregnancy sequence command repository', () => {
  const input = {
    nickname: 'Baby',
    expectedCount: 1,
    dueDate: null,
    createdBy: actor.userId,
  };
  function setup(max: number | null, active = true) {
    const transaction = {
      $queryRaw: jest.fn().mockResolvedValue(active ? [{ id: family.id }] : []),
      pregnancy: {
        aggregate: jest.fn().mockResolvedValue({ _max: { seqNo: max } }),
        create: jest
          .fn()
          .mockResolvedValue(
            new Pregnancy({ ...pregnancy, seqNo: (max ?? 0) + 1 }),
          ),
      },
    };
    const database = {
      $transaction: jest
        .fn()
        .mockImplementation(
          (callback: (tx: typeof transaction) => Promise<Pregnancy>) =>
            callback(transaction),
        ),
    };
    return {
      transaction,
      database,
      repository: new PregnancyCommandRepository(
        database as unknown as PrismaService,
      ),
    };
  }

  it('locks the active family using SQL parameters and includes deleted sequence history', async () => {
    const { transaction, database, repository } = setup(7);
    const result = await repository.createNext(family.id, input);
    const calls = transaction.$queryRaw.mock.calls as unknown as {
      sql: string;
      values: unknown[];
    }[][];
    const query = calls[0]?.[0];
    expect(query?.sql).toContain('FOR UPDATE');
    expect(query?.sql).not.toContain(family.id);
    expect(query?.values).toEqual([family.id]);
    expect(transaction.pregnancy.aggregate).toHaveBeenCalledWith({
      where: { familyId: family.id },
      _max: { seqNo: true },
    });
    expect(transaction.pregnancy.create).toHaveBeenCalledWith({
      data: { familyId: family.id, seqNo: 8, ...input },
    });
    expect(database.$transaction).toHaveBeenCalledWith(expect.any(Function), {
      isolationLevel: 'ReadCommitted',
      timeout: 10000,
    });
    expect(result).toBeInstanceOf(Pregnancy);
    expect(result.seqNo).toBe(8);
  });

  it('starts at one and refuses smallint overflow before insert', async () => {
    const first = setup(null);
    await first.repository.createNext(family.id, input);
    expect(first.transaction.pregnancy.create).toHaveBeenCalledWith({
      data: { familyId: family.id, seqNo: 1, ...input },
    });
    const overflow = setup(32767);
    await expect(
      overflow.repository.createNext(family.id, input),
    ).rejects.toBeInstanceOf(ConflictError);
    expect(overflow.transaction.pregnancy.create).not.toHaveBeenCalled();
  });

  it('rechecks family lifecycle while holding the transaction lock', async () => {
    const { transaction, repository } = setup(1, false);
    await expect(
      repository.createNext(family.id, input),
    ).rejects.toBeInstanceOf(ConflictError);
    expect(transaction.pregnancy.aggregate).not.toHaveBeenCalled();
    expect(transaction.pregnancy.create).not.toHaveBeenCalled();
  });
});
