import { ApiProperty } from '@nestjs/swagger';
import { MediaAssetResponseDto } from '../media/media-response.dto';
export class MediaGridItemDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty({ enum: ['IMAGE', 'VIDEO'] }) kind!: 'IMAGE' | 'VIDEO';
  @ApiProperty({ type: Number, nullable: true }) width!: number | null;
  @ApiProperty({ type: Number, nullable: true }) height!: number | null;
  @ApiProperty({ type: Number, nullable: true }) durationMs!: number | null;
  @ApiProperty({ type: String, nullable: true }) blurhash!: string | null;
  @ApiProperty({ format: 'date-time' }) occurredAt!: string;
  @ApiProperty({ type: 'object', additionalProperties: { type: 'string' } })
  urls!: MediaAssetResponseDto['urls'];
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  urlsExpireAt!: Date | null;
}
export class MediaGridResponseDto {
  @ApiProperty({ type: [MediaGridItemDto] }) data!: MediaGridItemDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}
