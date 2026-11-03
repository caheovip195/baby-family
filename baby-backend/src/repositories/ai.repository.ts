import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type {
  AiOutcome,
  IAiRepository,
} from '../interfaces/repositories/ai-repository.interface';
import { AiAccess, AiReservation } from '../models/ai-access.model';

const record = (value: unknown): Record<string, unknown> =>
  value && typeof value === 'object' && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : {};

/**
 * AI 1.2 (BF-20261028-010) trên bảng có sẵn: `ops.ai_invocations` (chỉ
 * metadata — không prompt / nội dung), `ops.ai_usage_reservations`,
 * `app.ai_usage_monthly`, `app.user_consents`, cài đặt AI ở `user_settings`.
 */
@Injectable()
export class AiRepository implements IAiRepository {
  constructor(private readonly prisma: PrismaService) {}

  async access(familyId: string, userId: string): Promise<AiAccess> {
    const [entitlement, settings] = await Promise.all([
      this.prisma.familyEntitlement.findFirst({
        where: { familyId, deletedAt: null },
        include: { planVersion: true },
      }),
      this.prisma.userSetting.findFirst({ where: { userId } }),
    ]);
    const plan = entitlement?.planVersion;
    const live = plan && plan.deletedAt === null;
    const features = record(live ? plan.features : null);
    const quotas = record(live ? plan.quotas : null);
    const perMonth = quotas.aiPerMonth;
    const toggles = record(settings?.aiFeatures);
    return new AiAccess(
      features['ai.enabled'] === true,
      typeof perMonth === 'number' && perMonth > 0 ? perMonth : 0,
      settings?.aiEnabled ?? true,
      Object.fromEntries(
        Object.entries(toggles).filter(
          (entry): entry is [string, boolean] => typeof entry[1] === 'boolean',
        ),
      ),
    );
  }

  async consent(userId: string, document: string, version: string) {
    const row = await this.prisma.userConsent.findFirst({
      where: { userId, document, deletedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    return row && row.granted && row.version === version ? row.id : null;
  }

  async grantConsent(userId: string, document: string, version: string) {
    return (
      await this.prisma.userConsent.create({
        data: { userId, document, version, granted: true },
      })
    ).id;
  }

  async recentMissionCategories(familyId: string, since: Date) {
    const rows = await this.prisma.mission.groupBy({
      by: ['category'],
      where: {
        familyId,
        deletedAt: null,
        missionCompletionsMissionCompletionsMissionIdTomissions: {
          some: {
            completedAt: { gte: since },
            undoneAt: null,
            deletedAt: null,
          },
        },
      },
      _count: { _all: true },
    });
    return Object.fromEntries(
      rows.map((row) => [row.category, row._count._all]),
    );
  }

  async used(familyId: string, month: Date, now: Date) {
    const [monthly, reserved] = await Promise.all([
      this.prisma.aiUsageMonthly.findFirst({
        where: { familyId, month, deletedAt: null },
      }),
      this.prisma.aiUsageReservation.count({
        where: {
          familyId,
          usageMonth: month,
          status: 'RESERVED',
          expiresAt: { gt: now },
          deletedAt: null,
        },
      }),
    ]);
    return (monthly?.used ?? 0) + reserved;
  }

  reserve(input: {
    familyId: string;
    userId: string;
    feature: string;
    promptVersion: string;
    model: string;
    consentId: string;
    month: Date;
    limit: number;
    expiresAt: Date;
  }): Promise<AiReservation | null> {
    return this.prisma.$transaction(async (tx) => {
      // Một gia đình giữ chỗ tuần tự để không vượt hạn mức khi bấm cùng lúc.
      await tx.$queryRaw`SELECT pg_advisory_xact_lock(hashtext(${`ai-usage:${input.familyId}`}))::text`;
      const now = new Date();
      const [monthly, reserved] = await Promise.all([
        tx.aiUsageMonthly.findFirst({
          where: {
            familyId: input.familyId,
            month: input.month,
            deletedAt: null,
          },
        }),
        tx.aiUsageReservation.count({
          where: {
            familyId: input.familyId,
            usageMonth: input.month,
            status: 'RESERVED',
            expiresAt: { gt: now },
            deletedAt: null,
          },
        }),
      ]);
      if ((monthly?.used ?? 0) + reserved >= input.limit) return null;
      const invocation = await tx.aiInvocation.create({
        data: {
          familyId: input.familyId,
          requesterUserId: input.userId,
          featureCode: input.feature,
          promptVersion: input.promptVersion,
          modelId: input.model.slice(0, 100),
          status: 'PENDING',
          consentId: input.consentId,
        },
      });
      const reservation = await tx.aiUsageReservation.create({
        data: {
          familyId: input.familyId,
          invocationId: invocation.id,
          idempotencyKey: randomUUID(),
          usageMonth: input.month,
          expiresAt: input.expiresAt,
        },
      });
      return new AiReservation(invocation.id, reservation.id);
    });
  }

  async finish(reservation: AiReservation, outcome: AiOutcome) {
    await this.prisma.$transaction(async (tx) => {
      const now = new Date();
      await tx.aiInvocation.update({
        where: { id: reservation.invocationId },
        data: {
          status: outcome.status,
          modelId: outcome.model.slice(0, 100),
          inputTokens: outcome.inputTokens,
          outputTokens: outcome.outputTokens,
          durationMs: outcome.durationMs,
          errorCode: outcome.errorCode,
        },
      });
      const row = await tx.aiUsageReservation.update({
        where: { id: reservation.reservationId },
        data:
          outcome.status === 'SUCCEEDED'
            ? { status: 'CONSUMED', consumedAt: now }
            : { status: 'RELEASED', releasedAt: now },
      });
      if (outcome.status === 'SUCCEEDED')
        await tx.aiUsageMonthly.upsert({
          where: {
            familyId_month: { familyId: row.familyId, month: row.usageMonth },
          },
          update: { used: { increment: 1 } },
          create: { familyId: row.familyId, month: row.usageMonth, used: 1 },
        });
    });
  }
}
