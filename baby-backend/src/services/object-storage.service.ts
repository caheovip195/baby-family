import { createReadStream, createWriteStream } from 'node:fs';
import { stat } from 'node:fs/promises';
import type { Readable } from 'node:stream';
import { pipeline } from 'node:stream/promises';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  AbortMultipartUploadCommand,
  CompleteMultipartUploadCommand,
  CreateMultipartUploadCommand,
  DeleteObjectCommand,
  DeleteObjectsCommand,
  GetObjectCommand,
  HeadBucketCommand,
  HeadObjectCommand,
  ListObjectVersionsCommand,
  ListObjectsV2Command,
  PutObjectCommand,
  S3Client,
  S3ServiceException,
  UploadPartCommand,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import {
  ConflictError,
  ServiceUnavailableError,
  ValidationError,
} from '../common/errors/domain.error';
import type { Environment } from '../config/environment';
import type { DependencyStatus } from '../common/health/dependency-status';
import type {
  CompleteMultipartInput,
  DownloadUrlInput,
  IObjectStorageService,
  ObjectLocation,
  MultipartUploadInput,
  ObjectStorageBucket,
  PartUploadUrls,
  PartUploadUrlsInput,
  PresignedRequest,
  StoredObjectMetadata,
  UploadUrlInput,
} from '../interfaces/services/object-storage-service.interface';

