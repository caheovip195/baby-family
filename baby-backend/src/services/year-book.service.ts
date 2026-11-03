import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { MEDIA_POLICY } from '../config/media-policy';
import { YEAR_BOOK_POLICY } from '../config/year-book-policy';
import type {
  SaveYearBookDto,
  YearBookListDto,
  YearBookChapterDto,
  YearBookDto,
  YearBookItemDto,
} from '../dto/year-book/year-book.dto';
import { YEAR_BOOK_REPOSITORY } from '../interfaces/repositories/year-book-repository.interface';
import type { IYearBookRepository } from '../interfaces/repositories/year-book-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEDIA_SERVICE } from '../interfaces/services/media-service.interface';
import type { IMediaService } from '../interfaces/services/media-service.interface';
import type { IYearBookService } from '../interfaces/services/year-book-service.interface';
import type {
  YearBookMemory,
  YearBookPlan,
  YearBookSubject,
} from '../models/year-book.model';

/** Nội dung lưu trong `app.recaps.content` (period YEAR). */
interface SavedContent {
  version: number;
  title: string | null;
  /** Bản cho ông bà: người thân được xem (BF-20261030-002). */
  shared: boolean;
  chapters: {
    month: number;
    title: string | null;
    items: { memoryId: string; assetIds: string[]; caption: string | null }[];
  }[];
}

/**
 * REC-04 Sách của con / cả nhà (BF-20261028-013, BF-20261030-001): đối tượng
 * là một bé hoặc cả nhà (mọi ký ức của gia đình); mỗi tháng một chương, tự chọn ký ức
 * (cột mốc trước) và ảnh; Parent chọn/bỏ ảnh, sửa chú thích, đặt tên rồi lưu.
 * PDF dựng trên máy; server chỉ trả `canExport` theo gói (cờ
 * `yearbook.export`, dùng thử chỉ xem trước). Chỉ ký ức người hỏi được xem.
 *
 * Bản cho ông bà (BF-20261030-002): Parent bật chia sẻ khi lưu (gói có
 * `yearbook.circleShare`, chưa khai báo thì gói có Family Circle); người thân
 * được xem bé đó (sách cả nhà: mọi người thân đang hoạt động) đọc bản đã lưu,
 * chỉ ký ức đã chọn mà họ được xem, không sửa.
 */
