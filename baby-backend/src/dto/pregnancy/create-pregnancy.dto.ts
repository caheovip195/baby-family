import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsInt,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
} from 'class-validator';

export class CreatePregnancyDto {
  @ApiProperty({ maxLength: 40 })
  @IsString()
  @MinLength(1)
  @MaxLength(40)
  nickname!: string;

  @ApiPropertyOptional({
    nullable: true,
    example: '2026-11-20',
    format: 'date',
  })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  @IsDateString({ strict: true })
  dueDate?: string | null;

  @ApiPropertyOptional({ minimum: 1, maximum: 4, default: 1 })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsInt()
  @Min(1)
  @Max(4)
  expectedCount?: number;
}
