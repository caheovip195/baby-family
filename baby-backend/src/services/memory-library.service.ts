import { Inject, Injectable } from '@nestjs/common';
import { InjectThrottlerStorage } from '@nestjs/throttler';
import type { ThrottlerStorage } from '@nestjs/throttler';
import { z } from 'zod';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type { MediaAssetResponseDto } from '../dto/media/media-response.dto';
import { MEMORY_LIBRARY_POLICY } from '../config/memory-library-policy';
import type {
  LibraryQueryDto,
  OriginalDownloadResponse,
} from '../dto/memory-library/library-query.dto';
import type {
  MemoryResponseDto,
  MemoryFeedResponseDto,
} from '../dto/memory/memory-response.dto';
import { MEMORY_LIBRARY_REPOSITORY } from '../interfaces/repositories/memory-library-repository.interface';
import type {
  IMemoryLibraryRepository,
  LibraryCursor,
} from '../interfaces/repositories/memory-library-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../interfaces/services/memory-content-service.interface';
import type { IMemoryContentService } from '../interfaces/services/memory-content-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../interfaces/services/object-storage-service.interface';
import type { IMemoryLibraryService } from '../interfaces/services/memory-library-service.interface';

@Injectable()
export class MemoryLibraryService implements IMemoryLibraryService {
  constructor(
    @Inject(MEMORY_LIBRARY_REPOSITORY)
    private readonly repository: IMemoryLibraryRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_CONTENT_SERVICE)
    private readonly content: IMemoryContentService,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    @InjectThrottlerStorage() private readonly rateLimit: ThrottlerStorage,
  ) {}
  async requireFamily(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'download' = 'read',
  ): Promise<{ isParent: boolean }> {
    if (this.access.requireContentAccess) {
      const scope = await this.access.requireContentAccess(
        actor,
        familyId,
        mode,
      );
      return { isParent: scope.isParent };
    }
    // Compatibility for older injected access adapters; never grant Circle access.
    await this.access.requireParent(actor, familyId, mode);
    return { isParent: true };
  }
  async read(
    actor: AuthPrincipal,
    id: string,
    mode: 'read' | 'download' = 'read',
  ): Promise<MemoryResponseDto> {
    if (this.repository.findFamilyId) {
      const familyId = await this.repository.findFamilyId(id);
      if (!familyId) throw new NotFoundError('Memory was not found.');
      const membership = await this.repository.familyAccess(
        familyId,
        actor.userId,
      );
      if (membership?.isParent || membership?.circleActive)
        await this.requireFamily(actor, familyId, mode);
    }
    const row = await this.repository.find(id, actor.userId);
    if (!row) throw new NotFoundError('Memory was not found.');
    const scope = await this.requireFamily(actor, row.memory.familyId, mode);
    if (scope.isParent) return this.content.getById(actor, id);
    const m = row.memory;
    const sealed =
      m.kind === 'LETTER' &&
      !!m.unlockAt &&
      m.unlockAt > new Date() &&
      m.authorUserId !== actor.userId;
    const assets: MediaAssetResponseDto[] = [];
    for (const asset of row.assets) {
      const urls: Record<string, string> = {};
      let urlsExpireAt: Date | null = null;
      if (asset.status === 'READY') {
        for (const variant of row.variants.filter(
          (v) => v.assetId === asset.id && v.variantCode !== 'orig',
        )) {
          const bucket = this.storage.bucketOf(variant.storageBucket);
          if (bucket !== 'media') continue;
          const signed = await this.storage.createDownloadUrl({
            bucket,
            key: variant.storageKey,
            expiresInSeconds: MEMORY_LIBRARY_POLICY.downloadTtlSeconds,
          });
          urls[variant.variantCode] = signed.url;
          urlsExpireAt = signed.expiresAt;
        }
      }
      assets.push({
        assetId: asset.id,
        kind: asset.kind,
        purpose: asset.purpose,
        status: asset.status,
        width: asset.width,
        height: asset.height,
        durationMs: asset.durationMs,
        blurhash: asset.blurhash,
        urls,
        urlsExpireAt,
      });
    }
    return {
      id: m.id,
      familyId: m.familyId,
      kind: m.kind,
      status: m.status,
      version: m.version,
      authorUserId: m.authorUserId,
      authorRole: m.authorRole,
      title: m.title,
      body: sealed ? null : m.body,
      occurredAt: m.occurredAt.toISOString(),
      occurredLocalDate: m.occurredLocalDate.toISOString().slice(0, 10),
      visibility: m.visibility,
      familyMoment: m.familyMoment,
      childIds: row.childIds,
      pregnancyId: m.pregnancyId,
      pregnancyWeek: m.pregnancyWeek,
      feeling: m.feeling,
      locationLabel: m.locationLabel,
      quoteContext: sealed ? null : m.quoteContext,
      commentsEnabled: m.commentsEnabled,
      commentCount: m.commentCount,
      reactionCount: m.reactionCount,
      reactions: {},
      myReaction: null,
      perspectiveCount: row.perspectiveCount,
      sealed,
      unlockAt: m.unlockAt?.toISOString() ?? null,
      coverAssetId: row.coverAssetId,
      assets,
      createdAt: m.createdAt.toISOString(),
      publishedAt: m.publishedAt?.toISOString() ?? null,
      trashedAt: null,
      trashedBy: null,
      purgeAfter: null,
    };
  }
  async favorite(
    actor: AuthPrincipal,
    id: string,
    enabled: boolean,
  ): Promise<void> {
    const memory = await this.read(actor, id);
    const scope = await this.requireFamily(actor, memory.familyId);
    if (scope.isParent)
      await this.access.requireParent(actor, memory.familyId, 'write');
    await this.repository.setFavorite(
      actor.userId,
      id,
      memory.familyId,
      enabled,
    );
  }
  async favorites(
    actor: AuthPrincipal,
    familyId: string,
    query: LibraryQueryDto,
  ): Promise<MemoryFeedResponseDto> {
    await this.requireFamily(actor, familyId);
    const limit = query.limit ?? 20,
      cursor = query.cursor ? decodeCursor(query.cursor) : null;
    const rows = await this.repository.favorites(
      actor.userId,
      familyId,
      cursor,
      limit,
    );
    const page = rows.slice(0, limit),
      data: MemoryResponseDto[] = [];
    for (const r of page) {
      try {
        data.push(await this.read(actor, r.id));
      } catch (e) {
        if (!(e instanceof NotFoundError)) throw e;
      }
    }
    const last = page.at(-1);
    return {
      data,
      nextCursor:
        rows.length > limit && last
          ? Buffer.from(
              JSON.stringify({ t: last.createdAt.toISOString(), id: last.id }),
            ).toString('base64url')
          : null,
    };
  }
  async download(
    actor: AuthPrincipal,
    id: string,
  ): Promise<OriginalDownloadResponse> {
    await this.read(actor, id, 'download');
    // Re-read the live grant and links before issuing bearer URLs.
    const row = await this.repository.find(id, actor.userId);
    if (!row) throw new NotFoundError('Memory was not found.');
    if (!row.canDownload)
      throw new DomainError(
        'Original downloads are not allowed.',
        'MEMORY_DOWNLOAD_FORBIDDEN',
        403,
      );
    const policy = MEMORY_LIBRARY_POLICY;
    const hit = await this.rateLimit.increment(
      `memory-download:v${policy.version}:${actor.userId}`,
      policy.downloadWindowMs,
      policy.downloadsPerWindow,
      0,
      'memory-download',
    );
    if (hit.isBlocked || hit.totalHits > policy.downloadsPerWindow)
      throw new DomainError(
        'Too many download requests.',
        'MEMORY_DOWNLOAD_RATE_LIMITED',
        429,
      );
    const items: OriginalDownloadResponse['items'] = [];
    for (const [index, asset] of row.assets.entries()) {
      // Workers erase non-retained raw uploads after processing; never sign a missing original.
      const original = row.variants.find(
        (v) =>
          v.assetId === asset.id &&
          (v.variantCode === 'orig' ||
            (v.storageKey === asset.storageKey &&
              ['v1080', 'a'].includes(v.variantCode))),
      );
      if (asset.status !== 'READY' || !asset.keepOriginal || !original)
        continue;
      const bucket = this.storage.bucketOf(original.storageBucket);
      if (bucket !== 'media') continue;
      const ext: Record<string, string> = {
        'image/jpeg': 'jpg',
        'image/png': 'png',
        'image/heic': 'heic',
        'image/webp': 'webp',
        'video/mp4': 'mp4',
        'video/quicktime': 'mov',
        'audio/mp4': 'm4a',
        'audio/x-m4a': 'm4a',
        'audio/mpeg': 'mp3',
        'audio/aac': 'aac',
        'audio/wav': 'wav',
      };
      const fileName = `BabyFamily_${row.memory.occurredLocalDate.toISOString().slice(0, 10)}_${index + 1}.${ext[original.mime] ?? 'bin'}`;
      const signed = await this.storage.createDownloadUrl({
        bucket,
        key: original.storageKey,
        expiresInSeconds: policy.downloadTtlSeconds,
        downloadFileName: fileName,
      });
      items.push({
        assetId: asset.id,
        kind: asset.kind,
        url: signed.url,
        expiresAt: signed.expiresAt.toISOString(),
        fileName,
      });
    }
    await this.repository.auditDownload(actor.userId, row.memory.familyId, id);
    return { items };
  }
}
function decodeCursor(value: string): LibraryCursor {
  try {
    const parsed = z
      .object({ t: z.iso.datetime(), id: z.uuid() })
      .parse(
        JSON.parse(Buffer.from(value, 'base64url').toString('utf8')) as unknown,
      );
    return { createdAt: new Date(parsed.t), id: parsed.id };
  } catch {
    throw new ValidationError('Invalid favorites cursor.');
  }
}
