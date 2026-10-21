import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { MeFamilyResponse } from '../../dto/me-families/me-families.dto';

export const ME_FAMILIES_SERVICE = Symbol('ME_FAMILIES_SERVICE');
export interface IMeFamiliesService {
  list(actor: AuthPrincipal): Promise<{ items: MeFamilyResponse[] }>;
  setDefault(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<{ familyId: string }>;
}
