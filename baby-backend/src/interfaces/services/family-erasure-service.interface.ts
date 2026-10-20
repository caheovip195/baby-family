import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  RequestFamilyErasureDto,
  ConfirmFamilyErasureDto,
} from '../../dto/family/family-erasure.dto';
import type { FamilyErasure } from '../../models/family-erasure.model';
import type { NO_FAMILY_ERASURE } from '../../models/family-erasure.model';
import type { JobContext } from './job-runner-service.interface';
export const FAMILY_ERASURE_SERVICE = Symbol('FAMILY_ERASURE_SERVICE');
export type FamilyErasureResponse =
  ReturnType<FamilyErasure['project']> | typeof NO_FAMILY_ERASURE;
export interface IFamilyErasureService {
  get(actor: AuthPrincipal, familyId: string): Promise<FamilyErasureResponse>;
  request(
    actor: AuthPrincipal,
    familyId: string,
    input: RequestFamilyErasureDto,
  ): Promise<FamilyErasureResponse>;
  confirm(
    actor: AuthPrincipal,
    familyId: string,
    input: ConfirmFamilyErasureDto,
  ): Promise<FamilyErasureResponse>;
  cancel(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyErasureResponse>;
  executeDue(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>>;
}
