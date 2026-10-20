import { Injectable } from '@nestjs/common';
import type { PregnancyStatus } from '../common/database.enums';
import { DomainError } from '../common/errors/domain.error';
import type {
  Paginated,
  PaginationInput,
} from '../common/pagination/pagination.types';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { IPregnancyLifecycleRepository } from '../interfaces/repositories/pregnancy-lifecycle-repository.interface';
import { Pregnancy } from '../models/pregnancy.model';

@Injectable()
export class PregnancyLifecycleRepository implements IPregnancyLifecycleRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<Pregnancy | null> {
    const row = await this.prisma.pregnancy.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Pregnancy(row) : null;
  }

  async listArchived(
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<Pregnancy>> {
    const where: Prisma.PregnancyWhereInput = {
      familyId,
      deletedAt: null,
      status: { in: ['ARCHIVED', 'ENDED_PRIVATE', 'PAUSED'] },
    };
    const [rows, total] = await this.prisma.$transaction([
      this.prisma.pregnancy.findMany({
        where,
        orderBy: [{ seqNo: 'desc' }],
        skip: (input.page - 1) * input.limit,
        take: input.limit,
      }),
      this.prisma.pregnancy.count({ where }),
    ]);
    return {
      data: rows.map((row) => new Pregnancy(row)),
      meta: {
        page: input.page,
        limit: input.limit,
        total,
        totalPages: Math.ceil(total / input.limit),
      },
    };
  }

  changeStatus(
    current: Pregnancy,
    status: PregnancyStatus,
  ): Promise<Pregnancy> {
    return this.prisma.$transaction(
      async (tx) => {
        // Keep the family → pregnancy lock order used by birth conversion.
        await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${current.familyId}::uuid FOR UPDATE`;
        // Lock the same subject row as birth conversion; the optimistic predicate
        // rejects an archive/restore based on a stale lifecycle state.
        await tx.$queryRaw`SELECT id FROM app.pregnancies WHERE id = ${current.id}::uuid AND family_id = ${current.familyId}::uuid FOR UPDATE`;
        const changed = await tx.pregnancy.updateMany({
          where: {
            id: current.id,
            familyId: current.familyId,
            deletedAt: null,
            status: current.status,
            version: current.version,
          },
          data: { status, version: { increment: 1 } },
        });
        if (changed.count !== 1)
          throw new DomainError(
            'Pregnancy changed concurrently; retry.',
            'PREGNANCY_STATUS_CONFLICT',
            409,
          );
        if (status === 'ENDED_PRIVATE') {
          // Tighten shared content only: PRIVATE memories must stay private even
          // from the other Parent. Restore never widens visibility automatically.
          await tx.memory.updateMany({
            where: {
              familyId: current.familyId,
              pregnancyId: current.id,
              deletedAt: null,
              visibility: 'FAMILY',
            },
            data: { visibility: 'PARENTS', version: { increment: 1 } },
          });
          await tx.circleGrant.updateMany({
            where: {
              familyId: current.familyId,
              pregnancyId: current.id,
              deletedAt: null,
              status: { in: ['ACTIVE', 'PAUSED'] },
            },
            data: { status: 'REVOKED' },
          });
        }
        await tx.family.update({
          where: { id: current.familyId },
          data: { accessVersion: { increment: 1 } },
        });
        // No reason/status/content in the event, and no notification is queued.
        await tx.outboxEvent.create({
          data: {
            eventType: 'pregnancy.status_changed',
            aggregateId: current.id,
            familyId: current.familyId,
            payload: { pregnancyId: current.id },
          },
        });
        const row = await tx.pregnancy.findUniqueOrThrow({
          where: { id: current.id },
        });
        return new Pregnancy(row);
      },
      {
        isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
        timeout: 10000,
      },
    );
  }
}
