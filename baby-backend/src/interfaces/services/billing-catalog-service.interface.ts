import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { BillingCatalogResponseDto } from '../../dto/billing/billing-catalog-response.dto';

export const BILLING_CATALOG_SERVICE = Symbol('BILLING_CATALOG_SERVICE');
export interface IBillingCatalogService {
  list(actor: AuthPrincipal): Promise<BillingCatalogResponseDto>;
}
