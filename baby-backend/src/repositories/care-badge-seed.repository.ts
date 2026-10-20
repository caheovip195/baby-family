import { readFile } from 'node:fs/promises';
import { z } from 'zod';
import type { Prisma, PrismaClient } from '../generated/prisma/client';

const badgeCatalogSchema = z.array(
  z.object({
    code: z.string().min(1).max(30),
    titleI18n: z.object({
      vi: z.string().min(1),
      en: z.string().min(1),
    }),
    descI18n: z.object({
      vi: z.string().min(1),
      en: z.string().min(1),
    }),
    icon: z.string().min(1).max(60),
    rule: z.record(z.string(), z.unknown()),
    scope: z.string().default('FAMILY'),
    status: z.literal('ACTIVE').default('ACTIVE'),
  }),
);

export class CareBadgeSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async seedFromFile(path: string): Promise<void> {
    const raw: unknown = JSON.parse(await readFile(path, 'utf8'));
    const badges = badgeCatalogSchema.parse(raw);
    await this.seed(badges);
  }

  async seed(badges: z.infer<typeof badgeCatalogSchema>): Promise<void> {
    await this.prisma.$transaction(
      async (tx) => {
        for (const item of badges) {
          const ruleJson = item.rule as unknown as Prisma.InputJsonValue;
          const titleJson = item.titleI18n as unknown as Prisma.InputJsonValue;
          const descJson = item.descI18n as unknown as Prisma.InputJsonValue;
          await tx.badge.upsert({
            where: { code: item.code },
            update: {
              titleI18n: titleJson,
              descI18n: descJson,
              icon: item.icon,
              rule: ruleJson,
              scope: item.scope,
              status: item.status,
            },
            create: {
              code: item.code,
              titleI18n: titleJson,
              descI18n: descJson,
              icon: item.icon,
              rule: ruleJson,
              scope: item.scope,
              status: item.status,
            },
          });
        }
      },
      { timeout: 15000 },
    );
  }
}
