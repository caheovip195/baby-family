import { completedPhotoMonths } from '../common/time/monthly-photo-age';
import {
  TIMELINE_CARD_REPOSITORY,
  type ITimelineCardRepository,
} from '../interfaces/repositories/timeline-card-repository.interface';
import {
  MEMORY_LIBRARY_REPOSITORY,
  type IMemoryLibraryRepository,
} from '../interfaces/repositories/memory-library-repository.interface';
import {
  OBJECT_STORAGE_SERVICE,
  type IObjectStorageService,
} from '../interfaces/services/object-storage-service.interface';
import { MEMORY_LIBRARY_POLICY } from '../config/memory-library-policy';
import type { TimelineQueryDto } from '../dto/memory/timeline-query.dto';
import type {
  TimelineResponseDto,
  TimelineSystemItemDto,
  TimelineRecapItemDto,
} from '../dto/memory/timeline-response.dto';
import type { MediaGridQueryDto } from '../dto/memory/media-grid-query.dto';
import type { MediaGridResponseDto } from '../dto/memory/media-grid-response.dto';
import type { OccurredCursor } from '../interfaces/repositories/memory-content-repository.interface';
import type { TimelineChildContext } from '../models/memory-view.model';
import { createHash } from 'node:crypto';
import { Inject, Injectable, Optional } from '@nestjs/common';
import { z } from 'zod';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import type { MemoryKind, Visibility } from '../common/database.enums';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { MEDIA_POLICY } from '../config/media-policy';
import { MEMORY_POLICY } from '../config/memory-policy';
import type { CreateMemoryDto } from '../dto/memory/create-memory.dto';
import type { MemoryFeedQueryDto } from '../dto/memory/memory-feed-query.dto';
import type {
  MemorySearchQueryDto,
  OnThisDayQueryDto,
  OnThisDayResponseDto,
  TodayStoryQueryDto,
  TodayStoryResponseDto,
} from '../dto/memory/memory-search-query.dto';
import type { MemoryTrashQueryDto } from '../dto/memory/memory-trash-query.dto';
import type { UpdateMemoryDto } from '../dto/memory/update-memory.dto';
import type {
  MemoryFeedResponseDto,
  MemoryResponseDto,
} from '../dto/memory/memory-response.dto';
import type { MediaAssetResponseDto } from '../dto/media/media-response.dto';
import { MEMORY_CONTENT_REPOSITORY } from '../interfaces/repositories/memory-content-repository.interface';
import type {
  IMemoryContentRepository,
  MemoryFeedCursor,
} from '../interfaces/repositories/memory-content-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEDIA_SERVICE } from '../interfaces/services/media-service.interface';
import type {
  IMediaService,
  MediaViewAccess,
} from '../interfaces/services/media-service.interface';
import type { IMemoryContentService } from '../interfaces/services/memory-content-service.interface';
import type {
  MemoryCreationContext,
  MemoryView,
} from '../models/memory-view.model';

const planSchema = z.object({
  quotas: z.looseObject({
    photosPerMemory: z.number().int().nonnegative(),
    // Catalog semantic: an absent quota key means the plan sets no limit.
    memoryCount: z.number().int().nonnegative().optional(),
  }),
  features: z.record(z.string(), z.unknown()),
});
/** Fields the Parent who is not the author may change (spec §6.2). */
const PARTNER_EDITABLE_FIELDS: readonly (keyof UpdateMemoryDto)[] = [
  'childIds',
  'familyMoment',
  'pregnancyId',
  'visibility',
];
const cursorSchema = z.object({ c: z.iso.datetime(), i: z.uuid() });
const DAY_MS = 24 * 60 * 60 * 1000;
const IDEMPOTENCY_TTL_MS = DAY_MS;

