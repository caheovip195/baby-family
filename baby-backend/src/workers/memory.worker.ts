import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { JOBS, QUEUES, MEMORY_LETTER_RELEASE_POLICY } from '../config/jobs';
import { MEMORY_CAPSULE_SERVICE } from '../interfaces/services/memory-capsule-service.interface';
import type { IMemoryCapsuleService } from '../interfaces/services/memory-capsule-service.interface';
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
export class MemoryQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(MemoryQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(MEMORY_CAPSULE_SERVICE)
    private readonly capsules: IMemoryCapsuleService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      JOBS.releaseLetters,
      MEMORY_LETTER_RELEASE_POLICY.everyMs,
    );
    this.worker = new Worker(
      QUEUES.memory,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: JOBS.releaseLetters.maxAttempts,
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
    if (job.name !== JOBS.releaseLetters.name)
      throw new UnrecoverableError('Invalid memory job.');
    // UTC daily buckets; missed ticks are skipped; next run scans all families.
    const period = new Date(
      Math.floor(job.timestamp / MEMORY_LETTER_RELEASE_POLICY.everyMs) *
        MEMORY_LETTER_RELEASE_POLICY.everyMs,
    );
    try {
      return await this.runner.execute(
        JOBS.releaseLetters,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `${JOBS.releaseLetters.name}:${period.toISOString()}`,
        },
        (context) => this.capsules.release(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
