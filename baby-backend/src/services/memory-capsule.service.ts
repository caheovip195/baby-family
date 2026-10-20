import { Inject, Injectable } from '@nestjs/common';
import { MEMORY_LETTER_RELEASE_POLICY } from '../config/jobs';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { MEMORY_CAPSULE_REPOSITORY } from '../interfaces/repositories/memory-capsule-repository.interface';
import type { IMemoryCapsuleRepository } from '../interfaces/repositories/memory-capsule-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type {
  IMemoryCapsuleService,
  CapsuleResponse,
} from '../interfaces/services/memory-capsule-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';

@Injectable()
export class MemoryCapsuleService implements IMemoryCapsuleService {
  constructor(
    @Inject(MEMORY_CAPSULE_REPOSITORY)
    private readonly repository: IMemoryCapsuleRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async list(
    actor: AuthPrincipal,
    childId: string,
  ): Promise<{ data: CapsuleResponse[] }> {
    const access = await this.repository.findAccess(childId, actor.userId);
    if (!access) throw new NotFoundError('Child was not found.');
    if (access.role === 'INACTIVE')
      throw new DomainError(
        'Membership is inactive.',
        'FAMILY_MEMBERSHIP_INACTIVE',
        403,
      );
    if (this.access.requireContentAccess)
      await this.access.requireContentAccess(actor, access.familyId, 'read');
    if (access.role === 'PARENT') {
      if (!this.access.requireContentAccess)
        await this.access.requireParent(actor, access.familyId, 'read');
    } else {
      if (!access.granted) throw new NotFoundError('Child was not found.');
      if (!access.familyActive)
        throw new DomainError(
          'Family is not active.',
          'FAMILY_NOT_ACTIVE',
          403,
        );
      if (access.licenseBlocked)
        throw new DomainError('License is blocked.', 'LICENSE_BLOCKED', 403);
      const entitlement = access.entitlement;
      const now = new Date();
      if (
        !entitlement ||
        entitlement.deletedAt ||
        !['TRIAL', 'PAID'].includes(entitlement.accessPhase) ||
        !entitlement.validUntil ||
        entitlement.validUntil <= now ||
        (entitlement.accessPhase === 'TRIAL' &&
          (!entitlement.trialEndsAt || entitlement.trialEndsAt <= now))
      )
        throw new DomainError(
          'An active subscription is required.',
          'SUBSCRIPTION_REQUIRED',
          402,
        );
      const features = access.features;
      if (
        !features ||
        typeof features !== 'object' ||
        Array.isArray(features) ||
        features['circle.enabled'] !== true
      )
        throw new DomainError(
          'Circle sharing is unavailable.',
          'CIRCLE_NOT_ENABLED',
          403,
        );
    }
    const rows = await this.repository.list(
      childId,
      access.familyId,
      actor.userId,
      access.role === 'CIRCLE',
    );
    return {
      data: rows.map(({ memory, assetIds }) => {
        const sealed = memory.unlockAt !== null;
        const hidden = sealed && memory.authorUserId !== actor.userId;
        return {
          id: memory.id,
          kind: 'LETTER',
          authorUserId: memory.authorUserId,
          authorRole: memory.authorRole,
          sealed,
          unlockAt: memory.unlockAt?.toISOString() ?? null,
          title: memory.title,
          ...(hidden ? {} : { body: memory.body, assetIds }),
        };
      }),
    };
  }
  async release(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>> {
    let released = 0;
    for (;;) {
      context.signal.throwIfAborted();
      const count = await this.repository.releaseDue(now, context, familyId);
      released += count;
      if (count < MEMORY_LETTER_RELEASE_POLICY.batchSize) break;
    }
    return { released };
  }
}
