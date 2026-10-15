import { hostname } from 'node:os';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DomainError } from '../common/errors/domain.error';
import { JobBusyError, PermanentJobError } from '../common/errors/job.error';
import type { JobPolicy } from '../config/jobs';
import type { Environment } from '../config/environment';
import { JOB_EXECUTION_REPOSITORY } from '../interfaces/repositories/job-execution-repository.interface';
import type { IJobExecutionRepository } from '../interfaces/repositories/job-execution-repository.interface';
import type {
  IJobRunnerService,
  JobExecutionOutcome,
  JobHandler,
  JobRunRequest,
} from '../interfaces/services/job-runner-service.interface';

@Injectable()
export class JobRunnerService implements IJobRunnerService {
  private readonly logger = new Logger(JobRunnerService.name);
  private readonly workerId: string;

  constructor(
    @Inject(JOB_EXECUTION_REPOSITORY)
    private readonly runs: IJobExecutionRepository,
    config: ConfigService<Environment, true>,
  ) {
    this.workerId = (
      config.get('WORKER_ID', { infer: true }) ?? `${hostname()}-${process.pid}`
    ).slice(0, 100);
  }

  async execute(
    policy: JobPolicy,
    request: JobRunRequest,
    handler: JobHandler,
  ): Promise<JobExecutionOutcome> {
    const claim = await this.runs.claim(
      {
        jobName: policy.name,
        scopeKey: request.scopeKey,
        scheduledFor: request.scheduledFor,
        idempotencyKey: request.idempotencyKey,
        maxAttempts: policy.maxAttempts,
        familyId: request.familyId ?? null,
        inputReference: request.inputReference ?? {},
      },
      this.workerId,
      policy.leaseMs,
    );
    if (claim.kind === 'finished') return 'ALREADY_FINISHED';
    if (claim.kind === 'busy') throw new JobBusyError();
    if (claim.kind === 'exhausted') {
      this.logger.error(
        `Job ${policy.name} exhausted its attempts (${request.idempotencyKey}).`,
      );
      throw new PermanentJobError(
        'ATTEMPTS_EXHAUSTED',
        'Job attempts are exhausted.',
      );
    }
    const lease = claim.lease;
    const controller = new AbortController();
    const heartbeat = setInterval(
      () => {
        this.runs.heartbeat(lease, policy.leaseMs).then(
          (owned) => {
            if (!owned) controller.abort(new Error('Job lease was lost.'));
          },
          () => undefined, // DB outage: the lease may expire; the reconciler recovers.
        );
      },
      Math.floor(policy.leaseMs / 3),
    );
    heartbeat.unref();
    try {
      const checkpoint = await handler({ signal: controller.signal, lease });
      if (!(await this.runs.succeed(lease, checkpoint)))
        throw new Error('Job lease was lost before completion.');
      return 'SUCCEEDED';
    } catch (error) {
      const permanent = error instanceof PermanentJobError;
      const code = permanent
        ? error.code
        : error instanceof DomainError
          ? error.code
          : 'TRANSIENT_ERROR';
      // Persist only our own sanitized messages; unknown errors keep their type name.
      const summary = (
        permanent || error instanceof DomainError
          ? error.message
          : error instanceof Error
            ? error.name
            : 'Error'
      ).slice(0, 500);
      const status = await this.runs
        .fail(lease, {
          code,
          summary,
          permanent,
          retryAt: new Date(
            Date.now() + policy.backoffMs * 2 ** (lease.attemptNumber - 1),
          ),
        })
        .catch(() => {
          // The DB may be down: the lease expires and the next claim marks the
          // attempt TIMED_OUT (docs/jobs.md §5).
          this.logger.warn(`Could not record failure of job ${policy.name}.`);
          return null;
        });
      if (status === 'FAILED')
        this.logger.error(
          `Job ${policy.name} failed permanently (${code}, attempt ${lease.attemptNumber}).`,
        );
      throw error;
    } finally {
      clearInterval(heartbeat);
    }
  }
}
