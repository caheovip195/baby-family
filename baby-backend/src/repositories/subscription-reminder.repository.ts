import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import { NOTIFICATION_POLICY } from '../config/notification-policy';
import { SUBSCRIPTION_REMINDER_POLICY } from '../config/subscription-reminder-policy';
import type { ISubscriptionReminderRepository } from '../interfaces/repositories/subscription-reminder-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import type {
  SubscriptionReminderState,
  SubscriptionReminderDecision,
} from '../models/subscription-reminder-state.model';

type Tx = Prisma.TransactionClient;
@Injectable()
export class SubscriptionReminderRepository implements ISubscriptionReminderRepository {
  constructor(private readonly prisma: PrismaService) {}

  private async state(
    tx: Tx,
    familyId: string,
    now: Date,
  ): Promise<SubscriptionReminderState | null> {
    const family = await tx.family.findFirst({
      where: { id: familyId, status: 'ACTIVE', deletedAt: null },
      include: { familyLicense: true },
    });
    if (!family) return null;
    const license = family.familyLicense;
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { licenseGrant: { include: { trialPolicy: true } } },
    });
    if (!entitlement || !license || entitlement.licenseId !== license.id)
      return null;
    // Recompute clears sourceGrantId/validUntil when there is no active grant.
    // Recover the ended grant, including its immutable policy, without consulting
    // the currently published catalog policy.
    const grant =
      entitlement.licenseGrant ??
      (await tx.licenseGrant.findFirst({
        where: {
          familyId,
          licenseId: license.id,
          deletedAt: null,
          validFrom: { lte: now },
          ...(entitlement.accessPhase === 'TRIAL' ? { source: 'TRIAL' } : {}),
        },
        include: { trialPolicy: true },
        orderBy: [{ validUntil: 'desc' }, { id: 'asc' }],
      }));
    const trial = grant?.trialPolicy;
    const endedAt = grant
      ? new Date(
          Math.min(
            grant.validUntil.getTime(),
            grant.revokedAt?.getTime() ?? Infinity,
          ),
        )
      : null;
    const expiresAt =
      entitlement.accessPhase === 'TRIAL' &&
      entitlement.trialEndsAt &&
      entitlement.validUntil
        ? new Date(
            Math.min(
              entitlement.trialEndsAt.getTime(),
              entitlement.validUntil.getTime(),
            ),
          )
        : (entitlement.validUntil ??
          (entitlement.accessPhase === 'EXPIRED'
            ? (endedAt ?? entitlement.trialEndsAt)
            : null));
    return {
      familyId,
      timezone: family.timezone,
      phase: entitlement.accessPhase,
      blocked: !!(
        license.deletedAt ||
        license.blockedAt ||
        license.blockReasonCode
      ),
      inGrace: entitlement.inGrace,
      expiresAt,
      trialEndsAt: entitlement.trialEndsAt,
      trial:
        entitlement.accessPhase === 'TRIAL' ||
        (entitlement.accessPhase !== 'PAID' &&
          (grant?.source === 'TRIAL' || (!grant && !!entitlement.trialEndsAt))),
      trialPolicy: trial
        ? {
            id: trial.id,
            code: trial.code,
            version: trial.version,
            durationSeconds: trial.durationSeconds,
            reminderOffsetsSeconds: [...trial.reminderOffsetsSeconds],
          }
        : null,
    };
  }

  findState(
    familyId: string,
    now: Date,
  ): Promise<SubscriptionReminderState | null> {
    return this.prisma.$transaction((tx) => this.state(tx, familyId, now), {
      isolationLevel: 'RepeatableRead',
    });
  }

  private async fence(tx: Tx, context: JobContext): Promise<void> {
    context.signal.throwIfAborted();
    const { lease } = context;
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id=${lease.runId}::uuid AND status='RUNNING' AND fencing_token=${lease.fencingToken} AND lease_owner=${lease.workerId} AND deleted_at IS NULL AND lease_expires_at>clock_timestamp() FOR UPDATE`;
    if (!rows.length) throw new Error('Subscription reminder lease lost.');
  }

  async dispatch(
    now: Date,
    context: JobContext,
    decide: (
      state: SubscriptionReminderState,
    ) => SubscriptionReminderDecision | null,
    familyId?: string,
  ): Promise<number> {
    let cursor: string | undefined;
    let created = 0;
    for (;;) {
      context.signal.throwIfAborted();
      const families = await this.prisma.family.findMany({
        where: {
          ...(familyId ? { id: familyId } : {}),
          status: 'ACTIVE',
          deletedAt: null,
        },
        select: { id: true },
        orderBy: { id: 'asc' },
        take: SUBSCRIPTION_REMINDER_POLICY.batchSize,
        ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
      });
      for (const family of families) {
        created += await this.prisma.$transaction(
          async (tx) => {
            await this.fence(tx, context);
            await tx.$queryRaw`SELECT id FROM app.families WHERE id=${family.id}::uuid FOR SHARE`;
            const state = await this.state(tx, family.id, now);
            if (!state) return 0;
            const decision = decide(state);
            if (!decision) return 0;
            const parents = await tx.familyParent.findMany({
              where: {
                familyId: family.id,
                status: 'ACTIVE',
                leftAt: null,
                joinedAt: { lte: now },
                deletedAt: null,
                user: { status: 'ACTIVE', deletedAt: null },
              },
              include: { user: true },
              orderBy: { userId: 'asc' },
            });
            // Do not send reminders to families that have not completed activation.
            if (parents.length !== 2) return 0;
            let count = 0;
            for (const parent of parents) {
              const key = {
                eventId: decision.eventId,
                recipientUserId: parent.userId,
                templateCode: decision.templateCode,
              };
              // Include dismissed/deleted inbox rows: the uniqueness ledger must survive hiding.
              if (
                await tx.notification.findUnique({
                  where: { eventId_recipientUserId_templateCode: key },
                })
              )
                continue;
              await tx.notification.create({
                data: {
                  ...key,
                  familyId: family.id,
                  category: 'BILLING',
                  locale: parent.user.locale,
                  subjectType: 'subscription_billing',
                  subjectId: family.id,
                  sensitive: false,
                  payloadReference: {
                    params: { familyId: family.id },
                    tab: 'FAMILY',
                    deepLink: `babyfamily://families/${family.id}/billing`,
                    policyVersion: SUBSCRIPTION_REMINDER_POLICY.version,
                    expiresAt: state.expiresAt!.toISOString(),
                    offsetSeconds: decision.offsetSeconds,
                  },
                  expiresAt: new Date(
                    now.getTime() +
                      NOTIFICATION_POLICY.retentionDays * 86400000,
                  ),
                  notificationDeliveries: {
                    create: {
                      channel: 'PUSH',
                      targetKey: 'user',
                      status: 'PENDING',
                      nextAttemptAt: now,
                    },
                  },
                },
              });
              count++;
            }
            await this.fence(tx, context);
            return count;
          },
          { timeout: 15000 },
        );
      }
      if (familyId || families.length < SUBSCRIPTION_REMINDER_POLICY.batchSize)
        break;
      cursor = families.at(-1)!.id;
    }
    return created;
  }
}
