import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import { DAY_STORY_POLICY } from '../config/day-story-policy';
import type {
  DayStoryDto,
  SaveDayStoryDto,
  SavedDayStoryDto,
} from '../dto/day-story/day-story.dto';
import { DAY_STORY_RECAP_REPOSITORY } from '../interfaces/repositories/day-story-recap-repository.interface';
import type { IDayStoryRecapRepository } from '../interfaces/repositories/day-story-recap-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IDayStoryRecapService } from '../interfaces/services/day-story-recap-service.interface';
import type {
  DayStoryChild,
  SavedDayStory,
} from '../models/day-story-recap.model';

const DAY = /^\d{4}-\d{2}-\d{2}$/;

const toDto = (story: SavedDayStory): SavedDayStoryDto => ({
  id: story.id,
  title: story.title,
  body: story.body,
  coverAssetId: story.coverAssetId,
  memoryIds: [...story.memoryIds],
  assetIds: [...story.assetIds],
  visibility: story.visibility,
  updatedAt: story.updatedAt.toISOString(),
});

/**
 * REC-01 Câu chuyện ngày (BF-20261028-006, bản không AI): Parent gom ký ức
 * một ngày của bé thành câu chuyện — tự viết tiêu đề, đoạn văn, chọn ảnh từ
 * chính các ký ức trong ngày. Mỗi bé + ngày một câu chuyện (lưu lại thì đè).
 * Ảnh/ký ức chỉ nhận từ đúng ngày đó và người lưu được xem.
 */
@Injectable()
export class DayStoryRecapService implements IDayStoryRecapService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(DAY_STORY_RECAP_REPOSITORY)
    private readonly repository: IDayStoryRecapRepository,
  ) {}

  async get(
    actor: AuthPrincipal,
    childId: string,
    date?: string,
  ): Promise<DayStoryDto> {
    const { child, today } = await this.child(actor, childId, 'read');
    const day = date ?? today;
    this.assertDay(day, today);
    const [memories, saved] = await Promise.all([
      this.repository.memories(
        child,
        actor.userId,
        day,
        DAY_STORY_POLICY.maxMemories,
      ),
      this.repository.saved(child.id, day),
    ]);
    return {
      childId: child.id,
      date: day,
      memories: memories.map((memory) => ({
        memoryId: memory.id,
        kind: memory.kind,
        title: memory.title ?? memory.body?.slice(0, 120) ?? null,
        occurredAt: memory.occurredAt.toISOString(),
        assetIds: [...memory.assetIds],
      })),
      saved: saved ? toDto(saved) : null,
    };
  }

  async save(
    actor: AuthPrincipal,
    childId: string,
    date: string,
    input: SaveDayStoryDto,
  ): Promise<SavedDayStoryDto> {
    const { child, today } = await this.child(actor, childId, 'write');
    this.assertDay(date, today);
    const title = input.title.trim();
    if (!title) throw new ValidationError('title is required.');
    const memories = await this.repository.memories(
      child,
      actor.userId,
      date,
      DAY_STORY_POLICY.maxMemories,
    );
    const memoryIds = new Set(memories.map((memory) => memory.id));
    const assetIds = new Set(memories.flatMap((memory) => memory.assetIds));
    const chosenMemories = [...new Set(input.memoryIds)];
    const chosenAssets = [...new Set(input.assetIds)];
    if (
      chosenMemories.some((id) => !memoryIds.has(id)) ||
      chosenAssets.some((id) => !assetIds.has(id))
    )
      throw new ValidationError('Memories and photos must come from this day.');
    const cover = input.coverAssetId ?? chosenAssets[0] ?? null;
    if (cover !== null && !chosenAssets.includes(cover))
      throw new ValidationError('coverAssetId must be one of assetIds.');
    return toDto(
      await this.repository.upsert(
        child,
        date,
        {
          title,
          body: input.body?.trim() || null,
          coverAssetId: cover,
          memoryIds: chosenMemories,
          assetIds: chosenAssets,
          visibility: input.visibility,
        },
        actor.userId,
      ),
    );
  }

  async remove(
    actor: AuthPrincipal,
    childId: string,
    date: string,
  ): Promise<void> {
    const { child, today } = await this.child(actor, childId, 'write');
    this.assertDay(date, today);
    await this.repository.remove(child.id, date);
  }

  /** Câu chuyện ngày là việc của bố mẹ (đọc toàn bộ ký ức trong ngày). */
  private async child(
    actor: AuthPrincipal,
    childId: string,
    mode: 'read' | 'write',
  ): Promise<{ child: DayStoryChild; today: string }> {
    const child = await this.repository.child(childId);
    if (!child) throw new NotFoundError('Child was not found.');
    const family = await this.access.requireParent(actor, child.familyId, mode);
    const today = new Intl.DateTimeFormat('en-CA', {
      timeZone: family.timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).format(new Date());
    return { child, today };
  }

  private assertDay(day: string, today: string) {
    const parsed = new Date(`${day}T00:00:00.000Z`);
    if (
      !DAY.test(day) ||
      Number.isNaN(parsed.getTime()) ||
      parsed.toISOString().slice(0, 10) !== day ||
      day > today
    )
      throw new ValidationError('date must be a past or current YYYY-MM-DD.');
  }
}
