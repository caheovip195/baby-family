import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  ValidateNested,
  IsIn,
  IsISO8601,
  IsInt,
  IsString,
  IsUUID,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import type { AssetKind } from '../../common/database.enums';
import { MEDIA_POLICY } from '../../config/media-policy';
import type { MediaPurpose } from '../../config/media-policy';

const KINDS = Object.keys(MEDIA_POLICY.kinds);
const PURPOSES = Object.keys(MEDIA_POLICY.purposes);
const optional = (_object: object, value: unknown) => value !== undefined;

export class CreateUploadVariantDto {
  @ApiProperty() @IsString() @MaxLength(30) code!: string;
  @ApiProperty() @IsString() @MaxLength(60) mime!: string;
  @ApiProperty() @IsInt() @Min(1) @Max(Number.MAX_SAFE_INTEGER) size!: number;
  @ApiProperty() @IsString() @Matches(/^[0-9a-fA-F]{64}$/) sha256!: string;
  @ApiPropertyOptional()
  @ValidateIf(optional)
  @IsInt()
  @Min(1)
  @Max(100_000)
  width?: number;
  @ApiPropertyOptional()
  @ValidateIf(optional)
  @IsInt()
  @Min(1)
  @Max(100_000)
  height?: number;
}

/** Original file on the device, before client processing (BF-20261021-008). */
export class CreateUploadSourceDto {
  @ApiProperty({ description: 'SHA-256 of the original bytes, hex.' })
  @IsString()
  @Matches(/^[0-9a-fA-F]{64}$/)
  sha256!: string;

  @ApiProperty({ example: 'IMAGE|3024x4032|0', maxLength: 64 })
  @IsString()
  @MaxLength(64)
  key!: string;

  @ApiPropertyOptional({ format: 'date-time' })
  @ValidateIf(optional)
  @IsISO8601()
  capturedAt?: string;
}

export class CreateUploadIntentDto {
  @ApiPropertyOptional({ type: CreateUploadSourceDto })
  @ValidateIf(optional)
  @ValidateNested()
  @Type(() => CreateUploadSourceDto)
  source?: CreateUploadSourceDto;

  @ApiPropertyOptional({ type: [CreateUploadVariantDto] })
  @ValidateIf(optional)
  @IsArray()
  @ArrayMaxSize(3)
  @ValidateNested({ each: true })
  @Type(() => CreateUploadVariantDto)
  variants?: CreateUploadVariantDto[];

  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  familyId!: string;

  @ApiProperty({ enum: KINDS })
  @IsIn(KINDS)
  kind!: AssetKind;

  @ApiProperty({ enum: PURPOSES })
  @IsIn(PURPOSES)
  purpose!: MediaPurpose;

  @ApiProperty({ example: 'image/jpeg', maxLength: 60 })
  @IsString()
  @MaxLength(60)
  mime!: string;

  @ApiProperty({ description: 'Declared size in bytes.', minimum: 1 })
  @IsInt()
  @Min(1)
  @Max(Number.MAX_SAFE_INTEGER)
  size!: number;

  @ApiProperty({ description: 'SHA-256 of the file, hex.', example: 'ab…' })
  @IsString()
  @Matches(/^[0-9a-fA-F]{64}$/)
  sha256!: string;

  @ApiPropertyOptional({ minimum: 1 })
  @ValidateIf(optional)
  @IsInt()
  @Min(1)
  @Max(100_000)
  width?: number;

  @ApiPropertyOptional({ minimum: 1 })
  @ValidateIf(optional)
  @IsInt()
  @Min(1)
  @Max(100_000)
  height?: number;

  @ApiPropertyOptional({ description: 'Required for VIDEO/AUDIO.', minimum: 0 })
  @ValidateIf(optional)
  @IsInt()
  @Min(0)
  @Max(24 * 60 * 60 * 1000)
  durationMs?: number;
}
