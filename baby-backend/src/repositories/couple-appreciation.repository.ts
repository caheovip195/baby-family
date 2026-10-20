import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { Appreciation as AppreciationRow } from '../generated/prisma/client';
import type {
  ICoupleAppreciationRepository,
  CreateAppreciationCommand,
  ListAppreciationFilter,
} from '../interfaces/repositories/couple-appreciation-repository.interface';
import { Appreciation } from '../models/appreciation.model';
import {
  CoupleAppreciationScope,
  CoupleAppreciationView,
} from '../models/couple-appreciation-view.model';

const orderBy: Prisma.AppreciationOrderByWithRelationInput[] = [
  { createdAt: 'desc' },
  { id: 'desc' },
];

function view(row: AppreciationRow): CoupleAppreciationView {
  return new CoupleAppreciationView(new Appreciation(row));
}

@Injectable()
export class CoupleAppreciationRepository implements ICoupleAppreciationRepository {
  constructor(private readonly prisma: PrismaService) {}

  async resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleAppreciationScope | null> {
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
      ? new CoupleAppreciationScope(
          familyId,
          pair.id,
          userId,
          pair.parentAUserId === userId
            ? pair.parentBUserId
            : pair.parentAUserId,
        )
      : null;
  }

  async verifyLinkedItem(
    scope: CoupleAppreciationScope,
    linkedType: string,
    linkedId: string,
  ): Promise<boolean> {
    if (linkedType === 'MISSION') {
      const mission = await this.prisma.mission.findFirst({
        where: {
          id: linkedId,
          familyId: scope.familyId,
          deletedAt: null,
        },
      });
      return mission !== null;
    }

    if (linkedType === 'REQUEST') {
      const req = await this.prisma.request.findFirst({
        where: {
          id: linkedId,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          deletedAt: null,
        },
      });
      return req !== null;
    }

    if (linkedType === 'MEMORY') {
      const memory = await this.prisma.memory.findFirst({
        where: {
          id: linkedId,
          familyId: scope.familyId,
          deletedAt: null,
        },
      });
      return memory !== null;
    }

    return false;
  }

