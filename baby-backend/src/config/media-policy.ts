import type { AssetKind } from '../common/database.enums';
import type { ObjectStorageBucket } from '../interfaces/services/object-storage-service.interface';

const MIB = 1024 * 1024;

export interface MediaKindPolicy {
  /** Formats the media worker can process (spec §10.3/10.4); HEIC is converted on device. */
  readonly mimes: readonly string[];
  /** Technical per-file ceiling; plan quotas (storage, duration) are checked separately. */
  readonly maxBytes: number;
  /** Plan quota key (seconds) that bounds `durationMs`, when the kind has a duration. */
  readonly durationQuota?: 'videoMaxSec' | 'audioMaxSec';
}

export interface MediaPurposePolicy {
  readonly kinds: readonly AssetKind[];
  readonly bucket: ObjectStorageBucket;
  /** Only the uploader may ever see it (DB: JOURNAL ⇔ private_owner_user_id). */
  readonly private?: boolean;
}

/**
 * Upload/view policy (spec §10). Plan-dependent limits live in the billing catalog
 * (`storageBytes`, `videoMaxSec`, `audioMaxSec`); this holds technical limits only.
 * Purposes not listed here (RECAP, EXPORT) are not client-uploadable.
 */
export const MEDIA_POLICY = {
  kinds: {
    IMAGE: {
      mimes: ['image/jpeg', 'image/png', 'image/webp', 'image/gif'],
      maxBytes: 50 * MIB,
    },
    VIDEO: {
      mimes: ['video/mp4', 'video/quicktime'],
      maxBytes: 4096 * MIB,
      durationQuota: 'videoMaxSec',
    },
    AUDIO: {
      mimes: ['audio/mp4', 'audio/x-m4a', 'audio/aac', 'audio/mpeg'],
      maxBytes: 200 * MIB,
      durationQuota: 'audioMaxSec',
    },
  } satisfies Record<AssetKind, MediaKindPolicy>,
  purposes: {
    MEMORY: { kinds: ['IMAGE', 'VIDEO', 'AUDIO'], bucket: 'media' },
    AVATAR: { kinds: ['IMAGE'], bucket: 'media' },
    COVER: { kinds: ['IMAGE'], bucket: 'media' },
    // US-07 private journal photos (BF-20261019-004): separate bucket, owner only.
    JOURNAL: { kinds: ['IMAGE'], bucket: 'userMedia', private: true },
  } satisfies Record<string, MediaPurposePolicy>,
  client: {
    imageMimes: ['image/jpeg', 'image/webp'],
    mainMimes: {
      IMAGE: ['image/jpeg', 'image/webp', 'image/png'],
      VIDEO: ['video/mp4'],
      AUDIO: ['audio/mp4', 'audio/x-m4a'],
    },
    imageMaxEdge: 4096,
    videoMaxShortEdge: 1080,
    videoMaxLongEdge: 1920,
    variants: {
      m1080: { maxBytes: 5 * MIB, maxEdge: 1080 },
      t320: { maxBytes: 5 * MIB, maxEdge: 320 },
      l2048: { maxBytes: 10 * MIB, maxEdge: 2048 },
      poster: { maxBytes: 5 * MIB, maxEdge: 1920 },
    },
    required: {
      IMAGE: ['m1080', 't320'],
      VIDEO: ['poster', 't320'],
      AUDIO: [],
    },
    allowed: {
      IMAGE: ['m1080', 't320', 'l2048'],
      VIDEO: ['poster', 't320'],
      AUDIO: [],
    },
    primaryCode: { IMAGE: 'orig', VIDEO: 'v1080', AUDIO: 'a' },
  },
  uploadUrlTtlSeconds: 15 * 60,
  partUrlTtlSeconds: 60 * 60,
  viewUrlTtlSeconds: 60 * 60,
  multipartThresholdBytes: 20 * MIB,
  partSizeBytes: 8 * MIB,
  /** Unconfirmed uploads expire with the orphan purge window (spec §10.2). */
  reservationTtlMs: 24 * 60 * 60 * 1000,
  /** Stored size may exceed the declared size by at most 5 % (spec §10.2). */
  sizeTolerancePercent: 5n,
  maxBatchAssets: 100,
} as const;

export type MediaPurpose = keyof typeof MEDIA_POLICY.purposes;

/** Largest stored size accepted at completion; also the bytes reserved for quota. */
export function maxAcceptedSize(declaredSize: bigint): bigint {
  return (
    declaredSize +
    (declaredSize * MEDIA_POLICY.sizeTolerancePercent + 99n) / 100n
  );
}

export function mediaStorageKey(familyId: string, assetId: string): string {
  return `fam/${familyId}/a/${assetId}/orig`;
}
