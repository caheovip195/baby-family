import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
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
}
