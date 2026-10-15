import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsInt,
  IsString,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';

export class CompletedPartDto {
  @ApiProperty({ minimum: 1, maximum: 10000 })
  @IsInt()
  @Min(1)
  @Max(10_000)
  n!: number;

  @ApiProperty({ description: 'ETag returned by the part upload.' })
  @IsString()
  @MinLength(1)
  @MaxLength(200)
  etag!: string;
}

export class CompleteUploadDto {
  @ApiPropertyOptional({
    type: [CompletedPartDto],
    description: 'Required for multipart uploads; omit for single uploads.',
  })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(10_000)
  @ValidateNested({ each: true })
  @Type(() => CompletedPartDto)
  parts?: CompletedPartDto[];
}
