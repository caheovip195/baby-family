import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type {
  DayStoryValues,
  IDayStoryRecapRepository,
} from '../interfaces/repositories/day-story-recap-repository.interface';
import {
  DayStoryChild,
  DayStoryMemory,
  SavedDayStory,
} from '../models/day-story-recap.model';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions } from './viewer-exclusions';

type Row = {
  id: string;
  title: string;
  body: string | null;
  coverAssetId: string | null;
  memoryIds: string[];
  assetIds: string[];
  visibility: string;
  updatedAt: Date;
};

const toSaved = (row: Row) =>
  new SavedDayStory(
    row.id,
    row.title,
    row.body,
    row.coverAssetId,
    row.memoryIds,
    row.assetIds,
    row.visibility,
    row.updatedAt,
  );

const day = (date: string) => new Date(`${date}T00:00:00.000Z`);

/** REC-01 (BF-20261028-006): đọc ký ức trong ngày theo quyền xem của feed. */
@Injectable()
export class DayStoryRecapRepository implements IDayStoryRecapRepository {
  constructor(private readonly prisma: PrismaService) {}

  async child(childId: string): Promise<DayStoryChild | null> {
    const row = await this.prisma.child.findFirst({
      where: { id: childId, deletedAt: null, status: { not: 'DELETED' } },
      select: { id: true, familyId: true },
    });
    return row ? new DayStoryChild(row.id, row.familyId) : null;
  }

  async memories(
    child: DayStoryChild,
    userId: string,
    date: string,
    limit: number,
  ): Promise<DayStoryMemory[]> {
    const scope = await memoryContentScope(this.prisma, child.familyId, userId);
    const exclusions = await viewerExclusions(
      this.prisma,
      child.familyId,
      userId,
    );
    const rows = await this.prisma.$queryRaw<
      {
        id: string;
        kind: string;
        title: string | null;
        body: string | null;
        occurredAt: Date;
        assetIds: string[] | null;
      }[]
    >(Prisma.sql`SELECT m.id::text AS id, m.kind::text AS kind, m.title, m.body,
        m.occurred_at AS "occurredAt",
        array_agg(a.id::text ORDER BY ma.sort_order)
          FILTER (WHERE a.id IS NOT NULL) AS "assetIds"
      FROM app.memory_children mc
      JOIN app.memories m ON m.id = mc.memory_id AND m.family_id = mc.family_id
      LEFT JOIN app.memory_assets ma ON ma.memory_id = m.id
        AND ma.family_id = m.family_id AND ma.deleted_at IS NULL
      LEFT JOIN app.assets a ON a.id = ma.asset_id AND a.family_id = ma.family_id
        AND a.deleted_at IS NULL AND a.status = 'READY' AND a.kind = 'IMAGE'
      WHERE mc.family_id = ${child.familyId}::uuid
        AND mc.child_id = ${child.id}::uuid AND mc.deleted_at IS NULL
        AND m.deleted_at IS NULL AND m.status = 'PUBLISHED'
        AND m.occurred_local_date = ${day(date)}::date
        AND (${scope.sql})
        AND NOT(m.author_user_id = ANY(${exclusions.blockedUserIds}::uuid[]))
        AND NOT(m.id = ANY(${exclusions.hiddenMemoryIds}::uuid[]))
      GROUP BY m.id
      ORDER BY m.occurred_at ASC, m.id ASC
      LIMIT ${limit}`);
    return rows.map(
      (row) =>
        new DayStoryMemory(
          row.id,
          row.kind,
          row.title,
          row.body,
          row.occurredAt,
          row.assetIds ?? [],
        ),
    );
  }

  async saved(childId: string, date: string): Promise<SavedDayStory | null> {
    const row = await this.prisma.dayStory.findFirst({
      where: { childId, localDate: day(date), deletedAt: null },
    });
    return row ? toSaved(row) : null;
  }

  upsert(
    child: DayStoryChild,
    date: string,
    values: DayStoryValues,
    userId: string,
  ): Promise<SavedDayStory> {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.dayStory.findFirst({
        where: { childId: child.id, localDate: day(date), deletedAt: null },
        select: { id: true },
      });
      const row = existing
        ? await tx.dayStory.update({
            where: { id: existing.id },
            data: { ...values, updatedBy: userId },
          })
        : await tx.dayStory.create({
            data: {
              ...values,
              familyId: child.familyId,
              childId: child.id,
              localDate: day(date),
              createdBy: userId,
              updatedBy: userId,
            },
          });
      return toSaved(row);
    });
  }

  async remove(childId: string, date: string): Promise<void> {
    await this.prisma.dayStory.updateMany({
      where: { childId, localDate: day(date), deletedAt: null },
      data: { deletedAt: new Date() },
    });
  }
}
