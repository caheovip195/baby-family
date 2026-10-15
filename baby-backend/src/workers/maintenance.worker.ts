import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { JOBS, QUEUES, SCHEDULES } from '../config/jobs';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import { MEDIA_MAINTENANCE_SERVICE } from '../interfaces/services/media-maintenance-service.interface';
import type { IMediaMaintenanceService } from '../interfaces/services/media-maintenance-service.interface';
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
  ) {}

  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    for (const schedule of SCHEDULES)
      await this.queue.schedule(schedule.job, schedule.everyMs);
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
    const schedule = SCHEDULES.find((item) => item.job.name === job.name);
    if (!schedule) throw new UnrecoverableError('Unknown maintenance job.');
    // The period start identifies the run, so retries/replicas share one run.
    const period = new Date(
      Math.floor(job.timestamp / schedule.everyMs) * schedule.everyMs,
    );
    const work =
      schedule.job.name === JOBS.purgeOrphans.name
        ? () => this.maintenance.purgeOrphans(new Date())
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
