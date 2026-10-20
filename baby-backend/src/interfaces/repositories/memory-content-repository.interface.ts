import type { TimelineFilter } from '../../dto/memory/timeline-query.dto';
import type {
  MemoryGridAsset,
  TimelineChildContext,
} from '../../models/memory-view.model';
import type {
  MemoryKind,
  MomentFeeling,
  Visibility,
} from '../../common/database.enums';
import type {
  MemoryCreationContext,
  MemoryView,
} from '../../models/memory-view.model';

export const MEMORY_CONTENT_REPOSITORY = Symbol('MEMORY_CONTENT_REPOSITORY');

export interface CreateMemoryCommand {
  authorRole?: 'PARENT' | 'CIRCLE';
  status?: 'DRAFT' | 'PENDING_REVIEW';
  unlockAt?: Date | null;
  milestone?: {
    templateCode?: string;
    customTitle?: string;
    occurredOn: string;
  };
  letter?: {
    childId: string;
    releaseRule: string;
    birthdayNumber?: number;
    releaseVisibility: Visibility;
  };

  familyId: string;
  authorUserId: string;
  idempotencyKey: string;
  /** SHA-256 of the canonical request; a reused key with another hash is rejected. */
  requestHash: Uint8Array;
  kind: MemoryKind;
  title: string | null;
  body: string | null;
  occurredAt: Date;
  occurredLocalDate: Date;
  visibility: Visibility;
  familyMoment: boolean;
  pregnancyId: string | null;
  pregnancyWeek: number | null;
  feeling: MomentFeeling | null;
  locationLabel: string | null;
  quoteContext: string | null;
  commentsEnabled: boolean;
  children: { childId: string; ageMonth: number }[];
  assets: { assetId: string; sortOrder: number; isCover: boolean }[];
  /** Plan quota `memoryCount`; null = the plan sets no limit. */
  memoryQuota: number | null;
  idempotencyExpiresAt: Date;
}

export interface MemoryFeedCursor {
  createdAt: Date;
  id: string;
}

export interface MemoryFeedFilter {
  childId?: string;
  pregnancyId?: string;
  /** Restrict to these ids (search / on-this-day matches). */
  ids?: string[];
  kind?: MemoryKind;
  after: MemoryFeedCursor | null;
  limit: number;
}

export interface UpdateMemoryCommand {
  assets?: { assetId: string; sortOrder: number; isCover: boolean }[];
  assetQuota?: number;

  familyId: string;
  memoryId: string;
  actorUserId: string;
  /** `If-Match` version; a different current version → 412 VERSION_CONFLICT. */
  expectedVersion: number;
  title: string | null;
  body: string | null;
  occurredAt: Date;
  occurredLocalDate: Date;
  visibility: Visibility;
  familyMoment: boolean;
  pregnancyId: string | null;
  pregnancyWeek: number | null;
  feeling: MomentFeeling | null;
  locationLabel: string | null;
  quoteContext: string | null;
  commentsEnabled: boolean;
  /** Complete subject set; removed children are soft-deleted, re-added restored. */
  children: { childId: string; ageMonth: number }[];
  /** Names of the fields the request changed (outbox `memory.updated`). */
  changedFields: string[];
}

export interface MemoryTrashCursor {
  trashedAt: Date;
  id: string;
}

export interface TrashMemoryCommand {
  familyId: string;
  memoryId: string;
  actorUserId: string;
  purgeAfter: Date;
}

export interface RestoreMemoryCommand {
  familyId: string;
  memoryId: string;
  actorUserId: string;
  /** Plan quota `memoryCount`; null = the plan sets no limit. */
  memoryQuota: number | null;
}

/** Memory create/read/trash persistence (spec §6.3, §7.8.3, §11.5). */
export interface IMemoryContentRepository {
  readableSubjects(
    familyId: string,
    userId: string,
  ): Promise<{ isParent: boolean; childIds: string[]; pregnancyIds: string[] }>;
  contributionSubjects(
    familyId: string,
    userId: string,
  ): Promise<{ childIds: string[]; pregnancyIds: string[] }>;
  listDrafts(familyId: string, userId: string): Promise<MemoryView[]>;
  publish(
    familyId: string,
    userId: string,
    memoryId: string,
    expectedVersion: number,
  ): Promise<MemoryView>;

  listTimelineForParent(
    familyId: string,
    userId: string,
    filter: TimelineRepositoryFilter,
  ): Promise<MemoryView[]>;
  findTimelineChild(
    familyId: string,
    childId: string,
  ): Promise<TimelineChildContext | null>;
  listMediaGridForParent(
    familyId: string,
    userId: string,
    filter: MediaGridRepositoryFilter,
  ): Promise<MemoryGridAsset[]>;

