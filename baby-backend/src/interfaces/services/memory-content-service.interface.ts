import type {
  MemorySearchQueryDto,
  OnThisDayQueryDto,
  OnThisDayResponseDto,
  TodayStoryQueryDto,
  TodayStoryResponseDto,
} from '../../dto/memory/memory-search-query.dto';
import type { TimelineQueryDto } from '../../dto/memory/timeline-query.dto';
import type { TimelineResponseDto } from '../../dto/memory/timeline-response.dto';
import type { MediaGridQueryDto } from '../../dto/memory/media-grid-query.dto';
import type { MediaGridResponseDto } from '../../dto/memory/media-grid-response.dto';
import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { CreateMemoryDto } from '../../dto/memory/create-memory.dto';
import type { MemoryFeedQueryDto } from '../../dto/memory/memory-feed-query.dto';
import type { MemoryTrashQueryDto } from '../../dto/memory/memory-trash-query.dto';
import type { UpdateMemoryDto } from '../../dto/memory/update-memory.dto';
import type {
  MemoryFeedResponseDto,
  MemoryResponseDto,
} from '../../dto/memory/memory-response.dto';

export const MEMORY_CONTENT_SERVICE = Symbol('MEMORY_CONTENT_SERVICE');

/** Create and read memories for Parents (spec §6.3, §11.3, §11.5). */
export interface IMemoryContentService {
  drafts(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<MemoryFeedResponseDto>;
  publish(actor: AuthPrincipal, memoryId: string): Promise<MemoryResponseDto>;

  timeline(
    actor: AuthPrincipal,
    familyId: string,
    query: TimelineQueryDto,
  ): Promise<TimelineResponseDto>;
  mediaGrid(
    actor: AuthPrincipal,
    familyId: string,
    query: MediaGridQueryDto,
  ): Promise<MediaGridResponseDto>;

  create(
    actor: AuthPrincipal,
    idempotencyKey: string,
    input: CreateMemoryDto,
  ): Promise<MemoryResponseDto>;
  getById(actor: AuthPrincipal, memoryId: string): Promise<MemoryResponseDto>;
  feed(
    actor: AuthPrincipal,
    familyId: string,
    query: MemoryFeedQueryDto,
  ): Promise<MemoryFeedResponseDto>;
  /** MEM-15. */
  search(
    actor: AuthPrincipal,
    familyId: string,
    query: MemorySearchQueryDto,
  ): Promise<MemoryFeedResponseDto>;
  /** MEM-25. */
  todayStory(
    actor: AuthPrincipal,
    childId: string,
    query: TodayStoryQueryDto,
  ): Promise<TodayStoryResponseDto>;
  /** MEM-16. */
  onThisDay(
    actor: AuthPrincipal,
    familyId: string,
    query: OnThisDayQueryDto,
  ): Promise<OnThisDayResponseDto>;
  /** MEM-09 with `If-Match` version (412 VERSION_CONFLICT when stale). */
  update(
    actor: AuthPrincipal,
    memoryId: string,
    expectedVersion: number,
    input: UpdateMemoryDto,
  ): Promise<MemoryResponseDto>;
  /** MEM-07 “Xoá”: author or Parent → trash for 30 days; idempotent. */
  trash(actor: AuthPrincipal, memoryId: string): Promise<void>;
  /** MEM-17 list, most recently trashed first. */
  listTrash(
    actor: AuthPrincipal,
    familyId: string,
    query: MemoryTrashQueryDto,
  ): Promise<MemoryFeedResponseDto>;
  restore(actor: AuthPrincipal, memoryId: string): Promise<MemoryResponseDto>;
  /** MEM-17 “Xoá vĩnh viễn”. */
  purge(actor: AuthPrincipal, memoryId: string): Promise<void>;
}
