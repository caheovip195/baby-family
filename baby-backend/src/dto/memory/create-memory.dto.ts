import { Type } from 'class-transformer';
import { MemoryPersonInputDto } from './memory-people.dto';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsBoolean,
  IsIn,
  IsISO8601,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
  ValidateNested,
  IsInt,
  Min,
  Max,
  IsDateString,
} from 'class-validator';
import { MomentFeeling, Visibility } from '../../common/database.enums';
import type { MemoryKind } from '../../common/database.enums';
import { MEMORY_POLICY } from '../../config/memory-policy';

const optional = (_object: object, value: unknown) => value !== undefined;
const nullable = (_object: object, value: unknown) =>
  value !== undefined && value !== null;

export class MemoryMilestoneInputDto {
  @ValidateIf(optional)
  @IsString()
  @MaxLength(40)
  templateCode?: string;
  @ValidateIf(optional)
  @IsString()
  @MaxLength(80)
  customTitle?: string;
  @IsDateString({ strict: true })
  occurredOn!: string;
}
export class MemoryLetterInputDto {
  @IsUUID() childId!: string;
  @IsIn(['DATE', 'CHILD_BIRTHDAY']) releaseRule!: 'DATE' | 'CHILD_BIRTHDAY';
  @ValidateIf(optional) @IsISO8601({ strict: true }) unlockAt?: string;
  @ValidateIf(optional) @IsInt() @Min(1) @Max(150) birthdayNumber?: number;
  @IsIn(Object.values(Visibility)) releaseVisibility!: Visibility;
}

/**
 * `POST /memories`: atomic memory, milestone/letter metadata and outbox creation.
 * Unknown fields are rejected by the global whitelist.
 */
export class CreateMemoryDto {
  @ApiPropertyOptional({ enum: ['DRAFT'] })
  @ValidateIf(optional)
  @IsIn(['DRAFT'])
  status?: 'DRAFT';

  @ApiPropertyOptional({ type: [MemoryPersonInputDto], maxItems: 30 })
  @ValidateIf(optional)
  @IsArray()
  @ArrayMaxSize(30)
  @ValidateNested({ each: true })
  @Type(() => MemoryPersonInputDto)
  people?: MemoryPersonInputDto[];

  @ApiPropertyOptional({ type: MemoryMilestoneInputDto })
  @ValidateIf(optional)
  @ValidateNested()
  @Type(() => MemoryMilestoneInputDto)
  milestone?: MemoryMilestoneInputDto;

  @ApiPropertyOptional({ type: MemoryLetterInputDto })
  @ValidateIf(optional)
  @ValidateNested()
  @Type(() => MemoryLetterInputDto)
  letter?: MemoryLetterInputDto;

  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  familyId!: string;

  @ApiProperty({
    enum: [...MEMORY_POLICY.creatableKinds, 'MILESTONE', 'LETTER'],
  })
  @IsIn([...MEMORY_POLICY.creatableKinds, 'MILESTONE', 'LETTER'])
  kind!: MemoryKind;

  @ApiPropertyOptional({
    type: [String],
    format: 'uuid',
    maxItems: MEMORY_POLICY.maxAssetsPerRequest,
  })
  @ValidateIf(optional)
  @IsArray()
  @ArrayMaxSize(MEMORY_POLICY.maxAssetsPerRequest)
  @ArrayUnique()
  @IsUUID('all', { each: true })
  assetIds?: string[];

  @ApiPropertyOptional({ format: 'uuid', nullable: true })
  @ValidateIf(nullable)
  @IsUUID()
  coverAssetId?: string | null;

  @ApiPropertyOptional({ nullable: true, maxLength: 120 })
  @ValidateIf(nullable)
  @IsString()
  @MaxLength(120)
  title?: string | null;

  @ApiPropertyOptional({ nullable: true, maxLength: 20000 })
  @ValidateIf(nullable)
  @IsString()
  @MaxLength(20000)
  body?: string | null;

  @ApiPropertyOptional({
    type: [String],
    format: 'uuid',
    maxItems: MEMORY_POLICY.maxChildrenPerMemory,
  })
  @ValidateIf(optional)
  @IsArray()
  @ArrayMaxSize(MEMORY_POLICY.maxChildrenPerMemory)
  @ArrayUnique()
  @IsUUID('all', { each: true })
  childIds?: string[];

  @ApiPropertyOptional({ default: false })
  @ValidateIf(optional)
  @IsBoolean()
  familyMoment?: boolean;

  @ApiPropertyOptional({ format: 'uuid', nullable: true })
  @ValidateIf(nullable)
  @IsUUID()
  pregnancyId?: string | null;

  @ApiProperty({ example: '2026-10-05T09:12:00+07:00' })
  @IsISO8601({ strict: true })
  occurredAt!: string;

  @ApiProperty({ enum: Object.values(Visibility) })
  @IsIn(Object.values(Visibility))
  visibility!: Visibility;

  @ApiPropertyOptional({ enum: Object.values(MomentFeeling), nullable: true })
  @ValidateIf(nullable)
  @IsIn(Object.values(MomentFeeling))
  feeling?: MomentFeeling | null;

  @ApiPropertyOptional({ nullable: true, maxLength: 120 })
  @ValidateIf(nullable)
  @IsString()
  @MaxLength(120)
  locationLabel?: string | null;

  @ApiPropertyOptional({ nullable: true, maxLength: 200 })
  @ValidateIf(nullable)
  @IsString()
  @MaxLength(200)
  quoteContext?: string | null;

  @ApiPropertyOptional({ default: true })
  @ValidateIf(optional)
  @IsBoolean()
  commentsEnabled?: boolean;
}
