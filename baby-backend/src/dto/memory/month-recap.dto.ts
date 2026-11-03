import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, Max, Min } from 'class-validator';
import { MONTH_RECAP_POLICY } from '../../config/month-recap-policy';

/** `GET /children/:childId/month-recap?monthIndex=` (REC-03). */
export class MonthRecapQueryDto {
  @ApiPropertyOptional({
    minimum: 1,
    description: 'Tháng tuổi vừa tròn (mặc định tháng gần nhất).',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MONTH_RECAP_POLICY.maxMonthIndex)
  monthIndex?: number;
}

export class MonthRecapPhotoDto {
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty({ format: 'uuid' }) assetId!: string;
}

export class MonthRecapDto {
  @ApiProperty({ format: 'uuid' }) childId!: string;
  @ApiProperty() monthIndex!: number;
  @ApiProperty({ example: '2026-09-08' }) start!: string;
  @ApiProperty({ example: '2026-10-07' }) end!: string;
  @ApiProperty() moments!: number;
  @ApiProperty() firsts!: number;
  @ApiProperty() voices!: number;
  @ApiProperty({ type: [String] }) firstMemoryIds!: string[];
  @ApiProperty({ type: [String] }) voiceMemoryIds!: string[];
  @ApiProperty({ type: MonthRecapPhotoDto, nullable: true })
  currentPhoto!: MonthRecapPhotoDto | null;
  @ApiProperty({ type: MonthRecapPhotoDto, nullable: true })
  previousPhoto!: MonthRecapPhotoDto | null;
}
