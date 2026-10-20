import { memoryContentScope } from './memory-content-visibility';
import { memoryExclusionWhere, viewerExclusions } from './viewer-exclusions';
import type {
  TimelineRepositoryFilter,
  MediaGridRepositoryFilter,
} from '../interfaces/repositories/memory-content-repository.interface';
import {
  MemoryGridAsset,
  TimelineChildContext,
} from '../models/memory-view.model';
import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type {
  Asset as AssetRow,
  Memory as MemoryRow,
  MemoryAsset as MemoryAssetRow,
  MemoryChild as MemoryChildRow,
} from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type { ReactionType } from '../common/database.enums';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import type {
  CreateMemoryCommand,
  IMemoryContentRepository,
  MemoryFeedFilter,
  MemoryTrashCursor,
  RestoreMemoryCommand,
  TrashMemoryCommand,
  UpdateMemoryCommand,
} from '../interfaces/repositories/memory-content-repository.interface';
import { Memory } from '../models/memory.model';
import { MemoryView } from '../models/memory-view.model';
import type { MemoryCreationContext } from '../models/memory-view.model';
import { parentSharedAssetSql } from './parent-asset-visibility.sql';

type Transaction = Prisma.TransactionClient;
type MemoryWithRelations = MemoryRow & {
  memoryChildren: MemoryChildRow[];
  memoryAsset: (MemoryAssetRow & { asset: AssetRow })[];
  reactionsReactionsMemoryIdTomemories: {
    userId: string;
    type: ReactionType;
  }[];
};

const TRANSACTION_OPTIONS = {
  isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
  timeout: 10000,
};
const CREATE_OPERATION = 'memory.create';
const STORED_STATUSES = ['UPLOADED', 'PROCESSING', 'READY'];
const RELATIONS = {
  memoryChildren: { where: { deletedAt: null } },
  memoryAsset: {
    where: { deletedAt: null },
    include: { asset: true },
    orderBy: { sortOrder: 'asc' },
  },
  reactionsReactionsMemoryIdTomemories: {
    where: { deletedAt: null },
    select: { userId: true, type: true },
  },
} satisfies Prisma.MemoryInclude;

/**
 * Memory persistence (spec §6.3, §11.5). Creation locks the referenced asset rows,
 * so it serializes with the media worker: either the worker's READY commit is
 * seen here (memory published at once) or the worker's publish step sees the
 * committed memory (`MediaRepository.completeProcessing`).
 */
@Injectable()
export class MemoryContentRepository implements IMemoryContentRepository {
  constructor(private readonly prisma: PrismaService) {}

  async readableSubjects(
    familyId: string,
    userId: string,
  ): Promise<{
    isParent: boolean;
    childIds: string[];
    pregnancyIds: string[];
  }> {
    return memoryContentScope(this.prisma, familyId, userId);
  }
  async contributionSubjects(
    familyId: string,
    userId: string,
  ): Promise<{ childIds: string[]; pregnancyIds: string[] }> {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    return {
      childIds: scope.contributeChildIds,
      pregnancyIds: scope.contributePregnancyIds,
    };
  }

  async listDrafts(familyId: string, userId: string): Promise<MemoryView[]> {
    const rows = await this.prisma.memory.findMany({
      where: {
        familyId,
        authorUserId: userId,
        status: 'DRAFT',
        deletedAt: null,
      },
      include: RELATIONS,
      orderBy: [{ updatedAt: 'desc' }, { id: 'desc' }],
    });
    return rows.map((row) => mapView(row));
  }

