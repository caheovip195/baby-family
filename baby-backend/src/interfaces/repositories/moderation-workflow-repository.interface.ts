import type { JobLease } from '../../models/job-lease.model';
import type { ModerationWorkflowCase } from '../../models/moderation-workflow.model';

export const MODERATION_WORKFLOW_REPOSITORY = Symbol(
  'MODERATION_WORKFLOW_REPOSITORY',
);
export interface IModerationWorkflowRepository {
  attachReport(
    reportId: string,
    lease?: JobLease,
  ): Promise<ModerationWorkflowCase | null>;
  unattachedReports(limit: number, familyId?: string): Promise<string[]>;
  escalateDue(
    now: Date,
    lease: JobLease,
    limit: number,
    familyId?: string,
  ): Promise<number>;
}
