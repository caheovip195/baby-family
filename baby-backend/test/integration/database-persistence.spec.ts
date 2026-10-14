import { randomUUID } from 'node:crypto';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { AppModule } from '../../src/app.module';
import { PrismaService } from '../../src/database/prisma.service';
import { AI_USAGE_MONTHLY_REPOSITORY } from '../../src/interfaces/repositories/ai-usage-monthly-repository.interface';
import type { IAiUsageMonthlyRepository } from '../../src/interfaces/repositories/ai-usage-monthly-repository.interface';
import { USER_SETTING_REPOSITORY } from '../../src/interfaces/repositories/user-setting-repository.interface';
import type { IUserSettingRepository } from '../../src/interfaces/repositories/user-setting-repository.interface';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import type { IUserRepository } from '../../src/interfaces/repositories/user-repository.interface';
import { FAMILY_REPOSITORY } from '../../src/interfaces/repositories/family-repository.interface';
import type { IFamilyRepository } from '../../src/interfaces/repositories/family-repository.interface';
import { AiUsageMonthly } from '../../src/models/ai-usage-monthly.model';
import { DatabaseDecimal } from '../../src/common/database.types';

describe('Domain persistence + real PostgreSQL + DI', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  const userIds = [randomUUID(), randomUUID()];
  const familyIds = [randomUUID(), randomUUID()];
  const month = new Date('2026-10-01T00:00:00.000Z');
  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error(
        'Persistence integration requires a dedicated *_test database',
      );
    module = await Test.createTestingModule({ imports: [AppModule] }).compile();
    await module.init();
    prisma = module.get(PrismaService);
  });
  afterAll(async () => {
    if (prisma) {
      // Physical cleanup is restricted to this test's own fixtures in a guarded test database.
      await prisma.aiUsageMonthly.deleteMany({
        where: { familyId: { in: familyIds } },
      });
      await prisma.userSetting.deleteMany({
        where: { userId: { in: userIds } },
      });
      await prisma.family.deleteMany({ where: { id: { in: familyIds } } });
      await prisma.user.deleteMany({ where: { id: { in: userIds } } });
    }
    if (module) await module.close();
  });
  it('persists scoped composite keys, ORM-free JSON/Decimal models and atomic soft delete', async () => {
    const users = module.get<IUserRepository>(USER_REPOSITORY);
    const families = module.get<IFamilyRepository>(FAMILY_REPOSITORY);
    const settings = module.get<IUserSettingRepository>(
      USER_SETTING_REPOSITORY,
    );
    const usage = module.get<IAiUsageMonthlyRepository>(
      AI_USAGE_MONTHLY_REPOSITORY,
    );
    for (let index = 0; index < 2; index++) {
      await users.create(
        { privileged: true },
        { id: userIds[index], displayName: 'Persistence fixture' },
      );
      await families.create(
        { privileged: true },
        {
          id: familyIds[index],
          name: 'Persistence fixture',
          createdBy: userIds[index]!,
        },
      );
      await usage.create(
        { familyId: familyIds[index]! },
        { month, used: index + 1 },
      );
    }
    const firstScope = { familyId: familyIds[0]! };
    const firstKey = { ...firstScope, month };
    const page = await usage.list(firstScope, { page: 1, limit: 10 });
    expect(page.meta.total).toBe(1);
    expect(page.data).toHaveLength(1);
    expect(page.data[0]).toBeInstanceOf(AiUsageMonthly);
    expect(page.data[0]?.getKey()).toEqual(firstKey);
    const first = page.data[0]!;
    expect(first.createdAt).toBeInstanceOf(Date);
    expect(first.updatedAt).toBeInstanceOf(Date);
    expect(first.deletedAt).toBeNull();
    const updated = await usage.update(firstScope, firstKey, { used: 8 });
    expect(updated?.used).toBe(8);
    expect(updated?.updatedAt.getTime()).toBeGreaterThanOrEqual(
      first.updatedAt.getTime(),
    );
    const setting = await settings.create(
      { userId: userIds[0]! },
      { notificationPrefs: { enabled: true }, textScale: '1.25' },
    );
    expect(setting.textScale).toBeInstanceOf(DatabaseDecimal);
    expect(setting.textScale.toString()).toBe('1.25');
    expect(setting.notificationPrefs).toEqual({ enabled: true });
    await expect(
      settings.findByKey({ userId: userIds[1]! }, { userId: userIds[0]! }),
    ).rejects.toThrow('does not match');
    const results = await Promise.all([
      usage.softDelete(firstScope, firstKey),
      usage.softDelete(firstScope, firstKey),
    ]);
    expect(results.sort()).toEqual([false, true]);
    expect(await usage.findByKey(firstScope, firstKey)).toBeNull();
    expect(
      (await usage.list(firstScope, { page: 1, limit: 10 })).meta.total,
    ).toBe(0);
    expect(
      (await usage.list({ familyId: familyIds[1]! }, { page: 1, limit: 10 }))
        .meta.total,
    ).toBe(1);
    const retained = await prisma.aiUsageMonthly.findUniqueOrThrow({
      where: { familyId_month: firstKey },
    });
    expect(retained.deletedAt).toBeInstanceOf(Date);
    expect(retained.used).toBe(8);
  });
});
