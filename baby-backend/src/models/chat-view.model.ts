import type { ChatKind } from '../config/chat-policy';

/** Cuộc trò chuyện đã kiểm tra quyền cho người đang gọi. */
export class ChatScope {
  constructor(
    readonly familyId: string,
    readonly userId: string,
    readonly isParent: boolean,
    /** null khi gia đình chưa có couple space đang hoạt động. */
    readonly coupleSpaceId: string | null,
  ) {}
}

export class ChatConversationRow {
  constructor(
    readonly id: string,
    readonly familyId: string,
    readonly kind: ChatKind,
    readonly coupleSpaceId: string | null,
    readonly lastSeq: number,
    readonly lastMessageAt: Date | null,
  ) {}

  isCouple(): boolean {
    return this.kind === 'COUPLE';
  }
}

export class ChatMessageRow {
  constructor(
    readonly id: string,
    readonly conversationId: string,
    readonly senderUserId: string,
    readonly seq: number,
    /** Khoá thao tác của người gửi (AAD của nội dung mã hoá). */
    readonly idempotencyKey: string,
    readonly body: string | null,
    readonly bodyEnc: Uint8Array | null,
    readonly createdAt: Date,
  ) {}
}

/** Thành viên hiện có quyền với cuộc trò chuyện và vị trí đã đọc. */
export class ChatMemberRow {
  constructor(
    readonly userId: string,
    readonly displayName: string,
    readonly role: 'PARENT' | 'CIRCLE',
    readonly lastReadSeq: number,
  ) {}
}

export interface NewChatMessage {
  idempotencyKey: string;
  body: string | null;
  bodyEnc: Uint8Array | null;
}