  publish(
    familyId: string,
    userId: string,
    memoryId: string,
    expectedVersion: number,
  ): Promise<MemoryView> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockUsage(tx, familyId);
      const links = await tx.memoryAsset.findMany({
        where: { memoryId, familyId, deletedAt: null },
      });
      const ready = await this.lockAssets(
        tx,
        familyId,
        userId,
        links.map((a) => a.assetId),
      );
      const changed = await tx.memory.updateMany({
        where: {
          id: memoryId,
          familyId,
          authorUserId: userId,
          status: 'DRAFT',
          version: expectedVersion,
          deletedAt: null,
        },
        data: {
          status: ready ? 'PUBLISHED' : 'PROCESSING',
          publishedAt: ready ? new Date() : null,
          version: { increment: 1 },
        },
      });
      const row = await tx.memory.findFirst({
        where: {
          id: memoryId,
          familyId,
          authorUserId: userId,
          deletedAt: null,
        },
        include: RELATIONS,
      });
      if (!row) throw new NotFoundError('Memory was not found.');
      if (!changed.count && row.status === 'DRAFT')
        throw new DomainError(
          'Draft changed; reload.',
          'VERSION_CONFLICT',
          412,
        );
      if (changed.count && ready)
        await tx.outboxEvent.create({
          data: {
            eventType: 'memory.published',
            aggregateId: memoryId,
            familyId,
            payload: {
              memoryId,
              familyId,
              authorUserId: userId,
              kind: row.kind,
              status: row.status,
              visibility: row.visibility,
            },
          },
        });
      return mapView(row);
    }, TRANSACTION_OPTIONS);
  }

  async findCreationContext(
    familyId: string,
    actorUserId: string,
    input: {
      childIds: readonly string[];
      pregnancyId: string | null;
      assetIds: readonly string[];
    },
  ): Promise<MemoryCreationContext | null> {
    const family = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
      select: { timezone: true },
    });
    if (!family) return null;
    const [activeChildCount, children, pregnancy, assets, entitlement, shared] =
      await Promise.all([
        this.prisma.child.count({
          where: { familyId, status: 'ACTIVE', deletedAt: null },
        }),
        input.childIds.length
          ? this.prisma.child.findMany({
              where: { familyId, id: { in: [...input.childIds] } },
            })
          : Promise.resolve([]),
        input.pregnancyId
          ? this.prisma.pregnancy.findFirst({
              where: { familyId, id: input.pregnancyId },
            })
          : Promise.resolve(null),
        input.assetIds.length
          ? this.prisma.asset.findMany({
              where: { familyId, id: { in: [...input.assetIds] } },
            })
          : Promise.resolve([]),
        this.prisma.familyEntitlement.findFirst({
          where: { familyId, deletedAt: null },
          include: { planVersion: true },
        }),
        input.assetIds.length
          ? this.prisma.$queryRaw<{ id: string }[]>`
              SELECT a.id FROM app.assets a
              WHERE a.id = ANY(${[...input.assetIds]}::uuid[])
                AND a.family_id = ${familyId}::uuid
                AND a.deleted_at IS NULL
                AND ${parentSharedAssetSql(actorUserId)}`
          : Promise.resolve([]),
      ]);
    const sharedIds = new Set(shared.map((row) => row.id));
    const version = entitlement?.planVersion;
    const plan = version && version.deletedAt === null ? version : null;
    return {
      timezone: family.timezone,
      activeChildCount,
      children: children.map((child) => ({
        id: child.id,
        birthDate: child.birthDate,
        active: child.status === 'ACTIVE' && child.deletedAt === null,
      })),
      pregnancy: pregnancy
        ? {
            id: pregnancy.id,
            dueDate: pregnancy.dueDate,
            active:
              pregnancy.status === 'ACTIVE' && pregnancy.deletedAt === null,
          }
        : null,
      assets: assets
        .filter((asset) => asset.deletedAt === null)
        .map((asset) => ({
          id: asset.id,
          uploaderUserId: asset.uploaderUserId,
          purpose: asset.purpose,
          status: asset.status,
          sharedWithActor: sharedIds.has(asset.id),
        })),
      quotas: plan?.quotas ?? null,
      features: plan?.features ?? null,
    };
  }

  async findReplay(
    authorUserId: string,
    idempotencyKey: string,
    requestHash: Uint8Array,
  ): Promise<MemoryView | null> {
    const record = await this.prisma.idempotencyRecord.findUnique({
      where: {
        scopeKey_operation_idempotencyKey: {
          scopeKey: authorUserId,
          operation: CREATE_OPERATION,
          idempotencyKey,
        },
      },
    });
    if (!record || record.deletedAt) return null;
    if (!Buffer.from(record.requestHash).equals(Buffer.from(requestHash)))
      throw new DomainError(
        'Idempotency-Key was used for a different request.',
        'IDEMPOTENCY_KEY_REUSED',
        409,
      );
    const row = record.resultEntityId
      ? await this.prisma.memory.findFirst({
          where: {
            id: record.resultEntityId,
            deletedAt: null,
            status: { notIn: ['TRASHED', 'PURGED'] },
          },
          include: RELATIONS,
        })
      : null;
    // The key already produced a memory that is gone (trashed): never recreate it.
    if (!row) throw new NotFoundError('Memory was not found.');
    return mapView(row);
  }

  async create(command: CreateMemoryCommand): Promise<MemoryView> {
    try {
      return await this.prisma.$transaction(
        (tx) => this.createInTransaction(tx, command),
        TRANSACTION_OPTIONS,
      );
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        if (
          command.milestone?.templateCode &&
          (await this.prisma.milestone.findFirst({
            where: {
              familyId: command.familyId,
              templateCode: command.milestone.templateCode,
              deletedAt: null,
              ...(command.pregnancyId
                ? { pregnancyId: command.pregnancyId }
                : { childId: command.children[0]?.childId }),
            },
          }))
        )
          throw new DomainError(
            'Milestone already recorded.',
            'MILESTONE_ALREADY_RECORDED',
            409,
          );
        // The same Idempotency-Key raced: retrying replays the winner.
        throw new DomainError(
          'A concurrent memory request conflicted; retry.',
          'MEMORY_CONFLICT',
          409,
        );
      }
      throw error;
    }
  }

  async findFamilyId(memoryId: string): Promise<string | null> {
    // Trashed memories (soft-deleted) still resolve: restore/purge need them.
    const row = await this.prisma.memory.findFirst({
      where: { id: memoryId, status: { not: 'PURGED' } },
      select: { familyId: true },
    });
    return row?.familyId ?? null;
  }

  async findVisibleToParent(
    familyId: string,
    userId: string,
    memoryId: string,
  ): Promise<MemoryView | null> {
    const scope = await memoryContentScope(this.prisma, familyId, userId, true);
    const row = await this.prisma.memory.findFirst({
      where: {
        id: memoryId,
        familyId,
        deletedAt: null,
        ...(scope.isParent
          ? {
              OR: parentVisibility(userId, [
                'PUBLISHED',
                'PROCESSING',
                'DRAFT',
              ]),
            }
          : scope.where),
      },
      include: RELATIONS,
    });
    return row ? mapView(row, scope) : null;
  }

  async listFeedForParent(
    familyId: string,
    userId: string,
    filter: MemoryFeedFilter,
  ): Promise<MemoryView[]> {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    const and: Prisma.MemoryWhereInput[] = [
      scope.isParent
        ? { OR: parentVisibility(userId, ['PUBLISHED', 'PROCESSING']) }
        : scope.where,
      memoryExclusionWhere(
        await viewerExclusions(this.prisma, familyId, userId),
      ),
    ];
    if (filter.ids) and.push({ id: { in: filter.ids } });
    if (filter.kind) and.push({ kind: filter.kind });
    if (filter.childId)
      and.push({
        memoryChildren: {
          some: { childId: filter.childId, deletedAt: null },
        },
      });
    if (filter.pregnancyId) and.push({ pregnancyId: filter.pregnancyId });
    if (filter.after)
      and.push({
        OR: [
          { createdAt: { lt: filter.after.createdAt } },
          { createdAt: filter.after.createdAt, id: { lt: filter.after.id } },
        ],
      });
    const rows = await this.prisma.memory.findMany({
      where: { familyId, deletedAt: null, AND: and },
      include: RELATIONS,
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: filter.limit + 1,
    });
    return rows.map((row) => mapView(row, scope));
  }

  /**
   * MEM-15: ids whose `search_tsv` (unaccent title/body/location, kept by a
   * trigger) matches every word as a prefix; newest first, capped.
   */
  async searchMatchIds(
    familyId: string,
    words: string[],
    cap: number,
  ): Promise<string[]> {
    if (!words.length) return [];
    const query = words.map((word) => `${word}:*`).join(' & ');
    const rows = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT id FROM app.memories
      WHERE family_id = ${familyId}::uuid AND deleted_at IS NULL
        AND search_tsv @@ to_tsquery('simple', unaccent(${query}))
      ORDER BY created_at DESC, id DESC
      LIMIT ${cap}`;
    return rows.map((row) => row.id);
  }

  /** MEM-16: ids on the same local day/month in earlier years, newest first. */
  async onThisDayIds(
    familyId: string,
    day: string,
    cap: number,
  ): Promise<string[]> {
    const rows = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT id FROM app.memories
      WHERE family_id = ${familyId}::uuid AND deleted_at IS NULL
        AND extract(month FROM occurred_local_date) = extract(month FROM ${day}::date)
        AND extract(day FROM occurred_local_date) = extract(day FROM ${day}::date)
        AND occurred_local_date < date_trunc('year', ${day}::date)
      ORDER BY occurred_local_date DESC, id DESC
      LIMIT ${cap}`;
    return rows.map((row) => row.id);
  }

  /** MEM-25: ids of a child's memories on one family-local day, oldest first. */
  async childDayIds(
    familyId: string,
    childId: string,
    day: string,
    cap: number,
  ): Promise<string[]> {
    const rows = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT m.id FROM app.memories m
      JOIN app.memory_children mc ON mc.memory_id = m.id AND mc.deleted_at IS NULL
      WHERE m.family_id = ${familyId}::uuid AND m.deleted_at IS NULL
        AND mc.child_id = ${childId}::uuid
        AND m.occurred_local_date = ${day}::date
      ORDER BY m.occurred_at, m.id
      LIMIT ${cap}`;
    return rows.map((row) => row.id);
  }

  async findChildFamilyId(childId: string): Promise<string | null> {
    const row = await this.prisma.child.findFirst({
      where: { id: childId, deletedAt: null },
      select: { familyId: true },
    });
    return row?.familyId ?? null;
  }

  async familyTimezone(familyId: string): Promise<string | null> {
    const row = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
      select: { timezone: true },
    });
    return row?.timezone ?? null;
  }

  async findTimelineChild(
    familyId: string,
    childId: string,
  ): Promise<TimelineChildContext | null> {
    const row = await this.prisma.child.findFirst({
      where: { id: childId, familyId, deletedAt: null },
      include: { family: { select: { timezone: true } } },
    });
    return row
      ? new TimelineChildContext(row.id, row.birthDate, row.family.timezone)
      : null;
  }

  async listTimelineForParent(
    familyId: string,
    userId: string,
    filter: TimelineRepositoryFilter,
  ): Promise<MemoryView[]> {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    const and: Prisma.MemoryWhereInput[] = [
      scope.isParent
        ? { OR: parentVisibility(userId, ['PUBLISHED', 'PROCESSING']) }
        : scope.where,
      memoryExclusionWhere(
        await viewerExclusions(this.prisma, familyId, userId),
      ),
    ];
    if (filter.childId)
      and.push({
        memoryChildren: {
          some: { childId: filter.childId, familyId, deletedAt: null },
        },
      });
    if (filter.pregnancyId) and.push({ pregnancyId: filter.pregnancyId });
    switch (filter.filter) {
      case 'MILESTONE':
      case 'DIARY':
      case 'LETTER':
        and.push({ kind: filter.filter });
        break;
      case 'PREGNANCY':
        and.push({ pregnancyId: { not: null } });
        break;
      case 'MEDIA':
        and.push({
          memoryAsset: {
            some: {
              familyId,
              deletedAt: null,
              asset: { familyId, deletedAt: null },
            },
          },
        });
        break;
    }
    if (filter.after)
      and.push({
        OR: [
          { occurredAt: { lt: filter.after.occurredAt } },
          { occurredAt: filter.after.occurredAt, id: { lt: filter.after.id } },
        ],
      });
    const rows = await this.prisma.memory.findMany({
      where: { familyId, deletedAt: null, AND: and },
      include: RELATIONS,
      orderBy: [{ occurredAt: 'desc' }, { id: 'desc' }],
      take: filter.limit + 1,
    });
    return rows.map((row) => mapView(row, scope));
  }

  async listMediaGridForParent(
    familyId: string,
    userId: string,
    filter: MediaGridRepositoryFilter,
  ): Promise<MemoryGridAsset[]> {
    // Reuse media ACL (including sealed-letter protection), then narrow to the
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    // same non-draft/live statuses as the feed. Deduplicate BEFORE pagination:
    // an asset reused in several memories occupies exactly one grid cell.
    const rows = await this.prisma.$queryRaw<
      {
        assetId: string;
        memoryId: string;
        kind: 'IMAGE' | 'VIDEO';
        width: number | null;
        height: number | null;
        durationMs: number | null;
        blurhash: string | null;
        occurredAt: Date;
      }[]
    >(Prisma.sql`
      WITH visible AS (
        SELECT DISTINCT ON (a.id)
          a.id AS "assetId", m.id AS "memoryId", a.kind::text AS kind,
          a.width, a.height, a.duration_ms AS "durationMs", a.blurhash,
          m.occurred_at AS "occurredAt"
        FROM app.assets a
        JOIN app.memory_assets ma ON ma.asset_id = a.id
          AND ma.family_id = ${familyId}::uuid AND ma.deleted_at IS NULL
        JOIN app.memories m ON m.id = ma.memory_id
        WHERE a.family_id = ${familyId}::uuid AND m.family_id = ${familyId}::uuid
          AND a.deleted_at IS NULL AND a.status = 'READY'
          AND a.kind IN ('IMAGE', 'VIDEO') AND a.purpose = 'MEMORY'
          AND a.private_owner_user_id IS NULL
          AND m.deleted_at IS NULL AND m.status IN ('PUBLISHED', 'PROCESSING', 'PENDING_REVIEW')
          AND ${scope.sql}
          ${filter.kind ? Prisma.sql`AND a.kind::text = ${filter.kind}` : Prisma.empty}
          ${
            filter.childId
              ? Prisma.sql`AND EXISTS (
            SELECT 1 FROM app.memory_children mc WHERE mc.memory_id = m.id
              AND mc.family_id = ${familyId}::uuid AND mc.child_id = ${filter.childId}::uuid AND mc.deleted_at IS NULL
          )`
              : Prisma.empty
          }
        ORDER BY a.id, m.occurred_at DESC, m.id DESC
      )
      SELECT * FROM visible
      ${filter.after ? Prisma.sql`WHERE ("occurredAt", "assetId") < (${filter.after.occurredAt}, ${filter.after.id}::uuid)` : Prisma.empty}
      ORDER BY "occurredAt" DESC, "assetId" DESC LIMIT ${filter.limit + 1}
    `);
    return rows.map(
      (row) =>
        new MemoryGridAsset(
          row.assetId,
          row.memoryId,
          row.kind,
          row.width,
          row.height,
          row.durationMs,
          row.blurhash,
          row.occurredAt,
        ),
    );
  }

  update(command: UpdateMemoryCommand): Promise<MemoryView> {
    return this.prisma.$transaction(async (tx) => {
      let ready: boolean | undefined;
      if (command.assets) {
        await this.lockUsage(tx, command.familyId);
        if (
          command.assetQuota !== undefined &&
          command.assets.length > command.assetQuota
        )
          throw new DomainError(
            'Too many photos.',
            'QUOTA_PHOTOS_PER_MEMORY',
            402,
          );
        ready = await this.lockAssets(
          tx,
          command.familyId,
          command.actorUserId,
          command.assets.map((a) => a.assetId),
        );
      }
      const updated = await tx.memory.updateMany({
        where: {
          id: command.memoryId,
          familyId: command.familyId,
          deletedAt: null,
          version: command.expectedVersion,
        },
        data: {
          title: command.title,
          body: command.body,
          occurredAt: command.occurredAt,
          occurredLocalDate: command.occurredLocalDate,
          visibility: command.visibility,
          familyMoment: command.familyMoment,
          pregnancyId: command.pregnancyId,
          pregnancyWeek: command.pregnancyWeek,
          feeling: command.feeling,
          locationLabel: command.locationLabel,
          quoteContext: command.quoteContext,
          commentsEnabled: command.commentsEnabled,
          version: { increment: 1 },
        },
      });
      if (updated.count === 0) {
        const exists = await tx.memory.count({
          where: {
            id: command.memoryId,
            familyId: command.familyId,
            deletedAt: null,
          },
        });
        if (exists)
          throw new DomainError(
            'The memory was changed by someone else; reload it.',
            'VERSION_CONFLICT',
            412,
          );
        throw new NotFoundError('Memory was not found.');
      }
      if (command.assets) {
        const current = await tx.memory.findUniqueOrThrow({
          where: { id: command.memoryId },
        });
        if (!['DRAFT', 'PENDING_REVIEW', 'REJECTED'].includes(current.status))
          await tx.memory.update({
            where: { id: command.memoryId },
            data: {
              status: ready ? 'PUBLISHED' : 'PROCESSING',
              publishedAt: ready ? (current.publishedAt ?? new Date()) : null,
            },
          });
        await tx.memoryAsset.updateMany({
          where: {
            memoryId: command.memoryId,
            familyId: command.familyId,
            deletedAt: null,
          },
          data: { deletedAt: new Date(), isCover: false },
        });
        // Native upsert cannot target the deployed constraints for this link.
        // The memory/usage locks serialize link restoration and creation.
        for (const asset of command.assets) {
          const restored = await tx.memoryAsset.updateMany({
            where: {
              memoryId: command.memoryId,
              assetId: asset.assetId,
              familyId: command.familyId,
            },
            data: {
              sortOrder: asset.sortOrder,
              isCover: asset.isCover,
              deletedAt: null,
            },
          });
          if (!restored.count)
            await tx.memoryAsset.create({
              data: {
                ...asset,
                memoryId: command.memoryId,
                familyId: command.familyId,
              },
            });
        }
        await tx.outboxEvent.create({
          data: {
            eventType: 'memory.changed',
            aggregateId: command.memoryId,
            familyId: command.familyId,
            payload: {
              memoryId: command.memoryId,
              familyId: command.familyId,
              fields: command.changedFields,
            },
          },
        });
      }
      const now = new Date();
      const keep = command.children.map((child) => child.childId);
      await tx.memoryChild.updateMany({
        where: {
          memoryId: command.memoryId,
          deletedAt: null,
          childId: { notIn: keep },
        },
        data: { deletedAt: now },
      });
      for (const child of command.children)
        // Primary key (memory_id, child_id): a removed child is restored in place.
        await tx.memoryChild.upsert({
          where: {
            memoryId_childId: {
              memoryId: command.memoryId,
              childId: child.childId,
            },
          },
          create: {
            memoryId: command.memoryId,
            childId: child.childId,
            familyId: command.familyId,
            addedBy: command.actorUserId,
            ageMonth: child.ageMonth,
          },
          update: { ageMonth: child.ageMonth, deletedAt: null },
        });
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.updated',
          aggregateId: command.memoryId,
          familyId: command.familyId,
          payload: {
            memoryId: command.memoryId,
            familyId: command.familyId,
            updatedBy: command.actorUserId,
            fields: command.changedFields,
            visibility: command.visibility,
          },
        },
      });
      const row = await tx.memory.findUniqueOrThrow({
        where: { id: command.memoryId },
        include: RELATIONS,
      });
      return mapView(row);
    }, TRANSACTION_OPTIONS);
  }

  trash(command: TrashMemoryCommand): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      // Same lock order as creation and the media worker: usage, then memory.
      await this.lockUsage(tx, command.familyId);
      const [before] = await tx.$queryRaw<
        { status: string; visibility: string }[]
      >`
        SELECT status::text AS status, visibility::text AS visibility FROM app.memories
        WHERE id = ${command.memoryId}::uuid AND family_id = ${command.familyId}::uuid
        AND deleted_at IS NULL FOR UPDATE`;
      const [moved] = await tx.$queryRaw<
        { id: string; author_user_id: string; kind: string }[]
      >`
        UPDATE app.memories
        SET visibility = CASE WHEN status = 'DRAFT' THEN 'PRIVATE'::app.visibility ELSE visibility END,
            status = 'TRASHED', trashed_at = now(), deleted_at = now(),
            trashed_by = ${command.actorUserId}::uuid,
            purge_after = ${command.purgeAfter}, version = version + 1
        WHERE id = ${command.memoryId}::uuid
          AND family_id = ${command.familyId}::uuid
          AND deleted_at IS NULL
          AND status IN ('DRAFT', 'PROCESSING', 'PENDING_REVIEW', 'PUBLISHED')
        RETURNING id, author_user_id, kind::text AS kind`;
      if (!moved) return false;
      await tx.$executeRaw`
        UPDATE billing.family_usage
        SET memory_count = GREATEST(memory_count - 1, 0), version = version + 1
        WHERE family_id = ${command.familyId}::uuid`;
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.trashed',
          aggregateId: command.memoryId,
          familyId: command.familyId,
          payload: {
            memoryId: command.memoryId,
            familyId: command.familyId,
            trashedBy: command.actorUserId,
            previousStatus: before?.status ?? null,
            previousVisibility: before?.visibility ?? null,
            purgeAfter: command.purgeAfter.toISOString(),
          },
        },
      });
      return true;
    }, TRANSACTION_OPTIONS);
  }

  async findTrashedVisibleToParent(
    familyId: string,
    userId: string,
    memoryId: string,
  ): Promise<MemoryView | null> {
    const row = await this.prisma.memory.findFirst({
      where: {
        id: memoryId,
        familyId,
        ...trashVisibility(userId),
      },
      include: RELATIONS,
    });
    return row ? mapView(row) : null;
  }

  async listTrashForParent(
    familyId: string,
    userId: string,
    filter: { after: MemoryTrashCursor | null; limit: number },
  ): Promise<MemoryView[]> {
    const after = filter.after;
    const rows = await this.prisma.memory.findMany({
      where: {
        familyId,
        ...trashVisibility(userId),
        ...(after
          ? {
              AND: [
                {
                  OR: [
                    { trashedAt: { lt: after.trashedAt } },
                    { trashedAt: after.trashedAt, id: { lt: after.id } },
                  ],
                },
              ],
            }
          : {}),
      },
      include: RELATIONS,
      orderBy: [{ trashedAt: 'desc' }, { id: 'desc' }],
      take: filter.limit + 1,
    });
    return rows.map((row) => mapView(row));
  }

  async restore(command: RestoreMemoryCommand): Promise<MemoryView> {
    return this.prisma.$transaction(async (tx) => {
      await this.consumeMemoryQuota(tx, command.familyId, command.memoryQuota);
      const lastTrash = await tx.outboxEvent.findFirst({
        where: {
          familyId: command.familyId,
          aggregateId: command.memoryId,
          eventType: 'memory.trashed',
          deletedAt: null,
        },
        orderBy: { id: 'desc' },
      });
      const payload = lastTrash?.payload;
      const prior =
        payload && typeof payload === 'object' && !Array.isArray(payload)
          ? payload
          : null;
      const draft = prior?.previousStatus === 'DRAFT';
      const pending = prior?.previousStatus === 'PENDING_REVIEW';
      const rejected = prior?.previousStatus === 'REJECTED';
      const previousVisibility = prior?.previousVisibility;
      const restoredVisibility =
        draft &&
        typeof previousVisibility === 'string' &&
        ['PRIVATE', 'PARENTS', 'FAMILY'].includes(previousVisibility)
          ? previousVisibility
          : null;
      const [restored] = await tx.$queryRaw<{ id: string; status: string }[]>`
        UPDATE app.memories m
        SET status = CASE WHEN ${draft} THEN 'DRAFT'::app.memory_status WHEN ${pending} THEN 'PENDING_REVIEW'::app.memory_status WHEN ${rejected} THEN 'REJECTED'::app.memory_status WHEN NOT EXISTS (
              SELECT 1 FROM app.memory_assets ma
              JOIN app.assets a ON a.id = ma.asset_id
              WHERE ma.memory_id = m.id AND ma.deleted_at IS NULL
                AND a.deleted_at IS NULL AND a.status <> 'READY')
            THEN 'PUBLISHED'::app.memory_status
            ELSE 'PROCESSING'::app.memory_status END,
          visibility = COALESCE(${restoredVisibility}::app.visibility, m.visibility),
          published_at = CASE WHEN ${draft || pending || rejected} THEN NULL ELSE COALESCE(m.published_at, now()) END,
          trashed_at = NULL, trashed_by = NULL, purge_after = NULL,
          deleted_at = NULL, version = m.version + 1
        WHERE m.id = ${command.memoryId}::uuid
          AND m.family_id = ${command.familyId}::uuid
          AND m.status = 'TRASHED'
          AND m.purge_after > now()
        RETURNING m.id, m.status::text AS status`;
      // Nothing restored: the transaction rolls back the quota consumption.
      if (!restored) throw new NotFoundError('Memory was not found.');
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.restored',
          aggregateId: command.memoryId,
          familyId: command.familyId,
          payload: {
            memoryId: command.memoryId,
            familyId: command.familyId,
            restoredBy: command.actorUserId,
            status: restored.status,
          },
        },
      });
      const row = await tx.memory.findUniqueOrThrow({
        where: { id: command.memoryId },
        include: RELATIONS,
      });
      return mapView(row);
    }, TRANSACTION_OPTIONS);
  }

  purge(
    familyId: string,
    memoryId: string,
    actorUserId: string | null,
  ): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const now = new Date();
      const purged = await tx.memory.updateMany({
        where: { id: memoryId, familyId, status: 'TRASHED' },
        data: {
          status: 'PURGED',
          purgeAfter: null,
          version: { increment: 1 },
        },
      });
      if (purged.count === 0) return false;
      await tx.memoryChild.updateMany({
        where: { memoryId, deletedAt: null },
        data: { deletedAt: now },
      });
      await tx.memoryAsset.updateMany({
        where: { memoryId, deletedAt: null },
        data: { deletedAt: now },
      });
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.purged',
          aggregateId: memoryId,
          familyId,
          payload: { memoryId, familyId, purgedBy: actorUserId },
        },
      });
      return true;
    }, TRANSACTION_OPTIONS);
  }

  async findExpiredTrash(
    now: Date,
    limit: number,
    familyId?: string,
  ): Promise<{ id: string; familyId: string }[]> {
    return this.prisma.memory.findMany({
      where: {
        status: 'TRASHED',
        purgeAfter: { lte: now },
        ...(familyId ? { familyId } : {}),
      },
      select: { id: true, familyId: true },
      orderBy: { purgeAfter: 'asc' },
      take: limit,
    });
  }

  private async createInTransaction(
    tx: Transaction,
    command: CreateMemoryCommand,
  ): Promise<MemoryView> {
    if (command.milestone?.templateCode) {
      const template = await tx.milestoneTemplate.findFirst({
        where: {
          code: command.milestone.templateCode,
          status: 'ACTIVE',
          deletedAt: null,
        },
      });
      if (!template)
        throw new DomainError(
          'Unknown milestone template.',
          'MILESTONE_TEMPLATE_INVALID',
          422,
        );
    }
    if (command.authorRole === 'CIRCLE') {
      const scope = await memoryContentScope(
        tx,
        command.familyId,
        command.authorUserId,
      );
      if (
        command.children.some(
          (c) => !scope.contributeChildIds.includes(c.childId),
        ) ||
        (command.pregnancyId &&
          !scope.contributePregnancyIds.includes(command.pregnancyId)) ||
        (!command.children.length && !command.pregnancyId)
      )
        throw new DomainError(
          'Contribution grant is required.',
          'CIRCLE_CONTRIBUTE_REQUIRED',
          403,
        );
    }
    const family =
      command.authorRole === 'CIRCLE'
        ? await tx.family.findFirst({
            where: { id: command.familyId, deletedAt: null, status: 'ACTIVE' },
            select: { settings: true },
          })
        : null;
    if (command.authorRole === 'CIRCLE' && !family)
      throw new DomainError('Family sharing is paused.', 'CIRCLE_PAUSED', 403);
    const settings = family?.settings;
    const status =
      command.authorRole === 'CIRCLE' &&
      !(
        settings &&
        typeof settings === 'object' &&
        !Array.isArray(settings) &&
        settings.requireCircleReview === false
      )
        ? 'PENDING_REVIEW'
        : command.status;
    const assetIds = command.assets.map((asset) => asset.assetId);
    // Same lock order as the media workflow: family usage first, then assets.
    await this.consumeMemoryQuota(tx, command.familyId, command.memoryQuota);
    // Row locks serialize with the worker's READY commit. An asset may belong to
    // several memories (SHA-256 dedup returns the stored asset): the uploader can
    // attach it, another Parent only once it is READY and already visible to them.
    const ready = await this.lockAssets(
      tx,
      command.familyId,
      command.authorUserId,
      assetIds,
    );
    const now = new Date();
    const memory = await tx.memory.create({
      data: {
        familyId: command.familyId,
        authorUserId: command.authorUserId,
        authorRole: command.authorRole ?? 'PARENT',
        kind: command.kind,
        title: command.title,
        body: command.body,
        occurredAt: command.occurredAt,
        occurredLocalDate: command.occurredLocalDate,
        visibility: command.visibility,
        status:
          status === 'PENDING_REVIEW'
            ? 'PENDING_REVIEW'
            : status === 'DRAFT'
              ? 'DRAFT'
              : ready
                ? 'PUBLISHED'
                : 'PROCESSING',
        publishedAt: !status && ready ? now : null,
        unlockAt: command.unlockAt ?? null,
        familyMoment: command.familyMoment,
        pregnancyId: command.pregnancyId,
        pregnancyWeek: command.pregnancyWeek,
        feeling: command.feeling,
        locationLabel: command.locationLabel,
        quoteContext: command.quoteContext,
        commentsEnabled: command.commentsEnabled,
      },
    });
    if (command.children.length)
      await tx.memoryChild.createMany({
        data: command.children.map((child) => ({
          memoryId: memory.id,
          childId: child.childId,
          familyId: command.familyId,
          addedBy: command.authorUserId,
          ageMonth: child.ageMonth,
        })),
      });
    if (command.assets.length)
      await tx.memoryAsset.createMany({
        data: command.assets.map((asset) => ({
          memoryId: memory.id,
          assetId: asset.assetId,
          familyId: command.familyId,
          sortOrder: asset.sortOrder,
          isCover: asset.isCover,
        })),
      });
    if (command.milestone)
      await tx.milestone.create({
        data: {
          familyId: command.familyId,
          memoryId: memory.id,
          childId: command.children[0]?.childId ?? null,
          pregnancyId: command.pregnancyId,
          templateCode: command.milestone.templateCode ?? null,
          customTitle: command.milestone.customTitle?.trim() ?? null,
          occurredOn: new Date(command.milestone.occurredOn),
          createdBy: command.authorUserId,
        },
      });
    if (command.letter)
      await tx.memoryLetter.create({
        data: {
          memoryId: memory.id,
          familyId: command.familyId,
          childId: command.letter.childId,
          releaseRule: command.letter.releaseRule,
          birthdayNumber: command.letter.birthdayNumber ?? null,
          releaseVisibility: command.letter.releaseVisibility,
        },
      });
    const payload = {
      memoryId: memory.id,
      familyId: command.familyId,
      authorUserId: command.authorUserId,
      kind: command.kind,
      status: memory.status,
      visibility: command.visibility,
    };
    // Transactional outbox (spec §3.3): notifications/feeds consume these.
    await tx.outboxEvent.create({
      data: {
        eventType: 'memory.created',
        aggregateId: memory.id,
        familyId: command.familyId,
        payload,
      },
    });
    if (status === 'PENDING_REVIEW')
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.review_requested',
          aggregateId: memory.id,
          familyId: command.familyId,
          payload,
        },
      });
    if (ready && !status)
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.published',
          aggregateId: memory.id,
          familyId: command.familyId,
          payload,
        },
      });
    await tx.idempotencyRecord.create({
      data: {
        actorUserId: command.authorUserId,
        familyId: command.familyId,
        operation: CREATE_OPERATION,
        scopeKey: command.authorUserId,
        idempotencyKey: command.idempotencyKey,
        requestHash: Buffer.from(command.requestHash),
        status: 'SUCCEEDED',
        resultEntityType: 'memory',
        resultEntityId: memory.id,
        responseCode: 201,
        expiresAt: command.idempotencyExpiresAt,
      },
    });
    const row = await tx.memory.findUniqueOrThrow({
      where: { id: memory.id },
      include: RELATIONS,
    });
    return mapView(row);
  }

  private async lockAssets(
    tx: Transaction,
    familyId: string,
    userId: string,
    assetIds: string[],
  ): Promise<boolean> {
    const locked = assetIds.length
      ? await tx.$queryRaw<{ id: string; status: string }[]>`
          SELECT a.id, a.status::text AS status FROM app.assets a
          WHERE a.id = ANY(${assetIds}::uuid[])
            AND a.family_id = ${familyId}::uuid
            AND a.purpose = 'MEMORY'
            AND a.private_owner_user_id IS NULL
            AND a.deleted_at IS NULL
            AND (a.uploader_user_id = ${userId}::uuid
                 OR (a.status = 'READY'
                     AND ${parentSharedAssetSql(userId)}))
          FOR UPDATE OF a`
      : [];
    const statusById = new Map(locked.map((row) => [row.id, row.status]));
    if (
      assetIds.some((id) => !STORED_STATUSES.includes(statusById.get(id) ?? ''))
    )
      throw new DomainError(
        'Some media is not uploaded or not yours.',
        'MEMORY_ASSET_INVALID',
        422,
      );
    return assetIds.every((id) => statusById.get(id) === 'READY');
  }

  /**
   * Spec §11.5 (5): `family_usage.memory_count` counts created memories and is
   * always maintained; it is checked only when the plan defines `memoryCount`.
   */
  private async consumeMemoryQuota(
    tx: Transaction,
    familyId: string,
    quota: number | null,
  ): Promise<void> {
    const memoryCount = await this.lockUsage(tx, familyId);
    if (quota !== null && memoryCount + 1 > quota)
      throw new DomainError(
        'Memory quota of the current plan is exceeded.',
        'QUOTA_MEMORY_COUNT_EXCEEDED',
        402,
      );
    await tx.$executeRaw`
      UPDATE billing.family_usage
      SET memory_count = memory_count + 1, version = version + 1
      WHERE family_id = ${familyId}::uuid`;
  }

  /** Locks the family usage row (created on first use); returns `memory_count`. */
  private async lockUsage(tx: Transaction, familyId: string): Promise<number> {
    await tx.$executeRaw`
      INSERT INTO billing.family_usage (family_id) VALUES (${familyId}::uuid)
      ON CONFLICT (family_id) DO NOTHING`;
    const [usage] = await tx.$queryRaw<{ memory_count: number }[]>`
      SELECT memory_count FROM billing.family_usage
      WHERE family_id = ${familyId}::uuid FOR UPDATE`;
    return usage?.memory_count ?? 0;
  }
}

/**
 * Trash of a Parent (spec MEM-17): trashed, not expired, and readable under the
 * §6.3 rules — own memories, or shared ones (PARENTS/FAMILY), never the
 * partner's PRIVATE memories.
 */
function trashVisibility(userId: string): Prisma.MemoryWhereInput {
  return {
    status: 'TRASHED',
    purgeAfter: { gt: new Date() },
    OR: [
      { authorUserId: userId },
      { visibility: { in: ['PARENTS', 'FAMILY'] } },
    ],
  };
}

/** Spec §6.3 Parent filter; `ownStatuses` narrows the author's own memories. */
function parentVisibility(
  userId: string,
  ownStatuses: ('PUBLISHED' | 'PROCESSING' | 'DRAFT')[],
): Prisma.MemoryWhereInput[] {
  return [
    { status: 'PUBLISHED', visibility: { in: ['PARENTS', 'FAMILY'] } },
    { status: 'PUBLISHED', kind: 'LETTER', unlockAt: { not: null } },
    { status: 'PENDING_REVIEW' },
    {
      status: 'PROCESSING',
      authorRole: 'CIRCLE',
      reviewedAt: { not: null },
      visibility: 'FAMILY',
    },
    { authorUserId: userId, status: { in: ownStatuses } },
  ];
}

function mapView(
  row: MemoryWithRelations,
  scope?: { isParent: boolean; pregnancyIds: string[] },
): MemoryView {
  return new MemoryView(
    new Memory(
      scope &&
        !scope.isParent &&
        row.pregnancyId &&
        !scope.pregnancyIds.includes(row.pregnancyId)
        ? { ...row, pregnancyId: null, pregnancyWeek: null }
        : row,
    ),
    row.memoryChildren.map((child) => child.childId),
    row.memoryAsset
      .filter((link) => link.asset.deletedAt === null)
      .map((link) => ({
        assetId: link.assetId,
        kind: link.asset.kind,
        status: link.asset.status,
        sortOrder: link.sortOrder,
        isCover: link.isCover,
        width: link.asset.width,
        height: link.asset.height,
        durationMs: link.asset.durationMs,
        blurhash: link.asset.blurhash,
      })),
    row.reactionsReactionsMemoryIdTomemories,
  );
}
