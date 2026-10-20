import { viewerExclusions } from './viewer-exclusions';
import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type { Comment as CommentRow } from '../generated/prisma/client';
import type { ReactionType } from '../common/database.enums';
import { NotFoundError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import type {
  CreateCommentCommand,
  IMemoryInteractionRepository,
} from '../interfaces/repositories/memory-interaction-repository.interface';
import { Comment } from '../models/comment.model';

type Transaction = Prisma.TransactionClient;

const TRANSACTION_OPTIONS = {
  isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
  timeout: 10000,
};

/**
 * Comments and reactions (spec §7.12). Every write locks the memory row first, so
 * `comment_count`/`reaction_count` stay equal to the active rows under concurrency.
 */
@Injectable()
export class MemoryInteractionRepository implements IMemoryInteractionRepository {
  constructor(private readonly prisma: PrismaService) {}

  async listComments(
    memoryId: string,
    limit: number,
    viewer?: { familyId: string; userId: string },
  ): Promise<Comment[]> {
    // RPT-01/02: blocked authors and comments hidden by a report stay hidden.
    const exclusions = viewer
      ? await viewerExclusions(this.prisma, viewer.familyId, viewer.userId)
      : null;
    const rows = await this.prisma.comment.findMany({
      where: {
        memoryId,
        status: 'ACTIVE',
        deletedAt: null,
        ...(exclusions?.blockedUserIds.length
          ? { authorUserId: { notIn: exclusions.blockedUserIds } }
          : {}),
        ...(exclusions?.hiddenCommentIds.length
          ? { id: { notIn: exclusions.hiddenCommentIds } }
          : {}),
      },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      take: limit,
    });
    return rows.map(mapComment);
  }

  async findActiveComment(commentId: string): Promise<Comment | null> {
    const row = await this.prisma.comment.findFirst({
      where: { id: commentId, status: 'ACTIVE', deletedAt: null },
    });
    return row ? mapComment(row) : null;
  }

  createComment(command: CreateCommentCommand): Promise<Comment> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockMemory(tx, command.familyId, command.memoryId);
      const row = await tx.comment.create({
        data: {
          familyId: command.familyId,
          memoryId: command.memoryId,
          authorUserId: command.authorUserId,
          parentCommentId: command.parentCommentId,
          body: command.body,
        },
      });
      await tx.$executeRaw`
        UPDATE app.memories SET comment_count = comment_count + 1
        WHERE id = ${command.memoryId}::uuid`;
      await tx.outboxEvent.create({
        data: {
          eventType: 'comment.created',
          aggregateId: row.id,
          familyId: command.familyId,
          payload: {
            commentId: row.id,
            memoryId: command.memoryId,
            familyId: command.familyId,
            authorUserId: command.authorUserId,
            parentCommentId: command.parentCommentId,
          },
        },
      });
      return mapComment(row);
    }, TRANSACTION_OPTIONS);
  }

  async updateCommentBody(commentId: string, body: string): Promise<Comment> {
    const updated = await this.prisma.comment.updateManyAndReturn({
      where: { id: commentId, status: 'ACTIVE', deletedAt: null },
      data: { body, editedAt: new Date() },
    });
    const [row] = updated;
    if (!row) throw new NotFoundError('Comment was not found.');
    return mapComment(row);
  }

  deleteComment(comment: Comment, actorUserId: string): Promise<number> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockMemory(tx, comment.familyId, comment.memoryId);
      const now = new Date();
      // Replies go with their root comment (one reply level).
      const removed = await tx.comment.updateMany({
        where: {
          memoryId: comment.memoryId,
          status: 'ACTIVE',
          deletedAt: null,
          OR: [{ id: comment.id }, { parentCommentId: comment.id }],
        },
        data: { status: 'DELETED', deletedAt: now },
      });
      if (removed.count === 0) return 0;
      await tx.$executeRaw`
        UPDATE app.memories
        SET comment_count = GREATEST(comment_count - ${removed.count}, 0)
        WHERE id = ${comment.memoryId}::uuid`;
      await tx.outboxEvent.create({
        data: {
          eventType: 'comment.deleted',
          aggregateId: comment.id,
          familyId: comment.familyId,
          payload: {
            commentId: comment.id,
            memoryId: comment.memoryId,
            familyId: comment.familyId,
            deletedBy: actorUserId,
            removed: removed.count,
          },
        },
      });
      return removed.count;
    }, TRANSACTION_OPTIONS);
  }

  setReaction(
    familyId: string,
    memoryId: string,
    userId: string,
    type: ReactionType,
  ): Promise<void> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockMemory(tx, familyId, memoryId);
      const existing = await tx.reaction.findUnique({
        where: { memoryId_userId: { memoryId, userId } },
      });
      const active = existing !== null && existing.deletedAt === null;
      if (active && existing.type === type) return;
      await tx.reaction.upsert({
        where: { memoryId_userId: { memoryId, userId } },
        create: { memoryId, userId, familyId, type },
        update: { type, deletedAt: null },
      });
      if (!active)
        await tx.$executeRaw`
          UPDATE app.memories SET reaction_count = reaction_count + 1
          WHERE id = ${memoryId}::uuid`;
      await this.reactionChanged(tx, familyId, memoryId, userId, type);
    }, TRANSACTION_OPTIONS);
  }

  clearReaction(
    familyId: string,
    memoryId: string,
    userId: string,
  ): Promise<void> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockMemory(tx, familyId, memoryId);
      const removed = await tx.reaction.updateMany({
        where: { memoryId, userId, deletedAt: null },
        data: { deletedAt: new Date() },
      });
      if (removed.count === 0) return;
      await tx.$executeRaw`
        UPDATE app.memories
        SET reaction_count = GREATEST(reaction_count - 1, 0)
        WHERE id = ${memoryId}::uuid`;
      await this.reactionChanged(tx, familyId, memoryId, userId, null);
    }, TRANSACTION_OPTIONS);
  }

  private async lockMemory(
    tx: Transaction,
    familyId: string,
    memoryId: string,
  ): Promise<void> {
    const rows = await tx.$queryRaw<{ id: string }[]>`
      SELECT id FROM app.memories
      WHERE id = ${memoryId}::uuid AND family_id = ${familyId}::uuid
        AND deleted_at IS NULL
      FOR UPDATE`;
    if (rows.length === 0) throw new NotFoundError('Memory was not found.');
  }

  private async reactionChanged(
    tx: Transaction,
    familyId: string,
    memoryId: string,
    userId: string,
    type: ReactionType | null,
  ): Promise<void> {
    // Consumers (grouped notifications, spec §7.12) read only ids and the type.
    await tx.outboxEvent.create({
      data: {
        eventType: 'reaction.changed',
        aggregateId: memoryId,
        familyId,
        payload: { memoryId, familyId, userId, type },
      },
    });
  }
}

function mapComment(row: CommentRow): Comment {
  return new Comment({
    id: row.id,
    familyId: row.familyId,
    memoryId: row.memoryId,
    authorUserId: row.authorUserId,
    parentCommentId: row.parentCommentId,
    body: row.body,
    status: row.status,
    createdAt: row.createdAt,
    editedAt: row.editedAt,
    deletedAt: row.deletedAt,
    updatedAt: row.updatedAt,
  });
}