@Injectable()
export class MemoryContentService implements IMemoryContentService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_CONTENT_REPOSITORY)
    private readonly repository: IMemoryContentRepository,
    @Inject(MEDIA_SERVICE) private readonly media: IMediaService,
    @Optional()
    @Inject(MEMORY_LIBRARY_REPOSITORY)
    private readonly library?: IMemoryLibraryRepository,
    @Optional()
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage?: IObjectStorageService,
    @Optional()
    @Inject(TIMELINE_CARD_REPOSITORY)
    private readonly timelineCards?: ITimelineCardRepository,
  ) {}

  async create(
    actor: AuthPrincipal,
    idempotencyKey: string,
    input: CreateMemoryDto,
  ): Promise<MemoryResponseDto> {
    // Membership, ACTIVE family and an unexpired entitlement (402/403/404).
    const scope = await this.contentAccess(actor, input.familyId, 'write');
    if (!scope.isParent) {
      if (input.kind !== 'MOMENT')
        throw memoryError(
          'Circle may only post moments.',
          'MEMORY_KIND_NOT_ALLOWED',
        );
      if (input.visibility !== 'FAMILY' || input.familyMoment || input.status)
        throw memoryError(
          'Circle moments must be shared with granted subjects.',
          'MEMORY_VISIBILITY_INVALID',
        );
      const grants = await this.repository.contributionSubjects(
        input.familyId,
        actor.userId,
      );
      if (
        !(input.childIds?.length || input.pregnancyId) ||
        input.childIds?.some((id) => !grants.childIds.includes(id)) ||
        (input.pregnancyId && !grants.pregnancyIds.includes(input.pregnancyId))
      )
        throw new DomainError(
          'Contribution grant is required.',
          'CIRCLE_CONTRIBUTE_REQUIRED',
          403,
        );
    }
    const requestHash = hashRequest(input);
    const replay = await this.repository.findReplay(
      actor.userId,
      idempotencyKey,
      requestHash,
    );
    if (replay)
      return scope.isParent
        ? this.projectOne(actor, replay)
        : this.getById(actor, replay.memory.id);

    const assetIds = input.assetIds ?? [];
    const childIds = input.childIds ?? [];
    const pregnancyId = input.pregnancyId ?? null;
    const familyMoment = input.familyMoment ?? false;
    const title = blankToNull(input.title);
    const body = blankToNull(input.body);
    const occurredAt = new Date(input.occurredAt);
    if (occurredAt.getTime() > Date.now() + MEMORY_POLICY.futureSkewMs)
      throw memoryError('occurredAt is in the future.', 'MEMORY_DATE_INVALID');

    const context = await this.repository.findCreationContext(
      input.familyId,
      actor.userId,
      {
        childIds,
        pregnancyId,
        assetIds,
      },
    );
    if (!context) throw new NotFoundError('Family was not found.');
    const plan = planSchema.safeParse({
      quotas: context.quotas,
      features: context.features,
    });
    // Unknown or malformed plan data fails closed (extensibility standards).
    if (!plan.success)
      throw new DomainError(
        'The family plan does not allow memories.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );

    if (!scope.isParent && plan.data.features['circle.enabled'] !== true)
      throw new DomainError('Circle sharing is paused.', 'CIRCLE_PAUSED', 403);
    if (input.status !== 'DRAFT')
      this.assertContent(input.kind, assetIds.length, childIds, title, body);
    if ((input.kind === 'MILESTONE') !== (input.milestone !== undefined))
      throw memoryError(
        'MILESTONE requires milestone details.',
        'MILESTONE_INVALID',
      );
    if ((input.kind === 'LETTER') !== (input.letter !== undefined))
      throw memoryError('LETTER requires letter details.', 'LETTER_INVALID');
    if (input.milestone) {
      const m = input.milestone;
      if (
        Number(Boolean(m.templateCode)) +
          Number(Boolean(m.customTitle?.trim())) !==
          1 ||
        childIds.length + Number(Boolean(pregnancyId)) !== 1 ||
        familyMoment
      )
        throw memoryError(
          'Choose one subject and a template or custom title.',
          'MILESTONE_INVALID',
        );
      if (
        !/^\d{4}-\d{2}-\d{2}$/.test(m.occurredOn) ||
        new Date(m.occurredOn).getTime() >
          Date.now() + MEMORY_POLICY.futureSkewMs
      )
        throw memoryError('Invalid milestone date.', 'MILESTONE_DATE_INVALID');
    }
    let unlockAt: Date | null = null;
    if (input.letter) {
      const letter = input.letter;
      if (
        childIds.length !== 1 ||
        childIds[0] !== letter.childId ||
        pregnancyId ||
        familyMoment
      )
        throw memoryError(
          'A letter belongs to its child.',
          'LETTER_CHILD_INVALID',
        );
      if (letter.releaseRule === 'DATE') {
        if (!letter.unlockAt || letter.birthdayNumber !== undefined)
          throw memoryError(
            'DATE requires unlockAt only.',
            'LETTER_RELEASE_INVALID',
          );
        unlockAt = new Date(letter.unlockAt);
      } else {
        const child = context.children.find(
          (c) => c.id === letter.childId && c.active,
        );
        if (!child || !letter.birthdayNumber || letter.unlockAt !== undefined)
          throw memoryError(
            'Birthday rule requires birthdayNumber only.',
            'LETTER_RELEASE_INVALID',
          );
        const birth = child.birthDate;
        const year = birth.getUTCFullYear() + letter.birthdayNumber;
        const day = Math.min(
          birth.getUTCDate(),
          new Date(Date.UTC(year, birth.getUTCMonth() + 1, 0)).getUTCDate(),
        );
        unlockAt = midnightInTimezone(
          year,
          birth.getUTCMonth() + 1,
          day,
          context.timezone,
        );
      }
      if (
        !Number.isFinite(unlockAt.getTime()) ||
        unlockAt.getTime() <= Date.now()
      )
        throw memoryError(
          'Letter release must be in the future.',
          'LETTER_RELEASE_INVALID',
        );
    }
    if (assetIds.length > plan.data.quotas.photosPerMemory)
      throw new DomainError(
        'Too many photos for one memory on this plan.',
        'QUOTA_PHOTOS_PER_MEMORY',
        402,
      );
    this.assertAssets(actor, context, assetIds);
    if (
      !scope.isParent &&
      context.assets.some((a) => a.uploaderUserId !== actor.userId)
    )
      throw memoryError(
        'Circle must use its own uploads.',
        'MEMORY_ASSET_INVALID',
      );
    this.assertSubjects(context, childIds, pregnancyId, familyMoment);
    const cover = input.coverAssetId ?? assetIds[0] ?? null;
    if (cover !== null && !assetIds.includes(cover))
      throw memoryError(
        'coverAssetId must be one of assetIds.',
        'MEMORY_COVER_INVALID',
      );

    const localDate = localDateIn(occurredAt, context.timezone);
    const view = await this.repository.create({
      authorRole: scope.isParent ? 'PARENT' : 'CIRCLE',
      status:
        !scope.isParent &&
        !(
          typeof scope.family.settings === 'object' &&
          scope.family.settings !== null &&
          !Array.isArray(scope.family.settings) &&
          scope.family.settings.requireCircleReview === false
        )
          ? 'PENDING_REVIEW'
          : input.status,
      milestone: input.milestone,
      letter: input.letter
        ? {
            ...input.letter,
            releaseVisibility: this.effectiveVisibility(
              input.letter.releaseVisibility,
              plan.data.features,
            ),
          }
        : undefined,
      unlockAt,
      familyId: input.familyId,
      authorUserId: actor.userId,
      idempotencyKey,
      requestHash,
      kind: input.kind,
      title,
      body,
      occurredAt,
      occurredLocalDate: localDate,
      // Spec §11.5 (4): without Circle sharing, FAMILY means both parents.
      visibility: input.letter
        ? 'PRIVATE'
        : this.effectiveVisibility(input.visibility, plan.data.features),
      familyMoment,
      pregnancyId,
      pregnancyWeek: pregnancyWeek(
        context.pregnancy?.dueDate ?? null,
        localDate,
      ),
      feeling: input.feeling ?? null,
      locationLabel: blankToNull(input.locationLabel),
      quoteContext:
        input.kind === 'QUOTE' ? blankToNull(input.quoteContext) : null,
      commentsEnabled: input.commentsEnabled ?? true,
      children: childIds.map((childId) => ({
        childId,
        ageMonth: ageInMonths(
          context.children.find((child) => child.id === childId)!.birthDate,
          localDate,
        ),
      })),
      assets: assetIds.map((assetId, sortOrder) => ({
        assetId,
        sortOrder,
        isCover: assetId === cover,
      })),
      memoryQuota: plan.data.quotas.memoryCount ?? null,
      idempotencyExpiresAt: new Date(Date.now() + IDEMPOTENCY_TTL_MS),
    });
    return this.projectOne(actor, view);
  }

  async drafts(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<MemoryFeedResponseDto> {
    await this.access.requireParent(actor, familyId, 'download');
    return {
      data: await this.project(
        actor,
        await this.repository.listDrafts(familyId, actor.userId),
        'download',
      ),
      nextCursor: null,
    };
  }

  async publish(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<MemoryResponseDto> {
    const familyId = await this.repository.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, familyId, 'write');
    const view = await this.repository.findVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!view || view.memory.authorUserId !== actor.userId)
      throw new NotFoundError('Memory was not found.');
    if (view.memory.status !== 'DRAFT') return this.projectOne(actor, view);
    const context = await this.repository.findCreationContext(
      familyId,
      actor.userId,
      {
        childIds: view.childIds,
        pregnancyId: view.memory.pregnancyId,
        assetIds: view.assets.map((a) => a.assetId),
      },
    );
    if (!context) throw new NotFoundError('Family was not found.');
    const plan = await this.planOf(familyId, actor.userId);
    this.assertContent(
      view.memory.kind,
      view.assets.length,
      view.childIds,
      view.memory.title,
      view.memory.body,
    );
    this.assertSubjects(
      context,
      view.childIds,
      view.memory.pregnancyId,
      view.memory.familyMoment,
    );
    this.assertAssets(
      actor,
      context,
      view.assets.map((a) => a.assetId),
    );
    if (view.assets.length > plan.quotas.photosPerMemory)
      throw new DomainError('Too many photos.', 'QUOTA_PHOTOS_PER_MEMORY', 402);
    if (
      view.memory.occurredAt.getTime() >
      Date.now() + MEMORY_POLICY.futureSkewMs
    )
      throw memoryError('Invalid memory date.', 'MEMORY_DATE_INVALID');
    return this.projectOne(
      actor,
      await this.repository.publish(
        familyId,
        actor.userId,
        memoryId,
        view.memory.version,
      ),
    );
  }

  async getById(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<MemoryResponseDto> {
    const familyId = await this.repository.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    // Spec §6.5: still readable after the subscription expired (data download).
    await this.contentAccess(actor, familyId, 'download');
    const view = await this.repository.findVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    // Hidden and missing look the same (spec §6.4 invariant 1).
    if (!view) throw new NotFoundError('Memory was not found.');
    return this.projectOne(actor, view, 'download');
  }

  async feed(
    actor: AuthPrincipal,
    familyId: string,
    query: MemoryFeedQueryDto,
  ): Promise<MemoryFeedResponseDto> {
    await this.contentAccess(actor, familyId, 'read');
    const limit = query.limit ?? MEMORY_POLICY.feedDefaultLimit;
    const rows = await this.repository.listFeedForParent(
      familyId,
      actor.userId,
      {
        childId: query.childId,
        pregnancyId: query.pregnancyId,
        after: query.cursor ? decodeCursor(query.cursor) : null,
        limit,
      },
    );
    const page = rows.slice(0, limit);
    const last = page.at(-1);
    return {
      data: await this.project(actor, page),
      nextCursor:
        rows.length > limit && last
          ? encodeCursor({
              createdAt: last.memory.createdAt,
              id: last.memory.id,
            })
          : null,
    };
  }

  /**
   * MEM-15: prefix full-text match (unaccent, case-insensitive), then the same
   * ACL/exclusions as the feed before paging — matches the viewer cannot see
   * never count.
   */
  async search(
    actor: AuthPrincipal,
    familyId: string,
    query: MemorySearchQueryDto,
  ): Promise<MemoryFeedResponseDto> {
    await this.contentAccess(actor, familyId, 'read');
    const words = query.q
      .toLowerCase()
      .split(/[^\p{L}\p{N}]+/u)
      .filter((word) => word.length > 0)
      .slice(0, MEMORY_POLICY.searchMaxWords);
    const ids = await this.repository.searchMatchIds(
      familyId,
      words,
      MEMORY_POLICY.searchMatchCap,
    );
    if (!ids.length) return { data: [], nextCursor: null };
    const limit = query.limit ?? MEMORY_POLICY.feedDefaultLimit;
    const rows = await this.repository.listFeedForParent(
      familyId,
      actor.userId,
      {
        childId: query.childId,
        kind: query.kind,
        ids,
        after: query.cursor ? decodeCursor(query.cursor) : null,
        limit,
      },
    );
    const page = rows.slice(0, limit);
    const last = page.at(-1);
    return {
      data: await this.project(actor, page),
      nextCursor:
        rows.length > limit && last
          ? encodeCursor({
              createdAt: last.memory.createdAt,
              id: last.memory.id,
            })
          : null,
    };
  }

  /**
   * MEM-16: same day/month (family-local date) in earlier years, grouped by
   * years ago, newest year first; same ACL/exclusions as the feed.
   */
  async onThisDay(
    actor: AuthPrincipal,
    familyId: string,
    query: OnThisDayQueryDto,
  ): Promise<OnThisDayResponseDto> {
    await this.contentAccess(actor, familyId, 'read');
    const day =
      query.date ??
      new Intl.DateTimeFormat('en-CA', {
        timeZone:
          (await this.repository.familyTimezone(familyId)) ??
          'Asia/Ho_Chi_Minh',
      }).format(new Date());
    const ids = await this.repository.onThisDayIds(
      familyId,
      day,
      MEMORY_POLICY.onThisDayCap,
    );
    if (!ids.length) return { date: day, groups: [] };
    const rows = await this.repository.listFeedForParent(
      familyId,
      actor.userId,
      { ids, after: null, limit: MEMORY_POLICY.onThisDayCap },
    );
    const year = Number(day.slice(0, 4));
    const byYear = new Map<number, MemoryView[]>();
    for (const view of rows) {
      const at = view.memory.occurredLocalDate.getUTCFullYear();
      byYear.set(at, [...(byYear.get(at) ?? []), view]);
    }
    const groups: OnThisDayResponseDto['groups'] = [];
    for (const at of [...byYear.keys()].sort((a, b) => b - a)) {
      const views = byYear
        .get(at)!
        .sort(
          (a, b) =>
            b.memory.occurredAt.getTime() - a.memory.occurredAt.getTime(),
        );
      groups.push({
        yearsAgo: year - at,
        date: `${at}${day.slice(4)}`,
        memories: await this.project(actor, views),
      });
    }
    return { date: day, groups };
  }

  /**
   * MEM-25 “Hôm nay của bé”: a child's memories of one family-local day as
   * slides (each image/video asset), same ACL/exclusions as the feed.
   */
  async todayStory(
    actor: AuthPrincipal,
    childId: string,
    query: TodayStoryQueryDto,
  ): Promise<TodayStoryResponseDto> {
    const familyId = await this.repository.findChildFamilyId(childId);
    if (!familyId) throw new NotFoundError('Child was not found.');
    await this.contentAccess(actor, familyId, 'read');
    const day =
      query.date ??
      new Intl.DateTimeFormat('en-CA', {
        timeZone:
          (await this.repository.familyTimezone(familyId)) ??
          'Asia/Ho_Chi_Minh',
      }).format(new Date());
    const ids = await this.repository.childDayIds(
      familyId,
      childId,
      day,
      MEMORY_POLICY.todayStoryCap,
    );
    const rows = ids.length
      ? await this.repository.listFeedForParent(familyId, actor.userId, {
          ids,
          after: null,
          limit: MEMORY_POLICY.todayStoryCap,
        })
      : [];
    const memories = (await this.project(actor, rows)).sort(
      (a, b) =>
        new Date(a.occurredAt).getTime() - new Date(b.occurredAt).getTime(),
    );
    const slides: TodayStoryResponseDto['slides'] = [];
    for (const memory of memories)
      for (const asset of memory.assets) {
        const urls = asset.urls;
        const imageUrl =
          asset.kind === 'VIDEO'
            ? (urls.poster ?? urls.t320)
            : (urls.m1080 ?? urls.l2048 ?? urls.t320);
        if (!imageUrl || (asset.kind !== 'IMAGE' && asset.kind !== 'VIDEO'))
          continue;
        slides.push({
          memoryId: memory.id,
          kind: asset.kind,
          imageUrl,
          videoUrl: asset.kind === 'VIDEO' ? (urls.v1080 ?? null) : null,
          caption: memory.title ?? memory.body ?? null,
          occurredAt: memory.occurredAt,
        });
      }
    return { date: day, childId, memoryCount: memories.length, slides };
  }

  async timeline(
    actor: AuthPrincipal,
    familyId: string,
    query: TimelineQueryDto,
  ): Promise<TimelineResponseDto> {
    await this.contentAccess(actor, familyId, 'read');
    if (query.childId || query.pregnancyId) {
      const subjects = await this.repository.readableSubjects(
        familyId,
        actor.userId,
      );
      if (
        !subjects.isParent &&
        ((query.childId && !subjects.childIds.includes(query.childId)) ||
          (query.pregnancyId &&
            !subjects.pregnancyIds.includes(query.pregnancyId)))
      )
        throw new NotFoundError('Subject was not found.');
    }
    const limit = query.limit ?? MEMORY_POLICY.timelineDefaultLimit;
    const after = query.cursor
      ? decodeOccurredCursor(query.cursor, 'timeline')
      : null;
    const child = query.childId
      ? await this.repository.findTimelineChild(familyId, query.childId)
      : null;
    if (query.childId && !child)
      throw new NotFoundError('Child was not found.');
    const rows = await this.repository.listTimelineForParent(
      familyId,
      actor.userId,
      {
        childId: query.childId,
        pregnancyId: query.pregnancyId,
        filter: query.filter ?? 'ALL',
        after,
        limit,
      },
    );
    const page = rows.slice(0, limit);
    const last = page.at(-1);
    const hasMore = rows.length > limit;
    const projected = await this.project(actor, page);
    // Half-open intervals [last memory, previous cursor) give every virtual
    // card exactly one page, including when memories tie at midnight. limit
    // counts memories only; the final page extends back through the birth.
    const lower =
      hasMore && last ? last.memory.occurredAt.getTime() : -Infinity;
    const upper = after?.occurredAt.getTime() ?? Infinity;
    const cards: {
      instant: Date;
      item: TimelineSystemItemDto | TimelineRecapItemDto;
    }[] = child ? timelineSystemCards(child, new Date()) : [];
    if (this.timelineCards && !query.pregnancyId) {
      if (child) {
        const [covers, counts] = await Promise.all([
          this.timelineCards.monthlyCovers(
            familyId,
            actor.userId,
            child.childId,
          ),
          this.timelineCards.monthCounts(familyId, actor.userId, child.childId),
        ]);
        const coverByMonth = new Map(
          covers
            .filter(
              (cover) =>
                completedPhotoMonths(
                  cover.birthDate,
                  cover.occurredLocalDate,
                  cover.monthlyPhotoLunar,
                ) === cover.monthIndex,
            )
            .map((cover) => [cover.monthIndex, cover]),
        );
        const countsByMonth = new Map(
          counts.map((count) => [count.monthIndex, count]),
        );
        const chapters = timelineSystemCards(child, new Date()).filter(
          (card) =>
            card.instant.getTime() >= lower && card.instant.getTime() < upper,
        );
        const signed = new Map<string, MediaAssetResponseDto>();
        const visibleCovers = chapters.flatMap((card) => {
          const cover = coverByMonth.get(card.item.monthIndex ?? 0);
          return cover ? [cover] : [];
        });
        for (
          let start = 0;
          start < visibleCovers.length;
          start += MEDIA_POLICY.maxBatchAssets
        ) {
          const batch = visibleCovers.slice(
            start,
            start + MEDIA_POLICY.maxBatchAssets,
          );
          const result = await this.signAssets(
            actor,
            batch.map((cover) => cover.assetId),
            'read',
            batch.map((cover) => cover.memoryId),
          );
          for (const asset of result.items) signed.set(asset.assetId, asset);
        }
        for (const card of chapters) {
          const monthIndex = card.item.monthIndex ?? 0;
          const cover = coverByMonth.get(monthIndex);
          const asset = cover ? signed.get(cover.assetId) : undefined;
          const urls = asset?.status === 'READY' ? asset.urls : {};
          const count = countsByMonth.get(monthIndex);
          cards.push({
            instant: card.instant,
            item: {
              type: 'SYSTEM',
              id: `sys:chapter:${child.childId}:${monthIndex}`,
              kind: 'CHAPTER',
              childId: child.childId,
              monthIndex,
              date: card.item.date,
              coverUrl: urls.t1280 ?? urls.t640 ?? urls.t320 ?? null,
              coverUrlExpiresAt: asset?.urlsExpireAt?.toISOString() ?? null,
              memoryCount: count?.memoryCount ?? 0,
              firstsCount: count?.firstsCount ?? 0,
              quotesCount: count?.quotesCount ?? 0,
            },
          });
        }
      }
      const timezone =
        child?.timezone ??
        (await this.repository.familyTimezone(familyId)) ??
        'Asia/Ho_Chi_Minh';
      const recaps = await this.timelineCards.weeklyRecaps(
        familyId,
        actor.userId,
        query.childId,
      );
      for (const recap of recaps) {
        cards.push({
          instant: timelineDateInstant(recap.periodStart, timezone),
          item: {
            type: 'RECAP',
            id: recap.id,
            kind: 'WEEKLY_RECAP',
            childId: recap.childId,
            date: recap.periodStart.toISOString().slice(0, 10),
            periodStart: recap.periodStart.toISOString().slice(0, 10),
          },
        });
      }
    }
    const merged = [
      ...projected.map((memory) => ({
        time: new Date(memory.occurredAt).getTime(),
        id: memory.id,
        item: { type: 'MEMORY' as const, memory },
      })),
      ...cards
        .filter(
          (card) =>
            card.instant.getTime() >= lower && card.instant.getTime() < upper,
        )
        .map((card) => ({
          time: card.instant.getTime(),
          id: card.item.id,
          item: card.item,
        })),
    ].sort(
      (a, b) => b.time - a.time || (a.id < b.id ? 1 : a.id > b.id ? -1 : 0),
    );
    return {
      data: merged.map((row) => row.item),
      nextCursor:
        hasMore && last
          ? encodeOccurredCursor(
              { occurredAt: last.memory.occurredAt, id: last.memory.id },
              'timeline',
            )
          : null,
    };
  }

  async mediaGrid(
    actor: AuthPrincipal,
    familyId: string,
    query: MediaGridQueryDto,
  ): Promise<MediaGridResponseDto> {
    await this.contentAccess(actor, familyId, 'download');
    const limit = query.limit ?? MEMORY_POLICY.gridDefaultLimit;
    const rows = await this.repository.listMediaGridForParent(
      familyId,
      actor.userId,
      {
        childId: query.childId,
        kind: query.kind,
        after: query.cursor ? decodeOccurredCursor(query.cursor, 'grid') : null,
        limit,
      },
    );
    const page = rows.slice(0, limit);
    const signed = new Map<string, MediaAssetResponseDto>();
    for (
      let start = 0;
      start < page.length;
      start += MEDIA_POLICY.maxBatchAssets
    ) {
      const result = await this.signAssets(
        actor,
        page
          .slice(start, start + MEDIA_POLICY.maxBatchAssets)
          .map((row) => row.assetId),
        'download',
        page.map((row) => row.memoryId),
      );
      for (const item of result.items) signed.set(item.assetId, item);
    }
    const last = page.at(-1);
    return {
      // Recheck by signing service prevents returning asset metadata if access
      // was revoked between the query and URL projection.
      data: page.flatMap((row) => {
        const asset = signed.get(row.assetId);
        return asset?.status === 'READY'
          ? [
              {
                assetId: row.assetId,
                memoryId: row.memoryId,
                kind: row.kind,
                width: row.width,
                height: row.height,
                durationMs: row.durationMs,
                blurhash: row.blurhash,
                occurredAt: row.occurredAt.toISOString(),
                urls: asset.urls,
                urlsExpireAt: asset.urlsExpireAt,
              },
            ]
          : [];
      }),
      nextCursor:
        rows.length > limit && last
          ? encodeOccurredCursor(
              { occurredAt: last.occurredAt, id: last.assetId },
              'grid',
            )
          : null,
    };
  }

  async update(
    actor: AuthPrincipal,
    memoryId: string,
    expectedVersion: number,
    input: UpdateMemoryDto,
  ): Promise<MemoryResponseDto> {
    const familyId = await this.repository.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, familyId, 'write');
    const view = await this.repository.findVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!view) throw new NotFoundError('Memory was not found.');
    const current = view.memory;
    if (
      current.kind === 'LETTER' &&
      current.unlockAt !== null &&
      current.authorUserId !== actor.userId
    )
      throw new NotFoundError('Memory was not found.');
    if (
      current.kind === 'LETTER' &&
      current.unlockAt !== null &&
      input.visibility !== undefined &&
      input.visibility !== 'PRIVATE'
    )
      throw memoryError(
        'Sealed letters stay private until release.',
        'LETTER_SEALED',
      );
    if (
      (current.kind === 'MILESTONE' || current.kind === 'LETTER') &&
      (input.childIds !== undefined ||
        input.pregnancyId !== undefined ||
        input.familyMoment !== undefined)
    )
      throw memoryError(
        'Milestone and letter subjects cannot be reassigned.',
        'MEMORY_SUBJECT_IMMUTABLE',
      );
    const isAuthor = current.authorUserId === actor.userId;
    const changed = (Object.keys(input) as (keyof UpdateMemoryDto)[]).filter(
      (key) => input[key] !== undefined,
    );
    // canEditMemory (spec §6.2): the other Parent only re-tags and re-scopes.
    if (!isAuthor) {
      const locked = changed.filter(
        (key) => !PARTNER_EDITABLE_FIELDS.includes(key),
      );
      if (locked.length)
        throw new DomainError(
          `Only the author can change: ${locked.join(', ')}.`,
          'MEMORY_FIELD_NOT_EDITABLE',
          403,
        );
      if (input.visibility === 'PRIVATE')
        throw memoryError(
          'Only the author can make a memory private.',
          'MEMORY_VISIBILITY_INVALID',
        );
    }
    const pick = <T>(value: T | undefined, fallback: T): T =>
      value === undefined ? fallback : value;
    const title =
      input.title === undefined ? current.title : blankToNull(input.title);
    const body =
      input.body === undefined ? current.body : blankToNull(input.body);
    const childIds = pick(input.childIds, [...view.childIds]);
    const pregnancyId = pick(input.pregnancyId, current.pregnancyId);
    const familyMoment = pick(input.familyMoment, current.familyMoment);
    const occurredAt = input.occurredAt
      ? new Date(input.occurredAt)
      : current.occurredAt;
    if (
      input.occurredAt &&
      occurredAt.getTime() > Date.now() + MEMORY_POLICY.futureSkewMs
    )
      throw memoryError('occurredAt is in the future.', 'MEMORY_DATE_INVALID');

    const add = input.addAssetIds ?? [];
    const remove = input.removeAssetIds ?? [];
    if (
      add.some((id) => remove.includes(id)) ||
      remove.some((id) => !view.assets.some((a) => a.assetId === id))
    )
      throw memoryError('Invalid asset changes.', 'MEMORY_ASSET_INVALID');
    const finalAssetIds = [
      ...new Set([
        ...view.assets
          .map((a) => a.assetId)
          .filter((id) => !remove.includes(id)),
        ...add,
      ]),
    ];
    const mediaChanged =
      input.addAssetIds !== undefined ||
      input.removeAssetIds !== undefined ||
      input.coverAssetId !== undefined;
    const cover =
      input.coverAssetId === undefined
        ? finalAssetIds.includes(view.coverAssetId ?? '')
          ? view.coverAssetId
          : (finalAssetIds[0] ?? null)
        : input.coverAssetId;
    if (
      (cover && !finalAssetIds.includes(cover)) ||
      (finalAssetIds.length > 0 && !cover)
    )
      throw memoryError('Cover must be attached.', 'MEMORY_COVER_INVALID');
    const context = await this.repository.findCreationContext(
      familyId,
      actor.userId,
      { childIds, pregnancyId, assetIds: add },
    );
    if (!context) throw new NotFoundError('Family was not found.');
    const plan = await this.planOf(familyId, actor.userId);
    if (current.status !== 'DRAFT') {
      if (
        view.assets.length > 0 &&
        ['MOMENT', 'KEEPSAKE', 'MONTHLY_PHOTO', 'BUMP', 'ULTRASOUND'].includes(
          current.kind,
        ) &&
        finalAssetIds.length === 0
      )
        throw memoryError('Keep at least one photo.', 'MEMORY_ASSET_REQUIRED');
      this.assertContent(
        current.kind,
        finalAssetIds.length,
        childIds,
        title,
        body,
      );
    }
    if (finalAssetIds.length > plan.quotas.photosPerMemory)
      throw new DomainError('Too many photos.', 'QUOTA_PHOTOS_PER_MEMORY', 402);
    this.assertAssets(actor, context, add);
    this.assertSubjects(context, childIds, pregnancyId, familyMoment);
    const localDate = localDateIn(occurredAt, context.timezone);
    const updated = await this.repository.update({
      familyId,
      memoryId,
      actorUserId: actor.userId,
      expectedVersion,
      title,
      body,
      occurredAt,
      occurredLocalDate: localDate,
      visibility: input.visibility
        ? this.effectiveVisibility(input.visibility, plan.features)
        : current.visibility,
      familyMoment,
      pregnancyId,
      pregnancyWeek: pregnancyWeek(
        context.pregnancy?.dueDate ?? null,
        localDate,
      ),
      feeling: pick(input.feeling, current.feeling),
      locationLabel:
        input.locationLabel === undefined
          ? current.locationLabel
          : blankToNull(input.locationLabel),
      quoteContext:
        current.kind !== 'QUOTE'
          ? null
          : input.quoteContext === undefined
            ? current.quoteContext
            : blankToNull(input.quoteContext),
      commentsEnabled: pick(input.commentsEnabled, current.commentsEnabled),
      children: childIds.map((childId) => ({
        childId,
        ageMonth: ageInMonths(
          context.children.find((child) => child.id === childId)!.birthDate,
          localDate,
        ),
      })),
      assets: mediaChanged
        ? finalAssetIds.map((assetId, sortOrder) => ({
            assetId,
            sortOrder,
            isCover: assetId === cover,
          }))
        : undefined,
      assetQuota: plan.quotas.photosPerMemory,
      changedFields: changed,
    });
    return this.projectOne(actor, updated);
  }

  async trash(actor: AuthPrincipal, memoryId: string): Promise<void> {
    const familyId = await this.repository.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, familyId, 'write');
    // canDeleteMemory (spec §6.2): author or Parent — any memory the Parent sees.
    const live = await this.repository.findVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (live) {
      const moved = await this.repository.trash({
        familyId,
        memoryId,
        actorUserId: actor.userId,
        purgeAfter: new Date(Date.now() + MEMORY_POLICY.trashRetentionMs),
      });
      if (moved) return;
    }
    // Already in the trash (retry, or the partner deleted it first): same outcome.
    const trashed = await this.repository.findTrashedVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!trashed) throw new NotFoundError('Memory was not found.');
  }

  async listTrash(
    actor: AuthPrincipal,
    familyId: string,
    query: MemoryTrashQueryDto,
  ): Promise<MemoryFeedResponseDto> {
    await this.access.requireParent(actor, familyId, 'read');
    const limit = query.limit ?? MEMORY_POLICY.feedDefaultLimit;
    const after = query.cursor ? decodeCursor(query.cursor) : null;
    const rows = await this.repository.listTrashForParent(
      familyId,
      actor.userId,
      {
        after: after ? { trashedAt: after.createdAt, id: after.id } : null,
        limit,
      },
    );
    const page = rows.slice(0, limit);
    const last = page.at(-1)?.memory;
    return {
      data: await this.project(actor, page),
      nextCursor:
        rows.length > limit && last?.trashedAt
          ? encodeCursor({ createdAt: last.trashedAt, id: last.id })
          : null,
    };
  }

  async restore(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<MemoryResponseDto> {
    const familyId = await this.repository.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, familyId, 'write');
    const trashed = await this.repository.findTrashedVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!trashed) {
      // Restoring twice (retry) returns the live memory.
      const live = await this.repository.findVisibleToParent(
        familyId,
        actor.userId,
        memoryId,
      );
      if (live) return this.projectOne(actor, live);
      throw new NotFoundError('Memory was not found.');
    }
    const plan = await this.planOf(familyId, actor.userId);
    const view = await this.repository.restore({
      familyId,
      memoryId,
      actorUserId: actor.userId,
      memoryQuota: plan.quotas.memoryCount ?? null,
    });
    return this.projectOne(actor, view);
  }

  async purge(actor: AuthPrincipal, memoryId: string): Promise<void> {
    const familyId = await this.repository.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, familyId, 'write');
    const trashed = await this.repository.findTrashedVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!trashed) throw new NotFoundError('Memory was not found.');
    await this.repository.purge(familyId, memoryId, actor.userId);
  }

  /** Plan in effect; unknown or malformed plan data fails closed (402). */
  private async planOf(
    familyId: string,
    actorUserId: string,
  ): Promise<z.infer<typeof planSchema>> {
    const context = await this.repository.findCreationContext(
      familyId,
      actorUserId,
      {
        childIds: [],
        pregnancyId: null,
        assetIds: [],
      },
    );
    const plan = planSchema.safeParse({
      quotas: context?.quotas,
      features: context?.features,
    });
    if (!plan.success)
      throw new DomainError(
        'The family plan does not allow memories.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    return plan.data;
  }

  private async contentAccess(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'download' | 'write',
  ) {
    if (this.access.requireContentAccess)
      return this.access.requireContentAccess(actor, familyId, mode);
    return {
      family: await this.access.requireParent(actor, familyId, mode),
      isParent: true,
    };
  }

  private assertContent(
    kind: MemoryKind,
    assetCount: number,
    childIds: readonly string[],
    title: string | null,
    body: string | null,
  ): void {
    if (!assetCount && !title && !body)
      throw memoryError('A memory needs media or text.', 'MEMORY_EMPTY');
    if (MEMORY_POLICY.assetRequiredKinds.includes(kind) && !assetCount)
      throw memoryError(
        'This kind of memory needs at least one photo.',
        'MEMORY_ASSET_REQUIRED',
      );
    if (kind === 'QUOTE') {
      if (childIds.length !== 1)
        throw memoryError(
          'A quote belongs to exactly one child.',
          'MEMORY_QUOTE_CHILD',
        );
      if (!body || body.length > MEMORY_POLICY.quoteMaxLength)
        throw memoryError(
          'A quote needs a body of at most 280 characters.',
          'MEMORY_QUOTE_BODY',
        );
    }
  }

  private assertAssets(
    actor: AuthPrincipal,
    context: MemoryCreationContext,
    assetIds: readonly string[],
  ): void {
    for (const id of assetIds) {
      const asset = context.assets.find((candidate) => candidate.id === id);
      // Own stored upload, or another Parent's verified asset the actor already
      // sees (SHA-256 dedup may return it, spec §6.3/§10.2).
      const usable =
        asset?.uploaderUserId === actor.userId
          ? ['UPLOADED', 'PROCESSING', 'READY'].includes(asset.status)
          : asset?.sharedWithActor === true && asset.status === 'READY';
      if (!asset || asset.purpose !== 'MEMORY' || !usable)
        throw memoryError(
          'Some media is not uploaded or not yours.',
          'MEMORY_ASSET_INVALID',
        );
    }
  }

  private assertSubjects(
    context: MemoryCreationContext,
    childIds: readonly string[],
    pregnancyId: string | null,
    familyMoment: boolean,
  ): void {
    for (const id of childIds) {
      const child = context.children.find((candidate) => candidate.id === id);
      // Invariant 5 (spec §6.4): children of another family are rejected.
      if (!child?.active)
        throw memoryError(
          'Child does not belong to this family.',
          'CHILD_NOT_IN_FAMILY',
        );
    }
    if (pregnancyId !== null && !context.pregnancy?.active)
      throw memoryError(
        'Pregnancy does not belong to this family.',
        'PREGNANCY_NOT_IN_FAMILY',
      );
    if (familyMoment && (childIds.length || pregnancyId))
      throw memoryError(
        'A family moment has no child or pregnancy.',
        'MEMORY_SUBJECT_INVALID',
      );
    // Spec §11.5 (2): with several children, an untagged memory must be a family moment.
    if (
      !familyMoment &&
      !childIds.length &&
      !pregnancyId &&
      context.activeChildCount > 1
    )
      throw memoryError(
        'Choose a child or mark it as a family moment.',
        'FAMILY_MOMENT_REQUIRED',
      );
  }

  private effectiveVisibility(
    requested: Visibility,
    features: Record<string, unknown>,
  ): Visibility {
    return requested === 'FAMILY' && features['circle.enabled'] !== true
      ? 'PARENTS'
      : requested;
  }

  /** Media's Parent API is retained; Circle variants use the library's grant-aware projection. */
  private async signAssets(
    actor: AuthPrincipal,
    assetIds: string[],
    mode: MediaViewAccess,
    memoryIds: string[],
  ) {
    const result = await this.media.signViewUrls(actor, { assetIds }, mode);
    if (
      !this.library ||
      !this.storage ||
      result.items.length === assetIds.length
    )
      return result;
    const available = new Set(result.items.map((a) => a.assetId));
    for (const memoryId of new Set(memoryIds)) {
      const row = await this.library.find(memoryId, actor.userId, true);
      if (!row) continue;
      await this.contentAccess(actor, row.memory.familyId, mode);
      for (const asset of row.assets) {
        if (!assetIds.includes(asset.id) || available.has(asset.id)) continue;
        const urls: Record<string, string> = {};
        let expiresAt: Date | null = null;
        if (asset.status === 'READY')
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
            expiresAt = signed.expiresAt;
          }
        result.items.push({
          assetId: asset.id,
          kind: asset.kind,
          purpose: asset.purpose,
          status: asset.status,
          width: asset.width,
          height: asset.height,
          durationMs: asset.durationMs,
          blurhash: asset.blurhash,
          urls,
          urlsExpireAt: expiresAt,
        });
        available.add(asset.id);
      }
    }
    return {
      ...result,
      unavailableIds: assetIds.filter((id) => !available.has(id)),
    };
  }

  private async projectOne(
    actor: AuthPrincipal,
    view: MemoryView,
    access: MediaViewAccess = 'read',
  ): Promise<MemoryResponseDto> {
    const [dto] = await this.project(actor, [view], access);
    return dto!;
  }

  /** Response shaping with signed URLs of READY variants (spec §10.5). */
  private async project(
    actor: AuthPrincipal,
    views: readonly MemoryView[],
    access: MediaViewAccess = 'read',
  ): Promise<MemoryResponseDto[]> {
    const visibleAssets = views
      .filter(
        (view) =>
          !(
            view.memory.kind === 'LETTER' &&
            view.memory.unlockAt !== null &&
            view.memory.authorUserId !== actor.userId
          ),
      )
      .flatMap((view) => view.assets.map((asset) => asset.assetId));
    const signed = new Map<string, MediaAssetResponseDto>();
    for (
      let start = 0;
      start < visibleAssets.length;
      start += MEDIA_POLICY.maxBatchAssets
    ) {
      const result = await this.signAssets(
        actor,
        visibleAssets.slice(start, start + MEDIA_POLICY.maxBatchAssets),
        access,
        views.map((view) => view.memory.id),
      );
      for (const item of result.items) signed.set(item.assetId, item);
    }
    return views.map((view) => {
      const memory = view.memory;
      const sealed =
        memory.kind === 'LETTER' &&
        memory.unlockAt !== null &&
        memory.authorUserId !== actor.userId;
      return {
        id: memory.id,
        familyId: memory.familyId,
        kind: memory.kind,
        status: memory.status,
        version: memory.version,
        authorUserId: memory.authorUserId,
        authorRole: memory.authorRole,
        // Sealed letter (spec §6.3): only id/kind/unlockAt/author survive.
        title: sealed ? null : memory.title,
        body: sealed ? null : memory.body,
        occurredAt: memory.occurredAt.toISOString(),
        occurredLocalDate: memory.occurredLocalDate.toISOString().slice(0, 10),
        visibility: memory.visibility,
        familyMoment: memory.familyMoment,
        childIds: sealed ? [] : [...view.childIds],
        pregnancyId: sealed ? null : memory.pregnancyId,
        pregnancyWeek: sealed ? null : memory.pregnancyWeek,
        feeling: sealed ? null : memory.feeling,
        locationLabel: sealed ? null : memory.locationLabel,
        quoteContext: sealed ? null : memory.quoteContext,
        commentsEnabled: memory.commentsEnabled,
        commentCount: memory.commentCount,
        reactionCount: memory.reactionCount,
        reactions: view.reactionCounts,
        myReaction: view.reactionOf(actor.userId),
        perspectiveCount: memory.perspectiveCount,
        sealed,
        unlockAt: memory.unlockAt?.toISOString() ?? null,
        coverAssetId: sealed ? null : view.coverAssetId,
        assets: sealed
          ? []
          : view.assets.map(
              (asset) =>
                signed.get(asset.assetId) ?? {
                  assetId: asset.assetId,
                  kind: asset.kind,
                  purpose: 'MEMORY',
                  status: asset.status,
                  width: asset.width,
                  height: asset.height,
                  durationMs: asset.durationMs,
                  blurhash: asset.blurhash,
                  urls: {},
                  urlsExpireAt: null,
                },
            ),
        createdAt: memory.createdAt.toISOString(),
        publishedAt: memory.publishedAt?.toISOString() ?? null,
        trashedAt: memory.trashedAt?.toISOString() ?? null,
        trashedBy: memory.trashedBy,
        purgeAfter: memory.purgeAfter?.toISOString() ?? null,
      };
    });
  }
}

