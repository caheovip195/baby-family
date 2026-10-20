import { ACCOUNT_DELETION_SERVICE } from '../interfaces/services/account-deletion-service.interface';
import type { IAccountDeletionService } from '../interfaces/services/account-deletion-service.interface';
import { DATA_EXPORT_SERVICE } from '../interfaces/services/data-export-service.interface';
import type { IDataExportService } from '../interfaces/services/data-export-service.interface';
import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { JOBS, QUEUES, SCHEDULES } from '../config/jobs';
import {
  MODERATION_SLA_JOB,
  MODERATION_WORKFLOW_POLICY,
} from '../config/moderation-workflow-policy';
import { MODERATION_WORKFLOW_SERVICE } from '../interfaces/services/moderation-workflow-service.interface';
import type { IModerationWorkflowService } from '../interfaces/services/moderation-workflow-service.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import { MEDIA_MAINTENANCE_SERVICE } from '../interfaces/services/media-maintenance-service.interface';
import type { IMediaMaintenanceService } from '../interfaces/services/media-maintenance-service.interface';
import { MEMORY_MAINTENANCE_SERVICE } from '../interfaces/services/memory-maintenance-service.interface';
import type { IMemoryMaintenanceService } from '../interfaces/services/memory-maintenance-service.interface';
import {
  createQueueConnection,
  drainWorker,
  postponeIfBusy,
} from './queue-connection';

/**
 * Registers the recurring maintenance schedules and consumes them. One logical run
 * per job and period (`job_runs` unique key), whichever replica picks it up.
 */
@Injectable()
export class MaintenanceQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(MaintenanceQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;

  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(MEDIA_MAINTENANCE_SERVICE)
    private readonly maintenance: IMediaMaintenanceService,
    @Inject(MEMORY_MAINTENANCE_SERVICE)
    private readonly memories: IMemoryMaintenanceService,
    @Inject(ACCOUNT_DELETION_SERVICE)
    private readonly deletion: IAccountDeletionService,
    @Inject(DATA_EXPORT_SERVICE) private readonly exports: IDataExportService,
    @Inject(MODERATION_WORKFLOW_SERVICE)
    private readonly moderation: IModerationWorkflowService,
  ) {}

  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    for (const schedule of SCHEDULES)
      await this.queue.schedule(schedule.job, schedule.everyMs);
    await this.queue.schedule(
      MODERATION_SLA_JOB,
      MODERATION_WORKFLOW_POLICY.everyMs,
    );
    this.worker = new Worker(
      QUEUES.maintenance,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        // A crash mid-job is recovered through the DB lease; allow as many stalls.
        maxStalledCount: JOBS.purgeOrphans.maxAttempts,
        concurrency: 1,
      },
    );
    this.worker.on('failed', (job, error) =>
      this.logger.warn(`Job ${job?.name ?? '?'} failed: ${error.name}`),
    );
  }

  /** Runs before connections close (onApplicationShutdown of Prisma/Valkey). */
  async onModuleDestroy(): Promise<void> {
    await drainWorker(this.worker, this.connection);
  }

  private async handle(job: Job, token?: string): Promise<string> {
    if (job.name === MODERATION_SLA_JOB.name) {
      try {
        return await this.moderation.runScheduled(new Date(job.timestamp));
      } catch (error) {
        if (error instanceof PermanentJobError)
          throw new UnrecoverableError(error.code);
        await postponeIfBusy(error, job, token);
        throw error;
      }
    }
    const schedule = SCHEDULES.find((item) => item.job.name === job.name);
    if (!schedule) throw new UnrecoverableError('Unknown maintenance job.');
    // The period start identifies the run, so retries/replicas share one run.
    const period = new Date(
      Math.floor(job.timestamp / schedule.everyMs) * schedule.everyMs,
    );
    const work =
      schedule.job.name === JOBS.deletionExecutor.name
        ? (
            context: import('../interfaces/services/job-runner-service.interface').JobContext,
          ) => this.deletion.executeDue(new Date(), context)
        : schedule.job.name === JOBS.accountMaintenance.name
          ? async (
              context: import('../interfaces/services/job-runner-service.interface').JobContext,
            ) => {
              const result = await this.exports.purgeExpired(context);
              for (const row of await this.exports.pending()) {
                context.signal.throwIfAborted();
                try {
                  await this.runner.execute(
                    JOBS.dataExport,
                    {
                      scopeKey: row.id,
                      scheduledFor: row.createdAt,
                      idempotencyKey: `data-export:${row.id}`,
                      familyId: row.familyId,
                    },
                    (ctx) => this.exports.execute(row.id, ctx),
                  );
                } catch (error) {
                  // Child runs persist their own bounded attempts; continue other users' exports.
                  this.logger.warn(
                    `Export run failed: ${error instanceof Error ? error.name : 'Error'}`,
                  );
                }
              }
              return result;
            }
          : schedule.job.name === JOBS.purgeOrphans.name
            ? (
                context: import('../interfaces/services/job-runner-service.interface').JobContext,
              ) => this.maintenance.purgeOrphans(new Date(), context)
            : schedule.job.name === JOBS.purgeTrash.name
              ? () => this.memories.purgeExpiredTrash(new Date())
              : () => this.maintenance.reconcileUploads(new Date());
    try {
      return await this.runner.execute(
        schedule.job,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `${schedule.job.name}:${period.toISOString()}`,
        },
        work,
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
