import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import { NOTIFICATION_POLICY } from '../config/notification-policy';
import { PREFERENCE_SETTINGS_POLICY as POLICY } from '../config/preference-settings-policy';
import type {
  AiSettingsResponseDto,
  NotificationSettingsResponseDto,
  UpdateAiSettingsDto,
  UpdateNotificationSettingsDto,
} from '../dto/preferences/preference-settings.dto';
import { PREFERENCE_SETTINGS_REPOSITORY } from '../interfaces/repositories/preference-settings-repository.interface';
import type {
  IPreferenceSettingsRepository,
  PreferenceSettingsPatch,
} from '../interfaces/repositories/preference-settings-repository.interface';
import type { IPreferenceSettingsService } from '../interfaces/services/preference-settings-service.interface';
import type { UserSetting } from '../models/user-setting.model';

type JsonObject = Record<string, unknown>;

function object(value: unknown): JsonObject {
  return value && typeof value === 'object' && !Array.isArray(value)
    ? { ...(value as JsonObject) }
    : {};
}

const hhmm = (value: Date) => value.toISOString().slice(11, 16);

/**
 * SET notification / AI settings of the caller (Parent or Circle), stored on
 * `user_settings`. Category switches live in `notification_prefs.categories`,
 * the shape notification dispatch already reads; other keys (muted users,
 * legacy aliases) are preserved.
 */
@Injectable()
export class PreferenceSettingsService implements IPreferenceSettingsService {
  constructor(
    @Inject(PREFERENCE_SETTINGS_REPOSITORY)
    private readonly repository: IPreferenceSettingsRepository,
  ) {}

  async notificationSettings(
    actor: AuthPrincipal,
  ): Promise<NotificationSettingsResponseDto> {
    return this.notificationView(await this.settings(actor));
  }

  async updateNotificationSettings(
    actor: AuthPrincipal,
    input: UpdateNotificationSettingsDto,
  ): Promise<NotificationSettingsResponseDto> {
    const current = await this.settings(actor);
    const patch: PreferenceSettingsPatch = {};
    if (input.categories !== undefined) {
      const allowed: readonly string[] = POLICY.notificationCategories;
      const prefs = object(current.notificationPrefs);
      const categories = object(prefs.categories);
      for (const [key, value] of Object.entries(input.categories)) {
        if (!allowed.includes(key))
          throw new ValidationError(`Unknown notification category: ${key}.`);
        if (typeof value !== 'boolean')
          throw new ValidationError('Category switches must be booleans.');
        categories[key] = value;
      }
      patch.notificationPrefs = {
        ...prefs,
        version: POLICY.version,
        categories,
      } as PreferenceSettingsPatch['notificationPrefs'];
    }
    for (const key of [
      'quietStart',
      'quietEnd',
      'circleDigestTime',
      'circleDigestMode',
    ] as const)
      if (input[key] !== undefined) patch[key] = input[key];
    if (input.hideSensitivePreview !== undefined)
      patch.hideSensitivePreview = input.hideSensitivePreview;
    return this.notificationView(await this.save(actor, patch));
  }

  async aiSettings(actor: AuthPrincipal): Promise<AiSettingsResponseDto> {
    return this.aiView(await this.settings(actor));
  }

  async updateAiSettings(
    actor: AuthPrincipal,
    input: UpdateAiSettingsDto,
  ): Promise<AiSettingsResponseDto> {
    const current = await this.settings(actor);
    const patch: PreferenceSettingsPatch = {};
    if (input.aiEnabled !== undefined) patch.aiEnabled = input.aiEnabled;
    if (input.features !== undefined) {
      const allowed: readonly string[] = POLICY.aiFeatures;
      const features = object(current.aiFeatures);
      for (const [key, value] of Object.entries(input.features)) {
        if (!allowed.includes(key))
          throw new ValidationError(`Unknown AI feature: ${key}.`);
        if (typeof value !== 'boolean')
          throw new ValidationError('AI feature switches must be booleans.');
        features[key] = value;
      }
      patch.aiFeatures = {
        ...features,
        version: POLICY.version,
      };
    }
    return this.aiView(await this.save(actor, patch));
  }

  private async settings(actor: AuthPrincipal): Promise<UserSetting> {
    const settings = await this.repository.findOrCreate(actor.userId);
    if (!settings) throw new NotFoundError('User settings were not found.');
    return settings;
  }

  private async save(
    actor: AuthPrincipal,
    patch: PreferenceSettingsPatch,
  ): Promise<UserSetting> {
    if (!Object.keys(patch).length)
      throw new ValidationError(
        'Provide at least one supported settings field.',
      );
    const saved = await this.repository.update(actor.userId, patch);
    if (!saved) throw new NotFoundError('User settings were not found.');
    return saved;
  }

  private notificationView(
    settings: UserSetting,
  ): NotificationSettingsResponseDto {
    const prefs = object(settings.notificationPrefs);
    const nested = object(prefs.categories);
    const categories: Record<string, boolean> = {};
    for (const category of POLICY.notificationCategories) {
      // Same precedence as dispatch: legacy alias `false` wins.
      const keys = [category, ...NOTIFICATION_POLICY.categoryAliases[category]];
      const values = keys.flatMap((key) => [nested[key], prefs[key]]);
      categories[category] = values.includes(false)
        ? false
        : values.includes(true)
          ? true
          : NOTIFICATION_POLICY.categoryDefaults[category];
    }
    return {
      policyVersion: POLICY.version,
      quietStart: hhmm(settings.quietStart),
      quietEnd: hhmm(settings.quietEnd),
      hideSensitivePreview: settings.hideSensitivePreview,
      categories,
      circleDigestMode: settings.circleDigestMode,
      circleDigestTime: hhmm(settings.circleDigestTime),
    };
  }

  private aiView(settings: UserSetting): AiSettingsResponseDto {
    const stored = object(settings.aiFeatures);
    return {
      policyVersion: POLICY.version,
      aiEnabled: settings.aiEnabled,
      features: Object.fromEntries(
        POLICY.aiFeatures.map((key) => [
          key,
          typeof stored[key] === 'boolean'
            ? stored[key]
            : POLICY.aiFeatureDefault,
        ]),
      ),
    };
  }
}
