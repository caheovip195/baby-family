import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import { NotFoundError } from '../common/errors/domain.error';
import { WEEKLY_RECAP_POLICY } from '../config/weekly-recap-policy';
import type { IWeeklyRecapRepository } from '../interfaces/repositories/weekly-recap-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { Recap } from '../models/recap.model';
import { WeeklyRecapData } from '../models/weekly-recap-data.model';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions } from './viewer-exclusions';

@Injectable()
export class WeeklyRecapRepository implements IWeeklyRecapRepository {
  constructor(private readonly prisma: PrismaService) {}
  async families(after?: string) {
    return this.prisma.family.findMany({
      where: {
        status: 'ACTIVE',
        deletedAt: null,
        ...(after ? { id: { gt: after } } : {}),
      },
      orderBy: { id: 'asc' },
      take: WEEKLY_RECAP_POLICY.batchSize,
      select: { id: true, timezone: true, createdAt: true },
    });
  }
  async aggregate(
    familyId: string,
    start: string,
    end: string,
    timezone: string,
    viewer?: { userId: string; isParent: boolean; includePrivate?: boolean },
  ) {
    const scope = viewer
      ? await memoryContentScope(this.prisma, familyId, viewer.userId)
      : null;
    const exclusions = viewer
      ? await viewerExclusions(this.prisma, familyId, viewer.userId)
      : { blockedUserIds: [], hiddenMemoryIds: [] };
    const acl =
      scope?.sql ??
      Prisma.sql`m.visibility IN ('PARENTS','FAMILY') AND (m.unlock_at IS NULL OR m.unlock_at <= now())`;
    const [row] = await this.prisma.$queryRaw<
      {
        memoryCount: number;
        photoCount: number;
        videoCount: number;
        milestoneCount: number;
        byChild: { childId: string; memoryCount: number }[];
        topIds: string[];
        milestoneIds: string[];
        coverAssetId: string | null;
        missionsDone: number;
        appreciationCount: number;
      }[]
    >(Prisma.sql`
 WITH visible AS MATERIALIZED (
 SELECT m.* FROM app.memories m WHERE m.family_id=${familyId}::uuid AND m.deleted_at IS NULL AND m.status='PUBLISHED'
 AND (m.published_at AT TIME ZONE ${timezone})::date BETWEEN ${start}::date AND ${end}::date
 AND ${acl} AND (${viewer?.includePrivate === true} OR (m.visibility <> 'PRIVATE' AND (m.unlock_at IS NULL OR m.unlock_at <= now()))) AND NOT(m.author_user_id=ANY(${exclusions.blockedUserIds}::uuid[])) AND NOT(m.id=ANY(${exclusions.hiddenMemoryIds}::uuid[]))
 ), media AS (
 SELECT DISTINCT a.id,a.kind,ma.memory_id FROM app.memory_assets ma JOIN visible m ON m.id=ma.memory_id
 JOIN app.assets a ON a.id=ma.asset_id AND a.family_id=ma.family_id
 WHERE ma.family_id=${familyId}::uuid AND ma.deleted_at IS NULL AND a.deleted_at IS NULL AND a.status='READY' AND a.private_owner_user_id IS NULL
 ), ranked AS (SELECT id FROM visible ORDER BY reaction_count*2+comment_count DESC,published_at DESC,id DESC LIMIT ${WEEKLY_RECAP_POLICY.topLimit})
 SELECT (SELECT count(*)::int FROM visible) AS "memoryCount",
 (SELECT count(DISTINCT id)::int FROM media WHERE kind='IMAGE') AS "photoCount",
 (SELECT count(DISTINCT id)::int FROM media WHERE kind='VIDEO') AS "videoCount",
 (SELECT count(*)::int FROM app.milestones ms JOIN visible m ON m.id=ms.memory_id WHERE ms.family_id=${familyId}::uuid AND ms.deleted_at IS NULL) AS "milestoneCount",
 COALESCE((SELECT jsonb_agg(x) FROM (SELECT mc.child_id AS "childId",count(*)::int AS "memoryCount" FROM app.memory_children mc JOIN visible m ON m.id=mc.memory_id JOIN app.children c ON c.id=mc.child_id AND c.family_id=mc.family_id WHERE mc.family_id=${familyId}::uuid AND mc.deleted_at IS NULL AND c.deleted_at IS NULL GROUP BY mc.child_id ORDER BY mc.child_id) x),'[]'::jsonb) AS "byChild",
 ARRAY(SELECT id::text FROM ranked) AS "topIds",
 ARRAY(SELECT DISTINCT ms.memory_id::text FROM app.milestones ms JOIN visible m ON m.id=ms.memory_id WHERE ms.family_id=${familyId}::uuid AND ms.deleted_at IS NULL ORDER BY ms.memory_id::text LIMIT ${WEEKLY_RECAP_POLICY.topLimit}) AS "milestoneIds",
 (SELECT media.id::text FROM media JOIN ranked ON ranked.id=media.memory_id WHERE media.kind='IMAGE' ORDER BY media.id LIMIT 1) AS "coverAssetId",
 (SELECT count(*)::int FROM app.mission_completions mc JOIN app.missions mi ON mi.id=mc.mission_id AND mi.family_id=mc.family_id WHERE mc.family_id=${familyId}::uuid AND ${!viewer || viewer.isParent} AND mc.deleted_at IS NULL AND mc.undone_at IS NULL AND mi.deleted_at IS NULL AND mi.status='DONE' AND (mc.completed_at AT TIME ZONE ${timezone})::date BETWEEN ${start}::date AND ${end}::date) AS "missionsDone",
 (SELECT count(*)::int FROM us.appreciations a WHERE a.family_id=${familyId}::uuid AND ${!viewer || viewer.isParent} AND a.deleted_at IS NULL AND a.deleted_by_from_at IS NULL AND a.deleted_by_to_at IS NULL AND (a.created_at AT TIME ZONE ${timezone})::date BETWEEN ${start}::date AND ${end}::date) AS "appreciationCount"
 `);
    if (!row) throw new Error('Weekly aggregation returned no row.');
    return new WeeklyRecapData(
      {
        weekStart: start,
        memoryCount: row.memoryCount,
        photoCount: row.photoCount,
        videoCount: row.videoCount,
        milestoneCount: row.milestoneCount,
        byChild: row.byChild,
        ...(!viewer || viewer.isParent
          ? { missionsDone: row.missionsDone }
          : {}),
      },
      row.topIds,
      row.milestoneIds,
      row.coverAssetId,
      !viewer || viewer.isParent ? row.appreciationCount : 0,
    );
  }
  async save(
    familyId: string,
    start: string,
    end: string,
    data: WeeklyRecapData,
    context: JobContext,
  ) {
    await this.prisma.$transaction(async (tx) => {
      const { lease } = context;
      const owned = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM ops.job_runs WHERE id=${lease.runId}::uuid AND status='RUNNING' AND fencing_token=${lease.fencingToken} AND lease_owner=${lease.workerId} AND lease_expires_at>clock_timestamp() AND deleted_at IS NULL FOR UPDATE`;
      if (!owned.length) throw new Error('Weekly recap lease lost.');
      context.signal.throwIfAborted();
      await tx.$queryRaw`SELECT id FROM app.families WHERE id=${familyId}::uuid AND deleted_at IS NULL AND status='ACTIVE' FOR UPDATE`;
      const family = await tx.family.findFirst({
        where: { id: familyId, status: 'ACTIVE', deletedAt: null },
      });
      if (!family) return;
      const key = {
        familyId,
        scope: 'FAMILY',
        childId: null,
        period: 'WEEK',
        periodStart: new Date(start),
      };
      const existing = await tx.recap.findFirst({ where: key });
      const values = {
        periodEnd: new Date(end),
        content: JSON.parse(
          JSON.stringify(data.content()),
        ) as Prisma.InputJsonValue,
        contentParentsOnly: {
          version: 1,
          appreciationCount: data.appreciationCount,
        },
        coverAssetId: data.coverAssetId,
      };
      if (existing && !existing.deletedAt)
        await tx.recap.update({ where: { id: existing.id }, data: values });
      else if (!existing)
        await tx.recap.create({
          data: { ...key, ...values, visibility: 'PARENTS' },
        });
      const snapshot = await tx.careWeeklySnapshot.findFirst({
        where: { familyId, weekStart: new Date(start), childId: null },
      });
      const previousMetrics =
        snapshot?.metrics &&
        typeof snapshot.metrics === 'object' &&
        !Array.isArray(snapshot.metrics)
          ? snapshot.metrics
          : {};
      const metrics = {
        ...previousMetrics,
        recapWeekly: JSON.parse(
          JSON.stringify({ version: 1, ...data.stats }),
        ) as Prisma.InputJsonValue,
      };
      if (snapshot && !snapshot.deletedAt)
        await tx.careWeeklySnapshot.update({
          where: { id: snapshot.id },
          data: { metrics, computedAt: new Date() },
        });
      else if (!snapshot)
        await tx.careWeeklySnapshot.create({
          data: { familyId, weekStart: new Date(start), metrics },
        });
      const stillOwned = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM ops.job_runs WHERE id=${lease.runId}::uuid AND fencing_token=${lease.fencingToken} AND lease_expires_at>clock_timestamp()`;
      if (!stillOwned.length) throw new Error('Weekly recap lease expired.');
    });
  }
  private toRecap(row: Prisma.RecapGetPayload<object>) {
    return new Recap({
      ...row,
      content: cloneDatabaseJson(row.content),
      contentParentsOnly:
        row.contentParentsOnly === null
          ? null
          : cloneDatabaseJson(row.contentParentsOnly),
    });
  }

