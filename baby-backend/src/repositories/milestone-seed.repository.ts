import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { isDeepStrictEqual } from 'node:util';
import { z } from 'zod';
import { Prisma } from '../generated/prisma/client';
import type { PrismaClient } from '../generated/prisma/client';
const translations = z.object({ vi: z.string().min(1), en: z.string().min(1) });
const entry = z.object({
  code: z.string().regex(/^[a-z][a-z0-9_]{0,39}$/),
  category: z.string().min(1).max(20),
  icon: z.string().min(1).max(40),
  titleI18n: translations,
  promptI18n: translations,
  isTraditional: z.boolean(),
  sortOrder: z.number().int().nonnegative(),
  dateRule: z
    .discriminatedUnion('type', [
      z.object({
        type: z.literal('LUNAR_FESTIVAL'),
        month: z.number().int().min(1).max(12),
        day: z.number().int().min(1).max(29),
      }),
      z.object({
        type: z.literal('BIRTH_MONTHS'),
        months: z.number().int().nonnegative(),
      }),
      z.object({
        type: z.literal('BIRTH_DAYS'),
        days: z.number().int().nonnegative(),
      }),
    ])
    .nullable(),
});
/** Explicit, idempotent insert-only seed; existing catalog content is preserved. */
export class MilestoneSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}
  async seedFromFile(
    path = join(__dirname, '../../prisma/seeds/milestones.json'),
  ): Promise<void> {
    const entries = z
      .array(entry)
      .parse(JSON.parse(await readFile(path, 'utf8')));
    if (new Set(entries.map((item) => item.code)).size !== entries.length)
      throw new Error('Duplicate milestone code');
    await this.prisma.$transaction(async (tx) => {
      for (const item of entries) {
        const current = await tx.milestoneTemplate.findUnique({
          where: { code: item.code },
        });
        if (current) {
          if (!isDeepStrictEqual(current.titleI18n, item.titleI18n))
            throw new Error(
              `Milestone ${item.code} differs; existing catalog is immutable by seed`,
            );
          continue;
        }
        await tx.milestoneTemplate.create({
          data: {
            ...item,
            dateRule: item.dateRule ?? Prisma.DbNull,
            remindDaysBefore: item.isTraditional && item.dateRule ? 3 : null,
          },
        });
      }
    });
  }
}
