import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsUUID, ValidateIf } from 'class-validator';

export class CareStatsQueryDto {
  @ApiPropertyOptional({ example: '2026-10-26' })
  @ValidateIf((_object: object, value: unknown) => value !== undefined)
  @IsString()
  weekStart?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf((_object: object, value: unknown) => value !== undefined)
  @IsUUID()
  childId?: string;
}

/** Family totals only. The app renders the fixed CARE-11 disclaimer. */
export interface CareStatsResponseDto {
  weekStart: string;
  /** Inclusive Sunday, in the family's calendar. */
  weekEnd: string;
  total: number;
  categories: { code: string; count: number }[];
  bloomDays: number;
  /** Monday through Sunday; unaffected by the child filter. */
  bloomed: boolean[];
}
