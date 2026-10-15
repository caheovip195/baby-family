import { Injectable } from '@nestjs/common';
import type { OnApplicationShutdown } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Queue } from 'bullmq';
import { Redis } from 'ioredis';
import { ServiceUnavailableError } from '../common/errors/domain.error';
import type { Environment } from '../config/environment';
import type { JobPolicy, QueueName } from '../config/jobs';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';

const COMPLETED_RETENTION = { age: 24 * 60 * 60, count: 1000 };
const FAILED_RETENTION = { age: 7 * 24 * 60 * 60 };

@Injectable()
export class JobQueueService
  implements IJobQueueService, OnApplicationShutdown
{
  private readonly connection: Redis | null;
  private readonly queues = new Map<QueueName, Queue>();

  constructor(config: ConfigService<Environment, true>) {
    const url = config.get('REDIS_URL', { infer: true });
    // BullMQ requires its own connection with unlimited per-request retries.
    this.connection = url
      ? new Redis(url, { maxRetriesPerRequest: null, lazyConnect: true })
      : null;
    this.connection?.on('error', () => undefined);
  }

  isConfigured(): boolean {
    return this.connection !== null;
  }

  async enqueue(
    policy: JobPolicy,
    jobId: string,
    data: Record<string, string>,
  ): Promise<void> {
    await this.queue(policy.queue).add(policy.name, data, {
      jobId,
      attempts: policy.maxAttempts,
      backoff: { type: 'exponential', delay: policy.backoffMs },
      removeOnComplete: COMPLETED_RETENTION,
      removeOnFail: FAILED_RETENTION,
    });
  }

  async schedule(policy: JobPolicy, everyMs: number): Promise<void> {
    await this.queue(policy.queue).upsertJobScheduler(
      policy.name,
      { every: everyMs },
      {
        name: policy.name,
        data: {},
        opts: {
          attempts: policy.maxAttempts,
          backoff: { type: 'exponential', delay: policy.backoffMs },
          removeOnComplete: COMPLETED_RETENTION,
          removeOnFail: FAILED_RETENTION,
        },
      },
    );
  }

  async onApplicationShutdown(): Promise<void> {
    await Promise.all([...this.queues.values()].map((queue) => queue.close()));
    this.connection?.disconnect();
  }

  private queue(name: QueueName): Queue {
    if (!this.connection)
      throw new ServiceUnavailableError('Job queue is not configured.');
    let queue = this.queues.get(name);
    if (!queue) {
      queue = new Queue(name, { connection: this.connection });
      this.queues.set(name, queue);
    }
    return queue;
  }
}
