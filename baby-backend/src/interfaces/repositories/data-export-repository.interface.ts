import type {
  DataExport,
  DataExportSnapshot,
} from '../../models/data-export.model';
import type { JobLease } from '../../models/job-lease.model';

export const DATA_EXPORT_REPOSITORY = Symbol('DATA_EXPORT_REPOSITORY');
export interface CreateDataExportInput {
  userId: string;
  familyId: string | null;
  scope: 'PERSONAL' | 'FAMILY';
  policyVersion: string;
  since: Date;
  maxRequests: number;
}
export interface IDataExportRepository {
  create(input: CreateDataExportInput): Promise<DataExport>;
  find(userId: string, id: string): Promise<DataExport | null>;
  pending(limit: number): Promise<DataExport[]>;
  expired(now: Date, limit: number): Promise<DataExport[]>;
  begin(id: string, lease: JobLease): Promise<DataExport | null>;
  snapshot(job: DataExport): Promise<DataExportSnapshot>;
  complete(
    job: DataExport,
    key: string,
    bytes: number,
    expiresAt: Date,
    lease: JobLease,
  ): Promise<void>;
  fail(id: string, code: string, lease: JobLease): Promise<void>;
  reconcileFailed(lease: JobLease): Promise<number>;
  retire(id: string, lease: JobLease): Promise<void>;
}
