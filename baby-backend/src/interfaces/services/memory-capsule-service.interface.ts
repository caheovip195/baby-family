import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { JobContext } from './job-runner-service.interface';

export const MEMORY_CAPSULE_SERVICE = Symbol('MEMORY_CAPSULE_SERVICE');
export interface CapsuleResponse {
  id: string;
  kind: 'LETTER';
  authorUserId: string;
  authorRole: string;
  sealed: boolean;
  unlockAt: string | null;
  title: string | null;
  body?: string | null;
  assetIds?: string[];
}
export interface IMemoryCapsuleService {
  list(
    actor: AuthPrincipal,
    childId: string,
  ): Promise<{ data: CapsuleResponse[] }>;
  release(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>>;
}
