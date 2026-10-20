import { QUEUES, type JobPolicy } from './jobs';

/** Trial offsets come from the granted policy; paid reminders use this versioned policy. */
export const SUBSCRIPTION_REMINDER_POLICY = {
  version: 1,
  everyMs: 60 * 60 * 1000,
  batchSize: 50,
  localHour: 9,
  expiryCatchUpSeconds: 28 * 86400,
  paidReminderOffsetsSeconds: [604800, 86400],
} as const;

/** Dedicated queue avoids competing with the shared maintenance queue's worker. */
export const SUBSCRIPTION_REMINDER_JOB: JobPolicy = {
  queue: QUEUES.subscriptionReminders,
  name: 'billing.subscription-reminders',
  maxAttempts: 3,
  backoffMs: 10000,
  leaseMs: 120000,
};
