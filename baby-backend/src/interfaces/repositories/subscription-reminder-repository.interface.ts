import type { JobContext } from '../services/job-runner-service.interface';
import type {
  SubscriptionReminderState,
  SubscriptionReminderDecision,
} from '../../models/subscription-reminder-state.model';

export const SUBSCRIPTION_REMINDER_REPOSITORY = Symbol(
  'SUBSCRIPTION_REMINDER_REPOSITORY',
);
export interface ISubscriptionReminderRepository {
  findState(
    familyId: string,
    now: Date,
  ): Promise<SubscriptionReminderState | null>;
  dispatch(
    now: Date,
    context: JobContext,
    decide: (
      state: SubscriptionReminderState,
    ) => SubscriptionReminderDecision | null,
    familyId?: string,
  ): Promise<number>;
}
