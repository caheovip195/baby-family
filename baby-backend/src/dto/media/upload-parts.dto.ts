import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  ArrayUnique,
  IsArray,
  IsInt,
  Max,
  Min,
  ValidateIf,
} from 'class-validator';

export class UploadPartsDto {
  @ApiPropertyOptional({
    type: [Number],
    description: 'Parts to re-sign; omit for all parts.',
  })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(1000)
  @ArrayUnique()
  @IsInt({ each: true })
  @Min(1, { each: true })
  @Max(10_000, { each: true })
  partNumbers?: number[];
}
