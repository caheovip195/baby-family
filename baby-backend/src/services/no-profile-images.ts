import { ServiceUnavailableError } from '../common/errors/domain.error';
import type { IProfileImageService } from '../interfaces/services/profile-image-service.interface';

const unavailable = () =>
  Promise.reject(
    new ServiceUnavailableError('Profile images are not configured.'),
  );

/**
 * Null object for modules that do not bind PROFILE_IMAGE_SERVICE (focused test
 * modules written before AUTH-04): no image URLs, uploads unavailable. The
 * application and worker composition roots always bind the real service.
 */
export const NO_PROFILE_IMAGES: IProfileImageService = {
  createIntent: unavailable,
  complete: unavailable,
  attach: unavailable,
  userAvatar: () =>
    Promise.resolve({ avatarUrl: null, avatarUrlExpiresAt: null }),
  familyCover: () =>
    Promise.resolve({ coverUrl: null, coverUrlExpiresAt: null }),
  isUsableFamilyCover: () => Promise.resolve(false),
  childImages: () =>
    Promise.resolve({
      avatarUrl: null,
      avatarUrlExpiresAt: null,
      coverUrl: null,
      coverUrlExpiresAt: null,
    }),
};
