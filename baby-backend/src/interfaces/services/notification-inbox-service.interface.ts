import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  NotificationListQueryDto,
  NotificationListResponseDto,
  NotificationReadDto,
} from '../../dto/notification/notification-inbox.dto';

export const NOTIFICATION_INBOX_SERVICE = Symbol('NOTIFICATION_INBOX_SERVICE');

export interface INotificationInboxService {
  list(
    actor: AuthPrincipal,
    query: NotificationListQueryDto,
  ): Promise<NotificationListResponseDto>;
  unreadCount(actor: AuthPrincipal): Promise<{ count: number }>;
  markRead(
    actor: AuthPrincipal,
    input: NotificationReadDto,
  ): Promise<{ updatedCount: number }>;
}
