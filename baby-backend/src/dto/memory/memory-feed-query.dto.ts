import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
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

/** `GET /families/{fid}/feed?childId|pregnancyId&cursor&limit` (spec §11.3). */
export class MemoryFeedQueryDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf(optional)
  @IsUUID()
  childId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf(optional)
  @IsUUID()
  pregnancyId?: string;

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
