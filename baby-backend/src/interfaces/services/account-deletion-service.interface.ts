import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { RequestAccountDeletionDto } from '../../dto/account/account-deletion.dto';
import type { JobContext } from './job-runner-service.interface';
export const ACCOUNT_DELETION_SERVICE = Symbol('ACCOUNT_DELETION_SERVICE');
export interface IAccountDeletionService {
  preview(actor: AuthPrincipal): Promise<unknown>;
  request(
    actor: AuthPrincipal,
    input: RequestAccountDeletionDto,
  ): Promise<unknown>;
  cancel(reauthToken: string): Promise<unknown>;
  executeDue(now: Date, context: JobContext): Promise<Record<string, number>>;
}
