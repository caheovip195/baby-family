import type { Memory } from '../../models/memory.model';
export const MEMORY_REVIEW_REPOSITORY = Symbol('MEMORY_REVIEW_REPOSITORY');
export interface IMemoryReviewRepository {
  list(familyId: string): Promise<Memory[]>;
  find(id: string): Promise<Memory | null>;
  review(input: {
    familyId: string;
    memoryId: string;
    actorUserId: string;
    decision: 'APPROVE' | 'REJECT';
    childIds?: string[];
    reason?: string;
  }): Promise<Memory>;
}
