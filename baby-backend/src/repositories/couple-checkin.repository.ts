import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { MoodCheckin as CheckinRow } from '../generated/prisma/client';
import type {
  ICoupleCheckinRepository,
  CreateCoupleCheckinCommand,
} from '../interfaces/repositories/couple-checkin-repository.interface';
import type { CoupleResponseType } from '../config/couple-policy';
import {
  CoupleCheckinScope,
  CoupleCheckinView,
} from '../models/couple-checkin-view.model';
import { MoodCheckin } from '../models/mood-checkin.model';
import { MoodResponse } from '../models/mood-response.model';
const orderBy = [
  { createdAt: 'desc' },
  { id: 'desc' },
] satisfies Prisma.MoodCheckinOrderByWithRelationInput[];
function view(row: CheckinRow): CoupleCheckinView {
  return new CoupleCheckinView(new MoodCheckin(row));
}
function scopeWhere(scope: CoupleCheckinScope) {
  return {
    familyId: scope.familyId,
    coupleSpaceId: scope.coupleSpaceId,
    deletedAt: null,
  };
}
@Injectable()
export class CoupleCheckinRepository implements ICoupleCheckinRepository {
  constructor(private readonly prisma: PrismaService) {}
  async resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleCheckinScope | null> {
    const pair = await this.prisma.coupleSpace.findFirst({
      where: {
        familyId,
        status: 'ACTIVE',
        deletedAt: null,
        disabledAt: null,
        OR: [{ parentAUserId: userId }, { parentBUserId: userId }],
      },
    });
    return pair
      ? new CoupleCheckinScope(
          familyId,
          pair.id,
          userId,
          pair.parentAUserId === userId
            ? pair.parentBUserId
            : pair.parentAUserId,
        )
      : null;
  }
  async create(
    scope: CoupleCheckinScope,
    input: CreateCoupleCheckinCommand,
  ): Promise<CoupleCheckinView> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.moodCheckin.create({
        data: {
          ...input,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          userId: scope.userId,
          noteEnc:
            input.noteEnc === null ? null : new Uint8Array(input.noteEnc),
          sharedNoteEnc:
            input.sharedNoteEnc === null
              ? null
              : new Uint8Array(input.sharedNoteEnc),
        },
      });
      if (row.shared)
        await tx.outboxEvent.create({
          data: {
            eventType: 'us.checkin.shared',
            familyId: scope.familyId,
            aggregateId: row.id,
            payload: {
              checkinId: row.id,
              familyId: scope.familyId,
              coupleSpaceId: scope.coupleSpaceId,
              userId: scope.userId,
              partnerUserId: scope.partnerUserId,
            },
          },
        });
      return view(row);
    });
  }
  async find(
    scope: CoupleCheckinScope,
    id: string,
  ): Promise<CoupleCheckinView | null> {
    const row = await this.prisma.moodCheckin.findFirst({
      where: { ...scopeWhere(scope), id },
    });
    return row ? view(row) : null;
  }
  async latest(
    scope: CoupleCheckinScope,
    userId: string,
  ): Promise<CoupleCheckinView | null> {
    const row = await this.prisma.moodCheckin.findFirst({
      where: { ...scopeWhere(scope), userId },
      orderBy,
    });
    return row ? view(row) : null;
  }
  async history(
    scope: CoupleCheckinScope,
    cursor: string | undefined,
    limit: number,
  ): Promise<CoupleCheckinView[]> {
    const where = { ...scopeWhere(scope), userId: scope.userId };
    const anchor = cursor
      ? await this.prisma.moodCheckin.findFirst({
          where: { ...where, id: cursor },
        })
      : null;
    if (cursor && !anchor)
      throw new DomainError(
        'The history cursor is invalid.',
        'CHECKIN_CURSOR_INVALID',
        400,
      );
    const rows = await this.prisma.moodCheckin.findMany({
      where: {
        ...where,
        ...(anchor
          ? {
              OR: [
                { createdAt: { lt: anchor.createdAt } },
                { createdAt: anchor.createdAt, id: { lt: anchor.id } },
              ],
            }
          : {}),
      },
      orderBy,
      take: limit,
    });
    return rows.map(view);
  }
  async respond(
    scope: CoupleCheckinScope,
    id: string,
    type: CoupleResponseType,
  ): Promise<MoodResponse> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.moodCheckin.findFirst({
        where: { ...scopeWhere(scope), id },
      });
      // Recheck service preconditions under the same lock as the write.
      if (!row)
        throw new DomainError(
          'Check-in was not found.',
          'CHECKIN_NOT_FOUND',
          404,
        );
      if (row.userId === scope.userId)
        throw new DomainError(
          'Only the partner can respond.',
          'CHECKIN_RESPONSE_SELF',
          422,
        );
      if (row.userId !== scope.partnerUserId || !row.shared)
        throw new DomainError(
          'Check-in was not found.',
          'CHECKIN_NOT_FOUND',
          404,
        );
      const latest = await tx.moodCheckin.findFirst({
        where: { ...scopeWhere(scope), userId: scope.partnerUserId },
        orderBy,
      });
      if (row.expiresAt <= new Date() || latest?.id !== id)
        throw new DomainError(
          'Check-in is no longer current.',
          'CHECKIN_NOT_CURRENT',
          422,
        );
      const response = await tx.moodResponse.create({
        data: {
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          checkinId: id,
          userId: scope.userId,
          type,
        },
      });
      if (type === 'SEEN')
        await tx.moodCheckin.update({
          where: { id },
          data: { seenByPartnerAt: row.seenByPartnerAt ?? new Date() },
        });
      return new MoodResponse(response);
    });
  }
  async deleteHistory(scope: CoupleCheckinScope): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const now = new Date();
      await tx.moodResponse.updateMany({
        where: {
          ...scopeWhere(scope),
          moodCheckinsMoodResponsesCheckinIdFamilyIdCoupleSpaceIdTomoodCheckins:
            {
              is: { ...scopeWhere(scope), userId: scope.userId },
            },
        },
        data: { deletedAt: now, updatedAt: now },
      });
      await tx.moodCheckin.updateMany({
        where: { ...scopeWhere(scope), userId: scope.userId },
        data: { deletedAt: now, updatedAt: now },
      });
    });
  }
  private async lockPair(
    tx: Prisma.TransactionClient,
    scope: CoupleCheckinScope,
  ): Promise<void> {
    // Serialize create/respond/delete so a superseded/deleted state cannot be responded to.
    const rows = await tx.$queryRaw<{ id: string }[]>(
      Prisma.sql`SELECT c.id FROM app.couple_spaces c JOIN app.families f ON f.id = c.family_id WHERE c.id = ${scope.coupleSpaceId}::uuid AND c.family_id = ${scope.familyId}::uuid AND c.status = 'ACTIVE' AND c.deleted_at IS NULL AND c.disabled_at IS NULL AND f.status = 'ACTIVE' AND f.deleted_at IS NULL AND (c.parent_a_user_id = ${scope.userId}::uuid OR c.parent_b_user_id = ${scope.userId}::uuid) FOR UPDATE OF c`,
    );
    if (!rows.length)
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
  }
}
