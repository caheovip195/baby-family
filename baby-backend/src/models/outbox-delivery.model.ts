/** A claimed outbox event; publishing must match the fencing token. */
export class OutboxDelivery {
  constructor(
    readonly id: bigint,
    readonly eventId: string,
    readonly eventType: string,
    readonly aggregateId: string | null,
    readonly familyId: string | null,
    readonly attempts: number,
    readonly fencingToken: bigint,
  ) {}
}
