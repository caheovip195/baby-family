import type { JobLease } from '../../models/job-lease.model';

export const JOB_EXECUTION_REPOSITORY = Symbol('JOB_EXECUTION_REPOSITORY');

export interface JobRunDefinition {
  jobName: string;
  /** Business scope, e.g. an asset id or `GLOBAL`. */
  scopeKey: string;
  scheduledFor: Date;
  /** Stable across retries: one logical run per job + scope + period. */
  idempotencyKey: string;
  maxAttempts: number;
  familyId: string | null;
  /** Identifiers only; never payloads or private content. */
  inputReference: Record<string, string>;
}

export type JobClaim =
  | { kind: 'claimed'; lease: JobLease }
  /** SUCCEEDED/FAILED/SKIPPED already: do not run again. */
  | { kind: 'finished'; status: string }
  /** RUNNING under another live lease. */
  | { kind: 'busy' }
  /** Attempts used up (e.g. after stale leases); the run is now FAILED. */
  | { kind: 'exhausted' };

export interface JobFailure {
  code: string;
  summary: string;
  permanent: boolean;
  retryAt: Date;
}

/** Durable PostgreSQL run/attempt history with lease + fencing (docs/jobs.md). */
export interface IJobExecutionRepository {
  /** Creates the run if missing and claims a new attempt in one short transaction. */
  claim(
    definition: JobRunDefinition,
    workerId: string,
    leaseMs: number,
  ): Promise<JobClaim>;
  /** Extends the lease; false when ownership was lost. */
  heartbeat(lease: JobLease, leaseMs: number): Promise<boolean>;
  /** False when ownership was lost before completion was recorded. */
  succeed(
    lease: JobLease,
    checkpoint: Record<string, number>,
  ): Promise<boolean>;
  /** Records the failed attempt; returns the new run status, or null if not owned. */
  fail(
    lease: JobLease,
    failure: JobFailure,
  ): Promise<'RETRY_WAIT' | 'FAILED' | null>;
}
