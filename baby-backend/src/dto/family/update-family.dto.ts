import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsIn,
  IsString,
  IsUUID,
  IsTimeZone,
  MaxLength,
  MinLength,
  ValidateIf,
} from 'class-validator';

export class UpdateFamilyDto {
  @ApiPropertyOptional({ maxLength: 80 })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  name?: string;

  @ApiPropertyOptional({ example: 'Asia/Ho_Chi_Minh' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @IsTimeZone()
  @MaxLength(64)
  timezone?: string;

  /** FAM-07: language of content the server writes for the family. */
  @ApiPropertyOptional({ enum: ['vi', 'en'] })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(['vi', 'en'])
  contentLocale?: string;

  /** FAM-07: READY COVER asset of this family (media upload), or null. */
  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsUUID()
  coverAssetId?: string | null;
}
