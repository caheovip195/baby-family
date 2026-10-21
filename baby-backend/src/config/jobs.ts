import { TRANSACTIONAL_MAIL_JOBS } from './transactional-mail-policy';

/**
 * Queue, job and outbox routing definitions (spec §9). Retry policies are declared
 * per job type (docs/jobs.md); BullMQ attempts equal the PostgreSQL run maxAttempts.
 */
export const QUEUES = {
  transactionalMail: 'transactional-mail',
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
  storeNotifications: 'store-notifications',
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
  processStoreNotification: {
    queue: QUEUES.storeNotifications,
    name: 'billing.process-store-notification',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
  reconcileStoreNotifications: {
    queue: QUEUES.storeNotifications,
    name: 'billing.reconcile-store-notifications',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  },
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

/** Primary consumer. Unknown event types remain unpublished for investigation. */
export const OUTBOX_ROUTES = {
  'mail.transactional': TRANSACTIONAL_MAIL_JOBS.deliver,
  'billing.store-notification': JOBS.processStoreNotification,
  'mission.changed': JOBS.awardBadges,
  'memory.created': JOBS.awardBadges,
  'memory.restored': JOBS.awardBadges,
  'memory.perspective.changed': JOBS.awardBadges,
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

/** Fan-out consumers use distinct durable queue IDs; retry replays all safely. */
export const OUTBOX_ADDITIONAL_ROUTES: Readonly<
  Record<string, readonly JobPolicy[]>
> = {
  'us.request.done': [JOBS.awardBadges],
  'memory.published': [JOBS.awardBadges],
  'us.appreciation.created': [JOBS.awardBadges],
};

/** Audited terminal events: no asynchronous consumer is required (docs/outbox.md). */
export const OUTBOX_NO_CONSUMER: Readonly<Record<string, string>> = {
  'auth.email_verified':
    'Persistent email-verification proof; acknowledge delivery but retain row until identity revocation/account erasure.',
  FamilyCreated: 'Family and initial license are persisted atomically.',
  PartnerLinked: 'Membership and access version are persisted atomically.',
  TrialStarted: 'Trial grant is persisted atomically; reminders scan grants.',
  'badge.earned': 'Award and private recipient inbox are persisted atomically.',
  'memory.changed':
    'Feed, search, recap and timeline read PostgreSQL directly.',
  'memory.updated': 'Read projections query current memory and ACL directly.',
  'memory.trashed': 'Reads filter state; restore retains this outbox audit.',
  'memory.purged': 'Purge already completed; no search cache to invalidate.',
  'memory.letter.released':
    'Release persists visibility; reads expose due letters directly; no configured release notification template.',
  'memory.original.downloaded':
    'Download audit only; signed link already issued.',
  'comment.deleted': 'Reads query current comment state directly.',
  'child.order_changed': 'Ordering is persisted; no materialized feed cache.',
  'child.status_changed': 'Status and access version are persisted atomically.',
  'child.profile_changed': 'Reads query current profile directly.',
  'pregnancy.profile_changed': 'Reads query current profile directly.',
  'pregnancy.status_changed': 'Status and ACL are persisted atomically.',
  'pregnancy.birth_converted':
    'Conversion and new child are persisted atomically.',
  'pregnancy.prep.changed': 'Preparation state is read directly.',
  'family.settings.changed':
    'Settings and access version are persisted atomically.',
  'family.entitlement.changed': 'Billing projection is persisted atomically.',
  'family.entitlement.recompute':
    'License belongs to family; lifecycle gates access after parent departure.',
  'family.deletion_scheduled':
    'Deletion and transactional mail reconciliation scan scheduled requests.',
  'family.deletion_cancelled':
    'Cancellation is persisted; scanners recheck request state.',
  'family.deleted': 'Erasure executor already completed business effects.',
  'us.request.reminder_set':
    'Reminder preference is persisted; no recipient notification required.',
  'us.request.seen': 'Read receipt persisted; no notification template.',
  'us.request.cancel': 'Cancellation persisted; lists read current state.',
  'us.request.expired':
    'Expiry is persisted; request lists read current state.',
  'us.journal.created': 'Private journal remains private; no fan-out.',
  'us.journal.deleted': 'Private journal state is persisted; no fan-out.',
  'us.journal.shared': 'Shared projection is queried under couple ACL.',
  'us.appreciation.reacted':
    'Reaction is persisted; no configured notification template.',
  'us.appreciation.share_requested':
    'Approval state is queried under couple ACL.',
  'us.appreciation.share_approved':
    'Family memory emits its own created and published events.',
  'us.appreciation.share_rejected':
    'Rejection state is queried under couple ACL.',
};

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
