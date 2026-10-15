import type { OutboxDelivery } from '../../models/outbox-delivery.model';

export const OUTBOX_RELAY_REPOSITORY = Symbol('OUTBOX_RELAY_REPOSITORY');

export interface IOutboxRelayRepository {
  /** Leases due, unpublished events of the given types (SKIP LOCKED). */
  claim(
    eventTypes: readonly string[],
    owner: string,
    leaseMs: number,
    limit: number,
  ): Promise<OutboxDelivery[]>;
  markPublished(delivery: OutboxDelivery): Promise<boolean>;
  /** Keeps the event pending and makes it due again at `availableAt`. */
  markFailed(
    delivery: OutboxDelivery,
    errorCode: string,
    availableAt: Date,
  ): Promise<void>;
}
