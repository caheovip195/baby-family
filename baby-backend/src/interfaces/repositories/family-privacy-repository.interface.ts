import type { FamilyPrivacySnapshot } from '../../models/family-privacy.model';
export const FAMILY_PRIVACY_REPOSITORY = Symbol('FAMILY_PRIVACY_REPOSITORY');
export interface IFamilyPrivacyRepository {
  findOverview(
    familyId: string,
    userId: string,
  ): Promise<FamilyPrivacySnapshot | null>;
}
