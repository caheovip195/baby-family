import { readFile } from 'node:fs/promises';
import { isDeepStrictEqual } from 'node:util';
import { z } from 'zod';
import type { PrismaClient } from '../generated/prisma/client';

const missionCatalogSchema = z
  .object({
    catalogVersion: z.literal(1),
    templates: z
      .array(
        z
          .object({
            code: z.string().min(1).max(20),
            stage: z.enum(['PREGNANCY', 'CHILD', 'ANY']),
            minAgeDays: z.number().int().nonnegative().nullable(),
            maxAgeDays: z.number().int().nonnegative().nullable(),
            minPregWeek: z.number().int().min(1).max(42).nullable(),
            maxPregWeek: z.number().int().min(1).max(42).nullable(),
            category: z.enum([
              'CARE',
              'BONDING',
              'PLAY',
              'OUTDOOR',
              'MEMORY',
              'TOGETHER',
              'SUPPORT',
              'SELF',
              'COUPLE',
              'PREP',
              'HOME',
            ]),
            suggestedScope: z.enum([
              'CHILD',
              'MULTI_CHILD',
              'FAMILY',
              'COUPLE',
            ]),
            roleFit: z.enum([
              'ANY_PARENT',
              'PREGNANT_MOTHER',
              'PARTNER_OF_PREGNANT',
              'TOGETHER',
            ]),
            hearts: z.number().int().min(1).max(10),
            durationMin: z.number().int().positive().max(32767),
            multiChildOk: z.boolean(),
            requestable: z.boolean(),
            titleI18n: z.object({
              vi: z.string().min(1),
              en: z.string().min(1),
            }),
            descI18n: z.object({
              vi: z.string().min(1),
              en: z.string().min(1),
            }),
            memoryPromptI18n: z
              .object({
                vi: z.string().min(1),
                en: z.string().min(1),
              })
              .optional(),
            tags: z.array(z.string().min(1)),
            weight: z.number().int().positive().max(32767),
            rolloutPct: z.number().int().min(0).max(100),
            status: z.literal('ACTIVE'),
            version: z.number().int().positive(),
          })
          .superRefine((item, context) => {
            if (
              item.suggestedScope === 'COUPLE' &&
              item.roleFit !== 'TOGETHER'
            ) {
              context.addIssue({
                code: 'custom',
                message: 'COUPLE requires TOGETHER roleFit',
              });
            }
            if (
              (item.minAgeDays !== null &&
                item.maxAgeDays !== null &&
                item.minAgeDays > item.maxAgeDays) ||
              (item.minPregWeek !== null &&
                item.maxPregWeek !== null &&
                item.minPregWeek > item.maxPregWeek)
            ) {
              context.addIssue({
                code: 'custom',
                message: 'Mission age range is reversed',
              });
            }
          }),
      )
      .min(1),
  })
  .superRefine((catalog, context) => {
    if (
      new Set(catalog.templates.map((item) => item.code)).size !==
      catalog.templates.length
    ) {
      context.addIssue({
        code: 'custom',
        message: 'Mission template codes must be unique',
      });
    }
  });

const LIFECYCLE_FIELDS = new Set(['status', 'rolloutPct']);

export class MissionBoardCatalogSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async seedFromFile(path: string): Promise<void> {
    const catalog = missionCatalogSchema.parse(
      JSON.parse(await readFile(path, 'utf8')),
    );
    await this.seed(catalog);
  }
  private async seed(
    catalog: z.infer<typeof missionCatalogSchema>,
  ): Promise<void> {
    await this.prisma.$transaction(
      async (tx) => {
        for (const item of catalog.templates) {
          const existing = await tx.missionTemplate.upsert({
            where: { code: item.code },
            update: {},
            create: item,
          });
          // Published template content is preserved, including soft-delete state.
          // Changed content needs an explicit catalog/version publication workflow.
          // Lifecycle (status, rollout) is owned by the Admin CMS publishing
          // workflow after release; only published content must stay equal.
          const matches = Object.entries(item).every(
            ([key, value]) =>
              LIFECYCLE_FIELDS.has(key) ||
              isDeepStrictEqual(existing[key as keyof typeof existing], value),
          );
          if (!matches) {
            throw new Error(
              `Mission template ${item.code} differs from published data; publish changes explicitly instead of overwriting`,
            );
          }
        }
      },
      { timeout: 15000 },
    );
  }
}