  findCreationContext(
    familyId: string,
    actorUserId: string,
    input: {
      childIds: readonly string[];
      pregnancyId: string | null;
      assetIds: readonly string[];
    },
  ): Promise<MemoryCreationContext | null>;
  /** Memory already created by (actor, Idempotency-Key); 409 when the hash differs, 404 when that memory is gone. */
  findReplay(
    authorUserId: string,
    idempotencyKey: string,
    requestHash: Uint8Array,
  ): Promise<MemoryView | null>;
  /**
   * One transaction: family usage locked and `memory_count` checked against
   * `memoryQuota` then incremented (402 QUOTA_MEMORY_COUNT_EXCEEDED), assets
   * locked and re-checked (own and stored, or another Parent's READY asset the
   * author already sees), memory + memory_children + memory_assets,
   * status PUBLISHED when every asset is READY (else PROCESSING), outbox
   * `memory.created` (+ `memory.published`).
   */
  create(command: CreateMemoryCommand): Promise<MemoryView>;
  findFamilyId(memoryId: string): Promise<string | null>;
  /**
   * One transaction: the live memory row updated only when `version` equals
   * `expectedVersion` (version+1), subject links synced, outbox `memory.updated`.
   * 412 VERSION_CONFLICT on a stale version, 404 when the memory is gone.
   */
  update(command: UpdateMemoryCommand): Promise<MemoryView>;
  /** Spec §6.3 Parent filter (own drafts/processing included). */
  findVisibleToParent(
    familyId: string,
    userId: string,
    memoryId: string,
  ): Promise<MemoryView | null>;
  /** Feed page, newest first; drafts excluded. Returns up to `limit + 1` rows. */
  listFeedForParent(
    familyId: string,
    userId: string,
    filter: MemoryFeedFilter,
  ): Promise<MemoryView[]>;
  /** MEM-15: prefix full-text matches (ACL is applied by the caller's list). */
  searchMatchIds(
    familyId: string,
    words: string[],
    cap: number,
  ): Promise<string[]>;
  /** MEM-16: same local day/month in earlier years (`day` = YYYY-MM-DD). */
  onThisDayIds(familyId: string, day: string, cap: number): Promise<string[]>;
  familyTimezone(familyId: string): Promise<string | null>;
  /** MEM-25: a child's memory ids on one family-local day (ACL by caller). */
  childDayIds(
    familyId: string,
    childId: string,
    day: string,
    cap: number,
  ): Promise<string[]>;
  findChildFamilyId(childId: string): Promise<string | null>;
  /**
   * One transaction: family usage locked, a live memory → TRASHED (soft delete:
   * deleted_at, trashed_at/by, purge_after, version+1), `memory_count` decremented, outbox `memory.trashed`.
   * False when the memory is not live any more (already trashed concurrently).
   */
  trash(command: TrashMemoryCommand): Promise<boolean>;
  /** Trashed, not yet expired, and visible to the Parent (spec §6.3 rules). */
  findTrashedVisibleToParent(
    familyId: string,
    userId: string,
    memoryId: string,
  ): Promise<MemoryView | null>;
  /** Trash page, most recently trashed first. Returns up to `limit + 1` rows. */
  listTrashForParent(
    familyId: string,
    userId: string,
    filter: { after: MemoryTrashCursor | null; limit: number },
  ): Promise<MemoryView[]>;
  /**
   * One transaction: usage locked and `memory_count` re-checked/incremented
   * (402 QUOTA_MEMORY_COUNT_EXCEEDED), TRASHED → PUBLISHED when every asset is
   * READY (else PROCESSING), outbox `memory.restored`; 404 when not restorable.
   */
  restore(command: RestoreMemoryCommand): Promise<MemoryView>;
  /**
   * TRASHED → PURGED (soft-deleted with its subject/asset links, outbox
   * `memory.purged`). Assets left without links are retired by media maintenance.
   */
  purge(
    familyId: string,
    memoryId: string,
    actorUserId: string | null,
  ): Promise<boolean>;
  /** Trashed memories whose `purge_after` has passed (oldest first). */
  findExpiredTrash(
    now: Date,
    limit: number,
    familyId?: string,
  ): Promise<{ id: string; familyId: string }[]>;
}

export interface OccurredCursor {
  occurredAt: Date;
  id: string;
}
export interface TimelineRepositoryFilter {
  childId?: string;
  pregnancyId?: string;
  filter: TimelineFilter;
  after: OccurredCursor | null;
  limit: number;
}
export interface MediaGridRepositoryFilter {
  childId?: string;
  kind?: 'IMAGE' | 'VIDEO';
  after: OccurredCursor | null;
  limit: number;
}
