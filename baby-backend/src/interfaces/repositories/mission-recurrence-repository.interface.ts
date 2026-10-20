import type { MissionSeriesModel } from '../../models/mission-recurrence.model';

export const MISSION_RECURRENCE_REPOSITORY = Symbol(
  'MISSION_RECURRENCE_REPOSITORY',
);

export type MissionSeriesRow = MissionSeriesModel;

export interface CreateMissionSeriesInput {
  familyId: string;
  createdBy: string;
  ownerKind: 'PARENT' | 'TOGETHER';
  title: string;
  note: string | null;
  category: string;
  targetScope: string;
  childIds: string[];
  timeOfDay: Date | null;
  startDate: Date;
  endDate: Date | null;
  rrule: string;
  timezone: string;
}

export interface IMissionRecurrenceRepository {
  /** Family timezone, active children ids and whether the couple space is on. */
  familyContext(familyId: string): Promise<{
    timezone: string;
    childIds: string[];
    coupleActive: boolean;
  } | null>;
  create(input: CreateMissionSeriesInput): Promise<MissionSeriesRow>;
  list(familyId: string): Promise<MissionSeriesRow[]>;
  find(id: string): Promise<MissionSeriesRow | null>;
  pause(id: string, ranges: { from: string; to: string }[]): Promise<void>;
  /** Ends the series; TODO missions from `fromDate` on are removed. */
  end(id: string, fromDate: Date): Promise<void>;
}