function memoryError(message: string, code: string): DomainError {
  return new DomainError(message, code, 422);
}

function blankToNull(value: string | null | undefined): string | null {
  const trimmed = value?.trim();
  return trimmed ? trimmed : null;
}

function hashRequest(input: CreateMemoryDto): Uint8Array {
  return createHash('sha256')
    .update(
      JSON.stringify([
        input.familyId,
        input.kind,
        input.assetIds ?? [],
        input.coverAssetId ?? null,
        input.title ?? null,
        input.body ?? null,
        input.childIds ?? [],
        input.familyMoment ?? false,
        input.pregnancyId ?? null,
        input.occurredAt,
        input.visibility,
        input.feeling ?? null,
        input.locationLabel ?? null,
        input.quoteContext ?? null,
        input.commentsEnabled ?? true,
      ]),
    )
    .digest();
}

/** Calendar date of `instant` in the family timezone, as a UTC-midnight Date. */
export function localDateIn(instant: Date, timezone: string): Date {
  const day = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(instant);
  return new Date(day + 'T00:00:00.000Z');
}

/** Completed months between birth and the memory date (spec §7.10 chapters). */
export function ageInMonths(birthDate: Date, localDate: Date): number {
  const months =
    (localDate.getUTCFullYear() - birthDate.getUTCFullYear()) * 12 +
    localDate.getUTCMonth() -
    birthDate.getUTCMonth() -
    (localDate.getUTCDate() < birthDate.getUTCDate() ? 1 : 0);
  return Math.max(months, 0);
}

