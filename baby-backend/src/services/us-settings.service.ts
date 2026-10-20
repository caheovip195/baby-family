import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import {
  MOOD_SHARE_DEFAULTS,
  UsSettingsResponseDto,
} from '../dto/us-settings/us-settings.dto';
import type { UpdateUsSettingsDto } from '../dto/us-settings/us-settings.dto';
import { US_SETTINGS_REPOSITORY } from '../interfaces/repositories/us-settings-repository.interface';
import type { IUsSettingsRepository } from '../interfaces/repositories/us-settings-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IUsSettingsService } from '../interfaces/services/us-settings-service.interface';

@Injectable()
export class UsSettingsService implements IUsSettingsService {
  constructor(
    @Inject(US_SETTINGS_REPOSITORY)
    private readonly repository: IUsSettingsRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async getMe(actor: AuthPrincipal): Promise<UsSettingsResponseDto> {
    await this.requireParent(actor);
    const settings = await this.repository.findSettings(actor.userId);
    if (!settings) throw new NotFoundError('User settings were not found.');
    return UsSettingsResponseDto.fromModel(settings);
  }

  async updateMe(
    actor: AuthPrincipal,
    input: UpdateUsSettingsDto,
  ): Promise<UsSettingsResponseDto> {
    await this.requireParent(actor);
    const data: UpdateUsSettingsDto = {};
    for (const key of [
      'usLockEnabled',
      'requestSoonBypassQuiet',
      'hideSensitivePreview',
    ] as const) {
      if (input[key] !== undefined) {
        if (typeof input[key] !== 'boolean')
          throw new ValidationError('Settings flags must be booleans.');
        data[key] = input[key];
      }
    }
    if (input.moodShareDefault !== undefined) {
      if (!MOOD_SHARE_DEFAULTS.includes(input.moodShareDefault))
        throw new ValidationError('Mood sharing must be ASK, ALWAYS or NEVER.');
      data.moodShareDefault = input.moodShareDefault;
    }
    if (!Object.keys(data).length)
      throw new ValidationError(
        'Provide at least one supported settings field.',
      );
    const settings = await this.repository.updateSettings(actor.userId, data);
    if (!settings) throw new NotFoundError('User settings were not found.');
    return UsSettingsResponseDto.fromModel(settings);
  }

  private async requireParent(actor: AuthPrincipal): Promise<void> {
    const parent = await this.repository.findActiveParent(actor.userId);
    if (!parent)
      throw new DomainError(
        'An active family Parent is required.',
        'PARENT_REQUIRED',
        403,
      );
    // Privacy preferences remain accessible without requiring a paid subscription.
    const family = await this.access.requireParent(
      actor,
      parent.familyId,
      'metadata',
    );
    if (family.status !== 'ACTIVE')
      throw new DomainError(
        'The family is not active.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
  }
}
