import type { AssetKind } from '../../common/database.enums';
import type { JobLease } from '../../models/job-lease.model';
import type { Asset } from '../../models/asset.model';
import type {
  MediaAssetView,
  MediaUpload,
} from '../../models/media-upload.model';

export const MEDIA_REPOSITORY = Symbol('MEDIA_REPOSITORY');

export interface ReserveUploadInput {
  familyId: string;
  allowSharedCopy?: boolean;
  uploaderUserId: string;
  idempotencyKey: string;
  /** SHA-256 of the canonical request; a reused key with another hash is rejected. */
  requestHash: Uint8Array;
  kind: AssetKind;
  purpose: string;
  mime: string;
  declaredSize: bigint;
  sha256: Uint8Array;
  width: number | null;
  height: number | null;
  durationMs: number | null;
  storageBucket: string;
  storageKey: (assetId: string) => string;
  /** Owner-only asset (JOURNAL); the DB requires it to equal the uploader. */
  privateOwnerUserId?: string | null;
  /** Bytes held until completion: the largest size `complete` will accept. */
  reservedBytes: bigint;
  /** Plan storage quota; checked against used + reserved under a row lock. */
  storageLimitBytes: bigint;
  /** Uploads up to this size are checksum-verified by storage (single PUT). */
  checksumVerifiedMaxBytes: bigint;
  reservationExpiresAt: Date;
}

export type ReserveUploadResult =
  /** New asset + reservation, or an existing pending upload (replay/resume). */
  | { outcome: 'created' | 'replayed'; upload: MediaUpload }
  /** Same content already stored for this family/purpose: no upload needed. */
  | { outcome: 'duplicate'; asset: Asset };

export interface ProcessedVariantInput {
  code: string;
  storageBucket: string;
  storageKey: string;
  mime: string;
  sizeBytes: bigint;
  width: number | null;
  height: number | null;
  durationMs: number | null;
}

export interface ProcessingResult {
  width: number | null;
  height: number | null;
  durationMs: number | null;
  capturedAt: Date | null;
  blurhash: string | null;
  keepOriginal: boolean;
  variants: ProcessedVariantInput[];
}

export type ProcessingCommit = 'COMPLETED' | 'NOT_PROCESSING' | 'LEASE_LOST';

/**
 * Purge rules (spec §10.2): expired uploads, FAILED assets past retention, and
 * never-attached MEMORY uploads (opt-in).
 */
/**
 * `DETACHED`: a memory asset that was attached but every memory/perspective using
 * it is gone (purged trash, spec §10.7) — retired without waiting.
 */
export type PurgeRule = 'EXPIRED_UPLOAD' | 'FAILED' | 'UNATTACHED' | 'DETACHED';

/** Plan version in effect for a family (raw catalog JSON, parsed by services). */
export interface EffectivePlanData {
  quotas: unknown;
  features: unknown;
}

export interface IMediaRepository {
  /**
   * Atomically: replay by (actor, Idempotency-Key) from `ops.idempotency_records`,
   * dedup by verified (family, purpose, sha256), quota check on locked
   * `billing.family_usage`, then create PENDING_UPLOAD asset + reservation. Every
   * successful outcome is recorded for replay. Throws 402 QUOTA_STORAGE_EXCEEDED,
   * 409 IDEMPOTENCY_KEY_REUSED / UPLOAD_IN_PROGRESS / UPLOAD_PENDING_VERIFICATION.
   */
  reserveUpload(input: ReserveUploadInput): Promise<ReserveUploadResult>;
  findUpload(assetId: string): Promise<MediaUpload | null>;
  /** Stores the multipart upload id unless one exists; returns the effective id. */
  attachMultipartUpload(assetId: string, uploadId: string): Promise<string>;
  /**
   * PENDING_UPLOAD → UPLOADED, reservation CONFIRMED, usage moved from reserved to
   * stored and a `media.asset_uploaded` outbox event, in one transaction. Idempotent.
   */
  confirmUpload(assetId: string, sizeBytes: bigint): Promise<Asset>;
  /** PENDING_UPLOAD → FAILED and release the reservation. */
  failUpload(assetId: string, reason: string): Promise<void>;
  /** Family of each existing (non-deleted) asset. */
  findFamilyIds(assetIds: readonly string[]): Promise<Map<string, string>>;
  /**
   * Assets a Parent may view (spec §6.3): own uploads, family AVATAR/COVER, and
   * media of memories/perspectives visible to that Parent; sealed letters excluded.
   */
  findViewableByParent(
    familyId: string,
    userId: string,
    assetIds: readonly string[],
  ): Promise<MediaAssetView[]>;

  hasContributeChild(familyId: string, userId: string): Promise<boolean>;
  findViewableByCircle(
    familyId: string,
    userId: string,
    assetIds: readonly string[],
  ): Promise<MediaAssetView[]>;

  // --- Worker (spec §10.3/10.4) ---
  /** UPLOADED/PROCESSING → PROCESSING; null when the asset is gone or finished. */
  startProcessing(assetId: string): Promise<Asset | null>;
  findAssetView(assetId: string): Promise<MediaAssetView | null>;
  findEffectivePlan(familyId: string): Promise<EffectivePlanData | null>;
  /**
   * PROCESSING → READY with variants and storage usage delta, only while `lease`
   * still owns its job run (fencing checked in the same transaction).
   */
  completeProcessing(
    assetId: string,
    result: ProcessingResult,
    lease: JobLease,
  ): Promise<ProcessingCommit>;
  /** UPLOADED/PROCESSING → FAILED under the same fencing rule. */
  failProcessing(
    assetId: string,
    reason: string,
    lease: JobLease,
  ): Promise<boolean>;
  /** PROCESSING assets untouched since `before` (worker gave up) → FAILED. */
  failStaleProcessing(before: Date): Promise<number>;
  /**
   * UPLOADED/PROCESSING assets idle since `before` whose processing run is missing,
   * waiting or has an expired lease (lost queue job), for re-enqueueing.
   */
  findStuckProcessing(
    before: Date,
    runKeyPrefix: string,
    limit: number,
  ): Promise<Asset[]>;

  // --- Maintenance (purge-orphans, reconcile-uploads) ---
  findPurgeCandidates(
    rule: PurgeRule,
    cutoff: Date,
    limit: number,
  ): Promise<string[]>;
  /**
   * Atomically re-checks `rule`, refunds quota (open reservation and stored bytes),
   * soft-deletes the asset and variants and marks its objects for deletion.
   */
  retireAsset(assetId: string, rule: PurgeRule, cutoff: Date): Promise<boolean>;
  /** Retired assets whose storage objects are not deleted yet. */
  findAssetsAwaitingObjectPurge(limit: number): Promise<Asset[]>;
  markObjectsPurged(assetId: string): Promise<void>;
  /** Unexpired single uploads created before `before` but never completed. */
  findUncompletedUploads(
    before: Date,
    maxDeclaredBytes: bigint,
    limit: number,
  ): Promise<MediaUpload[]>;
}
