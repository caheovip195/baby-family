import { Injectable } from '@nestjs/common';
import { EVENT_REMINDER_POLICY } from '../config/event-reminder-policy';
import { NOTIFICATION_POLICY } from '../config/notification-policy';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import type {
  IEventReminderScheduleRepository,
  ReminderDispatchSnapshot,
  ReminderEventSnapshot,
  ReminderNotification,
  ReminderPlan,
} from '../interfaces/repositories/event-reminder-schedule-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { Event } from '../models/event.model';
import { EventReminder } from '../models/event-reminder.model';
type Tx = Prisma.TransactionClient;
const key = (r: ReminderPlan) =>
  `${r.recipientUserId}:${r.occurrenceAt.toISOString()}:${r.offsetMinutes}`;
@Injectable()
export class EventReminderScheduleRepository implements IEventReminderScheduleRepository {
  constructor(private readonly prisma: PrismaService) {}
  private async fenced(tx: Tx, context: JobContext): Promise<void> {
    context.signal.throwIfAborted();
    const { lease } = context;
    const owned = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR UPDATE`;
    if (!owned.length) throw new Error('Event reminder job lease lost.');
  }
  private async snapshot(
    tx: Tx,
    eventId: string,
  ): Promise<ReminderEventSnapshot | null> {
    const event = await tx.event.findUnique({
      where: { id: eventId },
      include: {
        family: true,
        eventReminderRules: { where: { enabled: true, deletedAt: null } },
      },
    });
    if (!event) return null;
    const outstanding = await tx.eventReminder.findMany({
      where: { eventId, sentAt: null, cancelledAt: null, deletedAt: null },
    });
    return {
      event: new Event(event),
      familyActive:
        !event.family.deletedAt &&
        !['DELETED', 'DELETION_SCHEDULED'].includes(event.family.status),
      rules: event.eventReminderRules.map((r) => ({
        recipientUserId: r.recipientUserId,
        offsetMinutes: r.offsetMinutes,
      })),
      outstanding: outstanding.map((r) => new EventReminder(r)),
    };
  }
  async reconcile(
    now: Date,
    context: JobContext,
    plan: (snapshot: ReminderEventSnapshot) => ReminderPlan[],
    eventId?: string,
  ): Promise<number> {
    let cursor: string | undefined;
    let planned = 0;
    for (;;) {
      context.signal.throwIfAborted();
      // Include deleted events with outstanding work so polling also repairs lost outbox jobs.
      const events = await this.prisma.event.findMany({
        where: {
          ...(eventId ? { id: eventId } : {}),
          OR: [
            {
              deletedAt: null,
              eventReminderRules: { some: { enabled: true, deletedAt: null } },
            },
            {
              eventReminders: {
                some: { sentAt: null, cancelledAt: null, deletedAt: null },
              },
            },
          ],
        },
        select: { id: true },
        orderBy: { id: 'asc' },
        take: EVENT_REMINDER_POLICY.batchSize,
        ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
      });
      for (const event of events) {
        planned += await this.prisma.$transaction(
          async (tx) => {
            await this.fenced(tx, context);
            await tx.$queryRaw`SELECT id FROM app.events WHERE id = ${event.id}::uuid FOR UPDATE`;
            const snapshot = await this.snapshot(tx, event.id);
            if (!snapshot) return 0;
            const desired = plan(snapshot);
            const keys = new Set(desired.map(key));
            for (const row of snapshot.outstanding) {
              if (!keys.has(key(row)))
                await tx.eventReminder.update({
                  where: { id: row.id },
                  data: { cancelledAt: now },
                });
            }
            let count = 0;
            for (const row of desired) {
              const unique = {
                eventId: event.id,
                recipientUserId: row.recipientUserId,
                occurrenceAt: row.occurrenceAt,
                offsetMinutes: row.offsetMinutes,
              };
              const existing = await tx.eventReminder.findUnique({
                where: {
                  eventId_recipientUserId_occurrenceAt_offsetMinutes: unique,
                },
              });
              if (existing?.sentAt) continue;
              if (existing) {
                if (
                  existing.cancelledAt ||
                  existing.deletedAt ||
                  existing.dueAt.getTime() !== row.dueAt.getTime()
                )
                  await tx.eventReminder.update({
                    where: { id: existing.id },
                    data: {
                      cancelledAt: null,
                      deletedAt: null,
                      dueAt: row.dueAt,
                    },
                  });
              } else {
                await tx.eventReminder.create({
                  data: {
                    ...unique,
                    familyId: snapshot.event.familyId,
                    dueAt: row.dueAt,
                  },
                });
                count++;
              }
            }
            await this.fenced(tx, context);
            return count;
          },
          { timeout: 30000 },
        );
      }
      if (events.length < EVENT_REMINDER_POLICY.batchSize || eventId) break;
      cursor = events.at(-1)!.id;
    }
    return planned;
  }
  async dispatchBatch(
    now: Date,
    context: JobContext,
    decide: (snapshot: ReminderDispatchSnapshot) => ReminderNotification | null,
  ): Promise<{ sent: number; cancelled: number; claimed: number }> {
    return this.prisma.$transaction(
      async (tx) => {
        await this.fenced(tx, context);
        const rows = await tx.$queryRaw<
          { id: string; event_id: string }[]
        >`SELECT id, event_id FROM app.event_reminders WHERE due_at <= ${now} AND sent_at IS NULL AND cancelled_at IS NULL AND deleted_at IS NULL ORDER BY due_at, id LIMIT ${EVENT_REMINDER_POLICY.batchSize} FOR UPDATE SKIP LOCKED`;
        let sent = 0,
          cancelled = 0;
        for (const row of rows) {
          context.signal.throwIfAborted();
          await tx.$queryRaw`SELECT id FROM app.events WHERE id = ${row.event_id}::uuid FOR SHARE`;
          const snapshot = await this.snapshot(tx, row.event_id);
          const reminder = await tx.eventReminder.findUniqueOrThrow({
            where: { id: row.id },
          });
          if (!snapshot) {
            await tx.eventReminder.update({
              where: { id: row.id },
              data: { cancelledAt: now },
            });
            cancelled++;
            continue;
          }
          const userId = reminder.recipientUserId,
            familyId = reminder.familyId;
          const [user, parent, circle, children] = await Promise.all([
            tx.user.findFirst({
              where: { id: userId, status: 'ACTIVE', deletedAt: null },
            }),
            tx.familyParent.findFirst({
              where: {
                userId,
                familyId,
                status: 'ACTIVE',
                leftAt: null,
                joinedAt: { lte: now },
                deletedAt: null,
              },
            }),
            tx.circleMember.findFirst({
              where: {
                family: { status: 'ACTIVE', deletedAt: null },
                userId,
                familyId,
                status: 'ACTIVE',
                joinedAt: { lte: now },
                deletedAt: null,
              },
              include: {
                circleGrants: {
                  where: {
                    status: 'ACTIVE',
                    deletedAt: null,
                    child: { deletedAt: null, status: 'ACTIVE' },
                  },
                },
              },
            }),
            tx.eventChild.findMany({
              where: {
                eventId: row.event_id,
                familyId,
                deletedAt: null,
                child: { deletedAt: null, status: 'ACTIVE' },
              },
            }),
          ]);
          const notification = decide({
            ...snapshot,
            reminder: new EventReminder(reminder),
            locale: user?.locale ?? 'vi',
            userActive: !!user,
            isParent: !!parent,
            isCircle: !!circle,
            hasGrantedChild: !!circle?.circleGrants.some((g) =>
              children.some((c) => c.childId === g.childId),
            ),
          });
          if (!notification) {
            await tx.eventReminder.update({
              where: { id: row.id },
              data: { cancelledAt: now },
            });
            cancelled++;
            continue;
          }
          // Reminder id is the inbox event id; unique key survives retries and inbox deletion.
          await tx.notification.upsert({
            where: {
              eventId_recipientUserId_templateCode: {
                eventId: reminder.id,
                recipientUserId: userId,
                templateCode: 'NOTI_EVENT_REMINDER',
              },
            },
            update: {},
            create: {
              eventId: reminder.id,
              familyId,
              recipientUserId: userId,
              templateCode: 'NOTI_EVENT_REMINDER',
              category: notification.tab === 'US' ? 'US' : 'CALENDAR',
              priority: 'NORMAL',
              locale: user?.locale ?? 'vi',
              sensitive: notification.sensitive,
              subjectType: 'calendar_event',
              subjectId: snapshot.event.id,
              payloadReference: {
                params: notification.params,
                tab: notification.tab,
                deepLink: notification.deepLink,
                policyVersion: EVENT_REMINDER_POLICY.version,
              },
              expiresAt: new Date(
                now.getTime() + NOTIFICATION_POLICY.retentionDays * 86400000,
              ),
            },
          });
          await tx.eventReminder.update({
            where: { id: row.id },
            data: { sentAt: now },
          });
          sent++;
        }
        await this.fenced(tx, context);
        return { sent, cancelled, claimed: rows.length };
      },
      { timeout: 30000, isolationLevel: 'Serializable' },
    );
  }
}
