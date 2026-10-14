import { ServiceUnavailableException } from '@nestjs/common';
import { Prisma } from '../../src/generated/prisma/client';
import type { PrismaService } from '../../src/database/prisma.service';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import { NotFoundError } from '../../src/common/errors/domain.error';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';
import { AuthSessionState } from '../../src/models/auth-session-state.model';
import { FamilyAccessState } from '../../src/models/family-access-state.model';
import { Family } from '../../src/models/family.model';
import { FamilyEntitlement } from '../../src/models/family-entitlement.model';
import { FamilyUsage } from '../../src/models/family-usage.model';
import {
  BillingCatalog,
  BillingPlan,
  BillingTrialPolicy,
} from '../../src/models/billing-catalog.model';
import { FamilyBillingState } from '../../src/models/family-billing-state.model';
import { BillingCatalogService } from '../../src/services/billing-catalog.service';
import { FamilyBillingService } from '../../src/services/family-billing.service';
import { BillingProjection } from '../../src/services/billing-projection';
import type { ICatalogQueryRepository } from '../../src/interfaces/repositories/catalog-query-repository.interface';

const now = new Date('2026-10-14T02:00:00.000Z');
const actor: AuthPrincipal = {
  userId: 'actor',
  sessionId: 'session',
  tokenVersion: 4,
};
const family = new Family({
  id: 'family',
  name: 'Test',
  coverAssetId: null,
  status: 'ACTIVE',
  activatedAt: now,
  timezone: 'Asia/Ho_Chi_Minh',
  contentLocale: 'vi',
  settings: {},
  accessVersion: 1,
  createdBy: 'actor',
  createdAt: now,
  updatedAt: now,
  deletionScheduledAt: null,
  deletedAt: null,
});
const license = {
  id: 'license',
  deletedAt: null,
  blockedAt: null,
  blockReasonCode: null,
};
const entitlement = new FamilyEntitlement({
  familyId: 'family',
  licenseId: 'license',
  accessPhase: 'PAID',
  effectivePlanVersionId: 'plan-version',
  sourceGrantId: 'private-provenance',
  trialStartedAt: null,
  trialEndsAt: null,
  validUntil: new Date('2026-10-15T02:00:00.000Z'),
  inGrace: false,
  computedAt: now,
  version: 9007199254740993n,
  createdAt: now,
  updatedAt: now,
  deletedAt: null,
});
const plan = new BillingPlan({
  code: 'EXTRA_PLAN',
  displayName: { vi: 'Gói mở rộng' },
  displayOrder: 300,
  versionId: 'plan-version',
  version: 3,
  quotas: { storageBytes: 100 },
  features: { 'circle.enabled': true },
});
const usage = new FamilyUsage({
  familyId: 'family',
  storageBytes: 9007199254740993n,
  reservedStorageBytes: 10n,
  memoryCount: 2,
  albumCount: 1,
  activeSeries: 0,
  letterCount: 0,
  version: 1n,
  createdAt: now,
  updatedAt: now,
  deletedAt: null,
});

function transactionFixture(delegates: object) {
  const transaction = jest.fn(async (operation: unknown) => {
    if (Array.isArray(operation))
      return Promise.all(operation as Promise<unknown>[]);
    return (operation as (tx: object) => Promise<unknown>)(delegates);
  });
  return {
    transaction,
    prisma: {
      ...delegates,
      $transaction: transaction,
    } as unknown as PrismaService,
  };
}

