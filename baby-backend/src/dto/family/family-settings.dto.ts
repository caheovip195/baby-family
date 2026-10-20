import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsIn, ValidateIf } from 'class-validator';
import type { Visibility } from '../../common/database.enums';
import { FAMILY_SETTINGS_POLICY } from '../../config/family-settings-policy';

export class UpdateFamilySettingsDto {
  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  showLunar?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  circleCanSeeTree?: boolean;

  @ApiPropertyOptional({
    nullable: true,
    enum: FAMILY_SETTINGS_POLICY.fields.defaultVisibility.values,
  })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn([...FAMILY_SETTINGS_POLICY.fields.defaultVisibility.values, null])
  defaultVisibility?: Visibility | null;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  requireCircleReview?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  traditionalUseLunar?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  milestoneSuggestions?: boolean;
}

export interface FamilySettingsResponseDto {
  showLunar: boolean;
  circleCanSeeTree?: boolean;
  defaultVisibility?: Visibility | null;
  requireCircleReview?: boolean;
  traditionalUseLunar?: boolean;
  milestoneSuggestions?: boolean;
}
