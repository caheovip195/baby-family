import type { NotificationInboxModel } from '../../models/notification-inbox.model';
import type { SupportedLocale } from '../../common/i18n/request-locale';

export interface NotificationText {
  title: string | null;
  body: string | null;
  locale: SupportedLocale;
}
export const NOTIFICATION_TEXT_SERVICE = Symbol('NOTIFICATION_TEXT_SERVICE');
export interface INotificationTextService {
  renderInbox(
    rows: NotificationInboxModel[],
  ): Promise<Map<string, NotificationText>>;
}