@Injectable()
export class YearBookService implements IYearBookService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(YEAR_BOOK_REPOSITORY)
    private readonly repository: IYearBookRepository,
    @Inject(MEDIA_SERVICE) private readonly media: IMediaService,
  ) {}

  async get(
    actor: AuthPrincipal,
    childId: string,
    year: number,
  ): Promise<YearBookDto> {
    validYear(year);
    const subject = await this.repository.child(childId);
    if (!subject) throw new NotFoundError('Child was not found.');
    const parent = await this.reader(actor, subject);
    return this.build(actor, inTimeline(subject, year), year, !parent);
  }

  async save(
    actor: AuthPrincipal,
    childId: string,
    year: number,
    input: SaveYearBookDto,
  ): Promise<YearBookDto> {
    const subject = await this.child(actor, childId, year, 'write');
    return this.store(actor, subject, year, input);
  }

  async getFamily(
    actor: AuthPrincipal,
    familyId: string,
    year: number,
  ): Promise<YearBookDto> {
    validYear(year);
    const parent = await this.readerOf(actor, familyId);
    const subject = await this.repository.family(familyId);
    if (!subject) throw new NotFoundError('Family was not found.');
    return this.build(actor, inTimeline(subject, year), year, !parent);
  }

  async saveFamily(
    actor: AuthPrincipal,
    familyId: string,
    year: number,
    input: SaveYearBookDto,
  ): Promise<YearBookDto> {
    const subject = await this.family(actor, familyId, year, 'write');
    return this.store(actor, subject, year, input);
  }

  /** Sách đã lưu: Parent thấy mọi bản, người thân chỉ bản chia sẻ được xem. */
  async list(actor: AuthPrincipal, familyId: string): Promise<YearBookListDto> {
    const parent = await this.readerOf(actor, familyId);
    const viewer = parent
      ? null
      : await this.repository.viewer(familyId, actor.userId);
    const items = [];
    for (const row of await this.repository.savedList(familyId)) {
      const content = parseContent(row.content);
      if (!content) continue;
      if (
        viewer &&
        (!content.shared ||
          (row.childId !== null && !viewer.childIds.includes(row.childId)))
      )
        continue;
      items.push({
        scope: row.scope,
        childId: row.childId,
        name: row.name,
        year: row.year,
        title: content.title,
        sharedWithCircle: content.shared,
        updatedAt: row.updatedAt.toISOString(),
      });
    }
    return { items };
  }

  /** true = Parent; người thân chỉ đọc sách của bé mình được xem. */
  private async reader(actor: AuthPrincipal, subject: YearBookSubject) {
    const parent = await this.readerOf(actor, subject.familyId);
    if (parent || subject.childId === null) return parent;
    const viewer = await this.repository.viewer(subject.familyId, actor.userId);
    if (!viewer.childIds.includes(subject.childId))
      throw new NotFoundError('Year book was not found.');
    return false;
  }

  /** Thành viên đọc được nội dung gia đình (người thân: gói có Circle). */
  private async readerOf(actor: AuthPrincipal, familyId: string) {
    if (!this.access.requireContentAccess) {
      await this.access.requireParent(actor, familyId, 'read');
      return true;
    }
    const { isParent } = await this.access.requireContentAccess(
      actor,
      familyId,
      'read',
    );
    return isParent;
  }

  private async store(
    actor: AuthPrincipal,
    subject: YearBookSubject,
    year: number,
    input: SaveYearBookDto,
  ): Promise<YearBookDto> {
    const shared = input.sharedWithCircle === true;
    if (shared && !canShare(await this.repository.plan(subject.familyId)))
      throw new DomainError(
        'Sharing the year book needs the Family plan.',
        'PLAN_REQUIRED_FAMILY',
        402,
      );
    const memories = await this.memories(actor, subject, year);
    const byId = new Map(memories.map((memory) => [memory.id, memory]));
    const months = new Set<number>();
    const seen = new Set<string>();
    const chapters: SavedContent['chapters'] = [];
    let cover: string | null = null;
    for (const chapter of input.chapters) {
      if (months.has(chapter.month))
        throw new ValidationError('Each month can appear only once.');
      months.add(chapter.month);
      const items: SavedContent['chapters'][number]['items'] = [];
      for (const item of chapter.items) {
        const memory = byId.get(item.memoryId);
        if (!memory || monthOf(memory) !== chapter.month || seen.has(memory.id))
          throw new ValidationError(
            'Each item must be a distinct visible memory of its month.',
          );
        seen.add(memory.id);
        const assetIds = [...new Set(item.assetIds)];
        if (assetIds.some((id) => !memory.assetIds.includes(id)))
          throw new ValidationError('Photos must belong to the memory.');
        cover ??= assetIds[0] ?? null;
        items.push({
          memoryId: memory.id,
          assetIds,
          caption: item.caption?.trim() || null,
        });
      }
      chapters.push({
        month: chapter.month,
        title: chapter.title?.trim() || null,
        items,
      });
    }
    const content: SavedContent = {
      version: YEAR_BOOK_POLICY.contentVersion,
      title: input.title?.trim() || null,
      shared,
      chapters,
    };
    await this.repository.save(
      subject,
      yearStart(year),
      new Date(Date.UTC(year, 11, 31)),
      content,
      cover,
      shared,
      actor.userId,
    );
    return this.build(actor, subject, year, false, memories);
  }

  private async build(
    actor: AuthPrincipal,
    subject: YearBookSubject,
    year: number,
    readOnly = false,
    loaded?: YearBookMemory[],
  ): Promise<YearBookDto> {
    const [memories, saved, plan] = await Promise.all([
      loaded ?? this.memories(actor, subject, year),
      this.repository.saved(subject, yearStart(year)),
      this.repository.plan(subject.familyId),
    ]);
    const content = parseContent(saved?.content);
    // Người thân: chỉ bản Parent đã chia sẻ (không lộ bản riêng / chưa lưu).
    if (readOnly && !content?.shared)
      throw new NotFoundError('Year book was not found.');
    const urls = await this.urls(actor, memories);
    const groups = new Map<number, YearBookMemory[]>();
    for (const memory of memories) {
      const month = monthOf(memory);
      groups.set(month, [...(groups.get(month) ?? []), memory]);
    }
    const chapters: YearBookChapterDto[] = [];
    for (const [month, items] of [...groups].sort((a, b) => a[0] - b[0])) {
      const stored = content?.chapters.find(
        (chapter) => chapter.month === month,
      );
      const entries = (
        content
          ? this.savedItems(items, stored?.items ?? [])
          : this.suggestedItems(items)
      ).filter((entry) => !readOnly || entry.included);
      if (readOnly && entries.length === 0) continue;
      chapters.push({
        month,
        title: stored?.title ?? null,
        items: entries.map((entry) => ({
          ...entry,
          photos: entry.assetIds.map((assetId) => ({
            assetId,
            url: urls.get(assetId) ?? null,
          })),
        })),
      });
    }
    return {
      scope: subject.scope,
      familyId: subject.familyId,
      childId: subject.childId,
      childName: subject.name,
      year,
      title: content?.title ?? null,
      canExport: canExport(plan),
      canShare: !readOnly && canShare(plan),
      sharedWithCircle: content?.shared ?? false,
      readOnly,
      saved: content !== null,
      chapters,
    };
  }

  /** Bản đã lưu: giữ thứ tự chọn; ký ức/ảnh không còn xem được thì bỏ. */
  private savedItems(
    memories: YearBookMemory[],
    stored: SavedContent['chapters'][number]['items'],
  ): Omit<YearBookItemDto, 'photos'>[] {
    const picks = new Map(stored.map((item) => [item.memoryId, item]));
    return memories.map((memory) => {
      const pick = picks.get(memory.id);
      return item(
        memory,
        pick !== undefined,
        pick?.assetIds.filter((id) => memory.assetIds.includes(id)) ?? [],
        pick?.caption ?? null,
      );
    });
  }

  /**
   * Chưa lưu: chọn sẵn tới `defaultPhotosPerChapter` ảnh, ưu tiên cột mốc /
   * ảnh tháng, mỗi ký ức một ảnh đầu; cột mốc không ảnh vẫn vào sách.
   */
  private suggestedItems(
    memories: YearBookMemory[],
  ): Omit<YearBookItemDto, 'photos'>[] {
    const rank = (memory: YearBookMemory) => {
      const index = (
        YEAR_BOOK_POLICY.preferredKinds as readonly string[]
      ).indexOf(memory.kind);
      return index < 0 ? YEAR_BOOK_POLICY.preferredKinds.length : index;
    };
    const chosen = new Set<string>();
    let photos = 0;
    for (const memory of [...memories].sort((a, b) => rank(a) - rank(b))) {
      if (chosen.size >= YEAR_BOOK_POLICY.maxItemsPerChapter) break;
      if (memory.assetIds.length > 0) {
        if (photos >= YEAR_BOOK_POLICY.defaultPhotosPerChapter) continue;
        photos++;
        chosen.add(memory.id);
      } else if (memory.kind === 'MILESTONE') {
        chosen.add(memory.id);
      }
    }
    return memories.map((memory) =>
      item(
        memory,
        chosen.has(memory.id),
        chosen.has(memory.id) ? memory.assetIds.slice(0, 1) : [],
        null,
      ),
    );
  }

  /** URL xem ảnh (bản ~1080px cho trang sách), ký theo lô. */
  private async urls(actor: AuthPrincipal, memories: YearBookMemory[]) {
    const ids = [...new Set(memories.flatMap((memory) => memory.assetIds))];
    const urls = new Map<string, string>();
    for (
      let start = 0;
      start < ids.length;
      start += MEDIA_POLICY.maxBatchAssets
    ) {
      const signed = await this.media.signViewUrls(actor, {
        assetIds: ids.slice(start, start + MEDIA_POLICY.maxBatchAssets),
      });
      for (const item of signed.items) {
        const url =
          item.urls.m1080 ??
          item.urls.t1280 ??
          item.urls.t640 ??
          item.urls.t320 ??
          Object.values(item.urls)[0];
        if (url) urls.set(item.assetId, url);
      }
    }
    return urls;
  }

  private memories(
    actor: AuthPrincipal,
    subject: YearBookSubject,
    year: number,
  ) {
    return this.repository.memories(
      subject,
      actor.userId,
      yearStart(year),
      yearStart(year + 1),
      YEAR_BOOK_POLICY.maxMemoriesPerYear,
    );
  }

  private async child(
    actor: AuthPrincipal,
    childId: string,
    year: number,
    mode: 'read' | 'write',
  ): Promise<YearBookSubject> {
    validYear(year);
    const child = await this.repository.child(childId);
    if (!child) throw new NotFoundError('Child was not found.');
    await this.access.requireParent(actor, child.familyId, mode);
    return inTimeline(child, year);
  }

  private async family(
    actor: AuthPrincipal,
    familyId: string,
    year: number,
    mode: 'read' | 'write',
  ): Promise<YearBookSubject> {
    validYear(year);
    await this.access.requireParent(actor, familyId, mode);
    const family = await this.repository.family(familyId);
    if (!family) throw new NotFoundError('Family was not found.');
    return inTimeline(family, year);
  }
}

