import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { IMonthRecapRepository } from '../interfaces/repositories/month-recap-repository.interface';
import { MonthRecapChild, MonthRecapData } from '../models/month-recap.model';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions } from './viewer-exclusions';

/** REC-03 (BF-20261027-003): chỉ đọc, theo đúng quyền xem của feed. */
@Injectable()
export class MonthRecapRepository implements IMonthRecapRepository {
  constructor(private readonly prisma: PrismaService) {}

  async child(childId: string): Promise<MonthRecapChild | null> {
    const row = await this.prisma.child.findFirst({
      where: { id: childId, deletedAt: null, status: { not: 'DELETED' } },
      select: { id: true, familyId: true, birthDate: true },
    });
    return row
      ? new MonthRecapChild(row.id, row.familyId, row.birthDate)
      : null;
  }

  async canSeeChild(
    familyId: string,
    userId: string,
    childId: string,
  ): Promise<boolean> {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    return scope.isParent || scope.childIds.includes(childId);
  }

  async recap(
    familyId: string,
    userId: string,
    childId: string,
    ageMonth: number,
    monthIndexes: readonly number[],
    highlightLimit: number,
  ): Promise<MonthRecapData> {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    const exclusions = await viewerExclusions(this.prisma, familyId, userId);
    const visible = Prisma.sql`m.family_id = ${familyId}::uuid AND m.deleted_at IS NULL
      AND m.status IN ('PUBLISHED', 'PROCESSING') AND (${scope.sql})
      AND NOT(m.author_user_id = ANY(${exclusions.blockedUserIds}::uuid[]))
      AND NOT(m.id = ANY(${exclusions.hiddenMemoryIds}::uuid[]))`;
    const inMonth = Prisma.sql`FROM app.memory_children mc
      JOIN app.memories m ON m.id = mc.memory_id AND m.family_id = mc.family_id
      WHERE mc.family_id = ${familyId}::uuid AND mc.child_id = ${childId}::uuid
        AND mc.deleted_at IS NULL AND mc.age_month = ${ageMonth} AND (${visible})`;
    const [counts] = await this.prisma.$queryRaw<
      { moments: number; firsts: number; voices: number }[]
    >(Prisma.sql`SELECT count(*)::int AS moments,
        count(*) FILTER (WHERE m.kind = 'MILESTONE')::int AS firsts,
        count(*) FILTER (WHERE m.kind = 'VOICE')::int AS voices ${inMonth}`);
    const ids = (kind: string) =>
      this.prisma.$queryRaw<{ id: string }[]>(Prisma.sql`SELECT m.id::text AS id
        ${inMonth} AND m.kind = ${kind}::app.memory_kind
        ORDER BY m.occurred_at ASC, m.id ASC LIMIT ${highlightLimit}`);
    const [firsts, voices] = await Promise.all([
      ids('MILESTONE'),
      ids('VOICE'),
    ]);
    const photos = await this.prisma.$queryRaw<
      { monthIndex: number; memoryId: string; assetId: string }[]
    >(Prisma.sql`SELECT p.month_index AS "monthIndex", p.memory_id::text AS "memoryId",
        p.asset_id::text AS "assetId"
      FROM app.monthly_photos p
      JOIN app.memories m ON m.id = p.memory_id AND m.family_id = p.family_id
      JOIN app.assets a ON a.id = p.asset_id AND a.family_id = p.family_id
        AND a.deleted_at IS NULL AND a.status = 'READY' AND a.kind = 'IMAGE'
      WHERE p.family_id = ${familyId}::uuid AND p.child_id = ${childId}::uuid
        AND p.deleted_at IS NULL
        AND p.month_index = ANY(${[...monthIndexes]}::int[]) AND (${visible})`);
    return new MonthRecapData(
      counts?.moments ?? 0,
      counts?.firsts ?? 0,
      counts?.voices ?? 0,
      firsts.map((row) => row.id),
      voices.map((row) => row.id),
      new Map(
        photos.map((row) => [
          row.monthIndex,
          { memoryId: row.memoryId, assetId: row.assetId },
        ]),
      ),
    );
  }
}
