import type { TransactionalMail } from '../../models/transactional-mail.model';
import type { JobLease } from '../../models/job-lease.model';
export const TRANSACTIONAL_MAIL_REPOSITORY = Symbol(
  'TRANSACTIONAL_MAIL_REPOSITORY',
);
export interface ITransactionalMailRepository {
  pending(limit: number, familyId?: string, userId?: string): Promise<string[]>;
  find(eventId: string, now: Date): Promise<TransactionalMail | null>;
  checkpoint(
    eventId: string,
    expected: string,
    state: string,
    lease: JobLease,
  ): Promise<boolean>;
  reconcile(
    now: Date,
    lease: JobLease,
    familyId?: string,
    userId?: string,
  ): Promise<number>;
}
