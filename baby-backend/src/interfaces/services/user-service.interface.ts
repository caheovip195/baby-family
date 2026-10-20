import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  RecordConsentsDto,
  RegisterDeviceDto,
  SetOnboardingRoleDto,
} from '../../dto/user/account-commands.dto';
import type { MeResponseDto } from '../../dto/user/me-response.dto';
import type { UpdateUserDto } from '../../dto/user/update-user.dto';
import type { UserResponseDto } from '../../dto/user/user-response.dto';

export const USER_SERVICE = Symbol('USER_SERVICE');
export interface IUserService {
  getMe(actor: AuthPrincipal): Promise<MeResponseDto>;
  updateMe(
    actor: AuthPrincipal,
    input: UpdateUserDto,
  ): Promise<UserResponseDto>;
  setOnboardingRole(
    actor: AuthPrincipal,
    input: SetOnboardingRoleDto,
  ): Promise<MeResponseDto>;
  registerDevice(actor: AuthPrincipal, input: RegisterDeviceDto): Promise<void>;
  recordConsents(
    actor: AuthPrincipal,
    input: RecordConsentsDto,
    ip: string | null,
  ): Promise<void>;
}
