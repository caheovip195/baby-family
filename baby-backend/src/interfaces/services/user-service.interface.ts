import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { UpdateUserDto } from '../../dto/user/update-user.dto';
import type { UserResponseDto } from '../../dto/user/user-response.dto';

export const USER_SERVICE = Symbol('USER_SERVICE');
export interface IUserService {
  getMe(actor: AuthPrincipal): Promise<UserResponseDto>;
  updateMe(
    actor: AuthPrincipal,
    input: UpdateUserDto,
  ): Promise<UserResponseDto>;
}
