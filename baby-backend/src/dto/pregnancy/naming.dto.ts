import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsString, Length, MaxLength, ValidateIf } from 'class-validator';
import {
  cleanPregnancyName,
  PREGNANCY_NAMING_POLICY,
} from '../../config/pregnancy-naming-policy';

export class CreatePregnancyNameDto {
  @ApiProperty({
    minLength: 1,
    maxLength: PREGNANCY_NAMING_POLICY.maxNameLength,
  })
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? cleanPregnancyName(value) : value,
  )
  @IsString()
  @Length(1, PREGNANCY_NAMING_POLICY.maxNameLength)
  name!: string;

  @ApiPropertyOptional({ maxLength: PREGNANCY_NAMING_POLICY.maxMeaningLength })
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @MaxLength(PREGNANCY_NAMING_POLICY.maxMeaningLength)
  meaning?: string;
}

export interface PregnancyNameItemDto {
  id: string;
  name: string;
  meaning: string | null;
  addedByUserId: string;
  likedByMe: boolean;
  likedByPartner: boolean;
  chosen: boolean;
  createdAt: string;
}

export interface PregnancyNamesDto {
  items: PregnancyNameItemDto[];
  chosenLimit: number;
}
