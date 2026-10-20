import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import { cloneDatabaseJson } from '../common/database.types';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { Child } from '../models/child.model';
import { Memory } from '../models/memory.model';
import {
  MonthlyPhotoCandidate,
  MonthlyPhotoChild,
  MonthlyPhotoSelection,
} from '../models/monthly-photo-selection.model';
import type { IMonthlyPhotoSelectionRepository } from '../interfaces/repositories/monthly-photo-selection-repository.interface';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions, memoryExclusionWhere } from './viewer-exclusions';
@Injectable()
export class MonthlyPhotoSelectionRepository implements IMonthlyPhotoSelectionRepository {
  constructor(private readonly prisma: PrismaService) {}
  async child(id: string, userId: string) {
    const row = await this.prisma.child.findFirst({
      where: { id, deletedAt: null, status: 'ACTIVE' },
    });
    if (!row) return null;
    const scope = await memoryContentScope(this.prisma, row.familyId, userId);
    return new MonthlyPhotoChild(
      new Child({
        ...row,
        profile: cloneDatabaseJson(row.profile),
        birthStats: cloneDatabaseJson(row.birthStats),
      }),
      scope.isParent || scope.childIds.includes(id),
    );
  }
  async candidate(familyId: string, memoryId: string, assetId: string) {
    const row = await this.prisma.memory.findFirst({
      where: { id: memoryId, familyId, deletedAt: null },
      include: {
        memoryChildren: { where: { deletedAt: null } },
        memoryAsset: {
          where: { assetId, deletedAt: null },
          include: { asset: true },
        },
      },
    });
    if (!row) return null;
    const asset = row.memoryAsset[0]?.asset;
    return new MonthlyPhotoCandidate(
      new Memory(row),
      row.memoryChildren.map((c) => c.childId),
      !!asset &&
        asset.familyId === familyId &&
        asset.deletedAt === null &&
        asset.kind === 'IMAGE' &&
        asset.status === 'READY',
    );
  }
  async list(familyId: string, childId: string, userId: string) {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    const excluded = memoryExclusionWhere(
      await viewerExclusions(this.prisma, familyId, userId),
    );
    const rows = await this.prisma.monthlyPhoto.findMany({
      where: {
        familyId,
        childId,
        deletedAt: null,
        memory: {
          AND: [
            scope.isParent
              ? {
                  OR: [
                    { visibility: { in: ['PARENTS', 'FAMILY'] } },
                    { authorUserId: userId },
                  ],
                }
              : scope.where,
            excluded,
          ],
          deletedAt: null,
          status: 'PUBLISHED',
          memoryChildren: {
            some: { childId, deletedAt: null },
            none: { childId: { not: childId }, deletedAt: null },
          },
          memoryAsset: {
            some: {
              familyId,
              deletedAt: null,
              asset: { deletedAt: null, status: 'READY', kind: 'IMAGE' },
            },
          },
        },
        memoryAsset: {
          deletedAt: null,
          asset: { deletedAt: null, status: 'READY', kind: 'IMAGE' },
        },
      },
      include: { memory: true },
      orderBy: { monthIndex: 'asc' },
    });
    return rows.flatMap((r) =>
      r.monthIndex === null
        ? []
        : [
            new MonthlyPhotoSelection(
              r.monthIndex,
              r.memoryId,
              r.assetId,
              r.memory.occurredAt,
              r.memory.occurredLocalDate,
            ),
          ],
    );
  }
  set(
    familyId: string,
    childId: string,
    userId: string,
    monthIndex: number,
    memoryId: string,
    assetId: string,
    version: number,
  ) {
    return this.prisma.$transaction(async (tx) => {
      // Serialize replacements on the child, including two first inserts. Locks also
      // coordinate child lifecycle changes without introducing a schema migration.
      const child = await tx.$queryRaw<{ id: string }[]>(
        Prisma.sql`SELECT id FROM app.children WHERE id=${childId}::uuid AND family_id=${familyId}::uuid AND deleted_at IS NULL AND status='ACTIVE' FOR UPDATE`,
      );
      if (!child.length) throw new NotFoundError('Child was not found.');
      await tx.$queryRaw(
        Prisma.sql`SELECT id FROM app.memories WHERE id=${memoryId}::uuid AND family_id=${familyId}::uuid FOR UPDATE`,
      );
      const target = await tx.memory.findFirst({
        where: {
          id: memoryId,
          familyId,
          version,
          deletedAt: null,
          status: 'PUBLISHED',
          kind: { in: ['MOMENT', 'MONTHLY_PHOTO'] },
          memoryAsset: {
            some: {
              assetId,
              deletedAt: null,
              asset: { deletedAt: null, status: 'READY', kind: 'IMAGE' },
            },
          },
        },
      });
      if (!target)
        throw new DomainError(
          'Memory changed; reload.',
          'VERSION_CONFLICT',
          412,
        );
      const old = await tx.monthlyPhoto.findFirst({
        where: { familyId, childId, monthIndex, deletedAt: null },
      });
      if (old && old.memoryId !== memoryId) {
        // BR-072: preserve media, content and publication; only remove designation.
        await tx.memory.updateMany({
          where: {
            id: old.memoryId,
            familyId,
            kind: 'MONTHLY_PHOTO',
            deletedAt: null,
          },
          data: { kind: 'MOMENT', version: { increment: 1 } },
        });
      }
      if (target.kind !== 'MONTHLY_PHOTO')
        await tx.memory.update({
          where: { id: memoryId },
          data: { kind: 'MONTHLY_PHOTO', version: { increment: 1 } },
        });
      if (old)
        await tx.monthlyPhoto.update({
          where: { id: old.id },
          data: { memoryId, assetId, setBy: userId, setAt: new Date() },
        });
      else
        await tx.monthlyPhoto.create({
          data: {
            familyId,
            childId,
            monthIndex,
            memoryId,
            assetId,
            setBy: userId,
          },
        });
      return new MonthlyPhotoSelection(
        monthIndex,
        memoryId,
        assetId,
        target.occurredAt,
        target.occurredLocalDate,
      );
    });
  }
}
