import { Test } from '@nestjs/testing';
import { PATH_METADATA } from '@nestjs/common/constants';
import {
  ConflictError,
  NotFoundError,
  ValidationError,
} from '../../src/common/errors/domain.error';
import { INTERNAL_SERVICE_PROVIDERS } from '../../src/common/application/service.providers';
import { INTERNAL_SERVICE_TABLES } from '../../src/common/application/service.manifest';
import { AI_USAGE_MONTHLY_REPOSITORY } from '../../src/interfaces/repositories/ai-usage-monthly-repository.interface';
import type {
  IAiUsageMonthlyRepository,
  UpdateAiUsageMonthlyInput,
} from '../../src/interfaces/repositories/ai-usage-monthly-repository.interface';
import type { IMemoryRepository } from '../../src/interfaces/repositories/memory-repository.interface';
import { AiUsageMonthlyService } from '../../src/services/ai-usage-monthly.service';
import { MemoryService } from '../../src/services/memory.service';
import { HeartLedgerService } from '../../src/services/heart-ledger.service';
import { OutboxEventService } from '../../src/services/outbox-event.service';
import { JobAttemptService } from '../../src/services/job-attempt.service';
import { AiUsageMonthly } from '../../src/models/ai-usage-monthly.model';

const month = new Date('2026-10-01T00:00:00.000Z');
const now = new Date('2026-10-14T00:00:00.000Z');
const scope = { familyId: 'family-a' };
const key = { ...scope, month };
const model = new AiUsageMonthly({
  familyId: 'family-a',
  month,
  used: 1,
  createdAt: now,
  updatedAt: now,
  deletedAt: null,
});
function fixture() {
  const repository: jest.Mocked<IAiUsageMonthlyRepository> = {
    create: jest.fn(),
    findByKey: jest.fn(),
    list: jest.fn(),
    update: jest.fn(),
    softDelete: jest.fn(),
  };
  return { repository, service: new AiUsageMonthlyService(repository) };
}

describe('Internal persistence-backed application services', () => {
  it('covers 117 internal tables and excludes manual HTTP services', () => {
    expect(INTERNAL_SERVICE_TABLES).toHaveLength(117);
    expect(INTERNAL_SERVICE_PROVIDERS).toHaveLength(117);
    expect(
      new Set(INTERNAL_SERVICE_TABLES.map((table) => table.model)).size,
    ).toBe(117);
    for (const name of [
      'Note',
      'User',
      'UserSetting',
      'Family',
      'Child',
      'Pregnancy',
    ])
      expect(
        INTERNAL_SERVICE_TABLES.some((table) => table.model === name),
      ).toBe(false);
    expect(
      INTERNAL_SERVICE_TABLES.filter(
        (table) =>
          !table.methods.some(
            (method) => method === 'update' || method === 'softDelete',
          ),
      ),
    ).toHaveLength(18);
    expect(
      INTERNAL_SERVICE_TABLES.every((table) => table.exposure === 'internal'),
    ).toBe(true);
    expect(
      Reflect.getMetadata(PATH_METADATA, AiUsageMonthlyService),
    ).toBeUndefined();
  });

  it('injects the typed repository through its exported Symbol token', async () => {
    const { repository } = fixture();
    repository.findByKey.mockResolvedValue(model);
    const module = await Test.createTestingModule({
      providers: [
        AiUsageMonthlyService,
        { provide: AI_USAGE_MONTHLY_REPOSITORY, useValue: repository },
      ],
    }).compile();
    try {
      expect(await module.get(AiUsageMonthlyService).getByKey(scope, key)).toBe(
        model,
      );
      expect(repository.findByKey).toHaveBeenCalledWith(scope, key);
    } finally {
      await module.close();
    }
  });

  it('keeps tenant scope explicit when creating and listing', async () => {
    const { repository, service } = fixture();
    repository.create.mockResolvedValue(model);
    expect(await service.create(scope, { month })).toBe(model);
    expect(repository.create).toHaveBeenCalledWith(scope, { month });
    await service.list(scope, { page: 2, limit: 10 });
    expect(repository.list).toHaveBeenCalledWith(scope, { page: 2, limit: 10 });
  });

  it('rejects invalid pagination before invoking persistence', () => {
    const { repository, service } = fixture();
    expect(() => service.list(scope, { page: 1, limit: 101 })).toThrow(
      ValidationError,
    );
    expect(repository.list).not.toHaveBeenCalled();
  });

  it('turns a missing lookup into a domain not-found error', async () => {
    const { repository, service } = fixture();
    repository.findByKey.mockResolvedValue(null);
    await expect(service.getByKey(scope, key)).rejects.toBeInstanceOf(
      NotFoundError,
    );
  });

  it('rejects empty or protected updates before persistence', async () => {
    const { repository, service } = fixture();
    await expect(service.update(scope, key, {})).rejects.toBeInstanceOf(
      ValidationError,
    );
    await expect(
      service.update(scope, key, { used: undefined }),
    ).rejects.toBeInstanceOf(ValidationError);
    await expect(
      service.update(scope, key, {
        familyId: 'other',
      } as unknown as UpdateAiUsageMonthlyInput),
    ).rejects.toBeInstanceOf(ValidationError);
    expect(repository.update).not.toHaveBeenCalled();
  });

  it('returns updated model instances and handles concurrent row removal', async () => {
    const { repository, service } = fixture();
    repository.update.mockResolvedValueOnce(model).mockResolvedValueOnce(null);
    expect(await service.update(scope, key, { used: 2 })).toBe(model);
    await expect(
      service.update(scope, key, { used: 2 }),
    ).rejects.toBeInstanceOf(NotFoundError);
    expect(repository.update).toHaveBeenCalledWith(scope, key, { used: 2 });
  });

  it('reports repeated or missing soft deletion as not found', async () => {
    const { repository, service } = fixture();
    repository.softDelete
      .mockResolvedValueOnce(true)
      .mockResolvedValueOnce(false);
    await expect(service.softDelete(scope, key)).resolves.toBeUndefined();
    await expect(service.softDelete(scope, key)).rejects.toBeInstanceOf(
      NotFoundError,
    );
  });

  it('requires the dedicated Memory retention input when forwarding deletion', async () => {
    const repository: jest.Mocked<IMemoryRepository> = {
      create: jest.fn(),
      findByKey: jest.fn(),
      list: jest.fn(),
      update: jest.fn(),
      softDelete: jest.fn().mockResolvedValue(true),
    };
    const service = new MemoryService(repository);
    const input = {
      purgeAfter: new Date('2026-11-14T00:00:00.000Z'),
      actorUserId: 'parent-a',
    };
    await service.softDelete(scope, { id: 'memory-a' }, input);
    expect(repository.softDelete).toHaveBeenCalledWith(
      scope,
      { id: 'memory-a' },
      input,
    );
  });

  it('does not add mutation operations to append-only history services', () => {
    for (const service of [
      HeartLedgerService,
      OutboxEventService,
      JobAttemptService,
    ]) {
      expect(Object.hasOwn(service.prototype, 'update')).toBe(false);
      expect(Object.hasOwn(service.prototype, 'softDelete')).toBe(false);
    }
  });

  it('preserves repository domain errors for the application error boundary', async () => {
    const { repository, service } = fixture();
    const error = new ConflictError('Duplicate idempotency key');
    repository.create.mockRejectedValue(error);
    await expect(service.create(scope, { month })).rejects.toBe(error);
  });
});
