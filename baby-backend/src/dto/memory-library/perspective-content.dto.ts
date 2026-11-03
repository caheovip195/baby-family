import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
} from 'class-validator';
import { MEMORY_POLICY } from '../../config/memory-policy';

const nullable = (_: object, value: unknown) =>
  value !== undefined && value !== null;
export class PutPerspectiveContentDto {
  @ApiPropertyOptional({ nullable: true, maxLength: 1000 })
  @ValidateIf(nullable)
  @IsString()
  @MaxLength(1000)
  body?: string | null;

  @ApiPropertyOptional({ nullable: true, format: 'uuid' })
  @ValidateIf(nullable)
  @IsUUID()
  audioAssetId?: string | null;

  @ApiPropertyOptional()
  @ValidateIf((_: object, value: unknown) => value !== undefined)
  @IsBoolean()
  hiddenFromCircle?: boolean;

  @ApiPropertyOptional({
    type: [String],
    description:
      'Ảnh/video của góc nhìn theo thứ tự (thay cả bộ); bỏ trống = giữ bộ cũ (BF-20261030-006).',
  })
  @ValidateIf((_: object, value: unknown) => value !== undefined)
  @IsArray()
  @ArrayMaxSize(MEMORY_POLICY.perspectiveMaxAssets)
  @IsUUID('all', { each: true })
  assetIds?: string[];
}

export class PerspectiveAssetDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty({ enum: ['IMAGE', 'VIDEO'] }) kind!: string;
  @ApiProperty({
    nullable: true,
    type: String,
    description: 'Ảnh (~1080px) / poster video có hạn.',
  })
  url!: string | null;
  @ApiProperty({
    nullable: true,
    type: String,
    description: 'Video phát được.',
  })
  videoUrl!: string | null;
}

export class PerspectiveContentResponseDto {
  @ApiProperty() id!: string;
  @ApiProperty() memoryId!: string;
  @ApiProperty() authorUserId!: string;
  @ApiProperty({ nullable: true, type: String }) body!: string | null;
  @ApiProperty({ nullable: true, type: String }) audioAssetId!: string | null;
  @ApiPropertyOptional({
    nullable: true,
    type: String,
    description: 'URL nghe có hạn của ghi âm (BF-20261030-004).',
  })
  audioUrl?: string | null;
  @ApiPropertyOptional({ nullable: true, type: String, format: 'date-time' })
  audioUrlExpiresAt?: string | null;
  @ApiPropertyOptional({ nullable: true, type: Number })
  audioDurationSec?: number | null;
  @ApiPropertyOptional({ type: [PerspectiveAssetDto] })
  assets?: PerspectiveAssetDto[];
  @ApiProperty() hiddenFromCircle!: boolean;
  @ApiProperty() version!: number;
  @ApiProperty() createdAt!: string;
  @ApiProperty() updatedAt!: string;
}
