import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  ChatConversationDto,
  ChatMessageDto,
  ChatMessagePageDto,
  ChatMessagesQueryDto,
  ChatReadResultDto,
} from '../../dto/chat/chat.dto';

export const CHAT_SERVICE = Symbol('CHAT_SERVICE');

/** Nhắn tin trong gia đình (BF-20261101-001). */
export interface IChatService {
  list(actor: AuthPrincipal, familyId: string): Promise<ChatConversationDto[]>;
  messages(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
    query: ChatMessagesQueryDto,
  ): Promise<ChatMessagePageDto>;
  send(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
    idempotencyKey: string,
    body: string,
  ): Promise<ChatMessageDto>;
  markRead(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
    seq: number,
  ): Promise<ChatReadResultDto>;
  /** Tín hiệu “đang nhập” từ WebSocket; lỗi quyền bị bỏ qua im lặng. */
  typing(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
  ): Promise<void>;
}