/** Gestational week from the due date (40 weeks = 280 days); null when unknown. */
export function pregnancyWeek(
  dueDate: Date | null,
  localDate: Date,
): number | null {
  if (!dueDate) return null;
  const daysToDue = Math.round(
    (dueDate.getTime() - localDate.getTime()) / DAY_MS,
  );
  const week = Math.floor((280 - daysToDue) / 7);
  return week >= 0 && week <= 45 ? week : null;
}

function encodeCursor(cursor: MemoryFeedCursor): string {
  return Buffer.from(
    JSON.stringify({ c: cursor.createdAt.toISOString(), i: cursor.id }),
  ).toString('base64url');
}

function decodeCursor(value: string): MemoryFeedCursor {
  try {
    const parsed = cursorSchema.parse(
      JSON.parse(Buffer.from(value, 'base64url').toString('utf8')),
    );
    return { createdAt: new Date(parsed.c), id: parsed.i };
  } catch {
    throw new ValidationError('cursor is invalid.');
  }
}

const occurredCursorSchema = z.object({
  o: z.iso.datetime(),
  i: z.uuid(),
  v: z.literal(1),
  route: z.enum(['timeline', 'grid']),
});
function encodeOccurredCursor(
  cursor: OccurredCursor,
  route: 'timeline' | 'grid',
): string {
  return Buffer.from(
    JSON.stringify({
      v: 1,
      route,
      o: cursor.occurredAt.toISOString(),
      i: cursor.id,
    }),
  ).toString('base64url');
}
function decodeOccurredCursor(
  value: string,
  route: 'timeline' | 'grid',
): OccurredCursor {
  try {
    const parsed = occurredCursorSchema.parse(
      JSON.parse(Buffer.from(value, 'base64url').toString('utf8')),
    );
    if (parsed.route !== route) throw new Error('Wrong cursor route');
    return { occurredAt: new Date(parsed.o), id: parsed.i };
  } catch {
    throw new ValidationError('cursor is invalid.');
  }
}

