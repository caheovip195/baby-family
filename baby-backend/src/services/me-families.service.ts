import { Inject, Injectable, Optional } from '@nestjs/common';
import { NO_PROFILE_IMAGES } from './no-profile-images';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError } from '../common/errors/domain.error';
import { ME_FAMILIES_REPOSITORY } from '../interfaces/repositories/me-families-repository.interface';
import type { IMeFamiliesRepository } from '../interfaces/repositories/me-families-repository.interface';
import type { IMeFamiliesService } from '../interfaces/services/me-families-service.interface';
import { PROFILE_IMAGE_SERVICE } from '../interfaces/services/profile-image-service.interface';
import type { IProfileImageService } from '../interfaces/services/profile-image-service.interface';

@Injectable()
export class MeFamiliesService implements IMeFamiliesService {
  constructor(
    @Inject(ME_FAMILIES_REPOSITORY)
    private readonly repository: IMeFamiliesRepository,
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly images: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}

  async list(actor: AuthPrincipal) {
    const state = await this.repository.find(actor.userId);
    if (!state) throw new NotFoundError('User was not found.');
    const defaultFamilyId = state.items.some(
      (item) => item.familyId === state.defaultFamilyId,
    )
      ? state.defaultFamilyId
      : (state.items[0]?.familyId ?? null);
    const items = await Promise.all(
      state.items.map(async (item) => ({
        familyId: item.familyId,
        name: item.name,
        role: item.role,
        status: {
          family: item.familyStatus,
          membership: item.membershipStatus,
        },
        coverUrl: item.canReadCover
          ? (await this.images.familyCover(item.familyId)).coverUrl
          : null,
        isDefault: item.familyId === defaultFamilyId,
      })),
    );
    return { items };
  }

  async setDefault(actor: AuthPrincipal, familyId: string) {
    if (!(await this.repository.setDefault(actor.userId, familyId)))
      throw new NotFoundError('Family membership was not found.');
    // Context selection never changes a Parent or Circle membership (BR-057).
    return { familyId };
  }
}
