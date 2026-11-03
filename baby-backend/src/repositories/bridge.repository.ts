import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import { BRIDGE_POLICY } from '../config/bridge-policy';
import type {
  BridgeSessionPatch,
  BridgeShareValues,
  IBridgeRepository,
} from '../interfaces/repositories/bridge-repository.interface';
import {
  BridgeNextStepRow,
  BridgeSessionRow,
  BridgeShareRow,
} from '../models/bridge-view.model';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';

const LIVE = ['INVITED', 'ACTIVE', 'PAUSED', 'AGREED'] as const;
const DAY_MS = 86_400_000;

type StepJson = {
  version?: number;
  code?: string;
  text?: string | null;
  at?: string | null;
  closeAgreed?: string[];
};

const step = (value: unknown): StepJson =>
  value && typeof value === 'object' && !Array.isArray(value) ? value : {};

/**
 * Cầu nối (BF-20261028-008/009) trên bảng có sẵn `us.conflict_sessions`,
 * `conflict_entries`, `conflict_confirmations`: `draft_enc` không dùng (nháp
 * ở lại máy), `topic` không dùng (chủ đề nằm trong `shared_points_enc`).
 * `next_step` JSON giữ phiên bản bước, mã, giờ, văn bản mã hoá và danh sách
 * đồng ý đóng.
 */
@Injectable()
export class BridgeRepository implements IBridgeRepository {
  constructor(private readonly prisma: PrismaService) {}

  private where(scope: CoupleCheckinScope) {
    return {
      familyId: scope.familyId,
      coupleSpaceId: scope.coupleSpaceId,
      deletedAt: null,
    };
  }

  private async rows(
    scope: CoupleCheckinScope,
    records: {
      id: string;
      openedBy: string;
      status: string;
      retentionDays: number;
      nextStep: Prisma.JsonValue;
      joinedAt: Date | null;
      closedAt: Date | null;
      purgeAt: Date | null;
      createdAt: Date;
    }[],
  ): Promise<BridgeSessionRow[]> {
    if (!records.length) return [];
    const ids = records.map((record) => record.id);
    const [entries, confirmations] = await Promise.all([
      this.prisma.conflictEntry.findMany({
        where: { sessionId: { in: ids }, deletedAt: null },
        orderBy: { createdAt: 'asc' },
      }),
      this.prisma.conflictConfirmation.findMany({
        where: { sessionId: { in: ids }, deletedAt: null },
      }),
    ]);
    const now = Date.now();
    return records.map((record) => {
      const json = step(record.nextStep);
      const version = json.version ?? 0;
      return new BridgeSessionRow(
        record.id,
        record.openedBy,
        record.openedBy === scope.userId ? scope.partnerUserId : scope.userId,
        record.status === 'AGREED'
          ? 'NEXT_STEP'
          : record.status === 'RESOLVED'
            ? 'CLOSED'
            : record.status,
        record.retentionDays,
        json.code
          ? new BridgeNextStepRow(
              version,
              json.code,
              json.text ?? null,
              json.at ? new Date(json.at) : null,
              confirmations
                .filter(
                  (item) =>
                    item.sessionId === record.id &&
                    item.stepVersion === version,
                )
                .map((item) => item.userId),
            )
          : null,
        json.closeAgreed ?? [],
        record.joinedAt,
        record.closedAt,
        record.purgeAt !== null && record.purgeAt.getTime() <= now,
        record.createdAt,
        entries
          .filter((entry) => entry.sessionId === record.id)
          .map(
            (entry) =>
              new BridgeShareRow(
                entry.userId,
                entry.feelings,
                entry.needs,
                entry.sharedPointsEnc,
                entry.understoodAt !== null,
              ),
          ),
      );
    });
  }

  async live(scope: CoupleCheckinScope) {
    const record = await this.prisma.conflictSession.findFirst({
      where: { ...this.where(scope), status: { in: [...LIVE] } },
      orderBy: { createdAt: 'desc' },
    });
    return record ? ((await this.rows(scope, [record]))[0] ?? null) : null;
  }

