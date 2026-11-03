import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsDateString,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { HANDOFF_POLICY } from '../../config/handoff-policy';

/** `POST /families/:familyId/us/handoffs` (Idempotency-Key). */
export class CreateHandoffDto {
  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(HANDOFF_POLICY.maxChildren)
  @IsUUID('all', { each: true })
  childIds?: string[];

  @ApiPropertyOptional({ description: 'Đã ăn lúc (ISO 8601).' })
  @IsOptional()
  @IsDateString()
  fedAt?: string;

  @ApiPropertyOptional({ description: 'Đã ngủ lúc.' })
  @IsOptional()
  @IsDateString()
  sleptAt?: string;

  @ApiPropertyOptional({ description: 'Đã dậy lúc.' })
  @IsOptional()
  @IsDateString()
  wokeAt?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(HANDOFF_POLICY.noteMaxLength)
  note?: string;

  @ApiPropertyOptional({
    description: 'Lời nhờ gửi kèm (của chính người bàn giao).',
  })
  @IsOptional()
  @IsUUID()
  requestId?: string;
}

export class HandoffListQueryDto {
  @ApiPropertyOptional({ minimum: 1, maximum: HANDOFF_POLICY.listLimit })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(HANDOFF_POLICY.listLimit)
  limit?: number;
}

export class HandoffDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) fromUserId!: string;
  @ApiProperty({ format: 'uuid' }) toUserId!: string;
  @ApiProperty({ enum: ['SENT', 'RECEIVED'] }) direction!: 'SENT' | 'RECEIVED';
  @ApiProperty({ type: [String] }) childIds!: string[];
  @ApiProperty({ type: String, nullable: true }) fedAt!: string | null;
  @ApiProperty({ type: String, nullable: true }) sleptAt!: string | null;
  @ApiProperty({ type: String, nullable: true }) wokeAt!: string | null;
  @ApiProperty({ type: String, nullable: true }) note!: string | null;
  @ApiProperty({ type: String, nullable: true }) requestId!: string | null;
  @ApiProperty({ type: String, nullable: true }) acknowledgedAt!: string | null;
  @ApiProperty() createdAt!: string;
}
