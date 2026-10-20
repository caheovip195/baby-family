import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError } from '../common/errors/domain.error';
import type { FamilyBillingResponseDto } from '../dto/billing/family-billing-response.dto';
import { CATALOG_QUERY_REPOSITORY } from '../interfaces/repositories/catalog-query-repository.interface';
import type { ICatalogQueryRepository } from '../interfaces/repositories/catalog-query-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IFamilyBillingService } from '../interfaces/services/family-billing-service.interface';
import { SUBSCRIPTION_REMINDER_SERVICE } from '../interfaces/services/subscription-reminder-service.interface';
import type { ISubscriptionReminderService } from '../interfaces/services/subscription-reminder-service.interface';
import { BillingProjection } from './billing-projection';

@Injectable()
export class FamilyBillingService implements IFamilyBillingService {
  constructor(
    @Inject(CATALOG_QUERY_REPOSITORY)
    private readonly repository: ICatalogQueryRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Optional()
    @Inject(SUBSCRIPTION_REMINDER_SERVICE)
    private readonly reminders?: ISubscriptionReminderService,
  ) {}

  async get(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyBillingResponseDto> {
    await this.access.requireParent(actor, familyId, 'metadata');
    const now = new Date();
    const state = await this.repository.findFamilyBillingState(
      familyId,
      actor.userId,
      now,
    );
    if (!state) throw new NotFoundError('Family was not found.');
    const result = BillingProjection.family(state, now);
    if (this.reminders)
      result.statusBanner = await this.reminders.status(familyId, now);
    return result;
  }
}
