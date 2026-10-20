import type { MissionPreferenceModel } from '../../models/mission-recurrence.model';

export const MISSION_CONFIG_REPOSITORY = Symbol('MISSION_CONFIG_REPOSITORY');

export interface MissionPreferencePatch {
  disabledCategories?: string[];
  boardPushTime?: Date;
  eveningCarryOver?: boolean;
  defaultReminderMin?: number | null;
}

export interface IMissionConfigRepository {
  boardLevel(familyId: string): Promise<'LIGHT' | 'MEDIUM' | 'HEAVY' | null>;
  saveBoardLevel(
    familyId: string,
    userId: string,
    level: 'LIGHT' | 'MEDIUM' | 'HEAVY',
  ): Promise<void>;
  preference(
    familyId: string,
    userId: string,
  ): Promise<MissionPreferenceModel | null>;
  savePreference(
    familyId: string,
    userId: string,
    patch: MissionPreferencePatch,
  ): Promise<void>;
}
