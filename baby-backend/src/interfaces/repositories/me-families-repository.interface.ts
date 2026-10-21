import type { MeFamiliesState } from '../../models/me-family.model';

export const ME_FAMILIES_REPOSITORY = Symbol('ME_FAMILIES_REPOSITORY');
export interface IMeFamiliesRepository {
  find(userId: string): Promise<MeFamiliesState | null>;
  /** Revalidates membership and user lifecycle atomically with the write. */
  setDefault(userId: string, familyId: string): Promise<boolean>;
}
