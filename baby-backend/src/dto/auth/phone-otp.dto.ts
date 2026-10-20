import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsIn,
  IsString,
  Matches,
  MaxLength,
  ValidateIf,
} from 'class-validator';

export class RequestPhoneOtpDto {
  @ApiProperty({
    example: '+84912345678',
    description: 'E.164 or a Vietnamese local number (0912345678).',
  })
  @IsString()
  @MaxLength(20)
  @Matches(/^\+?[0-9 ]{8,20}$/)
  phone!: string;

  @ApiPropertyOptional({ enum: ['ZALO', 'SMS'], default: 'ZALO' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(['ZALO', 'SMS'])
  channel?: 'ZALO' | 'SMS';
}

export class PhoneOtpResponseDto {
  @ApiProperty({ description: 'Seconds the code stays valid.' })
  expiresIn!: number;
  @ApiProperty({ description: 'Seconds before another code can be sent.' })
  resendIn!: number;
  @ApiProperty({ enum: ['ZALO', 'SMS', 'MAIL'] })
  channelUsed!: string;
}
