import { hostname } from 'node:os';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { OUTBOX_RELAY, OUTBOX_ROUTES } from '../config/jobs';
import type { OutboxEventType } from '../config/jobs';
import { OUTBOX_RELAY_REPOSITORY } from '../interfaces/repositories/outbox-relay-repository.interface';
import type { IOutboxRelayRepository } from '../interfaces/repositories/outbox-relay-repository.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import type { IOutboxRelayService } from '../interfaces/services/outbox-relay-service.interface';

const STALE_WARNING_ATTEMPTS = 10;

@Injectable()
export class OutboxRelayService implements IOutboxRelayService {
  private readonly logger = new Logger(OutboxRelayService.name);
  private readonly owner = `${hostname()}-${process.pid}`.slice(0, 100);

  constructor(
    @Inject(OUTBOX_RELAY_REPOSITORY)
    private readonly outbox: IOutboxRelayRepository,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}

  async relayBatch(): Promise<number> {
    const deliveries = await this.outbox.claim(
      Object.keys(OUTBOX_ROUTES),
      this.owner,
      OUTBOX_RELAY.leaseMs,
      OUTBOX_RELAY.batchSize,
    );
    for (const delivery of deliveries) {
      const policy = OUTBOX_ROUTES[delivery.eventType as OutboxEventType];
      try {
        if (!delivery.aggregateId) throw new Error('Missing aggregate id');
        // Job id = event id: a re-delivered event never enqueues twice.
        await this.queue.enqueue(policy, `evt-${delivery.eventId}`, {
          assetId: delivery.aggregateId,
          eventId: delivery.eventId,
        });
        await this.outbox.markPublished(delivery);
      } catch {
        // Retry until published, with capped exponential backoff (docs/jobs.md).
        const delay = Math.min(
          1000 * 2 ** Math.min(delivery.attempts, 20),
          OUTBOX_RELAY.maxBackoffMs,
        );
        await this.outbox.markFailed(
          delivery,
          'ENQUEUE_FAILED',
          new Date(Date.now() + delay),
        );
        if (delivery.attempts >= STALE_WARNING_ATTEMPTS)
          this.logger.error(
            `Outbox event ${delivery.eventId} still unpublished after ${delivery.attempts} attempts.`,
          );
      }
    }
    return deliveries.length;
  }
}
