import {
  ApiExtraModels,
  ApiProperty,
  ApiPropertyOptional,
  getSchemaPath,
} from '@nestjs/swagger';
import { MemoryResponseDto } from './memory-response.dto';

export class TimelineMemoryItemDto {
  @ApiProperty({ enum: ['MEMORY'] }) type!: 'MEMORY';
  @ApiProperty({ type: MemoryResponseDto }) memory!: MemoryResponseDto;
}
export class TimelineSystemItemDto {
  @ApiProperty({ enum: ['SYSTEM'] }) type!: 'SYSTEM';
  @ApiProperty() id!: string;
  @ApiProperty({ enum: ['BIRTH', 'MONTHIVERSARY', 'CHAPTER'] }) kind!:
    'BIRTH' | 'MONTHIVERSARY' | 'CHAPTER';
  @ApiProperty({ format: 'uuid' }) childId!: string;
  @ApiPropertyOptional() monthIndex?: number;
  @ApiProperty({ format: 'date' }) date!: string;
  @ApiPropertyOptional({ type: String, nullable: true }) coverUrl?:
    string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) coverUrlExpiresAt?:
    string | null;
  @ApiPropertyOptional() memoryCount?: number;
  @ApiPropertyOptional() firstsCount?: number;
  @ApiPropertyOptional() quotesCount?: number;
}
export class TimelineRecapItemDto {
  @ApiProperty({ enum: ['RECAP'] }) type!: 'RECAP';
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: ['WEEKLY_RECAP'] }) kind!: 'WEEKLY_RECAP';
  @ApiProperty({ type: String, nullable: true, format: 'uuid' }) childId!:
    string | null;
  @ApiProperty({ format: 'date' }) date!: string;
  @ApiProperty({ format: 'date' }) periodStart!: string;
}
export type TimelineItemDto =
  TimelineMemoryItemDto | TimelineSystemItemDto | TimelineRecapItemDto;

@ApiExtraModels(
  TimelineMemoryItemDto,
  TimelineSystemItemDto,
  TimelineRecapItemDto,
)
export class TimelineResponseDto {
  @ApiProperty({
    type: 'array',
    items: {
      oneOf: [
        { $ref: getSchemaPath(TimelineMemoryItemDto) },
        { $ref: getSchemaPath(TimelineSystemItemDto) },
        { $ref: getSchemaPath(TimelineRecapItemDto) },
      ],
      discriminator: { propertyName: 'type' },
    },
    description:
      'limit counts memories; system cards belong to the same time range and do not consume limit.',
  })
  data!: TimelineItemDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}