  async create(
    scope: CoupleAppreciationScope,
    input: CreateAppreciationCommand,
  ): Promise<CoupleAppreciationView> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.appreciation.create({
        data: {
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          fromUserId: scope.userId,
          toUserId: scope.partnerUserId,
          bodyEnc: new Uint8Array(input.bodyEnc),
          sticker: input.sticker,
          linkedType: input.linkedType,
          linkedId: input.linkedId,
          familyShareStatus: 'NONE',
          createdAt: input.createdAt,
        },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'us.appreciation.created',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            appreciationId: row.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            fromUserId: scope.userId,
            toUserId: scope.partnerUserId,
            linkedType: row.linkedType,
            linkedId: row.linkedId,
          },
        },
      });

      return view(row);
    });
  }

  async find(
    scope: CoupleAppreciationScope,
    id: string,
  ): Promise<CoupleAppreciationView | null> {
    const row = await this.prisma.appreciation.findFirst({
      where: {
        id,
        familyId: scope.familyId,
        coupleSpaceId: scope.coupleSpaceId,
        deletedAt: null,
        OR: [
          { fromUserId: scope.userId, deletedByFromAt: null },
          { toUserId: scope.userId, deletedByToAt: null },
        ],
      },
    });

    return row ? view(row) : null;
  }

  async listWall(
    scope: CoupleAppreciationScope,
    filter: ListAppreciationFilter,
  ): Promise<CoupleAppreciationView[]> {
    const visibilityFilter = {
      familyId: scope.familyId,
      coupleSpaceId: scope.coupleSpaceId,
      deletedAt: null,
      OR: [
        { fromUserId: scope.userId, deletedByFromAt: null },
        { toUserId: scope.userId, deletedByToAt: null },
      ],
    };

    let monthFilter: Prisma.DateTimeFilter | undefined;
    if (filter.month) {
      const parts = filter.month.split('-');
      const year = Number(parts[0]);
      const monthNum = Number(parts[1]);
      const startDate = new Date(Date.UTC(year, monthNum - 1, 1));
      const endDate = new Date(Date.UTC(year, monthNum, 1));
      monthFilter = { gte: startDate, lt: endDate };
    }

    const anchor = filter.cursor
      ? await this.prisma.appreciation.findFirst({
          where: { ...visibilityFilter, id: filter.cursor },
        })
      : null;

    if (filter.cursor && !anchor) {
      throw new DomainError(
        'The wall cursor is invalid.',
        'APPRECIATION_CURSOR_INVALID',
        400,
      );
    }

    const rows = await this.prisma.appreciation.findMany({
      where: {
        ...visibilityFilter,
        ...(monthFilter ? { createdAt: monthFilter } : {}),
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
      take: filter.limit,
    });

    return rows.map(view);
  }

  async react(
    scope: CoupleAppreciationScope,
    id: string,
    reaction: string,
  ): Promise<CoupleAppreciationView> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.appreciation.findFirst({
        where: {
          id,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          deletedAt: null,
        },
      });

      if (!row || row.deletedByToAt) {
        throw new DomainError(
          'Appreciation was not found.',
          'APPRECIATION_NOT_FOUND',
          404,
        );
      }

      if (row.toUserId !== scope.userId) {
        throw new DomainError(
          'Only the recipient can react to this appreciation.',
          'APPRECIATION_REACT_PARTNER_ONLY',
          422,
        );
      }

      const now = new Date();
      const updated = await tx.appreciation.update({
        where: { id },
        data: {
          reaction,
          seenAt: row.seenAt ?? now,
          updatedAt: now,
        },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'us.appreciation.reacted',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            appreciationId: row.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            fromUserId: row.fromUserId,
            reactedBy: scope.userId,
            reaction,
          },
        },
      });

      return view(updated);
    });
  }

  async requestShare(
    scope: CoupleAppreciationScope,
    id: string,
  ): Promise<CoupleAppreciationView> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.appreciation.findFirst({
        where: {
          id,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          deletedAt: null,
          OR: [
            { fromUserId: scope.userId, deletedByFromAt: null },
            { toUserId: scope.userId, deletedByToAt: null },
          ],
        },
      });

      if (!row) {
        throw new DomainError(
          'Appreciation was not found.',
          'APPRECIATION_NOT_FOUND',
          404,
        );
      }

      if (row.familyShareStatus === 'REQUESTED') {
        throw new DomainError(
          'Family share has already been requested.',
          'APPRECIATION_SHARE_ALREADY_REQUESTED',
          409,
        );
      }

      if (row.familyShareStatus === 'APPROVED') {
        throw new DomainError(
          'Appreciation is already approved for family feed.',
          'APPRECIATION_SHARE_ALREADY_APPROVED',
          409,
        );
      }

      const now = new Date();
      const updated = await tx.appreciation.update({
        where: { id },
        data: {
          familyShareStatus: 'REQUESTED',
          updatedAt: now,
        },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'us.appreciation.share_requested',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            appreciationId: row.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            requestedBy: scope.userId,
          },
        },
      });

      return view(updated);
    });
  }

  async respondShare(
    scope: CoupleAppreciationScope,
    id: string,
    approve: boolean,
    memoryBody: string | null,
  ): Promise<CoupleAppreciationView> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.appreciation.findFirst({
        where: {
          id,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          deletedAt: null,
          OR: [
            { fromUserId: scope.userId, deletedByFromAt: null },
            { toUserId: scope.userId, deletedByToAt: null },
          ],
        },
      });

      if (!row) {
        throw new DomainError(
          'Appreciation was not found.',
          'APPRECIATION_NOT_FOUND',
          404,
        );
      }

      // The sender must never approve their own appreciation, including retries.
      if (scope.userId === row.fromUserId) {
        throw new DomainError(
          'Only the partner can approve sharing as a family moment.',
          'APPRECIATION_SHARE_SELF_APPROVAL',
          422,
        );
      }
      // lockPair serializes concurrent approvals; the persisted link makes retries safe.
      if (
        approve &&
        row.familyShareStatus === 'APPROVED' &&
        row.familyMemoryId
      ) {
        return view(row);
      }
      if (row.familyShareStatus !== 'REQUESTED') {
        throw new DomainError(
          'Family share was not requested for this appreciation.',
          'APPRECIATION_SHARE_NOT_REQUESTED',
          422,
        );
      }

      const now = new Date();
      let familyMemoryId = row.familyMemoryId;
      if (approve && !familyMemoryId) {
        if (memoryBody === null) {
          throw new DomainError(
            'The appreciation body is unavailable.',
            'APPRECIATION_BODY_UNREADABLE',
            503,
          );
        }
        await this.consumeMemoryQuota(tx, scope.familyId);
        const family = await tx.family.findUniqueOrThrow({
          where: { id: scope.familyId },
          select: { timezone: true },
        });
        const localDate = new Intl.DateTimeFormat('en-CA', {
          timeZone: family.timezone,
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
        }).format(now);
        const memory = await tx.memory.create({
          data: {
            familyId: scope.familyId,
            authorUserId: row.fromUserId,
            authorRole: 'PARENT',
            kind: 'MOMENT',
            body: memoryBody,
            occurredAt: now,
            occurredLocalDate: new Date(`${localDate}T00:00:00.000Z`),
            visibility: 'PARENTS',
            status: 'PUBLISHED',
            publishedAt: now,
            familyMoment: true,
            sourceType: 'APPRECIATION',
            sourceId: row.id,
          },
        });
        familyMemoryId = memory.id;
        const payload = {
          memoryId: memory.id,
          familyId: scope.familyId,
          authorUserId: row.fromUserId,
          kind: memory.kind,
          status: memory.status,
          visibility: memory.visibility,
        };
        await tx.outboxEvent.createMany({
          data: ['memory.created', 'memory.published'].map((eventType) => ({
            eventType,
            familyId: scope.familyId,
            aggregateId: memory.id,
            payload,
          })),
        });
      }
      const nextStatus = approve ? 'APPROVED' : 'REJECTED';
      const updated = await tx.appreciation.update({
        where: { id },
        data: {
          familyShareStatus: nextStatus,
          familyMemoryId,
          updatedAt: now,
        },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: approve
            ? 'us.appreciation.share_approved'
            : 'us.appreciation.share_rejected',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            appreciationId: row.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            approvedBy: scope.userId,
            status: nextStatus,
            memoryId: familyMemoryId,
          },
        },
      });

      return view(updated);
    });
  }

  async delete(scope: CoupleAppreciationScope, id: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const row = await tx.appreciation.findFirst({
        where: {
          id,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          deletedAt: null,
        },
      });

      if (!row) {
        throw new DomainError(
          'Appreciation was not found.',
          'APPRECIATION_NOT_FOUND',
          404,
        );
      }

      const now = new Date();
      const deletedByFromAt =
        row.fromUserId === scope.userId ? now : row.deletedByFromAt;
      const deletedByToAt =
        row.toUserId === scope.userId ? now : row.deletedByToAt;
      const isFullDelete = deletedByFromAt !== null && deletedByToAt !== null;

      await tx.appreciation.update({
        where: { id },
        data: {
          deletedByFromAt,
          deletedByToAt,
          deletedAt: isFullDelete ? now : row.deletedAt,
          updatedAt: now,
        },
      });
    });
  }

  private async consumeMemoryQuota(
    tx: Prisma.TransactionClient,
    familyId: string,
  ): Promise<void> {
    // Approval locks couple -> usage; ordinary memory creation locks usage -> assets.
    await tx.$executeRaw`
      INSERT INTO billing.family_usage (family_id) VALUES (${familyId}::uuid)
      ON CONFLICT (family_id) DO NOTHING`;
    const [usage] = await tx.$queryRaw<{ memory_count: number }[]>`
      SELECT memory_count FROM billing.family_usage
      WHERE family_id = ${familyId}::uuid FOR UPDATE`;
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { planVersion: true },
    });
    const quotas =
      entitlement?.planVersion?.deletedAt === null
        ? entitlement.planVersion.quotas
        : null;
    if (!quotas || typeof quotas !== 'object' || Array.isArray(quotas)) {
      throw new DomainError(
        'The family plan does not allow memories.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    }
    const quota = quotas.memoryCount;
    if (
      quota !== undefined &&
      (typeof quota !== 'number' || !Number.isSafeInteger(quota) || quota < 0)
    ) {
      throw new DomainError(
        'The family plan has an invalid memory quota.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    }
    if (typeof quota === 'number' && (usage?.memory_count ?? 0) + 1 > quota) {
      throw new DomainError(
        'Memory quota of the current plan is exceeded.',
        'QUOTA_MEMORY_COUNT_EXCEEDED',
        402,
      );
    }
    await tx.$executeRaw`
      UPDATE billing.family_usage
      SET memory_count = memory_count + 1, version = version + 1
      WHERE family_id = ${familyId}::uuid`;
  }

  private async lockPair(
    tx: Prisma.TransactionClient,
    scope: CoupleAppreciationScope,
  ): Promise<void> {
    const rows = await tx.$queryRaw<{ id: string }[]>(
      Prisma.sql`SELECT c.id FROM app.couple_spaces c JOIN app.families f ON f.id = c.family_id WHERE c.id = ${scope.coupleSpaceId}::uuid AND c.family_id = ${scope.familyId}::uuid AND c.status = 'ACTIVE' AND c.deleted_at IS NULL AND c.disabled_at IS NULL AND f.status = 'ACTIVE' AND f.deleted_at IS NULL AND (c.parent_a_user_id = ${scope.userId}::uuid OR c.parent_b_user_id = ${scope.userId}::uuid) FOR UPDATE OF c`,
    );
    if (!rows.length) {
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
    }
  }
}
