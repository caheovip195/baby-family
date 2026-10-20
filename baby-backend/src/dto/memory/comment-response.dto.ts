import { ApiProperty } from '@nestjs/swagger';

export class CommentResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty({ format: 'uuid' }) authorUserId!: string;
  @ApiProperty({ type: String, format: 'uuid', nullable: true })
  parentCommentId!: string | null;
  @ApiProperty() body!: string;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  editedAt!: string | null;
}

export class CommentListResponseDto {
  @ApiProperty({ type: [CommentResponseDto] }) data!: CommentResponseDto[];
}

export class ReactionResponseDto {
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty({
    type: 'object',
    additionalProperties: { type: 'number' },
    description: 'Active reactions per type.',
  })
  reactions!: Record<string, number>;
  @ApiProperty({ type: String, nullable: true }) myReaction!: string | null;
  @ApiProperty() reactionCount!: number;
}
