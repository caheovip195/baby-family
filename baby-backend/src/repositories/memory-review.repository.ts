import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { Memory } from '../models/memory.model';
import type { IMemoryReviewRepository } from '../interfaces/repositories/memory-review-repository.interface';
@Injectable()
export class MemoryReviewRepository implements IMemoryReviewRepository {
  constructor(private readonly prisma: PrismaService) {}
  async list(familyId: string): Promise<Memory[]> {
    return (
      await this.prisma.memory.findMany({
        where: { familyId, status: 'PENDING_REVIEW', deletedAt: null },
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
        take: 100,
      })
    ).map((row) => new Memory(row));
  }
  async find(id: string): Promise<Memory | null> {
    const row = await this.prisma.memory.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Memory(row) : null;
  }
  review(
    input: Parameters<IMemoryReviewRepository['review']>[0],
  ): Promise<Memory> {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT a.id FROM app.assets a JOIN app.memory_assets ma ON ma.asset_id=a.id AND ma.family_id=a.family_id WHERE ma.memory_id=${input.memoryId}::uuid AND ma.family_id=${input.familyId}::uuid AND ma.deleted_at IS NULL ORDER BY a.id FOR UPDATE OF a`;
      await tx.$queryRaw`SELECT id FROM app.memories WHERE id=${input.memoryId}::uuid AND family_id=${input.familyId}::uuid FOR UPDATE`;
      const row = await tx.memory.findFirst({
        where: {
          id: input.memoryId,
          familyId: input.familyId,
          deletedAt: null,
        },
      });
      if (!row) throw new NotFoundError('Memory was not found.');
      if (row.status !== 'PENDING_REVIEW') {
        if (
          (input.decision === 'REJECT' && row.status === 'REJECTED') ||
          (input.decision === 'APPROVE' &&
            row.reviewedAt &&
            ['PUBLISHED', 'PROCESSING'].includes(row.status))
        )
          return new Memory(row);
        throw new DomainError(
          'Memory is not awaiting review.',
          'MEMORY_NOT_PENDING_REVIEW',
          409,
        );
      }
      const now = new Date();
      if (input.decision === 'APPROVE' && input.childIds) {
        const children = await tx.child.findMany({
          where: {
            id: { in: input.childIds },
            familyId: input.familyId,
            status: 'ACTIVE',
            deletedAt: null,
          },
        });
        if (
          children.length !== input.childIds.length ||
          (!children.length && !row.pregnancyId)
        )
          throw new DomainError(
            'Choose children in this family.',
            'CHILD_NOT_IN_FAMILY',
            422,
          );
        await tx.memoryChild.updateMany({
          where: {
            familyId: input.familyId,
            memoryId: row.id,
            deletedAt: null,
            childId: { notIn: input.childIds },
          },
          data: { deletedAt: now },
        });
        for (const child of children) {
          const months = Math.max(
            0,
            (row.occurredLocalDate.getUTCFullYear() -
              child.birthDate.getUTCFullYear()) *
              12 +
              row.occurredLocalDate.getUTCMonth() -
              child.birthDate.getUTCMonth() -
              Number(
                row.occurredLocalDate.getUTCDate() <
                  child.birthDate.getUTCDate(),
              ),
          );
          await tx.memoryChild.upsert({
            where: {
              memoryId_childId: { memoryId: row.id, childId: child.id },
            },
            create: {
              familyId: input.familyId,
              memoryId: row.id,
              childId: child.id,
              addedBy: input.actorUserId,
              ageMonth: months,
            },
            update: {
              deletedAt: null,
              addedBy: input.actorUserId,
              ageMonth: months,
            },
          });
        }
      }
      const unready = await tx.memoryAsset.count({
        where: {
          memoryId: row.id,
          familyId: input.familyId,
          deletedAt: null,
          asset: {
            OR: [{ status: { not: 'READY' } }, { deletedAt: { not: null } }],
          },
        },
      });
      const status =
        input.decision === 'REJECT'
          ? 'REJECTED'
          : unready
            ? 'PROCESSING'
            : 'PUBLISHED';
      const result = await tx.memory.update({
        where: { id: row.id },
        data: {
          status,
          reviewedBy: input.actorUserId,
          reviewedAt: now,
          rejectReason:
            input.decision === 'REJECT' ? input.reason?.trim() || null : null,
          publishedAt: status === 'PUBLISHED' ? now : null,
          version: { increment: 1 },
        },
      });
      const payload = {
        memoryId: row.id,
        familyId: input.familyId,
        authorUserId: row.authorUserId,
        recipientUserId: row.authorUserId,
        reviewedBy: input.actorUserId,
        status,
        kind: row.kind,
        visibility: row.visibility,
        ...(input.decision === 'REJECT'
          ? { reason: input.reason?.trim() || null }
          : {}),
      };
      await tx.outboxEvent.create({
        data: {
          familyId: input.familyId,
          aggregateId: row.id,
          eventType:
            input.decision === 'APPROVE'
              ? 'memory.approved'
              : 'memory.rejected',
          payload,
        },
      });
      if (status === 'PUBLISHED')
        await tx.outboxEvent.create({
          data: {
            familyId: input.familyId,
            aggregateId: row.id,
            eventType: 'memory.published',
            payload,
          },
        });
      return new Memory(result);
    });
  }
}
