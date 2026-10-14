import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { AUTH_ACCESS_REPOSITORY } from '../interfaces/repositories/auth-access-repository.interface';
import type { IAuthAccessRepository } from '../interfaces/repositories/auth-access-repository.interface';
import type {
  FamilyAccessMode,
  IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type { Family } from '../models/family.model';

@Injectable()
export class ApplicationAccessService implements IApplicationAccessService {
  constructor(
    @Inject(AUTH_ACCESS_REPOSITORY)
    private readonly repository: IAuthAccessRepository,
  ) {}

  async requireParent(
    actor: AuthPrincipal,
    familyId: string,
    mode: FamilyAccessMode,
  ): Promise<Family> {
    const now = new Date();
    const state = await this.repository.findFamilyAccessState(
      familyId,
      actor.userId,
      now,
    );
    if (!state || state.family.deletedAt || state.family.status === 'DELETED')
      throw new NotFoundError('Family was not found.');
    const family = state.family;
    // Bootstrap metadata and billing stay available to the original active Parent.
    if (mode === 'metadata') return family;
    if (mode === 'family-profile-update' && family.status === 'WAITING_PARTNER')
      return family;
    if (state.licenseBlocked || state.entitlement?.accessPhase === 'BLOCKED')
      throw new DomainError(
        'The family license is blocked.',
        'LICENSE_BLOCKED',
        403,
      );
    if (family.status === 'PARTNER_LEFT' && mode === 'read') return family;
    if (family.status !== 'ACTIVE' || state.activeParentCount !== 2)
      throw new DomainError(
        'The family is not active for this operation.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
    const entitlement = state.entitlement;
    if (
      !entitlement ||
      entitlement.deletedAt ||
      (entitlement.accessPhase !== 'TRIAL' &&
        entitlement.accessPhase !== 'PAID') ||
      !entitlement.validUntil ||
      entitlement.validUntil.getTime() <= now.getTime() ||
      (entitlement.accessPhase === 'TRIAL' &&
        (!entitlement.trialEndsAt ||
          entitlement.trialEndsAt.getTime() <= now.getTime()))
    )
      throw new DomainError(
        'An active family subscription is required.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    return family;
  }
}
