import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IAdminCmsCatalogRepository } from '../interfaces/repositories/admin-cms-catalog-repository.interface';
import type { AdminCmsCatalogKind } from '../dto/admin-cms-catalog/admin-cms-catalog.dto';
import { AdminCmsCatalogEntry } from '../models/admin-cms-catalog-entry.model';
@Injectable()
export class AdminCmsCatalogRepository implements IAdminCmsCatalogRepository {
  constructor(private readonly prisma: PrismaService) {}
  async list(
    adminId: string,
    kind: AdminCmsCatalogKind,
    offset: number,
    limit: number,
  ): Promise<AdminCmsCatalogEntry[]> {
    return this.prisma.$transaction(async (tx) => {
      const pagination = {
        skip: offset,
        take: limit,
        where: { deletedAt: null },
      };
      let rows: object[];
      switch (kind) {
        case 'missions':
          rows = await tx.missionTemplate.findMany({
            ...pagination,
            orderBy: { code: 'asc' },
            select: {
              id: true,
              code: true,
              stage: true,
              minAgeDays: true,
              maxAgeDays: true,
              minPregWeek: true,
              maxPregWeek: true,
              category: true,
              suggestedScope: true,
              roleFit: true,
              hearts: true,
              durationMin: true,
              multiChildOk: true,
              requestable: true,
              titleI18n: true,
              descI18n: true,
              memoryPromptI18n: true,
              tags: true,
              weight: true,
              rolloutPct: true,
              status: true,
              version: true,
            },
          });
          break;
        case 'milestones':
          rows = await tx.milestoneTemplate.findMany({
            ...pagination,
            orderBy: { code: 'asc' },
            select: {
              code: true,
              category: true,
              icon: true,
              titleI18n: true,
              promptI18n: true,
              isTraditional: true,
              dateRule: true,
              remindDaysBefore: true,
              sortOrder: true,
              status: true,
            },
          });
          break;
        case 'notification-templates':
          rows = await tx.notificationTemplate.findMany({
            ...pagination,
            orderBy: [{ code: 'asc' }, { locale: 'asc' }],
            select: {
              code: true,
              locale: true,
              title: true,
              body: true,
              sensitive: true,
              hiddenTitle: true,
              hiddenBody: true,
              category: true,
              priority: true,
              enabled: true,
            },
          });
          break;
        case 'plan-versions':
          rows = await tx.planVersion.findMany({
            ...pagination,
            where: { deletedAt: null, plan: { deletedAt: null } },
            orderBy: [{ planId: 'asc' }, { version: 'desc' }],
            select: {
              id: true,
              planId: true,
              version: true,
              quotas: true,
              entitlementRank: true,
              features: true,
              availableFrom: true,
              retiredAt: true,
              plan: {
                select: {
                  id: true,
                  code: true,
                  displayNameI18n: true,
                  displayOrder: true,
                  purchaseEnabled: true,
                  active: true,
                },
              },
            },
          });
          break;
        case 'trial-policies':
          rows = await tx.trialPolicy.findMany({
            ...pagination,
            where: {
              deletedAt: null,
              planVersion: { deletedAt: null, plan: { deletedAt: null } },
            },
            orderBy: [{ code: 'asc' }, { version: 'desc' }],
            select: {
              id: true,
              code: true,
              version: true,
              planVersionId: true,
              durationSeconds: true,
              reminderOffsetsSeconds: true,
              active: true,
              publishedAt: true,
              retiredAt: true,
            },
          });
          break;
      }
      await tx.adminAuditEvent.create({
        data: {
          adminId,
          action: 'CATALOG_LIST',
          entityType: 'CATALOG',
          entityId: kind,
          redactedChanges: { offset, limit },
        },
      });
      // Date -> ISO and bigint duration -> decimal string, preserving exact values.
      return rows.map(
        (row) =>
          new AdminCmsCatalogEntry(
            JSON.parse(
              JSON.stringify(row, (_key, value: unknown) =>
                typeof value === 'bigint' ? value.toString() : value,
              ),
            ) as Record<string, unknown>,
          ),
      );
    });
  }
}
