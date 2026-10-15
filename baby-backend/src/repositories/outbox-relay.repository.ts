import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IOutboxRelayRepository } from '../interfaces/repositories/outbox-relay-repository.interface';
import { OutboxDelivery } from '../models/outbox-delivery.model';

interface OutboxRow {
  id: bigint;
  event_id: string;
  event_type: string;
  aggregate_id: string | null;
  family_id: string | null;
  attempts: number;
  fencing_token: bigint;
}

@Injectable()
export class OutboxRelayRepository implements IOutboxRelayRepository {
  constructor(private readonly prisma: PrismaService) {}

  async claim(
    eventTypes: readonly string[],
    owner: string,
    leaseMs: number,
    limit: number,
  ): Promise<OutboxDelivery[]> {
    const rows = await this.prisma.$queryRaw<OutboxRow[]>`
      UPDATE ops.outbox_events
      SET lease_owner = ${owner},
          lease_expires_at = now() + make_interval(secs => ${leaseMs / 1000}),
          fencing_token = fencing_token + 1,
          attempts = attempts + 1
      WHERE id IN (
        SELECT id FROM ops.outbox_events
        WHERE published_at IS NULL AND deleted_at IS NULL
          AND available_at <= now()
          AND event_type = ANY(${[...eventTypes]}::text[])
          AND (lease_expires_at IS NULL OR lease_expires_at < now())
        ORDER BY available_at, id
        LIMIT ${limit}
        FOR UPDATE SKIP LOCKED)
      RETURNING id, event_id::text, event_type, aggregate_id::text,
                family_id::text, attempts, fencing_token`;
    return rows.map(
      (row) =>
        new OutboxDelivery(
          row.id,
          row.event_id,
          row.event_type,
          row.aggregate_id,
          row.family_id,
          row.attempts,
          row.fencing_token,
        ),
    );
  }

  async markPublished(delivery: OutboxDelivery): Promise<boolean> {
    const updated = await this.prisma.$executeRaw`
      UPDATE ops.outbox_events
      SET published_at = now(), lease_owner = NULL, lease_expires_at = NULL,
          last_error_code = NULL
      WHERE id = ${delivery.id} AND fencing_token = ${delivery.fencingToken}
        AND published_at IS NULL`;
    return updated === 1;
  }

  async markFailed(
    delivery: OutboxDelivery,
    errorCode: string,
    availableAt: Date,
  ): Promise<void> {
    await this.prisma.$executeRaw`
      UPDATE ops.outbox_events
      SET available_at = ${availableAt}, last_error_code = ${errorCode},
          lease_owner = NULL, lease_expires_at = NULL
      WHERE id = ${delivery.id} AND fencing_token = ${delivery.fencingToken}
        AND published_at IS NULL`;
  }
}
