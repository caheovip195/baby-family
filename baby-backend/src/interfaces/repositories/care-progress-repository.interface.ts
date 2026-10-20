import type {
  CareHeartsSnapshot,
  CareFamilyTreeSnapshot,
  CareBadgeEvaluation,
} from '../../models/care-progress.model';
import type { CareMissionHistoryQueryDto } from '../../dto/care/care-mission-history.dto';
import type { Mission } from '../../models/mission.model';

export const CARE_PROGRESS_REPOSITORY = Symbol('CARE_PROGRESS_REPOSITORY');

export interface CareMissionHistoryRow {
  mission: Mission;
  childIds: string[];
  events: { type: string; createdAt: Date }[];
}

export interface ICareProgressRepository {
  getHeartsMe(
    familyId: string,
    userId: string,
    todayDate: Date,
    cursor?: string,
    limit?: number,
  ): Promise<CareHeartsSnapshot>;

  getFamilyTree(
    familyId: string,
    todayDate: Date,
    weekStartDate: Date,
    weekEndDate: Date,
  ): Promise<CareFamilyTreeSnapshot>;

  getBadges(familyId: string): Promise<CareBadgeEvaluation[]>;

  getMissionHistory(
    familyId: string,
    userId: string,
    query: CareMissionHistoryQueryDto,
  ): Promise<{ items: CareMissionHistoryRow[]; nextCursor: string | null }>;
}
