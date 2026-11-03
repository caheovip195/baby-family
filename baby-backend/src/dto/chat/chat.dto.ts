import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  Max,
  MinLength,
} from 'class-validator';
import { CHAT_POLICY } from '../../config/chat-policy';

/** `POST /families/:familyId/chats/:conversationId/messages` (Idempotency-Key). */
export class SendChatMessageDto {
  @ApiProperty({ maxLength: CHAT_POLICY.bodyMaxLength })
  @IsString()
  @MinLength(1)
  @MaxLength(CHAT_POLICY.bodyMaxLength)
  body!: string;
}

/**
 * Phân trang theo `seq`: `afterSeq` lấy tin mới hơn (đồng bộ sau khi mất kết
 * nối), `beforeSeq` lấy tin cũ hơn; không có cả hai → trang mới nhất. Kết quả
 * luôn tăng dần theo seq.
 */
export class ChatMessagesQueryDto {
  @ApiPropertyOptional({ minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  beforeSeq?: number;

  @ApiPropertyOptional({ minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  afterSeq?: number;

  @ApiPropertyOptional({ minimum: 1, maximum: CHAT_POLICY.maxPageLimit })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(CHAT_POLICY.maxPageLimit)
  limit?: number;
}

export class MarkChatReadDto {
  @ApiProperty({ minimum: 0 })
  @IsInt()
  @Min(0)
  seq!: number;
}

export class ChatMessageDto {
  @ApiProperty() id!: string;
  @ApiProperty() conversationId!: string;
  @ApiProperty() seq!: number;
  @ApiProperty() senderUserId!: string;
  @ApiProperty() body!: string;
  @ApiProperty() isMine!: boolean;
  @ApiPropertyOptional({
    nullable: true,
    description: 'Idempotency-Key đã gửi; chỉ trả cho người gửi.',
  })
  clientKey!: string | null;
  @ApiProperty() createdAt!: string;
}

export class ChatMemberDto {
  @ApiProperty() userId!: string;
  @ApiProperty() displayName!: string;
  @ApiProperty({ enum: ['PARENT', 'CIRCLE'] }) role!: string;
  @ApiProperty() lastReadSeq!: number;
}

export class ChatConversationDto {
  @ApiProperty() id!: string;
  @ApiProperty() familyId!: string;
  @ApiProperty({ enum: CHAT_POLICY.kinds }) kind!: string;
  @ApiProperty() lastSeq!: number;
  @ApiProperty() readSeq!: number;
  @ApiProperty() unreadCount!: number;
  @ApiPropertyOptional({ nullable: true }) lastMessageAt!: string | null;
  @ApiPropertyOptional({ type: ChatMessageDto, nullable: true })
  lastMessage!: ChatMessageDto | null;
  @ApiProperty({ type: [ChatMemberDto] }) members!: ChatMemberDto[];
}

export class ChatMessagePageDto {
  @ApiProperty({ type: [ChatMessageDto] }) items!: ChatMessageDto[];
  @ApiProperty() hasMore!: boolean;
}

export class ChatReadResultDto {
  @ApiProperty() conversationId!: string;
  @ApiProperty() readSeq!: number;
}
