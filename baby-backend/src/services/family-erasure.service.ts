import { Inject, Injectable, Optional } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { FAMILY_ERASURE_POLICY } from '../config/family-erasure-policy';
import type {
  ConfirmFamilyErasureDto,
  RequestFamilyErasureDto,
} from '../dto/family/family-erasure.dto';
import {
  FAMILY_ERASURE_REPOSITORY,
  type IFamilyErasureRepository,
} from '../interfaces/repositories/family-erasure-repository.interface';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type { IFamilyErasureService } from '../interfaces/services/family-erasure-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import {
  REAUTH_SERVICE,
  type IReauthService,
} from '../interfaces/services/reauth-service.interface';
import { NO_FAMILY_ERASURE } from '../models/family-erasure.model';
@Injectable()
export class FamilyErasureService implements IFamilyErasureService {
  constructor(
    @Inject(FAMILY_ERASURE_REPOSITORY)
    private readonly repository: IFamilyErasureRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Optional()
    @Inject(REAUTH_SERVICE)
    private readonly reauth?: IReauthService,
  ) {}
  async get(actor: AuthPrincipal, familyId: string) {
    await this.access.requireParent(actor, familyId, 'metadata');
    return (
      (await this.repository.latest(familyId))?.project() ?? NO_FAMILY_ERASURE
    );
  }
  async request(
    actor: AuthPrincipal,
    familyId: string,
    input: RequestFamilyErasureDto,
  ) {
    await this.access.requireParent(actor, familyId, 'metadata');
    await this.verifyReauth(actor, input.reauthToken);
    return (
      await this.repository.transition(
        familyId,
        actor.userId,
        'request',
        new Date(),
        input.reason,
      )
    ).project();
  }
  async confirm(
    actor: AuthPrincipal,
    familyId: string,
    input: ConfirmFamilyErasureDto,
  ) {
    await this.access.requireParent(actor, familyId, 'metadata');
    await this.verifyReauth(actor, input.reauthToken);
    return (
      await this.repository.transition(
        familyId,
        actor.userId,
        'confirm',
        new Date(),
      )
    ).project();
  }
  async cancel(actor: AuthPrincipal, familyId: string) {
    await this.access.requireParent(actor, familyId, 'metadata');
    return (
      await this.repository.transition(
        familyId,
        actor.userId,
        'cancel',
        new Date(),
      )
    ).project();
  }
  private verifyReauth(actor: AuthPrincipal, token: string) {
    if (!this.reauth)
      throw new DomainError(
        'Reauthentication is not configured.',
        'REAUTH_UNAVAILABLE',
        503,
      );
    return this.reauth.verifyToken(actor, token);
  }
  async executeDue(now: Date, context: JobContext, familyId?: string) {
    let completed = 0;
    for (const row of await this.repository.due(
      now,
      FAMILY_ERASURE_POLICY.batchSize,
      familyId,
    )) {
      context.signal.throwIfAborted();
      if (await this.repository.complete(row.id, now, context.lease))
        completed++;
    }
    return { completed };
  }
}
