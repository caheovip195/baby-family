import type { DependencyStatus } from '../../common/health/dependency-status';

export const OBJECT_STORAGE_SERVICE = Symbol('OBJECT_STORAGE_SERVICE');

/** Logical buckets (spec §10.1); physical names come from configuration. */
export type ObjectStorageBucket = 'media' | 'userMedia' | 'exports' | 'public';

export interface ObjectLocation {
  bucket: ObjectStorageBucket;
  /** Opaque key without names/emails (e.g. `fam/{familyId}/a/{assetId}/orig`). */
  key: string;
}

export interface UploadUrlInput extends ObjectLocation {
  contentType: string;
  /** Base64 SHA-256 of the body; signed so storage rejects any other content. */
  sha256Base64?: string;
  /**
   * Exact body size; signs `Content-Length` so storage rejects any other size
   * (storage without POST Object support, e.g. Contabo, still bounds the size).
   */
  sizeBytes?: number;
  /** Defaults to 900 seconds (spec §10.2). */
  expiresInSeconds?: number;
}

export interface DownloadUrlInput extends ObjectLocation {
  /** Defaults to 3600 seconds (spec §10.5). */
  expiresInSeconds?: number;
  /** Sets `Content-Disposition: attachment` for downloads of originals. */
  downloadFileName?: string;
}

/**
 * Browser-style POST upload (S3 POST Object): storage enforces the signed policy
 * (key, Content-Type, exact size, SHA-256) before accepting the body.
 */
export interface UploadPostInput extends ObjectLocation {
  contentType: string;
  /** Exact body size the policy accepts (`content-length-range`). */
  sizeBytes: number;
  /** Base64 SHA-256 of the body; storage that supports checksums rejects others. */
  sha256Base64?: string;
  /** Defaults to 900 seconds (spec §10.2). */
  expiresInSeconds?: number;
}

export interface PresignedPost {
  method: 'POST';
  url: string;
  /** Form fields to send unchanged, before the `file` field. */
  fields: Record<string, string>;
  expiresAt: Date;
}

export interface PresignedRequest {
  method: 'PUT' | 'GET';
  url: string;
  /** Headers the client must send unchanged (they are part of the signature). */
  headers: Record<string, string>;
  expiresAt: Date;
}

export interface MultipartUploadInput extends ObjectLocation {
  contentType: string;
}

export interface PartUploadUrlsInput extends ObjectLocation {
  uploadId: string;
  partNumbers: number[];
  /**
   * With the part size and total, each URL signs `Content-Length`, so storage
   * rejects any part whose size differs (bounds the multipart object size).
   */
  partSizeBytes?: number;
  totalBytes?: bigint;
  /** Defaults to 3600 seconds (spec §10.2). */
  expiresInSeconds?: number;
}

export interface PartUploadUrls {
  parts: { partNumber: number; url: string }[];
  expiresAt: Date;
}

export interface CompletedPart {
  partNumber: number;
  etag: string;
}

export interface CompleteMultipartInput extends ObjectLocation {
  uploadId: string;
  parts: CompletedPart[];
}

export interface StoredObjectMetadata {
  size: number;
  contentType: string | null;
  etag: string | null;
  /** Full-object SHA-256 (base64) when storage keeps checksums; null otherwise. */
  checksumSha256: string | null;
}

/**
 * S3-compatible object storage (spec §10). Only standard S3 APIs, so MinIO can be
 * replaced (§10.8). Presigned PUT does not bound the size: callers must verify the
 * object with `headObject` before accepting an upload.
 */
export interface IObjectStorageService {
  isConfigured(): boolean;
  checkHealth(): Promise<DependencyStatus>;
  /** Physical bucket name configured for a logical bucket (persisted on assets). */
  bucketName(bucket: ObjectStorageBucket): string;
  /** Logical bucket for a persisted physical name, or null if not configured. */
  bucketOf(name: string): ObjectStorageBucket | null;
  createUploadUrl(input: UploadUrlInput): Promise<PresignedRequest>;
  createUploadPost(input: UploadPostInput): Promise<PresignedPost>;
  createDownloadUrl(input: DownloadUrlInput): Promise<PresignedRequest>;
  /**
   * First `bytes` of an object by ranged GET (at most 64 KiB), for format
   * detection; never the whole object. Null when the object does not exist.
   */
  readObjectPrefix(
    location: ObjectLocation,
    bytes: number,
  ): Promise<Buffer | null>;
  headObject(location: ObjectLocation): Promise<StoredObjectMetadata | null>;
  deleteObject(location: ObjectLocation): Promise<void>;
  /**
   * Erases every version of an object (incl. delete markers) so nothing survives in
   * versioned buckets; used for raw uploads that may carry GPS metadata.
   */
  eraseObjectVersions(location: ObjectLocation): Promise<void>;
  /** Keys under a prefix (e.g. all renditions of one asset). */
  listKeys(bucket: ObjectStorageBucket, prefix: string): Promise<string[]>;
  /** Streams an object to a local file (worker temp storage). */
  downloadToFile(location: ObjectLocation, filePath: string): Promise<void>;
  /** Uploads a local file, replacing any object at the key. */
  uploadFile(
    location: ObjectLocation,
    filePath: string,
    contentType: string,
  ): Promise<void>;
  createMultipartUpload(input: MultipartUploadInput): Promise<string>;
  createPartUploadUrls(input: PartUploadUrlsInput): Promise<PartUploadUrls>;
  /** Throws ValidationError for invalid/missing parts, ConflictError if the upload is gone. */
  completeMultipartUpload(input: CompleteMultipartInput): Promise<void>;
  abortMultipartUpload(
    location: ObjectLocation,
    uploadId: string,
  ): Promise<void>;
}
