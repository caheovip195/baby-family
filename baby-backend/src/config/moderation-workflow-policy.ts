import type { JobPolicy } from './jobs';

/** v1: priority 1 is highest; report SLA is inherited, never extended. */
export const MODERATION_WORKFLOW_POLICY = {
  version: 1,
  openStatuses: ['OPEN', 'IN_REVIEW', 'ESCALATED'],
  reportStatuses: ['NEW', 'TRIAGE', 'IN_REVIEW', 'NEED_INFO'],
  batchSize: 100,
  everyMs: 60_000,
  timezone: 'UTC',
} as const;

/** Missed ticks coalesce: each run recovers the backlog then escalates due cases. */
export const MODERATION_SLA_JOB = {
  queue: 'maintenance',
  name: 'moderation.reconcile-sla',
  maxAttempts: 3,
  backoffMs: 10_000,
  leaseMs: 120_000,
} as const satisfies JobPolicy;
