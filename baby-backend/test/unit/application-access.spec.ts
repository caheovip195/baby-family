import { randomUUID } from 'node:crypto';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import type { IAuthAccessRepository } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { Family } from '../../src/models/family.model';
import { FamilyEntitlement } from '../../src/models/family-entitlement.model';
import { FamilyAccessState } from '../../src/models/family-access-state.model';
import type { FamilyAccessStateAttributes } from '../../src/models/family-access-state.model';

describe('family business access policy', () => {
  const actor = {
    userId: randomUUID(),
    sessionId: randomUUID(),
    tokenVersion: 1,
  };
  const familyId = randomUUID();
  const repository: jest.Mocked<IAuthAccessRepository> = {
    findUserSessionState: jest.fn(),
    findFamilyAccessState: jest.fn(),
  };
  const service = new ApplicationAccessService(repository);
  const state = (overrides: Partial<FamilyAccessStateAttributes> = {}) => {
    const now = new Date();
    return new FamilyAccessState({
      family: new Family({
        id: familyId,
        name: 'Family',
        coverAssetId: null,
        status: 'ACTIVE',
        activatedAt: now,
        timezone: 'Asia/Ho_Chi_Minh',
        contentLocale: 'vi',
        settings: {},
        accessVersion: 1,
        createdBy: actor.userId,
        createdAt: now,
        updatedAt: now,
        deletionScheduledAt: null,
        deletedAt: null,
      }),
      activeParentCount: 2,
      licenseBlocked: false,
      entitlement: new FamilyEntitlement({
        familyId,
        licenseId: randomUUID(),
        accessPhase: 'TRIAL',
        effectivePlanVersionId: randomUUID(),
        sourceGrantId: randomUUID(),
        trialStartedAt: now,
        trialEndsAt: new Date(now.getTime() + 60000),
        validUntil: new Date(now.getTime() + 60000),
        inGrace: false,
        computedAt: now,
        version: 1n,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
      }),
      ...overrides,
    });
  };
  beforeEach(() => repository.findFamilyAccessState.mockResolvedValue(state()));
  it('allows active Parent operations using current server data', async () => {
    expect(
      await service.requireParent(actor, familyId, 'write'),
    ).toBeInstanceOf(Family);
    expect(repository.findFamilyAccessState).toHaveBeenCalledWith(
      familyId,
      actor.userId,
      expect.any(Date),
    );
  });
  it('rejects non-members and Circle before repository operations', async () => {
    repository.findFamilyAccessState.mockResolvedValue(null);
    await expect(
      service.requireParent(actor, familyId, 'read'),
    ).rejects.toMatchObject({ code: 'NOT_FOUND', statusCode: 404 });
  });
  it('checks expiry immediately even if the expiry worker has not run', async () => {
    const current = state();
    repository.findFamilyAccessState.mockResolvedValue(
      state({
        entitlement: new FamilyEntitlement({
          ...current.entitlement!,
          validUntil: new Date(0),
        }),
      }),
    );
    await expect(
      service.requireParent(actor, familyId, 'read'),
    ).rejects.toMatchObject({ code: 'SUBSCRIPTION_REQUIRED', statusCode: 402 });
    expect(
      await service.requireParent(actor, familyId, 'metadata'),
    ).toBeInstanceOf(Family);
  });
  it('rejects missing entitlement, blocked license and insufficient active Parents', async () => {
    repository.findFamilyAccessState.mockResolvedValueOnce(
      state({ entitlement: null }),
    );
    await expect(
      service.requireParent(actor, familyId, 'write'),
    ).rejects.toMatchObject({ statusCode: 402 });
    repository.findFamilyAccessState.mockResolvedValueOnce(
      state({ licenseBlocked: true }),
    );
    await expect(
      service.requireParent(actor, familyId, 'write'),
    ).rejects.toMatchObject({ code: 'LICENSE_BLOCKED' });
    repository.findFamilyAccessState.mockResolvedValueOnce(
      state({ activeParentCount: 1 }),
    );
    await expect(
      service.requireParent(actor, familyId, 'write'),
    ).rejects.toMatchObject({ code: 'FAMILY_NOT_ACTIVE' });
  });
  it('allows waiting-family metadata changes but blocks content', async () => {
    const current = state();
    repository.findFamilyAccessState.mockResolvedValue(
      state({
        family: new Family({ ...current.family, status: 'WAITING_PARTNER' }),
        activeParentCount: 1,
      }),
    );
    expect(
      await service.requireParent(actor, familyId, 'family-profile-update'),
    ).toBeInstanceOf(Family);
    await expect(
      service.requireParent(actor, familyId, 'read'),
    ).rejects.toMatchObject({ code: 'FAMILY_NOT_ACTIVE' });
  });
  it('allows remaining Parent to read after account deletion but denies writes', async () => {
    const current = state();
    repository.findFamilyAccessState.mockResolvedValue(
      state({
        family: new Family({ ...current.family, status: 'PARTNER_LEFT' }),
        activeParentCount: 1,
      }),
    );
    expect(await service.requireParent(actor, familyId, 'read')).toBeInstanceOf(
      Family,
    );
    await expect(
      service.requireParent(actor, familyId, 'write'),
    ).rejects.toMatchObject({ code: 'FAMILY_NOT_ACTIVE' });
  });
  it('does not bypass a blocked entitlement after a Parent account is deleted', async () => {
    const current = state();
    repository.findFamilyAccessState.mockResolvedValue(
      state({
        family: new Family({ ...current.family, status: 'PARTNER_LEFT' }),
        activeParentCount: 1,
        entitlement: new FamilyEntitlement({
          ...current.entitlement!,
          accessPhase: 'BLOCKED',
        }),
      }),
    );
    await expect(
      service.requireParent(actor, familyId, 'read'),
    ).rejects.toMatchObject({ code: 'LICENSE_BLOCKED' });
    expect(
      await service.requireParent(actor, familyId, 'metadata'),
    ).toBeInstanceOf(Family);
  });
});
