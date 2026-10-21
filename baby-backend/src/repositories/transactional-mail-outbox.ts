import { createHash } from 'node:crypto';
import type { Prisma } from '../generated/prisma/client';
import type { TransactionalMailKind } from '../config/transactional-mail-policy';

/** Only called inside the source transaction. No address, phone or content in outbox. */
export async function enqueueTransactionalMail(
  tx: Prisma.TransactionClient,
  kind: TransactionalMailKind,
  userId: string,
  referenceId: string,
  key: string = referenceId,
) {
  const hash = createHash('sha256')
    .update(`mail:v1:${kind}:${userId}:${key}`)
    .digest('hex');
  const eventId = `${hash.slice(0, 8)}-${hash.slice(8, 12)}-5${hash.slice(13, 16)}-a${hash.slice(17, 20)}-${hash.slice(20, 32)}`;
  await tx.outboxEvent.upsert({
    where: { eventId },
    create: {
      eventId,
      eventType: 'mail.transactional',
      aggregateId: referenceId,
      payload: { version: 1, kind, userId, referenceId, state: 'READY' },
    },
    update: {},
  });
}

/** Durable verification evidence; never infer verification from a nullable email alone. */
export async function recordVerifiedIdentityEmail(
  tx: Prisma.TransactionClient,
  identityId: string,
  email: string | null,
) {
  if (!email) return;
  const emailHash = createHash('sha256')
    .update(email.toLowerCase())
    .digest('hex');
  const hash = createHash('sha256')
    .update(`verified-email:v1:${identityId}:${emailHash}`)
    .digest('hex');
  const eventId = `${hash.slice(0, 8)}-${hash.slice(8, 12)}-5${hash.slice(13, 16)}-a${hash.slice(17, 20)}-${hash.slice(20, 32)}`;
  await tx.outboxEvent.upsert({
    where: { eventId },
    create: {
      eventId,
      eventType: 'auth.email_verified',
      aggregateId: identityId,
      payload: { version: 1, emailHash },
    },
    update: {},
  });
}
