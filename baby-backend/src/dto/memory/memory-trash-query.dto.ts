import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsInt,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import { MEMORY_POLICY } from '../../config/memory-policy';

const optional = (_object: object, value: unknown) => value !== undefined;

/** `GET /families/{fid}/trash?cursor&limit` (MEM-17). */
export class MemoryTrashQueryDto {
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
