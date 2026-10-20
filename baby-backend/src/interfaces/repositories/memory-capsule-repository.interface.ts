import type { DatabaseJsonValue } from '../../common/database.types';
import type { FamilyEntitlement } from '../../models/family-entitlement.model';
import type { Memory } from '../../models/memory.model';
import type { MemoryLetter } from '../../models/memory-letter.model';
import type { JobContext } from '../services/job-runner-service.interface';

export const MEMORY_CAPSULE_REPOSITORY = Symbol('MEMORY_CAPSULE_REPOSITORY');
export interface CapsuleAccess {
  familyId: string;
  role: 'PARENT' | 'CIRCLE' | 'INACTIVE';
  granted: boolean;
  familyActive: boolean;
  licenseBlocked: boolean;
  entitlement: FamilyEntitlement | null;
  features: DatabaseJsonValue;
}
export interface CapsuleView {
  memory: Memory;
  letter: MemoryLetter;
  assetIds: string[];
}
export interface IMemoryCapsuleRepository {
  findAccess(childId: string, userId: string): Promise<CapsuleAccess | null>;
  list(
    childId: string,
    familyId: string,
    userId: string,
    circle: boolean,
  ): Promise<CapsuleView[]>;
  releaseDue(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<number>;
}
