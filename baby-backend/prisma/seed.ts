import { MilestoneSeedRepository } from '../src/repositories/milestone-seed.repository';
import { MemoryPromptSeedRepository } from '../src/repositories/memory-prompt-seed.repository';
import { PregnancyContentSeedRepository } from '../src/repositories/pregnancy-content-seed.repository';
import { MissionBoardCatalogSeedRepository } from '../src/repositories/mission-board-catalog-seed.repository';
import { NotificationTemplateSeedRepository } from '../src/repositories/notification-template-seed.repository';
import { CareBadgeSeedRepository } from '../src/repositories/care-badge-seed.repository';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { isDeepStrictEqual } from 'node:util';

import { PrismaPg } from '@prisma/adapter-pg';
import { config } from 'dotenv';
import { z } from 'zod';

import { PrismaClient } from '../src/generated/prisma/client';

const catalogSchema = z.object({
  plans: z.array(
    z.object({
      code: z.string().min(1).max(40),
      displayName: z.record(z.string(), z.string().min(1)),
      displayOrder: z.number().int(),
      purchaseEnabled: z.boolean(),
      version: z.number().int().positive(),
      entitlementRank: z.number().int().nonnegative(),
      quotas: z.record(z.string(), z.number().int().nonnegative()),
      features: z.record(z.string(), z.boolean()),
    }),
  ),
  trialPolicies: z.array(
    z.object({
      code: z.string().min(1).max(60),
      version: z.number().int().positive(),
      planCode: z.string().min(1),
      planVersion: z.number().int().positive(),
      durationSeconds: z.number().int().positive(),
      reminderOffsetsSeconds: z.array(z.number().int().positive()),
      active: z.boolean(),
    }),
  ),
  settings: z.record(z.string(), z.string()),
});
type Catalog = z.infer<typeof catalogSchema>;

interface ICatalogSeedRepository {
  seed(catalog: Catalog): Promise<void>;
}

class CatalogSeedRepository implements ICatalogSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async seed(catalog: Catalog): Promise<void> {
    await this.prisma.$transaction(
      async (tx) => {
        for (const item of catalog.plans) {
          const plan = await tx.plan.upsert({
            where: { code: item.code },
            update: {},
            create: {
              code: item.code,
              displayNameI18n: item.displayName,
              displayOrder: item.displayOrder,
              purchaseEnabled: item.purchaseEnabled,
            },
          });
          const version = await tx.planVersion.upsert({
            where: {
              planId_version: { planId: plan.id, version: item.version },
            },
            update: {},
            create: {
              planId: plan.id,
              version: item.version,
              entitlementRank: item.entitlementRank,
              quotas: item.quotas,
              features: item.features,
            },
          });
          if (
            version.entitlementRank !== item.entitlementRank ||
            !isDeepStrictEqual(version.quotas, item.quotas) ||
            !isDeepStrictEqual(version.features, item.features)
          ) {
            throw new Error(
              `Catalog ${item.code} v${item.version} differs from published data; add a new version instead of overwriting`,
            );
          }
        }
        for (const item of catalog.trialPolicies) {
          if (
            item.reminderOffsetsSeconds.some(
              (offset) => offset >= item.durationSeconds,
            )
          )
            throw new Error(
              'Trial reminder offset must be within its duration',
            );
          const plan = await tx.plan.findUniqueOrThrow({
            where: { code: item.planCode },
          });
          const version = await tx.planVersion.findUniqueOrThrow({
            where: {
              planId_version: { planId: plan.id, version: item.planVersion },
            },
          });
          const policy = await tx.trialPolicy.upsert({
            where: { code_version: { code: item.code, version: item.version } },
            update: {},
            create: {
              code: item.code,
              version: item.version,
              planVersionId: version.id,
              durationSeconds: BigInt(item.durationSeconds),
              reminderOffsetsSeconds: item.reminderOffsetsSeconds,
              active: item.active,
              publishedAt: item.active ? new Date() : null,
            },
          });
          if (
            policy.planVersionId !== version.id ||
            policy.durationSeconds !== BigInt(item.durationSeconds) ||
            !isDeepStrictEqual(
              policy.reminderOffsetsSeconds,
              item.reminderOffsetsSeconds,
            )
          ) {
            throw new Error(
              `Trial policy ${item.code} v${item.version} differs; add a new version`,
            );
          }
        }
        for (const [key, value] of Object.entries(catalog.settings)) {
          await tx.appConfig.upsert({
            where: { key },
            update: {},
            create: { key, value },
          });
        }
      },
      { timeout: 15000 },
    );
  }
}

class CatalogSeeder {
  constructor(private readonly repository: ICatalogSeedRepository) {}

  async run(): Promise<void> {
    const catalog = catalogSchema.parse(
      JSON.parse(await readFile(join(__dirname, 'seeds/catalog.json'), 'utf8')),
    );
    await this.repository.seed(catalog);
    process.stdout.write(
      'Catalog seed complete; existing versions and grants preserved.\n',
    );
  }
}

async function main(): Promise<void> {
  config({ quiet: true });
  const url = process.env.DATABASE_URL;
  if (!url)
    throw new Error('DATABASE_URL is required for an explicit seed run');
  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString: url }),
  });
  try {
    await new CatalogSeeder(new CatalogSeedRepository(prisma)).run();
    await new MilestoneSeedRepository(prisma).seedFromFile();
    await new MemoryPromptSeedRepository(prisma).seedFromFile(
      join(__dirname, 'seeds/memory-prompts.json'),
    );
    await new PregnancyContentSeedRepository(prisma).seedFromFile(
      join(__dirname, 'seeds/pregnancy-weeks.json'),
    );
    await new PregnancyContentSeedRepository(prisma).seedFromFile(
      join(__dirname, 'seeds/prep-defaults.json'),
    );
    await new MissionBoardCatalogSeedRepository(prisma).seedFromFile(
      join(__dirname, 'seeds/missions.json'),
    );
    await new NotificationTemplateSeedRepository(prisma).seedFromFile(
      join(__dirname, 'seeds/notification-templates.json'),
    );
    await new CareBadgeSeedRepository(prisma).seedFromFile(
      join(__dirname, 'seeds/badges.json'),
    );
  } finally {
    await prisma.$disconnect();
  }
}

void main().catch((error: unknown) => {
  process.stderr.write(
    `${error instanceof Error ? error.message : 'Catalog seed failed'}\n`,
  );
  process.exitCode = 1;
});
