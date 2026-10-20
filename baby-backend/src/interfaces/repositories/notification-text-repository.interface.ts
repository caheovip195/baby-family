import type { NotificationTemplate } from '../../models/notification-template.model';

export const NOTIFICATION_TEXT_REPOSITORY = Symbol(
  'NOTIFICATION_TEXT_REPOSITORY',
);
export interface INotificationTextRepository {
  findTemplates(codes: string[]): Promise<NotificationTemplate[]>;
}
