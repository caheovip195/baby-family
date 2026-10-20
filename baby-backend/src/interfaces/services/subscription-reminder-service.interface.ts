import type { JobContext } from './job-runner-service.interface';
import type { SubscriptionStatusBanner } from '../../models/subscription-reminder-state.model';

export const SUBSCRIPTION_REMINDER_SERVICE = Symbol(
  'SUBSCRIPTION_REMINDER_SERVICE',
);
export interface ISubscriptionReminderService {
  status(familyId: string, now: Date): Promise<SubscriptionStatusBanner | null>;
  dispatch(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>>;
}
