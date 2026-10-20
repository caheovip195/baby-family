import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength, MinLength } from 'class-validator';
import { UserResponseDto } from '../user/user-response.dto';

export class RefreshTokenDto {
  @ApiProperty()
  @IsString()
  @MinLength(20)
  @MaxLength(200)
  refreshToken!: string;
}

/** Token pair returned by sign-in and refresh (spec §5.1). */
export class AuthTokensResponseDto {
  @ApiProperty() accessToken!: string;
  @ApiProperty({ description: 'Opaque, rotated on every refresh.' })
  refreshToken!: string;
  @ApiProperty({ description: 'Access token lifetime in seconds.' })
  expiresIn!: number;
  @ApiProperty({ type: UserResponseDto }) user!: UserResponseDto;
  @ApiProperty({ description: 'True when this sign-in created the account.' })
  isNewUser!: boolean;
}
