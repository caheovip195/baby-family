import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import { MEMORY_POLICY } from '../../config/memory-policy';
const optional = (_object: object, value: unknown) => value !== undefined;
export const TIMELINE_FILTERS = [
  'ALL',
  'MILESTONE',
  'MEDIA',
  'DIARY',
  'LETTER',
  'PREGNANCY',
] as const;
export type TimelineFilter = (typeof TIMELINE_FILTERS)[number];
export class TimelineQueryDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf(optional)
  @IsUUID()
  childId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf(optional)
  @IsUUID()
  pregnancyId?: string;

  @ApiPropertyOptional({ enum: TIMELINE_FILTERS, default: 'ALL' })
  @ValidateIf(optional)
  @IsIn(TIMELINE_FILTERS)
  filter?: TimelineFilter;

  @ApiPropertyOptional({ description: 'Opaque cursor from nextCursor.' })
  @ValidateIf(optional)
  @IsString()
  @MaxLength(500)
  cursor?: string;

  @ApiPropertyOptional({
    minimum: 1,
    maximum: MEMORY_POLICY.timelineMaxLimit,
    default: MEMORY_POLICY.timelineDefaultLimit,
  })
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MEMORY_POLICY.timelineMaxLimit)
  limit?: number;
}
