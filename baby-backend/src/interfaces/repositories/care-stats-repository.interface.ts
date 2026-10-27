import type { CareStatsSnapshot } from '../../models/care-stats-snapshot.model';

export const CARE_STATS_REPOSITORY = Symbol('CARE_STATS_REPOSITORY');

export interface ICareStatsRepository {
  /** Null means the requested child is absent/deleted or outside this family. */
  readWeek(
    familyId: string,
    weekStart: Date,
    weekEndExclusive: Date,
    childId?: string,
  ): Promise<CareStatsSnapshot | null>;
}
