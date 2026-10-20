import { Injectable } from '@nestjs/common';
import { NOTIFICATION_POLICY } from '../config/notification-policy';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { Notification } from '../generated/prisma/client';
import type {
  INotificationInboxRepository,
  NotificationInboxQuery,
  NotificationReadInput,
} from '../interfaces/repositories/notification-inbox-repository.interface';
import type { JobLease } from '../models/job-lease.model';
import { NotificationInboxModel } from '../models/notification-inbox.model';
import {
  NotificationDispatchSnapshot,
  NotificationRecipient,
} from '../models/notification-inbox-dispatch.model';
import type { NotificationDispatchDecision } from '../models/notification-inbox-dispatch.model';

type Tx = Prisma.TransactionClient;
const DAY = 86_400_000;
const object = (value: unknown): Record<string, unknown> =>
  value !== null && typeof value === 'object' && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : {};
const string = (value: unknown): string =>
  typeof value === 'string' ? value : '';

@Injectable()
export class NotificationInboxRepository implements INotificationInboxRepository {
  constructor(private readonly prisma: PrismaService) {}

  private visible(userId: string): Prisma.NotificationWhereInput {
    const now = new Date();
    return {
      recipientUserId: userId,
      deletedAt: null,
      dismissedAt: null,
      createdAt: {
        gte: new Date(now.getTime() - NOTIFICATION_POLICY.retentionDays * DAY),
      },
      AND: [
        { OR: [{ expiresAt: null }, { expiresAt: { gt: now } }] },
        // Apply the entitlement fence before pagination, counts and read updates.
        // Billing remains available to current Parents so renewal reminders survive expiry.
        {
          OR: [
            { familyId: null },
            {
              category: 'BILLING',
              family: {
                deletedAt: null,
                status: { not: 'DELETED' },
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
            {
              category: { not: 'BILLING' },
              family: {
                deletedAt: null,
                status: 'ACTIVE',
                familyLicense: {
                  is: {
                    deletedAt: null,
                    blockedAt: null,
                    blockReasonCode: null,
                  },
                },
                familyEntitlement: {
                  is: {
                    deletedAt: null,
                    validUntil: { gt: now },
                    OR: [
                      { accessPhase: 'PAID' },
                      { accessPhase: 'TRIAL', trialEndsAt: { gt: now } },
                    ],
                  },
                },
                OR: [
                  {
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
                  {
                    circleMembers: {
                      some: {
                        userId,
                        status: 'ACTIVE',
                        deletedAt: null,
                        endedAt: null,
                        joinedAt: { lte: now },
                      },
                    },
                    familyEntitlement: {
                      is: {
                        planVersion: {
                          is: {
                            deletedAt: null,
                            features: {
                              path: ['circle.enabled'],
                              equals: true,
                            },
                          },
                        },
                      },
                    },
                  },
                ],
              },
            },
          ],
        },
        // Private couple categories are never readable by a Circle recipient.
        {
          OR: [
            { category: { notIn: ['REQUESTS', 'US', 'APPRECIATION'] } },
            {
              family: {
                familyParents: {
                  some: { userId, status: 'ACTIVE', deletedAt: null },
                },
              },
            },
          ],
        },
      ],
    };
  }

  async list(userId: string, query: NotificationInboxQuery) {
    const where = this.visible(userId);
    const and = [...(where.AND as Prisma.NotificationWhereInput[])];
    if (query.tab)
      and.push({
        category:
          query.tab === 'US'
            ? { in: ['REQUESTS', 'US', 'APPRECIATION'] }
            : { notIn: ['REQUESTS', 'US', 'APPRECIATION'] },
      });
    if (query.cursor) {
      const cursor = await this.prisma.notification.findFirst({
        where: { ...where, id: query.cursor },
      });
      if (!cursor) return { items: [], nextCursor: null };
      and.push({
        OR: [
          { createdAt: { lt: cursor.createdAt } },
          { createdAt: cursor.createdAt, id: { lt: cursor.id } },
        ],
      });
    }
    const limit = query.limit ?? 20;
    const rows = await this.prisma.notification.findMany({
      where: { ...where, AND: and },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
    });
    const page = rows.slice(0, limit);
    return {
      items: page.map((row) => this.view(row)),
      nextCursor: rows.length > limit ? page.at(-1)!.id : null,
    };
  }
  unreadCount(userId: string): Promise<number> {
    return this.prisma.notification.count({
      where: { ...this.visible(userId), readAt: null },
    });
  }
  async markRead(
    userId: string,
    input: NotificationReadInput,
  ): Promise<number> {
    const result = await this.prisma.notification.updateMany({
      where: {
        ...this.visible(userId),
        readAt: null,
        ...(input.all ? {} : { id: { in: input.ids ?? [] } }),
      },
      data: { readAt: new Date() },
    });
    return result.count;
  }
  private view(row: Notification): NotificationInboxModel {
    const reference = object(row.payloadReference);
    const raw = object(reference.params);
    const params: Record<string, string | string[] | number> = {};
    // Never return arbitrary persisted JSON or rendered content.
    // Event reminders (BF-20261018-013): ids/time only; title only when not sensitive.
    // Badges (BF-20261018-014): catalog code only.
    const reminderKeys =
      row.templateCode === 'NOTI_EVENT_REMINDER'
        ? ['eventId', 'eventType', 'occurrenceAt', 'offsetMinutes']
        : row.templateCode === 'NOTI_BADGE_EARNED'
          ? ['badgeCode']
          : [];
    const keys = row.sensitive
      ? ['actorUserId', 'familyId', 'entityId', ...reminderKeys]
      : [
          'actorUserId',
          'familyId',
          'entityId',
          'childIds',
          'childNames',
          'actorName',
          ...reminderKeys,
          ...(row.templateCode === 'NOTI_EVENT_REMINDER' ? ['title'] : []),
        ];
    for (const key of keys) {
      const value = raw[key];
      if (
        typeof value === 'string' ||
        (typeof value === 'number' && Number.isFinite(value)) ||
        (Array.isArray(value) &&
          value.every((item) => typeof item === 'string'))
      )
        params[key] = value;
    }
    if (typeof reference.count === 'number') params.count = reference.count;
    const tab = ['REQUESTS', 'US', 'APPRECIATION'].includes(row.category)
      ? 'US'
      : 'FAMILY';
    const deepLink =
      row.subjectType === 'memory'
        ? `babyfamily://memories/${row.subjectId}`
        : row.subjectType === 'calendar_event'
          ? `babyfamily://calendar/events/${row.subjectId}`
          : row.subjectType === 'badge'
            ? 'babyfamily://care/badges'
            : 'babyfamily://us';
    return new NotificationInboxModel(
      row.id,
      tab,
      row.category,
      row.templateCode,
      params,
      row.createdAt,
      row.readAt,
      deepLink,
    );
  }

  async consume(
    eventId: string,
    lease: JobLease,
    decide: (
      snapshot: NotificationDispatchSnapshot,
    ) => NotificationDispatchDecision[],
  ): Promise<number> {
    return this.prisma.$transaction(
      async (tx) => {
        const owned = await tx.$queryRaw<
          { id: string }[]
        >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_expires_at > now() FOR UPDATE`;
        if (!owned.length) throw new Error('Notification job lease lost.');
        await tx.$queryRaw`SELECT event_id FROM ops.outbox_events WHERE event_id = ${eventId}::uuid FOR UPDATE`;
        const event = await tx.outboxEvent.findFirst({
          where: { eventId, deletedAt: null },
        });
        if (!event?.familyId || !event.aggregateId) return 0;
        // Ledger rows (including grouped source rows) survive retries and inbox hiding.
        if (await tx.notification.count({ where: { eventId } })) return 0;
        const snapshot = await this.snapshot(tx, event);
        if (!snapshot) return 0;
        // Lock sorted users so separate events cannot race grouping or daily reservations.
        const ids = snapshot.candidates.map((c) => c.userId).sort();
        if (ids.length)
          await tx.$queryRaw`SELECT id FROM app.users WHERE id = ANY(${ids}::uuid[]) ORDER BY id FOR UPDATE`;
        let count = 0;
        for (const decision of decide(snapshot)) {
          const recipient = snapshot.candidates.find(
            (c) => c.userId === decision.recipientUserId && c.canView,
          );
          if (
            !recipient ||
            (decision.tab === 'US' && recipient.role !== 'PARENT')
          )
            continue;
          await this.persist(tx, snapshot, recipient, decision);
          count++;
        }
        return count;
      },
      { timeout: 15000 },
    );
  }

  private async snapshot(
    tx: Tx,
    event: {
      eventId: string;
      eventType: string;
      familyId: string | null;
      aggregateId: string | null;
      payload: unknown;
      createdAt: Date;
    },
  ): Promise<NotificationDispatchSnapshot | null> {
    const familyId = event.familyId!;
    const payload = object(event.payload);
    const now = new Date();
    const parents = await tx.familyParent.findMany({
      where: { familyId, status: 'ACTIVE', deletedAt: null },
      select: { userId: true },
    });
    const parentIds = parents.map((p) => p.userId);
    const circles = await tx.circleMember.findMany({
      where: { familyId, status: 'ACTIVE', deletedAt: null },
      include: {
        circleGrants: { where: { status: 'ACTIVE', deletedAt: null } },
      },
    });
    const blocks = await tx.block.findMany({
      where: { familyId, deletedAt: null },
    });
    let subjectId = event.aggregateId!,
      actorUserId = '',
      target = '',
      author = '',
      participants: string[] = [],
      validIds: string[],
      childIds: string[] = [],
      childNames: string[] = [],
      urgency: 'NORMAL' | 'SOON' = 'NORMAL',
      requestKind: 'TASK' | 'NEED' = 'TASK';
    if (
      [
        'memory.review_requested',
        'memory.submitted',
        'memory.approved',
        'memory.rejected',
      ].includes(event.eventType)
    ) {
      // Review outcomes concern the submitter, even while media is PROCESSING or
      // after rejection. Never require publication or expose the rejected content.
      const submitted = [
        'memory.review_requested',
        'memory.submitted',
      ].includes(event.eventType);
      const memory = await tx.memory.findFirst({
        where: {
          id: subjectId,
          familyId,
          authorRole: 'CIRCLE',
          deletedAt: null,
          trashedAt: null,
          status: submitted
            ? 'PENDING_REVIEW'
            : event.eventType === 'memory.approved'
              ? { in: ['PROCESSING', 'PUBLISHED'] }
              : 'REJECTED',
        },
      });
      if (!memory) return null;
      author = memory.authorUserId;
      actorUserId = submitted ? author : (memory.reviewedBy ?? '');
      if (!submitted && !memory.reviewedAt) return null;
      validIds = submitted ? parentIds : [author];
    } else if (
      event.eventType.startsWith('memory.') ||
      event.eventType === 'comment.created' ||
      event.eventType === 'reaction.changed'
    ) {
      subjectId = string(payload.memoryId) || subjectId;
      const memory = await tx.memory.findFirst({
        where: {
          id: subjectId,
          familyId,
          status: 'PUBLISHED',
          deletedAt: null,
          trashedAt: null,
        },
        include: {
          memoryChildren: {
            where: { deletedAt: null },
            include: { child: true },
          },
        },
      });
      if (!memory || (memory.unlockAt && memory.unlockAt > now)) return null;
      author = memory.authorUserId;
      actorUserId =
        string(payload.authorUserId) || string(payload.userId) || author;
      const children = memory.memoryChildren.filter((c) => !c.child.deletedAt);
      childIds = children.map((c) => c.childId);
      childNames = children.map((c) => c.child.nickname ?? c.child.name ?? '');
      validIds = memory.visibility === 'PRIVATE' ? [author] : [...parentIds];
      if (memory.visibility === 'FAMILY' && !memory.pregnancyId)
        validIds.push(
          ...circles
            .filter((c) =>
              childIds.length === 0
                ? memory.familyMoment
                : c.circleGrants.some(
                    (g) => g.childId && childIds.includes(g.childId),
                  ),
            )
            .map((c) => c.userId),
        );
      participants = (
        await tx.comment.findMany({
          where: {
            memoryId: subjectId,
            familyId,
            status: 'ACTIVE',
            deletedAt: null,
          },
          select: { authorUserId: true },
          distinct: ['authorUserId'],
        })
      ).map((c) => c.authorUserId);
      if (
        event.eventType === 'comment.created' &&
        !(await tx.comment.findFirst({
          where: {
            id: event.aggregateId!,
            memoryId: subjectId,
            deletedAt: null,
            status: 'ACTIVE',
          },
        }))
      )
        return null;
    } else {
      const pair = await tx.coupleSpace.findFirst({
        where: {
          familyId,
          status: 'ACTIVE',
          deletedAt: null,
          disabledAt: null,
        },
      });
      if (
        !pair ||
        !parentIds.includes(pair.parentAUserId) ||
        !parentIds.includes(pair.parentBUserId)
      )
        return null;
      validIds = [pair.parentAUserId, pair.parentBUserId];
      if (event.eventType.startsWith('us.request.')) {
        const row = await tx.request.findFirst({
          where: {
            id: subjectId,
            familyId,
            coupleSpaceId: pair.id,
            deletedAt: null,
          },
        });
        if (!row) return null;
        const creation = ['us.request.sent', 'us.request.created'].includes(
          event.eventType,
        );
        actorUserId = creation ? row.senderUserId : row.receiverUserId;
        target = creation ? row.receiverUserId : row.senderUserId;
        urgency = row.urgency;
        requestKind = row.kind;
      } else if (event.eventType === 'us.checkin.shared') {
        const row = await tx.moodCheckin.findFirst({
          where: {
            id: subjectId,
            familyId,
            coupleSpaceId: pair.id,
            deletedAt: null,
            shared: true,
            expiresAt: { gt: now },
          },
        });
        if (!row) return null;
        actorUserId = row.userId;
        target =
          pair.parentAUserId === actorUserId
            ? pair.parentBUserId
            : pair.parentAUserId;
      } else if (event.eventType === 'us.appreciation.created') {
        const row = await tx.appreciation.findFirst({
          where: {
            id: subjectId,
            familyId,
            coupleSpaceId: pair.id,
            deletedAt: null,
            deletedByToAt: null,
            deletedByFromAt: null,
          },
        });
        if (!row) return null;
        actorUserId = row.fromUserId;
        target = row.toUserId;
      } else return null;
    }
    const candidates: NotificationRecipient[] = [];
    for (const userId of [
      ...new Set([...parentIds, ...circles.map((c) => c.userId)]),
    ].sort()) {
      const circle = circles.find((c) => c.userId === userId);
      const allowedChildren = childIds
        .map((id, index) => ({ id, name: childNames[index] ?? '' }))
        .filter(
          (c) => !circle || circle.circleGrants.some((g) => g.childId === c.id),
        );
      const quiet = await tx.moodCheckin.findFirst({
        where: {
          familyId,
          userId,
          deletedAt: null,
          shared: true,
          sharedFields: { has: 'needs' },
          needs: { has: 'QUIET' },
          expiresAt: { gt: now },
        },
        orderBy: { expiresAt: 'desc' },
        select: { expiresAt: true },
      });
      const user = await tx.user.findFirst({
        where: { id: userId, deletedAt: null, status: 'ACTIVE' },
      });
      if (!user) continue;
      const setting = await tx.userSetting.findFirst({
        where: { userId, deletedAt: null },
      });
      const prefs = object(setting?.notificationPrefs);
      let timezone = user.timezone;
      try {
        new Intl.DateTimeFormat('en-CA', { timeZone: timezone }).format(now);
      } catch {
        timezone = NOTIFICATION_POLICY.defaultTimezone;
      }
      const muted =
        Array.isArray(prefs.mutedUserIds) &&
        prefs.mutedUserIds.includes(actorUserId);
      const blocked = blocks.some(
        (b) =>
          (b.blockerUserId === userId && b.blockedUserId === actorUserId) ||
          (b.blockedUserId === userId && b.blockerUserId === actorUserId),
      );
      candidates.push(
        new NotificationRecipient({
          childIds: allowedChildren.map((c) => c.id),
          childNames: allowedChildren.map((c) => c.name),
          quietUntil: quiet?.expiresAt,
          userId,
          role: parentIds.includes(userId) ? 'PARENT' : 'CIRCLE',
          canView: validIds.includes(userId) && !blocked && !muted,
          isAuthor: author === userId,
          isParticipant: participants.includes(userId),
          isPartner: parentIds.includes(userId) && actorUserId !== userId,
          isTarget: target === userId,
          locale: user.locale,
          timezone,
          prefs,
          quietStart:
            setting?.quietStart.toISOString().slice(11, 16) ?? '22:00',
          quietEnd: setting?.quietEnd.toISOString().slice(11, 16) ?? '06:30',
          requestSoonBypassQuiet: setting?.requestSoonBypassQuiet ?? false,
          pushCountToday: 0,
        }),
      );
    }
    return new NotificationDispatchSnapshot({
      eventId: event.eventId,
      eventType: event.eventType,
      familyId,
      subjectId,
      createdAt: event.createdAt,
      now,
      actorUserId,
      candidates,
      params: {
        actorUserId,
        familyId,
        entityId: subjectId,
        childIds,
        childNames,
      },
      urgency,
      requestKind,
      reactionRemoved:
        event.eventType === 'reaction.changed' && payload.type === null,
    });
  }

  private async persist(
    tx: Tx,
    snapshot: NotificationDispatchSnapshot,
    recipient: NotificationRecipient,
    decision: NotificationDispatchDecision,
  ): Promise<void> {
    const now = snapshot.now;
    const anchor = decision.groupKey
      ? await tx.notification.findFirst({
          where: {
            recipientUserId: recipient.userId,
            templateCode: decision.templateCode,
            subjectId: snapshot.subjectId,
            deletedAt: null,
            dismissedAt: null,
            createdAt: {
              gte: new Date(now.getTime() - NOTIFICATION_POLICY.groupWindowMs),
            },
            payloadReference: { path: ['groupKey'], equals: decision.groupKey },
          },
          orderBy: { createdAt: 'desc' },
        })
      : null;
    const reference = {
      params: decision.params,
      tab: decision.tab,
      deepLink: decision.deepLink,
      groupKey: decision.groupKey,
      count: 1,
      policyVersion: NOTIFICATION_POLICY.version,
    };
    const source = await tx.notification.create({
      data: {
        familyId: snapshot.familyId,
        recipientUserId: recipient.userId,
        eventId: snapshot.eventId,
        templateCode: decision.templateCode,
        category: decision.category,
        priority: decision.priority,
        locale: recipient.locale,
        subjectId: snapshot.subjectId,
        subjectType: decision.tab === 'FAMILY' ? 'memory' : 'us',
        payloadReference: reference,
        sensitive: decision.sensitive,
        expiresAt: new Date(
          now.getTime() + NOTIFICATION_POLICY.retentionDays * DAY,
        ),
        ...(anchor ? { dismissedAt: now } : {}),
      },
    });
    if (anchor) {
      const old = object(anchor.payloadReference);
      await tx.notification.update({
        where: { id: anchor.id },
        data: {
          readAt: null,
          payloadReference: {
            ...object(anchor.payloadReference),
            params: decision.params,
            count: typeof old.count === 'number' ? old.count + 1 : 2,
          },
        },
      });
      return;
    }
    let pushAt = decision.pushAt;
    if (pushAt && decision.category !== 'REQUESTS') {
      const localDay = (date: Date) =>
        new Intl.DateTimeFormat('en-CA', {
          timeZone: recipient.timezone,
        }).format(date);
      const reserved = await tx.notificationDelivery.findMany({
        where: {
          channel: 'PUSH',
          status: { in: ['PENDING', 'SENT', 'RETRY_WAIT'] },
          deletedAt: null,
          OR: [
            {
              nextAttemptAt: {
                gte: new Date(pushAt.getTime() - 36 * 3_600_000),
                lte: new Date(pushAt.getTime() + 36 * 3_600_000),
              },
            },
            {
              nextAttemptAt: null,
              createdAt: {
                gte: new Date(pushAt.getTime() - 36 * 3_600_000),
                lte: new Date(pushAt.getTime() + 36 * 3_600_000),
              },
            },
          ],
          notification: {
            recipientUserId: recipient.userId,
            category: { not: 'REQUESTS' },
            deletedAt: null,
          },
        },
        select: { notificationId: true, nextAttemptAt: true, createdAt: true },
      });
      const scheduledDay = localDay(pushAt);
      // The push worker fans out one row per device: count notifications, not rows.
      const sameDay = new Set(
        reserved
          .filter(
            (d) => localDay(d.nextAttemptAt ?? d.createdAt) === scheduledDay,
          )
          .map((d) => d.notificationId),
      );
      if (sameDay.size >= NOTIFICATION_POLICY.nonUrgentPushDailyCap)
        pushAt = null;
    }
    if (pushAt)
      await tx.notificationDelivery.create({
        data: {
          notificationId: source.id,
          channel: 'PUSH',
          targetKey: recipient.userId,
          status: 'PENDING',
          nextAttemptAt: pushAt,
        },
      });
    // Push sender must recheck ACL/preferences/quiet/cap before claiming these rows.
    // TODO: actual per-device sending, delivery attempts, online suppression and retention purge.
  }
}
