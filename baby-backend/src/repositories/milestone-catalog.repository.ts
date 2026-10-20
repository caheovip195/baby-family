import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import type { Prisma } from '../generated/prisma/client';
import type {
  IMilestoneCatalogRepository,
  MilestoneCursor,
  MilestoneSubjectContext,
} from '../interfaces/repositories/milestone-catalog-repository.interface';
import { MilestoneTemplate } from '../models/milestone-template.model';
import { Milestone } from '../models/milestone.model';
import { Memory } from '../models/memory.model';
import { memoryContentScope } from './memory-content-visibility';
@Injectable()
export class MilestoneCatalogRepository implements IMilestoneCatalogRepository {
  constructor(private readonly prisma: PrismaService) {}
  async subject(
    id: string,
    pregnancy: boolean,
    userId: string,
  ): Promise<MilestoneSubjectContext | null> {
    const row = pregnancy
      ? await this.prisma.pregnancy.findFirst({
          where: { id, deletedAt: null },
        })
      : await this.prisma.child.findFirst({
          where: { id, deletedAt: null, status: { not: 'DELETED' } },
        });
    if (!row) return null;
    const [parent, circle, family, entitlement, license] = await Promise.all([
      this.prisma.familyParent.findFirst({
        where: {
          familyId: row.familyId,
          userId,
          status: 'ACTIVE',
          deletedAt: null,
        },
      }),
      this.prisma.circleMember.findFirst({
        where: { familyId: row.familyId, userId },
        include: {
          circleGrants: {
            where: {
              ...(pregnancy ? { pregnancyId: id } : { childId: id }),
              status: 'ACTIVE',
              deletedAt: null,
            },
          },
        },
      }),
      this.prisma.family.findFirst({
        where: { id: row.familyId, deletedAt: null },
      }),
      this.prisma.familyEntitlement.findFirst({
        where: { familyId: row.familyId, deletedAt: null },
        include: { planVersion: true },
      }),
      this.prisma.familyLicense.findFirst({
        where: { familyId: row.familyId, deletedAt: null },
      }),
    ]);
    const features = entitlement?.planVersion?.features;
    const settings = family?.settings;
    return {
      id,
      familyId: row.familyId,
      pregnancy,
      birthDate: 'birthDate' in row ? row.birthDate : null,
      traditionalUseLunar:
        !!settings &&
        typeof settings === 'object' &&
        !Array.isArray(settings) &&
        settings['traditionalUseLunar'] === true,
      parent: !!parent,
      circle: circle
        ? {
            active: circle.status === 'ACTIVE' && !circle.deletedAt,
            granted:
              circle.circleGrants.length > 0 &&
              (pregnancy
                ? ['ACTIVE', 'COMPLETED'].includes(row.status)
                : row.status === 'ACTIVE'),
            enabled:
              !!features &&
              typeof features === 'object' &&
              !Array.isArray(features) &&
              features['circle.enabled'] === true &&
              !entitlement?.planVersion?.deletedAt,
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
  async templates(pregnancy?: boolean) {
    return (
      await this.prisma.milestoneTemplate.findMany({
        where: {
          deletedAt: null,
          status: 'ACTIVE',
          ...(pregnancy === undefined
            ? {}
            : { category: pregnancy ? 'PREGNANCY' : { not: 'PREGNANCY' } }),
        },
        orderBy: [{ sortOrder: 'asc' }, { code: 'asc' }],
      })
    ).map(
      (row) =>
        new MilestoneTemplate({
          ...row,
          titleI18n: cloneDatabaseJson(row.titleI18n),
          promptI18n:
            row.promptI18n === null ? null : cloneDatabaseJson(row.promptI18n),
          dateRule:
            row.dateRule === null ? null : cloneDatabaseJson(row.dateRule),
        }),
    );
  }
  async records(
    subject: MilestoneSubjectContext,
    userId: string,
    circle: boolean,
    after: MilestoneCursor | null,
    limit?: number,
  ) {
    const circleScope = circle
      ? await memoryContentScope(this.prisma, subject.familyId, userId)
      : null;
    const memoryWhere: Prisma.MemoryWhereInput = {
      familyId: subject.familyId,
      deletedAt: null,
      kind: 'MILESTONE',
      ...(circle
        ? {
            status: 'PUBLISHED',
            visibility: 'FAMILY',
            AND: circleScope ? [circleScope.where] : [],
            OR: [
              { pregnancyId: null },
              {
                pregnancy: {
                  deletedAt: null,
                  status: { in: ['ACTIVE', 'COMPLETED'] },
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
              {
                authorUserId: userId,
                status: { in: ['PUBLISHED', 'PROCESSING'] },
              },
            ],
          }),
    };
    const rows = await this.prisma.milestone.findMany({
      where: {
        familyId: subject.familyId,
        deletedAt: null,
        ...(subject.pregnancy
          ? { pregnancyId: subject.id }
          : { childId: subject.id }),
        memory: memoryWhere,
        ...(after
          ? {
              OR: [
                { occurredOn: { lt: after.occurredOn } },
                { occurredOn: after.occurredOn, id: { lt: after.id } },
              ],
            }
          : {}),
      },
      include: {
        memory: {
          include: {
            memoryAsset: {
              where: {
                deletedAt: null,
                isCover: true,
                asset: { deletedAt: null },
              },
              take: 1,
            },
          },
        },
      },
      orderBy: [{ occurredOn: 'desc' }, { id: 'desc' }],
      ...(limit === undefined ? {} : { take: limit + 1 }),
    });
    return rows.map((row) => ({
      milestone: new Milestone(row),
      memory: new Memory(row.memory),
      coverAssetId: row.memory.memoryAsset[0]?.assetId ?? null,
    }));
  }
}
