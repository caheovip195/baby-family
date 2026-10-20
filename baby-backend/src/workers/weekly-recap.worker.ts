import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import {
  WEEKLY_RECAP_JOB,
  WEEKLY_RECAP_POLICY,
} from '../config/weekly-recap-policy';
import { WEEKLY_RECAP_SERVICE } from '../interfaces/services/weekly-recap-service.interface';
import type { IWeeklyRecapService } from '../interfaces/services/weekly-recap-service.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import {
  createQueueConnection,
  drainWorker,
  postponeIfBusy,
} from './queue-connection';

@Injectable()
export class WeeklyRecapQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(WeeklyRecapQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(WEEKLY_RECAP_SERVICE)
    private readonly recaps: IWeeklyRecapService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(WEEKLY_RECAP_JOB, WEEKLY_RECAP_POLICY.everyMs);
    this.worker = new Worker(
      WEEKLY_RECAP_JOB.queue,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: WEEKLY_RECAP_JOB.maxAttempts,
      },
    );
    this.worker.on('failed', (job, error) =>
      this.logger.warn(`Job ${job?.name ?? '?'} failed: ${error.name}`),
    );
  }
  async onModuleDestroy(): Promise<void> {
    await drainWorker(this.worker, this.connection);
  }
  private async handle(job: Job, token?: string): Promise<string> {
    if (job.name !== WEEKLY_RECAP_JOB.name)
      throw new UnrecoverableError('Invalid weekly recap job.');
    // Hourly buckets; the next tick coalesces up to four completed local weeks.
    const period = new Date(
      Math.floor(job.timestamp / WEEKLY_RECAP_POLICY.everyMs) *
        WEEKLY_RECAP_POLICY.everyMs,
    );
    try {
      return await this.runner.execute(
        WEEKLY_RECAP_JOB,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `${WEEKLY_RECAP_JOB.name}:${period.toISOString()}`,
        },
        (context) => this.recaps.build(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
