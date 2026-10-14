import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import type { BillingCatalogResponseDto } from '../dto/billing/billing-catalog-response.dto';
import { CATALOG_QUERY_REPOSITORY } from '../interfaces/repositories/catalog-query-repository.interface';
import type { ICatalogQueryRepository } from '../interfaces/repositories/catalog-query-repository.interface';
import type { IBillingCatalogService } from '../interfaces/services/billing-catalog-service.interface';
import { BillingProjection } from './billing-projection';

@Injectable()
export class BillingCatalogService implements IBillingCatalogService {
  constructor(
    @Inject(CATALOG_QUERY_REPOSITORY)
    private readonly repository: ICatalogQueryRepository,
  ) {}

  async list(_actor: AuthPrincipal): Promise<BillingCatalogResponseDto> {
    const catalog = await this.repository.findCatalog(new Date());
    return {
      plans: catalog.plans.map((plan) => BillingProjection.plan(plan)),
      trialPolicies: catalog.trialPolicies.map((policy) =>
        BillingProjection.trial(policy),
      ),
    };
  }
}
