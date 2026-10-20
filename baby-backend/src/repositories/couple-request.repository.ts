import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { COUPLE_REQUEST_POLICY } from '../config/couple-request-policy';
import { PrismaService } from '../database/prisma.service';
import type { RequestListQueryDto } from '../dto/us/request.dto';
import { Prisma } from '../generated/prisma/client';
import type { Request as RequestRow } from '../generated/prisma/client';
import type {
  CreateCoupleRequestCommand,
  ICoupleRequestRepository,
  RequestMutation,
} from '../interfaces/repositories/couple-request-repository.interface';
import { CoupleCheckinScope } from '../models/couple-checkin-view.model';
import { CoupleRequestView } from '../models/couple-request-view.model';
import { Request } from '../models/request.model';
import { CoupleRequestResendBlockedError } from '../models/couple-request-resend-blocked.model';

type Transaction = Prisma.TransactionClient;
type RequestWithChildren = RequestRow & {
  requestChildren: { childId: string }[];
};
const OPERATION = 'us.request.create';
const RELATIONS = {
  requestChildren: {
    where: { deletedAt: null, child: { deletedAt: null } },
    select: { childId: true },
  },
} satisfies Prisma.RequestInclude;
const ORDER = [
  { createdAt: 'desc' },
  { id: 'desc' },
] satisfies Prisma.RequestOrderByWithRelationInput[];

function view(row: RequestWithChildren): CoupleRequestView {
  return new CoupleRequestView(
    new Request(row),
    row.requestChildren.map((child) => child.childId),
  );
}
function scopeWhere(scope: CoupleCheckinScope): Prisma.RequestWhereInput {
  return {
    familyId: scope.familyId,
    coupleSpaceId: scope.coupleSpaceId,
    deletedAt: null,
    OR: [{ senderUserId: scope.userId }, { receiverUserId: scope.userId }],
  };
}

@Injectable()
export class CoupleRequestRepository implements ICoupleRequestRepository {
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
        family: { status: 'ACTIVE', deletedAt: null },
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

