import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import type { UpdateUserDto } from '../dto/user/update-user.dto';
import { UserResponseDto } from '../dto/user/user-response.dto';
import { USER_REPOSITORY } from '../interfaces/repositories/user-repository.interface';
import type {
  IUserRepository,
  UpdateUserInput,
} from '../interfaces/repositories/user-repository.interface';
import type { IUserService } from '../interfaces/services/user-service.interface';

@Injectable()
export class UserService implements IUserService {
  constructor(
    @Inject(USER_REPOSITORY) private readonly repository: IUserRepository,
  ) {}

  async getMe(actor: AuthPrincipal): Promise<UserResponseDto> {
    const user = await this.repository.findByKey(
      { privileged: true },
      { id: actor.userId },
    );
    if (!user) throw new NotFoundError('User was not found.');
    return UserResponseDto.fromModel(user);
  }

  async updateMe(
    actor: AuthPrincipal,
    input: UpdateUserDto,
  ): Promise<UserResponseDto> {
    const data: UpdateUserInput = {};
    if (input.displayName !== undefined) {
      if (
        typeof input.displayName !== 'string' ||
        !input.displayName.trim() ||
        input.displayName.trim().length > 80
      )
        throw new ValidationError(
          'Display name must contain between 1 and 80 characters.',
        );
      data.displayName = input.displayName.trim();
    }
    if (input.locale !== undefined) {
      if (!['vi', 'en'].includes(input.locale))
        throw new ValidationError('Locale must be vi or en.');
      data.locale = input.locale;
    }
    if (input.timezone !== undefined) {
      this.assertTimezone(input.timezone);
      data.timezone = input.timezone;
    }
    if (!Object.keys(data).length)
      throw new ValidationError(
        'Provide at least one supported profile field.',
      );
    const user = await this.repository.update(
      { privileged: true },
      { id: actor.userId },
      data,
    );
    if (!user) throw new NotFoundError('User was not found.');
    return UserResponseDto.fromModel(user);
  }

  private assertTimezone(value: string): void {
    try {
      if (typeof value !== 'string' || value.length > 64 || /^[+-]/.test(value))
        throw new Error();
      new Intl.DateTimeFormat('en', { timeZone: value });
    } catch {
      throw new ValidationError('Timezone must be a valid IANA timezone.');
    }
  }
}
