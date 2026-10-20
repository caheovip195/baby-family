import type { DatabaseJsonValue } from '../../common/database.types';
import type { UserSetting } from '../../models/user-setting.model';

export const PREFERENCE_SETTINGS_REPOSITORY = Symbol(
  'PREFERENCE_SETTINGS_REPOSITORY',
);

/** Already-validated column values; `HH:mm` times are stored as `time`. */
export interface PreferenceSettingsPatch {
  notificationPrefs?: DatabaseJsonValue;
  quietStart?: string;
  quietEnd?: string;
  hideSensitivePreview?: boolean;
  circleDigestMode?: string;
  circleDigestTime?: string;
  aiEnabled?: boolean;
  aiFeatures?: DatabaseJsonValue;
}

export interface IPreferenceSettingsRepository {
  /** The caller's row, created with column defaults when missing. */
  findOrCreate(userId: string): Promise<UserSetting | null>;
  update(
    userId: string,
    patch: PreferenceSettingsPatch,
  ): Promise<UserSetting | null>;
}
