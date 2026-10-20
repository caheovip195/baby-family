import { ApiProperty } from '@nestjs/swagger';
import { MediaAssetResponseDto } from '../media/media-response.dto';

/** Memory as seen by a Parent (spec §11.5 response, §6.3 shaping). */
export class MemoryResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty() kind!: string;
  @ApiProperty({
    enum: ['DRAFT', 'PROCESSING', 'PENDING_REVIEW', 'PUBLISHED'],
  })
  status!: string;
  @ApiProperty() version!: number;
  @ApiProperty({ format: 'uuid' }) authorUserId!: string;
  @ApiProperty({ enum: ['PARENT', 'CIRCLE'] }) authorRole!: string;
  @ApiProperty({ type: String, nullable: true }) title!: string | null;
  @ApiProperty({ type: String, nullable: true }) body!: string | null;
  @ApiProperty({ format: 'date-time' }) occurredAt!: string;
  @ApiProperty({ format: 'date' }) occurredLocalDate!: string;
  @ApiProperty({ enum: ['PRIVATE', 'PARENTS', 'FAMILY'] }) visibility!: string;
  @ApiProperty() familyMoment!: boolean;
  @ApiProperty({ type: [String], format: 'uuid' }) childIds!: string[];
  @ApiProperty({ type: String, format: 'uuid', nullable: true })
  pregnancyId!: string | null;
  @ApiProperty({ type: Number, nullable: true }) pregnancyWeek!: number | null;
  @ApiProperty({ type: String, nullable: true }) feeling!: string | null;
  @ApiProperty({ type: String, nullable: true }) locationLabel!: string | null;
  @ApiProperty({ type: String, nullable: true }) quoteContext!: string | null;
  @ApiProperty() commentsEnabled!: boolean;
  @ApiProperty() commentCount!: number;
  @ApiProperty() reactionCount!: number;
  @ApiProperty({
    type: 'object',
    additionalProperties: { type: 'number' },
    description: 'Active reactions per type (LOVE, CUTE, HAHA, TOUCHED, CLAP).',
  })
  reactions!: Record<string, number>;
  @ApiProperty({
    type: String,
    nullable: true,
    description: "The viewer's own reaction type.",
  })
  myReaction!: string | null;
  @ApiProperty() perspectiveCount!: number;
  @ApiProperty({
    description: 'Sealed letter: body and assets are withheld until unlockAt.',
  })
  sealed!: boolean;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  unlockAt!: string | null;
  @ApiProperty({ type: String, format: 'uuid', nullable: true })
  coverAssetId!: string | null;
  @ApiProperty({
    type: [MediaAssetResponseDto],
    description: 'In display order; `urls` filled once the asset is READY.',
  })
  assets!: MediaAssetResponseDto[];
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  publishedAt!: string | null;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Set while the memory is in the trash (MEM-17).',
  })
  trashedAt!: string | null;
  @ApiProperty({ type: String, format: 'uuid', nullable: true })
  trashedBy!: string | null;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Trashed memories are purged permanently after this instant.',
  })
  purgeAfter!: string | null;
}

export class MemoryFeedResponseDto {
  @ApiProperty({ type: [MemoryResponseDto] }) data!: MemoryResponseDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}
