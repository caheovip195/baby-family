import type { FamilyErasure } from '../../models/family-erasure.model';
import type { JobLease } from '../../models/job-lease.model';
export const FAMILY_ERASURE_REPOSITORY = Symbol('FAMILY_ERASURE_REPOSITORY');
export interface IFamilyErasureRepository {
  latest(familyId: string): Promise<FamilyErasure | null>;
  transition(
    familyId: string,
    userId: string,
    action: 'request' | 'confirm' | 'cancel',
    now: Date,
    reason?: string,
  ): Promise<FamilyErasure>;
  due(now: Date, limit: number, familyId?: string): Promise<FamilyErasure[]>;
  complete(id: string, now: Date, lease: JobLease): Promise<boolean>;
}
