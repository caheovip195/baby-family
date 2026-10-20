import type { JobLease } from '../../models/job-lease.model';
import type { NotificationInboxModel } from '../../models/notification-inbox.model';
import type {
  NotificationDispatchSnapshot,
  NotificationDispatchDecision,
} from '../../models/notification-inbox-dispatch.model';

export const NOTIFICATION_INBOX_REPOSITORY = Symbol(
  'NOTIFICATION_INBOX_REPOSITORY',
);
export interface NotificationInboxQuery {
  tab?: 'FAMILY' | 'US';
  cursor?: string;
  limit?: number;
}
export interface NotificationReadInput {
  ids?: string[];
  all?: boolean;
}
export interface INotificationInboxRepository {
  list(
    userId: string,
    query: NotificationInboxQuery,
  ): Promise<{ items: NotificationInboxModel[]; nextCursor: string | null }>;
  unreadCount(userId: string): Promise<number>;
  markRead(userId: string, input: NotificationReadInput): Promise<number>;
  consume(
    eventId: string,
    lease: JobLease,
    decide: (
      snapshot: NotificationDispatchSnapshot,
    ) => NotificationDispatchDecision[],
  ): Promise<number>;
}
