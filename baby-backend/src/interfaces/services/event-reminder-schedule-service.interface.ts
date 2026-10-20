import type { JobContext } from './job-runner-service.interface';
export const EVENT_REMINDER_SCHEDULE_SERVICE = Symbol(
  'EVENT_REMINDER_SCHEDULE_SERVICE',
);
export interface IEventReminderScheduleService {
  plan(
    now: Date,
    context: JobContext,
    eventId?: string,
  ): Promise<Record<string, number>>;
  dispatch(now: Date, context: JobContext): Promise<Record<string, number>>;
}