/** Birth + completed calendar months; month-end anniversaries clamp to the
 * last day (Jan 31 → Feb 28/29), with no accumulated calendar drift. */
export function timelineSystemCards(
  child: TimelineChildContext,
  now: Date,
): { instant: Date; item: TimelineSystemItemDto }[] {
  const today = localDateIn(now, child.timezone);
  const birth = child.birthDate;
  const months =
    (today.getUTCFullYear() - birth.getUTCFullYear()) * 12 +
    today.getUTCMonth() -
    birth.getUTCMonth();
  const cards: { instant: Date; item: TimelineSystemItemDto }[] = [];
  for (let n = 0; n <= months; n++) {
    const first = new Date(
      Date.UTC(birth.getUTCFullYear(), birth.getUTCMonth() + n, 1),
    );
    const lastDay = new Date(
      Date.UTC(first.getUTCFullYear(), first.getUTCMonth() + 1, 0),
    ).getUTCDate();
    first.setUTCDate(Math.min(birth.getUTCDate(), lastDay));
    if (first > today) break;
    const date = first.toISOString().slice(0, 10);
    cards.push({
      instant: timelineDateInstant(first, child.timezone),
      item: {
        type: 'SYSTEM',
        id:
          n === 0
            ? `sys:birth:${child.childId}`
            : `sys:monthiversary:${child.childId}:${n}`,
        kind: n === 0 ? 'BIRTH' : 'MONTHIVERSARY',
        childId: child.childId,
        ...(n === 0 ? {} : { monthIndex: n }),
        date,
      },
    });
  }
  return cards;
}