function validYear(year: number) {
  if (!Number.isInteger(year) || year < YEAR_BOOK_POLICY.minYear)
    throw new ValidationError('year is invalid.');
}

function inTimeline(subject: YearBookSubject, year: number) {
  if (year < subject.firstYear || year > new Date().getUTCFullYear() + 1)
    throw new ValidationError('year is outside the timeline.');
  return subject;
}

function yearStart(year: number) {
  return new Date(Date.UTC(year, 0, 1));
}

function monthOf(memory: YearBookMemory) {
  return Number(memory.localDate.slice(5, 7));
}

function caption(memory: YearBookMemory) {
  const text = (memory.title ?? memory.body ?? '').trim();
  return text.slice(0, YEAR_BOOK_POLICY.captionMaxLength);
}

function item(
  memory: YearBookMemory,
  included: boolean,
  selected: string[],
  saved: string | null,
): Omit<YearBookItemDto, 'photos'> {
  return {
    memoryId: memory.id,
    kind: memory.kind,
    occurredAt: memory.occurredAt.toISOString(),
    caption: saved ?? caption(memory),
    assetIds: [...memory.assetIds],
    selectedAssetIds: selected,
    included,
  };
}

function canShare(plan: YearBookPlan) {
  return plan.share ?? plan.circle;
}

