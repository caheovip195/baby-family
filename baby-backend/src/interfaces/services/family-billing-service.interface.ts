import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { FamilyBillingResponseDto } from '../../dto/billing/family-billing-response.dto';

export const FAMILY_BILLING_SERVICE = Symbol('FAMILY_BILLING_SERVICE');
export interface IFamilyBillingService {
  get(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyBillingResponseDto>;
}
