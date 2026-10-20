import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsIn, ValidateIf } from 'class-validator';
import type { UserSetting } from '../../models/user-setting.model';

export const MOOD_SHARE_DEFAULTS = ['ASK', 'ALWAYS', 'NEVER'] as const;
export type MoodShareDefault = (typeof MOOD_SHARE_DEFAULTS)[number];

export class UpdateUsSettingsDto {
  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  usLockEnabled?: boolean;

  @ApiPropertyOptional({ enum: MOOD_SHARE_DEFAULTS })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(MOOD_SHARE_DEFAULTS)
  moodShareDefault?: MoodShareDefault;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  requestSoonBypassQuiet?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  hideSensitivePreview?: boolean;
}

export class UsSettingsResponseDto {
  @ApiProperty() usLockEnabled!: boolean;
  @ApiProperty({ enum: MOOD_SHARE_DEFAULTS }) moodShareDefault!: string;
  @ApiProperty() requestSoonBypassQuiet!: boolean;
  @ApiProperty() hideSensitivePreview!: boolean;

  static fromModel(model: UserSetting): UsSettingsResponseDto {
    return Object.assign(new UsSettingsResponseDto(), {
      usLockEnabled: model.usLockEnabled,
      moodShareDefault: model.moodShareDefault,
      requestSoonBypassQuiet: model.requestSoonBypassQuiet,
      hideSensitivePreview: model.hideSensitivePreview,
    });
  }
}
