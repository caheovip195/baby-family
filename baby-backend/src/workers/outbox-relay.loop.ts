import { setTimeout as sleep } from 'node:timers/promises';
import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { OUTBOX_RELAY } from '../config/jobs';
import { OUTBOX_RELAY_SERVICE } from '../interfaces/services/outbox-relay-service.interface';
import type { IOutboxRelayService } from '../interfaces/services/outbox-relay-service.interface';

/** Polls the transactional outbox and hands events to the queue (spec §3.3). */
@Injectable()
export class OutboxRelayLoop
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(OutboxRelayLoop.name);
  private readonly stop = new AbortController();
  private loop: Promise<void> | null = null;

  constructor(
    @Inject(OUTBOX_RELAY_SERVICE) private readonly relay: IOutboxRelayService,
  ) {}

  onApplicationBootstrap(): void {
    this.loop = this.run();
  }

  async onModuleDestroy(): Promise<void> {
    this.stop.abort();
    await this.loop;
  }

  private async run(): Promise<void> {
    while (!this.stop.signal.aborted) {
      let claimed = 0;
      try {
        claimed = await this.relay.relayBatch();
      } catch (error) {
        // DB/queue outage: events stay pending in PostgreSQL and are retried.
        this.logger.warn(
          `Outbox relay failed: ${error instanceof Error ? error.name : 'Error'}`,
        );
      }
      if (claimed < OUTBOX_RELAY.batchSize)
        await sleep(OUTBOX_RELAY.pollIntervalMs, undefined, {
          signal: this.stop.signal,
        }).catch(() => undefined);
    }
  }
}