describe('Auth access read repository', () => {
  it('checks session revocation/rotation/two expiry boundaries and active user in SQL, selecting no credentials', async () => {
    const findFirst = jest.fn().mockResolvedValue({
      id: 'session',
      userId: 'actor',
      user: { tokenVersion: 4 },
    });
    const { prisma, transaction } = transactionFixture({
      userSession: { findFirst },
    });
    const result = await new AuthAccessRepository(prisma).findUserSessionState(
      'session',
      'actor',
      now,
    );
    expect(result).toBeInstanceOf(AuthSessionState);
    expect(result).toEqual(actor);
    expect(findFirst).toHaveBeenCalledWith({
      where: {
        id: 'session',
        userId: 'actor',
        deletedAt: null,
        revokedAt: null,
        replacedBy: null,
        expiresAt: { gt: now },
        absoluteExpiresAt: { gt: now },
        user: { status: 'ACTIVE', deletedAt: null },
      },
      select: {
        id: true,
        userId: true,
        user: { select: { tokenVersion: true } },
      },
    });
    expect(transaction).toHaveBeenCalledWith(expect.any(Function), {
      isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead,
    });
    findFirst.mockResolvedValueOnce(null);
    expect(
      await new AuthAccessRepository(prisma).findUserSessionState(
        'session',
        'actor',
        now,
      ),
    ).toBeNull();
  });

  it('requires active actor membership and counts active parents in the same repeatable snapshot', async () => {
    const findFamily = jest.fn().mockResolvedValue({
      ...family,
      familyLicense: license,
      _count: { familyParents: 2 },
    });
    const findEntitlement = jest.fn().mockResolvedValue(entitlement);
    const { prisma } = transactionFixture({
      family: { findFirst: findFamily },
      familyEntitlement: { findFirst: findEntitlement },
    });
    const result = await new AuthAccessRepository(prisma).findFamilyAccessState(
      'family',
      'actor',
      now,
    );
    expect(result).toBeInstanceOf(FamilyAccessState);
    expect(result?.family).toBeInstanceOf(Family);
    expect(result?.activeParentCount).toBe(2);
    expect(result?.licenseBlocked).toBe(false);
    expect(result?.entitlement).toBeInstanceOf(FamilyEntitlement);
    const parent = {
      status: 'ACTIVE',
      deletedAt: null,
      leftAt: null,
      joinedAt: { lte: now },
      user: { status: 'ACTIVE', deletedAt: null },
    };
    expect(findFamily).toHaveBeenCalledWith({
      where: {
        id: 'family',
        deletedAt: null,
        status: { not: 'DELETED' },
        familyParents: { some: { ...parent, userId: 'actor' } },
      },
      include: {
        _count: { select: { familyParents: { where: parent } } },
        familyLicense: true,
      },
    });
    expect(findEntitlement).toHaveBeenCalledWith({
      where: { familyId: 'family', licenseId: 'license', deletedAt: null },
    });
  });

  it.each([
    null,
    { ...license, deletedAt: now },
    { ...license, blockedAt: now },
    { ...license, blockReasonCode: 'BLOCKED' },
  ])(
    'fails closed for a missing/deleted/blocked license',
    async (familyLicense) => {
      const { prisma } = transactionFixture({
        family: {
          findFirst: jest.fn().mockResolvedValue({
            ...family,
            familyLicense,
            _count: { familyParents: 2 },
          }),
        },
        familyEntitlement: {
          findFirst: jest.fn().mockResolvedValue(entitlement),
        },
      });
      const state = await new AuthAccessRepository(
        prisma,
      ).findFamilyAccessState('family', 'actor', now);
      expect(state?.licenseBlocked).toBe(true);
      if (!familyLicense || familyLicense.deletedAt)
        expect(state?.entitlement).toBeNull();
    },
  );

  it('returns null for an unrelated family without reading entitlement', async () => {
    const findEntitlement = jest.fn();
    const { prisma } = transactionFixture({
      family: { findFirst: jest.fn().mockResolvedValue(null) },
      familyEntitlement: { findFirst: findEntitlement },
    });
    expect(
      await new AuthAccessRepository(prisma).findFamilyAccessState(
        'other',
        'actor',
        now,
      ),
    ).toBeNull();
    expect(findEntitlement).not.toHaveBeenCalled();
  });
});

