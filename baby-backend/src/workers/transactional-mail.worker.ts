import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { z } from 'zod';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import {
  TRANSACTIONAL_MAIL_POLICY,
  TRANSACTIONAL_MAIL_JOBS,
} from '../config/transactional-mail-policy';
import { QUEUES } from '../config/jobs';
import { TRANSACTIONAL_MAIL_SERVICE } from '../interfaces/services/transactional-mail-service.interface';
import type { ITransactionalMailService } from '../interfaces/services/transactional-mail-service.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import {
  createQueueConnection,
  drainWorker,
  postponeIfBusy,
} from './queue-connection';

/** Adapters only: durable attempts and business/fencing live in services/repositories. */
@Injectable()
export class TransactionalMailQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(TransactionalMailQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(TRANSACTIONAL_MAIL_SERVICE)
    private readonly mail: ITransactionalMailService,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap() {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      TRANSACTIONAL_MAIL_JOBS.reconcile,
      TRANSACTIONAL_MAIL_POLICY.everyMs,
    );
    this.worker = new Worker(
      QUEUES.transactionalMail,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: TRANSACTIONAL_MAIL_JOBS.deliver.maxAttempts,
      },
    );
    this.worker.on('failed', () =>
      this.logger.error(
        'Transactional mail job failed; inspect durable job history.',
      ),
    );
  }
  async onModuleDestroy() {
    await drainWorker(this.worker, this.connection);
  }
  private async handle(job: Job, token?: string) {
    try {
      if (job.name === TRANSACTIONAL_MAIL_JOBS.deliver.name) {
        // Use eventId, not aggregateId: one source can have several mail templates.
        const data: unknown = job.data;
        const parsed = z.object({ eventId: z.uuid() }).safeParse(data);
        if (!parsed.success)
          throw new UnrecoverableError('Invalid mail event reference.');
        const id = parsed.data.eventId;
        return await this.runner.execute(
          TRANSACTIONAL_MAIL_JOBS.deliver,
          {
            scopeKey: id,
            scheduledFor: new Date(0),
            idempotencyKey: `mail-event:${id}`,
            inputReference: { eventId: id },
          },
          (context) => this.mail.deliver(id, context),
        );
      }
      if (job.name !== TRANSACTIONAL_MAIL_JOBS.reconcile.name)
        throw new UnrecoverableError('Unknown mail job.');
      const period = new Date(
        Math.floor(job.timestamp / TRANSACTIONAL_MAIL_POLICY.everyMs) *
          TRANSACTIONAL_MAIL_POLICY.everyMs,
      );
      return await this.runner.execute(
        TRANSACTIONAL_MAIL_JOBS.reconcile,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `mail-reconcile:${period.toISOString()}`,
        },
        (context) => this.mail.reconcile(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
