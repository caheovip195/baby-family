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
import { NOTIFICATION_DISPATCH_SERVICE } from '../interfaces/services/notification-dispatch-service.interface';
import type { INotificationDispatchService } from '../interfaces/services/notification-dispatch-service.interface';
import {
  createQueueConnection,
  drainWorker,
  postponeIfBusy,
} from './queue-connection';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Consumes the `notifications` queue; all work goes through services (no Prisma here). */
@Injectable()
export class NotificationQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(NotificationQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;

  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(NOTIFICATION_DISPATCH_SERVICE)
    private readonly processing: INotificationDispatchService,
  ) {}

  onApplicationBootstrap(): void {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    this.worker = new Worker(
      QUEUES.notifications,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        // A crash mid-job is recovered through the DB lease; allow as many stalls.
        maxStalledCount: JOBS.dispatchNotification.maxAttempts,
        concurrency: 2,
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
    const eventId = (job.data as { eventId?: unknown }).eventId;
    if (
      job.name !== JOBS.dispatchNotification.name ||
      typeof eventId !== 'string' ||
      !UUID.test(eventId)
    )
      throw new UnrecoverableError('Invalid notification job.');
    try {
      return await this.runner.execute(
        JOBS.dispatchNotification,
        {
          scopeKey: eventId,
          scheduledFor: new Date(job.timestamp),
          idempotencyKey: `${JOBS.dispatchNotification.name}:${eventId}`,
          inputReference: { eventId },
        },
        (context) => this.processing.dispatch(eventId, context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