const DEFAULT_UPLOAD_TTL_SECONDS = 15 * 60;
const DEFAULT_DOWNLOAD_TTL_SECONDS = 60 * 60;
const DEFAULT_PART_TTL_SECONDS = 60 * 60;
const MAX_PART_NUMBER = 10_000; // S3 limit
const MAX_PARTS_PER_SIGNING = 1_000;
const SHA256_BASE64_PATTERN = /^[A-Za-z0-9+/]{43}=$/;
// S3 error codes that mean the client sent bad/missing parts rather than an outage.
const INVALID_PART_ERRORS = new Set([
  'InvalidPart',
  'InvalidPartOrder',
  'EntityTooSmall',
  'MalformedXML',
]);
const MAX_PRESIGN_TTL_SECONDS = 7 * 24 * 60 * 60; // SigV4 limit
const REQUEST_TIMEOUT_MS = 5000;
const TRANSFER_TIMEOUT_MS = 10 * 60 * 1000;
const KEY_PATTERN = /^[A-Za-z0-9][A-Za-z0-9!_.*'()/-]{0,1023}$/;
const CONTENT_TYPE_PATTERN = /^[a-z0-9][a-z0-9.+-]*\/[a-z0-9][a-z0-9.+-]*$/i;

interface S3Clients {
  /** Server-side operations over the internal endpoint (e.g. Docker network). */
  internal: S3Client;
  /** Signs URLs for the endpoint the app can reach; the host is part of the signature. */
  public: S3Client;
}

@Injectable()
/** S3 API adapter (path-style for MinIO); no provider-specific calls (spec §10.8). */
export class ObjectStorageService implements IObjectStorageService {
  private readonly clients: S3Clients | null;
  private readonly buckets: Record<ObjectStorageBucket, string>;

  constructor(config: ConfigService<Environment, true>) {
    this.buckets = {
      media: config.get('S3_BUCKET_MEDIA', { infer: true }),
      userMedia: config.get('S3_BUCKET_USER_MEDIA', { infer: true }),
      exports: config.get('S3_BUCKET_EXPORTS', { infer: true }),
      public: config.get('S3_BUCKET_PUBLIC', { infer: true }),
    };
    const endpoint = config.get('S3_ENDPOINT', { infer: true });
    const accessKeyId = config.get('S3_ACCESS_KEY_ID', { infer: true });
    const secretAccessKey = config.get('S3_SECRET_ACCESS_KEY', { infer: true });
    if (!endpoint || !accessKeyId || !secretAccessKey) {
      this.clients = null;
      return;
    }
    const create = (url: string) =>
      new S3Client({
        endpoint: url,
        region: config.get('S3_REGION', { infer: true }),
        forcePathStyle: config.get('S3_FORCE_PATH_STYLE', { infer: true }),
        credentials: { accessKeyId, secretAccessKey },
        // Default checksums add x-amz-checksum-* to presigned PUTs, which clients cannot satisfy.
        requestChecksumCalculation: 'WHEN_REQUIRED',
        responseChecksumValidation: 'WHEN_REQUIRED',
        maxAttempts: 2,
      });
    const publicEndpoint =
      config.get('S3_PUBLIC_ENDPOINT', { infer: true }) ?? endpoint;
    const internal = create(endpoint);
    this.clients = {
      internal,
      public: publicEndpoint === endpoint ? internal : create(publicEndpoint),
    };
  }

  isConfigured(): boolean {
    return this.clients !== null;
  }

  bucketName(bucket: ObjectStorageBucket): string {
    return this.buckets[bucket];
  }

  bucketOf(name: string): ObjectStorageBucket | null {
    const entry = Object.entries(this.buckets).find(
      ([, configured]) => configured === name,
    );
    return entry ? (entry[0] as ObjectStorageBucket) : null;
  }

  async checkHealth(): Promise<DependencyStatus> {
    if (!this.clients) return 'disabled';
    try {
      await this.clients.internal.send(
        new HeadBucketCommand({ Bucket: this.buckets.media }),
        { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
      );
      return 'up';
    } catch {
      return 'down';
    }
  }

  async createUploadUrl(input: UploadUrlInput): Promise<PresignedRequest> {
    const clients = this.requireClients();
    const expiresIn = presignTtl(
      input.expiresInSeconds,
      DEFAULT_UPLOAD_TTL_SECONDS,
    );
    assertContentType(input.contentType);
    if (
      input.sha256Base64 !== undefined &&
      !SHA256_BASE64_PATTERN.test(input.sha256Base64)
    ) {
      throw new ValidationError('SHA-256 checksum is invalid.');
    }
    const command = new PutObjectCommand({
      ...this.resolve(input),
      ContentType: input.contentType,
      ...(input.sha256Base64 ? { ChecksumSHA256: input.sha256Base64 } : {}),
    });
    // The presigner leaves content-type unsigned by default; sign it so the
    // client cannot store a different type than the one that was authorized.
    // A signed checksum makes storage reject any body other than the declared one.
    const signed = ['content-type'];
    const headers: Record<string, string> = {
      'Content-Type': input.contentType,
    };
    if (input.sha256Base64) {
      signed.push('x-amz-checksum-sha256');
      headers['x-amz-checksum-sha256'] = input.sha256Base64;
    }
    const url = await this.sign(clients, command, expiresIn, signed);
    return {
      method: 'PUT',
      url,
      headers,
      expiresAt: new Date(Date.now() + expiresIn * 1000),
    };
  }

  async createDownloadUrl(input: DownloadUrlInput): Promise<PresignedRequest> {
    const clients = this.requireClients();
    const expiresIn = presignTtl(
      input.expiresInSeconds,
      DEFAULT_DOWNLOAD_TTL_SECONDS,
    );
    const command = new GetObjectCommand({
      ...this.resolve(input),
      ...(input.downloadFileName
        ? {
            ResponseContentDisposition: attachmentDisposition(
              input.downloadFileName,
            ),
          }
        : {}),
    });
    const url = await this.sign(clients, command, expiresIn);
    return {
      method: 'GET',
      url,
      headers: {},
      expiresAt: new Date(Date.now() + expiresIn * 1000),
    };
  }

  async headObject(
    location: ObjectLocation,
  ): Promise<StoredObjectMetadata | null> {
    const clients = this.requireClients();
    try {
      const result = await clients.internal.send(
        new HeadObjectCommand(this.resolve(location)),
        { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
      );
      return {
        size: result.ContentLength ?? 0,
        contentType: result.ContentType ?? null,
        etag: result.ETag ?? null,
      };
    } catch (error) {
      if (
        error instanceof S3ServiceException &&
        error.$metadata.httpStatusCode === 404
      ) {
        return null;
      }
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async deleteObject(location: ObjectLocation): Promise<void> {
    const clients = this.requireClients();
    try {
      await clients.internal.send(
        new DeleteObjectCommand(this.resolve(location)),
        { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
      );
    } catch {
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async eraseObjectVersions(location: ObjectLocation): Promise<void> {
    const clients = this.requireClients();
    const { Bucket, Key } = this.resolve(location);
    try {
      let keyMarker: string | undefined;
      let versionMarker: string | undefined;
      do {
        const page = await clients.internal.send(
          new ListObjectVersionsCommand({
            Bucket,
            Prefix: Key,
            KeyMarker: keyMarker,
            VersionIdMarker: versionMarker,
          }),
          { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
        );
        const objects = [
          ...(page.Versions ?? []),
          ...(page.DeleteMarkers ?? []),
        ]
          .filter((entry) => entry.Key === Key && entry.VersionId)
          .map((entry) => ({ Key, VersionId: entry.VersionId }));
        if (objects.length > 0)
          await clients.internal.send(
            new DeleteObjectsCommand({
              Bucket,
              Delete: { Objects: objects, Quiet: true },
            }),
            { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
          );
        keyMarker = page.IsTruncated ? page.NextKeyMarker : undefined;
        versionMarker = page.IsTruncated ? page.NextVersionIdMarker : undefined;
      } while (keyMarker);
    } catch {
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async listKeys(
    bucket: ObjectStorageBucket,
    prefix: string,
  ): Promise<string[]> {
    const clients = this.requireClients();
    const { Bucket } = this.resolve({ bucket, key: 'x' });
    if (!prefix.endsWith('/') || !KEY_PATTERN.test(prefix.slice(0, -1)))
      throw new ValidationError('Prefix is invalid.');
    const keys: string[] = [];
    try {
      let token: string | undefined;
      do {
        const page = await clients.internal.send(
          new ListObjectsV2Command({
            Bucket,
            Prefix: prefix,
            ContinuationToken: token,
          }),
          { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
        );
        for (const entry of page.Contents ?? [])
          if (entry.Key) keys.push(entry.Key);
        token = page.IsTruncated ? page.NextContinuationToken : undefined;
      } while (token);
    } catch {
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
    return keys;
  }

  async downloadToFile(
    location: ObjectLocation,
    filePath: string,
  ): Promise<void> {
    const clients = this.requireClients();
    try {
      const result = await clients.internal.send(
        new GetObjectCommand(this.resolve(location)),
        { abortSignal: AbortSignal.timeout(TRANSFER_TIMEOUT_MS) },
      );
      if (!result.Body) throw new Error('Empty body');
      await pipeline(result.Body as Readable, createWriteStream(filePath));
    } catch (error) {
      if (
        error instanceof S3ServiceException &&
        error.$metadata.httpStatusCode === 404
      )
        throw new ConflictError('Stored object was not found.');
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async uploadFile(
    location: ObjectLocation,
    filePath: string,
    contentType: string,
  ): Promise<void> {
    const clients = this.requireClients();
    assertContentType(contentType);
    try {
      const { size } = await stat(filePath);
      await clients.internal.send(
        new PutObjectCommand({
          ...this.resolve(location),
          Body: createReadStream(filePath),
          ContentLength: size,
          ContentType: contentType,
        }),
        { abortSignal: AbortSignal.timeout(TRANSFER_TIMEOUT_MS) },
      );
    } catch {
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async createMultipartUpload(input: MultipartUploadInput): Promise<string> {
    const clients = this.requireClients();
    assertContentType(input.contentType);
    try {
      const result = await clients.internal.send(
        new CreateMultipartUploadCommand({
          ...this.resolve(input),
          ContentType: input.contentType,
        }),
        { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
      );
      if (!result.UploadId) throw new Error('Missing upload id');
      return result.UploadId;
    } catch {
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async createPartUploadUrls(
    input: PartUploadUrlsInput,
  ): Promise<PartUploadUrls> {
    const clients = this.requireClients();
    const expiresIn = presignTtl(
      input.expiresInSeconds,
      DEFAULT_PART_TTL_SECONDS,
    );
    const location = this.resolve(input);
    if (
      input.partNumbers.length === 0 ||
      input.partNumbers.length > MAX_PARTS_PER_SIGNING ||
      input.partNumbers.some(
        (n) => !Number.isInteger(n) || n < 1 || n > MAX_PART_NUMBER,
      )
    ) {
      throw new ValidationError('Part numbers are invalid.');
    }
    const parts = await Promise.all(
      input.partNumbers.map(async (partNumber) => ({
        partNumber,
        url: await this.sign(
          clients,
          new UploadPartCommand({
            ...location,
            UploadId: input.uploadId,
            PartNumber: partNumber,
          }),
          expiresIn,
        ),
      })),
    );
    return { parts, expiresAt: new Date(Date.now() + expiresIn * 1000) };
  }

  async completeMultipartUpload(input: CompleteMultipartInput): Promise<void> {
    const clients = this.requireClients();
    try {
      await clients.internal.send(
        new CompleteMultipartUploadCommand({
          ...this.resolve(input),
          UploadId: input.uploadId,
          MultipartUpload: {
            Parts: input.parts.map((part) => ({
              PartNumber: part.partNumber,
              ETag: part.etag,
            })),
          },
        }),
        { abortSignal: AbortSignal.timeout(30_000) },
      );
    } catch (error) {
      if (error instanceof S3ServiceException) {
        if (INVALID_PART_ERRORS.has(error.name)) {
          throw new ValidationError('Upload parts are invalid or incomplete.');
        }
        if (error.name === 'NoSuchUpload') {
          throw new ConflictError('Multipart upload no longer exists.');
        }
      }
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  async abortMultipartUpload(
    location: ObjectLocation,
    uploadId: string,
  ): Promise<void> {
    const clients = this.requireClients();
    try {
      await clients.internal.send(
        new AbortMultipartUploadCommand({
          ...this.resolve(location),
          UploadId: uploadId,
        }),
        { abortSignal: AbortSignal.timeout(REQUEST_TIMEOUT_MS) },
      );
    } catch (error) {
      if (error instanceof S3ServiceException && error.name === 'NoSuchUpload')
        return;
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }

  private requireClients(): S3Clients {
    if (!this.clients) {
      throw new ServiceUnavailableError('Object storage is not configured.');
    }
    return this.clients;
  }

  private resolve(location: ObjectLocation): { Bucket: string; Key: string } {
    const bucket = this.buckets[location.bucket];
    if (!bucket) throw new ValidationError('Unknown storage bucket.');
    if (
      !KEY_PATTERN.test(location.key) ||
      location.key.split('/').some((part) => part === '' || part === '..')
    ) {
      throw new ValidationError('Object key is invalid.');
    }
    return { Bucket: bucket, Key: location.key };
  }

  private async sign(
    clients: S3Clients,
    command: PutObjectCommand | GetObjectCommand | UploadPartCommand,
    expiresIn: number,
    signedHeaders: string[] = [],
  ): Promise<string> {
    try {
      // Signing is local (no network call), but keep SDK errors opaque to callers.
      // The SDK's generic signature cannot express a union of commands.
      const signable = command as Parameters<typeof getSignedUrl>[1];
      // Keep signed headers as headers: hoisting x-amz-* into the query would make
      // storage treat the header the client sends as unsigned.
      return await getSignedUrl(clients.public, signable, {
        expiresIn,
        signableHeaders: new Set(signedHeaders),
        unhoistableHeaders: new Set(signedHeaders),
      });
    } catch {
      throw new ServiceUnavailableError('Object storage is unavailable.');
    }
  }
}

function assertContentType(contentType: string): void {
  if (!CONTENT_TYPE_PATTERN.test(contentType)) {
    throw new ValidationError('Content type is invalid.');
  }
}

function presignTtl(value: number | undefined, fallback: number): number {
  const seconds = value ?? fallback;
  if (
    !Number.isSafeInteger(seconds) ||
    seconds < 1 ||
    seconds > MAX_PRESIGN_TTL_SECONDS
  ) {
    throw new ValidationError('Presigned URL expiry is out of range.');
  }
  return seconds;
}

/** RFC 6266 attachment header with an ASCII fallback and a UTF-8 filename*. */
function attachmentDisposition(fileName: string): string {
  const trimmed = fileName.trim().slice(0, 200);
  if (trimmed.length === 0) throw new ValidationError('File name is empty.');
  const ascii = trimmed.replace(/[^A-Za-z0-9._-]/g, '_');
  return `attachment; filename="${ascii}"; filename*=UTF-8''${encodeURIComponent(trimmed)}`;
}
