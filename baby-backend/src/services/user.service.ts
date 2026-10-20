import {
  PROFILE_IMAGE_SERVICE,
  type IProfileImageService,
} from '../interfaces/services/profile-image-service.interface';
import { Optional, Inject, Injectable } from '@nestjs/common';
import { NO_PROFILE_IMAGES } from './no-profile-images';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  RecordConsentsDto,
  RegisterDeviceDto,
  SetOnboardingRoleDto,
} from '../dto/user/account-commands.dto';
import { MeResponseDto } from '../dto/user/me-response.dto';
import type { UpdateUserDto } from '../dto/user/update-user.dto';
import { UserResponseDto } from '../dto/user/user-response.dto';
import { ACCOUNT_REPOSITORY } from '../interfaces/repositories/account-repository.interface';
import type { IAccountRepository } from '../interfaces/repositories/account-repository.interface';
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
    @Inject(ACCOUNT_REPOSITORY) private readonly accounts: IAccountRepository,
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly profileImages: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}

  async getMe(actor: AuthPrincipal): Promise<MeResponseDto> {
    const overview = await this.accounts.findOverview(actor.userId);
    if (!overview) throw new NotFoundError('User was not found.');
    return Object.assign(
      MeResponseDto.fromModel(overview),
      await this.profileImages.userAvatar(actor.userId),
    );
  }

  async setOnboardingRole(
    actor: AuthPrincipal,
    input: SetOnboardingRoleDto,
  ): Promise<MeResponseDto> {
    const result = await this.accounts.setOnboardingRole(
      actor.userId,
      input.role,
    );
    if (result.kind === 'NOT_FOUND')
      throw new NotFoundError('User was not found.');
    if (result.kind === 'LOCKED')
      throw new DomainError(
        'The role cannot change while you belong to a family.',
        'ONBOARDING_ROLE_LOCKED',
        409,
      );
    return this.getMe(actor);
  }

  async registerDevice(
    actor: AuthPrincipal,
    input: RegisterDeviceDto,
  ): Promise<void> {
    await this.accounts.registerDevice(
      actor.userId,
      actor.sessionId,
      {
        platform: input.platform,
        pushToken: input.pushToken ?? null,
        pushEnabled: input.pushEnabled ?? false,
        appVersion: input.appVersion ?? null,
        osVersion: input.osVersion ?? null,
        deviceModel: input.deviceModel ?? null,
        locale: input.locale ?? null,
        timezone: input.timezone ?? null,
      },
      new Date(),
    );
  }

  async recordConsents(
    actor: AuthPrincipal,
    input: RecordConsentsDto,
    ip: string | null,
  ): Promise<void> {
    const documents = new Set(input.consents.map((item) => item.document));
    if (documents.size !== input.consents.length)
      throw new ValidationError('Each document may appear only once.');
    await this.accounts.recordConsents(actor.userId, input.consents, {
      platform: input.platform ?? null,
      ip,
    });
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
    if (!Object.keys(data).length && input.avatarAssetId === undefined)
      throw new ValidationError(
        'Provide at least one supported profile field.',
      );
    if (input.avatarAssetId !== undefined) {
      await this.profileImages.attach(actor, input.avatarAssetId, data);
      const overview = await this.accounts.findOverview(actor.userId);
      if (!overview) throw new NotFoundError('User was not found.');
      return Object.assign(
        UserResponseDto.fromModel(overview.user),
        await this.profileImages.userAvatar(actor.userId),
      );
    }
    const user = await this.repository.update(
      { privileged: true },
      { id: actor.userId },
      data,
    );
    if (!user) throw new NotFoundError('User was not found.');
    return Object.assign(
      UserResponseDto.fromModel(user),
      await this.profileImages.userAvatar(actor.userId),
    );
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
