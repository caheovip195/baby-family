import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsString,
  IsTimeZone,
  Matches,
  MaxLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { RequestPhoneOtpDto } from './phone-otp.dto';

export class SignInDeviceDto {
  @ApiProperty({ enum: ['IOS', 'ANDROID', 'WEB'] })
  @IsIn(['IOS', 'ANDROID', 'WEB'])
  platform!: 'IOS' | 'ANDROID' | 'WEB';

  @ApiPropertyOptional({ example: '1.0.0+12' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @MaxLength(20)
  appVersion?: string;

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

export class VerifyPhoneOtpDto extends RequestPhoneOtpDto {
  @ApiProperty({ example: '123456' })
  @IsString()
  @Matches(/^[0-9]{6}$/)
  code!: string;

  @ApiPropertyOptional({ type: SignInDeviceDto })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @ValidateNested()
  @Type(() => SignInDeviceDto)
  device?: SignInDeviceDto;
}
