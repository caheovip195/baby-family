import type { JobPolicy } from './jobs';
export const FAMILY_ERASURE_POLICY = {
  version: '2026-10-19.v1',
  graceDays: 30,
  batchSize: 25,
  everyMs: 900000,
} as const;
export const FAMILY_ERASURE_JOB = {
  queue: 'family-deletion',
  name: 'family.deletion-executor',
  maxAttempts: 3,
  backoffMs: 10000,
  leaseMs: 120000,
} as const satisfies JobPolicy;
