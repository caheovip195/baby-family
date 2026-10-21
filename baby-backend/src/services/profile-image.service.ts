import { createHash } from 'node:crypto';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { ConfigService } from '@nestjs/config';
import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ServiceUnavailableError,
} from '../common/errors/domain.error';
import { PermanentJobError } from '../common/errors/job.error';
import { MEDIA_POLICY, maxAcceptedSize } from '../config/media-policy';
import { PROFILE_IMAGE_POLICY as POLICY } from '../config/profile-image-policy';
import type { AvatarUploadIntentDto } from '../dto/user/avatar-upload.dto';
import {
  PROFILE_IMAGE_REPOSITORY,
  type IProfileImageRepository,
} from '../interfaces/repositories/profile-image-repository.interface';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import {
  IMAGE_PROCESSOR_SERVICE,
  type IImageProcessorService,
} from '../interfaces/services/image-processor-service.interface';
import {
  OBJECT_STORAGE_SERVICE,
  type IObjectStorageService,
} from '../interfaces/services/object-storage-service.interface';
import type { IProfileImageService } from '../interfaces/services/profile-image-service.interface';
import type { UserAsset } from '../models/user-asset.model';

@Injectable()
export class ProfileImageService implements IProfileImageService {
  constructor(
    @Inject(PROFILE_IMAGE_REPOSITORY)
    private readonly repository: IProfileImageRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    @Inject(IMAGE_PROCESSOR_SERVICE)
    private readonly images: IImageProcessorService,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Optional() private readonly config?: ConfigService,
  ) {}
  async createIntent(
    actor: AuthPrincipal,
    key: string,
    input: AvatarUploadIntentDto,
  ) {
    if (
      input.purpose !== 'AVATAR' ||
      !MEDIA_POLICY.kinds.IMAGE.mimes.includes(input.mime.toLowerCase())
    )
      throw new DomainError(
        'Unsupported avatar image.',
        'MEDIA_TYPE_UNSUPPORTED',
        422,
      );
    if (
      !Number.isSafeInteger(input.size) ||
      input.size < 1 ||
      input.size > POLICY.maxBytes
    )
      throw new DomainError('Avatar is too large.', 'MEDIA_TOO_LARGE', 422);
    const client = Array.isArray(input.variants);
    if (!client && !this.legacy())
      throw new DomainError(
        'Client variants are required.',
        'MEDIA_VARIANTS_REQUIRED',
        422,
      );
    if (
      client &&
      (!(MEDIA_POLICY.client.mainMimes.IMAGE as readonly string[]).includes(
        input.mime.toLowerCase(),
      ) ||
        Math.max(input.width ?? 0, input.height ?? 0) >
          MEDIA_POLICY.client.imageMaxEdge)
    )
      throw new DomainError(
        'Invalid client avatar image.',
        'MEDIA_VARIANT_INVALID',
        422,
      );
    const codes = input.variants?.map((v) => v.code) ?? [];
    if (
      client &&
      (MEDIA_POLICY.client.required.IMAGE.some(
        (code) => !codes.includes(code),
      ) ||
        new Set(codes).size !== codes.length)
    )
      throw new DomainError(
        'Avatar requires m1080 and t320 variants.',
        'MEDIA_VARIANTS_REQUIRED',
        422,
      );
    for (const variant of input.variants ?? []) {
      const limit =
        MEDIA_POLICY.client.variants[
          variant.code as keyof typeof MEDIA_POLICY.client.variants
        ];
      if (
        !(MEDIA_POLICY.client.allowed.IMAGE as readonly string[]).includes(
          variant.code,
        ) ||
        !limit ||
        !(MEDIA_POLICY.client.imageMimes as readonly string[]).includes(
          variant.mime,
        ) ||
        variant.size < 1 ||
        variant.size > Math.min(POLICY.maxBytes, limit.maxBytes) ||
        (variant.width ?? 0) > limit.maxEdge ||
        (variant.height ?? 0) > limit.maxEdge
      )
        throw new DomainError(
          'Invalid avatar variant.',
          'MEDIA_VARIANT_INVALID',
          422,
        );
    }
    this.requireStorage();
    // Owner-scoped deterministic UUID gives retries a durable request key.
    const hex = createHash('sha256')
      .update(`avatar:v1:${actor.userId}:${key}`)
      .digest('hex');
    const id = `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-a${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
    const asset = await this.repository.reserve({
      id,
      ownerUserId: actor.userId,
      mime: input.mime.toLowerCase(),
      declaredSize: BigInt(input.size),
      sha256: Buffer.from(input.sha256, 'hex'),
      storageBucket: this.storage.bucketName('userMedia'),
      storageKey: `usr/${actor.userId}/avatar/${id}/raw`,
      purgeAfter: new Date(Date.now() + POLICY.reservationTtlMs),
      variants: client
        ? [
            {
              code: 'orig',
              mime: input.mime.toLowerCase(),
              size: input.size,
              sha256: input.sha256,
              width: input.width,
              height: input.height,
            },
            ...input.variants!,
          ].map((v) => ({
            variantCode: v.code,
            storageBucket: this.storage.bucketName('userMedia'),
            storageKey: `usr/${actor.userId}/avatar/${id}/${v.code === 'orig' ? 'raw' : v.code}`,
            mime: v.mime,
            sizeBytes: BigInt(v.size),
            checksumSha256: Buffer.from(v.sha256, 'hex'),
            width: v.width ?? null,
            height: v.height ?? null,
          }))
        : [],
    });
    if (asset.status !== 'PENDING_UPLOAD' || this.expired(asset))
      return { assetId: id, status: asset.status };
    const signed = await this.storage.createUploadUrl({
      ...this.location(asset),
      contentType: asset.mime,
      sha256Base64: Buffer.from(asset.sha256!).toString('base64'),
      expiresInSeconds: Math.max(
        1,
        Math.min(
          POLICY.uploadTtlSeconds,
          Math.floor((asset.purgeAfter!.getTime() - Date.now()) / 1000),
        ),
      ),
    });
    return {
      assetId: id,
      status: asset.status,
      variantUploads: client
        ? await Promise.all(
            (input.variants ?? []).map(async (v) => {
              const upload = await this.storage.createUploadUrl({
                bucket: this.location(asset).bucket,
                key: `usr/${actor.userId}/avatar/${id}/${v.code}`,
                contentType: v.mime,
                sha256Base64: Buffer.from(v.sha256, 'hex').toString('base64'),
                expiresInSeconds: Math.max(
                  1,
                  Math.min(
                    POLICY.uploadTtlSeconds,
                    Math.floor(
                      (asset.purgeAfter!.getTime() - Date.now()) / 1000,
                    ),
                  ),
                ),
              });
              return {
                code: v.code,
                upload: {
                  ...upload,
                  mode: 'single' as const,
                  method: 'PUT' as const,
                },
              };
            }),
          )
        : undefined,
      upload: {
        mode: 'single' as const,
        method: 'PUT' as const,
        url: signed.url,
        headers: signed.headers,
        expiresAt: signed.expiresAt,
      },
    };
  }
  async complete(actor: AuthPrincipal, assetId: string) {
    const asset = await this.repository.ownAsset(actor.userId, assetId);
    if (!asset) throw new NotFoundError('Avatar upload was not found.');
    this.requireStorage();
    const location = this.location(asset);
    const variants = await this.repository.variants(actor.userId, assetId);
    const client = variants.length > 0;
    if (asset.status === 'READY') {
      if (!client) await this.storage.eraseObjectVersions(location);
      return { assetId, status: 'READY' };
    }
    if (
      !['PENDING_UPLOAD', 'PROCESSING'].includes(asset.status) ||
      this.expired(asset)
    )
      throw new DomainError(
        'Upload window has expired.',
        'UPLOAD_EXPIRED',
        409,
      );
    if (!client && !this.legacy())
      throw new DomainError(
        'Client variants are required.',
        'MEDIA_VARIANTS_REQUIRED',
        422,
      );
    if (client) {
      let total = 0n;
      const verifiedVariants: { code: string; size: bigint }[] = [];
      for (const variant of variants) {
        const head = await this.storage.headObject({
          ...location,
          key: variant.storageKey,
        });
        const tolerance =
          maxAcceptedSize(variant.sizeBytes) - variant.sizeBytes;
        const difference = head ? BigInt(head.size) - variant.sizeBytes : 0n;
        const code = !head
          ? 'UPLOAD_VARIANT_MISSING'
          : head.size < 1 || difference > tolerance || difference < -tolerance
            ? 'UPLOAD_VARIANT_SIZE_MISMATCH'
            : head.contentType?.split(';')[0]?.trim().toLowerCase() !==
                variant.mime
              ? 'UPLOAD_VARIANT_METADATA_MISMATCH'
              : null;
        if (code) {
          await this.repository.fail(actor.userId, assetId);
          for (const v of variants)
            await this.storage.eraseObjectVersions({
              ...location,
              key: v.storageKey,
            });
          throw new DomainError(
            'Uploaded avatar variant differs from intent.',
            code,
            422,
          );
        }
        total += BigInt(head!.size);
        verifiedVariants.push({
          code: variant.variantCode,
          size: BigInt(head!.size),
        });
      }
      await this.repository.ready(
        actor.userId,
        assetId,
        total,
        verifiedVariants,
      );
      return { assetId, status: 'READY' };
    }
    const head = await this.storage.headObject(location);
    if (!head)
      throw new DomainError(
        'Uploaded file was not found.',
        'UPLOAD_NOT_FOUND',
        409,
      );
    if (
      head.size < 1 ||
      BigInt(head.size) > maxAcceptedSize(asset.declaredSize) ||
      head.size > POLICY.maxBytes ||
      head.contentType?.split(';')[0]?.trim().toLowerCase() !== asset.mime
    )
      throw new DomainError(
        'Upload size or type differs from intent.',
        'UPLOAD_METADATA_MISMATCH',
        422,
      );
    await this.repository.startProcessing(actor.userId, assetId);
    const workDir = await mkdtemp(path.join(tmpdir(), 'bf-avatar-'));
    try {
      const input = path.join(workDir, 'input');
      await this.storage.downloadToFile(location, input);
      const bytes = await readFile(input);
      if (
        bytes.length !== head.size ||
        !asset.sha256 ||
        !createHash('sha256')
          .update(bytes)
          .digest()
          .equals(Buffer.from(asset.sha256))
      )
        throw new DomainError(
          'Upload checksum differs from intent.',
          'UPLOAD_CHECKSUM_MISMATCH',
          422,
        );
      let processed;
      try {
        processed = await this.images.process(input, {
          keepOriginal: false,
          workDir,
        });
      } catch (error) {
        if (error instanceof PermanentJobError)
          throw new DomainError(
            'Avatar image cannot be decoded.',
            'AVATAR_IMAGE_INVALID',
            422,
          );
        throw error;
      }
      const thumbnail = processed.variants.find((v) => v.code === 't320');
      if (!thumbnail)
        throw new ServiceUnavailableError('Avatar processing is unavailable.');
      await this.storage.uploadFile(
        { ...location, key: this.readyKey(asset) },
        thumbnail.path,
        thumbnail.mime,
      );
      await this.repository.ready(
        actor.userId,
        assetId,
        BigInt(thumbnail.sizeBytes),
      );
      // Commit first so a crash remains recoverable by an idempotent complete retry.
      await this.storage.eraseObjectVersions(location);
      return { assetId, status: 'READY' };
    } finally {
      await rm(workDir, { recursive: true, force: true });
    }
  }
  attach(
    actor: AuthPrincipal,
    assetId: string | null,
    fields?: Parameters<IProfileImageService['attach']>[2],
  ) {
    return this.repository.attach(actor.userId, assetId, fields);
  }
  async userAvatar(userId: string) {
    const asset = await this.repository.avatar(userId);
    if (!asset) return { avatarUrl: null, avatarUrlExpiresAt: null };
    const variants = await this.repository.variants(userId, asset.id);
    const thumbnail = variants.find((v) => v.variantCode === 't320');
    const signed = await this.sign(
      thumbnail ?? {
        storageBucket: asset.storageBucket,
        storageKey: this.readyKey(asset),
      },
    );
    return {
      avatarUrl: signed?.url ?? null,
      avatarUrlExpiresAt: signed?.expiresAt ?? null,
    };
  }
  /** Caller has already checked access to the family. */
  async familyCover(familyId: string) {
    const cover = await this.sign(
      await this.repository.familyCoverLocation(familyId),
    );
    return {
      coverUrl: cover?.url ?? null,
      coverUrlExpiresAt: cover?.expiresAt ?? null,
    };
  }

  isUsableFamilyCover(familyId: string, assetId: string) {
    return this.repository.isUsableFamilyCover(familyId, assetId);
  }

  async childImages(actor: AuthPrincipal, familyId: string, childId: string) {
    const empty = {
      avatarUrl: null,
      avatarUrlExpiresAt: null,
      coverUrl: null,
      coverUrlExpiresAt: null,
    };
    // Parent bootstrap remains available in metadata/read-only phases. Circle needs live content access.
    try {
      await this.access.requireParent(actor, familyId, 'metadata');
    } catch (error) {
      if (!(error instanceof NotFoundError)) throw error;
      if (!this.access.requireContentAccess) return empty;
      await this.access.requireContentAccess(actor, familyId, 'read');
    }
    const locations = await this.repository.childLocations(
      actor.userId,
      familyId,
      childId,
    );
    if (!locations) return empty;
    const avatar = await this.sign(locations.avatar),
      cover = await this.sign(locations.cover);
    return {
      avatarUrl: avatar?.url ?? null,
      avatarUrlExpiresAt: avatar?.expiresAt ?? null,
      coverUrl: cover?.url ?? null,
      coverUrlExpiresAt: cover?.expiresAt ?? null,
    };
  }
  private async sign(
    location: { storageBucket: string; storageKey: string } | null,
  ) {
    if (!location || !this.storage.isConfigured()) return null;
    const bucket = this.storage.bucketOf(location.storageBucket);
    if (!bucket) return null;
    return this.storage.createDownloadUrl({
      bucket,
      key: location.storageKey,
      expiresInSeconds: MEDIA_POLICY.viewUrlTtlSeconds,
    });
  }
  private legacy() {
    return this.config?.get<string>('MEDIA_SERVER_PROCESSING') === 'legacy';
  }
  private readyKey(asset: UserAsset) {
    return `${asset.storageKey}/avatar.webp`;
  }
  private expired(asset: UserAsset) {
    return !asset.purgeAfter || asset.purgeAfter.getTime() <= Date.now();
  }
  private location(asset: UserAsset) {
    const bucket = this.storage.bucketOf(asset.storageBucket);
    if (!bucket)
      throw new ServiceUnavailableError('Storage bucket is not configured.');
    return { bucket, key: asset.storageKey };
  }
  private requireStorage() {
    if (!this.storage.isConfigured())
      throw new ServiceUnavailableError('Object storage is not configured.');
  }
}
