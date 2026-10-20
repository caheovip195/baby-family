import { Inject, Injectable, Optional } from '@nestjs/common';
import { NO_PROFILE_IMAGES } from './no-profile-images';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { PROFILE_IMAGE_SERVICE } from '../interfaces/services/profile-image-service.interface';
import type { IProfileImageService } from '../interfaces/services/profile-image-service.interface';

/** FAM-07: languages the server can write family content in (vi, en). */
const FAMILY_CONTENT_LOCALES: readonly string[] = ['vi', 'en'];
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
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly images: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}

  async getById(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyResponseDto> {
    return this.withCover(
      FamilyResponseDto.fromModel(
        await this.access.requireParent(actor, familyId, 'read'),
      ),
    );
  }

  private async withCover(dto: FamilyResponseDto): Promise<FamilyResponseDto> {
    const cover = await this.images.familyCover(dto.id);
    dto.coverUrl = cover.coverUrl;
    dto.coverUrlExpiresAt = cover.coverUrlExpiresAt?.toISOString() ?? null;
    return dto;
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
    if (input.contentLocale !== undefined) {
      if (!FAMILY_CONTENT_LOCALES.includes(input.contentLocale))
        throw new ValidationError('Content language must be vi or en.');
      data.contentLocale = input.contentLocale;
    }
    if (input.coverAssetId !== undefined) {
      if (
        input.coverAssetId !== null &&
        !(await this.images.isUsableFamilyCover(familyId, input.coverAssetId))
      )
        throw new DomainError(
          'The cover must be a processed COVER image of this family.',
          'FAMILY_COVER_INVALID',
          422,
        );
      data.coverAssetId = input.coverAssetId;
    }
    if (!Object.keys(data).length)
      throw new ValidationError('Provide at least one supported family field.');
    const family = await this.repository.update(
      { privileged: true },
      { id: familyId },
      data,
    );
    if (!family) throw new NotFoundError('Family was not found.');
    return this.withCover(FamilyResponseDto.fromModel(family));
  }
}
