import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { HEARTS_POLICY } from '../config/hearts-policy';
import { PrismaService } from '../database/prisma.service';
import type { IMemoryHeartAwardRepository } from '../interfaces/repositories/memory-heart-award-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';

@Injectable()
export class MemoryHeartAwardRepository implements IMemoryHeartAwardRepository {
  constructor(private readonly prisma: PrismaService) {}
  award(
    eventId: string,
    context: JobContext,
    policy: { award: number; awardsPerDay: number; dailyCap: number },
  ): Promise<number> {
    return this.prisma.$transaction(async (tx) => {
      context.signal.throwIfAborted();
      const { lease } = context;
      const owned = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR UPDATE`;
      if (!owned.length)
        throw new DomainError('Job lease lost.', 'JOB_LEASE_LOST', 409);
      const event = await tx.outboxEvent.findFirst({
        where: {
          eventId,
          eventType: {
            in: [
              'memory.created',
              'memory.published',
              'memory.perspective.changed',
              'memory.restored',
            ],
          },
          deletedAt: null,
        },
      });
      if (!event?.familyId || !event.aggregateId) return 0;
      const families = await tx.$queryRaw<
        { timezone: string }[]
      >`SELECT timezone FROM app.families WHERE id = ${event.familyId}::uuid AND status = 'ACTIVE' AND deleted_at IS NULL FOR UPDATE`;
      const family = families[0];
      if (!family) return 0;
      const memory = await tx.memory.findFirst({
        where: {
          id: event.aggregateId,
          familyId: event.familyId,
          status: 'PUBLISHED',
          deletedAt: null,
          trashedAt: null,
        },
        include: {
          memoryAsset: {
            where: {
              deletedAt: null,
              asset: { deletedAt: null, status: 'READY' },
            },
            take: 1,
          },
        },
      });
      if (
        !memory ||
        (event.eventType !== 'memory.perspective.changed' &&
          memory.authorRole !== 'PARENT')
      )
        return 0;
      let sourceId = memory.id;
      let userId = memory.authorUserId;
      let sourceType = 'MEMORY';
      let reason = 'MEMORY_CREATED';
      let date = memory.createdAt;
      let content =
        !!memory.body?.trim() ||
        !!memory.title?.trim() ||
        memory.memoryAsset.length > 0;
      if (event.eventType === 'memory.perspective.changed') {
        const payload = event.payload;
        if (
          !payload ||
          typeof payload !== 'object' ||
          Array.isArray(payload) ||
          typeof payload.perspectiveId !== 'string'
        )
          return 0;
        const perspective = await tx.memoryPerspective.findFirst({
          where: {
            id: payload.perspectiveId,
            memoryId: memory.id,
            familyId: memory.familyId,
            status: 'ACTIVE',
            deletedAt: null,
          },
          include: {
            memoryPerspectiveAssets: {
              where: {
                deletedAt: null,
                asset: { deletedAt: null, status: 'READY' },
              },
              take: 1,
            },
            asset: true,
          },
        });
        if (!perspective) return 0;
        sourceId = perspective.id;
        userId = perspective.authorUserId;
        sourceType = 'PERSPECTIVE';
        reason = 'PERSPECTIVE_ADDED';
        date = perspective.createdAt;
        content =
          !!perspective.body?.trim() ||
          perspective.memoryPerspectiveAssets.length > 0 ||
          (!!perspective.asset &&
            !perspective.asset.deletedAt &&
            perspective.asset.status === 'READY');
      }
      if (!content) return 0;
      const parent = await tx.familyParent.findFirst({
        where: {
          familyId: memory.familyId,
          userId,
          status: 'ACTIVE',
          deletedAt: null,
          leftAt: null,
          user: { status: 'ACTIVE', deletedAt: null },
        },
      });
      if (!parent) return 0;
      const parts = new Intl.DateTimeFormat('en-CA', {
        timeZone: family.timezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      }).formatToParts(date);
      const part = (key: string) => parts.find((p) => p.type === key)!.value;
      const localDate = new Date(
        `${part('year')}-${part('month')}-${part('day')}T00:00:00.000Z`,
      );
      await tx.$executeRaw`INSERT INTO app.heart_daily_counters (family_id, user_id, local_date) VALUES (${memory.familyId}::uuid, ${userId}::uuid, ${localDate}::date) ON CONFLICT (user_id, local_date) DO NOTHING`;
      const [counter] = await tx.$queryRaw<
        {
          total: number;
          memory_count: number;
          family_id: string;
          deleted_at: Date | null;
        }[]
      >`SELECT total, memory_count, family_id, deleted_at FROM app.heart_daily_counters WHERE user_id = ${userId}::uuid AND local_date = ${localDate}::date FOR UPDATE`;
      if (
        !counter ||
        counter.deleted_at ||
        counter.family_id !== memory.familyId
      )
        throw new DomainError(
          'Hearts counter unavailable.',
          'MEMORY_HEARTS_UNAVAILABLE',
          409,
        );
      if (
        await tx.heartLedger.findFirst({
          where: {
            userId,
            sourceType,
            sourceId,
            reason,
            deletedAt: null,
            reversalOf: null,
          },
        })
      )
        return 0;
      if (counter.memory_count >= policy.awardsPerDay) return 0;
      const amount = Math.min(
        policy.award,
        Math.max(0, policy.dailyCap - counter.total),
      );
      if (amount <= 0) return 0;
      await tx.heartLedger.create({
        data: {
          familyId: memory.familyId,
          userId,
          sourceType,
          sourceId,
          reason,
          amount,
          localDate,
        },
      });
      await tx.heartDailyCounter.update({
        where: { userId_localDate: { userId, localDate } },
        data: { total: { increment: amount }, memoryCount: { increment: 1 } },
      });
      // Atomic increment avoids lost updates against mission writers sharing the tree.
      const tree = await tx.familyTree.upsert({
        where: { familyId: memory.familyId },
        create: { familyId: memory.familyId, totalHearts: amount },
        update: {
          totalHearts: { increment: amount },
          version: { increment: 1 },
        },
      });
      if (tree.deletedAt)
        throw new DomainError(
          'Family tree unavailable.',
          'MEMORY_HEARTS_UNAVAILABLE',
          409,
        );
      const level = Math.max(
        tree.level,
        HEARTS_POLICY.treeLevelThresholds.filter((n) => tree.totalHearts >= n)
          .length,
      );
      const fruits = Math.max(
        tree.fruits,
        Math.floor(
          Math.max(0, tree.totalHearts - HEARTS_POLICY.treeLevelThresholds[6]) /
            HEARTS_POLICY.fruitEveryHearts,
        ),
      );
      await tx.familyTree.update({
        where: { familyId: memory.familyId },
        data: { level, fruits },
      });
      context.signal.throwIfAborted();
      return amount;
    });
  }
}
