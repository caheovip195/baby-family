import { Injectable, Logger } from '@nestjs/common';
import { PUSH_POLICY, pushTimezone } from '../config/push-policy';
import { PrismaService } from '../database/prisma.service';
import type { Prisma, Notification } from '../generated/prisma/client';
import { PushCandidate } from '../interfaces/repositories/push-delivery-repository.interface';
import type {
  IPushDeliveryRepository,
  PushDecision,
} from '../interfaces/repositories/push-delivery-repository.interface';
import type { PushSendResult } from '../interfaces/services/push-sender.interface';
import type { JobLease } from '../models/job-lease.model';

const MEMORY_REVIEW_TEMPLATES = [
  'NOTI_MEMORY_REVIEW_REQUESTED',
  'NOTI_MEMORY_APPROVED',
  'NOTI_MEMORY_REJECTED',
] as const;
const isMemoryReview = (code: string): boolean =>
  MEMORY_REVIEW_TEMPLATES.some((template) => template === code);
type Tx = Prisma.TransactionClient;
const object = (v: unknown): Record<string, unknown> =>
  v !== null && typeof v === 'object' && !Array.isArray(v)
    ? (v as Record<string, unknown>)
    : {};
@Injectable()
export class PushDeliveryRepository implements IPushDeliveryRepository {
  private readonly logger = new Logger(PushDeliveryRepository.name);
  constructor(private readonly prisma: PrismaService) {}
  private async fence(tx: Tx, lease: JobLease): Promise<void> {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id=${lease.runId}::uuid AND status='RUNNING' AND fencing_token=${lease.fencingToken} AND lease_owner=${lease.workerId} AND deleted_at IS NULL AND lease_expires_at>clock_timestamp() FOR UPDATE`;
    if (!rows.length) throw new Error('Push lease lost.');
  }
  async claim(
    now: Date,
    lease: JobLease,
    decide: (c: PushCandidate) => PushDecision,
  ): Promise<PushCandidate | null> {
    await this.prisma.$transaction(
      async (tx) => {
        await this.fence(tx, lease);
        // Close attempts abandoned by a dead/lost owner. FCM has no idempotency
        // key: unknown outcomes are terminal and need operator reconciliation.
        // Rows are locked in id order with SKIP LOCKED first: two concurrent
        // claimers never wait on each other here (an unordered multi-row UPDATE
        // deadlocked them); a row skipped now is closed by a later claim.
        const abandoned = await tx.$queryRaw<{ id: string }[]>`
        WITH stale AS (
          SELECT d.id FROM app.notification_deliveries d
          WHERE d.channel='PUSH' AND d.deleted_at IS NULL AND d.status='CANCELLED' AND d.last_error_code='SEND_IN_FLIGHT'
            AND NOT EXISTS (
              SELECT 1 FROM ops.job_runs j JOIN app.notification_delivery_attempts a ON a.delivery_id=d.id AND a.attempt_number=d.attempts
              WHERE j.id::text=d.provider_message_id AND j.status='RUNNING' AND j.deleted_at IS NULL
                AND j.lease_expires_at>clock_timestamp() AND a.deleted_at IS NULL AND j.fencing_token::text=a.provider_status_code
            )
          ORDER BY d.id
          FOR UPDATE OF d SKIP LOCKED
        )
        UPDATE app.notification_deliveries d SET status='FAILED', last_error_code='DELIVERY_UNKNOWN'
        FROM stale WHERE d.id=stale.id
        RETURNING d.id`;
        if (abandoned.length) {
          await tx.notificationDeliveryAttempt.updateMany({
            where: {
              deliveryId: { in: abandoned.map((r) => r.id) },
              finishedAt: null,
              deletedAt: null,
            },
            data: {
              finishedAt: now,
              outcome: 'UNKNOWN',
              errorCode: 'DELIVERY_UNKNOWN',
            },
          });
          this.logger.error(
            `Push delivery unknown outcomes: ${abandoned.length}`,
          );
        }
      },
      { timeout: 15000 },
    );
    // One delivery (and so at most one recipient user lock) per transaction.
    // Scanning many deliveries in one transaction locked users in arbitrary
    // order and deadlocked concurrent claimers (40P01); skip/cancel decisions
    // are each final on their own and committed under a live lease.
    for (let scan = 0; scan < PUSH_POLICY.batchSize; scan++) {
      const outcome = await this.prisma.$transaction(
        (tx) => this.claimNext(tx, now, lease, decide),
        { timeout: 15000 },
      );
      if (outcome !== 'next') return outcome;
    }
    return null;
  }
  private async claimNext(
    tx: Tx,
    now: Date,
    lease: JobLease,
    decide: (c: PushCandidate) => PushDecision,
  ): Promise<PushCandidate | null | 'next'> {
    await this.fence(tx, lease);
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM app.notification_deliveries WHERE channel='PUSH' AND status IN ('PENDING','RETRY_WAIT') AND deleted_at IS NULL AND next_attempt_at<=${now} ORDER BY next_attempt_at,id FOR UPDATE SKIP LOCKED LIMIT 1`;
    if (!rows[0]) return null;
    const d = await tx.notificationDelivery.findUniqueOrThrow({
      where: { id: rows[0].id },
      include: { notification: true },
    });
    const n = d.notification;
    await tx.$queryRaw`SELECT id FROM app.users WHERE id=${n.recipientUserId}::uuid FOR UPDATE`;
    const cancel = async (code: string) => {
      await tx.notificationDelivery.update({
        where: { id: d.id },
        data: {
          status: 'CANCELLED',
          lastErrorCode: code,
          nextAttemptAt: null,
        },
      });
    };
    if (!(await this.canView(tx, n, now))) {
      await cancel('ACCESS_REVOKED');
      return 'next';
    }
    const user = await tx.user.findFirst({
      where: { id: n.recipientUserId, deletedAt: null, status: 'ACTIVE' },
    });
    if (!user) {
      await cancel('USER_INACTIVE');
      return 'next';
    }
    const setting = await tx.userSetting.findFirst({
      where: { userId: user.id, deletedAt: null },
    });
    const prefs = object(setting?.notificationPrefs),
      categories = object(prefs.categories);
    const reference = object(n.payloadReference);
    const params = await this.currentParams(tx, n, object(reference.params));
    const actor =
      typeof params.actorUserId === 'string' ? params.actorUserId : '';
    const disabled = [
      prefs[n.category],
      categories[n.category],
      ...(n.category === 'MEMORIES' ? [prefs.MEMORY, categories.MEMORY] : []),
    ].includes(false);
    const muted = ['mutedUserIds', 'blockedUserIds'].some(
      (k) => Array.isArray(prefs[k]) && (prefs[k] as unknown[]).includes(actor),
    );
    const blocked = actor
      ? await tx.block.count({
          where: {
            deletedAt: null,
            familyId: n.familyId ?? undefined,
            OR: [
              { blockerUserId: user.id, blockedUserId: actor },
              { blockerUserId: actor, blockedUserId: user.id },
            ],
          },
        })
      : 0;
    if (disabled || muted || blocked) {
      await cancel('PREFERENCES_DISABLED');
      return 'next';
    }
    if (!d.deviceId) {
      const devices = await tx.userDevice.findMany({
        where: {
          userId: user.id,
          deletedAt: null,
          pushEnabled: true,
          pushToken: { not: null },
        },
      });
      for (const device of devices)
        await tx.notificationDelivery.upsert({
          where: {
            notificationId_channel_targetKey: {
              notificationId: n.id,
              channel: 'PUSH',
              targetKey: device.id,
            },
          },
          create: {
            notificationId: n.id,
            channel: 'PUSH',
            deviceId: device.id,
            targetKey: device.id,
            nextAttemptAt: now,
          },
          update: {},
        });
      await cancel(devices.length ? 'EXPANDED_TO_DEVICES' : 'NO_ACTIVE_DEVICE');
      return 'next';
    }
    const device = await tx.userDevice.findFirst({
      where: {
        id: d.deviceId,
        userId: user.id,
        deletedAt: null,
        pushEnabled: true,
        pushToken: { not: null },
      },
    });
    if (!device?.pushToken) {
      await cancel('DEVICE_DISABLED');
      return 'next';
    }
    const locale = device.locale ?? user.locale ?? n.locale;
    const templates = await tx.notificationTemplate.findMany({
      where: {
        code: n.templateCode,
        locale: { in: [locale, locale.split('-')[0] ?? locale, 'vi'] },
        enabled: true,
        deletedAt: null,
      },
    });
    const template =
      templates.find((t) => t.locale === locale) ??
      templates.find((t) => t.locale === locale.split('-')[0]) ??
      templates.find((t) => t.locale === 'vi');
    if (!template) {
      await cancel('TEMPLATE_UNAVAILABLE');
      return 'next';
    }
    const zone = pushTimezone(device.timezone ?? user.timezone);
    const day = (date: Date) =>
      new Intl.DateTimeFormat('en-CA', { timeZone: zone }).format(date);
    const sent = await tx.notificationDelivery.findMany({
      where: {
        channel: 'PUSH',
        deletedAt: null,
        notification: {
          recipientUserId: user.id,
          category: { not: 'REQUESTS' },
          priority: 'NORMAL',
        },
        OR: [
          {
            status: 'SENT',
            sentAt: { gte: new Date(now.getTime() - 36 * 3600000) },
          },
          {
            status: { in: ['CANCELLED', 'FAILED'] },
            lastErrorCode: { in: ['SEND_IN_FLIGHT', 'DELIVERY_UNKNOWN'] },
            updatedAt: { gte: new Date(now.getTime() - 36 * 3600000) },
          },
        ],
      },
      select: { notificationId: true, sentAt: true, updatedAt: true },
    });
    // Multiple devices consume one user-level notification budget.
    const counted = new Set(
      sent
        .filter((s) => day(s.sentAt ?? s.updatedAt) === day(now))
        .map((s) => s.notificationId),
    );
    const quiet = await tx.moodCheckin.findFirst({
      where: {
        userId: user.id,
        familyId: n.familyId ?? undefined,
        deletedAt: null,
        shared: true,
        sharedFields: { has: 'needs' },
        needs: { has: 'QUIET' },
        expiresAt: { gt: now },
      },
      orderBy: { expiresAt: 'desc' },
    });
    let bypass = false;
    if (
      n.category === 'REQUESTS' &&
      n.priority === 'HIGH' &&
      setting?.requestSoonBypassQuiet &&
      n.subjectId
    ) {
      const request = await tx.request.findFirst({
        where: {
          id: n.subjectId,
          familyId: n.familyId ?? undefined,
          deletedAt: null,
          receiverUserId: user.id,
          urgency: 'SOON',
        },
      });
      bypass = !!request && n.templateCode === 'NOTI_REQUEST_CREATED';
    }
    const c = new PushCandidate(
      d.id,
      d.attempts + 1,
      device.pushToken,
      locale,
      zone,
      n.id,
      n.category,
      n.priority,
      n.sensitive || template.sensitive,
      typeof reference.deepLink === 'string'
        ? reference.deepLink
        : 'babyfamily://notifications',
      params,
      template.title,
      template.body,
      template.hiddenTitle,
      template.hiddenBody,
      setting?.quietStart.toISOString().slice(11, 16) ?? PUSH_POLICY.quietStart,
      setting?.quietEnd.toISOString().slice(11, 16) ?? PUSH_POLICY.quietEnd,
      quiet?.expiresAt ?? null,
      bypass,
      counted.has(n.id) ? 0 : counted.size,
    );
    if (d.attempts >= PUSH_POLICY.maxAttempts) {
      await tx.notificationDelivery.update({
        where: { id: d.id },
        data: {
          status: 'FAILED',
          lastErrorCode: 'ATTEMPTS_EXHAUSTED',
          nextAttemptAt: null,
        },
      });
      return 'next';
    }
    const decision = decide(c);
    if (decision.action === 'skip') {
      await cancel(decision.code);
      return 'next';
    }
    if (decision.action === 'delay') {
      await tx.notificationDelivery.update({
        where: { id: d.id },
        data: { nextAttemptAt: decision.at },
      });
      return 'next';
    }
    await tx.notificationDelivery.update({
      where: { id: d.id },
      data: {
        status: 'CANCELLED',
        lastErrorCode: 'SEND_IN_FLIGHT',
        providerMessageId: lease.runId,
        attempts: c.attempt,
        nextAttemptAt: null,
      },
    });
    await tx.notificationDeliveryAttempt.create({
      data: {
        deliveryId: d.id,
        attemptNumber: c.attempt,
        startedAt: now,
        providerStatusCode: String(lease.fencingToken),
      },
    });
    return c;
  }
  async finish(
    c: PushCandidate,
    result: PushSendResult,
    now: Date,
    lease: JobLease,
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.fence(tx, lease);
      const d = await tx.notificationDelivery.findFirst({
        where: {
          id: c.id,
          status: 'CANCELLED',
          lastErrorCode: 'SEND_IN_FLIGHT',
          attempts: c.attempt,
        },
      });
      if (!d) return;
      const retry =
        result.status === 'transient' && c.attempt < PUSH_POLICY.maxAttempts;
      const code = result.status === 'sent' ? null : result.code;
      await tx.notificationDelivery.update({
        where: { id: c.id },
        data: {
          status:
            result.status === 'sent'
              ? 'SENT'
              : retry
                ? 'RETRY_WAIT'
                : result.status === 'disabled'
                  ? 'CANCELLED'
                  : 'FAILED',
          sentAt: result.status === 'sent' ? now : null,
          providerMessageId: result.status === 'sent' ? result.messageId : null,
          lastErrorCode:
            result.status === 'invalid-token' ? 'FAILED_PERMANENT' : code,
          nextAttemptAt: retry
            ? new Date(
                now.getTime() + PUSH_POLICY.backoffMs * 2 ** (c.attempt - 1),
              )
            : null,
        },
      });
      await tx.notificationDeliveryAttempt.update({
        where: {
          deliveryId_attemptNumber: {
            deliveryId: c.id,
            attemptNumber: c.attempt,
          },
        },
        data: {
          finishedAt: now,
          outcome: result.status === 'sent' ? 'SENT' : 'FAILED',
          errorCode: code,
          providerStatusCode: result.status === 'sent' ? 'OK' : code,
        },
      });
      if (!retry && result.status !== 'sent' && result.status !== 'disabled')
        this.logger.error(
          `Push delivery failed permanently: ${code ?? 'UNKNOWN'}`,
        );
      if (result.status === 'invalid-token' && d.deviceId)
        await tx.userDevice.updateMany({
          where: { id: d.deviceId, pushToken: c.token },
          data: { pushToken: null },
        });
    });
  }
  private async currentParams(
    tx: Tx,
    n: Notification,
    original: Record<string, unknown>,
  ): Promise<Record<string, unknown>> {
    if (isMemoryReview(n.templateCode))
      return Object.fromEntries(
        Object.entries(original).filter(
          ([key, value]) =>
            ['actorUserId', 'familyId', 'entityId'].includes(key) &&
            typeof value === 'string',
        ),
      );
    if (n.subjectType !== 'memory' || !n.subjectId || !n.familyId)
      return original;
    const parent = await tx.familyParent.count({
      where: {
        familyId: n.familyId,
        userId: n.recipientUserId,
        status: 'ACTIVE',
        deletedAt: null,
      },
    });
    const grants = parent
      ? []
      : await tx.circleGrant.findMany({
          where: {
            familyId: n.familyId,
            status: 'ACTIVE',
            deletedAt: null,
            circleMember: {
              userId: n.recipientUserId,
              status: 'ACTIVE',
              deletedAt: null,
            },
          },
        });
    const children = await tx.memoryChild.findMany({
      where: {
        memoryId: n.subjectId,
        deletedAt: null,
        child: { status: 'ACTIVE', deletedAt: null },
      },
      include: { child: true },
    });
    const visible = children.filter(
      (c) => parent || grants.some((g) => g.childId === c.childId),
    );
    return {
      ...original,
      childIds: visible.map((c) => c.childId),
      childNames: visible.map((c) => c.child.nickname ?? c.child.name ?? ''),
    };
  }
  private async canView(tx: Tx, n: Notification, now: Date): Promise<boolean> {
    if (
      n.deletedAt ||
      n.dismissedAt ||
      (n.expiresAt && n.expiresAt <= now) ||
      !n.familyId
    )
      return false;
    if (
      !(await tx.family.findFirst({
        where: { id: n.familyId, status: 'ACTIVE', deletedAt: null },
      }))
    )
      return false;
    const parent = await tx.familyParent.findFirst({
      where: {
        familyId: n.familyId,
        userId: n.recipientUserId,
        status: 'ACTIVE',
        leftAt: null,
        joinedAt: { lte: now },
        deletedAt: null,
        family: { deletedAt: null, status: 'ACTIVE' },
      },
    });
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId: n.familyId, deletedAt: null },
      include: { familyLicense: true },
    });
    const license = entitlement?.familyLicense;
    const active =
      !!entitlement &&
      !!license &&
      !license.deletedAt &&
      !license.blockedAt &&
      !license.blockReasonCode &&
      ['TRIAL', 'PAID'].includes(entitlement.accessPhase) &&
      !!entitlement.validUntil &&
      entitlement.validUntil > now &&
      (entitlement.accessPhase !== 'TRIAL' ||
        (!!entitlement.trialEndsAt && entitlement.trialEndsAt > now));
    if (n.subjectType === 'subscription_billing' && n.category === 'BILLING') {
      if (
        !parent ||
        !entitlement ||
        !license ||
        license.deletedAt ||
        license.blockedAt ||
        license.blockReasonCode ||
        ['INCOMPLETE', 'BLOCKED'].includes(entitlement.accessPhase)
      )
        return false;
      const reference = object(n.payloadReference);
      let currentExpiry =
        entitlement.accessPhase === 'TRIAL' &&
        entitlement.trialEndsAt &&
        entitlement.validUntil
          ? new Date(
              Math.min(
                entitlement.trialEndsAt.getTime(),
                entitlement.validUntil.getTime(),
              ),
            )
          : entitlement.validUntil;
      if (!currentExpiry && entitlement.accessPhase === 'EXPIRED') {
        const ended = await tx.licenseGrant.findFirst({
          where: {
            familyId: n.familyId,
            licenseId: license.id,
            deletedAt: null,
            validFrom: { lte: now },
          },
          orderBy: [{ validUntil: 'desc' }, { id: 'asc' }],
        });
        currentExpiry = ended
          ? new Date(
              Math.min(
                ended.validUntil.getTime(),
                ended.revokedAt?.getTime() ?? Infinity,
              ),
            )
          : entitlement.trialEndsAt;
      }
      if (!currentExpiry || reference.expiresAt !== currentExpiry.toISOString())
        return false;
      if (
        ['NOTI_TRIAL_EXPIRED', 'NOTI_SUBSCRIPTION_EXPIRED'].includes(
          n.templateCode,
        )
      )
        return !active;
      if (n.templateCode === 'NOTI_SUBSCRIPTION_GRACE')
        return active && entitlement.inGrace;
      return (
        active &&
        (n.templateCode === 'NOTI_TRIAL_ENDING'
          ? entitlement.accessPhase === 'TRIAL'
          : entitlement.accessPhase === 'PAID')
      );
    }
    if (!active) return false;
    if (
      n.subjectType === 'memory' &&
      n.subjectId &&
      isMemoryReview(n.templateCode)
    ) {
      const submitted = n.templateCode === 'NOTI_MEMORY_REVIEW_REQUESTED';
      const memory = await tx.memory.findFirst({
        where: {
          id: n.subjectId,
          familyId: n.familyId,
          authorRole: 'CIRCLE',
          deletedAt: null,
          trashedAt: null,
          status: submitted
            ? 'PENDING_REVIEW'
            : n.templateCode === 'NOTI_MEMORY_APPROVED'
              ? { in: ['PROCESSING', 'PUBLISHED'] }
              : 'REJECTED',
        },
      });
      if (!memory) return false;
      if (submitted) return !!parent;
      if (!memory.reviewedAt || memory.authorUserId !== n.recipientUserId)
        return false;
      return !!(await tx.circleMember.findFirst({
        where: {
          familyId: n.familyId,
          userId: n.recipientUserId,
          status: 'ACTIVE',
          endedAt: null,
          joinedAt: { lte: now },
          deletedAt: null,
        },
      }));
    }
    if (n.subjectType === 'memory' && n.subjectId) {
      const m = await tx.memory.findFirst({
        where: {
          id: n.subjectId,
          familyId: n.familyId,
          deletedAt: null,
          trashedAt: null,
          status: 'PUBLISHED',
        },
        include: {
          memoryChildren: {
            where: { deletedAt: null },
            include: { child: true },
          },
        },
      });
      if (!m || (m.unlockAt && m.unlockAt > now)) return false;
      if (m.visibility === 'PRIVATE')
        return !!parent && m.authorUserId === n.recipientUserId;
      if (parent) return true;
      if (m.visibility !== 'FAMILY' || m.pregnancyId) return false;
      const ids = m.memoryChildren
        .filter((c) => !c.child.deletedAt && c.child.status === 'ACTIVE')
        .map((c) => c.childId);
      return !!(await tx.circleMember.findFirst({
        where: {
          familyId: n.familyId,
          userId: n.recipientUserId,
          status: 'ACTIVE',
          joinedAt: { lte: now },
          deletedAt: null,
          ...(ids.length
            ? {
                circleGrants: {
                  some: {
                    status: 'ACTIVE',
                    deletedAt: null,
                    childId: { in: ids },
                  },
                },
              }
            : m.familyMoment
              ? {}
              : { id: '00000000-0000-0000-0000-000000000000' }),
        },
      }));
    }
    if (n.subjectType === 'calendar_event') {
      const event = await tx.event.findFirst({
        where: { id: n.subjectId ?? '', familyId: n.familyId, deletedAt: null },
        include: {
          eventChildren: {
            where: {
              deletedAt: null,
              child: { status: 'ACTIVE', deletedAt: null },
            },
          },
        },
      });
      if (!event || (event.type === 'COUPLE' && !n.sensitive)) return false;
      if (parent) return true;
      if (!event.inviteCircle || event.type === 'COUPLE') return false;
      return !!(await tx.circleMember.findFirst({
        where: {
          userId: n.recipientUserId,
          familyId: n.familyId,
          status: 'ACTIVE',
          joinedAt: { lte: now },
          deletedAt: null,
          circleGrants: {
            some: {
              status: 'ACTIVE',
              deletedAt: null,
              childId: { in: event.eventChildren.map((c) => c.childId) },
            },
          },
        },
      }));
    }
    if (!parent) return false;
    if (n.subjectType === 'us') {
      const pair = await tx.coupleSpace.findFirst({
        where: {
          familyId: n.familyId,
          status: 'ACTIVE',
          deletedAt: null,
          disabledAt: null,
        },
      });
      if (
        !pair ||
        ![pair.parentAUserId, pair.parentBUserId].includes(n.recipientUserId)
      )
        return false;
      const count = await tx.familyParent.count({
        where: {
          familyId: n.familyId,
          userId: { in: [pair.parentAUserId, pair.parentBUserId] },
          status: 'ACTIVE',
          deletedAt: null,
        },
      });
      if (count !== 2) return false;
      if (n.category === 'REQUESTS')
        return !!(await tx.request.findFirst({
          where: {
            id: n.subjectId ?? '',
            familyId: n.familyId,
            coupleSpaceId: pair.id,
            deletedAt: null,
            OR: [
              { senderUserId: n.recipientUserId },
              { receiverUserId: n.recipientUserId },
            ],
          },
        }));
      if (n.category === 'APPRECIATION')
        return !!(await tx.appreciation.findFirst({
          where: {
            id: n.subjectId ?? '',
            familyId: n.familyId,
            coupleSpaceId: pair.id,
            deletedAt: null,
            deletedByToAt: null,
            deletedByFromAt: null,
            toUserId: n.recipientUserId,
          },
        }));
      return !!(await tx.moodCheckin.findFirst({
        where: {
          id: n.subjectId ?? '',
          familyId: n.familyId,
          coupleSpaceId: pair.id,
          deletedAt: null,
          shared: true,
          expiresAt: { gt: now },
        },
      }));
    }
    // Unknown subject types fail closed; badges are inbox-only.
    return false;
  }
}
