import type { MemoryKind } from '../common/database.enums';

/**
 * Technical limits of the memory API (spec §11.5). Plan-dependent limits come
 * from the billing catalog (`photosPerMemory`, `memoryCount` — an absent
 * `memoryCount` means no limit — and `circle.enabled`); kinds with
 * their own workflow (MONTHLY_PHOTO, LETTER, MILESTONE, ...) are added
 * here when that workflow is implemented.
 */
export const MEMORY_POLICY = {
  creatableKinds: [
    'MOMENT',
    'DIARY',
    'KEEPSAKE',
    'QUOTE',
    'VOICE',
  ] as MemoryKind[],
  /** Kinds that must carry at least one asset. */
  assetRequiredKinds: ['KEEPSAKE'] as MemoryKind[],
  /** Request-level ceiling; the plan quota `photosPerMemory` is usually lower. */
  maxAssetsPerRequest: 100,
  maxChildrenPerMemory: 20,
  quoteMaxLength: 280,
  /** Tolerated device clock skew for `occurredAt` in the future. */
  futureSkewMs: 24 * 60 * 60 * 1000,
  timelineDefaultLimit: 20,
  timelineMaxLimit: 50,
  gridDefaultLimit: 30,
  gridMaxLimit: 100,
  feedDefaultLimit: 20,
  feedMaxLimit: 50,
  /** MEM-15: at most this many newest full-text matches are ACL-filtered and paged. */
  searchMatchCap: 500,
  /** MEM-15: words used from one query (each matched as a prefix). */
  searchMaxWords: 8,
  /** MEM-16: memories considered for one day, across all earlier years. */
  onThisDayCap: 100,
  /** MEM-25: memories (and slides) of one child's day for the slideshow. */
  todayStoryCap: 60,
  /** Spec §7.8.3 / MEM-17: trashed memories are kept 30 days, then purged. */
  trashRetentionMs: 30 * 24 * 60 * 60 * 1000,
  /** Memories purged per `memory.purge-trash` run; the next run continues. */
  purgeBatchSize: 100,
  /** Spec §7.12: comments are text ≤ 1,000 characters, editable for 15 minutes. */
  commentMaxLength: 1000,
  commentEditWindowMs: 15 * 60 * 1000,
  /** Upper bound of one comment listing (MEM-10 shows the whole thread). */
  commentListMax: 1000,
} as const;
