import { Inject, Injectable, Logger, Optional } from '@nestjs/common';
import {
  MODERATION_SLA_JOB,
  MODERATION_WORKFLOW_POLICY,
} from '../config/moderation-workflow-policy';
import { MODERATION_WORKFLOW_REPOSITORY } from '../interfaces/repositories/moderation-workflow-repository.interface';
import type { IModerationWorkflowRepository } from '../interfaces/repositories/moderation-workflow-repository.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type {
  IJobRunnerService,
  JobContext,
  JobExecutionOutcome,
} from '../interfaces/services/job-runner-service.interface';
import type { IModerationWorkflowService } from '../interfaces/services/moderation-workflow-service.interface';

@Injectable()
export class ModerationWorkflowService implements IModerationWorkflowService {
  private readonly logger = new Logger(ModerationWorkflowService.name);
  constructor(
    @Inject(MODERATION_WORKFLOW_REPOSITORY)
    private readonly repository: IModerationWorkflowRepository,
    // Only the worker runs the SLA job; the API process just attaches reports.
    @Optional()
    @Inject(JOB_RUNNER_SERVICE)
    private readonly runner?: IJobRunnerService,
  ) {}
  async reportCreated(reportId: string): Promise<void> {
    try {
      await this.repository.attachReport(reportId);
    } catch {
      this.logger.warn(
        'MODERATION_ATTACH_DEFERRED: reconcile pending reports.',
      );
    }
  }
  async reconcile(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>> {
    let attached = 0;
    for (const id of await this.repository.unattachedReports(
      MODERATION_WORKFLOW_POLICY.batchSize,
      familyId,
    )) {
      context.signal.throwIfAborted();
      if (await this.repository.attachReport(id, context.lease)) attached++;
    }
    context.signal.throwIfAborted();
    const escalated = await this.repository.escalateDue(
      now,
      context.lease,
      MODERATION_WORKFLOW_POLICY.batchSize,
      familyId,
    );
    return { attached, escalated };
  }
  runScheduled(
    scheduledFor: Date,
    familyId?: string,
  ): Promise<JobExecutionOutcome> {
    const period = new Date(
      Math.floor(scheduledFor.getTime() / MODERATION_WORKFLOW_POLICY.everyMs) *
        MODERATION_WORKFLOW_POLICY.everyMs,
    );
    const scopeKey = familyId ?? 'GLOBAL';
    if (!this.runner)
      return Promise.reject(new Error('JOB_RUNNER_SERVICE is not bound.'));
    return this.runner.execute(
      MODERATION_SLA_JOB,
      {
        scopeKey,
        familyId,
        scheduledFor: period,
        idempotencyKey: `${MODERATION_SLA_JOB.name}:${scopeKey}:${period.toISOString()}`,
      },
      (context) => this.reconcile(new Date(), context, familyId),
    );
  }
}
