/**
 * Queue, job and outbox routing definitions (spec §9). Retry policies are declared
 * per job type (docs/jobs.md); BullMQ attempts equal the PostgreSQL run maxAttempts.
 */
export const QUEUES = {
  push: 'push',
  care: 'care',
  memory: 'memory',
  recaps: 'recaps',
  missions: 'missions',
  eventReminders: 'event-reminders',
  media: 'media',
  notifications: 'notifications',
  maintenance: 'maintenance',
  familyDeletion: 'family-deletion',
  subscriptionReminders: 'subscription-reminders',
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
  prepareMissionBoards: {
    queue: QUEUES.missions,
    name: 'mission.prepare-boards',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 300_000,
  },
  releaseLetters: {
    queue: QUEUES.memory,
    name: 'memory.release-letters',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
  deliverPush: {
    queue: QUEUES.push,
    name: 'notification.deliver-push',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  awardBadges: {
    queue: QUEUES.care,
    name: 'care.award-badges',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  planEventReminders: {
    queue: QUEUES.eventReminders,
    name: 'event.plan-reminders',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  dispatchEventReminders: {
    queue: QUEUES.eventReminders,
    name: 'event.dispatch-reminders',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  deletionExecutor: {
    queue: QUEUES.maintenance,
    name: 'account.deletion-executor',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  dataExport: {
    queue: QUEUES.maintenance,
    name: 'account.data-export',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  accountMaintenance: {
    queue: QUEUES.maintenance,
    name: 'account.maintenance',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  dispatchNotification: {
    queue: QUEUES.notifications,
    name: 'notify.resolve-and-dispatch',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
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
  purgeTrash: {
    queue: QUEUES.maintenance,
    name: 'memory.purge-trash',
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
  { job: JOBS.deletionExecutor, everyMs: 15 * 60 * 1000 },
  { job: JOBS.accountMaintenance, everyMs: 60 * 1000 },
  { job: JOBS.purgeOrphans, everyMs: 15 * 60 * 1000 },
  { job: JOBS.reconcileUploads, everyMs: 15 * 60 * 1000 },
  // Trash retention is 30 days (MEM-17); hourly keeps the overrun under an hour.
  { job: JOBS.purgeTrash, everyMs: 60 * 60 * 1000 },
] as const;

/** Outbox event type → queued job. Unknown types stay unpublished for their consumer. */
export const OUTBOX_ROUTES = {
  'mission.changed': JOBS.awardBadges,
  'event.changed': JOBS.planEventReminders,
  'media.asset_uploaded': JOBS.processAsset,
  'memory.published': JOBS.dispatchNotification,
  'memory.review_requested': JOBS.dispatchNotification,
  'memory.submitted': JOBS.dispatchNotification,
  'memory.approved': JOBS.dispatchNotification,
  'memory.rejected': JOBS.dispatchNotification,
  'comment.created': JOBS.dispatchNotification,
  'reaction.changed': JOBS.dispatchNotification,
  'us.request.sent': JOBS.dispatchNotification,
  'us.request.created': JOBS.dispatchNotification,
  'us.request.accept': JOBS.dispatchNotification,
  'us.request.decline': JOBS.dispatchNotification,
  'us.request.done': JOBS.dispatchNotification,
  'us.request.acknowledge': JOBS.dispatchNotification,
  'us.checkin.shared': JOBS.dispatchNotification,
  'us.appreciation.created': JOBS.dispatchNotification,
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

/** Hourly scan; each family gets its board once its local time passes the board hour. */
export const MISSION_BOARD_SCHEDULE_POLICY = {
  everyMs: 60 * 60 * 1000,
} as const;

/** Daily UTC scan; missed ticks coalesce because every run scans all due letters. */
export const MEMORY_LETTER_RELEASE_POLICY = {
  everyMs: 24 * 60 * 60 * 1000,
  batchSize: 100,
} as const;
