import { readFile } from 'node:fs/promises';
import { isDeepStrictEqual } from 'node:util';
import { z } from 'zod';
import type { Prisma, PrismaClient } from '../generated/prisma/client';
const weekData = z.object({
  emoji: z.string().min(1),
  lengthCm: z.number().nonnegative(),
  weightG: z.number().nonnegative().optional(),
  label: z.string().min(1),
  tip: z.string().min(1).max(200),
});
const prepData = z.object({
  groupCode: z.string().regex(/^[A-Z][A-Z0-9_]{0,19}$/),
  title: z.string().min(1).max(120),
  sortOrder: z.number().int().min(0).max(2147483647),
});
const entry = z.object({
  type: z.enum(['PREGNANCY_WEEK', 'PREP_DEFAULT']),
  code: z.string().min(1).max(40),
  locale: z.enum(['vi', 'en']),
  version: z.number().int().positive(),
  sortOrder: z.number().int().min(0).max(2147483647),
  data: z.unknown(),
});
/** Explicit seed: published equal versions are immutable; newer versions can replace content. */
export class PregnancyContentSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}
  async seedFromFile(path: string): Promise<void> {
    const raw: unknown = JSON.parse(await readFile(path, 'utf8'));
    const entries = z
      .array(entry)
      .parse(raw)
      .map((item) => ({
        ...item,
        data:
          item.type === 'PREGNANCY_WEEK'
            ? weekData.parse(item.data)
            : prepData.parse(item.data),
      }));
    for (const item of entries)
      if (
        item.type === 'PREGNANCY_WEEK' &&
        !/^W(0[4-9]|[1-3][0-9]|4[0-2])$/.test(item.code)
      )
        throw new Error('Invalid pregnancy week code');
    await this.prisma.$transaction(
      async (tx) => {
        for (const item of entries) {
          const key = { type: item.type, code: item.code, locale: item.locale };
          const current = await tx.contentItem.findUnique({
            where: { type_code_locale: key },
          });
          if (current && current.version > item.version) continue;
          if (current && current.version === item.version) {
            if (
              !isDeepStrictEqual(current.data, item.data) ||
              current.sortOrder !== item.sortOrder
            )
              throw new Error(
                `Content ${item.type}/${item.code}/${item.locale} differs; increment its version`,
              );
            continue;
          }
          const data = {
            ...item,
            data: item.data as Prisma.InputJsonValue,
            status: 'ACTIVE',
            deletedAt: null,
          };
          await tx.contentItem.upsert({
            where: { type_code_locale: key },
            create: data,
            update: data,
          });
        }
      },
      { timeout: 15000 },
    );
  }
}
