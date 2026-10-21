import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { PROFILE_IMAGE_POLICY } from '../../config/profile-image-policy';

export class AvatarVariantDto {
  @ApiProperty({ enum: ['m1080', 't320', 'l2048'] })
  @IsIn(['m1080', 't320', 'l2048'])
  code!: string;
  @ApiProperty({ enum: ['image/jpeg', 'image/webp'] })
  @IsIn(['image/jpeg', 'image/webp'])
  mime!: string;
  @ApiProperty()
  @IsInt()
  @Min(1)
  @Max(PROFILE_IMAGE_POLICY.maxBytes)
  size!: number;
  @ApiProperty()
  @Matches(/^[a-fA-F0-9]{64}$/)
  sha256!: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(4096)
  width?: number;
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(4096)
  height?: number;
}

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
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(4096)
  width?: number;
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(4096)
  height?: number;
  @ApiPropertyOptional({ type: [AvatarVariantDto] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(3)
  @ValidateNested({ each: true })
  @Type(() => AvatarVariantDto)
  variants?: AvatarVariantDto[];
}
