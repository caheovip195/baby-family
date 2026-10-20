import { ApiProperty } from '@nestjs/swagger';
import { IsString, Matches, MaxLength } from 'class-validator';
import type { Platform } from '../../common/database.enums';
export class RequestPhoneChangeOtpDto {
  @ApiProperty({ example: '+84912345678' })
  @IsString()
  @MaxLength(20)
  @Matches(/^\+?[0-9 ]{8,20}$/)
  phone!: string;
  @ApiProperty()
  @IsString()
  @MaxLength(8192)
  reauthToken!: string;
}
export class VerifyPhoneChangeDto {
  @ApiProperty({ example: '+84912345678' })
  @IsString()
  @MaxLength(20)
  @Matches(/^\+?[0-9 ]{8,20}$/)
  phone!: string;
  @ApiProperty({ example: '123456' })
  @IsString()
  @Matches(/^[0-9]{6}$/)
  code!: string;
}
export class SecuritySessionResponseDto {
  @ApiProperty() id!: string;
  @ApiProperty({ nullable: true }) platform!: Platform | null;
  @ApiProperty({ nullable: true }) appVersion!: string | null;
  @ApiProperty({ nullable: true }) deviceModel!: string | null;
  @ApiProperty() createdAt!: string;
  @ApiProperty() lastUsedAt!: string;
  @ApiProperty() current!: boolean;
}
export class SecuritySessionsResponseDto {
  @ApiProperty({ type: [SecuritySessionResponseDto] })
  items!: SecuritySessionResponseDto[];
}
export class RevokeOtherSessionsResponseDto {
  @ApiProperty() revokedCount!: number;
}
export class ChangedPhoneResponseDto {
  @ApiProperty({ example: '+84******678' }) phone!: string;
}
