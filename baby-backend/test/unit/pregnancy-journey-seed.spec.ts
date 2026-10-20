import { join } from 'node:path';
import type { Prisma, PrismaClient } from '../../src/generated/prisma/client';
import { PregnancyContentSeedRepository } from '../../src/repositories/pregnancy-content-seed.repository';

describe('Pregnancy content explicit seed', () => {
  function fixture() {
    const rows = new Map<
      string,
      { version: number; data: unknown; sortOrder: number }
    >();
    const key = (value: { type: string; code: string; locale: string }) =>
      `${value.type}/${value.code}/${value.locale}`;
    const upsert = jest.fn(
      (input: {
        where: {
          type_code_locale: { type: string; code: string; locale: string };
        };
        create: { version: number; data: unknown; sortOrder: number };
        update: { version: number; data: unknown; sortOrder: number };
      }) => {
        rows.set(key(input.where.type_code_locale), input.create);
        return Promise.resolve(input.create);
      },
    );
    const tx = {
      contentItem: {
        findUnique: (input: {
          where: {
            type_code_locale: { type: string; code: string; locale: string };
          };
        }) =>
          Promise.resolve(rows.get(key(input.where.type_code_locale)) ?? null),
        upsert,
      },
    };
    const prisma = {
      $transaction: (fn: (client: Prisma.TransactionClient) => Promise<void>) =>
        fn(tx as unknown as Prisma.TransactionClient),
    } as unknown as PrismaClient;
    return {
      repository: new PregnancyContentSeedRepository(prisma),
      rows,
      upsert,
    };
  }
  it('loads both catalogs once and preserves equal published versions on replay', async () => {
    const { repository, rows, upsert } = fixture();
    for (let replay = 0; replay < 2; replay++) {
      await repository.seedFromFile(
        join(process.cwd(), 'prisma/seeds/pregnancy-weeks.json'),
      );
      await repository.seedFromFile(
        join(process.cwd(), 'prisma/seeds/prep-defaults.json'),
      );
    }
    expect(rows.size).toBe(92);
    expect(upsert).toHaveBeenCalledTimes(92);
    expect(rows.get('PREGNANCY_WEEK/W24/vi')?.data).toMatchObject({
      emoji: '🌽',
      lengthCm: 30,
      label: 'bắp ngô',
    });
  });
  it('rejects mutation of an equal version and preserves newer operator content', async () => {
    const { repository, rows, upsert } = fixture();
    const path = join(process.cwd(), 'prisma/seeds/pregnancy-weeks.json');
    await repository.seedFromFile(path);
    rows.set('PREGNANCY_WEEK/W04/vi', {
      version: 1,
      sortOrder: 4,
      data: { tip: 'different published content' },
    });
    await expect(repository.seedFromFile(path)).rejects.toThrow(
      'increment its version',
    );
    rows.set('PREGNANCY_WEEK/W04/vi', {
      version: 2,
      sortOrder: 4,
      data: { tip: 'newer operator content' },
    });
    upsert.mockClear();
    await repository.seedFromFile(path);
    expect(upsert).not.toHaveBeenCalled();
    expect(rows.get('PREGNANCY_WEEK/W04/vi')?.version).toBe(2);
  });
});
