import { Injectable } from '@nestjs/common';
import type { ChatKind } from '../config/chat-policy';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import type { IChatRepository } from '../interfaces/repositories/chat-repository.interface';
import {
  ChatConversationRow,
  ChatMemberRow,
  ChatMessageRow,
} from '../models/chat-view.model';
import type { NewChatMessage } from '../models/chat-view.model';

type ConversationRecord = {
  id: string;
  familyId: string;
  kind: string;
  coupleSpaceId: string | null;
  lastSeq: number;
  lastMessageAt: Date | null;
};
type MessageRecord = {
  id: string;
  conversationId: string;
  senderUserId: string;
  seq: number;
  idempotencyKey: string;
  body: string | null;
  bodyEnc: Uint8Array | null;
  createdAt: Date;
};

const toConversation = (row: ConversationRecord) =>
  new ChatConversationRow(
    row.id,
    row.familyId,
    row.kind as ChatKind,
    row.coupleSpaceId,
    row.lastSeq,
    row.lastMessageAt,
  );
const toMessage = (row: MessageRecord) =>
  new ChatMessageRow(
    row.id,
    row.conversationId,
    row.senderUserId,
    row.seq,
    row.idempotencyKey,
    row.body,
    row.bodyEnc,
    row.createdAt,
  );

/** Nhắn tin (BF-20261101-001). */
@Injectable()
export class ChatRepository implements IChatRepository {
  constructor(private readonly prisma: PrismaService) {}

  async coupleSpaceOf(familyId: string, userId: string) {
    const pair = await this.prisma.coupleSpace.findFirst({
      where: {
        familyId,
        status: 'ACTIVE',
        deletedAt: null,
        disabledAt: null,
        OR: [{ parentAUserId: userId }, { parentBUserId: userId }],
      },
      select: { id: true },
    });
    return pair?.id ?? null;
  }

  async ensureConversation(
    familyId: string,
    kind: ChatKind,
    coupleSpaceId: string | null,
  ) {
    const where: Prisma.ChatConversationWhereInput = {
      familyId,
      kind,
      deletedAt: null,
      ...(kind === 'COUPLE' ? { coupleSpaceId } : {}),
    };
    const existing = await this.prisma.chatConversation.findFirst({ where });
    if (existing) return toConversation(existing);
    // Partial unique indexes chặn bản trùng khi hai request tạo cùng lúc.
    if (kind === 'COUPLE')
      await this.prisma
        .$executeRaw`INSERT INTO app.chat_conversations (family_id, kind, couple_space_id) VALUES (${familyId}::uuid, 'COUPLE', ${coupleSpaceId}::uuid) ON CONFLICT (couple_space_id) WHERE kind = 'COUPLE' AND deleted_at IS NULL DO NOTHING`;
    else
      await this.prisma
        .$executeRaw`INSERT INTO app.chat_conversations (family_id, kind) VALUES (${familyId}::uuid, 'FAMILY') ON CONFLICT (family_id) WHERE kind = 'FAMILY' AND deleted_at IS NULL DO NOTHING`;
    return toConversation(
      await this.prisma.chatConversation.findFirstOrThrow({ where }),
    );
  }

  async findConversation(familyId: string, conversationId: string) {
    const row = await this.prisma.chatConversation.findFirst({
      where: { id: conversationId, familyId, deletedAt: null },
    });
    return row ? toConversation(row) : null;
  }

  async members(conversation: ChatConversationRow) {
    const reads = await this.prisma.chatReadState.findMany({
      where: { conversationId: conversation.id, deletedAt: null },
      select: { userId: true, lastReadSeq: true },
    });
    const read = (userId: string) =>
      reads.find((r) => r.userId === userId)?.lastReadSeq ?? 0;
    let parentIds: string[] | null = null;
    if (conversation.coupleSpaceId) {
      const pair = await this.prisma.coupleSpace.findFirst({
        where: {
          id: conversation.coupleSpaceId,
          status: 'ACTIVE',
          deletedAt: null,
          disabledAt: null,
        },
      });
      if (!pair) return [];
      parentIds = [pair.parentAUserId, pair.parentBUserId];
    }
    const parents = await this.prisma.familyParent.findMany({
      where: {
        familyId: conversation.familyId,
        status: 'ACTIVE',
        leftAt: null,
        deletedAt: null,
        ...(parentIds ? { userId: { in: parentIds } } : {}),
      },
      orderBy: { slot: 'asc' },
      select: { userId: true, callName: true },
    });
    const result = parents.map(
      (p) => new ChatMemberRow(p.userId, p.callName, 'PARENT', read(p.userId)),
    );
    if (conversation.kind !== 'FAMILY') return result;
    const circles = await this.prisma.circleMember.findMany({
      where: {
        familyId: conversation.familyId,
        status: 'ACTIVE',
        endedAt: null,
        deletedAt: null,
      },
      orderBy: { createdAt: 'asc' },
      select: { userId: true, displayName: true },
    });
    return [
      ...result,
      ...circles
        .filter((c) => !result.some((p) => p.userId === c.userId))
        .map(
          (c) =>
            new ChatMemberRow(
              c.userId,
              c.displayName,
              'CIRCLE',
              read(c.userId),
            ),
        ),
    ];
  }

