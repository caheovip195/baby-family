import {
  MEMORY_LIBRARY_REPOSITORY,
  type IMemoryLibraryRepository,
} from '../interfaces/repositories/memory-library-repository.interface';
import { Inject, Injectable, Optional } from '@nestjs/common';
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
    @Optional()
    @Inject(MEMORY_LIBRARY_REPOSITORY)
    private readonly memories?: IMemoryLibraryRepository,
  ) {}

  async requireContentAccess(
    actor: AuthPrincipal,
    familyId: string,
    mode: FamilyAccessMode,
  ): Promise<{ family: Family; isParent: boolean }> {
    const state = await this.memories?.familyAccess(familyId, actor.userId);
    if (!state || state.isParent)
      return {
        family: await this.requireParent(actor, familyId, mode),
        isParent: true,
      };
    if (!state.circleActive)
      throw new DomainError(
        'Circle access was revoked.',
        'CIRCLE_ACCESS_REVOKED',
        403,
      );
    const ent = state.entitlement,
      now = new Date();
    if (
      state.circleEnabled !== true ||
      state.family.status !== 'ACTIVE' ||
      state.licenseBlocked ||
      !ent ||
      !['PAID', 'TRIAL'].includes(ent.accessPhase) ||
      !ent.validUntil ||
      ent.validUntil <= now ||
      (ent.accessPhase === 'TRIAL' &&
        (!ent.trialEndsAt || ent.trialEndsAt <= now))
    )
      throw new DomainError('Family sharing is paused.', 'CIRCLE_PAUSED', 403);
    return { family: state.family, isParent: false };
  }

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
    const readOnly = mode === 'read' || mode === 'download';
    const deletionRead = family.status === 'DELETION_SCHEDULED' && readOnly;
    if (family.status === 'DELETION_SCHEDULED' && !readOnly)
      throw new DomainError(
        'Family deletion is scheduled.',
        'FAMILY_DELETION_SCHEDULED',
        403,
      );
    if (
      (state.licenseBlocked || state.entitlement?.accessPhase === 'BLOCKED') &&
      mode !== 'download'
    )
      throw new DomainError(
        'The family license is blocked.',
        'LICENSE_BLOCKED',
        403,
      );
    if (family.status === 'PARTNER_LEFT' && readOnly) return family;
    if (
      (family.status !== 'ACTIVE' && !deletionRead) ||
      state.activeParentCount !== 2
    )
      throw new DomainError(
        'The family is not active for this operation.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
    const entitlement = state.entitlement;
    // Spec §6.5: an expired subscription still allows reading/downloading data.
    if (
      mode === 'download' &&
      entitlement &&
      !entitlement.deletedAt &&
      ['TRIAL', 'PAID', 'EXPIRED', 'BLOCKED'].includes(entitlement.accessPhase)
    )
      return family;
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
