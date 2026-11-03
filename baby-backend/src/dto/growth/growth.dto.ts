import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import { GROWTH_POLICY } from '../../config/growth-policy';
import type { GrowthEntry } from '../../models/growth.model';

/** `PUT /children/:childId/growth/:date` — ghi đè lần đo của ngày đó. */
export class UpsertGrowthDto {
  @ApiPropertyOptional({ type: Number, nullable: true, description: 'Gram' })
  @ValidateIf((_, value) => value !== null && value !== undefined)
  @IsInt()
  @Min(GROWTH_POLICY.minWeightGrams)
  @Max(GROWTH_POLICY.maxWeightGrams)
  weightGrams?: number | null;

  @ApiPropertyOptional({ type: Number, nullable: true, description: 'Milimét' })
  @ValidateIf((_, value) => value !== null && value !== undefined)
  @IsInt()
  @Min(GROWTH_POLICY.minHeightMm)
  @Max(GROWTH_POLICY.maxHeightMm)
  heightMm?: number | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @ValidateIf((_, value) => value !== null)
  @IsString()
  @MaxLength(GROWTH_POLICY.noteMaxLength)
  note?: string | null;
}

export class GrowthEntryDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ example: '2026-10-28' }) measuredOn!: string;
  @ApiProperty({ type: Number, nullable: true }) weightGrams!: number | null;
  @ApiProperty({ type: Number, nullable: true }) heightMm!: number | null;
  @ApiProperty({ type: String, nullable: true }) note!: string | null;
  @ApiProperty({ format: 'uuid' }) createdBy!: string;
  @ApiProperty() updatedAt!: string;

  static fromModel(entry: GrowthEntry): GrowthEntryDto {
    return {
      id: entry.id,
      measuredOn: entry.measuredOn,
      weightGrams: entry.weightGrams,
      heightMm: entry.heightMm,
      note: entry.note,
      createdBy: entry.createdBy,
      updatedAt: entry.updatedAt.toISOString(),
    };
  }
}

export class GrowthListDto {
  @ApiProperty({ format: 'uuid' }) childId!: string;
  @ApiProperty({ example: '2026-01-15' }) birthDate!: string;
  @ApiProperty({ type: [GrowthEntryDto] }) items!: GrowthEntryDto[];
}
