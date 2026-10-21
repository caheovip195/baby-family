import type {
  AssetKind,
  AssetStatus,
  ReactionType,
} from '../common/database.enums';
import type { Memory } from './memory.model';

/** A person permitted by the readable memory's family context. */
export class MemoryPersonView {
  constructor(
    readonly memberId: string | null,
    readonly userId: string | null,
    readonly displayName: string,
  ) {}
}

/** Asset attached to a memory, in display order. */
export interface MemoryAssetRef {
  readonly assetId: string;
  readonly kind: AssetKind;
  readonly status: AssetStatus;
  readonly sortOrder: number;
  readonly isCover: boolean;
  readonly width: number | null;
  readonly height: number | null;
  readonly durationMs: number | null;
  readonly blurhash: string | null;
}

/** A memory with its active subjects and assets (read model of spec §11.3/11.5). */
export class MemoryView {
  constructor(
    readonly memory: Memory,
    readonly childIds: readonly string[],
    readonly assets: readonly MemoryAssetRef[],
    /** Active reactions (one per person, spec §7.12). */
    readonly reactions: readonly {
      userId: string;
      type: ReactionType;
    }[] = [],
    readonly people: readonly MemoryPersonView[] = [],
  ) {}

  /** Active reactions per type. */
  get reactionCounts(): Record<string, number> {
    const counts: Record<string, number> = {};
    for (const reaction of this.reactions)
      counts[reaction.type] = (counts[reaction.type] ?? 0) + 1;
    return counts;
  }

  reactionOf(userId: string): ReactionType | null {
    return (
      this.reactions.find((reaction) => reaction.userId === userId)?.type ??
      null
    );
  }

  get coverAssetId(): string | null {
    return (
      this.assets.find((asset) => asset.isCover)?.assetId ??
      this.assets[0]?.assetId ??
      null
    );
  }

  /** Sealed letter (spec §6.3): only the author sees it before `unlockAt`. */
  isSealedFor(userId: string, now: Date): boolean {
    const { kind, unlockAt, authorUserId } = this.memory;
    return (
      kind === 'LETTER' &&
      unlockAt !== null &&
      unlockAt.getTime() > now.getTime() &&
      authorUserId !== userId
    );
  }
}

/** Child/pregnancy/asset facts the service validates before creating a memory. */
export interface MemoryCreationContext {
  readonly timezone: string;
  readonly activeChildCount: number;
  readonly children: readonly {
    id: string;
    birthDate: Date;
    active: boolean;
  }[];
  readonly pregnancy: {
    id: string;
    dueDate: Date | null;
    active: boolean;
  } | null;
  readonly assets: readonly {
    id: string;
    uploaderUserId: string;
    /** Processed server metadata; optional for legacy non-audio contexts. */
    kind?: AssetKind;
    durationMs?: number | null;
    purpose: string;
    status: AssetStatus;
    /** Another Parent's asset the actor already sees via the family ACL (spec §6.3). */
    sharedWithActor: boolean;
  }[];
  /** Plan quotas/features in effect (raw catalog JSON, parsed by the service). */
  readonly quotas: unknown;
  readonly features: unknown;
}

/** A distinct READY visual asset and its newest visible memory occurrence. */
export class MemoryGridAsset {
  constructor(
    readonly assetId: string,
    readonly memoryId: string,
    readonly kind: 'IMAGE' | 'VIDEO',
    readonly width: number | null,
    readonly height: number | null,
    readonly durationMs: number | null,
    readonly blurhash: string | null,
    readonly occurredAt: Date,
  ) {}
}

/** Calendar facts for child timeline system cards, scoped to an active family. */
export class TimelineChildContext {
  constructor(
    readonly childId: string,
    readonly birthDate: Date,
    readonly timezone: string,
  ) {}
}