  private weekKey(familyId: string, recapId: string) {
    return {
      id: recapId,
      familyId,
      scope: 'FAMILY',
      childId: null,
      period: 'WEEK',
      deletedAt: null,
    };
  }

  async find(familyId: string, recapId: string) {
    const row = await this.prisma.recap.findFirst({
      where: this.weekKey(familyId, recapId),
    });
    return row ? this.toRecap(row) : null;
  }

  async sharePlan(familyId: string) {
    const entitlement = await this.prisma.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { planVersion: true },
    });
    const features = entitlement?.planVersion?.features;
    const map =
      features && typeof features === 'object' && !Array.isArray(features)
        ? (features as Record<string, unknown>)
        : {};
    const share = map[WEEKLY_RECAP_POLICY.circleShareFeature];
    return {
      share: typeof share === 'boolean' ? share : null,
      circle: map['circle.enabled'] === true,
    };
  }

  async share(
    familyId: string,
    recapId: string,
    shared: boolean,
    actorUserId: string,
  ) {
    await this.prisma.$transaction(async (tx) => {
      const [row] = await tx.$queryRaw<{ visibility: string }[]>`
        SELECT visibility::text AS visibility FROM app.recaps
        WHERE id = ${recapId}::uuid AND family_id = ${familyId}::uuid
          AND scope = 'FAMILY' AND period = 'WEEK' AND deleted_at IS NULL
        FOR UPDATE`;
      if (!row) throw new NotFoundError('Weekly recap was not found.');
      const visibility = shared ? 'FAMILY' : 'PARENTS';
      if (row.visibility === visibility) return;
      await tx.recap.update({
        where: { id: recapId },
        data: { visibility },
      });
      if (shared)
        await tx.outboxEvent.create({
          data: {
            eventType: 'recap.weekly.shared',
            familyId,
            aggregateId: recapId,
            payload: { recapId, familyId, actorUserId },
          },
        });
    });
  }

  async saveToTimeline(
    familyId: string,
    recapId: string,
    input: {
      authorUserId: string;
      titles: Record<string, string>;
      occurredAt: Date;
      localDate: Date;
      maxPhotos: number;
    },
  ) {
    return this.prisma.$transaction(async (tx) => {
      const [row] = await tx.$queryRaw<
        { memory_id: string | null; content: unknown }[]
      >`
        SELECT memory_id::text AS memory_id, content FROM app.recaps
        WHERE id = ${recapId}::uuid AND family_id = ${familyId}::uuid
          AND scope = 'FAMILY' AND period = 'WEEK' AND deleted_at IS NULL
        FOR UPDATE`;
      if (!row) throw new NotFoundError('Weekly recap was not found.');
      if (row.memory_id) {
        const existing = await tx.memory.findFirst({
          where: { id: row.memory_id, familyId, deletedAt: null },
          select: { id: true },
        });
        if (existing) return existing.id;
      }
      const top = (
        (row.content as { topMemories?: { id?: unknown }[] } | null)
          ?.topMemories ?? []
      )
        .map((item) => item.id)
        .filter((id): id is string => typeof id === 'string');
      const firsts = top.length
        ? await tx.$queryRaw<{ asset_id: string; memory_id: string }[]>`
            SELECT DISTINCT ON (ma.memory_id) ma.asset_id::text AS asset_id,
              ma.memory_id::text AS memory_id
            FROM app.memory_assets ma
            JOIN app.assets a ON a.id = ma.asset_id AND a.family_id = ma.family_id
            WHERE ma.family_id = ${familyId}::uuid
              AND ma.memory_id = ANY(${top}::uuid[]) AND ma.deleted_at IS NULL
              AND a.deleted_at IS NULL AND a.status = 'READY' AND a.kind = 'IMAGE'
            ORDER BY ma.memory_id, ma.sort_order`
        : [];
      // Giữ thứ tự nổi bật của recap.
      const assets = [...firsts].sort(
        (a, b) => top.indexOf(a.memory_id) - top.indexOf(b.memory_id),
      );
      const user = await tx.user.findFirst({
        where: { id: input.authorUserId },
        select: { locale: true },
      });
      const title =
        input.titles[user?.locale ?? 'vi'] ?? input.titles.vi ?? null;
      const memory = await tx.memory.create({
        data: {
          familyId,
          kind: 'MOMENT',
          title,
          authorUserId: input.authorUserId,
          authorRole: 'PARENT',
          occurredAt: input.occurredAt,
          occurredLocalDate: input.localDate,
          visibility: 'PARENTS',
          familyMoment: true,
          status: 'PUBLISHED',
          publishedAt: new Date(),
        },
      });
      const picked = assets.slice(0, input.maxPhotos);
      if (picked.length)
        await tx.memoryAsset.createMany({
          data: picked.map((asset, index) => ({
            memoryId: memory.id,
            assetId: asset.asset_id,
            familyId,
            sortOrder: index,
          })),
        });
      await tx.$executeRaw`
        UPDATE billing.family_usage
        SET memory_count = memory_count + 1, version = version + 1
        WHERE family_id = ${familyId}::uuid`;
      await tx.recap.update({
        where: { id: recapId },
        data: { memoryId: memory.id },
      });
      return memory.id;
    });
  }

  async list(
    familyId: string,
    circle: boolean,
    cursor: string | undefined,
    limit: number,
  ) {
    return (
      await this.prisma.recap.findMany({
        where: {
          familyId,
          scope: 'FAMILY',
          childId: null,
          period: 'WEEK',
          deletedAt: null,
          status: { in: ['READY', 'SAVED', 'SHARED'] },
          ...(circle ? { visibility: 'FAMILY' } : {}),
          ...(cursor ? { periodStart: { lt: new Date(cursor) } } : {}),
        },
        orderBy: [{ periodStart: 'desc' }, { id: 'desc' }],
        take: limit,
      })
    ).map(
      (row) =>
        new Recap({
          ...row,
          content: cloneDatabaseJson(row.content),
          contentParentsOnly:
            row.contentParentsOnly === null
              ? null
              : cloneDatabaseJson(row.contentParentsOnly),
        }),
    );
  }
}
