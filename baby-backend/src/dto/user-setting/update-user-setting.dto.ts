import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsIn,
  IsNumber,
  Max,
  Min,
  ValidateIf,
} from 'class-validator';

export class UpdateUserSettingDto {
  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  hideSensitivePreview?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  requestSoonBypassQuiet?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  usLockEnabled?: boolean;

  @ApiPropertyOptional({ enum: ['SYSTEM', 'LIGHT', 'DARK'] })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(['SYSTEM', 'LIGHT', 'DARK'])
  theme?: string;

  @ApiPropertyOptional({ minimum: 0.8, maximum: 2 })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0.8)
  @Max(2)
  textScale?: number;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  showLunar?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  memoryPromptsEnabled?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  perspectiveSuggest?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  dailyStorySuggest?: boolean;
}
