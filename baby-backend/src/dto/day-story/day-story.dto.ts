import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  MaxLength,
  MinLength,
  ValidateIf,
} from 'class-validator';
import { DAY_STORY_POLICY } from '../../config/day-story-policy';

/** `GET /children/:childId/day-story?date=` (mặc định hôm nay). */
export class DayStoryQueryDto {
  @ApiPropertyOptional({ example: '2026-10-28' })
  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  date?: string;
}

/** `PUT /children/:childId/day-story/:date`. */
export class SaveDayStoryDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(DAY_STORY_POLICY.titleMaxLength)
  title!: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @ValidateIf((_, value) => value !== null)
  @IsString()
  @MaxLength(DAY_STORY_POLICY.bodyMaxLength)
  body?: string | null;

  @ApiProperty({ type: [String] })
  @IsArray()
  @ArrayMaxSize(DAY_STORY_POLICY.maxMemories)
  @IsUUID('all', { each: true })
  memoryIds!: string[];

  @ApiProperty({ type: [String] })
  @IsArray()
  @ArrayMaxSize(DAY_STORY_POLICY.maxPhotos)
  @IsUUID('all', { each: true })
  assetIds!: string[];

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @ValidateIf((_, value) => value !== null)
  @IsUUID()
  coverAssetId?: string | null;

  @ApiProperty({ enum: ['PARENTS', 'FAMILY'] })
  @IsIn(['PARENTS', 'FAMILY'])
  visibility!: 'PARENTS' | 'FAMILY';
}

export class DayStoryMemoryDto {
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty() kind!: string;
  @ApiProperty({ type: String, nullable: true }) title!: string | null;
  @ApiProperty() occurredAt!: string;
  @ApiProperty({ type: [String] }) assetIds!: string[];
}

export class SavedDayStoryDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() title!: string;
  @ApiProperty({ type: String, nullable: true }) body!: string | null;
  @ApiProperty({ type: String, nullable: true }) coverAssetId!: string | null;
  @ApiProperty({ type: [String] }) memoryIds!: string[];
  @ApiProperty({ type: [String] }) assetIds!: string[];
  @ApiProperty({ enum: ['PARENTS', 'FAMILY'] }) visibility!: string;
  @ApiProperty() updatedAt!: string;
}

export class DayStoryDto {
  @ApiProperty({ format: 'uuid' }) childId!: string;
  @ApiProperty({ example: '2026-10-28' }) date!: string;
  @ApiProperty({ type: [DayStoryMemoryDto] }) memories!: DayStoryMemoryDto[];
  @ApiProperty({ type: SavedDayStoryDto, nullable: true })
  saved!: SavedDayStoryDto | null;
}
