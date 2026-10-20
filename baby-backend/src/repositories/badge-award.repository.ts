import { Injectable } from '@nestjs/common';
import { BADGE_AWARD_POLICY } from '../config/badge-award-policy';
import { NOTIFICATION_POLICY } from '../config/notification-policy';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import type {
  BadgeAwardDecision,
  BadgeAwardSnapshot,
  IBadgeAwardRepository,
} from '../interfaces/repositories/badge-award-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';

@Injectable()
export class BadgeAwardRepository implements IBadgeAwardRepository {
  constructor(private readonly prisma: PrismaService) {}
  async eventFamily(eventId: string): Promise<string | null> {
    const event = await this.prisma.outboxEvent.findFirst({
      where: { eventId, eventType: 'mission.changed', deletedAt: null },
      select: { familyId: true },
    });
    return event?.familyId ?? null;
  }
  async families(after?: string): Promise<string[]> {
    return (
      await this.prisma.family.findMany({
        where: {
          status: 'ACTIVE',
          deletedAt: null,
          ...(after ? { id: { gt: after } } : {}),
        },
        select: { id: true },
        orderBy: { id: 'asc' },
        take: BADGE_AWARD_POLICY.batchSize,
      })
    ).map((f) => f.id);
  }
  private async fenced(
    tx: Prisma.TransactionClient,
    context: JobContext,
  ): Promise<void> {
    context.signal.throwIfAborted();
    const { lease } = context;
    const owned = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR UPDATE`;
    if (!owned.length) throw new Error('Badge award job lease lost.');
  }
  async award(
    familyId: string,
    now: Date,
    context: JobContext,
    evaluate: (snapshot: BadgeAwardSnapshot) => BadgeAwardDecision[],
  ): Promise<number> {
    return this.prisma.$transaction(
      async (tx) => {
        await this.fenced(tx, context);
        // NULL subjectUserId is not protected by PostgreSQL's ordinary unique key.
        // Serialize awards per family, including daily and event jobs, before checking.
        await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${familyId}::uuid FOR UPDATE`;
        if (
          !(await tx.family.findFirst({
            where: { id: familyId, status: 'ACTIVE', deletedAt: null },
          }))
        )
          return 0;
        const parents = await tx.familyParent.findMany({
          where: {
            familyId,
            status: 'ACTIVE',
            deletedAt: null,
            user: { status: 'ACTIVE', deletedAt: null },
          },
          select: { userId: true, user: { select: { locale: true } } },
        });
        const badges = await tx.badge.findMany({
          where: { status: 'ACTIVE', deletedAt: null },
          select: { code: true, scope: true, rule: true },
        });
        const mission = { familyId, status: 'DONE' as const, deletedAt: null };
        const [
          together,
          outdoor,
          memories,
          requests,
          appreciations,
          milestones,
          hearts,
        ] = await Promise.all([
          tx.mission.count({ where: { ...mission, ownerKind: 'TOGETHER' } }),
          tx.mission.count({ where: { ...mission, category: 'OUTDOOR' } }),
          tx.memory.count({ where: { familyId, deletedAt: null } }),
          tx.request.count({
            where: { familyId, status: 'DONE', deletedAt: null },
          }),
          tx.appreciation.count({ where: { familyId, deletedAt: null } }),
          tx.milestone.count({ where: { familyId, deletedAt: null } }),
          tx.heartLedger.groupBy({
            by: ['userId'],
            where: { familyId, deletedAt: null },
            _sum: { amount: true },
          }),
        ]);
        // Preserve the current CareProgressRepository catalog metric semantics.
        const snapshot: BadgeAwardSnapshot = {
          badges,
          parentIds: parents.map((p) => p.userId),
          heartsByUser: Object.fromEntries(
            hearts.map((h) => [h.userId, Math.max(0, h._sum.amount ?? 0)]),
          ),
          metrics: {
            BEDTIME_MISSIONS: together,
            READING_MISSIONS: together,
            TOGETHER_MISSIONS: together,
            OUTDOOR_MISSIONS: outdoor,
            MEMORIES_COUNT: memories,
            REQUESTS_DONE: requests,
            APPRECIATIONS_COUNT: appreciations,
            MILESTONES_COUNT: milestones,
          },
        };
        let awarded = 0;
        for (const decision of evaluate(snapshot)) {
          if (
            await tx.familyBadge.findFirst({
              where: {
                familyId,
                badgeCode: decision.badgeCode,
                subjectUserId: decision.subjectUserId,
              },
            })
          )
            continue;
          await tx.familyBadge.create({
            data: { familyId, ...decision, achievedAt: now },
          });
          const event = await tx.outboxEvent.create({
            data: {
              eventType: 'badge.earned',
              familyId,
              aggregateId: familyId,
              payload: { familyId, badgeCode: decision.badgeCode },
            },
          });
          for (const parent of parents) {
            if (
              decision.subjectUserId &&
              parent.userId !== decision.subjectUserId
            )
              continue;
            // Same inbox ledger shape as notification-inbox.persist; badges are in-app only.
            await tx.notification.create({
              data: {
                familyId,
                recipientUserId: parent.userId,
                eventId: event.eventId,
                templateCode: BADGE_AWARD_POLICY.templateCode,
                category: 'BADGES',
                priority: 'NORMAL',
                locale: parent.user.locale,
                subjectType: 'badge',
                subjectId: familyId,
                payloadReference: {
                  params: { badgeCode: decision.badgeCode },
                  tab: 'FAMILY',
                  deepLink: BADGE_AWARD_POLICY.deepLink,
                  count: 1,
                  policyVersion: BADGE_AWARD_POLICY.version,
                },
                sensitive: decision.subjectUserId !== null,
                expiresAt: new Date(
                  now.getTime() + NOTIFICATION_POLICY.retentionDays * 86400000,
                ),
              },
            });
          }
          awarded++;
        }
        await this.fenced(tx, context);
        return awarded;
      },
      { timeout: 30000 },
    );
  }
}
