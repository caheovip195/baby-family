import { Injectable } from '@nestjs/common';
import { YEAR_BOOK_POLICY } from '../config/year-book-policy';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { IYearBookRepository } from '../interfaces/repositories/year-book-repository.interface';
import {
  SavedYearBook,
  SavedYearBookSummary,
  YearBookPlan,
  YearBookMemory,
  YearBookSubject,
} from '../models/year-book.model';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions } from './viewer-exclusions';

/**
 * REC-04 Sách của con / cả nhà (BF-20261028-013, BF-20261030-001): đọc ký ức
 * theo quyền xem của feed; bản chỉnh sửa lưu ở bảng có sẵn `app.recaps`
 * (scope CHILD / FAMILY, period YEAR).
 */
@Injectable()
export class YearBookRepository implements IYearBookRepository {
  constructor(private readonly prisma: PrismaService) {}

  async child(childId: string): Promise<YearBookSubject | null> {
    const row = await this.prisma.child.findFirst({
      where: { id: childId, deletedAt: null, status: { not: 'DELETED' } },
      select: {
        id: true,
        familyId: true,
        name: true,
        nickname: true,
        birthDate: true,
      },
    });
    return row
      ? new YearBookSubject(
          'CHILD',
          row.id,
          row.familyId,
          row.name ?? row.nickname ?? '',
          row.birthDate.getUTCFullYear(),
        )
      : null;
  }

