export const OUTBOX_RELAY_SERVICE = Symbol('OUTBOX_RELAY_SERVICE');

/** Transactional outbox → queue dispatcher (spec §3.3). */
export interface IOutboxRelayService {
  /** Relays one batch; returns how many events were claimed. */
  relayBatch(): Promise<number>;
}
