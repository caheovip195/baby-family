import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { z } from 'zod';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { IAP_BILLING_POLICY } from '../config/iap-billing-policy';
import { JOBS, QUEUES } from '../config/jobs';
import { IAP_BILLING_SERVICE } from '../interfaces/services/iap-billing-service.interface';
import type { IIapBillingService } from '../interfaces/services/iap-billing-service.interface';
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
export class IapBillingQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(IapBillingQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(IAP_BILLING_SERVICE) private readonly billing: IIapBillingService,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async onApplicationBootstrap() {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      JOBS.reconcileStoreNotifications,
      IAP_BILLING_POLICY.reconciliationEveryMs,
    );
    this.worker = new Worker(
      QUEUES.storeNotifications,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        concurrency: 1,
        maxStalledCount: JOBS.processStoreNotification.maxAttempts,
      },
    );
    this.worker.on('failed', () =>
      this.logger.error(
        'Store notification job failed; inspect durable job history.',
      ),
    );
  }
  async onModuleDestroy() {
    await drainWorker(this.worker, this.connection);
  }
  private async handle(job: Job, token?: string) {
    try {
      if (job.name === JOBS.processStoreNotification.name) {
        // Existing outbox relay projects aggregateId as assetId for every event type.
        const data: unknown = job.data;
        const parsed = z.object({ assetId: z.uuid() }).safeParse(data);
        if (!parsed.success)
          throw new UnrecoverableError('Invalid store event reference.');
        const id = parsed.data.assetId;
        return await this.runner.execute(
          JOBS.processStoreNotification,
          {
            scopeKey: id,
            scheduledFor: new Date(0),
            idempotencyKey: `iap-event:${id}`,
            inputReference: { notificationId: id },
          },
          (context) => this.billing.processNotification(id, context),
        );
      }
      if (job.name !== JOBS.reconcileStoreNotifications.name)
        throw new UnrecoverableError('Unknown store job.');
      const period = new Date(
        Math.floor(job.timestamp / IAP_BILLING_POLICY.reconciliationEveryMs) *
          IAP_BILLING_POLICY.reconciliationEveryMs,
      );
      return await this.runner.execute(
        JOBS.reconcileStoreNotifications,
        {
          scopeKey: 'GLOBAL',
          scheduledFor: period,
          idempotencyKey: `iap-reconcile:${period.toISOString()}`,
        },
        (context) => this.billing.reconcileNotifications(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
