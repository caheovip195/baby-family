import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import { Memory } from '../models/memory.model';
import { AssetVariant } from '../models/asset-variant.model';
import { Asset } from '../models/asset.model';
import { Family } from '../models/family.model';
import { FamilyEntitlement } from '../models/family-entitlement.model';
import type {
  IMemoryLibraryRepository,
  LibraryCursor,
  LibraryFamilyAccess,
  LibraryMemory,
} from '../interfaces/repositories/memory-library-repository.interface';

@Injectable()
export class MemoryLibraryRepository implements IMemoryLibraryRepository {
  constructor(private readonly prisma: PrismaService) {}
  async familyAccess(
    familyId: string,
    userId: string,
  ): Promise<LibraryFamilyAccess | null> {
    const family = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null, status: { not: 'DELETED' } },
      include: { familyLicense: true },
    });
    if (!family) return null;
    const parent = await this.prisma.familyParent.findFirst({
      where: {
        familyId,
        userId,
        status: 'ACTIVE',
        deletedAt: null,
        leftAt: null,
        joinedAt: { lte: new Date() },
      },
    });
    const circle = await this.prisma.circleMember.findFirst({
      where: { familyId, userId, deletedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    if (!parent && !circle) return null;
    const entitlement = await this.prisma.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { planVersion: true },
    });
    const license = family.familyLicense;
    return {
      circleEnabled:
        !!entitlement?.planVersion &&
        !entitlement.planVersion.deletedAt &&
        typeof entitlement.planVersion.features === 'object' &&
        entitlement.planVersion.features !== null &&
        !Array.isArray(entitlement.planVersion.features) &&
        entitlement.planVersion.features['circle.enabled'] === true,
      isParent: !!parent,
      circleActive:
        circle?.status === 'ACTIVE' &&
        circle.endedAt === null &&
        circle.joinedAt <= new Date(),
      family: new Family({
        ...family,
        settings: cloneDatabaseJson(family.settings),
      }),
      entitlement: entitlement ? new FamilyEntitlement(entitlement) : null,
      licenseBlocked:
        !license ||
        !!license.deletedAt ||
        !!license.blockedAt ||
        !!license.blockReasonCode,
    };
  }
  private async visibility(
    familyId: string,
    userId: string,
    includeOwnPending = false,
  ): Promise<{
    where: Prisma.MemoryWhereInput;
    childIds: string[];
    downloadChildIds: string[];
    pregnancyIds: string[];
    downloadPregnancyIds: string[];
    isParent: boolean;
  }> {
    const access = await this.familyAccess(familyId, userId);
    if (access?.isParent)
      return {
        isParent: true,
        childIds: [],
        downloadChildIds: [],
        pregnancyIds: [],
        downloadPregnancyIds: [],
        where: {
          familyId,
          deletedAt: null,
          OR: [
            { status: 'PUBLISHED', visibility: { in: ['FAMILY', 'PARENTS'] } },
            { status: 'PENDING_REVIEW' },
            {
              authorUserId: userId,
              status: { in: ['PUBLISHED', 'PROCESSING', 'DRAFT'] },
            },
          ],
        },
      };
    const grants = access?.circleActive
      ? await this.prisma.circleGrant.findMany({
          where: {
            familyId,
            status: 'ACTIVE',
            deletedAt: null,
            circleMember: {
              userId,
              status: 'ACTIVE',
              deletedAt: null,
              endedAt: null,
              joinedAt: { lte: new Date() },
            },
            OR: [
              { child: { deletedAt: null, status: 'ACTIVE' } },
              {
                pregnancy: {
                  deletedAt: null,
                  status: { in: ['ACTIVE', 'COMPLETED'] },
                },
              },
            ],
          },
        })
      : [];
    const childIds = grants.flatMap((g) => (g.childId ? [g.childId] : []));
    const pregnancyIds = grants.flatMap((g) =>
      g.pregnancyId ? [g.pregnancyId] : [],
    );
    return {
      isParent: false,
      childIds,
      pregnancyIds,
      downloadChildIds: grants.flatMap((g) =>
        g.childId && g.allowDownload ? [g.childId] : [],
      ),
      downloadPregnancyIds: grants.flatMap((g) =>
        g.pregnancyId && g.allowDownload ? [g.pregnancyId] : [],
      ),
      where: {
        familyId,
        deletedAt: null,
        OR: [
          { status: 'PUBLISHED' },
          ...(includeOwnPending
            ? [
                {
                  authorUserId: userId,
                  status: {
                    in: ['PENDING_REVIEW', 'PROCESSING', 'REJECTED'] as (
                      'PENDING_REVIEW' | 'PROCESSING' | 'REJECTED'
                    )[],
                  },
                },
              ]
            : []),
        ],
        visibility: 'FAMILY',
        NOT: { kind: 'LETTER', unlockAt: { not: null } },
        AND: [
          {
            memoryChildren: {
              none: { deletedAt: null, childId: { notIn: childIds } },
            },
          },
          {
            OR: [
              { pregnancyId: null },
              {
                pregnancy: {
                  deletedAt: null,
                  status: { in: ['ACTIVE', 'COMPLETED'] },
                },
              },
            ],
          },
          {
            OR: [
              {
                memoryChildren: {
                  some: { childId: { in: childIds }, deletedAt: null },
                },
              },
              { pregnancyId: { in: pregnancyIds } },
              ...(childIds.length + pregnancyIds.length > 0
                ? [{ familyMoment: true }]
                : []),
            ],
          },
        ],
      },
    };
  }
  async findFamilyId(id: string): Promise<string | null> {
    const row = await this.prisma.memory.findFirst({
      where: { id, deletedAt: null },
      select: { familyId: true },
    });
    return row?.familyId ?? null;
  }
  async find(
    id: string,
    userId: string,
    includeOwnPending = false,
  ): Promise<LibraryMemory | null> {
    const ref = await this.prisma.memory.findUnique({
      where: { id },
      select: { familyId: true },
    });
    if (!ref) return null;
    const scope = await this.visibility(
      ref.familyId,
      userId,
      includeOwnPending,
    );
    const row = await this.prisma.memory.findFirst({
      where: { id, ...scope.where },
      include: {
        memoryChildren: { where: { deletedAt: null } },
        memoryAsset: {
          where: {
            deletedAt: null,
            asset: {
              deletedAt: null,
              purpose: 'MEMORY',
              privateOwnerUserId: null,
            },
          },
          include: {
            asset: {
              include: { assetVariants: { where: { deletedAt: null } } },
            },
          },
          orderBy: { sortOrder: 'asc' },
        },
        memoryPerspectives: {
          where: {
            deletedAt: null,
            status: 'ACTIVE',
            ...(scope.isParent ? {} : { hiddenFromCircle: false }),
          },
          select: { id: true },
        },
      },
    });
    if (!row) return null;
    const sealed =
      row.kind === 'LETTER' &&
      !!row.unlockAt &&
      row.unlockAt > new Date() &&
      row.authorUserId !== userId;
    return {
      memory: new Memory({
        ...row,
        pregnancyId:
          scope.isParent || scope.pregnancyIds.includes(row.pregnancyId ?? '')
            ? row.pregnancyId
            : null,
        pregnancyWeek:
          scope.isParent || scope.pregnancyIds.includes(row.pregnancyId ?? '')
            ? row.pregnancyWeek
            : null,
      }),
      variants: sealed
        ? []
        : row.memoryAsset.flatMap((a) =>
            a.asset.assetVariants.map((v) => new AssetVariant(v)),
          ),
      assets: sealed ? [] : row.memoryAsset.map((a) => new Asset(a.asset)),
      childIds: row.memoryChildren
        .filter((c) => scope.isParent || scope.childIds.includes(c.childId))
        .map((c) => c.childId),
      coverAssetId: sealed
        ? null
        : (row.memoryAsset.find((a) => a.isCover)?.assetId ?? null),
      canDownload:
        !sealed &&
        (scope.isParent ||
          row.memoryChildren.some((c) =>
            scope.downloadChildIds.includes(c.childId),
          ) ||
          (!!row.pregnancyId &&
            scope.downloadPregnancyIds.includes(row.pregnancyId))),
      perspectiveCount: row.memoryPerspectives.length,
    };
  }
  async setFavorite(
    userId: string,
    memoryId: string,
    familyId: string,
    enabled: boolean,
  ): Promise<void> {
    if (enabled)
      await this.prisma.favorite.upsert({
        where: { userId_memoryId: { userId, memoryId } },
        create: { userId, memoryId, familyId },
        update: { deletedAt: null },
      });
    else
      await this.prisma.favorite.updateMany({
        where: { userId, memoryId, familyId, deletedAt: null },
        data: { deletedAt: new Date() },
      });
  }
  async favorites(
    userId: string,
    familyId: string,
    cursor: LibraryCursor | null,
    limit: number,
  ): Promise<LibraryCursor[]> {
    const scope = await this.visibility(familyId, userId);
    const rows = await this.prisma.favorite.findMany({
      where: {
        userId,
        familyId,
        deletedAt: null,
        memoriesFavoritesMemoryIdFamilyIdTomemories: scope.where,
        ...(cursor
          ? {
              OR: [
                { createdAt: { lt: cursor.createdAt } },
                { createdAt: cursor.createdAt, memoryId: { lt: cursor.id } },
              ],
            }
          : {}),
      },
      orderBy: [{ createdAt: 'desc' }, { memoryId: 'desc' }],
      take: limit + 1,
    });
    return rows.map((r) => ({ createdAt: r.createdAt, id: r.memoryId }));
  }
  async auditDownload(
    userId: string,
    familyId: string,
    memoryId: string,
  ): Promise<void> {
    await this.prisma.outboxEvent.create({
      data: {
        familyId,
        aggregateId: memoryId,
        eventType: 'memory.original.downloaded',
        payload: { actorUserId: userId, memoryId },
      },
    });
  }
}
