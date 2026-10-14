import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { UpdateUserSettingDto } from '../../dto/user-setting/update-user-setting.dto';
import type { UserSettingResponseDto } from '../../dto/user-setting/user-setting-response.dto';

export const USER_SETTING_SERVICE = Symbol('USER_SETTING_SERVICE');
export interface IUserSettingService {
  getMe(actor: AuthPrincipal): Promise<UserSettingResponseDto>;
  updateMe(
    actor: AuthPrincipal,
    input: UpdateUserSettingDto,
  ): Promise<UserSettingResponseDto>;
}
