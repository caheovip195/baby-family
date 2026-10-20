import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import {
  FAMILY_ERASURE_JOB,
  FAMILY_ERASURE_POLICY,
} from '../config/family-erasure-policy';
import { FAMILY_ERASURE_SERVICE } from '../interfaces/services/family-erasure-service.interface';
import type { IFamilyErasureService } from '../interfaces/services/family-erasure-service.interface';
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
export class FamilyErasureQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(FamilyErasureQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(FAMILY_ERASURE_SERVICE)
    private readonly erasure: IFamilyErasureService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      FAMILY_ERASURE_JOB,
      FAMILY_ERASURE_POLICY.everyMs,
    );
    this.worker = new Worker(
      FAMILY_ERASURE_JOB.queue,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: FAMILY_ERASURE_JOB.maxAttempts,
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
    if (job.name !== FAMILY_ERASURE_JOB.name)
      throw new UnrecoverableError('Invalid family deletion job.');
    // Missed ticks coalesce: each period processes the due backlog.
    const period = new Date(
      Math.floor(job.timestamp / FAMILY_ERASURE_POLICY.everyMs) *
        FAMILY_ERASURE_POLICY.everyMs,
    );
    try {
      return await this.runner.execute(
        FAMILY_ERASURE_JOB,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `${FAMILY_ERASURE_JOB.name}:${period.toISOString()}`,
        },
        (context) => this.erasure.executeDue(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
