import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { PUSH_POLICY } from '../config/push-policy';
import { JOBS, QUEUES } from '../config/jobs';
import { PUSH_DELIVERY_SERVICE } from '../interfaces/services/push-delivery-service.interface';
import type { IPushDeliveryService } from '../interfaces/services/push-delivery-service.interface';
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
export class PushQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(PushQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(PUSH_DELIVERY_SERVICE)
    private readonly delivery: IPushDeliveryService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(JOBS.deliverPush, PUSH_POLICY.everyMs);
    this.worker = new Worker(
      QUEUES.push,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        maxStalledCount: JOBS.deliverPush.maxAttempts,
        concurrency: 2,
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
    if (job.name !== JOBS.deliverPush.name)
      throw new UnrecoverableError('Invalid push job.');
    const policy = JOBS.deliverPush;
    const period = new Date(
      Math.floor(job.timestamp / PUSH_POLICY.everyMs) * PUSH_POLICY.everyMs,
    );
    try {
      return await this.runner.execute(
        policy,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `${policy.name}:${period.toISOString()}`,
        },
        (context) => this.delivery.deliver(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
