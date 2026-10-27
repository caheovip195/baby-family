import { randomUUID } from 'node:crypto';
import type { IApplicationAccessService } from '../../src/interfaces/services/application-access-service.interface';
import type { ICatalogQueryRepository } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import type { ICareStatsRepository } from '../../src/interfaces/repositories/care-stats-repository.interface';
import { BillingPlan } from '../../src/models/billing-catalog.model';
import { CareStatsSnapshot } from '../../src/models/care-stats-snapshot.model';
import { FamilyBillingState } from '../../src/models/family-billing-state.model';
import { FamilyEntitlement } from '../../src/models/family-entitlement.model';
import { Family } from '../../src/models/family.model';
import { CareStatsService } from '../../src/services/care-stats.service';

describe('CARE-11 timezone and week boundaries', () => {
  const actor = {
    userId: randomUUID(),
    sessionId: randomUUID(),
    tokenVersion: 1,
  };
  const familyId = randomUUID();
  const access: jest.Mocked<IApplicationAccessService> = {
    requireParent: jest.fn(),
  };
  const catalog: jest.Mocked<ICatalogQueryRepository> = {
    findCatalog: jest.fn(),
    findFamilyBillingState: jest.fn(),
  };
  const repository: jest.Mocked<ICareStatsRepository> = { readWeek: jest.fn() };
  const service = new CareStatsService(access, catalog, repository);

  const family = (timezone: string) =>
    new Family({
      id: familyId,
      name: 'Synthetic care statistics',
      coverAssetId: null,
      status: 'ACTIVE',
      activatedAt: new Date(),
      timezone,
      contentLocale: 'vi',
      settings: {},
      accessVersion: 1,
      createdBy: actor.userId,
      createdAt: new Date(),
      updatedAt: new Date(),
      deletionScheduledAt: null,
      deletedAt: null,
    });

  beforeEach(() => {
    jest.useFakeTimers().setSystemTime(new Date('2026-10-25T18:30:00Z'));
    jest.clearAllMocks();
    access.requireParent.mockResolvedValue(family('Asia/Ho_Chi_Minh'));
    catalog.findFamilyBillingState.mockResolvedValue(
      new FamilyBillingState(
        familyId,
        false,
        new FamilyEntitlement({
          familyId,
          licenseId: randomUUID(),
          accessPhase: 'PAID',
          effectivePlanVersionId: randomUUID(),
          sourceGrantId: null,
          trialStartedAt: null,
          trialEndsAt: null,
          validUntil: new Date('2027-01-01T00:00:00Z'),
          inGrace: false,
          computedAt: new Date(),
          version: 1n,
          createdAt: new Date(),
          updatedAt: new Date(),
          deletedAt: null,
        }),
        null,
        new BillingPlan({
          code: 'SYNTHETIC_THIRD_PLAN',
          displayName: { vi: 'Synthetic plan' },
          displayOrder: 99,
          versionId: randomUUID(),
          version: 1,
          quotas: {},
          features: { 'care.statistics': true },
        }),
      ),
    );
    repository.readWeek.mockResolvedValue(new CareStatsSnapshot([], []));
  });
  afterEach(() => jest.useRealTimers());

  it.each([
    ['Asia/Ho_Chi_Minh', '2026-10-26', '2026-11-01', '2026-11-02'],
    ['America/Los_Angeles', '2026-10-19', '2026-10-25', '2026-10-26'],
    ['Pacific/Kiritimati', '2026-10-26', '2026-11-01', '2026-11-02'],
  ])(
    'uses %s Monday around the UTC Sunday boundary',
    async (timezone, weekStart, weekEnd, exclusiveEnd) => {
      access.requireParent.mockResolvedValue(family(timezone));
      expect(await service.get(actor, familyId, {})).toMatchObject({
        weekStart,
        weekEnd,
      });
      expect(repository.readWeek).toHaveBeenCalledWith(
        familyId,
        new Date(`${weekStart}T00:00:00Z`),
        new Date(`${exclusiveEnd}T00:00:00Z`),
        undefined,
      );
    },
  );

  it('keeps a seven-day calendar week across the DST transition', async () => {
    jest.setSystemTime(new Date('2026-11-01T12:00:00Z'));
    access.requireParent.mockResolvedValue(family('America/New_York'));
    const result = await service.get(actor, familyId, {
      weekStart: '2026-10-26',
    });
    expect(result).toMatchObject({
      weekStart: '2026-10-26',
      weekEnd: '2026-11-01',
      bloomed: [false, false, false, false, false, false, false],
    });
    expect(repository.readWeek).toHaveBeenCalledWith(
      familyId,
      new Date('2026-10-26T00:00:00Z'),
      new Date('2026-11-02T00:00:00Z'),
      undefined,
    );
  });

  it('accepts a leap-day Monday and rejects a nonexistent date without querying stats', async () => {
    jest.setSystemTime(new Date('2044-02-29T12:00:00Z'));
    // The catalog mock must still represent an active subscription at this clock.
    const state = (await catalog.findFamilyBillingState(
      familyId,
      actor.userId,
      new Date(),
    ))!;
    catalog.findFamilyBillingState.mockResolvedValue(
      new FamilyBillingState(
        familyId,
        false,
        new FamilyEntitlement({
          ...state.entitlement!,
          validUntil: new Date('2045-01-01T00:00:00Z'),
        }),
        null,
        state.effectivePlan,
      ),
    );
    expect(
      await service.get(actor, familyId, { weekStart: '2044-02-29' }),
    ).toMatchObject({ weekStart: '2044-02-29', weekEnd: '2044-03-06' });
    repository.readWeek.mockClear();
    await expect(
      service.get(actor, familyId, { weekStart: '2043-02-29' }),
    ).rejects.toMatchObject({
      code: 'CARE_STATS_WEEK_INVALID',
      statusCode: 400,
    });
    expect(repository.readWeek).not.toHaveBeenCalled();
  });

  it('fails closed for a malformed feature array even if a catalog adapter returns one', async () => {
    const state = (await catalog.findFamilyBillingState(
      familyId,
      actor.userId,
      new Date(),
    ))!;
    catalog.findFamilyBillingState.mockResolvedValue(
      new FamilyBillingState(
        familyId,
        false,
        state.entitlement,
        null,
        new BillingPlan({
          ...state.effectivePlan!,
          features: ['care.statistics'],
        }),
      ),
    );
    await expect(service.get(actor, familyId, {})).rejects.toMatchObject({
      code: 'SUBSCRIPTION_REQUIRED',
      statusCode: 402,
    });
    expect(repository.readWeek).not.toHaveBeenCalled();
  });
});
