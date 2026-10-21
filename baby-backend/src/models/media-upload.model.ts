import type { Asset } from './asset.model';
import type { AssetVariant } from './asset-variant.model';

export interface MediaUploadReservation {
  readonly status: string;
  readonly reservedBytes: bigint;
  readonly expiresAt: Date;
  readonly idempotencyKey: string;
}

/** An asset together with its storage reservation (upload workflow state). */
export class MediaUpload {
  constructor(
    readonly asset: Asset,
    readonly reservation: MediaUploadReservation | null,
    readonly variants: readonly AssetVariant[] = [],
  ) {}

  isPending(): boolean {
    return this.asset.status === 'PENDING_UPLOAD';
  }

  isExpired(now: Date): boolean {
    return (
      !this.reservation ||
      this.reservation.status !== 'RESERVED' ||
      this.reservation.expiresAt.getTime() <= now.getTime()
    );
  }

  /**
   * Why a stored object does not match this upload intent, or null when it does
   * (spec §10.2: presigned PUT does not bound the size).
   */
  rejectionReason(
    stored: { size: number; contentType: string | null },
    maxAcceptedBytes: bigint,
  ): 'SIZE_MISMATCH' | 'MIME_MISMATCH' | null {
    if (stored.size === 0 || BigInt(stored.size) > maxAcceptedBytes)
      return 'SIZE_MISMATCH';
    if (stored.contentType?.toLowerCase() !== this.asset.mime)
      return 'MIME_MISMATCH';
    return null;
  }

  partCount(partSizeBytes: number): number {
    return Number(
      (this.asset.declaredSize + BigInt(partSizeBytes) - 1n) /
        BigInt(partSizeBytes),
    );
  }
}

/** An asset the viewer may see, with its processed variants. */
/**
 * Fingerprint of the original file on the uploader's device, declared by the
 * client (BF-20261021-008) so the app can show its own gallery copy first.
 * Not verified by the server; never used for access or dedup decisions.
 */
export interface MediaSource {
  /** SHA-256 of the original bytes before client processing. */
  readonly sha256: Uint8Array;
  /** Client metadata key (`kind|shortxlong|seconds`), see the app. */
  readonly key: string;
  readonly capturedAt: Date | null;
}

/** Response shape of {@link MediaSource}; null when not declared. */
export function mediaSourceJson(
  asset: Pick<Asset, 'sourceSha256' | 'sourceKey' | 'capturedAt'>,
): { sha256: string; key: string; capturedAt: string | null } | null {
  if (asset.sourceSha256 === null || asset.sourceKey === null) return null;
  return {
    sha256: Buffer.from(asset.sourceSha256).toString('hex'),
    key: asset.sourceKey,
    capturedAt: asset.capturedAt?.toISOString() ?? null,
  };
}

export class MediaAssetView {
  constructor(
    readonly asset: Asset,
    readonly variants: readonly AssetVariant[],
  ) {}

  isReady(): boolean {
    return this.asset.status === 'READY';
  }
}
