import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { AssetKind, AssetStatus } from '../../common/database.enums';

export class UploadPartUrlDto {
  @ApiProperty() n!: number;
  @ApiProperty() url!: string;
}

export class UploadInstructionDto {
  @ApiProperty({ enum: ['single', 'multipart'] }) mode!: 'single' | 'multipart';
  @ApiPropertyOptional({ enum: ['PUT'] }) method?: 'PUT';
  @ApiPropertyOptional() url?: string;
  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'string' },
    description: 'Headers to send unchanged with the PUT (they are signed).',
  })
  headers?: Record<string, string>;
  @ApiPropertyOptional() partSize?: number;
  @ApiPropertyOptional() partCount?: number;
  @ApiPropertyOptional({ type: [UploadPartUrlDto] }) parts?: UploadPartUrlDto[];
  @ApiProperty({ type: String, format: 'date-time' }) expiresAt!: Date;
}

export class UploadIntentResponseDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty() status!: AssetStatus;
  @ApiProperty({
    description:
      'True when identical content already exists; no upload needed.',
  })
  deduplicated!: boolean;
  @ApiPropertyOptional({ type: UploadInstructionDto })
  upload?: UploadInstructionDto;
}

export class UploadPartsResponseDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty({ type: [UploadPartUrlDto] }) parts!: UploadPartUrlDto[];
  @ApiProperty({ type: String, format: 'date-time' }) expiresAt!: Date;
}

export class UploadStatusResponseDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty() status!: AssetStatus;
}

export class MediaAssetResponseDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty({ enum: ['IMAGE', 'VIDEO', 'AUDIO'] }) kind!: AssetKind;
  @ApiProperty() purpose!: string;
  @ApiProperty() status!: AssetStatus;
  @ApiProperty({ type: Number, nullable: true }) width!: number | null;
  @ApiProperty({ type: Number, nullable: true }) height!: number | null;
  @ApiProperty({ type: Number, nullable: true }) durationMs!: number | null;
  @ApiProperty({ type: String, nullable: true }) blurhash!: string | null;
  @ApiProperty({
    type: 'object',
    additionalProperties: { type: 'string' },
    description:
      'Signed URL per processed variant (t320, m1080, …); empty until READY.',
  })
  urls!: Record<string, string>;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  urlsExpireAt!: Date | null;
}

export class MediaUrlsResponseDto {
  @ApiProperty({ type: [MediaAssetResponseDto] })
  items!: MediaAssetResponseDto[];
  @ApiProperty({
    type: [String],
    description:
      'Requested ids that are missing, not visible or not accessible.',
  })
  unavailableIds!: string[];
}
