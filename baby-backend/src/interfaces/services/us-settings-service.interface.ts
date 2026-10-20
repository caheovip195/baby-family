import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  UpdateUsSettingsDto,
  UsSettingsResponseDto,
} from '../../dto/us-settings/us-settings.dto';

export const US_SETTINGS_SERVICE = Symbol('US_SETTINGS_SERVICE');
export interface IUsSettingsService {
  getMe(actor: AuthPrincipal): Promise<UsSettingsResponseDto>;
  updateMe(
    actor: AuthPrincipal,
    input: UpdateUsSettingsDto,
  ): Promise<UsSettingsResponseDto>;
}
