import type { Asset } from '../../models/asset.model';
import type { Pregnancy } from '../../models/pregnancy.model';
import type { Child } from '../../models/child.model';
import type { ChildProfileStatsDto } from '../../dto/child/child-profile.dto';
export const CHILD_PROFILE_REPOSITORY = Symbol('CHILD_PROFILE_REPOSITORY');
export interface ChildProfileViewer {
  child: Child;
  parent: boolean;
  circle: null | {
    active: boolean;
    granted: boolean;
    enabled: boolean;
    familyActive: boolean;
    licensed: boolean;
  };
}
export interface IChildProfileRepository {
  findChild(id: string): Promise<Child | null>;
  findPregnancy(id: string): Promise<Pregnancy | null>;
  findAsset(id: string): Promise<Asset | null>;
  listActiveChildren(familyId: string): Promise<Child[]>;
  viewer(id: string, userId: string): Promise<ChildProfileViewer | null>;
  reorder(
    familyId: string,
    childIds: string[],
    expected: Child[],
  ): Promise<Child[]>;
  transition(
    current: Child,
    action: 'archive' | 'restore' | 'delete',
    actorUserId: string,
    now: Date,
    purgeAfter: Date,
  ): Promise<Child>;
  setAsset(
    subject: 'child' | 'pregnancy',
    current: Child | Pregnancy,
    field: 'avatarAssetId' | 'coverAssetId',
    asset: Asset | null,
  ): Promise<
    Child | { id: string; familyId: string; coverAssetId: string | null }
  >;
  stats(
    child: Child,
    userId: string,
    circle: boolean,
  ): Promise<ChildProfileStatsDto>;
}
