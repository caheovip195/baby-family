import { Inject, Injectable } from '@nestjs/common';
import { requestLocaleContext } from '../common/i18n/request-locale';
import { SYSTEM_MESSAGE_CATALOG } from '../common/i18n/system-message-catalog';
import { NOTIFICATION_TEXT_REPOSITORY } from '../interfaces/repositories/notification-text-repository.interface';
import type { INotificationTextRepository } from '../interfaces/repositories/notification-text-repository.interface';
import type {
  INotificationTextService,
  NotificationText,
} from '../interfaces/services/notification-text-service.interface';
import type { NotificationInboxModel } from '../models/notification-inbox.model';

@Injectable()
export class NotificationTextService implements INotificationTextService {
  constructor(
    @Inject(NOTIFICATION_TEXT_REPOSITORY)
    private readonly repository: INotificationTextRepository,
  ) {}

  async renderInbox(
    rows: NotificationInboxModel[],
  ): Promise<Map<string, NotificationText>> {
    const locale = requestLocaleContext.getStore() ?? 'vi';
    const templates = await this.repository.findTemplates(
      rows.map((row) => row.templateCode),
    );
    const result = new Map<string, NotificationText>();
    for (const row of rows) {
      const choices = templates.filter(
        (template) => template.code === row.templateCode,
      );
      const template =
        choices.find((item) => item.locale === locale) ??
        choices.find((item) => item.locale === 'en') ??
        choices.find((item) => item.locale === 'vi');
      if (!template) {
        result.set(row.id, { title: null, body: null, locale });
        continue;
      }
      const chosenLocale = template.locale === 'en' ? 'en' : 'vi';
      // The inbox repository has already removed arbitrary/sensitive persisted params.
      const render = (value: string): string =>
        value.replace(/\{\{?(\w+)\}?\}/g, (_match, key: string) => {
          const param = sensitive ? undefined : row.params[key];
          return typeof param === 'string' || typeof param === 'number'
            ? String(param)
            : Array.isArray(param)
              ? param.join(chosenLocale === 'vi' ? ' và ' : ' & ')
              : '';
        });
      const sensitive =
        template.sensitive ||
        ['US', 'REQUESTS', 'APPRECIATION', 'BRIDGE'].includes(row.category);
      const fallback = SYSTEM_MESSAGE_CATALOG.notification[chosenLocale];
      result.set(row.id, {
        title: sensitive
          ? template.hiddenTitle
            ? render(template.hiddenTitle)
            : fallback.title
          : render(template.title),
        body: sensitive
          ? template.hiddenBody
            ? render(template.hiddenBody)
            : fallback.body
          : render(template.body),
        locale: chosenLocale,
      });
    }
    return result;
  }
}