  async lastMessage(conversationId: string) {
    const row = await this.prisma.chatMessage.findFirst({
      where: { conversationId, deletedAt: null },
      orderBy: { seq: 'desc' },
    });
    return row ? toMessage(row) : null;
  }

  async findByKey(
    conversationId: string,
    senderUserId: string,
    idempotencyKey: string,
  ) {
    const row = await this.prisma.chatMessage.findFirst({
      where: { conversationId, senderUserId, idempotencyKey },
    });
    return row ? toMessage(row) : null;
  }

  append(
    conversation: ChatConversationRow,
    senderUserId: string,
    input: NewChatMessage,
  ) {
    return this.prisma.$transaction(async (tx) => {
      const now = new Date();
      // Khoá dòng cuộc trò chuyện: seq liên tục, không trùng giữa các instance.
      const { lastSeq } = await tx.chatConversation.update({
        where: { id: conversation.id },
        data: { lastSeq: { increment: 1 }, lastMessageAt: now },
        select: { lastSeq: true },
      });
      const row = await tx.chatMessage.create({
        data: {
          conversationId: conversation.id,
          familyId: conversation.familyId,
          senderUserId,
          seq: lastSeq,
          idempotencyKey: input.idempotencyKey,
          body: input.body,
          bodyEnc: input.bodyEnc ? Buffer.from(input.bodyEnc) : null,
        },
      });
      await tx.chatReadState.upsert({
        where: {
          conversationId_userId: {
            conversationId: conversation.id,
            userId: senderUserId,
          },
        },
        create: {
          conversationId: conversation.id,
          userId: senderUserId,
          lastReadSeq: lastSeq,
        },
        update: { lastReadSeq: lastSeq, deletedAt: null },
      });
      await tx.outboxEvent.create({
        data: {
          eventType: 'chat.message.created',
          familyId: conversation.familyId,
          aggregateId: row.id,
          // Chỉ định danh: nội dung không bao giờ rời bảng chat.
          payload: {
            messageId: row.id,
            conversationId: conversation.id,
            familyId: conversation.familyId,
            kind: conversation.kind,
            seq: lastSeq,
            senderUserId,
          },
        },
      });
      return toMessage(row);
    });
  }

  async page(
    conversationId: string,
    query: { beforeSeq?: number; afterSeq?: number; limit: number },
  ) {
    const where: Prisma.ChatMessageWhereInput = {
      conversationId,
      deletedAt: null,
    };
    if (query.afterSeq !== undefined) {
      const rows = await this.prisma.chatMessage.findMany({
        where: { ...where, seq: { gt: query.afterSeq } },
        orderBy: { seq: 'asc' },
        take: query.limit + 1,
      });
      return {
        items: rows.slice(0, query.limit).map(toMessage),
        hasMore: rows.length > query.limit,
      };
    }
    const rows = await this.prisma.chatMessage.findMany({
      where: {
        ...where,
        ...(query.beforeSeq !== undefined
          ? { seq: { lt: query.beforeSeq } }
          : {}),
      },
      orderBy: { seq: 'desc' },
      take: query.limit + 1,
    });
    return {
      items: rows.slice(0, query.limit).reverse().map(toMessage),
      hasMore: rows.length > query.limit,
    };
  }

  async markRead(conversationId: string, userId: string, seq: number) {
    await this.prisma
      .$executeRaw`INSERT INTO app.chat_read_states (conversation_id, user_id, last_read_seq) VALUES (${conversationId}::uuid, ${userId}::uuid, ${seq}) ON CONFLICT (conversation_id, user_id) DO UPDATE SET last_read_seq = GREATEST(app.chat_read_states.last_read_seq, EXCLUDED.last_read_seq), deleted_at = NULL`;
    const row = await this.prisma.chatReadState.findUniqueOrThrow({
      where: { conversationId_userId: { conversationId, userId } },
      select: { lastReadSeq: true },
    });
    return row.lastReadSeq;
  }
}
