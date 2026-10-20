import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsIn,
  IsObject,
  Matches,
  ValidateIf,
} from 'class-validator';
import { PREFERENCE_SETTINGS_POLICY } from '../../config/preference-settings-policy';
import type { CircleDigestMode } from '../../config/preference-settings-policy';

const HH_MM = /^([01]\d|2[0-3]):[0-5]\d$/;

export class UpdateNotificationSettingsDto {
  @ApiPropertyOptional({ example: '22:00' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @Matches(HH_MM)
  quietStart?: string;

  @ApiPropertyOptional({ example: '06:30' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @Matches(HH_MM)
  quietEnd?: string;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  hideSensitivePreview?: boolean;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'boolean' },
  })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsObject()
  categories?: Record<string, boolean>;

  @ApiPropertyOptional({ enum: PREFERENCE_SETTINGS_POLICY.circleDigestModes })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(PREFERENCE_SETTINGS_POLICY.circleDigestModes)
  circleDigestMode?: CircleDigestMode;

  @ApiPropertyOptional({ example: '19:00' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @Matches(HH_MM)
  circleDigestTime?: string;
}

export class NotificationSettingsResponseDto {
  @ApiProperty() policyVersion!: number;
  @ApiProperty() quietStart!: string;
  @ApiProperty() quietEnd!: string;
  @ApiProperty() hideSensitivePreview!: boolean;
  @ApiProperty({ type: 'object', additionalProperties: { type: 'boolean' } })
  categories!: Record<string, boolean>;
  @ApiProperty({ enum: PREFERENCE_SETTINGS_POLICY.circleDigestModes })
  circleDigestMode!: string;
  @ApiProperty() circleDigestTime!: string;
}

export class UpdateAiSettingsDto {
  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  aiEnabled?: boolean;

  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'boolean' },
  })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsObject()
  features?: Record<string, boolean>;
}

export class AiSettingsResponseDto {
  @ApiProperty() policyVersion!: number;
  @ApiProperty() aiEnabled!: boolean;
  @ApiProperty({ type: 'object', additionalProperties: { type: 'boolean' } })
  features!: Record<string, boolean>;
}
