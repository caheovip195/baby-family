import type { JobPolicy } from '../../config/jobs';
import type { JobLease } from '../../models/job-lease.model';

export const JOB_RUNNER_SERVICE = Symbol('JOB_RUNNER_SERVICE');

export interface JobRunRequest {
  scopeKey: string;
  scheduledFor: Date;
  idempotencyKey: string;
  familyId?: string | null;
  inputReference?: Record<string, string>;
}

export interface JobContext {
  /** Aborted when the lease is lost; long work must stop. */
  signal: AbortSignal;
  /** Ownership token: business writes must check it in their transaction. */
  lease: JobLease;
}

export type JobHandler = (
  context: JobContext,
) => Promise<Record<string, number>>;

export type JobExecutionOutcome = 'SUCCEEDED' | 'ALREADY_FINISHED';

/**
 * Runs a handler as one attempt of a durable job run. Transient errors are rethrown
 * for the queue to retry; PermanentJobError marks the run FAILED; JobBusyError means
 * another worker holds a live lease.
 */
export interface IJobRunnerService {
  execute(
    policy: JobPolicy,
    request: JobRunRequest,
    handler: JobHandler,
  ): Promise<JobExecutionOutcome>;
}
