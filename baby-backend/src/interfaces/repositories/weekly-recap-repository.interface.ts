import type { Recap } from '../../models/recap.model';
import type { WeeklyRecapData } from '../../models/weekly-recap-data.model';
import type { JobContext } from '../services/job-runner-service.interface';
export const WEEKLY_RECAP_REPOSITORY = Symbol('WEEKLY_RECAP_REPOSITORY');
export interface IWeeklyRecapRepository {
  families(
    after?: string,
  ): Promise<{ id: string; timezone: string; createdAt: Date }[]>;
  aggregate(
    familyId: string,
    start: string,
    end: string,
    timezone: string,
    viewer?: { userId: string; isParent: boolean; includePrivate?: boolean },
  ): Promise<WeeklyRecapData>;
  save(
    familyId: string,
    start: string,
    end: string,
    data: WeeklyRecapData,
    context: JobContext,
  ): Promise<void>;
  list(
    familyId: string,
    circle: boolean,
    cursor: string | undefined,
    limit: number,
  ): Promise<Recap[]>;
}
