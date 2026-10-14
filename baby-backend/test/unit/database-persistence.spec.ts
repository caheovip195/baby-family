import { Prisma } from '../../src/generated/prisma/client';
import type { PrismaService } from '../../src/database/prisma.service';
import { ValidationError } from '../../src/common/errors/domain.error';
import {
  DatabaseDecimal,
  DATABASE_JSON_NULL,
  DATABASE_NULL,
} from '../../src/common/database.types';
import {
  toPrismaJson,
  toPrismaDecimal,
} from '../../src/repositories/database.mapping';
import { AiUsageMonthlyRepository } from '../../src/repositories/ai-usage-monthly.repository';
import { UserSettingRepository } from '../../src/repositories/user-setting.repository';
import { MemoryRepository } from '../../src/repositories/memory.repository';
import { OutboxEventRepository } from '../../src/repositories/outbox-event.repository';
import { HeartLedgerRepository } from '../../src/repositories/heart-ledger.repository';
import { MissionCompletionRepository } from '../../src/repositories/mission-completion.repository';
import { JobAttemptRepository } from '../../src/repositories/job-attempt.repository';
import { AiUsageMonthly } from '../../src/models/ai-usage-monthly.model';
import { UserSetting } from '../../src/models/user-setting.model';
import type { UpdateAiUsageMonthlyInput } from '../../src/interfaces/repositories/ai-usage-monthly-repository.interface';
import type { OutboxEventRepositoryScope } from '../../src/interfaces/repositories/outbox-event-repository.interface';
import { PERSISTENCE_TABLES } from '../../src/database/persistence.manifest';
import { DATABASE_REPOSITORY_PROVIDERS } from '../../src/database/repository.providers';

const now = new Date('2026-10-14T00:00:00.000Z');
const month = new Date('2026-10-01T00:00:00.000Z');
const monthlyRow = {
  familyId: 'family-a',
  month,
  used: 3,
  createdAt: now,
  updatedAt: now,
  deletedAt: null,
};
const scope = { familyId: 'family-a' };
const key = { familyId: 'family-a', month };
function monthlyFixture() {
  const delegate = {
    create: jest.fn().mockResolvedValue(monthlyRow),
    findFirst: jest.fn().mockResolvedValue(monthlyRow),
    findMany: jest.fn().mockResolvedValue([monthlyRow]),
    count: jest.fn().mockResolvedValue(1),
    updateMany: jest.fn().mockResolvedValue({ count: 1 }),
    findFirstOrThrow: jest.fn().mockResolvedValue(monthlyRow),
  };
  const transaction = jest.fn(async (operation: unknown) => {
    if (Array.isArray(operation))
      return Promise.all(operation as Promise<unknown>[]);
    return (operation as (tx: unknown) => Promise<unknown>)({
      aiUsageMonthly: delegate,
    });
  });
  const prisma = {
    aiUsageMonthly: delegate,
    $transaction: transaction,
  } as unknown as PrismaService;
  return {
    delegate,
    transaction,
    repository: new AiUsageMonthlyRepository(prisma),
  };
}

