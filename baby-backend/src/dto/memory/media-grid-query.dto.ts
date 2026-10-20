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
export class MediaGridQueryDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf(optional)
  @IsUUID()
  childId?: string;

  @ApiPropertyOptional({ enum: ['IMAGE', 'VIDEO'] })
  @ValidateIf(optional)
  @IsIn(['IMAGE', 'VIDEO'])
  kind?: 'IMAGE' | 'VIDEO';

  @ApiPropertyOptional({ description: 'Opaque cursor from nextCursor.' })
  @ValidateIf(optional)
  @IsString()
  @MaxLength(500)
  cursor?: string;

  @ApiPropertyOptional({
    minimum: 1,
    maximum: MEMORY_POLICY.gridMaxLimit,
    default: MEMORY_POLICY.gridDefaultLimit,
  })
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MEMORY_POLICY.gridMaxLimit)
  limit?: number;
}