  async family(familyId: string): Promise<YearBookSubject | null> {
    const row = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
      select: { id: true, name: true, createdAt: true },
    });
    if (!row) return null;
    const eldest = await this.prisma.child.aggregate({
      where: { familyId, deletedAt: null, status: { not: 'DELETED' } },
      _min: { birthDate: true },
    });
    const born = eldest._min.birthDate?.getUTCFullYear();
    const created = row.createdAt.getUTCFullYear();
    return new YearBookSubject(
      'FAMILY',
      null,
      row.id,
      row.name,
      born === undefined ? created : Math.min(born, created),
    );
  }

  async memories(
    subject: YearBookSubject,
    userId: string,
    from: Date,
    to: Date,
    limit: number,
  ): Promise<YearBookMemory[]> {
    const scope = await memoryContentScope(
      this.prisma,
      subject.familyId,
      userId,
    );
    const exclusions = await viewerExclusions(
      this.prisma,
      subject.familyId,
      userId,
    );
    // Cả nhà: mọi ký ức của gia đình (mọi bé + khoảnh khắc chung), mỗi ký ức
    // một lần dù gắn nhiều bé.
    const childFilter =
      subject.childId === null
        ? Prisma.empty
        : Prisma.sql`AND EXISTS (SELECT 1 FROM app.memory_children mc
            WHERE mc.memory_id = m.id AND mc.family_id = m.family_id
              AND mc.child_id = ${subject.childId}::uuid
              AND mc.deleted_at IS NULL)`;
    const rows = await this.prisma.$queryRaw<
      {
        id: string;
        kind: string;
        title: string | null;
        body: string | null;
        occurredAt: Date;
        localDate: string;
        assetIds: string[] | null;
      }[]
    >(Prisma.sql`SELECT m.id::text AS id, m.kind::text AS kind, m.title, m.body,
        m.occurred_at AS "occurredAt",
        m.occurred_local_date::text AS "localDate",
        array_agg(a.id::text ORDER BY ma.sort_order)
          FILTER (WHERE a.id IS NOT NULL) AS "assetIds"
      FROM app.memories m
      LEFT JOIN app.memory_assets ma ON ma.memory_id = m.id
        AND ma.family_id = m.family_id AND ma.deleted_at IS NULL
      LEFT JOIN app.assets a ON a.id = ma.asset_id AND a.family_id = ma.family_id
        AND a.deleted_at IS NULL AND a.status = 'READY' AND a.kind = 'IMAGE'
      WHERE m.family_id = ${subject.familyId}::uuid
        ${childFilter}
        AND m.deleted_at IS NULL AND m.status = 'PUBLISHED'
        AND m.occurred_local_date >= ${from}::date
        AND m.occurred_local_date < ${to}::date
        AND NOT(m.kind::text = ANY(${[...YEAR_BOOK_POLICY.excludedKinds]}::text[]))
        AND (${scope.sql})
        AND NOT(m.author_user_id = ANY(${exclusions.blockedUserIds}::uuid[]))
        AND NOT(m.id = ANY(${exclusions.hiddenMemoryIds}::uuid[]))
      GROUP BY m.id
      ORDER BY m.occurred_at ASC, m.id ASC
      LIMIT ${limit}`);
    return rows.map(
      (row) =>
        new YearBookMemory(
          row.id,
          row.kind,
          row.title,
          row.body,
          row.occurredAt,
          row.localDate,
          row.assetIds ?? [],
        ),
    );
  }

  private key(subject: YearBookSubject, yearStart: Date) {
    return {
      familyId: subject.familyId,
      scope: subject.scope,
      childId: subject.childId,
      period: 'YEAR',
      periodStart: yearStart,
    };
  }

  async saved(subject: YearBookSubject, yearStart: Date) {
    const row = await this.prisma.recap.findFirst({
      where: { ...this.key(subject, yearStart), deletedAt: null },
    });
    return row ? new SavedYearBook(row.content, row.updatedAt) : null;
  }

  async save(
    subject: YearBookSubject,
    yearStart: Date,
    yearEnd: Date,
    content: unknown,
    coverAssetId: string | null,
    shared: boolean,
    actorUserId: string,
  ) {
    const key = this.key(subject, yearStart);
    const data = {
      periodEnd: yearEnd,
      content: content as Prisma.InputJsonValue,
      coverAssetId,
      status: 'READY',
      visibility: shared ? ('FAMILY' as const) : ('PARENTS' as const),
      deletedAt: null,
    };
    await this.prisma.$transaction(async (tx) => {
      // child_id NULL (cả nhà) không bị unique chặn trùng: khoá theo sách.
      const lock = `yearbook:${key.familyId}:${key.scope}:${key.childId ?? '-'}:${yearStart.toISOString()}`;
      await tx.$queryRaw`SELECT pg_advisory_xact_lock(hashtext(${lock}))::text`;
      const existing = await tx.recap.findFirst({ where: key });
      const row = existing
        ? await tx.recap.update({ where: { id: existing.id }, data })
        : await tx.recap.create({ data: { ...key, ...data } });
      // Mới chia sẻ (trước đó riêng tư / chưa có): báo người thân một lần.
      const wasShared =
        existing?.deletedAt === null &&
        existing.visibility === 'FAMILY' &&
        isRecord(existing.content) &&
        existing.content.shared === true;
      if (shared && !wasShared)
        await tx.outboxEvent.create({
          data: {
            eventType: 'yearbook.shared',
            familyId: key.familyId,
            aggregateId: row.id,
            payload: {
              recapId: row.id,
              familyId: key.familyId,
              actorUserId,
            },
          },
        });
    });
  }

  async savedList(familyId: string) {
    const rows = await this.prisma.recap.findMany({
      where: {
        familyId,
        period: 'YEAR',
        scope: { in: ['CHILD', 'FAMILY'] },
        deletedAt: null,
        OR: [{ childId: null }, { child: { deletedAt: null } }],
      },
      include: { child: { select: { name: true, nickname: true } } },
      orderBy: [{ periodStart: 'desc' }, { updatedAt: 'desc' }],
    });
    const family = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
      select: { name: true },
    });
    return rows.map(
      (row) =>
        new SavedYearBookSummary(
          row.scope === 'FAMILY' ? 'FAMILY' : 'CHILD',
          row.childId,
          row.childId === null
            ? (family?.name ?? '')
            : (row.child?.name ?? row.child?.nickname ?? ''),
          row.periodStart.getUTCFullYear(),
          row.content,
          row.updatedAt,
        ),
    );
  }

  async viewer(familyId: string, userId: string) {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    return { isParent: scope.isParent, childIds: scope.childIds };
  }

  async plan(familyId: string) {
    const entitlement = await this.prisma.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { planVersion: true },
    });
    const plan = entitlement?.planVersion;
    const features =
      plan && plan.deletedAt === null && isRecord(plan.features)
        ? plan.features
        : {};
    const flag = (name: string) => {
      const value = features[name];
      return typeof value === 'boolean' ? value : null;
    };
    return new YearBookPlan(
      flag(YEAR_BOOK_POLICY.exportFeature),
      entitlement?.accessPhase ?? null,
      flag(YEAR_BOOK_POLICY.circleShareFeature),
      flag(YEAR_BOOK_POLICY.circleFeature) === true,
    );
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return Boolean(value) && typeof value === 'object' && !Array.isArray(value);
}
