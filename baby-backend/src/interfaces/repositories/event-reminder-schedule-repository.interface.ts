import type { Event } from '../../models/event.model';
import type { EventReminder } from '../../models/event-reminder.model';
import type { JobContext } from '../services/job-runner-service.interface';
export const EVENT_REMINDER_SCHEDULE_REPOSITORY = Symbol(
  'EVENT_REMINDER_SCHEDULE_REPOSITORY',
);
export interface ReminderPlan {
  recipientUserId: string;
  offsetMinutes: number;
  occurrenceAt: Date;
  dueAt: Date;
}
export interface ReminderEventSnapshot {
  event: Event;
  familyActive: boolean;
  outstanding: EventReminder[];
  rules: { recipientUserId: string; offsetMinutes: number }[];
}
export interface ReminderDispatchSnapshot extends ReminderEventSnapshot {
  reminder: EventReminder;
  userActive: boolean;
  locale: string;
  isParent: boolean;
  isCircle: boolean;
  hasGrantedChild: boolean;
}
export interface ReminderNotification {
  sensitive: boolean;
  tab: 'US' | 'FAMILY';
  params: {
    eventId: string;
    eventType: string;
    occurrenceAt: string;
    offsetMinutes: number;
    title?: string;
  };
  deepLink: string;
}
export interface IEventReminderScheduleRepository {
  reconcile(
    now: Date,
    context: JobContext,
    plan: (snapshot: ReminderEventSnapshot) => ReminderPlan[],
    eventId?: string,
  ): Promise<number>;
  dispatchBatch(
    now: Date,
    context: JobContext,
    decide: (snapshot: ReminderDispatchSnapshot) => ReminderNotification | null,
  ): Promise<{ sent: number; cancelled: number; claimed: number }>;
}
