import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsIn,
  IsUUID,
  IsString,
  IsTimeZone,
  MaxLength,
  MinLength,
  ValidateIf,
} from 'class-validator';

export class UpdateUserDto {
  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsUUID()
  avatarAssetId?: string | null;

  @ApiPropertyOptional({ maxLength: 80 })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  displayName?: string;

  @ApiPropertyOptional({ enum: ['vi', 'en'] })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(['vi', 'en'])
  locale?: string;

  @ApiPropertyOptional({ example: 'Asia/Ho_Chi_Minh' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @IsTimeZone()
  @MaxLength(64)
  timezone?: string;
}