describe('Generated persistence contracts', () => {
  it('covers each non-Note Prisma table with a concrete DI provider', () => {
    expect(PERSISTENCE_TABLES).toHaveLength(122);
    expect(DATABASE_REPOSITORY_PROVIDERS).toHaveLength(122);
    expect(
      new Set(
        PERSISTENCE_TABLES.map((table) => `${table.schema}.${table.table}`),
      ).size,
    ).toBe(122);
    expect(PERSISTENCE_TABLES.filter((table) => table.appendOnly)).toHaveLength(
      18,
    );
    expect(
      PERSISTENCE_TABLES.find((table) => table.model === 'Memory')?.unsupported,
    ).toEqual(['search_tsv']);
  });

  it('maps rows to model instances and preserves composite primary keys', async () => {
    const { repository, delegate } = monthlyFixture();
    const result = await repository.findByKey(scope, key);
    expect(result).toBeInstanceOf(AiUsageMonthly);
    expect(result?.getKey()).toEqual(key);
    expect(result?.isDeleted()).toBe(false);
    expect(delegate.findFirst).toHaveBeenCalledWith({
      where: { ...key, deletedAt: null },
    });
  });

  it('rejects a conflicting tenant and incomplete primary key before querying', async () => {
    const { repository, delegate } = monthlyFixture();
    await expect(
      repository.findByKey(scope, { ...key, familyId: 'other-family' }),
    ).rejects.toBeInstanceOf(ValidationError);
    await expect(
      repository.findByKey(scope, { familyId: 'family-a' } as typeof key),
    ).rejects.toBeInstanceOf(ValidationError);
    expect(delegate.findFirst).not.toHaveBeenCalled();
  });

  it('uses the same active tenant predicate and stable key order for page/count', async () => {
    const { repository, delegate, transaction } = monthlyFixture();
    const page = await repository.list(scope, { page: 2, limit: 10 });
    expect(delegate.findMany).toHaveBeenCalledWith({
      where: { familyId: 'family-a', deletedAt: null },
      skip: 10,
      take: 10,
      orderBy: [{ familyId: 'asc' }, { month: 'asc' }],
    });
    expect(delegate.count).toHaveBeenCalledWith({
      where: { familyId: 'family-a', deletedAt: null },
    });
    expect(transaction).toHaveBeenCalledWith(expect.any(Array), {
      isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead,
    });
    expect(page.data[0]).toBeInstanceOf(AiUsageMonthly);
    expect(page.meta).toEqual({ page: 2, limit: 10, total: 1, totalPages: 1 });
  });

  it('rejects unbounded pagination before any database call', async () => {
    const { repository, delegate } = monthlyFixture();
    await expect(
      repository.list(scope, { page: 1, limit: 101 }),
    ).rejects.toBeInstanceOf(ValidationError);
    expect(delegate.findMany).not.toHaveBeenCalled();
    expect(delegate.count).not.toHaveBeenCalled();
  });

  it('injects scope and leaves audit/default fields for PostgreSQL on create', async () => {
    const { repository, delegate } = monthlyFixture();
    expect(await repository.create(scope, { month })).toBeInstanceOf(
      AiUsageMonthly,
    );
    expect(delegate.create).toHaveBeenCalledWith({
      data: { familyId: 'family-a', month },
    });
  });

  it('updates atomically and returns null if another operation removed the active row', async () => {
    const { repository, delegate } = monthlyFixture();
    delegate.updateMany.mockResolvedValueOnce({ count: 0 });
    expect(await repository.update(scope, key, { used: 4 })).toBeNull();
    expect(delegate.findFirstOrThrow).not.toHaveBeenCalled();
    expect(await repository.update(scope, key, { used: 4 })).toBeInstanceOf(
      AiUsageMonthly,
    );
    expect(delegate.updateMany).toHaveBeenLastCalledWith({
      where: { ...key, deletedAt: null },
      data: { used: 4 },
    });
  });

  it('rejects audit/tenant writes and empty updates', async () => {
    const { repository, delegate } = monthlyFixture();
    await expect(
      repository.update(scope, key, {
        deletedAt: now,
      } as unknown as UpdateAiUsageMonthlyInput),
    ).rejects.toBeInstanceOf(ValidationError);
    await expect(repository.update(scope, key, {})).rejects.toBeInstanceOf(
      ValidationError,
    );
    expect(delegate.updateMany).not.toHaveBeenCalled();
  });

  it('soft-deletes only an active scoped row and returns false on repeat', async () => {
    const { repository, delegate } = monthlyFixture();
    delegate.updateMany
      .mockResolvedValueOnce({ count: 1 })
      .mockResolvedValueOnce({ count: 0 });
    expect(await repository.softDelete(scope, key)).toBe(true);
    expect(await repository.softDelete(scope, key)).toBe(false);
    expect(delegate.updateMany).toHaveBeenCalledWith({
      where: { ...key, deletedAt: null },
      data: { deletedAt: expect.any(Date) },
    });
  });

  it('preserves Memory trash invariants and takes retention from the calling service', async () => {
    const updateMany = jest.fn().mockResolvedValue({ count: 1 });
    const repository = new MemoryRepository({
      memory: { updateMany },
    } as unknown as PrismaService);
    const purgeAfter = new Date('2026-11-14T00:00:00.000Z');
    await repository.softDelete(
      scope,
      { id: 'memory-a' },
      { purgeAfter, actorUserId: 'user-a' },
    );
    expect(updateMany).toHaveBeenCalledWith({
      where: { id: 'memory-a', familyId: 'family-a', deletedAt: null },
      data: {
        status: 'TRASHED',
        deletedAt: expect.any(Date),
        trashedAt: expect.any(Date),
        purgeAfter,
        trashedBy: 'user-a',
      },
    });
  });

  it('exposes no generic mutations for ledgers, event history and job attempts', () => {
    for (const repository of [
      HeartLedgerRepository,
      OutboxEventRepository,
      MissionCompletionRepository,
      JobAttemptRepository,
    ]) {
      expect(Object.hasOwn(repository.prototype, 'update')).toBe(false);
      expect(Object.hasOwn(repository.prototype, 'softDelete')).toBe(false);
    }
  });

  it('requires explicit privilege to query rows without a family', async () => {
    const repository = new OutboxEventRepository({} as PrismaService);
    await expect(
      repository.list({ familyId: null } as OutboxEventRepositoryScope, {
        page: 1,
        limit: 10,
      }),
    ).rejects.toBeInstanceOf(ValidationError);
  });

  it('maps JSON and exact Decimal without exposing Prisma classes', async () => {
    const sourceJson = { alerts: { enabled: true } };
    const row = {
      userId: 'owner',
      notificationPrefs: sourceJson,
      quietStart: now,
      quietEnd: now,
      hideSensitivePreview: true,
      circleDigestMode: 'DAILY',
      circleDigestTime: now,
      moodShareDefault: 'PRIVATE',
      requestSoonBypassQuiet: false,
      usLockEnabled: false,
      aiEnabled: true,
      aiFeatures: {},
      theme: 'SYSTEM',
      textScale: new Prisma.Decimal('1.00000000000000000001'),
      showLunar: false,
      memoryPromptsEnabled: true,
      perspectiveSuggest: true,
      dailyStorySuggest: true,
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
    };
    const repository = new UserSettingRepository({
      userSetting: { findFirst: jest.fn().mockResolvedValue(row) },
    } as unknown as PrismaService);
    const setting = await repository.findByKey(
      { userId: 'owner' },
      { userId: 'owner' },
    );
    expect(setting).toBeInstanceOf(UserSetting);
    expect(setting?.textScale).toBeInstanceOf(DatabaseDecimal);
    expect(setting?.textScale.toString()).toBe('1.00000000000000000001');
    expect(setting?.notificationPrefs).toEqual(sourceJson);
    expect(setting?.notificationPrefs).not.toBe(sourceJson);
    sourceJson.alerts.enabled = false;
    expect(setting?.notificationPrefs).toEqual({ alerts: { enabled: true } });
  });

  it('distinguishes JSON null from SQL NULL and validates exact decimals', () => {
    expect(toPrismaJson(DATABASE_JSON_NULL)).toBe(Prisma.JsonNull);
    expect(toPrismaJson(DATABASE_NULL)).toBe(Prisma.DbNull);
    expect(toPrismaDecimal('9007199254740993.125')).toBe(
      '9007199254740993.125',
    );
    expect(() => toPrismaDecimal('NaN')).toThrow(RangeError);
  });
});
