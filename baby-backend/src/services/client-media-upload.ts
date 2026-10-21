import { DomainError } from '../common/errors/domain.error';
import { MEDIA_POLICY, maxAcceptedSize } from '../config/media-policy';
import type { CreateUploadIntentDto } from '../dto/media/create-upload-intent.dto';
import type {
  IObjectStorageService,
  ObjectLocation,
} from '../interfaces/services/object-storage-service.interface';
import type { MediaUpload } from '../models/media-upload.model';

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

/** HEAD-only verification, shared with the lost-complete reconciler. No media decoding. */
export async function verifyClientUpload(
  storage: IObjectStorageService,
  upload: MediaUpload,
  location: ObjectLocation,
): Promise<Map<string, bigint>> {
  const sizes = new Map<string, bigint>();
  for (const variant of upload.variants) {
    const head = await storage.headObject({
      ...location,
      key: variant.storageKey,
    });
    const primary = variant.storageKey === upload.asset.storageKey;
    let reason: string | null = null;
    if (!head) reason = primary ? 'MISSING' : 'VARIANT_MISSING';
    else if (!sizeMatches(head.size, variant.sizeBytes))
      reason = primary ? 'SIZE_MISMATCH' : 'VARIANT_SIZE_MISMATCH';
    else if (head.contentType?.toLowerCase() !== variant.mime)
      reason = primary ? 'MIME_MISMATCH' : 'VARIANT_MIME_MISMATCH';
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

function sizeMatches(actual: number, declared: bigint): boolean {
  const value = BigInt(actual);
  return (
    value > 0n &&
    value <= maxAcceptedSize(declared) &&
    value * 100n >= declared * (100n - MEDIA_POLICY.sizeTolerancePercent)
  );
}
