import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type { ITimelineCardRepository } from '../interfaces/repositories/timeline-card-repository.interface';
import {
  TimelineMonthlyCover,
  TimelineMonthCounts,
  TimelineWeeklyRecap,
} from '../models/timeline-card-data.model';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions } from './viewer-exclusions';

@Injectable()
export class TimelineCardRepository implements ITimelineCardRepository {
  constructor(private readonly prisma: PrismaService) {}

  private async visible(familyId: string, userId: string) {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    const exclusions = await viewerExclusions(this.prisma, familyId, userId);
    return Prisma.sql`m.family_id = ${familyId}::uuid AND m.deleted_at IS NULL
      AND m.status IN ('PUBLISHED', 'PROCESSING') AND (${scope.sql})
      AND NOT(m.author_user_id = ANY(${exclusions.blockedUserIds}::uuid[]))
      AND NOT(m.id = ANY(${exclusions.hiddenMemoryIds}::uuid[]))`;
  }

  async monthlyCovers(familyId: string, userId: string, childId: string) {
    const visible = await this.visible(familyId, userId);
    const rows = await this.prisma.$queryRaw<
      {
        monthIndex: number;
        memoryId: string;
        assetId: string;
        birthDate: Date;
        occurredLocalDate: Date;
        monthlyPhotoLunar: boolean;
      }[]
    >(Prisma.sql`
      SELECT p.month_index AS "monthIndex", p.memory_id AS "memoryId", p.asset_id AS "assetId", c.birth_date AS "birthDate", m.occurred_local_date AS "occurredLocalDate", c.monthly_photo_lunar AS "monthlyPhotoLunar"
      FROM app.monthly_photos p
      JOIN app.memories m ON m.id = p.memory_id AND m.family_id = p.family_id
      JOIN app.memory_assets ma ON ma.memory_id = p.memory_id AND ma.asset_id = p.asset_id AND ma.family_id = p.family_id AND ma.deleted_at IS NULL
      JOIN app.assets a ON a.id = p.asset_id AND a.family_id = p.family_id AND a.deleted_at IS NULL AND a.status = 'READY' AND a.kind = 'IMAGE'
      JOIN app.children c ON c.id = p.child_id AND c.family_id = p.family_id AND c.deleted_at IS NULL AND c.status = 'ACTIVE'
      WHERE p.family_id = ${familyId}::uuid AND p.child_id = ${childId}::uuid
        AND p.deleted_at IS NULL AND p.month_index IS NOT NULL AND m.status = 'PUBLISHED' AND (${visible})
        AND EXISTS (SELECT 1 FROM app.memory_children mc WHERE mc.memory_id=m.id AND mc.family_id=m.family_id AND mc.child_id=p.child_id AND mc.deleted_at IS NULL)
        AND NOT EXISTS (SELECT 1 FROM app.memory_children mc WHERE mc.memory_id=m.id AND mc.family_id=m.family_id AND mc.child_id<>p.child_id AND mc.deleted_at IS NULL)
        AND m.pregnancy_id IS NULL AND NOT m.family_moment
      ORDER BY p.month_index ASC`);
    return rows.map(
      (row) =>
        new TimelineMonthlyCover(
          row.monthIndex,
          row.memoryId,
          row.assetId,
          row.birthDate,
          row.occurredLocalDate,
          row.monthlyPhotoLunar,
        ),
    );
  }

  async monthCounts(familyId: string, userId: string, childId: string) {
    const visible = await this.visible(familyId, userId);
    const rows = await this.prisma.$queryRaw<
      {
        monthIndex: number;
        memoryCount: number;
        firstsCount: number;
        quotesCount: number;
      }[]
    >(Prisma.sql`
      SELECT mc.age_month AS "monthIndex", count(*)::int AS "memoryCount",
        count(*) FILTER (WHERE m.kind = 'MILESTONE')::int AS "firstsCount",
        count(*) FILTER (WHERE m.kind = 'QUOTE')::int AS "quotesCount"
      FROM app.memory_children mc
      JOIN app.memories m ON m.id = mc.memory_id AND m.family_id = mc.family_id
      WHERE mc.family_id = ${familyId}::uuid AND mc.child_id = ${childId}::uuid
        AND mc.deleted_at IS NULL AND (${visible})
      GROUP BY mc.age_month`);
    return rows.map(
      (row) =>
        new TimelineMonthCounts(
          row.monthIndex,
          row.memoryCount,
          row.firstsCount,
          row.quotesCount,
        ),
    );
  }

  async weeklyRecaps(familyId: string, userId: string, childId?: string) {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    if (!scope.isParent && !scope.childIds.length && !scope.pregnancyIds.length)
      return [];
    if (childId && !scope.isParent && !scope.childIds.includes(childId))
      return [];
    const rows = await this.prisma.recap.findMany({
      where: {
        familyId,
        deletedAt: null,
        period: 'WEEK',
        status: { in: ['READY', 'SAVED', 'SHARED'] },
        ...(childId
          ? {
              scope: 'CHILD',
              childId,
              child: { deletedAt: null, status: 'ACTIVE' },
            }
          : { scope: 'FAMILY', childId: null }),
        // Shared recaps contain only metadata here; the recap read API applies
        // its current-viewer projection again before exposing any content.
        ...(scope.isParent
          ? { visibility: { in: ['PARENTS', 'FAMILY'] as const } }
          : { visibility: 'FAMILY' as const }),
      },
      select: { id: true, childId: true, periodStart: true },
      orderBy: [{ periodStart: 'desc' }, { id: 'desc' }],
    });
    return rows.map(
      (row) => new TimelineWeeklyRecap(row.id, row.childId, row.periodStart),
    );
  }
}
