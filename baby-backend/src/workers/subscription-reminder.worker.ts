import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import {
  SUBSCRIPTION_REMINDER_JOB,
  SUBSCRIPTION_REMINDER_POLICY,
} from '../config/subscription-reminder-policy';
import { SUBSCRIPTION_REMINDER_SERVICE } from '../interfaces/services/subscription-reminder-service.interface';
import type { ISubscriptionReminderService } from '../interfaces/services/subscription-reminder-service.interface';
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
export class SubscriptionReminderQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(SubscriptionReminderQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(SUBSCRIPTION_REMINDER_SERVICE)
    private readonly reminders: ISubscriptionReminderService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      SUBSCRIPTION_REMINDER_JOB,
      SUBSCRIPTION_REMINDER_POLICY.everyMs,
    );
    this.worker = new Worker(
      SUBSCRIPTION_REMINDER_JOB.queue,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: SUBSCRIPTION_REMINDER_JOB.maxAttempts,
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
    if (job.name !== SUBSCRIPTION_REMINDER_JOB.name)
      throw new UnrecoverableError('Invalid subscription reminder job.');
    // Hourly UTC buckets; missed scans coalesce after 09:00 family time.
    const period = new Date(
      Math.floor(job.timestamp / SUBSCRIPTION_REMINDER_POLICY.everyMs) *
        SUBSCRIPTION_REMINDER_POLICY.everyMs,
    );
    try {
      return await this.runner.execute(
        SUBSCRIPTION_REMINDER_JOB,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `${SUBSCRIPTION_REMINDER_JOB.name}:${period.toISOString()}`,
        },
        (context) => this.reminders.dispatch(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
