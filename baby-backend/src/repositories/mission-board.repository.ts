import { createHash, randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { MissionRecurrenceModel } from '../models/mission-recurrence.model';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type {
  Mission as MissionRow,
  MissionTemplate as TemplateRow,
} from '../generated/prisma/client';
import { DomainError } from '../common/errors/domain.error';
import type { MissionCategory } from '../common/database.enums';
import { MISSION_POLICY as POLICY } from '../config/mission-policy';
import { HEARTS_POLICY } from '../config/hearts-policy';
import type {
  CreateMissionDto,
  CompleteMissionDto,
  SwapMissionDto,
} from '../dto/mission/mission.dto';
import type { IMissionBoardRepository } from '../interfaces/repositories/mission-board-repository.interface';
import { Mission } from '../models/mission.model';
import {
  MissionBoardView,
  MissionTemplateView,
} from '../models/mission-board-view.model';
import { MissionBoardBalanceModel } from '../models/mission-board-balance.model';
import { decideMissionTransition } from '../models/mission-board-state.model';

type Tx = Prisma.TransactionClient;
const relations = {
  missionChildren: {
    where: {
      deletedAt: null,
      child: { deletedAt: null, status: 'ACTIVE' as const },
    },
    select: { childId: true },
  },
  missionEventsMissionEventsMissionIdTomissions: {
    where: { deletedAt: null },
    select: { type: true, createdAt: true },
    orderBy: { createdAt: 'asc' as const },
  },
};
type Row = MissionRow & {
  missionChildren: { childId: string }[];
  missionEventsMissionEventsMissionIdTomissions: {
    type: string;
    createdAt: Date;
  }[];
};
type ResultMetadata = {
  myHeartsAwarded: number;
  tree?: { leaves: number; total: number; bloomed: boolean };
};
const view = (row: Row, metadata?: ResultMetadata) =>
  new MissionBoardView(
    new Mission(row),
    row.missionChildren.map((c) => c.childId),
    row.missionEventsMissionEventsMissionIdTomissions,
    metadata?.myHeartsAwarded,
    metadata?.tree,
  );
const title = (row: TemplateRow) => {
  const value = row.titleI18n as Record<string, unknown>;
  return typeof value.vi === 'string' ? value.vi : row.code;
};
const templateView = (row: TemplateRow) =>
  new MissionTemplateView(
    row.id,
    title(row),
    row.category,
    row.hearts,
    row.suggestedScope,
    row.multiChildOk,
    row.durationMin,
    row.roleFit,
  );
function fail(code: string, status = 422): never {
  throw new DomainError(code, code, status);
}
const hash = (value: unknown) =>
  createHash('sha256').update(JSON.stringify(value)).digest();
export function missionLocalDate(timezone: string, now = new Date()): string {
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(now);
  return ['year', 'month', 'day']
    .map((k) => parts.find((p) => p.type === k)!.value)
    .join('-');
}
const dateValue = (date: string) => new Date(`${date}T00:00:00.000Z`);

@Injectable()
export class MissionBoardRepository implements IMissionBoardRepository {
  constructor(private readonly prisma: PrismaService) {}
  async familyIdForActor(userId: string, childId?: string) {
    const parents = await this.prisma.familyParent.findMany({
      where: {
        userId,
        deletedAt: null,
        status: 'ACTIVE',
        family: {
          deletedAt: null,
          status: 'ACTIVE',
          ...(childId
            ? {
                children: {
                  some: { id: childId, deletedAt: null, status: 'ACTIVE' },
                },
              }
            : {}),
        },
      },
      select: { familyId: true },
      take: 2,
    });
    if (parents.length > 1) fail('FAMILY_SCOPE_REQUIRED');
    return parents[0]?.familyId ?? null;
  }
  async familyIdForMission(id: string) {
    return (
      (
        await this.prisma.mission.findFirst({
          where: { id, deletedAt: null },
          select: { familyId: true },
        })
      )?.familyId ?? null
    );
  }
  async find(id: string) {
    const row = await this.prisma.mission.findFirst({
      where: { id, deletedAt: null, status: { not: 'REMOVED' } },
      include: relations,
    });
    return row ? view(row) : null;
  }
  async templates(
    familyId: string,
    userId: string,
    category?: MissionCategory,
    childId?: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await this.lock(tx, familyId, userId);
      const context = await this.catalogContext(tx, familyId, new Date());
      if (childId && !context.children.some((c) => c.id === childId))
        fail('CHILD_NOT_IN_FAMILY');
      return context.templates
        .filter(
          (t) =>
            (!category || t.category === category) &&
            this.matches(t, context, childId),
        )
        .map(templateView);
    });
  }
  async board(familyId: string, userId: string, date: string, today: string) {
    return this.prisma.$transaction(
      async (tx) => {
        await this.lock(tx, familyId, userId);
        const boardDate = dateValue(date);
        const key = { familyId, boardDate };
        let board = await tx.dailyMissionBoard.findUnique({
          where: { familyId_boardDate: key },
        });
        if (!board && date === today) {
          await this.generate(tx, familyId, boardDate);
          board = await tx.dailyMissionBoard.findUnique({
            where: { familyId_boardDate: key },
          });
        }
        if (date === today) await this.materializeSeries(tx, familyId, date);
        if (board?.deletedAt) fail('MISSION_BOARD_UNAVAILABLE', 409);
        const expired = await tx.mission.findMany({
          where: {
            familyId,
            boardDate: { lt: dateValue(today) },
            status: 'TODO',
            deletedAt: null,
          },
        });
        for (const old of expired) {
          const updated = await tx.mission.update({
            where: { id: old.id, version: old.version },
            data: { status: 'EXPIRED', version: { increment: 1 } },
          });
          await this.emit(tx, updated, null, 'EXPIRED');
        }
        const rows = await tx.mission.findMany({
          where: {
            familyId,
            boardDate,
            deletedAt: null,
            status: { not: 'REMOVED' },
          },
          include: relations,
          orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
        });
        const counter = await tx.heartDailyCounter.findFirst({
          where: {
            familyId,
            userId,
            localDate: dateValue(today),
            deletedAt: null,
          },
        });
        const parent = await tx.dailyMissionBoardParent.findFirst({
          where: { ...key, userId, deletedAt: null },
        });
        return {
          board: board
            ? { level: board.level, bloomedAt: board.bloomedAt }
            : null,
          items: rows.map((row) => view(row)),
          swapsUsed: parent?.swapsUsed ?? 0,
          myHeartsToday: counter?.total ?? 0,
        };
      },
      { timeout: 15000 },
    );
  }
  /** Morning job (BF-20261019-003): ACTIVE families with both Parents active. */
  async familiesForBoards(): Promise<{ familyId: string; timezone: string }[]> {
    const rows = await this.prisma.family.findMany({
      where: {
        deletedAt: null,
        status: 'ACTIVE',
        familyParents: { some: { deletedAt: null, status: 'ACTIVE' } },
      },
      select: {
        id: true,
        timezone: true,
        _count: {
          select: {
            familyParents: { where: { deletedAt: null, status: 'ACTIVE' } },
          },
        },
      },
      orderBy: { id: 'asc' },
    });
    return rows
      .filter((row) => row._count.familyParents === 2)
      .map((row) => ({ familyId: row.id, timezone: row.timezone }));
  }
  /** Creates the family's board for `date` once; false when it already exists. */
  async prepareBoard(familyId: string, date: string): Promise<boolean> {
    return this.prisma.$transaction(
      async (tx) => {
        const rows = await tx.$queryRaw<
          { id: string }[]
        >`SELECT id FROM app.families WHERE id=${familyId}::uuid AND deleted_at IS NULL AND status='ACTIVE' FOR UPDATE`;
        if (!rows.length) return false;
        const boardDate = dateValue(date);
        const existing = await tx.dailyMissionBoard.findUnique({
          where: { familyId_boardDate: { familyId, boardDate } },
        });
        if (existing) return false;
        await this.generate(tx, familyId, boardDate);
        await this.materializeSeries(tx, familyId, date);
        return true;
      },
      { timeout: 15000 },
    );
  }
  async create(
    familyId: string,
    userId: string,
    input: CreateMissionDto,
    key: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await this.lock(tx, familyId, userId);
      const replay = await this.replay(
        tx,
        familyId,
        userId,
        'mission.create',
        key,
        hash(input),
      );
      if (replay) return replay;
      const now = new Date();
      const context = await this.catalogContext(
        tx,
        familyId,
        dateValue(
          input.boardDate ??
            input.date ??
            missionLocalDate(
              (await tx.family.findUniqueOrThrow({ where: { id: familyId } }))
                .timezone,
              now,
            ),
        ),
      );
      const template = input.templateId
        ? context.templates.find((t) => t.id === input.templateId)
        : undefined;
      if (input.templateId && !template) fail('MISSION_TEMPLATE_INVALID');
      const childIds = [...new Set(input.childIds ?? [])];
      if (childIds.length !== (input.childIds ?? []).length)
        fail('MISSION_SCOPE_INVALID');
      this.validateChildren(childIds, context);
      if (
        template &&
        (!this.matches(template, context) ||
          childIds.some((id) => !this.matches(template, context, id)) ||
          (!template.multiChildOk && childIds.length > 1))
      )
        fail('MISSION_TEMPLATE_INVALID');
      const role = await this.roleContext(tx, context);
      if (
        template &&
        ['PREGNANT_MOTHER', 'PARTNER_OF_PREGNANT'].includes(template.roleFit) &&
        (!role.perinatal ||
          template.roleFit !==
            (userId === role.carrier
              ? 'PREGNANT_MOTHER'
              : 'PARTNER_OF_PREGNANT'))
      )
        fail('MISSION_TEMPLATE_INVALID');
      const ownerKind = input.owner === 'TOGETHER' ? 'TOGETHER' : 'PARENT';
      if (ownerKind === 'TOGETHER') await this.requireTogether(tx, familyId);
      const targetScope =
        input.targetScope ??
        template?.suggestedScope ??
        (childIds.length > 1
          ? 'MULTI_CHILD'
          : childIds.length
            ? 'CHILD'
            : 'FAMILY');
      if (
        (targetScope === 'CHILD' && childIds.length !== 1) ||
        (targetScope === 'MULTI_CHILD' && childIds.length < 2) ||
        (['FAMILY', 'COUPLE'].includes(targetScope) && childIds.length > 0) ||
        (targetScope === 'COUPLE' && ownerKind !== 'TOGETHER')
      )
        fail('MISSION_SCOPE_INVALID');
      if (template?.roleFit === 'TOGETHER' && ownerKind !== 'TOGETHER')
        fail('MISSION_OWNER_INVALID');
      const boardDate = dateValue(
        input.boardDate ?? input.date ?? missionLocalDate(context.timezone),
      );
      const scheduledTime = input.scheduledTime
        ? new Date(`1970-01-01T${input.scheduledTime}:00.000Z`)
        : null;
      const dueAt = input.dueAt
        ? new Date(input.dueAt)
        : input.scheduledTime
          ? this.wallTime(boardDate, input.scheduledTime, context.timezone)
          : null;
      const row = await tx.mission.create({
        data: {
          familyId,
          boardDate,
          ownerKind,
          ownerUserId: ownerKind === 'PARENT' ? userId : null,
          source: template ? 'LIBRARY' : 'CUSTOM',
          templateId: template?.id,
          title: template ? title(template) : input.title!.trim(),
          note: input.note,
          category: template?.category ?? input.category ?? 'CUSTOM',
          targetScope,
          hearts: template?.hearts ?? POLICY.customHearts,
          createdBy: userId,
          scheduledTime,
          dueAt,
          memoryPrompt: input.memoryPrompt ?? true,
        },
      });
      await this.children(tx, row, childIds);
      await this.emit(tx, row, userId, 'CREATED');
      await this.remember(
        tx,
        familyId,
        userId,
        'mission.create',
        key,
        hash(input),
        row.id,
      );
      return view(
        await tx.mission.findUniqueOrThrow({
          where: { id: row.id },
          include: relations,
        }),
      );
    });
  }
  async act(
    id: string,
    userId: string,
    action: 'complete' | 'undo' | 'swap' | 'remove',
    key?: string,
    input?: SwapMissionDto | CompleteMissionDto,
  ) {
    const familyId = await this.familyIdForMission(id);
    if (!familyId) return fail('MISSION_NOT_FOUND', 404);
    return this.prisma.$transaction(
      async (tx) => {
        await this.lock(tx, familyId, userId);
        let row = await tx.mission.findFirst({
          where: { id, familyId, deletedAt: null },
          include: relations,
        });
        if (!row) return fail('MISSION_NOT_FOUND', 404);
        if (row.ownerKind === 'PARENT' && row.ownerUserId !== userId)
          fail('MISSION_NOT_OWNER', 403);
        if (row.ownerKind === 'TOGETHER')
          await this.requireTogether(tx, familyId);
        if (key) {
          const replay = await this.replay(
            tx,
            familyId,
            userId,
            `mission.${action}`,
            key,
            hash([id, input ?? null]),
          );
          if (replay) return replay;
        }
        const now = new Date();
        const family = await tx.family.findUniqueOrThrow({
          where: { id: familyId },
          select: { timezone: true },
        });
        const today = missionLocalDate(family.timezone, now);
        // Lazily expire the current row; the transition is committed with the action.
        if (row.status === 'TODO' && row.boardDate < dateValue(today))
          row = { ...row, status: 'EXPIRED' };
        const mutation = decideMissionTransition(
          view(row),
          userId,
          action,
          today,
          now,
        );
        let resultId = id;
        let myHeartsAwarded = 0;
        // TODO CARE-06: optional photo-to-memory projection is outside this MVP.
        if (action === 'complete') {
          if (!key) fail('IDEMPOTENCY_KEY_REQUIRED', 400);
          if (
            await tx.missionCompletion.findUnique({
              where: { idempotencyKey: key },
            })
          )
            fail('IDEMPOTENCY_KEY_REUSED', 409);
          const completion = await tx.missionCompletion.create({
            data: {
              missionId: id,
              familyId,
              completedBy: userId,
              late: mutation.late ?? false,
              idempotencyKey: key,
              completedAt: now,
              note: input && 'note' in input ? input.note : undefined,
            },
          });
          const parents =
            row.ownerKind === 'TOGETHER'
              ? await tx.familyParent.findMany({
                  where: { familyId, deletedAt: null, status: 'ACTIVE' },
                  orderBy: { userId: 'asc' },
                })
              : [{ userId: row.ownerUserId! }];
          for (const parent of parents) {
            const amount = await this.award(
              tx,
              row,
              parent.userId,
              completion.id,
              dateValue(today),
            );
            if (parent.userId === userId) myHeartsAwarded = amount;
          }
          await tx.mission.update({
            where: { id, version: row.version },
            data: {
              status: 'DONE',
              completedBy: userId,
              completedAt: now,
              late: mutation.late,
              version: { increment: 1 },
            },
          });
        } else if (action === 'undo') {
          const completion = await tx.missionCompletion.findFirst({
            where: { missionId: id, familyId, undoneAt: null, deletedAt: null },
          });
          if (!completion) fail('INVALID_MISSION_TRANSITION', 409);
          await this.reverse(tx, completion.id, familyId);
          await tx.missionCompletion.update({
            where: { id: completion.id },
            data: { undoneAt: now },
          });
          await tx.mission.update({
            where: { id, version: row.version },
            data: {
              status: mutation.status,
              completedAt: null,
              completedBy: null,
              late: false,
              version: { increment: 1 },
            },
          });
        } else if (action === 'swap') {
          if (
            !input ||
            !('templateId' in input) ||
            !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
              input.optionsToken,
            )
          )
            fail('MISSION_SWAP_NOT_ALLOWED');
          const parent = await tx.dailyMissionBoardParent.findFirst({
            where: {
              familyId,
              boardDate: row.boardDate,
              userId,
              deletedAt: null,
            },
          });
          if (!parent) fail('MISSION_SWAP_NOT_ALLOWED');
          if (parent.swapsUsed >= POLICY.swapsPerDay)
            fail('MISSION_SWAP_LIMIT');
          const record = await tx.idempotencyRecord.findUnique({
            where: {
              scopeKey_operation_idempotencyKey: {
                scopeKey: userId,
                operation: 'mission.swap-options',
                idempotencyKey: input.optionsToken,
              },
            },
          });
          const reference = record?.responseReference as {
            version?: number;
            options?: string[];
          } | null;
          if (
            !record ||
            record.deletedAt ||
            record.resultEntityId !== id ||
            record.familyId !== familyId ||
            !record.expiresAt ||
            record.expiresAt <= now ||
            reference?.version !== row.version ||
            !reference.options?.includes(input.templateId)
          )
            fail('MISSION_SWAP_NOT_ALLOWED');
          const options = await this.options(tx, row, userId);
          const chosen = options.find((t) => t.id === input.templateId);
          if (!chosen) fail('MISSION_SWAP_NOT_ALLOWED');
          await tx.mission.update({
            where: { id, version: row.version },
            data: {
              status: 'REMOVED',
              removedReason: 'SWAPPED',
              removedAt: now,
              deletedAt: now,
              version: { increment: 1 },
            },
          });
          const replacement = await tx.mission.create({
            data: {
              familyId,
              boardDate: row.boardDate,
              ownerKind: row.ownerKind,
              ownerUserId: row.ownerUserId,
              source: 'SYSTEM',
              templateId: chosen.id,
              swappedFromId: id,
              swapCount: row.swapCount + 1,
              title: title(chosen),
              category: chosen.category,
              targetScope: row.targetScope,
              hearts: chosen.hearts,
            },
          });
          await this.children(
            tx,
            replacement,
            row.missionChildren.map((c) => c.childId),
          );
          await tx.dailyMissionBoardParent.update({
            where: {
              familyId_boardDate_userId: {
                familyId,
                boardDate: row.boardDate,
                userId,
              },
            },
            data: { swapsUsed: { increment: 1 } },
          });
          await tx.idempotencyRecord.update({
            where: { id: record.id },
            data: { deletedAt: now },
          });
          await this.emit(tx, replacement, userId, 'CREATED');
          resultId = replacement.id;
        } else {
          await tx.mission.update({
            where: { id, version: row.version },
            data: {
              status: 'REMOVED',
              removedReason:
                row.source === 'SYSTEM' ? 'SKIPPED_TODAY' : 'DELETED',
              removedAt: now,
              deletedAt: now,
              version: { increment: 1 },
            },
          });
        }
        const updated = await tx.mission.findUniqueOrThrow({
          where: { id },
          include: relations,
        });
        await this.emit(tx, updated, userId, action.toUpperCase());
        await this.bloom(tx, familyId, row.boardDate);
        const treeRows = await tx.mission.findMany({
          where: {
            familyId,
            boardDate: row.boardDate,
            deletedAt: null,
            status: { not: 'REMOVED' },
          },
          select: { status: true },
        });
        const board = await tx.dailyMissionBoard.findFirst({
          where: { familyId, boardDate: row.boardDate, deletedAt: null },
        });
        const metadata = {
          myHeartsAwarded,
          tree: {
            leaves: treeRows.filter((m) => m.status === 'DONE').length,
            total: treeRows.length,
            bloomed: board?.bloomedAt != null,
          },
        };
        if (key)
          await this.remember(
            tx,
            familyId,
            userId,
            `mission.${action}`,
            key,
            hash([id, input ?? null]),
            resultId,
            metadata,
          );
        return view(
          await tx.mission.findUniqueOrThrow({
            where: { id: resultId },
            include: relations,
          }),
          metadata,
        );
      },
      { timeout: 15000 },
    );
  }
  async swapOptions(id: string, userId: string) {
    const familyId = await this.familyIdForMission(id);
    if (!familyId) return fail('MISSION_NOT_FOUND', 404);
    return this.prisma.$transaction(async (tx) => {
      await this.lock(tx, familyId, userId);
      const row = await tx.mission.findFirst({
        where: { id, deletedAt: null },
        include: relations,
      });
      if (!row) return fail('MISSION_NOT_FOUND', 404);
      const family = await tx.family.findUniqueOrThrow({
        where: { id: familyId },
      });
      decideMissionTransition(
        view(row),
        userId,
        'swap',
        missionLocalDate(family.timezone),
        new Date(),
      );
      const parent = await tx.dailyMissionBoardParent.findFirst({
        where: { familyId, boardDate: row.boardDate, userId, deletedAt: null },
      });
      if (!parent) fail('MISSION_SWAP_NOT_ALLOWED');
      if (parent.swapsUsed >= POLICY.swapsPerDay) fail('MISSION_SWAP_LIMIT');
      const options = (await this.options(tx, row, userId)).slice(
        0,
        POLICY.swapOptionsCount,
      );
      const optionsToken = randomUUID();
      await tx.idempotencyRecord.create({
        data: {
          familyId,
          actorUserId: userId,
          scopeKey: userId,
          operation: 'mission.swap-options',
          idempotencyKey: optionsToken,
          requestHash: hash([id, row.version]),
          status: 'SUCCEEDED',
          resultEntityType: 'mission',
          resultEntityId: id,
          responseReference: {
            version: row.version,
            options: options.map((t) => t.id),
          },
          expiresAt: new Date(Date.now() + POLICY.swapOptionsTtlMs),
        },
      });
      return {
        options: options.map(templateView),
        optionsToken,
        swapsLeft: POLICY.swapsPerDay - parent.swapsUsed,
      };
    });
  }
  private async lock(tx: Tx, familyId: string, userId: string) {
    // Family row serializes board/state writes; per-user counters also coordinate with other Hearts sources.
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT f.id FROM app.families f JOIN app.family_parents p ON p.family_id=f.id WHERE f.id=${familyId}::uuid AND f.deleted_at IS NULL AND f.status='ACTIVE' AND p.user_id=${userId}::uuid AND p.status='ACTIVE' AND p.deleted_at IS NULL FOR UPDATE OF f`;
    if (!rows.length) fail('FAMILY_ACCESS_DENIED', 403);
  }
  private async requireTogether(tx: Tx, familyId: string) {
    const pair = await tx.coupleSpace.findFirst({
      where: { familyId, deletedAt: null, status: 'ACTIVE', disabledAt: null },
    });
    const count = await tx.familyParent.count({
      where: {
        familyId,
        deletedAt: null,
        status: 'ACTIVE',
        userId: { in: pair ? [pair.parentAUserId, pair.parentBUserId] : [] },
      },
    });
    if (!pair || count !== 2) fail('MISSION_TOGETHER_UNAVAILABLE');
  }
  private async catalogContext(tx: Tx, familyId: string, date: Date) {
    const family = await tx.family.findUniqueOrThrow({
      where: { id: familyId },
    });
    const children = await tx.child.findMany({
      where: { familyId, deletedAt: null, status: 'ACTIVE' },
    });
    const pregnancies = await tx.pregnancy.findMany({
      where: { familyId, deletedAt: null, status: 'ACTIVE' },
    });
    const templates = await tx.missionTemplate.findMany({
      where: { deletedAt: null, status: 'ACTIVE' },
      orderBy: { code: 'asc' },
    });
    return {
      timezone: family.timezone,
      children,
      pregnancies,
      templates,
      date,
      familyId,
    };
  }
  private matches(
    t: TemplateRow,
    c: Awaited<ReturnType<MissionBoardRepository['catalogContext']>>,
    childId?: string,
  ) {
    const rollout = hash([c.familyId, t.code]).readUInt32BE(0) % 100;
    if (rollout >= t.rolloutPct) return false;
    if (t.stage === 'ANY') return true;
    if (t.stage === 'CHILD')
      return c.children.some((child) => {
        const age = Math.floor(
          (c.date.getTime() - child.birthDate.getTime()) / 86400000,
        );
        return (
          (!childId || child.id === childId) &&
          age >= 0 &&
          (t.minAgeDays === null || age >= t.minAgeDays) &&
          (t.maxAgeDays === null || age <= t.maxAgeDays)
        );
      });
    if (childId) return false;
    return (
      t.stage === 'PREGNANCY' &&
      c.pregnancies.some((p) => {
        if (!p.dueDate) return false;
        const week =
          Math.floor((c.date.getTime() - p.dueDate.getTime()) / 604800000) +
          POLICY.pregnancyDurationWeeks;
        return (
          week >= 0 &&
          (t.minPregWeek === null || week >= t.minPregWeek) &&
          (t.maxPregWeek === null || week <= t.maxPregWeek)
        );
      })
    );
  }
  private async roleContext(
    tx: Tx,
    context: Awaited<ReturnType<MissionBoardRepository['catalogContext']>>,
  ) {
    const pregnancy = [...context.pregnancies].sort(
      (a, b) =>
        (a.dueDate?.getTime() ?? Infinity) - (b.dueDate?.getTime() ?? Infinity),
    )[0];
    const newborn = context.children.find(
      (c) =>
        context.date.getTime() >= c.birthDate.getTime() &&
        context.date.getTime() - c.birthDate.getTime() <=
          POLICY.postpartumDays * 86400000,
    );
    const prior = newborn?.pregnancyId
      ? await tx.pregnancy.findFirst({
          where: {
            id: newborn.pregnancyId,
            familyId: context.familyId,
            deletedAt: null,
          },
        })
      : null;
    const fallback = await tx.familyParent.findFirst({
      where: {
        familyId: context.familyId,
        deletedAt: null,
        status: 'ACTIVE',
        kind: 'MOTHER',
      },
    });
    return {
      perinatal: !!pregnancy || !!newborn,
      carrier:
        pregnancy?.carrierUserId ?? prior?.carrierUserId ?? fallback?.userId,
    };
  }
  private validateChildren(
    ids: string[],
    context: Awaited<ReturnType<MissionBoardRepository['catalogContext']>>,
  ) {
    if (ids.some((id) => !context.children.some((c) => c.id === id)))
      fail('CHILD_NOT_IN_FAMILY');
  }
  /**
   * Custom repeating missions (series) for `date`: one mission per series and
   * day (DB unique `uq_series_day`), outside the system board quota.
   */
  private async materializeSeries(tx: Tx, familyId: string, date: string) {
    const boardDate = dateValue(date);
    const series = await tx.missionSeries.findMany({
      where: {
        familyId,
        deletedAt: null,
        status: 'ACTIVE',
        startDate: { lte: boardDate },
        OR: [{ endDate: null }, { endDate: { gte: boardDate } }],
      },
      include: { missionSeriesChildren: { where: { deletedAt: null } } },
    });
    for (const item of series) {
      const occurs = MissionRecurrenceModel.occursOn({
        rrule: item.rrule,
        startDate: item.startDate.toISOString().slice(0, 10),
        endDate: item.endDate?.toISOString().slice(0, 10) ?? null,
        pausedRanges: item.pausedRanges,
        date,
      });
      if (!occurs) continue;
      const existing = await tx.mission.findFirst({
        where: { seriesId: item.id, boardDate },
        select: { id: true },
      });
      if (existing) continue;
      if (item.ownerKind === 'TOGETHER') {
        const pair = await tx.coupleSpace.findFirst({
          where: {
            familyId,
            deletedAt: null,
            status: 'ACTIVE',
            disabledAt: null,
          },
          select: { id: true },
        });
        if (!pair) continue;
      }
      const time = item.timeOfDay?.toISOString().slice(11, 16) ?? null;
      const row = await tx.mission.create({
        data: {
          familyId,
          boardDate,
          ownerKind: item.ownerKind,
          ownerUserId: item.ownerUserId,
          source: 'SERIES',
          seriesId: item.id,
          templateId: item.templateId,
          title: item.title,
          note: item.note,
          category: item.category,
          targetScope: item.targetScope,
          hearts: item.hearts,
          scheduledTime: item.timeOfDay,
          dueAt: time ? this.wallTime(boardDate, time, item.timezone) : null,
        },
      });
      await this.children(
        tx,
        row,
        item.missionSeriesChildren.map((child) => child.childId),
      );
      await this.emit(tx, row, null, 'CREATED');
      await tx.missionSeries.update({
        where: { id: item.id },
        data: { generatedUntil: boardDate },
      });
    }
  }
  private async children(tx: Tx, row: MissionRow, ids: string[]) {
    if (ids.length)
      await tx.missionChild.createMany({
        data: ids.map((childId) => ({
          missionId: row.id,
          familyId: row.familyId,
          childId,
        })),
      });
  }
  private async emit(
    tx: Tx,
    row: MissionRow,
    actorUserId: string | null,
    type: string,
  ) {
    await tx.missionEvent.create({
      data: {
        missionId: row.id,
        familyId: row.familyId,
        actorUserId,
        type,
        data: { version: row.version },
      },
    });
    await tx.outboxEvent.create({
      data: {
        eventType: 'mission.changed',
        familyId: row.familyId,
        aggregateId: row.id,
        payload: {
          missionId: row.id,
          familyId: row.familyId,
          version: row.version,
        },
      },
    });
  }
  private async replay(
    tx: Tx,
    familyId: string,
    userId: string,
    operation: string,
    key: string,
    requestHash: Buffer,
  ) {
    const record = await tx.idempotencyRecord.findUnique({
      where: {
        scopeKey_operation_idempotencyKey: {
          scopeKey: userId,
          operation,
          idempotencyKey: key,
        },
      },
    });
    if (!record) return null;
    if (
      record.deletedAt ||
      record.familyId !== familyId ||
      !Buffer.from(record.requestHash).equals(requestHash)
    )
      fail('IDEMPOTENCY_KEY_REUSED', 409);
    const row = record.resultEntityId
      ? await tx.mission.findFirst({
          where: { id: record.resultEntityId, familyId },
          include: relations,
        })
      : null;
    if (!row) return fail('MISSION_NOT_FOUND', 404);
    if (record.responseReference) {
      const snapshot = record.responseReference as unknown as Row & {
        resultMetadata?: ResultMetadata;
      };
      for (const field of [
        'boardDate',
        'scheduledTime',
        'dueAt',
        'reminderAt',
        'completedAt',
        'removedAt',
        'createdAt',
        'updatedAt',
        'deletedAt',
      ] as const) {
        const value = snapshot[field];
        if (value != null)
          Object.assign(snapshot, { [field]: new Date(value) });
      }
      snapshot.missionEventsMissionEventsMissionIdTomissions =
        snapshot.missionEventsMissionEventsMissionIdTomissions.map((event) => ({
          ...event,
          createdAt: new Date(event.createdAt),
        }));
      return view(snapshot, snapshot.resultMetadata);
    }
    return view(row);
  }
  private async remember(
    tx: Tx,
    familyId: string,
    userId: string,
    operation: string,
    key: string,
    requestHash: Buffer,
    id: string,
    resultMetadata?: ResultMetadata,
  ) {
    const snapshot = await tx.mission.findUniqueOrThrow({
      where: { id },
      include: relations,
    });
    const responseReference = JSON.parse(
      JSON.stringify({ ...snapshot, resultMetadata }),
    ) as Prisma.InputJsonValue;
    await tx.idempotencyRecord.create({
      data: {
        familyId,
        actorUserId: userId,
        scopeKey: userId,
        operation,
        responseReference,
        idempotencyKey: key,
        requestHash: new Uint8Array(requestHash),
        status: 'SUCCEEDED',
        resultEntityType: 'mission',
        resultEntityId: id,
        responseCode: 201,
        expiresAt: new Date(Date.now() + 86400000 * 7),
      },
    });
  }
  private wallTime(date: Date, time: string, timezone: string) {
    const target = new Date(
      `${date.toISOString().slice(0, 10)}T${time}:00.000Z`,
    );
    let instant = target.getTime();
    for (let i = 0; i < 3; i++) {
      const parts = new Intl.DateTimeFormat('sv-SE', {
        timeZone: timezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hourCycle: 'h23',
      }).format(new Date(instant));
      const shown = new Date(parts.replace(' ', 'T') + 'Z').getTime();
      instant += target.getTime() - shown;
    }
    return new Date(instant);
  }
  private async generate(tx: Tx, familyId: string, boardDate: Date) {
    const parents = await tx.familyParent.findMany({
      where: { familyId, deletedAt: null, status: 'ACTIVE' },
      orderBy: { slot: 'asc' },
    });
    if (parents.length !== 2) fail('MISSION_BOARD_PARENTS_REQUIRED', 409);
    await this.requireTogether(tx, familyId);
    const setting = await tx.missionFamilySetting.findFirst({
      where: { familyId, deletedAt: null },
    });
    const level = setting?.boardLevel ?? POLICY.defaultLevel;
    const context = await this.catalogContext(tx, familyId, boardDate);
    const preferences = await tx.missionPreference.findMany({
      where: { familyId, deletedAt: null },
    });
    const recent = await tx.mission.findMany({
      where: {
        familyId,
        boardDate: {
          gte: new Date(
            boardDate.getTime() - POLICY.recentExclusionDays[0] * 86400000,
          ),
          lt: boardDate,
        },
        templateId: { not: null },
      },
      select: { templateId: true, boardDate: true, category: true },
    });
    const pregnancy = [...context.pregnancies].sort(
      (a, b) =>
        (a.dueDate?.getTime() ?? Infinity) - (b.dueDate?.getTime() ?? Infinity),
    )[0];
    const newborn = context.children.find(
      (c) =>
        boardDate.getTime() - c.birthDate.getTime() >= 0 &&
        boardDate.getTime() - c.birthDate.getTime() <=
          POLICY.postpartumDays * 86400000,
    );
    const birthPregnancy = newborn?.pregnancyId
      ? await tx.pregnancy.findFirst({
          where: { id: newborn.pregnancyId, familyId, deletedAt: null },
        })
      : null;
    const carrier =
      pregnancy?.carrierUserId ??
      birthPregnancy?.carrierUserId ??
      parents.find((p) => p.kind === 'MOTHER')?.userId;
    const week = pregnancy?.dueDate
      ? Math.floor(
          (boardDate.getTime() - pregnancy.dueDate.getTime()) / 604800000,
        ) + POLICY.pregnancyDurationWeeks
      : 0;
    const perinatal = !!pregnancy || !!newborn,
      latePhase = week >= POLICY.latePregnancyWeek || !!newborn;
    const categories = parents.map(
      (p) =>
        preferences.find((pref) => pref.userId === p.userId)
          ?.disabledCategories ?? [],
    );
    const fit = (t: TemplateRow, userId: string) =>
      t.roleFit === 'ANY_PARENT' ||
      (perinatal &&
        t.roleFit ===
          (userId === carrier ? 'PREGNANT_MOTHER' : 'PARTNER_OF_PREGNANT'));
    const sharedTired = await tx.moodCheckin.findMany({
      where: {
        familyId,
        deletedAt: null,
        shared: true,
        sharedFields: { has: 'mood' },
        mood: { in: ['TIRED', 'EXHAUSTED', 'OVERWHELMED'] },
        createdAt: {
          gte: new Date(Date.now() - POLICY.sharedMoodLookbackHours * 3600000),
        },
        expiresAt: { gt: new Date() },
        coupleSpacesMoodCheckinsCoupleSpaceIdTocoupleSpaces: {
          status: 'ACTIVE',
          disabledAt: null,
          deletedAt: null,
        },
      },
      select: { userId: true },
    });
    const categoryCounts = new Map<string, number>();
    for (const row of recent.filter(
      (r) =>
        r.boardDate.getTime() >=
        boardDate.getTime() - POLICY.diversityLookbackDays * 86400000,
    ))
      categoryCounts.set(
        row.category,
        (categoryCounts.get(row.category) ?? 0) + 1,
      );
    const minimumCategoryCount = Math.min(0, ...categoryCounts.values());
    const toCandidate = (t: TemplateRow, index: number) => ({
      ...t,
      weight:
        t.weight *
        (latePhase &&
        parents[index]!.userId === carrier &&
        t.category === 'SELF'
          ? POLICY.carrierSelfWeight
          : latePhase &&
              parents[index]!.userId !== carrier &&
              ['SUPPORT', 'CARE'].includes(t.category)
            ? POLICY.partnerCareWeight
            : 1) *
        (t.category === 'SUPPORT' &&
        sharedTired.some((m) => m.userId !== parents[index]!.userId)
          ? POLICY.sharedTiredSupportWeight
          : 1) *
        ((categoryCounts.get(t.category) ?? 0) <= minimumCategoryCount
          ? POLICY.underrepresentedCategoryWeight
          : 1),
      childIds: ['CHILD', 'MULTI_CHILD'].includes(t.suggestedScope)
        ? context.children
            .filter((c) => this.matches(t, context, c.id))
            .map((c) => c.id)
        : [],
    });
    const seed = `${familyId}:${boardDate.toISOString().slice(0, 10)}:${POLICY.generatorVersion}`;
    let result:
      | ReturnType<
          typeof MissionBoardBalanceModel.generate<
            ReturnType<typeof toCandidate>
          >
        >
      | undefined;
    for (const days of POLICY.recentExclusionDays) {
      const used = new Set(
        recent
          .filter(
            (r) =>
              r.boardDate.getTime() >= boardDate.getTime() - days * 86400000,
          )
          .map((r) => r.templateId),
      );
      const pool = (i: number) =>
        context.templates
          .filter(
            (t) =>
              !used.has(t.id) &&
              this.matches(t, context) &&
              !categories[i]!.includes(t.category) &&
              fit(t, parents[i]!.userId) &&
              t.roleFit !== 'TOGETHER',
          )
          .map((t) => toCandidate(t, i));
      const together = context.templates
        .filter(
          (t) =>
            t.roleFit === 'TOGETHER' &&
            !used.has(t.id) &&
            this.matches(t, context) &&
            categories.every((disabled) => !disabled.includes(t.category)),
        )
        .map((t) => toCandidate(t, 0));
      const current = MissionBoardBalanceModel.generate({
        seed,
        level,
        pools: [pool(0), pool(1)],
        togetherPool: together,
        childIds: context.children.map((child) => child.id),
        requiredCategories: [
          perinatal && parents[0]!.userId === carrier ? ['SELF'] : [],
          perinatal && parents[1]!.userId === carrier ? ['SELF'] : [],
        ],
      });
      if (
        !result ||
        current.quota > result.quota ||
        (current.quota === result.quota &&
          current.together.length > result.together.length)
      )
        result = current;
      if (
        current.quota === POLICY.levels[level].parentQuota &&
        (level === 'LIGHT' || current.together.length === 1)
      ) {
        result = current;
        break;
      }
    }
    if (
      !result ||
      result.quota < 2 ||
      result.balanceDiff > POLICY.maxBalanceDiff ||
      (level !== 'LIGHT' && result.together.length !== 1)
    )
      fail('MISSION_BOARD_POOL_INSUFFICIENT', 409);
    await tx.dailyMissionBoard.create({
      data: {
        familyId,
        boardDate,
        level,
        perParentCount: result.quota,
        togetherCount: result.together.length,
        balanceDiff: result.balanceDiff,
        generatorVersion: POLICY.generatorVersion,
        seed: BigInt(hash(seed).readUInt32BE(0)),
      },
    });
    await tx.dailyMissionBoardParent.createMany({
      data: parents.map((p, i) => ({
        familyId,
        boardDate,
        userId: p.userId,
        quotaCount: result.quota,
        heartsTotal: result.heartTotals[i]!,
      })),
    });
    const counts = new Map(context.children.map((c) => [c.id, 0]));
    for (const [index, set] of [...result.parents, result.together].entries())
      for (const candidate of set) {
        let ids: string[] = [],
          scope = candidate.suggestedScope;
        if (scope === 'CHILD' || scope === 'MULTI_CHILD') {
          const matches = [...candidate.childIds].sort(
            (a, b) =>
              (counts.get(a) ?? 0) - (counts.get(b) ?? 0) || a.localeCompare(b),
          );
          if (!matches.length) fail('MISSION_BOARD_POOL_INSUFFICIENT', 409);
          ids =
            candidate.multiChildOk && scope === 'MULTI_CHILD'
              ? matches
              : result.assignedChildIds[candidate.id]?.length
                ? result.assignedChildIds[candidate.id]!
                : [matches[0]!];
          scope = ids.length > 1 ? 'MULTI_CHILD' : 'CHILD';
          for (const id of ids) counts.set(id, (counts.get(id) ?? 0) + 1);
        }
        const row = await tx.mission.create({
          data: {
            familyId,
            boardDate,
            ownerKind: index < 2 ? 'PARENT' : 'TOGETHER',
            ownerUserId: index < 2 ? parents[index]!.userId : null,
            source: 'SYSTEM',
            templateId: candidate.id,
            title: title(candidate),
            category: candidate.category,
            targetScope: scope,
            hearts: candidate.hearts,
          },
        });
        await this.children(tx, row, ids);
        await this.emit(tx, row, null, 'CREATED');
      }
  }
  private async options(tx: Tx, row: Row, userId: string) {
    const context = await this.catalogContext(tx, row.familyId, row.boardDate);
    const pref = await tx.missionPreference.findFirst({
      where: { familyId: row.familyId, userId, deletedAt: null },
    });
    const used = await tx.mission.findMany({
      where: {
        familyId: row.familyId,
        boardDate: row.boardDate,
        templateId: { not: null },
      },
      select: { templateId: true },
    });
    const role = await this.roleContext(tx, context);
    const candidates = context.templates
      .filter(
        (t) =>
          Math.abs(t.hearts - row.hearts) <= POLICY.swapMaxHeartDifference &&
          !used.some((m) => m.templateId === t.id) &&
          !pref?.disabledCategories.includes(t.category) &&
          this.matches(t, context) &&
          row.missionChildren.every((c) =>
            this.matches(t, context, c.childId),
          ) &&
          (row.missionChildren.length <= 1 || t.multiChildOk) &&
          (t.suggestedScope === row.targetScope ||
            (row.targetScope === 'MULTI_CHILD' &&
              t.suggestedScope === 'CHILD' &&
              t.multiChildOk)) &&
          (row.ownerKind === 'TOGETHER'
            ? t.roleFit === 'TOGETHER'
            : t.roleFit === 'ANY_PARENT' ||
              (role.perinatal &&
                t.roleFit ===
                  (row.ownerUserId === role.carrier
                    ? 'PREGNANT_MOTHER'
                    : 'PARTNER_OF_PREGNANT'))),
      )
      .sort(
        (a, b) =>
          Number(a.category === row.category) -
            Number(b.category === row.category) || a.code.localeCompare(b.code),
      );
    const recent = await tx.mission.findMany({
      where: {
        familyId: row.familyId,
        boardDate: {
          gte: new Date(
            row.boardDate.getTime() - POLICY.recentExclusionDays[0] * 86400000,
          ),
          lt: row.boardDate,
        },
        templateId: { not: null },
      },
      select: { templateId: true, boardDate: true },
    });
    for (const days of POLICY.recentExclusionDays) {
      const excluded = new Set(
        recent
          .filter(
            (m) =>
              m.boardDate.getTime() >=
              row.boardDate.getTime() - days * 86400000,
          )
          .map((m) => m.templateId),
      );
      const pool = candidates.filter((t) => !excluded.has(t.id));
      if (pool.length >= POLICY.swapOptionsCount || days === 0) return pool;
    }
    return candidates;
  }
  private async award(
    tx: Tx,
    row: MissionRow,
    userId: string,
    completionId: string,
    localDate: Date,
  ) {
    await tx.$executeRaw`INSERT INTO app.heart_daily_counters (family_id,user_id,local_date) VALUES (${row.familyId}::uuid,${userId}::uuid,${localDate}::date) ON CONFLICT (user_id,local_date) DO NOTHING`;
    const [counter] = await tx.$queryRaw<
      {
        total: number;
        custom_count: number;
        deleted_at: Date | null;
        family_id: string;
      }[]
    >`SELECT total,custom_count,deleted_at,family_id FROM app.heart_daily_counters WHERE user_id=${userId}::uuid AND local_date=${localDate}::date FOR UPDATE`;
    if (!counter || counter.deleted_at || counter.family_id !== row.familyId)
      fail('MISSION_HEARTS_UNAVAILABLE', 409);
    const custom =
      row.source === 'CUSTOM' || (row.source === 'SERIES' && !row.templateId);
    if (custom && counter.custom_count >= POLICY.customAwardsPerDay) return 0;
    const amount = Math.min(
      row.hearts,
      Math.max(0, HEARTS_POLICY.dailyHeartCap - counter.total),
    );
    if (amount <= 0) return 0;
    await tx.heartLedger.create({
      data: {
        familyId: row.familyId,
        userId,
        sourceType: 'MISSION',
        sourceId: completionId,
        reason: custom ? 'CUSTOM_COMPLETED' : 'MISSION_COMPLETED',
        amount,
        localDate,
      },
    });
    await tx.heartDailyCounter.update({
      where: { userId_localDate: { userId, localDate } },
      data: {
        total: { increment: amount },
        ...(custom ? { customCount: { increment: 1 } } : {}),
      },
    });
    await this.tree(tx, row.familyId, amount);
    return amount;
  }
  private async reverse(tx: Tx, completionId: string, familyId: string) {
    const entries = await tx.heartLedger.findMany({
      where: {
        familyId,
        sourceId: completionId,
        sourceType: { in: ['MISSION', 'MISSION_PHOTO'] },
        reversalOf: null,
        deletedAt: null,
      },
      orderBy: { userId: 'asc' },
    });
    for (const e of entries) {
      await tx.$queryRaw`SELECT user_id FROM app.heart_daily_counters WHERE user_id=${e.userId}::uuid AND local_date=${e.localDate}::date FOR UPDATE`;
      await tx.heartLedger.create({
        data: {
          familyId,
          userId: e.userId,
          sourceType: e.sourceType,
          sourceId: completionId,
          reason: 'REVERSAL',
          amount: -e.amount,
          reversalOf: e.id,
          localDate: e.localDate,
        },
      });
      await tx.heartDailyCounter.update({
        where: {
          userId_localDate: { userId: e.userId, localDate: e.localDate },
        },
        data: {
          total: { decrement: e.amount },
          ...(e.reason === 'CUSTOM_COMPLETED'
            ? { customCount: { decrement: 1 } }
            : {}),
          ...(e.reason === 'MISSION_PHOTO'
            ? { photoCount: { decrement: 1 } }
            : {}),
        },
      });
      await this.tree(tx, familyId, -e.amount);
    }
  }
  private async tree(tx: Tx, familyId: string, amount: number) {
    const tree = await tx.familyTree.upsert({
      where: { familyId },
      create: { familyId },
      update: {},
    });
    if (tree.deletedAt) fail('MISSION_HEARTS_UNAVAILABLE', 409);
    const totalHearts = Math.max(0, tree.totalHearts + amount);
    const level = Math.max(
      tree.level,
      HEARTS_POLICY.treeLevelThresholds.filter((n) => totalHearts >= n).length,
    );
    const fruits = Math.max(
      tree.fruits,
      Math.floor(
        Math.max(0, totalHearts - HEARTS_POLICY.treeLevelThresholds[6]) /
          HEARTS_POLICY.fruitEveryHearts,
      ),
    );
    await tx.familyTree.update({
      where: { familyId },
      data: { totalHearts, level, fruits, version: { increment: 1 } },
    });
  }
  private async bloom(tx: Tx, familyId: string, boardDate: Date) {
    const board = await tx.dailyMissionBoard.findFirst({
      where: { familyId, boardDate, deletedAt: null, bloomedAt: null },
    });
    if (!board) return;
    const system = await tx.mission.findMany({
      where: {
        familyId,
        boardDate,
        source: 'SYSTEM',
        OR: [
          { deletedAt: null, status: { not: 'REMOVED' } },
          { removedReason: 'SKIPPED_TODAY' },
        ],
      },
      select: { status: true },
    });
    if (!system.length || system.some((m) => m.status !== 'DONE')) return;
    await tx.dailyMissionBoard.update({
      where: { familyId_boardDate: { familyId, boardDate } },
      data: { bloomedAt: new Date() },
    });
    await tx.familyTree.upsert({
      where: { familyId },
      create: { familyId, flowers: 1 },
      update: { flowers: { increment: 1 }, version: { increment: 1 } },
    });
  }
}
