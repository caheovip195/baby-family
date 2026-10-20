import { ApiProperty } from '@nestjs/swagger';
import { IsString, Matches } from 'class-validator';

/** Empty request: clients cannot select a phone or delivery destination. */
export class RequestReauthOtpDto {}
export class VerifyReauthDto {
  @ApiProperty({ example: '123456' })
  @IsString()
  @Matches(/^[0-9]{6}$/)
  code!: string;
}
export class ReauthResponseDto {
  @ApiProperty()
  reauthToken!: string;
  @ApiProperty()
  expiresAt!: string;
}