  findReplay(
    scope: CoupleCheckinScope,
    idempotencyKey: string,
    requestHash: Uint8Array,
  ): Promise<{ view: CoupleRequestView; openCount: number } | null> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      await this.expire(tx, scope, new Date());
      return this.replay(tx, scope, idempotencyKey, requestHash);
    });
  }

  create(
    scope: CoupleCheckinScope,
    command: CreateCoupleRequestCommand,
  ): Promise<{ view: CoupleRequestView; openCount: number }> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      await this.expire(tx, scope, command.now);
      const key = {
        scopeKey: scope.userId,
        operation: OPERATION,
        idempotencyKey: command.idempotencyKey,
      };
      const replay = await this.replay(
        tx,
        scope,
        command.idempotencyKey,
        command.requestHash,
      );
      if (replay) return replay;
      const openCount = await this.openCount(tx, scope);
      if (openCount >= COUPLE_REQUEST_POLICY.openLimit)
        throw new DomainError(
          'Too many open requests.',
          'REQUEST_OPEN_LIMIT',
          422,
        );
      const declined = await tx.request.findFirst({
        where: {
          ...scopeWhere(scope),
          senderUserId: scope.userId,
          status: 'DECLINED',
          contentKey: new Uint8Array(command.contentKey),
          respondedAt: {
            gt: new Date(
              command.now.getTime() - COUPLE_REQUEST_POLICY.resendBlockMs,
            ),
          },
        },
        orderBy: { respondedAt: 'desc' },
      });
      if (declined) {
        const retryAfter = new Date(
          declined.respondedAt!.getTime() + COUPLE_REQUEST_POLICY.resendBlockMs,
        ).toISOString();
        throw new CoupleRequestResendBlockedError(retryAfter);
      }
      if (command.templateId) {
        const template = await tx.missionTemplate.findFirst({
          where: {
            id: command.templateId,
            deletedAt: null,
            status: 'ACTIVE',
            requestable: true,
          },
        });
        if (!template)
          throw new DomainError(
            'Request template is unavailable.',
            'REQUEST_TEMPLATE_INVALID',
            422,
          );
        if (command.childIds.length > 1 && !template.multiChildOk)
          throw new DomainError(
            'This template supports only one child.',
            'REQUEST_TEMPLATE_INVALID',
            422,
          );
      }
      if (command.childIds.length) {
        const children = await tx.child.count({
          where: {
            id: { in: command.childIds },
            familyId: scope.familyId,
            deletedAt: null,
            status: 'ACTIVE',
          },
        });
        if (children !== command.childIds.length)
          throw new DomainError(
            'Some children do not belong to this family.',
            'CHILD_NOT_IN_FAMILY',
            422,
          );
      }
      const row = await tx.request.create({
        data: {
          id: command.id,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          senderUserId: scope.userId,
          receiverUserId: scope.partnerUserId,
          kind: command.kind,
          needCode: command.needCode,
          templateId: command.templateId,
          titleEnc:
            command.titleEnc === null ? null : new Uint8Array(command.titleEnc),
          durationMin: command.durationMin,
          contentKey: new Uint8Array(command.contentKey),
          messageEnc:
            command.messageEnc === null
              ? null
              : new Uint8Array(command.messageEnc),
          dueKind: command.dueKind,
          dueAt: command.dueAt,
          urgency: command.urgency,
          talkAt: command.talkAt,
          expiresAt: command.expiresAt,
          createdAt: command.now,
        },
      });
      if (command.childIds.length)
        await tx.requestChild.createMany({
          data: command.childIds.map((childId) => ({
            requestId: row.id,
            childId,
            familyId: scope.familyId,
          })),
        });
      await this.emit(tx, scope, row, 'us.request.sent');
      await tx.idempotencyRecord.create({
        data: {
          ...key,
          actorUserId: scope.userId,
          familyId: scope.familyId,
          requestHash: new Uint8Array(command.requestHash),
          status: 'SUCCEEDED',
          resultEntityType: 'request',
          resultEntityId: row.id,
          responseCode: 201,
          expiresAt: command.idempotencyExpiresAt,
        },
      });
      const result = await tx.request.findUniqueOrThrow({
        where: { id: row.id },
        include: RELATIONS,
      });
      return { view: view(result), openCount: openCount + 1 };
    });
  }

  list(
    scope: CoupleCheckinScope,
    query: RequestListQueryDto,
  ): Promise<CoupleRequestView[]> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      await this.expire(tx, scope, new Date());
      const where: Prisma.RequestWhereInput = {
        ...scopeWhere(scope),
        ...(query.box === 'OPEN'
          ? { status: { in: COUPLE_REQUEST_POLICY.openStatuses } }
          : {}),
        ...(query.box === 'HISTORY'
          ? { status: { notIn: COUPLE_REQUEST_POLICY.openStatuses } }
          : {}),
        ...(query.box === 'SENT' ? { senderUserId: scope.userId } : {}),
        ...(query.box === 'RECEIVED' ? { receiverUserId: scope.userId } : {}),
      };
      const anchor = query.cursor
        ? await tx.request.findFirst({ where: { ...where, id: query.cursor } })
        : null;
      if (query.cursor && !anchor)
        throw new DomainError(
          'Request cursor is invalid.',
          'REQUEST_CURSOR_INVALID',
          400,
        );
      const rows = await tx.request.findMany({
        where: {
          ...where,
          ...(anchor
            ? {
                AND: [
                  {
                    OR: [
                      { createdAt: { lt: anchor.createdAt } },
                      { createdAt: anchor.createdAt, id: { lt: anchor.id } },
                    ],
                  },
                ],
              }
            : {}),
        },
        include: RELATIONS,
        orderBy: ORDER,
        take: (query.limit ?? COUPLE_REQUEST_POLICY.defaultLimit) + 1,
      });
      return rows.map(view);
    });
  }

  find(
    scope: CoupleCheckinScope,
    id: string,
  ): Promise<CoupleRequestView | null> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      await this.expire(tx, scope, new Date());
      const row = await tx.request.findFirst({
        where: { ...scopeWhere(scope), id },
        include: RELATIONS,
      });
      return row ? view(row) : null;
    });
  }

  async transition(
    scope: CoupleCheckinScope,
    id: string,
    decide: (view: CoupleRequestView) => RequestMutation,
  ): Promise<CoupleRequestView> {
    const result = await this.prisma.$transaction(async (tx) => {
      await this.lockPair(tx, scope);
      const now = new Date();
      await this.expire(tx, scope, now);
      const row = await tx.request.findFirst({
        where: { ...scopeWhere(scope), id },
        include: RELATIONS,
      });
      if (!row)
        return {
          error: new DomainError(
            'Request was not found.',
            'REQUEST_NOT_FOUND',
            404,
          ),
        };
      let mutation: RequestMutation;
      try {
        mutation = decide(view(row));
      } catch (error) {
        if (error instanceof DomainError) return { error };
        throw error;
      }
      const { eventType, ...data } = mutation;
      const heartsAwarded =
        mutation.status === 'DONE'
          ? await this.awardHearts(tx, scope, row, now)
          : undefined;
      const updated = await tx.request.update({
        where: { id },
        data: {
          ...data,
          ...(heartsAwarded === undefined ? {} : { heartsAwarded }),
          version: { increment: 1 },
        },
        include: RELATIONS,
      });
      // TODO: QUIET acknowledgement needs the notification subsystem to set
      // quiet:user:{sender} for the configured window; no durable quiet-window
      // table or existing workflow is available in this repository scope.
      await this.emit(tx, scope, updated, eventType);
      return { view: view(updated) };
    });
    if (result.error) throw result.error;
    return result.view;
  }

  private async replay(
    tx: Transaction,
    scope: CoupleCheckinScope,
    idempotencyKey: string,
    requestHash: Uint8Array,
  ): Promise<{ view: CoupleRequestView; openCount: number } | null> {
    const record = await tx.idempotencyRecord.findUnique({
      where: {
        scopeKey_operation_idempotencyKey: {
          scopeKey: scope.userId,
          operation: OPERATION,
          idempotencyKey,
        },
      },
    });
    if (!record) return null;
    if (
      record.deletedAt ||
      !Buffer.from(record.requestHash).equals(Buffer.from(requestHash))
    )
      throw new DomainError(
        'Idempotency-Key was already used.',
        'IDEMPOTENCY_KEY_REUSED',
        409,
      );
    const replay = record.resultEntityId
      ? await tx.request.findFirst({
          where: { ...scopeWhere(scope), id: record.resultEntityId },
          include: RELATIONS,
        })
      : null;
    if (!replay)
      throw new DomainError('Request was not found.', 'REQUEST_NOT_FOUND', 404);
    return { view: view(replay), openCount: await this.openCount(tx, scope) };
  }

  private openCount(
    tx: Transaction,
    scope: CoupleCheckinScope,
  ): Promise<number> {
    return tx.request.count({
      where: {
        ...scopeWhere(scope),
        senderUserId: scope.userId,
        volunteered: false,
        status: { in: COUPLE_REQUEST_POLICY.openStatuses },
      },
    });
  }

  private async expire(
    tx: Transaction,
    scope: CoupleCheckinScope,
    now: Date,
  ): Promise<void> {
    const expired = await tx.request.findMany({
      where: {
        ...scopeWhere(scope),
        status: { in: COUPLE_REQUEST_POLICY.openStatuses },
        expiresAt: { lte: now },
      },
    });
    for (const row of expired) {
      await tx.request.update({
        where: { id: row.id },
        data: { status: 'EXPIRED', version: { increment: 1 } },
      });
      // State-only event. Expiry consumers must remain silent (no notification).
      await this.emit(
        tx,
        scope,
        { ...row, status: 'EXPIRED' },
        'us.request.expired',
      );
    }
  }

  private async emit(
    tx: Transaction,
    scope: CoupleCheckinScope,
    row: RequestRow,
    eventType: string,
  ): Promise<void> {
    await tx.outboxEvent.create({
      data: {
        eventType,
        familyId: scope.familyId,
        aggregateId: row.id,
        payload: {
          requestId: row.id,
          familyId: row.familyId,
          coupleSpaceId: row.coupleSpaceId,
          senderUserId: row.senderUserId,
          receiverUserId: row.receiverUserId,
          status: row.status,
        },
      },
    });
  }

  private async awardHearts(
    tx: Transaction,
    scope: CoupleCheckinScope,
    row: RequestRow,
    now: Date,
  ): Promise<number> {
    const family = await tx.family.findUniqueOrThrow({
      where: { id: scope.familyId },
      select: { timezone: true },
    });
    const dateParts = new Intl.DateTimeFormat('en-CA', {
      timeZone: family.timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).formatToParts(now);
    const part = (type: string) =>
      dateParts.find((item) => item.type === type)!.value;
    const localDate = new Date(
      `${part('year')}-${part('month')}-${part('day')}T00:00:00.000Z`,
    );
    // Counter lock is shared across all Hearts sources; the ledger unique index
    // additionally protects REQUEST/id/REQUEST_DONE from duplicate awards.
    await tx.$executeRaw`INSERT INTO app.heart_daily_counters (family_id, user_id, local_date)
      VALUES (${scope.familyId}::uuid, ${row.receiverUserId}::uuid, ${localDate}::date)
      ON CONFLICT (user_id, local_date) DO NOTHING`;
    const [counter] = await tx.$queryRaw<
      { total: number; deleted_at: Date | null }[]
    >`SELECT total, deleted_at FROM app.heart_daily_counters
      WHERE family_id = ${scope.familyId}::uuid AND user_id = ${row.receiverUserId}::uuid AND local_date = ${localDate}::date FOR UPDATE`;
    if (!counter || counter.deleted_at)
      throw new DomainError(
        'Hearts counter is unavailable.',
        'REQUEST_HEARTS_UNAVAILABLE',
        409,
      );
    const existing = await tx.heartLedger.findFirst({
      where: {
        userId: row.receiverUserId,
        sourceType: 'REQUEST',
        sourceId: row.id,
        reason: 'REQUEST_DONE',
        deletedAt: null,
        reversalOf: null,
      },
    });
    if (existing) return existing.amount;
    const amount = Math.min(
      COUPLE_REQUEST_POLICY.heartAward,
      Math.max(0, COUPLE_REQUEST_POLICY.dailyHeartCap - counter.total),
    );
    if (amount > 0) {
      await tx.heartLedger.create({
        data: {
          familyId: scope.familyId,
          userId: row.receiverUserId,
          sourceType: 'REQUEST',
          sourceId: row.id,
          reason: 'REQUEST_DONE',
          amount,
          localDate,
        },
      });
      await tx.heartDailyCounter.update({
        where: { userId_localDate: { userId: row.receiverUserId, localDate } },
        data: { total: { increment: amount } },
      });
    }
    return amount;
  }

  private async lockPair(
    tx: Transaction,
    scope: CoupleCheckinScope,
  ): Promise<void> {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >(Prisma.sql`SELECT c.id FROM app.couple_spaces c JOIN app.families f ON f.id = c.family_id
      WHERE c.id = ${scope.coupleSpaceId}::uuid AND c.family_id = ${scope.familyId}::uuid
      AND c.status = 'ACTIVE' AND c.deleted_at IS NULL AND c.disabled_at IS NULL AND f.status = 'ACTIVE' AND f.deleted_at IS NULL
      AND ((c.parent_a_user_id = ${scope.userId}::uuid AND c.parent_b_user_id = ${scope.partnerUserId}::uuid)
        OR (c.parent_b_user_id = ${scope.userId}::uuid AND c.parent_a_user_id = ${scope.partnerUserId}::uuid)) FOR UPDATE OF c`);
    if (!rows.length)
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
  }
}
