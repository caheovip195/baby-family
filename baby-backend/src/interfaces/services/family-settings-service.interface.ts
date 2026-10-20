import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  FamilySettingsResponseDto,
  UpdateFamilySettingsDto,
} from '../../dto/family/family-settings.dto';

export const FAMILY_SETTINGS_SERVICE = Symbol('FAMILY_SETTINGS_SERVICE');
export interface IFamilySettingsService {
  get(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilySettingsResponseDto>;
  patch(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateFamilySettingsDto,
  ): Promise<FamilySettingsResponseDto>;
}
