import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, MaxLength, MinLength } from 'class-validator';
export class AppleSignInDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(16384)
  identityToken!: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(512)
  nonce?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  fullName?: string;
}
export class GoogleSignInDto {
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(16384) idToken!: string;
}
export class LinkAppleIdentityDto extends AppleSignInDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(4096)
  reauthToken!: string;
}
export class LinkGoogleIdentityDto extends GoogleSignInDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(4096)
  reauthToken!: string;
}
export class UnlinkIdentityDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(4096)
  reauthToken!: string;
}
export class SignInMethodResponseDto {
  @ApiProperty({ enum: ['APPLE', 'GOOGLE', 'PHONE'] }) provider!: string;
  @ApiProperty() linkedAt!: string;
  @ApiProperty({ type: String, nullable: true }) maskedHint!: string | null;
}
