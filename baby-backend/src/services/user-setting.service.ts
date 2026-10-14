import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import type { UpdateUserSettingDto } from '../dto/user-setting/update-user-setting.dto';
import { UserSettingResponseDto } from '../dto/user-setting/user-setting-response.dto';
import { USER_SETTING_REPOSITORY } from '../interfaces/repositories/user-setting-repository.interface';
import type {
  IUserSettingRepository,
  UpdateUserSettingInput,
} from '../interfaces/repositories/user-setting-repository.interface';
import type { IUserSettingService } from '../interfaces/services/user-setting-service.interface';

@Injectable()
export class UserSettingService implements IUserSettingService {
  constructor(
    @Inject(USER_SETTING_REPOSITORY)
    private readonly repository: IUserSettingRepository,
  ) {}

  async getMe(actor: AuthPrincipal): Promise<UserSettingResponseDto> {
    const setting = await this.repository.findByKey(
      { userId: actor.userId },
      { userId: actor.userId },
    );
    if (!setting) throw new NotFoundError('User settings were not found.');
    return UserSettingResponseDto.fromModel(setting);
  }

  async updateMe(
    actor: AuthPrincipal,
    input: UpdateUserSettingDto,
  ): Promise<UserSettingResponseDto> {
    const data: UpdateUserSettingInput = {};
    const booleanFields = [
      'hideSensitivePreview',
      'requestSoonBypassQuiet',
      'usLockEnabled',
      'showLunar',
      'memoryPromptsEnabled',
      'perspectiveSuggest',
      'dailyStorySuggest',
    ] as const;
    for (const key of booleanFields) {
      const value = input[key];
      if (value !== undefined) {
        if (typeof value !== 'boolean')
          throw new ValidationError('Settings flags must be booleans.');
        data[key] = value;
      }
    }
    if (input.theme !== undefined) {
      if (!['SYSTEM', 'LIGHT', 'DARK'].includes(input.theme))
        throw new ValidationError('Theme must be SYSTEM, LIGHT or DARK.');
      data.theme = input.theme;
    }
    if (input.textScale !== undefined) {
      if (
        typeof input.textScale !== 'number' ||
        !Number.isFinite(input.textScale) ||
        input.textScale < 0.8 ||
        input.textScale > 2 ||
        Number(input.textScale.toFixed(2)) !== input.textScale
      )
        throw new ValidationError(
          'Text scale must be between 0.8 and 2 with at most two decimal places.',
        );
      data.textScale = input.textScale.toFixed(2);
    }
    if (!Object.keys(data).length)
      throw new ValidationError(
        'Provide at least one supported settings field.',
      );
    const setting = await this.repository.update(
      { userId: actor.userId },
      { userId: actor.userId },
      data,
    );
    if (!setting) throw new NotFoundError('User settings were not found.');
    return UserSettingResponseDto.fromModel(setting);
  }
}
