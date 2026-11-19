import { DomainError } from '../common/errors/domain.error';
import { MEDIA_POLICY, maxAcceptedSize } from '../config/media-policy';
import type { CreateUploadIntentDto } from '../dto/media/create-upload-intent.dto';
import type {
  IObjectStorageService,
  ObjectLocation,
  StoredObjectMetadata,
} from '../interfaces/services/object-storage-service.interface';
import type { MediaUpload } from '../models/media-upload.model';
import {
  MEDIA_SIGNATURE_PREFIX_BYTES,
  matchesDeclaredMime,
} from './media-content-signature';

const policy = MEDIA_POLICY.client;

/** Client manifest validation; limits here are technical, plan limits stay in MediaService. */
export function validateClientMedia(input: CreateUploadIntentDto): void {
  if (input.variants === undefined) return;
  const fail = (code: string): never => {
    throw new DomainError('Invalid client media manifest.', code, 422);
  };
  if (
    !(policy.mainMimes[input.kind] as readonly string[]).includes(
      input.mime.toLowerCase(),
    )
  )
    fail('MEDIA_TYPE_UNSUPPORTED');
  const codes = input.variants.map((v) => v.code);
  if (
    new Set(codes).size !== codes.length ||
    codes.some(
      (code) =>
        !(policy.allowed[input.kind] as readonly string[]).includes(code),
    )
  )
    fail('MEDIA_VARIANT_INVALID');
  if (
    (policy.required[input.kind] as readonly string[]).some(
      (code) => !codes.includes(code),
    )
  )
    fail('MEDIA_VARIANTS_REQUIRED');
  if (
    input.kind === 'IMAGE' &&
    Math.max(input.width ?? 0, input.height ?? 0) > policy.imageMaxEdge
  )
    fail('MEDIA_DIMENSIONS_EXCEEDED');
  if (input.kind === 'VIDEO') {
    const edges = [input.width ?? 0, input.height ?? 0].sort((a, b) => a - b);
    if (
      edges[0]! > policy.videoMaxShortEdge ||
      edges[1]! > policy.videoMaxLongEdge
    )
      fail('MEDIA_DIMENSIONS_EXCEEDED');
  }
  for (const variant of input.variants) {
    const limit = policy.variants[variant.code as keyof typeof policy.variants];
    if (
      !(policy.imageMimes as readonly string[]).includes(
        variant.mime.toLowerCase(),
      ) ||
      (variant.code === 'poster' && variant.mime.toLowerCase() !== 'image/jpeg')
    )
      fail('MEDIA_VARIANT_TYPE_UNSUPPORTED');
    if (variant.size > limit.maxBytes) fail('MEDIA_VARIANT_TOO_LARGE');
    if (Math.max(variant.width ?? 0, variant.height ?? 0) > limit.maxEdge)
      fail('MEDIA_VARIANT_DIMENSIONS_EXCEEDED');
  }
}

/**
 * Verification shared with the lost-complete reconciler, without media decoding:
 * HEAD (size, Content-Type), SHA-256 and the container's magic bytes.
 */
export async function verifyClientUpload(
  storage: IObjectStorageService,
  upload: MediaUpload,
  location: ObjectLocation,
): Promise<Map<string, bigint>> {
  const sizes = new Map<string, bigint>();
  for (const variant of upload.variants) {
    const objectLocation = { ...location, key: variant.storageKey };
    const head = await storage.headObject(objectLocation);
    const primary = variant.storageKey === upload.asset.storageKey;
    let reason: string | null = null;
    if (!head) reason = primary ? 'MISSING' : 'VARIANT_MISSING';
    else if (!sizeMatches(head.size, variant.sizeBytes))
      reason = primary ? 'SIZE_MISMATCH' : 'VARIANT_SIZE_MISMATCH';
    else if (head.contentType?.toLowerCase() !== variant.mime)
      reason = primary ? 'MIME_MISMATCH' : 'VARIANT_MIME_MISMATCH';
    else {
      const content = await inspectStoredContent(
        storage,
        objectLocation,
        head,
        {
          mime: variant.mime,
          sha256: variant.checksumSha256,
        },
      );
      if (content) reason = primary ? content : `VARIANT_${content}`;
    }
    if (reason)
      throw new DomainError(
        'Uploaded object does not match the manifest.',
        `UPLOAD_${reason}`,
        422,
      );
    sizes.set(variant.variantCode, BigInt(head!.size));
  }
  return sizes;
}

