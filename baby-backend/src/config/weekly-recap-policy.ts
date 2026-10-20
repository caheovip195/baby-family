import type { JobPolicy } from './jobs';
export const WEEKLY_RECAP_POLICY = {
  version: 1,
  batchSize: 25,
  topLimit: 10,
  everyMs: 3600000,
  catchUpWeeks: 4,
} as const;
export const WEEKLY_RECAP_JOB: JobPolicy = {
  queue: 'recaps',
  name: 'recap.weekly-build',
  maxAttempts: 3,
  backoffMs: 10000,
  leaseMs: 300000,
};
