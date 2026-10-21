import type { ProfileImageClientVariantAttributes } from '../../models/profile-image-client-variant.model';
import type { UpdateUserDto } from '../../dto/user/update-user.dto';
import type { AssetVariant } from '../../models/asset-variant.model';
import type { UserAsset } from '../../models/user-asset.model';
export const PROFILE_IMAGE_REPOSITORY = Symbol('PROFILE_IMAGE_REPOSITORY');
export type ProfileImageVariant = ProfileImageClientVariantAttributes;
export interface IProfileImageRepository {
  variants(userId: string, assetId: string): Promise<ProfileImageVariant[]>;
  fail(userId: string, assetId: string): Promise<void>;
  reserve(input: {
    id: string;
    ownerUserId: string;
    mime: string;
    declaredSize: bigint;
    sha256: Uint8Array;
    storageBucket: string;
    storageKey: string;
    purgeAfter: Date;
    variants?: ProfileImageVariant[];
  }): Promise<UserAsset>;
  ownAsset(userId: string, assetId: string): Promise<UserAsset | null>;
  avatar(userId: string): Promise<UserAsset | null>;
  startProcessing(userId: string, assetId: string): Promise<void>;
  ready(
    userId: string,
    assetId: string,
    size: bigint,
    verifiedVariants?: { code: string; size: bigint }[],
  ): Promise<void>;
  attach(
    userId: string,
    assetId: string | null,
    fields?: Pick<UpdateUserDto, 'displayName' | 'locale' | 'timezone'>,
  ): Promise<void>;
  childLocations(
    userId: string,
    familyId: string,
    childId: string,
  ): Promise<{
    avatar: AssetVariant | null;
    cover: AssetVariant | null;
  } | null>;
  /** FAM-07: processed variant of the family cover (READY, purpose COVER). */
  familyCoverLocation(familyId: string): Promise<AssetVariant | null>;
  /** FAM-07: the asset can become this family's cover. */
  isUsableFamilyCover(familyId: string, assetId: string): Promise<boolean>;
}