/** How a single (non-multipart) object is sent straight to storage. */
export type SingleUploadMethod = 'POST' | 'PUT';

export interface SingleUploadInstruction {
  mode: 'single';
  method: SingleUploadMethod;
  url: string;
  /** PUT: headers to send unchanged (signed). */
  headers?: Record<string, string>;
  /** POST: form fields to send unchanged before the `file` field. */
  fields?: Record<string, string>;
  expiresAt: Date;
}

/**
 * Signs one direct upload. POST (default) lets storage enforce the policy: key,
 * Content-Type, exact size and SHA-256. PUT signs Content-Type, Content-Length
 * and SHA-256 (storage such as Contabo enforces the first two but ignores the
 * checksum); completion verifies both ways regardless.
 */
export async function signSingleUpload(
  storage: IObjectStorageService,
  method: SingleUploadMethod,
  input: ObjectLocation & {
    contentType: string;
    sizeBytes: bigint;
    sha256: Uint8Array | null;
    expiresInSeconds: number;
  },
): Promise<SingleUploadInstruction> {
  const sha256Base64 = input.sha256
    ? Buffer.from(input.sha256).toString('base64')
    : undefined;
  const location = { bucket: input.bucket, key: input.key };
  if (method === 'POST') {
    const signed = await storage.createUploadPost({
      ...location,
      contentType: input.contentType,
      sizeBytes: Number(input.sizeBytes),
      sha256Base64,
      expiresInSeconds: input.expiresInSeconds,
    });
    return {
      mode: 'single',
      method: 'POST',
      url: signed.url,
      fields: signed.fields,
      expiresAt: signed.expiresAt,
    };
  }
  const signed = await storage.createUploadUrl({
    ...location,
    contentType: input.contentType,
    sha256Base64,
    sizeBytes: Number(input.sizeBytes),
    expiresInSeconds: input.expiresInSeconds,
  });
  return {
    mode: 'single',
    method: 'PUT',
    url: signed.url,
    headers: signed.headers,
    expiresAt: signed.expiresAt,
  };
}

/**
 * Checks what HEAD cannot, without ever downloading the object (server is weak,
 * BF-20261119-003): the SHA-256 storage reports, when it keeps checksums, and
 * the real format from the first {@link MEDIA_SIGNATURE_PREFIX_BYTES} bytes
 * (ranged GET). Storage without checksums (e.g. Contabo) gets no server-side
 * SHA check; signed Content-Type/Content-Length and per-part Content-MD5 bound
 * what can be stored.
 */
export async function inspectStoredContent(
  storage: IObjectStorageService,
  location: ObjectLocation,
  head: StoredObjectMetadata,
  expected: { mime: string; sha256: Uint8Array | null },
): Promise<'CHECKSUM_MISMATCH' | 'CONTENT_TYPE_MISMATCH' | null> {
  if (
    expected.sha256 &&
    head.checksumSha256 &&
    !Buffer.from(head.checksumSha256, 'base64').equals(
      Buffer.from(expected.sha256),
    )
  )
    return 'CHECKSUM_MISMATCH';
  const prefix = await storage.readObjectPrefix(
    location,
    MEDIA_SIGNATURE_PREFIX_BYTES,
  );
  if (!prefix) return 'CHECKSUM_MISMATCH'; // deleted or replaced meanwhile
  if (!matchesDeclaredMime(expected.mime, prefix))
    return 'CONTENT_TYPE_MISMATCH';
  return null;
}

function sizeMatches(actual: number, declared: bigint): boolean {
  const value = BigInt(actual);
  return (
    value > 0n &&
    value <= maxAcceptedSize(declared) &&
    value * 100n >= declared * (100n - MEDIA_POLICY.sizeTolerancePercent)
  );
}
