import type {
  TimelineMonthlyCover,
  TimelineMonthCounts,
  TimelineWeeklyRecap,
} from '../../models/timeline-card-data.model';

export const TIMELINE_CARD_REPOSITORY = Symbol('TIMELINE_CARD_REPOSITORY');
export interface ITimelineCardRepository {
  monthlyCovers(
    familyId: string,
    userId: string,
    childId: string,
  ): Promise<TimelineMonthlyCover[]>;
  monthCounts(
    familyId: string,
    userId: string,
    childId: string,
  ): Promise<TimelineMonthCounts[]>;
  weeklyRecaps(
    familyId: string,
    userId: string,
    childId?: string,
  ): Promise<TimelineWeeklyRecap[]>;
}
