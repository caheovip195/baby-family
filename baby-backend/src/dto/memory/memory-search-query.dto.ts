import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsISO8601,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
} from 'class-validator';
import { MemoryKind } from '../../common/database.enums';
import { MEMORY_POLICY } from '../../config/memory-policy';
import type { MemoryResponseDto } from './memory-response.dto';

const optional = (_object: object, value: unknown) => value !== undefined;

/** `GET /families/{fid}/search?q&childId&kind&cursor&limit` (MEM-15). */
export class MemorySearchQueryDto {
  @ApiProperty({ minLength: 2, maxLength: 100 })
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  q!: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf(optional)
  @IsUUID()
  childId?: string;

  @ApiPropertyOptional({ enum: Object.values(MemoryKind) })
  @ValidateIf(optional)
  @IsIn(Object.values(MemoryKind))
  kind?: MemoryKind;

  @ApiPropertyOptional({ description: 'Opaque cursor from `nextCursor`.' })
  @ValidateIf(optional)
  @IsString()
  @MaxLength(200)
  cursor?: string;

  @ApiPropertyOptional({
    minimum: 1,
    maximum: MEMORY_POLICY.feedMaxLimit,
    default: MEMORY_POLICY.feedDefaultLimit,
  })
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MEMORY_POLICY.feedMaxLimit)
  limit?: number;
}

/** `GET /families/{fid}/on-this-day?date=YYYY-MM-DD` (MEM-16). */
export class OnThisDayQueryDto {
  @ApiPropertyOptional({ example: '2026-10-19' })
  @ValidateIf(optional)
  @IsISO8601({ strict: true })
  @MaxLength(10)
  date?: string;
}

export class OnThisDayGroupDto {
  @ApiProperty() yearsAgo!: number;
  @ApiProperty({ example: '2025-10-19' }) date!: string;
  @ApiProperty({ type: Object, isArray: true }) memories!: MemoryResponseDto[];
}

export class OnThisDayResponseDto {
  @ApiProperty({ example: '2026-10-19' }) date!: string;
  @ApiProperty({ type: OnThisDayGroupDto, isArray: true })
  groups!: OnThisDayGroupDto[];
}

/** `GET /children/{id}/today-story?date=YYYY-MM-DD` (MEM-25). */
export class TodayStoryQueryDto {
  @ApiPropertyOptional({ example: '2026-10-19' })
  @ValidateIf(optional)
  @IsISO8601({ strict: true })
  @MaxLength(10)
  date?: string;
}

export class TodayStorySlideDto {
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty({ enum: ['IMAGE', 'VIDEO'] }) kind!: string;
  /** Ảnh lớn nhất / poster (VIDEO) — URL ký ngắn hạn. */
  @ApiProperty() imageUrl!: string;
  @ApiProperty({ type: String, nullable: true }) videoUrl!: string | null;
  @ApiProperty({ type: String, nullable: true }) caption!: string | null;
  @ApiProperty() occurredAt!: string;
}

export class TodayStoryResponseDto {
  @ApiProperty({ example: '2026-10-19' }) date!: string;
  @ApiProperty({ format: 'uuid' }) childId!: string;
  @ApiProperty() memoryCount!: number;
  @ApiProperty({ type: TodayStorySlideDto, isArray: true })
  slides!: TodayStorySlideDto[];
}