describe('Billing read queries and service projections', () => {
  it('filters purchasable active plans, available versions and published active trial policies before projection', async () => {
    const findPlans = jest.fn().mockResolvedValue([]);
    const findPolicies = jest.fn().mockResolvedValue([]);
    const { prisma, transaction } = transactionFixture({
      plan: { findMany: findPlans },
      trialPolicy: { findMany: findPolicies },
    });
    expect(await new CatalogQueryRepository(prisma).findCatalog(now)).toEqual(
      new BillingCatalog([], []),
    );
    const version = {
      deletedAt: null,
      availableFrom: { lte: now },
      OR: [{ retiredAt: null }, { retiredAt: { gt: now } }],
    };
    expect(findPlans).toHaveBeenCalledWith(
      expect.objectContaining({
        where: {
          active: true,
          purchaseEnabled: true,
          deletedAt: null,
          planVersions: { some: version },
        },
        include: {
          planVersions: {
            where: version,
            orderBy: [{ version: 'desc' }, { id: 'asc' }],
            take: 1,
          },
        },
      }),
    );
    expect(findPolicies).toHaveBeenCalledWith(
      expect.objectContaining({
        where: {
          active: true,
          deletedAt: null,
          publishedAt: { lte: now },
          OR: [{ retiredAt: null }, { retiredAt: { gt: now } }],
          planVersion: { ...version, plan: { active: true, deletedAt: null } },
        },
      }),
    );
    expect(transaction).toHaveBeenCalledWith(expect.any(Array), {
      isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead,
    });
  });

  it('accepts an extra plan and uses trial duration from the published model without SKU/price fabrication', async () => {
    const findCatalog = jest
      .fn()
      .mockResolvedValue(
        new BillingCatalog(
          [plan],
          [new BillingTrialPolicy('NEXT_TRIAL', 2, 864000n, [86400], plan)],
        ),
      );
    const repository = { findCatalog } as unknown as ICatalogQueryRepository;
    const result = await new BillingCatalogService(repository).list(actor);
    expect(result.plans[0]?.code).toBe('EXTRA_PLAN');
    expect(result.trialPolicies[0]?.durationSeconds).toBe('864000');
    expect(Object.keys(result.plans[0] ?? {}).sort()).toEqual([
      'code',
      'displayName',
      'displayOrder',
      'features',
      'quotas',
      'version',
      'versionId',
    ]);
    expect(JSON.stringify(result)).not.toMatch(
      /productId|price|purchaser|token|storageKey/,
    );
  });

  it('rejects malformed catalog values rather than publishing invalid capabilities', async () => {
    const invalid = new BillingPlan({ ...plan, features: { enabled: 'true' } });
    const repository = {
      findCatalog: jest
        .fn()
        .mockResolvedValue(new BillingCatalog([invalid], [])),
    } as unknown as ICatalogQueryRepository;
    await expect(
      new BillingCatalogService(repository).list(actor),
    ).rejects.toBeInstanceOf(ServiceUnavailableException);
  });

  it('uses metadata access for billing, rechecks membership in the query, and serializes bigint values exactly', async () => {
    const state = new FamilyBillingState(
      'family',
      false,
      entitlement,
      usage,
      plan,
    );
    const findFamilyBillingState = jest.fn().mockResolvedValue(state);
    const requireParent = jest.fn().mockResolvedValue(family);
    const service = new FamilyBillingService(
      { findFamilyBillingState } as unknown as ICatalogQueryRepository,
      { requireParent },
    );
    const result = await service.get(actor, 'family');
    expect(requireParent).toHaveBeenCalledWith(actor, 'family', 'metadata');
    expect(findFamilyBillingState).toHaveBeenCalledWith(
      'family',
      'actor',
      expect.any(Date),
    );
    expect(result.usage?.storageBytes).toBe('9007199254740993');
    expect(result.entitlementVersion).toBe('9007199254740993');
    expect(() => JSON.stringify(result)).not.toThrow();
    expect(JSON.stringify(result)).not.toMatch(
      /licenseId|sourceGrantId|private-provenance|purchaser|refreshToken/,
    );
  });

  it('stops before billing lookup when the actor lacks parent access', async () => {
    const findFamilyBillingState = jest.fn();
    const service = new FamilyBillingService(
      { findFamilyBillingState } as unknown as ICatalogQueryRepository,
      {
        requireParent: jest
          .fn()
          .mockRejectedValue(new NotFoundError('Family was not found.')),
      },
    );
    await expect(service.get(actor, 'other')).rejects.toBeInstanceOf(
      NotFoundError,
    );
    expect(findFamilyBillingState).not.toHaveBeenCalled();
  });

  it('returns 404 if membership disappears between policy check and billing read', async () => {
    const service = new FamilyBillingService(
      {
        findFamilyBillingState: jest.fn().mockResolvedValue(null),
      } as unknown as ICatalogQueryRepository,
      {
        requireParent: jest.fn().mockResolvedValue(family),
      },
    );
    await expect(service.get(actor, 'family')).rejects.toBeInstanceOf(
      NotFoundError,
    );
  });

  it('reports expired validity at its boundary while retaining readable billing metadata', async () => {
    const stale = new FamilyEntitlement({
      ...entitlement,
      validUntil: new Date(0),
      inGrace: true,
    });
    const service = new FamilyBillingService(
      {
        findFamilyBillingState: jest
          .fn()
          .mockResolvedValue(
            new FamilyBillingState('family', false, stale, usage, plan),
          ),
      } as unknown as ICatalogQueryRepository,
      {
        requireParent: jest.fn().mockResolvedValue(family),
      },
    );
    expect(await service.get(actor, 'family')).toMatchObject({
      accessPhase: 'EXPIRED',
      inGrace: false,
      plan: { code: 'EXTRA_PLAN' },
    });
  });

  it.each([null, now])(
    'reports a trial with missing/ended trial boundary as expired even when validUntil is future',
    (trialEndsAt) => {
      const stale = new FamilyEntitlement({
        ...entitlement,
        accessPhase: 'TRIAL',
        trialEndsAt,
      });
      expect(
        BillingProjection.family(
          new FamilyBillingState('family', false, stale, usage, plan),
          now,
        ),
      ).toMatchObject({ accessPhase: 'EXPIRED', inGrace: false });
    },
  );
});