  async find(scope: CoupleCheckinScope, id: string) {
    const record = await this.prisma.conflictSession.findFirst({
      where: { ...this.where(scope), id, status: { not: 'PRIVATE_DRAFT' } },
    });
    return record ? ((await this.rows(scope, [record]))[0] ?? null) : null;
  }

  async list(scope: CoupleCheckinScope, limit: number) {
    return this.rows(
      scope,
      await this.prisma.conflictSession.findMany({
        where: { ...this.where(scope), status: { not: 'PRIVATE_DRAFT' } },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        take: limit,
      }),
    );
  }

  async create(
    scope: CoupleCheckinScope,
    retentionDays: number,
    share: BridgeShareValues,
  ) {
    const record = await this.prisma.$transaction(async (tx) => {
      const now = new Date();
      const row = await tx.conflictSession.create({
        data: {
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          openedBy: scope.userId,
          status: 'INVITED',
          retentionDays,
          invitedAt: now,
        },
      });
      await tx.conflictEntry.create({
        data: {
          sessionId: row.id,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          userId: scope.userId,
          feelings: share.feelings,
          needs: share.needs,
          sharedPointsEnc: share.sharedEnc
            ? Buffer.from(share.sharedEnc)
            : null,
          shareStatus: 'SHARED',
        },
      });
      // Thông báo trung tính, không chi tiết (7.17.1 giai đoạn 2).
      await tx.outboxEvent.create({
        data: {
          eventType: 'us.bridge.invited',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            sessionId: row.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            fromUserId: scope.userId,
            toUserId: scope.partnerUserId,
          },
        },
      });
      return row;
    });
    return (await this.rows(scope, [record]))[0]!;
  }

  async saveShare(
    scope: CoupleCheckinScope,
    sessionId: string,
    share: BridgeShareValues,
    clarify = false,
  ) {
    await this.prisma.$transaction(async (tx) => {
      const now = new Date();
      const data = {
        feelings: share.feelings,
        needs: share.needs,
        sharedPointsEnc: share.sharedEnc ? Buffer.from(share.sharedEnc) : null,
        shareStatus: 'SHARED',
        understoodAt: null,
        ...(clarify ? { clarifyRequestedAt: now } : {}),
      };
      const existing = await tx.conflictEntry.findFirst({
        where: { sessionId, userId: scope.userId, deletedAt: null },
        select: { id: true },
      });
      if (existing)
        await tx.conflictEntry.update({ where: { id: existing.id }, data });
      else
        await tx.conflictEntry.create({
          data: {
            ...data,
            sessionId,
            userId: scope.userId,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
          },
        });
      // Ý mới → người kia đọc lại.
      await tx.conflictEntry.updateMany({
        where: { sessionId, userId: { not: scope.userId }, deletedAt: null },
        data: { understoodAt: null },
      });
      await tx.conflictSession.updateMany({
        where: { ...this.where(scope), id: sessionId },
        data: { lastActivityAt: now },
      });
    });
  }

  async setUnderstood(scope: CoupleCheckinScope, sessionId: string) {
    await this.prisma.$transaction(async (tx) => {
      const now = new Date();
      const existing = await tx.conflictEntry.findFirst({
        where: { sessionId, userId: scope.userId, deletedAt: null },
        select: { id: true },
      });
      if (existing)
        await tx.conflictEntry.update({
          where: { id: existing.id },
          data: { understoodAt: now },
        });
      else
        await tx.conflictEntry.create({
          data: {
            sessionId,
            userId: scope.userId,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            understoodAt: now,
          },
        });
      await tx.conflictSession.updateMany({
        where: { ...this.where(scope), id: sessionId },
        data: { lastActivityAt: now },
      });
    });
  }

  async confirmStep(
    scope: CoupleCheckinScope,
    sessionId: string,
    version: number,
  ) {
    await this.prisma.conflictConfirmation.upsert({
      where: {
        sessionId_userId_stepVersion: {
          sessionId,
          userId: scope.userId,
          stepVersion: version,
        },
      },
      update: { deletedAt: null, confirmedAt: new Date() },
      create: {
        sessionId,
        familyId: scope.familyId,
        coupleSpaceId: scope.coupleSpaceId,
        userId: scope.userId,
        stepVersion: version,
      },
    });
  }

  async update(
    scope: CoupleCheckinScope,
    sessionId: string,
    patch: BridgeSessionPatch,
  ) {
    await this.prisma.$transaction(async (tx) => {
      const current = await tx.conflictSession.findFirst({
        where: { ...this.where(scope), id: sessionId },
      });
      if (!current) return;
      const json = step(current.nextStep);
      let nextJson: StepJson = json;
      if (patch.nextStep)
        nextJson = {
          ...json,
          version: (json.version ?? 0) + 1,
          code: patch.nextStep.code,
          text: patch.nextStep.textEnc,
          at: patch.nextStep.at?.toISOString() ?? null,
        };
      if (patch.closeAgreed)
        nextJson = { ...nextJson, closeAgreed: patch.closeAgreed };
      const status =
        patch.status === 'NEXT_STEP'
          ? 'AGREED'
          : patch.status === 'CLOSED'
            ? 'RESOLVED'
            : patch.status;
      await tx.conflictSession.update({
        where: { id: current.id },
        data: {
          ...(status ? { status } : {}),
          ...(patch.startedAt ? { joinedAt: patch.startedAt } : {}),
          ...(patch.closedAt ? { closedAt: patch.closedAt } : {}),
          ...(patch.purgeAt ? { purgeAt: patch.purgeAt } : {}),
          ...(nextJson !== json ? { nextStep: nextJson } : {}),
          lastActivityAt: new Date(),
        },
      });
      // Người chọn bước mới tự đồng ý với phiên bản đó.
      if (patch.nextStep)
        await tx.conflictConfirmation.create({
          data: {
            sessionId: current.id,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            userId: scope.userId,
            stepVersion: nextJson.version!,
          },
        });
    });
  }

  async housekeep(scope: CoupleCheckinScope | null, now: Date) {
    const base = scope ? this.where(scope) : { deletedAt: null as Date | null };
    const stale = new Date(now.getTime() - BRIDGE_POLICY.inactiveExpiryMs);
    return this.prisma.$transaction(async (tx) => {
      const expiring = await tx.conflictSession.findMany({
        where: {
          ...base,
          status: { in: [...LIVE] },
          lastActivityAt: { lt: stale },
        },
        select: { id: true, retentionDays: true },
      });
      for (const session of expiring)
        await tx.conflictSession.update({
          where: { id: session.id },
          data: {
            status: 'EXPIRED',
            closedAt: now,
            purgeAt: new Date(now.getTime() + session.retentionDays * DAY_MS),
          },
        });
      // Hết thời hạn lưu: xoá ý đã chia sẻ + bước tiếp, giữ dòng phiên.
      const due = await tx.conflictSession.findMany({
        where: {
          ...base,
          purgeAt: { lte: now },
          OR: [
            { nextStep: { not: Prisma.DbNull } },
            {
              conflictEntriesConflictEntriesSessionIdToconflictSessions: {
                some: { deletedAt: null },
              },
            },
          ],
        },
        select: { id: true },
      });
      if (due.length) {
        const ids = due.map((session) => session.id);
        await tx.conflictEntry.updateMany({
          where: { sessionId: { in: ids }, deletedAt: null },
          data: {
            deletedAt: now,
            feelings: [],
            needs: [],
            sharedPointsEnc: null,
            draftEnc: null,
          },
        });
        await tx.conflictConfirmation.updateMany({
          where: { sessionId: { in: ids }, deletedAt: null },
          data: { deletedAt: now },
        });
        await tx.conflictSession.updateMany({
          where: { id: { in: ids } },
          data: { nextStep: Prisma.DbNull, topic: null },
        });
      }
      return { expired: expiring.length, purged: due.length };
    });
  }
}
