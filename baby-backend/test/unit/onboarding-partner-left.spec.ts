import type { ConfigService } from '@nestjs/config';
import type { Environment } from '../../src/config/environment';
import type { IOnboardingRepository } from '../../src/interfaces/repositories/onboarding-repository.interface';
import type { IUserRepository } from '../../src/interfaces/repositories/user-repository.interface';
import type { IAuthTokenService } from '../../src/interfaces/services/auth-token-service.interface';
import type { IFamilyBillingService } from '../../src/interfaces/services/family-billing-service.interface';
import { InvitePreview } from '../../src/models/onboarding-state.model';
import { OnboardingService } from '../../src/services/onboarding.service';

/** §7.3 bước 4 (BF-20261019-009): mời bạn đời mới sau PARTNER_LEFT hiện tên các bé. */
describe('OnboardingService partner invite preview', () => {
  const preview = (familyStatus: 'PARTNER_LEFT' | 'WAITING_PARTNER') =>
    new InvitePreview({
      inviteId: '00000000-0000-4000-8000-000000000001',
      type: 'PARTNER',
      status: 'PENDING',
      expiresAt: new Date(Date.now() + 86_400_000),
      familyId: '00000000-0000-4000-8000-000000000002',
      familyName: 'Synthetic family',
      familyStatus,
      inviterCallName: 'Mama',
      inviterKind: 'MOTHER',
      proposedKind: 'FATHER',
      message: null,
    });
  const service = (status: 'PARTNER_LEFT' | 'WAITING_PARTNER') => {
    const repository = {
      resolveInvite: jest.fn().mockResolvedValue(preview(status)),
      activeChildren: jest
        .fn()
        .mockResolvedValue([{ id: 'child-1', name: 'Hana' }]),
    } as unknown as IOnboardingRepository;
    return {
      repository,
      onboarding: new OnboardingService(
        {} as ConfigService<Environment, true>,
        repository,
        {} as IUserRepository,
        { keyedHash: () => Buffer.alloc(32) } as unknown as IAuthTokenService,
        {} as IFamilyBillingService,
      ),
    };
  };

  it('lists the children when the family is PARTNER_LEFT', async () => {
    const { onboarding } = service('PARTNER_LEFT');
    const result = await onboarding.resolveInvite({ code: 'ABCDEFGH' });
    expect(result).toMatchObject({
      type: 'PARTNER',
      state: 'VALID',
      children: [{ id: 'child-1', name: 'Hana' }],
    });
  });

  it('has no children before the first activation', async () => {
    const { onboarding, repository } = service('WAITING_PARTNER');
    const result = await onboarding.resolveInvite({ code: 'ABCDEFGH' });
    expect((result as { children?: unknown }).children).toBeUndefined();
    expect(
      (repository as unknown as { activeChildren: jest.Mock }).activeChildren,
    ).not.toHaveBeenCalled();
  });
});
