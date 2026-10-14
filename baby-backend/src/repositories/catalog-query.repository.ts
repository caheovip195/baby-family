import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type { Plan, PlanVersion } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import type { ICatalogQueryRepository } from '../interfaces/repositories/catalog-query-repository.interface';
import {
  BillingCatalog,
  BillingPlan,
  BillingTrialPolicy,
} from '../models/billing-catalog.model';
import { FamilyBillingState } from '../models/family-billing-state.model';
import { FamilyEntitlement } from '../models/family-entitlement.model';
import { FamilyUsage } from '../models/family-usage.model';

function mapPlan(plan: Plan, version: PlanVersion): BillingPlan {
  return new BillingPlan({
    code: plan.code,
    displayName: cloneDatabaseJson(plan.displayNameI18n),
    displayOrder: plan.displayOrder,
    versionId: version.id,
    version: version.version,
    quotas: cloneDatabaseJson(version.quotas),
    features: cloneDatabaseJson(version.features),
  });
}

@Injectable()
export class CatalogQueryRepository implements ICatalogQueryRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findCatalog(now: Date): Promise<BillingCatalog> {
    const availableVersion: Prisma.PlanVersionWhereInput = {
      deletedAt: null,
      availableFrom: { lte: now },
      OR: [{ retiredAt: null }, { retiredAt: { gt: now } }],
    };
    const [plans, policies] = await this.prisma.$transaction(
      [
        this.prisma.plan.findMany({
          where: {
            active: true,
            purchaseEnabled: true,
            deletedAt: null,
            planVersions: { some: availableVersion },
          },
          include: {
            planVersions: {
              where: availableVersion,
              orderBy: [{ version: 'desc' }, { id: 'asc' }],
              take: 1,
            },
          },
          orderBy: [{ displayOrder: 'asc' }, { code: 'asc' }],
        }),
        this.prisma.trialPolicy.findMany({
          where: {
            active: true,
            deletedAt: null,
            publishedAt: { lte: now },
            OR: [{ retiredAt: null }, { retiredAt: { gt: now } }],
            planVersion: {
              ...availableVersion,
              plan: { active: true, deletedAt: null },
            },
          },
          include: { planVersion: { include: { plan: true } } },
          orderBy: [{ code: 'asc' }, { version: 'desc' }],
        }),
      ],
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
    return new BillingCatalog(
      plans.flatMap((plan) =>
        plan.planVersions[0] ? [mapPlan(plan, plan.planVersions[0])] : [],
      ),
      policies.map(
        (policy) =>
          new BillingTrialPolicy(
            policy.code,
            policy.version,
            policy.durationSeconds,
            [...policy.reminderOffsetsSeconds],
            mapPlan(policy.planVersion.plan, policy.planVersion),
          ),
      ),
    );
  }

  findFamilyBillingState(
    familyId: string,
    userId: string,
    now: Date,
  ): Promise<FamilyBillingState | null> {
    return this.prisma.$transaction(
      async (tx) => {
        const row = await tx.family.findFirst({
          where: {
            id: familyId,
            deletedAt: null,
            status: { not: 'DELETED' },
            familyParents: {
              some: {
                userId,
                status: 'ACTIVE',
                deletedAt: null,
                leftAt: null,
                joinedAt: { lte: now },
                user: { status: 'ACTIVE', deletedAt: null },
              },
            },
          },
          include: {
            familyLicense: true,
          },
        });
        if (!row) return null;
        const license = row.familyLicense;
        const [entitlement, usage] = await Promise.all([
          license && license.deletedAt === null
            ? tx.familyEntitlement.findFirst({
                where: { familyId, licenseId: license.id, deletedAt: null },
                include: { planVersion: { include: { plan: true } } },
              })
            : null,
          tx.familyUsage.findFirst({ where: { familyId, deletedAt: null } }),
        ]);
        const version = entitlement?.planVersion;
        return new FamilyBillingState(
          row.id,
          !license ||
            license.deletedAt !== null ||
            license.blockedAt !== null ||
            license.blockReasonCode !== null,
          entitlement ? new FamilyEntitlement(entitlement) : null,
          usage ? new FamilyUsage(usage) : null,
          version &&
            version.deletedAt === null &&
            version.plan.deletedAt === null
            ? mapPlan(version.plan, version)
            : null,
        );
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }
}
