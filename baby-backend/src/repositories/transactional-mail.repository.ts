import { createHash } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import {
  TRANSACTIONAL_MAIL_POLICY as POLICY,
  TRANSACTIONAL_MAIL_TEMPLATES,
} from '../config/transactional-mail-policy';
import type { TransactionalMailKind } from '../config/transactional-mail-policy';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import type { ITransactionalMailRepository } from '../interfaces/repositories/transactional-mail-repository.interface';
import type { JobLease } from '../models/job-lease.model';
import { TransactionalMail } from '../models/transactional-mail.model';
import { enqueueTransactionalMail } from './transactional-mail-outbox';

@Injectable()
export class TransactionalMailRepository implements ITransactionalMailRepository {
  constructor(private readonly prisma: PrismaService) {}
  async find(eventId: string, now: Date) {
    const event = await this.prisma.outboxEvent.findFirst({
      where: { eventId, eventType: 'mail.transactional', deletedAt: null },
    });
    if (
      !event ||
      typeof event.payload !== 'object' ||
      !event.payload ||
      Array.isArray(event.payload)
    )
      return null;
    const { kind, userId, referenceId, state, version } = event.payload;
    if (
      version !== 1 ||
      typeof kind !== 'string' ||
      !Object.hasOwn(TRANSACTIONAL_MAIL_TEMPLATES.vi, kind) ||
      typeof userId !== 'string' ||
      typeof referenceId !== 'string' ||
      typeof state !== 'string'
    )
      return null;
    const user = await this.prisma.user.findFirst({
      where: {
        id: userId,
        deletedAt: null,
        status: { in: ['ACTIVE', 'DELETION_PENDING'] },
      },
    });
    if (!user) return null;
    // Apple/Google verifier writes email ONLY after email_verified=true. PHONE email is never trusted.
    const identities = await this.prisma.authIdentity.findMany({
      where: {
        userId,
        deletedAt: null,
        provider: { in: ['APPLE', 'GOOGLE'] },
        email: { not: null },
      },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
    });
    let verifiedEmail: string | null = null;
    for (const identity of identities) {
      const emailHash = createHash('sha256')
        .update(identity.email!.toLowerCase())
        .digest('hex');
      const proof = await this.prisma.outboxEvent.findFirst({
        where: {
          eventType: 'auth.email_verified',
          aggregateId: identity.id,
          deletedAt: null,
          AND: [
            { payload: { path: ['version'], equals: 1 } },
            { payload: { path: ['emailHash'], equals: emailHash } },
          ],
        },
      });
      if (proof) {
        verifiedEmail = identity.email;
        break;
      }
    }
    let timezone = user.timezone;
    let deadline: Date | null = null;
    let storageKey: string | null = null;
    if (kind === 'EXPORT_READY') {
      const row = await this.prisma.exportJob.findFirst({
        where: {
          id: referenceId,
          requesterId: userId,
          status: 'COMPLETED',
          deletedAt: null,
          expiresAt: { gt: now },
        },
      });
      if (!row || user.status !== 'ACTIVE') return null;
      if (row.scope === 'FAMILY') {
        const parent = await this.prisma.familyParent.findFirst({
          where: {
            familyId: row.familyId!,
            userId,
            status: 'ACTIVE',
            deletedAt: null,
            leftAt: null,
            joinedAt: { lte: now },
            family: { deletedAt: null, status: { not: 'DELETED' } },
          },
        });
        if (!parent) return null;
        const family = await this.prisma.family.findUniqueOrThrow({
          where: { id: row.familyId! },
        });
        timezone = family.timezone;
      }
      deadline = row.expiresAt;
      storageKey = row.storageKey;
      if (!storageKey) return null;
    } else if (kind.startsWith('ACCOUNT_DELETION_')) {
      const row = await this.prisma.deletionRequest.findFirst({
        where: {
          id: referenceId,
          userId,
          status: 'SCHEDULED',
          deletedAt: null,
          executeAfter: { gt: now },
        },
      });
      if (!row) return null;
      deadline = row.executeAfter;
    } else if (kind.startsWith('FAMILY_DELETION_')) {
      const row = await this.prisma.familyDeletionRequest.findFirst({
        where: {
          id: referenceId,
          status: 'SCHEDULED',
          deletedAt: null,
          executeAfter: { gt: now },
          family: {
            deletedAt: null,
            status: 'DELETION_SCHEDULED',
            familyParents: {
              some: {
                userId,
                status: 'ACTIVE',
                deletedAt: null,
                leftAt: null,
                joinedAt: { lte: now },
              },
            },
          },
        },
      });
      if (!row) return null;
      deadline = row.executeAfter;
      const family = await this.prisma.family.findUniqueOrThrow({
        where: { id: row.familyId },
      });
      timezone = family.timezone;
    }
    return new TransactionalMail(
      eventId,
      userId,
      kind as TransactionalMailKind,
      referenceId,
      state,
      verifiedEmail,
      user.locale,
      timezone,
      deadline,
      storageKey,
    );
  }
  checkpoint(
    eventId: string,
    expected: string,
    state: string,
    lease: JobLease,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      const count =
        await tx.$executeRaw`UPDATE ops.outbox_events SET payload = jsonb_set(payload, '{state}', to_jsonb(${state}::text)) WHERE event_id = ${eventId}::uuid AND event_type = 'mail.transactional' AND deleted_at IS NULL AND payload->>'state' = ${expected}`;
      return count === 1;
    });
  }
  async reconcile(
    now: Date,
    lease: JobLease,
    familyId?: string,
    userId?: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      let planned = 0;
      const accountIds = await tx.$queryRaw<
        { id: string }[]
      >`SELECT d.id FROM app.deletion_requests d WHERE d.deleted_at IS NULL AND d.status = 'SCHEDULED' AND d.execute_after > ${now} AND (${userId ?? null}::uuid IS NULL OR d.user_id = ${userId ?? null}::uuid) AND (${familyId ?? null}::uuid IS NULL OR d.family_id = ${familyId ?? null}::uuid) AND (NOT EXISTS (SELECT 1 FROM ops.outbox_events e WHERE e.event_type = 'mail.transactional' AND e.aggregate_id = d.id AND e.payload->>'kind' = 'ACCOUNT_DELETION_SCHEDULED') OR (d.execute_after <= ${new Date(now.getTime() + POLICY.reminderBeforeMs)} AND NOT EXISTS (SELECT 1 FROM ops.outbox_events e WHERE e.event_type = 'mail.transactional' AND e.aggregate_id = d.id AND e.payload->>'kind' = 'ACCOUNT_DELETION_REMINDER'))) ORDER BY d.execute_after, d.id LIMIT ${POLICY.batchSize}`;
      const accounts = await tx.deletionRequest.findMany({
        where: {
          id: { in: accountIds.map((r) => r.id) },
          userId,
          familyId,
          deletedAt: null,
          status: 'SCHEDULED',
          executeAfter: { gt: now },
        },
        orderBy: { requestedAt: 'asc' },
        take: POLICY.batchSize,
      });
      for (const row of accounts) {
        await enqueueTransactionalMail(
          tx,
          'ACCOUNT_DELETION_SCHEDULED',
          row.userId,
          row.id,
        );
        if (
          row.executeAfter.getTime() - now.getTime() <=
          POLICY.reminderBeforeMs
        )
          await enqueueTransactionalMail(
            tx,
            'ACCOUNT_DELETION_REMINDER',
            row.userId,
            row.id,
          );
        planned++;
      }
      const familyIds = await tx.$queryRaw<
        { id: string }[]
      >`SELECT d.id FROM app.family_deletion_requests d WHERE d.deleted_at IS NULL AND d.status = 'SCHEDULED' AND d.execute_after > ${now} AND (${familyId ?? null}::uuid IS NULL OR d.family_id = ${familyId ?? null}::uuid) AND EXISTS (SELECT 1 FROM app.family_parents p WHERE p.family_id = d.family_id AND p.deleted_at IS NULL AND p.status = 'ACTIVE' AND p.left_at IS NULL AND p.joined_at <= ${now} AND (${userId ?? null}::uuid IS NULL OR p.user_id = ${userId ?? null}::uuid) AND (NOT EXISTS (SELECT 1 FROM ops.outbox_events e WHERE e.event_type = 'mail.transactional' AND e.aggregate_id = d.id AND e.payload->>'userId' = p.user_id::text AND e.payload->>'kind' = 'FAMILY_DELETION_SCHEDULED') OR (d.execute_after <= ${new Date(now.getTime() + POLICY.reminderBeforeMs)} AND NOT EXISTS (SELECT 1 FROM ops.outbox_events e WHERE e.event_type = 'mail.transactional' AND e.aggregate_id = d.id AND e.payload->>'userId' = p.user_id::text AND e.payload->>'kind' = 'FAMILY_DELETION_REMINDER')))) ORDER BY d.execute_after, d.id LIMIT ${POLICY.batchSize}`;
      const families = await tx.familyDeletionRequest.findMany({
        where: {
          id: { in: familyIds.map((r) => r.id) },
          familyId,
          deletedAt: null,
          status: 'SCHEDULED',
          executeAfter: { gt: now },
          ...(userId
            ? {
                family: {
                  familyParents: {
                    some: {
                      userId,
                      status: 'ACTIVE',
                      deletedAt: null,
                      leftAt: null,
                    },
                  },
                },
              }
            : {}),
        },
        orderBy: { createdAt: 'asc' },
        take: POLICY.batchSize,
      });
      for (const row of families) {
        const parents = await tx.familyParent.findMany({
          where: {
            userId,
            familyId: row.familyId,
            status: 'ACTIVE',
            deletedAt: null,
            leftAt: null,
            joinedAt: { lte: now },
          },
        });
        for (const parent of parents) {
          await enqueueTransactionalMail(
            tx,
            'FAMILY_DELETION_SCHEDULED',
            parent.userId,
            row.id,
          );
          if (
            row.executeAfter!.getTime() - now.getTime() <=
            POLICY.reminderBeforeMs
          )
            await enqueueTransactionalMail(
              tx,
              'FAMILY_DELETION_REMINDER',
              parent.userId,
              row.id,
            );
          planned++;
        }
      }
      return planned;
    });
  }
  async pending(limit: number, familyId?: string, userId?: string) {
    const rows = await this.prisma.$queryRaw<
      { event_id: string }[]
    >`SELECT e.event_id FROM ops.outbox_events e WHERE e.event_type = 'mail.transactional' AND e.deleted_at IS NULL AND e.payload->>'state' IN ('READY', 'SENDING') AND (${userId ?? null}::text IS NULL OR e.payload->>'userId' = ${userId ?? null}) AND (${familyId ?? null}::uuid IS NULL OR EXISTS (SELECT 1 FROM app.family_parents p WHERE p.family_id = ${familyId ?? null}::uuid AND p.user_id::text = e.payload->>'userId' AND p.deleted_at IS NULL)) AND NOT EXISTS (SELECT 1 FROM ops.job_runs j WHERE j.idempotency_key = 'mail-event:' || e.event_id::text AND j.status IN ('FAILED', 'SUCCEEDED', 'SKIPPED') AND j.deleted_at IS NULL) ORDER BY e.id LIMIT ${limit}`;
    return rows.map((row) => row.event_id);
  }
  private async assertLease(tx: Prisma.TransactionClient, lease: JobLease) {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR SHARE`;
    if (!rows.length)
      throw new DomainError('Job lease expired.', 'JOB_LEASE_LOST', 409);
  }
}