/** Calendar-day cards sort at local midnight in the family's timezone. */
function timelineDateInstant(day: Date, timezone: string): Date {
  const format = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hourCycle: 'h23',
  });
  let instant = day.getTime();
  for (let pass = 0; pass < 3; pass++) {
    const parts = Object.fromEntries(
      format
        .formatToParts(new Date(instant))
        .map((part) => [part.type, part.value]),
    );
    const local = Date.UTC(
      Number(parts.year),
      Number(parts.month) - 1,
      Number(parts.day),
      Number(parts.hour),
      Number(parts.minute),
      Number(parts.second),
    );
    instant += day.getTime() - local;
  }
  return new Date(instant);
}

/** Calendar birthday at midnight in the family's IANA timezone, including DST. */
function midnightInTimezone(
  year: number,
  month: number,
  day: number,
  timezone: string,
): Date {
  const wall = Date.UTC(year, month - 1, day);
  let instant = wall;
  const formatter = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hourCycle: 'h23',
  });
  for (let i = 0; i < 3; i++) {
    const parts = Object.fromEntries(
      formatter.formatToParts(new Date(instant)).map((p) => [p.type, p.value]),
    );
    const represented = Date.UTC(
      Number(parts.year),
      Number(parts.month) - 1,
      Number(parts.day),
      Number(parts.hour),
      Number(parts.minute),
      Number(parts.second),
    );
    instant += wall - represented;
  }
  return new Date(instant);
}
