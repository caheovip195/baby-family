import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, ValidateIf } from 'class-validator';
import { TIMEZONE_CATALOG } from '../../config/timezone-catalog';

export class TimezoneCatalogQueryDto {
  @ApiPropertyOptional({ enum: TIMEZONE_CATALOG.locales, default: 'vi' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(TIMEZONE_CATALOG.locales)
  locale?: 'vi' | 'en';
}

export interface TimezoneCatalogResponseDto {
  version: string;
  items: { id: string; label: string; offsetMinutes: number }[];
}
