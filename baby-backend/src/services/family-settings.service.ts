import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import type { DatabaseJsonValue } from '../common/database.types';
import {
  DomainError,
  NotFoundError,
  ServiceUnavailableError,
  ValidationError,
} from '../common/errors/domain.error';
import { FAMILY_SETTINGS_POLICY } from '../config/family-settings-policy';
import type {
  FamilySettingsResponseDto,
  UpdateFamilySettingsDto,
} from '../dto/family/family-settings.dto';
import { FAMILY_SETTINGS_REPOSITORY } from '../interfaces/repositories/family-settings-repository.interface';
import type { IFamilySettingsRepository } from '../interfaces/repositories/family-settings-repository.interface';
import type { IFamilySettingsService } from '../interfaces/services/family-settings-service.interface';

@Injectable()
export class FamilySettingsService implements IFamilySettingsService {
  constructor(
    @Inject(FAMILY_SETTINGS_REPOSITORY)
    private readonly repository: IFamilySettingsRepository,
    @Optional()
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access?: IApplicationAccessService,
  ) {}

  async get(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilySettingsResponseDto> {
    const context = await this.requireMember(actor, familyId);
    if (!this.access)
      throw new ServiceUnavailableError('Family access policy is unavailable.');
    if (context.role === 'PARENT')
      await this.access.requireParent(actor, familyId, 'read');
    else if (this.access.requireContentAccess)
      await this.access.requireContentAccess(actor, familyId, 'read');
    else
      throw new ServiceUnavailableError('Circle access policy is unavailable.');
    const settings = this.project(context.family.settings);
    if (context.role === 'PARENT') return settings;
    return Object.fromEntries(
      FAMILY_SETTINGS_POLICY.circleReadableKeys.map((key) => [
        key,
        settings[key],
      ]),
    ) as unknown as FamilySettingsResponseDto;
  }

  async patch(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateFamilySettingsDto,
  ): Promise<FamilySettingsResponseDto> {
    const context = await this.requireMember(actor, familyId);
    if (context.role !== 'PARENT')
      throw new DomainError(
        'Only a Parent may change family settings.',
        'PARENT_REQUIRED',
        403,
      );
    if (context.family.status === 'DELETION_SCHEDULED')
      throw new DomainError(
        'Family deletion is scheduled.',
        'FAMILY_DELETION_SCHEDULED',
        403,
      );
    if (!this.access)
      throw new ServiceUnavailableError('Family access policy is unavailable.');
    await this.access.requireParent(actor, familyId, 'write');
    // ES2023 DTO class fields may materialize omitted optionals as own undefined
    // properties; only supplied JSON values participate in validation/merge/events.
    const patch = Object.fromEntries(
      Object.entries(input).filter(([, value]) => value !== undefined),
    ) as UpdateFamilySettingsDto;
    this.validate(patch);
    const family = await this.repository.merge(familyId, actor.userId, patch);
    if (!family) throw new NotFoundError('Family was not found.');
    return this.project(family.settings);
  }

  private async requireMember(actor: AuthPrincipal, familyId: string) {
    const context = await this.repository.findContext(familyId, actor.userId);
    if (!context) throw new NotFoundError('Family was not found.');
    if (context.role === 'INACTIVE')
      throw new DomainError(
        'Family membership is not active.',
        'FAMILY_MEMBERSHIP_INACTIVE',
        403,
      );
    if (
      context.role === 'CIRCLE' &&
      context.family.status === 'DELETION_SCHEDULED'
    )
      throw new DomainError('Family sharing is paused.', 'CIRCLE_PAUSED', 403);
    return context;
  }

  private validate(input: UpdateFamilySettingsDto): void {
    if (
      !input ||
      typeof input !== 'object' ||
      Array.isArray(input) ||
      Object.keys(input).length === 0
    )
      throw new ValidationError('At least one setting is required.');
    for (const [key, value] of Object.entries(input)) {
      if (!Object.hasOwn(FAMILY_SETTINGS_POLICY.fields, key))
        throw new ValidationError('Unknown family setting.');
      const field =
        FAMILY_SETTINGS_POLICY.fields[
          key as keyof typeof FAMILY_SETTINGS_POLICY.fields
        ];
      if (
        field.type === 'boolean'
          ? typeof value !== 'boolean'
          : value !== null && !field.values.some((allowed) => allowed === value)
      )
        throw new ValidationError('Invalid family setting value.');
    }
  }

  private project(value: DatabaseJsonValue): FamilySettingsResponseDto {
    const stored =
      value && typeof value === 'object' && !Array.isArray(value) ? value : {};
    return Object.fromEntries(
      Object.entries(FAMILY_SETTINGS_POLICY.fields).map(([key, field]) => {
        const value = stored[key];
        const valid =
          field.type === 'boolean'
            ? typeof value === 'boolean'
            : value === null ||
              field.values.some((allowed) => allowed === value);
        return [key, valid ? value : field.default];
      }),
    ) as unknown as FamilySettingsResponseDto;
  }
}