function canExport(plan: YearBookPlan) {
  if (plan.flag !== null) return plan.flag;
  return (
    plan.phase !== null &&
    (YEAR_BOOK_POLICY.exportPhasesWhenUndeclared as readonly string[]).includes(
      plan.phase,
    )
  );
}

/** Nội dung lưu không đúng cấu trúc (bản cũ / sửa tay) → coi như chưa lưu. */
function parseContent(value: unknown): SavedContent | null {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return null;
  const raw = value as Record<string, unknown>;
  if (!Array.isArray(raw.chapters)) return null;
  const text = (input: unknown) =>
    typeof input === 'string' && input ? input : null;
  return {
    version: typeof raw.version === 'number' ? raw.version : 1,
    title: text(raw.title),
    shared: raw.shared === true,
    chapters: raw.chapters.flatMap((chapter: unknown) => {
      if (!chapter || typeof chapter !== 'object') return [];
      const entry = chapter as Record<string, unknown>;
      if (typeof entry.month !== 'number' || !Array.isArray(entry.items))
        return [];
      return [
        {
          month: entry.month,
          title: text(entry.title),
          items: entry.items.flatMap((pick: unknown) => {
            if (!pick || typeof pick !== 'object') return [];
            const row = pick as Record<string, unknown>;
            if (typeof row.memoryId !== 'string') return [];
            return [
              {
                memoryId: row.memoryId,
                assetIds: Array.isArray(row.assetIds)
                  ? row.assetIds.filter(
                      (id): id is string => typeof id === 'string',
                    )
                  : [],
                caption: text(row.caption),
              },
            ];
          }),
        },
      ];
    }),
  };
}
