import type {
  AccountDeletionPurgeObject,
  AccountDeletionRequest,
  AccountDeletionScope,
  AccountDeletionStep,
} from '../../models/account-deletion.model';
import type { JobLease } from '../../models/job-lease.model';

export const ACCOUNT_DELETION_REPOSITORY = Symbol(
  'ACCOUNT_DELETION_REPOSITORY',
);
export interface RequestAccountDeletionCommand {
  id: string;
  userId: string;
  sessionId: string;
  tokenVersion: number;
  familyChoice: 'NONE' | 'DELETE_FAMILY' | 'PARTNER_CONTINUES';
  sharedContentChoice: 'KEEP_ANONYMIZED' | 'DELETE';
  now: Date;
  executeAfter: Date;
  policyVersion: string;
}
export interface IAccountDeletionRepository {
  preview(userId: string): Promise<AccountDeletionScope>;
  request(
    command: RequestAccountDeletionCommand,
  ): Promise<AccountDeletionRequest>;
  cancel(
    userId: string,
    tokenVersion: number,
    now: Date,
  ): Promise<AccountDeletionRequest>;
  findDue(now: Date, limit: number): Promise<AccountDeletionRequest[]>;
  executeDatabaseStep(
    id: string,
    step: AccountDeletionStep,
    now: Date,
    lease: JobLease,
  ): Promise<AccountDeletionRequest>;
  completeStep(
    id: string,
    step: string,
    now: Date,
    lease: JobLease,
    details?: string,
  ): Promise<AccountDeletionRequest>;
  complete(
    id: string,
    now: Date,
    lease: JobLease,
  ): Promise<AccountDeletionRequest>;
  fail(id: string, code: string, lease: JobLease): Promise<void>;
  findPurgeObjects(
    id: string,
    limit: number,
  ): Promise<AccountDeletionPurgeObject[]>;
  markObjectsPurged(
    id: string,
    objects: AccountDeletionPurgeObject[],
    now: Date,
    lease: JobLease,
  ): Promise<void>;
}
