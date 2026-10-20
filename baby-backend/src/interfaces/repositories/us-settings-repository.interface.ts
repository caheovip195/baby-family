import type { UpdateUsSettingsDto } from '../../dto/us-settings/us-settings.dto';
import type { FamilyParent } from '../../models/family-parent.model';
import type { UserSetting } from '../../models/user-setting.model';

export const US_SETTINGS_REPOSITORY = Symbol('US_SETTINGS_REPOSITORY');
export interface IUsSettingsRepository {
  findActiveParent(userId: string): Promise<FamilyParent | null>;
  findSettings(userId: string): Promise<UserSetting | null>;
  updateSettings(
    userId: string,
    input: UpdateUsSettingsDto,
  ): Promise<UserSetting | null>;
}
