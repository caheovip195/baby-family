import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { JOBS, QUEUES } from '../config/jobs';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import { MEDIA_PROCESSING_SERVICE } from '../interfaces/services/media-processing-service.interface';
import type { IMediaProcessingService } from '../interfaces/services/media-processing-service.interface';
import {
  createQueueConnection,
  drainWorker,
  postponeIfBusy,
} from './queue-connection';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Consumes the `media` queue; all work goes through services (no Prisma here). */
@Injectable()
export class MediaQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(MediaQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;

  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(MEDIA_PROCESSING_SERVICE)
    private readonly processing: IMediaProcessingService,
  ) {}

  onApplicationBootstrap(): void {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    this.worker = new Worker(
      QUEUES.media,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        // A crash mid-job is recovered through the DB lease; allow as many stalls.
        maxStalledCount: JOBS.processAsset.maxAttempts,
        concurrency: this.config.get('MEDIA_WORKER_CONCURRENCY', {
          infer: true,
        }),
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
    const assetId = (job.data as { assetId?: unknown }).assetId;
    if (
      job.name !== JOBS.processAsset.name ||
      typeof assetId !== 'string' ||
      !UUID.test(assetId)
    )
      throw new UnrecoverableError('Invalid media job.');
    try {
      return await this.runner.execute(
        JOBS.processAsset,
        {
          scopeKey: assetId,
          scheduledFor: new Date(job.timestamp),
          idempotencyKey: `${JOBS.processAsset.name}:${assetId}`,
          inputReference: { assetId },
        },
        (context) => this.processing.processAsset(assetId, context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
