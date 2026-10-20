import type {
  CircleSubject,
  FamilyCircleBootstrap,
  FamilyCircleMember,
  FamilyCircleOverview,
} from '../../models/family-circle-state.model';

export interface UserAvatarProjection {
  avatarUrl: string | null;
  avatarUrlExpiresAt: string | null;
}

export interface SubjectImagesProjection extends UserAvatarProjection {
  coverUrl: string | null;
  coverUrlExpiresAt: string | null;
}

/** Additive HTTP projections; signed URLs are never persisted on models. */
export type CircleMemberProfileResponse = FamilyCircleMember &
  UserAvatarProjection;
export type CircleSubjectProfileResponse = CircleSubject &
  SubjectImagesProjection;
export type CircleBootstrapProfileResponse = Omit<
  FamilyCircleBootstrap,
  'children'
> & {
  children: CircleSubjectProfileResponse[];
};
export type CircleOverviewProfileResponse = Omit<
  FamilyCircleOverview,
  'parents' | 'children'
> & {
  parents: (FamilyCircleOverview['parents'][number] & UserAvatarProjection)[];
  children: CircleSubjectProfileResponse[];
};
