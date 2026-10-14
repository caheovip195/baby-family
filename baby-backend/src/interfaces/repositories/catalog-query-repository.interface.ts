import type { BillingCatalog } from '../../models/billing-catalog.model';
import type { FamilyBillingState } from '../../models/family-billing-state.model';

export const CATALOG_QUERY_REPOSITORY = Symbol('CATALOG_QUERY_REPOSITORY');

export interface ICatalogQueryRepository {
  findCatalog(now: Date): Promise<BillingCatalog>;
  findFamilyBillingState(
    familyId: string,
    userId: string,
    now: Date,
  ): Promise<FamilyBillingState | null>;
}
