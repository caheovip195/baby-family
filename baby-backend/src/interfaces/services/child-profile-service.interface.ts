import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  ChildProfileResponseDto,
  ChildProfileStatsDto,
} from '../../dto/child/child-profile.dto';
export const CHILD_PROFILE_SERVICE = Symbol('CHILD_PROFILE_SERVICE');
export interface IChildProfileService {
  reorder(
    actor: AuthPrincipal,
    familyId: string,
    childIds: string[],
  ): Promise<ChildProfileResponseDto[]>;
  transition(
    actor: AuthPrincipal,
    id: string,
    action: 'archive' | 'restore' | 'delete',
    confirmName?: string,
  ): Promise<ChildProfileResponseDto>;
  childAsset(
    actor: AuthPrincipal,
    id: string,
    field: 'avatarAssetId' | 'coverAssetId',
    assetId: string | null,
  ): Promise<ChildProfileResponseDto>;
  pregnancyCover(
    actor: AuthPrincipal,
    id: string,
    assetId: string | null,
  ): Promise<{ id: string; familyId: string; coverAssetId: string | null }>;
  stats(actor: AuthPrincipal, id: string): Promise<ChildProfileStatsDto>;
}
