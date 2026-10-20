import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import { NO_FAMILY_ERASURE } from '../models/family-erasure.model';
import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ServiceUnavailableError,
} from '../common/errors/domain.error';
import { FAMILY_SETTINGS_POLICY } from '../config/family-settings-policy';
import { FAMILY_PRIVACY_REPOSITORY } from '../interfaces/repositories/family-privacy-repository.interface';
import type { IFamilyPrivacyRepository } from '../interfaces/repositories/family-privacy-repository.interface';
import type {
  IFamilyPrivacyService,
  FamilyPrivacyOverview,
} from '../interfaces/services/family-privacy-service.interface';

@Injectable()
export class FamilyPrivacyService implements IFamilyPrivacyService {
  constructor(
    @Inject(FAMILY_PRIVACY_REPOSITORY)
    private readonly repository: IFamilyPrivacyRepository,
    @Optional()
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access?: IApplicationAccessService,
  ) {}
  async get(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyPrivacyOverview> {
    const snapshot = await this.repository.findOverview(familyId, actor.userId);
    if (!snapshot) throw new NotFoundError('Family was not found.');
    if (snapshot.role !== 'PARENT')
      throw new DomainError(
        'Only a current Parent may read the privacy overview.',
        'PARENT_REQUIRED',
        403,
      );
    if (!this.access)
      throw new ServiceUnavailableError('Family access policy is unavailable.');
    await this.access.requireParent(actor, familyId, 'read');
    const settings =
      snapshot.settings &&
      typeof snapshot.settings === 'object' &&
      !Array.isArray(snapshot.settings)
        ? snapshot.settings
        : {};
    const policy = FAMILY_SETTINGS_POLICY.fields;
    const visibility = settings.defaultVisibility;
    const job = snapshot.dataExport;
    const deletion = snapshot.deletion;
    return {
      defaults: {
        defaultVisibility:
          visibility === null ||
          policy.defaultVisibility.values.some((v) => v === visibility)
            ? (visibility as string | null)
            : policy.defaultVisibility.default,
        requireCircleReview:
          typeof settings.requireCircleReview === 'boolean'
            ? settings.requireCircleReview
            : policy.requireCircleReview.default,
        circleCanSeeTree:
          typeof settings.circleCanSeeTree === 'boolean'
            ? settings.circleCanSeeTree
            : policy.circleCanSeeTree.default,
      },
      circle: snapshot.circle,
      pendingInvites: snapshot.pendingInvites,
      blockedCount: snapshot.blockedCount,
      papaMamaPrivate: {
        sharedBetweenParents: [
          'APPRECIATIONS',
          'REQUESTS',
          'SHARED_JOURNAL',
          'SHARED_MOOD',
        ],
        ownerOnlyUntilShared: ['JOURNAL', 'MOOD', 'CONFLICT_DRAFTS'],
        excludedFromFamilyExport: true,
        excludedFromCircle: true,
      },
      dataExport: job
        ? {
            ...job,
            createdAt: job.createdAt.toISOString(),
            completedAt: job.completedAt?.toISOString() ?? null,
            expiresAt: job.expiresAt?.toISOString() ?? null,
          }
        : null,
      deletion: deletion?.project() ?? NO_FAMILY_ERASURE,
    };
  }
}
