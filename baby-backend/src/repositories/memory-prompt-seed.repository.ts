import { readFile } from 'node:fs/promises';
import { isDeepStrictEqual } from 'node:util';
import { z } from 'zod';
import type { PrismaClient } from '../generated/prisma/client';
const catalog = z.array(
  z.object({
    code: z.string().min(1).max(30),
    stage: z.enum(['CHILD', 'PREGNANCY', 'ANY']),
    minAgeDays: z.number().int().nonnegative().nullable().optional(),
    maxAgeDays: z.number().int().nonnegative().nullable().optional(),
    minPregWeek: z.number().int().min(0).max(45).nullable().optional(),
    maxPregWeek: z.number().int().min(0).max(45).nullable().optional(),
    targetKind: z.enum([
      'MOMENT',
      'QUOTE',
      'VOICE',
      'DIARY',
      'LETTER',
      'MONTHLY_PHOTO',
      'BUMP',
    ]),
    textI18n: z.object({ vi: z.string().min(1), en: z.string().min(1) }),
    weight: z.number().int().min(1).max(32767),
    version: z.number().int().positive(),
  }),
);
/** Explicit, idempotent versioned catalog seed; never invoked at startup/migration. */
export class MemoryPromptSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}
  async seedFromFile(path: string): Promise<void> {
    const raw: unknown = JSON.parse(await readFile(path, 'utf8'));
    const entries = catalog.parse(raw);
    if (new Set(entries.map((row) => row.code)).size !== entries.length)
      throw new Error('Duplicate prompt code');
    await this.prisma.$transaction(async (tx) => {
      for (const item of entries) {
        const next = {
          ...item,
          minAgeDays: item.minAgeDays ?? null,
          maxAgeDays: item.maxAgeDays ?? null,
          minPregWeek: item.minPregWeek ?? null,
          maxPregWeek: item.maxPregWeek ?? null,
        };
        if (
          (next.minAgeDays !== null &&
            next.maxAgeDays !== null &&
            next.minAgeDays > next.maxAgeDays) ||
          (next.minPregWeek !== null &&
            next.maxPregWeek !== null &&
            next.minPregWeek > next.maxPregWeek)
        )
          throw new Error('Invalid prompt age range');
        const current = await tx.memoryPromptTemplate.findUnique({
          where: { code: item.code },
        });
        if (current && current.version > item.version) continue;
        if (current && current.version === item.version) {
          if (
            Object.entries(next).some(
              ([key, value]) =>
                !isDeepStrictEqual(current[key as keyof typeof next], value),
            )
          )
            throw new Error(`Prompt ${item.code} differs; increment version`);
          continue;
        }
        await tx.memoryPromptTemplate.upsert({
          where: { code: item.code },
          create: next,
          update: next,
        });
      }
    });
  }
}
