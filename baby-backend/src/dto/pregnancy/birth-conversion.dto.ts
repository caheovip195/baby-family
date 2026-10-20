import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsDateString,
  IsEnum,
  IsInt,
  IsNumber,
  IsString,
  Matches,
  MaxLength,
  Min,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Gender } from '../../common/database.enums';
import { ChildResponseDto } from '../child/child-response.dto';

export class BirthStatsDto {
  @ApiPropertyOptional({ minimum: 0 })
  @ValidateIf((_o, v: unknown) => v !== undefined)
  @IsInt()
  @Min(0)
  weightG?: number;
  @ApiPropertyOptional({ minimum: 0 })
  @ValidateIf((_o, v: unknown) => v !== undefined)
  @IsNumber()
  @Min(0)
  lengthCm?: number;
}
export class BirthChildDto {
  @ApiProperty({ maxLength: 60 })
  @IsString()
  @MaxLength(60)
  @Matches(/\S/)
  name!: string;
  @ApiPropertyOptional({ maxLength: 40 })
  @ValidateIf((_o, v: unknown) => v !== undefined)
  @IsString()
  @MaxLength(40)
  nickname?: string;
  @ApiProperty({ enum: Gender }) @IsEnum(Gender) gender!: Gender;
  @ApiProperty({ format: 'date' })
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  @IsDateString({ strict: true })
  birthDate!: string;
  @ApiPropertyOptional({ example: '09:30' })
  @ValidateIf((_o, v: unknown) => v !== undefined)
  @Matches(/^(?:[01]\d|2[0-3]):[0-5]\d$/)
  birthTime?: string;
  @ApiPropertyOptional({ type: BirthStatsDto })
  @ValidateIf((_o, v: unknown) => v !== undefined)
  @ValidateNested()
  @Type(() => BirthStatsDto)
  birthStats?: BirthStatsDto;
}
export class BirthConversionDto {
  @ApiProperty({ type: [BirthChildDto], minItems: 1, maxItems: 4 })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(4)
  @ValidateNested({ each: true })
  @Type(() => BirthChildDto)
  children!: BirthChildDto[];
}
export class BirthConversionResponseDto {
  @ApiProperty({ format: 'uuid' }) pregnancyId!: string;
  @ApiProperty({ type: [ChildResponseDto] }) children!: ChildResponseDto[];
}
