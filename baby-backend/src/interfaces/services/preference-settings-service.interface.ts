import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  AiSettingsResponseDto,
  NotificationSettingsResponseDto,
  UpdateAiSettingsDto,
  UpdateNotificationSettingsDto,
} from '../../dto/preferences/preference-settings.dto';

export const PREFERENCE_SETTINGS_SERVICE = Symbol(
  'PREFERENCE_SETTINGS_SERVICE',
);
export interface IPreferenceSettingsService {
  notificationSettings(
    actor: AuthPrincipal,
  ): Promise<NotificationSettingsResponseDto>;
  updateNotificationSettings(
    actor: AuthPrincipal,
    input: UpdateNotificationSettingsDto,
  ): Promise<NotificationSettingsResponseDto>;
  aiSettings(actor: AuthPrincipal): Promise<AiSettingsResponseDto>;
  updateAiSettings(
    actor: AuthPrincipal,
    input: UpdateAiSettingsDto,
  ): Promise<AiSettingsResponseDto>;
}
