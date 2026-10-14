import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import type { UpdateFamilyDto } from '../dto/family/update-family.dto';
import { FamilyResponseDto } from '../dto/family/family-response.dto';
import { FAMILY_REPOSITORY } from '../interfaces/repositories/family-repository.interface';
import type {
  IFamilyRepository,
  UpdateFamilyInput,
} from '../interfaces/repositories/family-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IFamilyService } from '../interfaces/services/family-service.interface';

@Injectable()
export class FamilyService implements IFamilyService {
  constructor(
    @Inject(FAMILY_REPOSITORY) private readonly repository: IFamilyRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async getById(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyResponseDto> {
    return FamilyResponseDto.fromModel(
      await this.access.requireParent(actor, familyId, 'metadata'),
    );
  }

  async update(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateFamilyDto,
  ): Promise<FamilyResponseDto> {
    await this.access.requireParent(actor, familyId, 'family-profile-update');
    const data: UpdateFamilyInput = {};
    if (input.name !== undefined) {
      if (
        typeof input.name !== 'string' ||
        !input.name.trim() ||
        input.name.trim().length > 80
      )
        throw new ValidationError(
          'Family name must contain between 1 and 80 characters.',
        );
      data.name = input.name.trim();
    }
    if (input.timezone !== undefined) {
      try {
        if (
          typeof input.timezone !== 'string' ||
          input.timezone.length > 64 ||
          /^[+-]/.test(input.timezone)
        )
          throw new Error();
        new Intl.DateTimeFormat('en', { timeZone: input.timezone });
      } catch {
        throw new ValidationError('Timezone must be a valid IANA timezone.');
      }
      data.timezone = input.timezone;
    }
    if (!Object.keys(data).length)
      throw new ValidationError('Provide at least one supported family field.');
    const family = await this.repository.update(
      { privileged: true },
      { id: familyId },
      data,
    );
    if (!family) throw new NotFoundError('Family was not found.');
    return FamilyResponseDto.fromModel(family);
  }
}
