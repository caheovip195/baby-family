import {
  createCipheriv,
  createDecipheriv,
  hkdfSync,
  randomBytes,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { CHAT_POLICY } from '../config/chat-policy';
import type {
  ChatConversationDto,
  ChatMessageDto,
  ChatMessagePageDto,
  ChatMessagesQueryDto,
  ChatReadResultDto,
} from '../dto/chat/chat.dto';
import { CHAT_REPOSITORY } from '../interfaces/repositories/chat-repository.interface';
import type { IChatRepository } from '../interfaces/repositories/chat-repository.interface';
import { REALTIME_REPOSITORY } from '../interfaces/repositories/realtime-repository.interface';
import type { IRealtimeRepository } from '../interfaces/repositories/realtime-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type {
  FamilyAccessMode,
  IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type { IChatService } from '../interfaces/services/chat-service.interface';
import { ChatScope } from '../models/chat-view.model';
import type {
  ChatConversationRow,
  ChatMemberRow,
  ChatMessageRow,
} from '../models/chat-view.model';

/**
 * Nhắn tin (BF-20261101-001). Hai cuộc trò chuyện mỗi gia đình: FAMILY (Parent
 * + người thân đang có quyền xem gia đình) và COUPLE (chỉ hai Parent của couple
 * space, nội dung mã hoá AES-256-GCM như các tính năng Papa & Mama). Realtime
 * chỉ phát tín hiệu `{conversationId, seq}` (§12); nội dung luôn lấy qua REST
 * để quyền được kiểm tra lại.
 */
@Injectable()
export class ChatService implements IChatService {
  private readonly typingAt = new Map<string, number>();

  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(CHAT_REPOSITORY) private readonly repository: IChatRepository,
    @Inject(REALTIME_REPOSITORY) private readonly realtime: IRealtimeRepository,
    private readonly config: ConfigService,
  ) {}

  async list(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<ChatConversationDto[]> {
    const scope = await this.scope(actor, familyId, 'read');
    const conversations = [
      await this.repository.ensureConversation(familyId, 'FAMILY', null),
    ];
    if (scope.isParent && scope.coupleSpaceId)
      conversations.push(
        await this.repository.ensureConversation(
          familyId,
          'COUPLE',
          scope.coupleSpaceId,
        ),
      );
    return Promise.all(
      conversations.map(async (conversation) => {
        const members = await this.repository.members(conversation);
        const last = await this.repository.lastMessage(conversation.id);
        const readSeq =
          members.find((m) => m.userId === scope.userId)?.lastReadSeq ?? 0;
        return {
          id: conversation.id,
          familyId,
          kind: conversation.kind,
          lastSeq: conversation.lastSeq,
          readSeq,
          unreadCount: Math.max(0, conversation.lastSeq - readSeq),
          lastMessageAt: conversation.lastMessageAt?.toISOString() ?? null,
          lastMessage: last ? this.project(last, conversation, scope) : null,
          members: members.map((m) => ({
            userId: m.userId,
            displayName: m.displayName,
            role: m.role,
            lastReadSeq: m.lastReadSeq,
          })),
        };
      }),
    );
  }

  async messages(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
    query: ChatMessagesQueryDto,
  ): Promise<ChatMessagePageDto> {
    const scope = await this.scope(actor, familyId, 'read');
    const conversation = await this.conversation(scope, conversationId);
    if (query.afterSeq !== undefined && query.beforeSeq !== undefined)
      throw new ValidationError('Use either afterSeq or beforeSeq.');
    const page = await this.repository.page(conversation.id, {
      beforeSeq: query.beforeSeq,
      afterSeq: query.afterSeq,
      limit: query.limit ?? CHAT_POLICY.pageLimit,
    });
    return {
      items: page.items.map((row) => this.project(row, conversation, scope)),
      hasMore: page.hasMore,
    };
  }

  async send(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
    idempotencyKey: string,
    body: string,
  ): Promise<ChatMessageDto> {
    const scope = await this.scope(actor, familyId, 'write');
    const conversation = await this.conversation(scope, conversationId);
    const text = body.trim();
    if (!text) throw new ValidationError('Message body is required.');
    const replay = await this.repository.findByKey(
      conversation.id,
      scope.userId,
      idempotencyKey,
    );
    if (replay) return this.project(replay, conversation, scope);
    let row: ChatMessageRow;
    try {
      row = await this.repository.append(conversation, scope.userId, {
        idempotencyKey,
        body: conversation.isCouple() ? null : text,
        bodyEnc: conversation.isCouple()
          ? this.encrypt(text, conversation, scope.userId, idempotencyKey)
          : null,
      });
    } catch (error) {
      // Hai lần gửi lại song song cùng khoá: trả bản đã ghi.
      const raced = await this.repository.findByKey(
        conversation.id,
        scope.userId,
        idempotencyKey,
      );
      if (!raced) throw error;
      row = raced;
    }
    const members = await this.repository.members(conversation);
    this.realtime.emitToUsers(
      members.map((m) => m.userId),
      'chat.message',
      {
        familyId,
        conversationId: conversation.id,
        id: row.id,
        seq: row.seq,
        senderUserId: row.senderUserId,
      },
    );
    return this.project(row, conversation, scope);
  }

  async markRead(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
    seq: number,
  ): Promise<ChatReadResultDto> {
    const scope = await this.scope(actor, familyId, 'read');
    const conversation = await this.conversation(scope, conversationId);
    const readSeq = await this.repository.markRead(
      conversation.id,
      scope.userId,
      Math.min(seq, conversation.lastSeq),
    );
    const members = await this.repository.members(conversation);
    this.realtime.emitToUsers(
      members.filter((m) => m.userId !== scope.userId).map((m) => m.userId),
      'chat.read',
      {
        familyId,
        conversationId: conversation.id,
        userId: scope.userId,
        seq: readSeq,
      },
    );
    return { conversationId: conversation.id, readSeq };
  }

  async typing(
    actor: AuthPrincipal,
    familyId: string,
    conversationId: string,
  ): Promise<void> {
    const throttleKey = `${actor.userId}:${conversationId}`;
    const now = Date.now();
    if (
      now - (this.typingAt.get(throttleKey) ?? 0) <
      CHAT_POLICY.typingMinIntervalMs
    )
      return;
    this.typingAt.set(throttleKey, now);
    if (this.typingAt.size > 10_000) this.typingAt.clear();
    let members: ChatMemberRow[];
    try {
      const scope = await this.scope(actor, familyId, 'write');
      const conversation = await this.conversation(scope, conversationId);
      members = await this.repository.members(conversation);
    } catch {
      return;
    }
    this.realtime.emitToUsers(
      members.filter((m) => m.userId !== actor.userId).map((m) => m.userId),
      'chat.typing',
      { familyId, conversationId, userId: actor.userId },
    );
  }

  private async scope(
    actor: AuthPrincipal,
    familyId: string,
    mode: FamilyAccessMode,
  ): Promise<ChatScope> {
    const { family, isParent } = this.access.requireContentAccess
      ? await this.access.requireContentAccess(actor, familyId, mode)
      : {
          family: await this.access.requireParent(actor, familyId, mode),
          isParent: true,
        };
    if (family.status !== 'ACTIVE')
      throw new DomainError(
        'The family is not active.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
    return new ChatScope(
      familyId,
      actor.userId,
      isParent,
      isParent
        ? await this.repository.coupleSpaceOf(familyId, actor.userId)
        : null,
    );
  }

  /** COUPLE không tồn tại với người ngoài couple space (404, không lộ). */
  private async conversation(
    scope: ChatScope,
    conversationId: string,
  ): Promise<ChatConversationRow> {
    const conversation = await this.repository.findConversation(
      scope.familyId,
      conversationId,
    );
    if (
      !conversation ||
      (conversation.isCouple() &&
        (!scope.isParent || conversation.coupleSpaceId !== scope.coupleSpaceId))
    )
      throw new NotFoundError('Conversation was not found.');
    return conversation;
  }

  private project(
    row: ChatMessageRow,
    conversation: ChatConversationRow,
    scope: ChatScope,
  ): ChatMessageDto {
    const mine = row.senderUserId === scope.userId;
    return {
      id: row.id,
      conversationId: row.conversationId,
      seq: row.seq,
      senderUserId: row.senderUserId,
      body: row.bodyEnc ? this.decrypt(row, conversation) : (row.body ?? ''),
      isMine: mine,
      clientKey: mine ? row.idempotencyKey : null,
      createdAt: row.createdAt.toISOString(),
    };
  }

  /** AES-256-GCM v1; khoá dẫn xuất theo couple space, AAD gồm id thao tác. */
  private key(conversation: ChatConversationRow): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32)
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required.',
        'CHAT_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return Buffer.from(
      hkdfSync(
        'sha256',
        key,
        'baby-family:chat:v1',
        `couple:${conversation.coupleSpaceId}`,
        32,
      ),
    );
  }

  private aad(conversationId: string, senderUserId: string, key: string) {
    return Buffer.from(`chat:${conversationId}:${senderUserId}:${key}`);
  }

  private encrypt(
    text: string,
    conversation: ChatConversationRow,
    senderUserId: string,
    idempotencyKey: string,
  ): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(conversation), iv);
    cipher.setAAD(this.aad(conversation.id, senderUserId, idempotencyKey));
    const ciphertext = Buffer.concat([
      cipher.update(text, 'utf8'),
      cipher.final(),
    ]);
    return Buffer.concat([
      Buffer.from([1]),
      iv,
      cipher.getAuthTag(),
      ciphertext,
    ]);
  }

  private decrypt(
    row: ChatMessageRow,
    conversation: ChatConversationRow,
  ): string {
    const data = Buffer.from(row.bodyEnc!);
    if (data[0] !== 1)
      throw new DomainError(
        'Unsupported message format.',
        'CHAT_FORMAT_UNSUPPORTED',
        500,
      );
    const decipher = createDecipheriv(
      'aes-256-gcm',
      this.key(conversation),
      data.subarray(1, 13),
    );
    decipher.setAAD(
      this.aad(row.conversationId, row.senderUserId, row.idempotencyKey),
    );
    decipher.setAuthTag(data.subarray(13, 29));
    return Buffer.concat([
      decipher.update(data.subarray(29)),
      decipher.final(),
    ]).toString('utf8');
  }
}
