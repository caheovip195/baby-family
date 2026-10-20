import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsInt, IsString, Matches, Max, Min } from 'class-validator';
import { PROFILE_IMAGE_POLICY } from '../../config/profile-image-policy';

export class AvatarUploadIntentDto {
  @ApiProperty({ enum: ['AVATAR'] })
  @IsIn(['AVATAR'])
  purpose!: 'AVATAR';
  @ApiProperty({ enum: ['image/jpeg', 'image/png', 'image/webp', 'image/gif'] })
  @IsString()
  mime!: string;
  @ApiProperty({ maximum: PROFILE_IMAGE_POLICY.maxBytes })
  @IsInt()
  @Min(1)
  @Max(PROFILE_IMAGE_POLICY.maxBytes)
  size!: number;
  @ApiProperty({ description: 'Hex SHA-256 of the upload body.' })
  @Matches(/^[a-fA-F0-9]{64}$/)
  sha256!: string;
}
