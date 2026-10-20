import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  FamilyErasure,
  NO_FAMILY_ERASURE,
} from '../../models/family-erasure.model';
import type { FamilyPrivacyMember } from '../../models/family-privacy.model';
export const FAMILY_PRIVACY_SERVICE = Symbol('FAMILY_PRIVACY_SERVICE');
export interface FamilyPrivacyOverview {
  defaults: {
    defaultVisibility: string | null;
    requireCircleReview: boolean;
    circleCanSeeTree: boolean;
  };
  circle: FamilyPrivacyMember[];
  pendingInvites: number;
  blockedCount: number;
  papaMamaPrivate: {
    sharedBetweenParents: string[];
    ownerOnlyUntilShared: string[];
    excludedFromFamilyExport: boolean;
    excludedFromCircle: boolean;
  };
  dataExport: {
    id: string;
    scope: string;
    status: string;
    createdAt: string;
    completedAt: string | null;
    expiresAt: string | null;
    errorCode: string | null;
  } | null;
  deletion: ReturnType<FamilyErasure['project']> | typeof NO_FAMILY_ERASURE;
}
export interface IFamilyPrivacyService {
  get(actor: AuthPrincipal, familyId: string): Promise<FamilyPrivacyOverview>;
}
