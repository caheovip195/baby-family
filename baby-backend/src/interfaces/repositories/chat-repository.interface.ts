import type { ChatKind } from '../../config/chat-policy';
import type {
  ChatConversationRow,
  ChatMemberRow,
  ChatMessageRow,
  NewChatMessage,
} from '../../models/chat-view.model';

export const CHAT_REPOSITORY = Symbol('CHAT_REPOSITORY');

export interface ChatMessagePage {
  items: ChatMessageRow[];
  hasMore: boolean;
}

/** Nhắn tin (BF-20261101-001): Prisma CRUD + transaction cho chat. */
export interface IChatRepository {
  /** couple space đang hoạt động của user trong gia đình, nếu có. */
  coupleSpaceOf(familyId: string, userId: string): Promise<string | null>;
  /** Tạo lười cuộc trò chuyện (idempotent) rồi trả về bản đang hoạt động. */
  ensureConversation(
    familyId: string,
    kind: ChatKind,
    coupleSpaceId: string | null,
  ): Promise<ChatConversationRow>;
  findConversation(
    familyId: string,
    conversationId: string,
  ): Promise<ChatConversationRow | null>;
  /** Thành viên hiện có quyền (FAMILY: Parent + người thân đang hoạt động). */
  members(conversation: ChatConversationRow): Promise<ChatMemberRow[]>;
  lastMessage(conversationId: string): Promise<ChatMessageRow | null>;
  findByKey(
    conversationId: string,
    senderUserId: string,
    idempotencyKey: string,
  ): Promise<ChatMessageRow | null>;
  /** Cấp seq kế tiếp, ghi tin, đánh dấu người gửi đã đọc và ghi outbox. */
  append(
    conversation: ChatConversationRow,
    senderUserId: string,
    input: NewChatMessage,
  ): Promise<ChatMessageRow>;
  page(
    conversationId: string,
    query: { beforeSeq?: number; afterSeq?: number; limit: number },
  ): Promise<ChatMessagePage>;
  /** Chỉ tiến lên; trả về vị trí đã đọc sau cập nhật. */
  markRead(
    conversationId: string,
    userId: string,
    seq: number,
  ): Promise<number>;
}
