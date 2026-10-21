import type { JobContext } from './job-runner-service.interface';
export const TRANSACTIONAL_MAIL_SERVICE = Symbol('TRANSACTIONAL_MAIL_SERVICE');
export interface ITransactionalMailService {
  deliver(
    eventId: string,
    context: JobContext,
  ): Promise<Record<string, number>>;
  reconcile(
    now: Date,
    context: JobContext,
    familyId?: string,
    userId?: string,
  ): Promise<Record<string, number>>;
}
