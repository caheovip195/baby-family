import type {
  DayStoryChild,
  DayStoryMemory,
  SavedDayStory,
} from '../../models/day-story-recap.model';

export const DAY_STORY_RECAP_REPOSITORY = Symbol('DAY_STORY_RECAP_REPOSITORY');

export interface DayStoryValues {
  title: string;
  body: string | null;
  coverAssetId: string | null;
  memoryIds: string[];
  assetIds: string[];
  visibility: 'PARENTS' | 'FAMILY';
}

export interface IDayStoryRecapRepository {
  child(childId: string): Promise<DayStoryChild | null>;

  /** Ký ức của bé trong ngày [date] (giờ gia đình) mà [userId] được xem. */
  memories(
    child: DayStoryChild,
    userId: string,
    date: string,
    limit: number,
  ): Promise<DayStoryMemory[]>;

  saved(childId: string, date: string): Promise<SavedDayStory | null>;

  /** Mỗi bé + ngày một câu chuyện: có rồi thì đè. */
  upsert(
    child: DayStoryChild,
    date: string,
    values: DayStoryValues,
    userId: string,
  ): Promise<SavedDayStory>;

  remove(childId: string, date: string): Promise<void>;
}
