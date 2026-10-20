import { readFile } from 'node:fs/promises';
import { isDeepStrictEqual } from 'node:util';
import { z } from 'zod';
import type { PrismaClient } from '../generated/prisma/client';

const templateSchema = z
  .object({
    code: z
      .string()
      .regex(/^NOTI_[A-Z_]+$/)
      .max(40),
    locale: z.enum(['vi', 'en']),
    title: z.string().min(1).max(120),
    body: z.string().min(1).max(300),
    sensitive: z.boolean(),
    hiddenTitle: z.string().min(1).max(120).nullable(),
    hiddenBody: z.string().min(1).max(300).nullable(),
    category: z.enum([
      'MEMORIES',
      'REQUESTS',
      'US',
      'APPRECIATION',
      'CALENDAR',
      'BADGES',
      'BILLING',
    ]),
    priority: z.enum(['NORMAL', 'HIGH']),
    enabled: z.boolean(),
  })
  .strict()
  .superRefine((item, context) => {
    const texts = [item.title, item.body, item.hiddenTitle, item.hiddenBody]
      .filter((value): value is string => value !== null)
      .join(' ');
    // Catalog copy never interpolates user content or personal reward balances.
    const validatedTexts =
      item.code === 'NOTI_BADGE_EARNED'
        ? texts.replaceAll('{badgeCode}', '')
        : texts;
    if (/hearts|trái tim|\u{1f497}|[{}]/iu.test(validatedTexts)) {
      context.addIssue({
        code: 'custom',
        message: 'Notification copy must not contain rewards or placeholders',
      });
    }
    if (
      item.sensitive !==
      !['MEMORIES', 'BADGES', 'BILLING'].includes(item.category)
    ) {
      context.addIssue({
        code: 'custom',
        message: 'Private notification categories must be sensitive',
      });
    }
    if (
      item.sensitive &&
      (item.hiddenTitle !== 'Baby Family' ||
        item.hiddenBody !==
          (item.category === 'CALENDAR'
            ? item.locale === 'vi'
              ? 'Bạn có một sự kiện sắp diễn ra.'
              : 'You have an upcoming event.'
            : item.locale === 'vi'
              ? 'Bạn có một cập nhật mới từ Papa & Mama'
              : 'You have a new update from Papa & Mama'))
    ) {
      context.addIssue({
        code: 'custom',
        message: 'Sensitive templates require the generic lock-screen preview',
      });
    }
  });

const notificationCatalogSchema = z
  .object({
    catalogVersion: z.union([
      z.literal(1),
      z.literal(2),
      z.literal(3),
      z.literal(4),
      z.literal(5),
    ]),
    templates: z.array(templateSchema).min(1),
  })
  .strict()
  .superRefine((catalog, context) => {
    const localesByCode = new Map<string, Set<string>>();
    for (const item of catalog.templates) {
      const locales = localesByCode.get(item.code) ?? new Set<string>();
      if (locales.has(item.locale)) {
        context.addIssue({
          code: 'custom',
          message: `Duplicate notification template ${item.code}/${item.locale}`,
        });
      }
      locales.add(item.locale);
      localesByCode.set(item.code, locales);
    }
    for (const [code, locales] of localesByCode) {
      if (!locales.has('vi') || !locales.has('en')) {
        context.addIssue({
          code: 'custom',
          message: `Notification template ${code} requires vi and en locales`,
        });
      }
    }
  });

/** Explicit seed only: never runs as part of migrations or application startup. */
export class NotificationTemplateSeedRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async seedFromFile(path: string): Promise<void> {
    const catalog = notificationCatalogSchema.parse(
      JSON.parse(await readFile(path, 'utf8')),
    );
    await this.prisma.$transaction(
      async (tx) => {
        for (const item of catalog.templates) {
          const existing = await tx.notificationTemplate.upsert({
            where: { code_locale: { code: item.code, locale: item.locale } },
            update: {},
            create: item,
          });
          const matches = Object.entries(item).every(([key, value]) =>
            isDeepStrictEqual(existing[key as keyof typeof existing], value),
          );
          // Templates have no version column: never silently overwrite published
          // copy, administrator changes, or restore soft-deleted catalog entries.
          if (!matches) {
            throw new Error(
              `Notification template ${item.code}/${item.locale} differs from published data; publish changes explicitly instead of overwriting`,
            );
          }
        }
      },
      { timeout: 15000 },
    );
  }
}
