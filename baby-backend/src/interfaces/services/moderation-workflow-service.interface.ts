import type {
  JobContext,
  JobExecutionOutcome,
} from './job-runner-service.interface';
export const MODERATION_WORKFLOW_SERVICE = Symbol(
  'MODERATION_WORKFLOW_SERVICE',
);
export interface IModerationWorkflowService {
  /** Best effort hook: committed reports remain recoverable after a failure. */
  reportCreated(reportId: string): Promise<void>;
  reconcile(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>>;
  runScheduled(
    scheduledFor: Date,
    familyId?: string,
  ): Promise<JobExecutionOutcome>;
}
