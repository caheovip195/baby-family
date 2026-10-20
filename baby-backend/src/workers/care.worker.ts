import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import { BADGE_AWARD_POLICY } from '../config/badge-award-policy';
import type { Environment } from '../config/environment';
import { JOBS, QUEUES } from '../config/jobs';
import { BADGE_AWARD_SERVICE } from '../interfaces/services/badge-award-service.interface';
import type { IBadgeAwardService } from '../interfaces/services/badge-award-service.interface';
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
export class CareQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(CareQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(BADGE_AWARD_SERVICE) private readonly badges: IBadgeAwardService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      JOBS.awardBadges,
      BADGE_AWARD_POLICY.dailyEveryMs,
    );
    this.worker = new Worker(
      QUEUES.care,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: JOBS.awardBadges.maxAttempts,
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
    const eventId = (job.data as { eventId?: unknown }).eventId;
    if (
      job.name !== JOBS.awardBadges.name ||
      (eventId !== undefined &&
        (typeof eventId !== 'string' ||
          !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
            eventId,
          )))
    )
      throw new UnrecoverableError('Invalid badge job.');
    // UTC daily buckets; missed ticks are skipped; next run scans all families.
    const period = new Date(
      Math.floor(job.timestamp / BADGE_AWARD_POLICY.dailyEveryMs) *
        BADGE_AWARD_POLICY.dailyEveryMs,
    );
    try {
      return await this.runner.execute(
        JOBS.awardBadges,
        {
          scopeKey: eventId ?? 'GLOBAL',
          scheduledFor: eventId ? new Date(job.timestamp) : period,
          idempotencyKey: `${JOBS.awardBadges.name}:${eventId ?? period.toISOString()}`,
        },
        (context) => this.badges.award(new Date(), context, eventId),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
