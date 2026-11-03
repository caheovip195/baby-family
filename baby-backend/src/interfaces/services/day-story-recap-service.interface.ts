import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  DayStoryDto,
  SaveDayStoryDto,
  SavedDayStoryDto,
} from '../../dto/day-story/day-story.dto';

export const DAY_STORY_RECAP_SERVICE = Symbol('DAY_STORY_RECAP_SERVICE');

export interface IDayStoryRecapService {
  get(
    actor: AuthPrincipal,
    childId: string,
    date?: string,
  ): Promise<DayStoryDto>;
  save(
    actor: AuthPrincipal,
    childId: string,
    date: string,
    input: SaveDayStoryDto,
  ): Promise<SavedDayStoryDto>;
  remove(actor: AuthPrincipal, childId: string, date: string): Promise<void>;
}
