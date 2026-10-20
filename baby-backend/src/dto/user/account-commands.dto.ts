import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsString,
  IsTimeZone,
  Matches,
  MaxLength,
  MinLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';

export class SetOnboardingRoleDto {
  @ApiProperty({ enum: ['PARENT_FATHER', 'PARENT_MOTHER', 'CIRCLE'] })
  @IsIn(['PARENT_FATHER', 'PARENT_MOTHER', 'CIRCLE'])
  role!: 'PARENT_FATHER' | 'PARENT_MOTHER' | 'CIRCLE';
}

const optional = () =>
  ValidateIf((_object, value: unknown) => value !== undefined);

export class RegisterDeviceDto {
  @ApiProperty({ enum: ['IOS', 'ANDROID', 'WEB'] })
  @IsIn(['IOS', 'ANDROID', 'WEB'])
  platform!: 'IOS' | 'ANDROID' | 'WEB';

  @ApiPropertyOptional({
    description: 'FCM registration token; null clears it.',
    nullable: true,
  })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsString()
  @MinLength(20)
  @MaxLength(4096)
  pushToken?: string | null;

  @ApiPropertyOptional({ description: 'OS notification permission.' })
  @optional()
  @IsBoolean()
  pushEnabled?: boolean;

  @ApiPropertyOptional()
  @optional()
  @IsString()
  @MaxLength(20)
  appVersion?: string;
  @ApiPropertyOptional()
  @optional()
  @IsString()
  @MaxLength(40)
  osVersion?: string;
  @ApiPropertyOptional()
  @optional()
  @IsString()
  @MaxLength(80)
  deviceModel?: string;

  @ApiPropertyOptional({ enum: ['vi', 'en'] })
  @optional()
  @IsIn(['vi', 'en'])
  locale?: string;

  @ApiPropertyOptional()
  @optional()
  @IsString()
  @IsTimeZone()
  @MaxLength(64)
  timezone?: string;
}

/** Spec §7.2 tables: legal documents a user can grant or withdraw. */
export const CONSENT_DOCUMENTS = [
  'TERMS',
  'PRIVACY',
  'DATA_PROCESSING',
  'CHILD_DATA',
  'MARKETING',
] as const;

export class ConsentItemDto {
  @ApiProperty({ enum: CONSENT_DOCUMENTS })
  @IsIn(CONSENT_DOCUMENTS)
  document!: (typeof CONSENT_DOCUMENTS)[number];

  @ApiProperty({ example: '2026-10' })
  @IsString()
  @Matches(/^[0-9A-Za-z._-]{1,20}$/)
  version!: string;

  @ApiProperty() @IsBoolean() granted!: boolean;
}

export class RecordConsentsDto {
  @ApiProperty({ type: [ConsentItemDto] })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => ConsentItemDto)
  consents!: ConsentItemDto[];

  @ApiPropertyOptional({ enum: ['IOS', 'ANDROID', 'WEB'] })
  @optional()
  @IsIn(['IOS', 'ANDROID', 'WEB'])
  platform?: 'IOS' | 'ANDROID' | 'WEB';
}
