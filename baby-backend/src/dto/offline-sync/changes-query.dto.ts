import { Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { OFFLINE_SYNC_POLICY } from '../../config/offline-sync-policy';
export class ChangesQueryDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(1024)
  cursor?: string;
  @ApiPropertyOptional({ default: 100, minimum: 1, maximum: 200 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(OFFLINE_SYNC_POLICY.maxLimit)
  limit: number = OFFLINE_SYNC_POLICY.defaultLimit;
}
