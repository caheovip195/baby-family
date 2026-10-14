import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { UpdateFamilyDto } from '../../dto/family/update-family.dto';
import type { FamilyResponseDto } from '../../dto/family/family-response.dto';

export const FAMILY_SERVICE = Symbol('FAMILY_SERVICE');
export interface IFamilyService {
  getById(actor: AuthPrincipal, familyId: string): Promise<FamilyResponseDto>;
  update(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateFamilyDto,
  ): Promise<FamilyResponseDto>;
}
