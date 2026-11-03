import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type {
  IHandoffRepository,
  NewHandoff,
} from '../interfaces/repositories/handoff-repository.interface';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';
import { HandoffRow } from '../models/handoff-view.model';

type Row = {
  id: string;
  fromUserId: string;
  toUserId: string;
  idempotencyKey: string;
  childIds: string[];
  fedAt: Date | null;
  sleptAt: Date | null;
  wokeAt: Date | null;
  noteEnc: Uint8Array | null;
  requestId: string | null;
  acknowledgedAt: Date | null;
  createdAt: Date;
};

const toRow = (row: Row) =>
  new HandoffRow(
    row.id,
    row.fromUserId,
    row.toUserId,
    row.idempotencyKey,
    row.childIds,
    row.fedAt,
    row.sleptAt,
    row.wokeAt,
    row.noteEnc,
    row.requestId,
    row.acknowledgedAt,
    row.createdAt,
  );

/** Bàn giao ca (BF-20261028-007): chỉ trong couple space đang hoạt động. */
@Injectable()
export class HandoffRepository implements IHandoffRepository {
  constructor(private readonly prisma: PrismaService) {}

  async activeChildIds(familyId: string, childIds: string[]) {
    if (!childIds.length) return [];
    const rows = await this.prisma.child.findMany({
      where: {
        id: { in: childIds },
        familyId,
        deletedAt: null,
        status: 'ACTIVE',
      },
      select: { id: true },
    });
    return rows.map((row) => row.id);
  }

  async ownRequestExists(scope: CoupleCheckinScope, requestId: string) {
    return (
      (await this.prisma.request.count({
        where: {
          id: requestId,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          senderUserId: scope.userId,
          deletedAt: null,
        },
      })) > 0
    );
  }

  async findByKey(scope: CoupleCheckinScope, idempotencyKey: string) {
    const row = await this.prisma.careHandoff.findFirst({
      where: {
        fromUserId: scope.userId,
        idempotencyKey,
        coupleSpaceId: scope.coupleSpaceId,
      },
    });
    return row ? toRow(row) : null;
  }

  create(scope: CoupleCheckinScope, input: NewHandoff) {
    return this.prisma.$transaction(async (tx) => {
      const row = await tx.careHandoff.create({
        data: {
          ...input,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          fromUserId: scope.userId,
          toUserId: scope.partnerUserId,
          noteEnc: input.noteEnc ? Buffer.from(input.noteEnc) : null,
        },
      });
      await tx.outboxEvent.create({
        data: {
          eventType: 'us.handoff.created',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            handoffId: row.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            fromUserId: row.fromUserId,
            toUserId: row.toUserId,
          },
        },
      });
      return toRow(row);
    });
  }

  async list(scope: CoupleCheckinScope, limit: number) {
    const rows = await this.prisma.careHandoff.findMany({
      where: {
        familyId: scope.familyId,
        coupleSpaceId: scope.coupleSpaceId,
        deletedAt: null,
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit,
    });
    return rows.map(toRow);
  }

  async acknowledge(scope: CoupleCheckinScope, handoffId: string, at: Date) {
    return this.prisma.$transaction(async (tx) => {
      const row = await tx.careHandoff.findFirst({
        where: {
          id: handoffId,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          toUserId: scope.userId,
          deletedAt: null,
        },
      });
      if (!row) return null;
      if (row.acknowledgedAt) return toRow(row);
      return toRow(
        await tx.careHandoff.update({
          where: { id: row.id },
          data: { acknowledgedAt: at },
        }),
      );
    });
  }
}
