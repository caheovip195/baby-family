import type { UpdateUserDto } from '../../dto/user/update-user.dto';
import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { AvatarUploadIntentDto } from '../../dto/user/avatar-upload.dto';
export const PROFILE_IMAGE_SERVICE = Symbol('PROFILE_IMAGE_SERVICE');
export interface AvatarUrls {
  avatarUrl: string | null;
  avatarUrlExpiresAt: Date | null;
}
export interface IProfileImageService {
  createIntent(
    actor: AuthPrincipal,
    key: string,
    input: AvatarUploadIntentDto,
  ): Promise<{
    assetId: string;
    status: string;
    upload?: {
      mode: 'single';
      method: 'PUT';
      url: string;
      headers: Record<string, string>;
      expiresAt: Date;
    };
  }>;
  complete(
    actor: AuthPrincipal,
    assetId: string,
  ): Promise<{ assetId: string; status: string }>;
  attach(
    actor: AuthPrincipal,
    assetId: string | null,
    fields?: Pick<UpdateUserDto, 'displayName' | 'locale' | 'timezone'>,
  ): Promise<void>;
  userAvatar(userId: string): Promise<AvatarUrls>;
  /** FAM-07: signed family cover URL (Parent/Circle of the family). */
  familyCover(
    familyId: string,
  ): Promise<{ coverUrl: string | null; coverUrlExpiresAt: Date | null }>;
  isUsableFamilyCover(familyId: string, assetId: string): Promise<boolean>;
  childImages(
    actor: AuthPrincipal,
    familyId: string,
    childId: string,
  ): Promise<
    AvatarUrls & { coverUrl: string | null; coverUrlExpiresAt: Date | null }
  >;
}
