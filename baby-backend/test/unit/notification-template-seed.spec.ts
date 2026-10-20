import { readFile } from 'node:fs/promises';
import type { PrismaClient } from '../../src/generated/prisma/client';
import { NotificationTextService } from '../../src/services/notification-text.service';
import { NotificationInboxModel } from '../../src/models/notification-inbox.model';
import { NotificationTemplate } from '../../src/models/notification-template.model';
import type { NotificationTemplateAttributes } from '../../src/models/notification-template.model';
import { requestLocaleContext } from '../../src/common/i18n/request-locale';
import { NotificationTemplateSeedRepository } from '../../src/repositories/notification-template-seed.repository';

it('validates and seeds catalog v5 with both locales of generic Circle review templates', async () => {
  const upsert = jest.fn(({ create }: { create: Record<string, unknown> }) =>
    Promise.resolve(create),
  );
  const transaction = jest.fn((callback: (tx: unknown) => Promise<void>) =>
    callback({ notificationTemplate: { upsert } }),
  );
  const repository = new NotificationTemplateSeedRepository({
    $transaction: transaction,
  } as unknown as PrismaClient);
  await repository.seedFromFile('prisma/seeds/notification-templates.json');
  const catalog = JSON.parse(
    await readFile('prisma/seeds/notification-templates.json', 'utf8'),
  ) as { catalogVersion: number; templates: Record<string, unknown>[] };
  expect(catalog.catalogVersion).toBe(5);
  const review = catalog.templates.filter((item) =>
    [
      'NOTI_MEMORY_REVIEW_REQUESTED',
      'NOTI_MEMORY_APPROVED',
      'NOTI_MEMORY_REJECTED',
    ].includes(String(item.code)),
  );
  expect(review).toHaveLength(6);
  for (const item of review) {
    expect(item).toMatchObject({ category: 'MEMORIES', sensitive: false });
    expect(`${String(item.title)} ${String(item.body)}`).not.toMatch(/[{}]/);
  }
  const billing = catalog.templates.filter(
    (item) => item.category === 'BILLING',
  );
  expect(billing).toHaveLength(10);
  expect(new Set(billing.map((item) => item.code)).size).toBe(5);
  for (const item of billing) {
    expect(item).toMatchObject({
      sensitive: false,
      hiddenTitle: null,
      hiddenBody: null,
      enabled: true,
    });
    expect(`${String(item.title)} ${String(item.body)}`).not.toMatch(/[{}]/);
  }
  expect(upsert).toHaveBeenCalledTimes(catalog.templates.length);
});

it.each(['vi', 'en'] as const)(
  'renders trial expiry billing copy in locale %s through the existing text pipeline',
  async (locale) => {
    const catalog = JSON.parse(
      await readFile('prisma/seeds/notification-templates.json', 'utf8'),
    ) as {
      templates: Omit<
        NotificationTemplateAttributes,
        'createdAt' | 'updatedAt' | 'deletedAt'
      >[];
    };
    const now = new Date();
    const templates = catalog.templates
      .filter((row) => row.code === 'NOTI_TRIAL_EXPIRED')
      .map(
        (row) =>
          new NotificationTemplate({
            ...row,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
          }),
      );
    const service = new NotificationTextService({
      findTemplates: () => Promise.resolve(templates),
    });
    const row = new NotificationInboxModel(
      'test',
      'FAMILY',
      'BILLING',
      'NOTI_TRIAL_EXPIRED',
      {},
      now,
      null,
      'babyfamily://billing',
    );
    const result = await requestLocaleContext.run(locale, () =>
      service.renderInbox([row]),
    );
    expect(result.get(row.id)).toEqual(
      locale === 'vi'
        ? {
            title: 'Dùng thử đã kết thúc',
            body: 'Thời gian dùng thử đã kết thúc. Nâng cấp gói để tiếp tục lưu giữ hành trình của con.',
            locale,
          }
        : {
            title: 'Trial ended',
            body: 'Your trial has ended. Choose a plan to keep saving your journey.',
            locale,
          },
    );
  },
);
