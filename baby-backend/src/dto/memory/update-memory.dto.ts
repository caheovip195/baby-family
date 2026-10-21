import { Type } from 'class-transformer';
import { MemoryPersonInputDto } from './memory-people.dto';
import { ApiPropertyOptional } from '@nestjs/swagger';
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
} from 'class-validator';
import { MomentFeeling, Visibility } from '../../common/database.enums';
import { MEMORY_POLICY } from '../../config/memory-policy';

const optional = (_object: object, value: unknown) => value !== undefined;
const nullable = (_object: object, value: unknown) =>
  value !== undefined && value !== null;

/**
 * `PATCH /memories/{id}` (MEM-09, spec §7.8.3) with `If-Match: <version>`. Absent
 * fields stay unchanged; `null` clears a nullable field. The author edits every
 * field; the other Parent only `childIds`, `familyMoment`, `pregnancyId` and
 * `visibility` (spec §6.2 canEditMemory). Only the author may edit media.
 */
export class UpdateMemoryDto {
  @ApiPropertyOptional({ type: [MemoryPersonInputDto], maxItems: 30 })
  @ValidateIf(optional)
  @IsArray()
  @ArrayMaxSize(30)
  @ValidateNested({ each: true })
  @Type(() => MemoryPersonInputDto)
  people?: MemoryPersonInputDto[];

  @ApiPropertyOptional({ type: [String] })
  @ValidateIf(optional)
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(MEMORY_POLICY.maxAssetsPerRequest)
  @IsUUID('all', { each: true })
  addAssetIds?: string[];

  @ApiPropertyOptional({ type: [String] })
  @ValidateIf(optional)
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(MEMORY_POLICY.maxAssetsPerRequest)
  @IsUUID('all', { each: true })
  removeAssetIds?: string[];

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

  @ApiPropertyOptional({ example: '2026-10-05T09:12:00+07:00' })
  @ValidateIf(optional)
  @IsISO8601({ strict: true })
  occurredAt?: string;

  @ApiPropertyOptional({ enum: Object.values(Visibility) })
  @ValidateIf(optional)
  @IsIn(Object.values(Visibility))
  visibility?: Visibility;

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
