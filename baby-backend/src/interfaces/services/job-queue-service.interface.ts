import type { JobPolicy } from '../../config/jobs';

export const JOB_QUEUE_SERVICE = Symbol('JOB_QUEUE_SERVICE');

/** Durable queue (BullMQ on Valkey). Job data holds identifiers only. */
export interface IJobQueueService {
  isConfigured(): boolean;
  /** Idempotent by jobId: an existing job with the same id is kept. */
  enqueue(
    policy: JobPolicy,
    jobId: string,
    data: Record<string, string>,
  ): Promise<void>;
  /** Recurring job, replacing the previous definition with the same name. */
  schedule(policy: JobPolicy, everyMs: number): Promise<void>;
}
