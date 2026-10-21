export interface ProfileImageClientVariantAttributes {
  variantCode: string;
  storageBucket: string;
  storageKey: string;
  mime: string;
  sizeBytes: bigint;
  checksumSha256: Uint8Array;
  width: number | null;
  height: number | null;
}

/** Durable declaration of one client-created account avatar rendition. */
export class ProfileImageClientVariant implements ProfileImageClientVariantAttributes {
  readonly variantCode: string;
  readonly storageBucket: string;
  readonly storageKey: string;
  readonly mime: string;
  readonly sizeBytes: bigint;
  readonly checksumSha256: Uint8Array;
  readonly width: number | null;
  readonly height: number | null;
  constructor(value: ProfileImageClientVariantAttributes) {
    this.variantCode = value.variantCode;
    this.storageBucket = value.storageBucket;
    this.storageKey = value.storageKey;
    this.mime = value.mime;
    this.sizeBytes = value.sizeBytes;
    this.checksumSha256 = value.checksumSha256;
    this.width = value.width;
    this.height = value.height;
  }
}
