import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
const optional = (_: object, value: unknown) => value !== undefined;
export class JourneyQueryDto {
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(4)
  @Max(42)
  week?: number;
}
export class JourneyMemoriesQueryDto {
  @IsIn(['BUMP', 'ULTRASOUND']) kind!: 'BUMP' | 'ULTRASOUND';
  @ValidateIf(optional) @IsString() @MaxLength(500) cursor?: string;
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
