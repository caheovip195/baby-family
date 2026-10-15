/**
 * Queue, job and outbox routing definitions (spec §9). Retry policies are declared
 * per job type (docs/jobs.md); BullMQ attempts equal the PostgreSQL run maxAttempts.
 */
export const QUEUES = {
  media: 'media',
  maintenance: 'maintenance',
} as const;
export type QueueName = (typeof QUEUES)[keyof typeof QUEUES];

export interface JobPolicy {
  readonly queue: QueueName;
  /** BullMQ job name; also the PostgreSQL `job_runs.job_name`. */
  readonly name: string;
  readonly maxAttempts: number;
  /** First retry delay; doubles per attempt (exponential backoff). */
  readonly backoffMs: number;
  /** Lease kept alive by heartbeats; an expired lease marks the attempt TIMED_OUT. */
  readonly leaseMs: number;
}

export const JOBS = {
  processAsset: {
    queue: QUEUES.media,
    name: 'media.process-asset',
    maxAttempts: 5,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
  purgeOrphans: {
    queue: QUEUES.maintenance,
    name: 'media.purge-orphans',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
  reconcileUploads: {
    queue: QUEUES.maintenance,
    name: 'media.reconcile-uploads',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
} as const satisfies Record<string, JobPolicy>;

/**
 * Recurring maintenance (spec §10.2: every 15 minutes). Missed ticks are skipped,
 * not replayed: each run processes the whole backlog, so the next tick catches up.
 */
export const SCHEDULES = [
  { job: JOBS.purgeOrphans, everyMs: 15 * 60 * 1000 },
  { job: JOBS.reconcileUploads, everyMs: 15 * 60 * 1000 },
] as const;

/** Outbox event type → queued job. Unknown types stay unpublished for their consumer. */
export const OUTBOX_ROUTES = {
  'media.asset_uploaded': JOBS.processAsset,
} as const satisfies Record<string, JobPolicy>;
export type OutboxEventType = keyof typeof OUTBOX_ROUTES;

export const OUTBOX_RELAY = {
  batchSize: 50,
  leaseMs: 30_000,
  pollIntervalMs: 1_000,
  /** Outbox delivery retries until it succeeds, with capped backoff (docs/jobs.md). */
  maxBackoffMs: 5 * 60 * 1000,
} as const;

export const MEDIA_MAINTENANCE = {
  batchSize: 100,
  /** FAILED assets stay visible to their uploader for this long before purge. */
  failedRetentionMs: 60 * 60 * 1000,
  /** Give clients time to call complete before reconcile confirms on their behalf. */
  reconcileAfterMs: 10 * 60 * 1000,
} as const;
