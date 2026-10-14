import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsIn,
  IsInt,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import { Gender } from '../../common/database.enums';

export class CreateChildDto {
  @ApiPropertyOptional({ nullable: true, maxLength: 60 })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsString()
  @MaxLength(60)
  name?: string | null;

  @ApiPropertyOptional({ nullable: true, maxLength: 40 })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsString()
  @MaxLength(40)
  nickname?: string | null;

  @ApiProperty({ example: '2026-01-20', format: 'date' })
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  @IsDateString({ strict: true })
  birthDate!: string;

  @ApiPropertyOptional({ nullable: true, example: '09:30' })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsString()
  @Matches(/^(?:[01]\d|2[0-3]):[0-5]\d$/)
  birthTime?: string | null;

  @ApiPropertyOptional({ enum: Object.values(Gender) })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(Object.values(Gender))
  gender?: Gender;

  @ApiProperty({ minimum: 1, maximum: 8 })
  @IsInt()
  @Min(1)
  @Max(8)
  colorIndex!: number;
}
