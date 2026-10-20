import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type { Child as ChildRow } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { Child } from '../models/child.model';
import { cloneDatabaseJson } from '../common/database.types';
import { DomainError } from '../common/errors/domain.error';
import { Asset } from '../models/asset.model';
import { Pregnancy } from '../models/pregnancy.model';
import { memoryContentScope } from './memory-content-visibility';
import type {
  IChildProfileRepository,
  ChildProfileViewer,
} from '../interfaces/repositories/child-profile-repository.interface';
const mapChild = (row: ChildRow): Child =>
  new Child({
    ...row,
    profile: cloneDatabaseJson(row.profile),
    birthStats: cloneDatabaseJson(row.birthStats),
  });
@Injectable()
export class ChildProfileRepository implements IChildProfileRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findChild(id: string) {
    const row = await this.prisma.child.findFirst({
      where: { id, deletedAt: null, status: { not: 'DELETED' } },
    });
    return row ? mapChild(row) : null;
  }
  async findPregnancy(id: string) {
    const row = await this.prisma.pregnancy.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Pregnancy(row) : null;
  }
  async findAsset(id: string) {
    const row = await this.prisma.asset.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Asset(row) : null;
  }
  async listActiveChildren(familyId: string) {
    return (
      await this.prisma.child.findMany({
        where: { familyId, status: 'ACTIVE', deletedAt: null },
      })
    ).map(mapChild);
  }
  async viewer(id: string, userId: string): Promise<ChildProfileViewer | null> {
    const child = await this.findChild(id);
    if (!child) return null;
    const [parent, circle, family, entitlement, license] = await Promise.all([
      this.prisma.familyParent.findFirst({
        where: {
          familyId: child.familyId,
          userId,
          status: 'ACTIVE',
          deletedAt: null,
        },
      }),
      this.prisma.circleMember.findFirst({
        where: { familyId: child.familyId, userId },
        include: {
          circleGrants: {
            where: { childId: id, status: 'ACTIVE', deletedAt: null },
          },
        },
      }),
      this.prisma.family.findFirst({
        where: { id: child.familyId, deletedAt: null },
      }),
      this.prisma.familyEntitlement.findFirst({
        where: { familyId: child.familyId, deletedAt: null },
        include: { planVersion: true },
      }),
      this.prisma.familyLicense.findFirst({
        where: { familyId: child.familyId, deletedAt: null },
      }),
    ]);
    const features = entitlement?.planVersion?.features;
    const enabled =
      !!features &&
      typeof features === 'object' &&
      !Array.isArray(features) &&
      features['circle.enabled'] === true;
    return {
      child,
      parent: !!parent,
      circle: circle
        ? {
            active: circle.status === 'ACTIVE' && !circle.deletedAt,
            granted: circle.circleGrants.length > 0,
            enabled: enabled && !entitlement?.planVersion?.deletedAt,
            familyActive: family?.status === 'ACTIVE',
            licensed:
              !!license &&
              !license.blockedAt &&
              !license.blockReasonCode &&
              entitlement?.licenseId === license.id &&
              entitlement.accessPhase === 'PAID' &&
              !!entitlement.validUntil &&
              entitlement.validUntil > new Date(),
          }
        : null,
    };
  }
  async reorder(familyId: string, childIds: string[], snapshots: Child[]) {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${familyId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      const children = await tx.child.findMany({
        where: { familyId, status: 'ACTIVE', deletedAt: null },
      });
      if (
        children.length !== snapshots.length ||
        children.some(
          (child) =>
            !snapshots.some(
              (snapshot) =>
                snapshot.id === child.id && snapshot.version === child.version,
            ),
        )
      )
        throw new DomainError(
          'Children changed concurrently; retry.',
          'CHILD_STATUS_CONFLICT',
          409,
        );
      const result: Child[] = [];
      for (const [sortOrder, id] of childIds.entries())
        result.push(
          mapChild(
            await tx.child.update({
              where: { id },
              data: { sortOrder, version: { increment: 1 } },
            }),
          ),
        );
      await tx.outboxEvent.create({
        data: {
          familyId,
          eventType: 'child.order_changed',
          payload: { familyId, childIds },
        },
      });
      return result;
    });
  }
  async transition(
    current: Child,
    action: 'archive' | 'restore' | 'delete',
    actorUserId: string,
    now: Date,
    purgeAfter: Date,
  ) {
    const { id, familyId } = current;
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${familyId}::uuid FOR UPDATE`;
      // Existing memory writers lock usage before memory rows; use that order.
      if (action === 'delete') {
        await tx.$executeRaw`INSERT INTO billing.family_usage (family_id) VALUES (${familyId}::uuid) ON CONFLICT (family_id) DO NOTHING`;
        await tx.$queryRaw`SELECT family_id FROM billing.family_usage WHERE family_id = ${familyId}::uuid FOR UPDATE`;
      }
      await tx.$queryRaw`SELECT id FROM app.children WHERE id = ${id}::uuid AND family_id = ${familyId}::uuid FOR UPDATE`;
      const child = await tx.child.findFirst({
        where: {
          id,
          familyId,
          deletedAt: null,
          status: current.status,
          version: current.version,
        },
      });
      if (!child)
        throw new DomainError(
          'Child changed concurrently; retry.',
          'CHILD_STATUS_CONFLICT',
          409,
        );
      const row = await tx.child.update({
        where: { id },
        data: {
          status:
            action === 'delete'
              ? 'DELETED'
              : action === 'archive'
                ? 'ARCHIVED'
                : 'ACTIVE',
          archivedAt: action === 'restore' ? null : (child.archivedAt ?? now),
          ...(action === 'delete'
            ? { deletedAt: now, deletionRequestedAt: now, purgeAfter }
            : {}),
          version: { increment: 1 },
        },
      });
      // Restoring never silently reinstates Circle access.
      if (action !== 'restore')
        await tx.circleGrant.updateMany({
          where: { familyId, childId: id, status: 'ACTIVE', deletedAt: null },
          data: { status: action === 'delete' ? 'REVOKED' : 'PAUSED' },
        });
      if (action === 'delete') {
        const exclusive = await tx.memory.findMany({
          where: {
            familyId,
            deletedAt: null,
            status: {
              in: ['DRAFT', 'PROCESSING', 'PENDING_REVIEW', 'PUBLISHED'],
            },
            pregnancyId: null,
            familyMoment: false,
            memoryChildren: {
              some: { childId: id, deletedAt: null },
              none: { childId: { not: id }, deletedAt: null },
            },
          },
          select: { id: true },
        });
        let moved = 0;
        for (const memory of exclusive) {
          const changed = await tx.memory.updateMany({
            where: {
              id: memory.id,
              familyId,
              deletedAt: null,
              status: {
                in: ['DRAFT', 'PROCESSING', 'PENDING_REVIEW', 'PUBLISHED'],
              },
            },
            data: {
              status: 'TRASHED',
              trashedAt: now,
              trashedBy: actorUserId,
              deletedAt: now,
              purgeAfter,
              version: { increment: 1 },
            },
          });
          if (changed.count) {
            moved += changed.count;
            await tx.outboxEvent.create({
              data: {
                familyId,
                aggregateId: memory.id,
                eventType: 'memory.trashed',
                payload: {
                  memoryId: memory.id,
                  familyId,
                  trashedBy: actorUserId,
                  purgeAfter: purgeAfter.toISOString(),
                },
              },
            });
          }
        }
        if (moved)
          await tx.$executeRaw`UPDATE billing.family_usage SET memory_count = GREATEST(memory_count - ${moved}, 0), version = version + 1 WHERE family_id = ${familyId}::uuid`;
        // Perspectives remain intact and inherit their parent memory's visibility.
        await tx.monthlyPhoto.updateMany({
          where: { familyId, childId: id, deletedAt: null },
          data: { deletedAt: now },
        });
        await tx.memoryPin.updateMany({
          where: { familyId, childId: id, deletedAt: null },
          data: { deletedAt: now },
        });
      }
      await tx.family.update({
        where: { id: familyId },
        data: { accessVersion: { increment: 1 } },
      });
      await tx.outboxEvent.create({
        data: {
          familyId,
          eventType: 'child.status_changed',
          payload: { childId: id, status: row.status },
        },
      });
      return mapChild(row);
    });
  }
  async setAsset(
    subject: 'child' | 'pregnancy',
    current: Child | Pregnancy,
    field: 'avatarAssetId' | 'coverAssetId',
    asset: Asset | null,
  ) {
    const { id, familyId } = current;
    const assetId = asset?.id ?? null;
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${familyId}::uuid FOR UPDATE`;
      if (asset) {
        await tx.$queryRaw`SELECT id FROM app.assets WHERE id = ${asset.id}::uuid FOR UPDATE`;
        const unchanged = await tx.asset.findFirst({
          where: {
            id: asset.id,
            familyId: asset.familyId,
            deletedAt: null,
            privateOwnerUserId: asset.privateOwnerUserId,
            status: asset.status,
            purpose: asset.purpose,
            kind: asset.kind,
            updatedAt: asset.updatedAt,
          },
        });
        if (!unchanged)
          throw new DomainError(
            'Asset changed concurrently; retry.',
            'ASSET_STATE_CONFLICT',
            409,
          );
      }
      let result:
        Child | { id: string; familyId: string; coverAssetId: string | null };
      if (subject === 'child') {
        const changed = await tx.child.updateMany({
          where: {
            id,
            familyId,
            deletedAt: null,
            status: 'ACTIVE',
            version: current.version,
          },
          data: { [field]: assetId, version: { increment: 1 } },
        });
        if (!changed.count)
          throw new DomainError(
            'Child changed concurrently; retry.',
            'CHILD_STATUS_CONFLICT',
            409,
          );
        result = mapChild(await tx.child.findUniqueOrThrow({ where: { id } }));
      } else {
        const changed = await tx.pregnancy.updateMany({
          where: {
            id,
            familyId,
            deletedAt: null,
            status: 'ACTIVE',
            version: current.version,
          },
          data: { coverAssetId: assetId, version: { increment: 1 } },
        });
        if (!changed.count)
          throw new DomainError(
            'Pregnancy changed concurrently; retry.',
            'PREGNANCY_STATUS_CONFLICT',
            409,
          );
        result = await tx.pregnancy.findUniqueOrThrow({
          where: { id },
          select: { id: true, familyId: true, coverAssetId: true },
        });
      }
      await tx.outboxEvent.create({
        data: {
          familyId,
          eventType: `${subject}.profile_changed`,
          payload: { id, field },
        },
      });
      return result;
    });
  }
  async stats(child: Child, userId: string, circle: boolean) {
    const circleScope = circle
      ? await memoryContentScope(this.prisma, child.familyId, userId)
      : null;
    const visible: Prisma.MemoryWhereInput = {
      familyId: child.familyId,
      deletedAt: null,
      memoryChildren: {
        some: { familyId: child.familyId, childId: child.id, deletedAt: null },
      },
      AND: [
        {
          OR: [
            { kind: { not: 'LETTER' } },
            { authorUserId: userId },
            { unlockAt: null },
            { unlockAt: { lte: new Date() } },
          ],
        },
        ...(circleScope ? [circleScope.where] : []),
      ],
      ...(circle
        ? {
            status: 'PUBLISHED',
            visibility: 'FAMILY',
            OR: [
              { pregnancyId: null },
              {
                pregnancy: {
                  status: { in: ['ACTIVE', 'COMPLETED'] },
                  deletedAt: null,
                },
              },
            ],
          }
        : {
            OR: [
              {
                status: 'PUBLISHED',
                visibility: { in: ['PARENTS', 'FAMILY'] },
              },
              { status: 'PENDING_REVIEW' },
              {
                authorUserId: userId,
                status: { in: ['PUBLISHED', 'PROCESSING', 'DRAFT'] },
              },
            ],
          }),
    };
    return this.prisma.$transaction(
      async (tx) => {
        const [memoryCount, first, milestoneCount, photos] = await Promise.all([
          tx.memory.count({ where: visible }),
          tx.memory.findFirst({
            where: visible,
            orderBy: [{ occurredAt: 'asc' }, { id: 'asc' }],
            select: { occurredAt: true },
          }),
          tx.milestone.count({
            where: {
              familyId: child.familyId,
              childId: child.id,
              deletedAt: null,
              memory: visible,
            },
          }),
          tx.memoryAsset.findMany({
            where: {
              familyId: child.familyId,
              deletedAt: null,
              memory: visible,
              asset: {
                familyId: child.familyId,
                kind: 'IMAGE',
                status: 'READY',
                deletedAt: null,
                privateOwnerUserId: null,
              },
            },
            distinct: ['assetId'],
            select: { assetId: true },
          }),
        ]);
        return {
          memoryCount,
          milestoneCount,
          firstMemoryAt: first?.occurredAt.toISOString() ?? null,
          photoCount: photos.length,
        };
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }
}
