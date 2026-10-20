import { Injectable } from '@nestjs/common';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type {
  CalendarMissionRow,
  CreateEventCommand,
  FamilyCalendarContext,
  ICalendarRepository,
  UpdateEventCommand,
} from '../interfaces/repositories/calendar-repository.interface';
import { CalendarEventView } from '../models/calendar-event-view.model';
import { Child, type ChildAttributes } from '../models/child.model';
import { Event } from '../models/event.model';
import { EventParticipant } from '../models/event-participant.model';
import { EventReminderRule } from '../models/event-reminder-rule.model';
import { Family, type FamilyAttributes } from '../models/family.model';
import { Mission } from '../models/mission.model';

type Transaction = Prisma.TransactionClient;

const EVENT_RELATIONS = {
  eventChildren: {
    where: { deletedAt: null },
    select: { childId: true },
  },
  eventParticipants: {
    where: { deletedAt: null },
  },
  eventReminderRules: {
    where: { deletedAt: null },
  },
} satisfies Prisma.EventInclude;

type EventWithRelations = Prisma.EventGetPayload<{
  include: typeof EVENT_RELATIONS;
}>;

function toEventView(row: EventWithRelations): CalendarEventView {
  return new CalendarEventView(
    new Event(row),
    row.eventChildren.map((ec) => ec.childId),
    row.eventParticipants.map((ep) => new EventParticipant(ep)),
    row.eventReminderRules.map((er) => new EventReminderRule(er)),
  );
}

@Injectable()
export class CalendarRepository implements ICalendarRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findFamilyContext(
    familyId: string,
    userId: string,
  ): Promise<FamilyCalendarContext> {
    const familyRow = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
    });

    if (!familyRow) {
      return {
        family: null,
        isParent: false,
        isCircle: false,
        grantedChildIds: [],
      };
    }

    const [parentRow, circleRow] = await Promise.all([
      this.prisma.familyParent.findFirst({
        where: { familyId, userId, deletedAt: null },
      }),
      this.prisma.circleMember.findFirst({
        where: {
          familyId,
          userId,
          status: 'ACTIVE',
          deletedAt: null,
        },
        include: {
          circleGrants: {
            where: { deletedAt: null },
          },
        },
      }),
    ]);

    const grantedChildIds =
      circleRow?.circleGrants
        .filter((g) => g.childId !== null)
        .map((g) => g.childId as string) ?? [];

    return {
      family: new Family(familyRow as unknown as FamilyAttributes),
      isParent: !!parentRow,
      isCircle: !!circleRow,
      grantedChildIds,
    };
  }

  async findEventsForCalendar(
    familyId: string,
    fromDate: Date,
    toDate: Date,
    childId?: string,
  ): Promise<CalendarEventView[]> {
    const where: Prisma.EventWhereInput = {
      familyId,
      deletedAt: null,
      OR: [
        {
          repeatYearly: false,
          localStartDate: { lte: toDate },
          OR: [
            { localEndDate: { gte: fromDate } },
            { localEndDate: null, localStartDate: { gte: fromDate } },
          ],
        },
        {
          repeatYearly: true,
        },
      ],
    };

    if (childId) {
      where.eventChildren = {
        some: { childId, deletedAt: null },
      };
    }

    const rows = await this.prisma.event.findMany({
      where,
      include: EVENT_RELATIONS,
      orderBy: [{ localStartDate: 'asc' }, { startAt: 'asc' }, { id: 'asc' }],
    });

    return rows.map(toEventView);
  }

  async findEventById(id: string): Promise<CalendarEventView | null> {
    const row = await this.prisma.event.findFirst({
      where: { id, deletedAt: null },
      include: EVENT_RELATIONS,
    });

    return row ? toEventView(row) : null;
  }

  async findFamilyChildren(
    familyId: string,
    childId?: string,
  ): Promise<Child[]> {
    const where: Prisma.ChildWhereInput = {
      familyId,
      status: 'ACTIVE',
      deletedAt: null,
      ...(childId ? { id: childId } : {}),
    };

    const rows = await this.prisma.child.findMany({
      where,
      orderBy: [{ sortOrder: 'asc' }, { birthDate: 'asc' }, { id: 'asc' }],
    });

    return rows.map((r) => new Child(r as unknown as ChildAttributes));
  }

  async findCalendarMissions(
    familyId: string,
    fromDate: Date,
    toDate: Date,
    childId?: string,
  ): Promise<CalendarMissionRow[]> {
    const where: Prisma.MissionWhereInput = {
      familyId,
      deletedAt: null,
      boardDate: {
        gte: fromDate,
        lte: toDate,
      },
      ...(childId
        ? {
            missionChildren: {
              some: { childId, deletedAt: null },
            },
          }
        : {}),
    };

    const rows = await this.prisma.mission.findMany({
      where,
      include: {
        missionChildren: {
          where: { deletedAt: null },
          select: { childId: true },
        },
        missionEventsMissionEventsMissionIdTomissions: {
          where: { deletedAt: null },
          select: { type: true, createdAt: true },
          orderBy: { createdAt: 'asc' },
        },
      },
      orderBy: [{ boardDate: 'asc' }, { scheduledTime: 'asc' }, { id: 'asc' }],
    });

    return rows.map((r) => ({
      mission: new Mission(r),
      childIds: r.missionChildren.map((c) => c.childId),
      events: r.missionEventsMissionEventsMissionIdTomissions,
    }));
  }

  async createEvent(command: CreateEventCommand): Promise<CalendarEventView> {
    return this.prisma.$transaction(async (tx: Transaction) => {
      const created = await tx.event.create({
        data: {
          familyId: command.familyId,
          type: command.type,
          title: command.title,
          notes: command.notes ?? null,
          allDay: command.allDay,
          startAt: command.startAt,
          endAt: command.endAt ?? null,
          localStartDate: command.localStartDate,
          localEndDate: command.localEndDate ?? null,
          timezone: command.timezone,
          isLunar: command.isLunar,
          lunarMonth: command.lunarMonth ?? null,
          lunarDay: command.lunarDay ?? null,
          lunarLeap: command.lunarLeap ?? null,
          repeatYearly: command.repeatYearly,
          inviteCircle: command.inviteCircle,
          createdBy: command.createdBy,
        },
      });

      if (command.childIds && command.childIds.length > 0) {
        await tx.eventChild.createMany({
          data: command.childIds.map((cid) => ({
            eventId: created.id,
            childId: cid,
            familyId: command.familyId,
          })),
        });
      }

      if (command.participants && command.participants.length > 0) {
        await tx.eventParticipant.createMany({
          data: command.participants.map((p) => ({
            eventId: created.id,
            familyId: command.familyId,
            userId: p.userId,
            response: p.response ?? 'INVITED',
          })),
        });
      }

      if (command.reminderRules && command.reminderRules.length > 0) {
        await tx.eventReminderRule.createMany({
          data: command.reminderRules.map((rr) => ({
            eventId: created.id,
            familyId: command.familyId,
            recipientUserId: rr.recipientUserId,
            offsetMinutes: rr.offsetMinutes,
            enabled: rr.enabled ?? true,
          })),
        });
      }

      await tx.outboxEvent.create({
        data: {
          eventType: 'event.changed',
          aggregateId: created.id,
          familyId: command.familyId,
          payload: {
            eventId: created.id,
            familyId: command.familyId,
          },
        },
      });

      const fullRow = await tx.event.findUniqueOrThrow({
        where: { id: created.id },
        include: EVENT_RELATIONS,
      });

      return toEventView(fullRow);
    });
  }

  async updateEvent(command: UpdateEventCommand): Promise<CalendarEventView> {
    return this.prisma.$transaction(async (tx: Transaction) => {
      const current = await tx.event.findFirst({
        where: {
          id: command.id,
          familyId: command.familyId,
          deletedAt: null,
        },
      });

      if (!current) {
        throw new NotFoundError('Event was not found.');
      }

      if (
        command.expectedVersion !== undefined &&
        current.version !== command.expectedVersion
      ) {
        throw new DomainError(
          'Event version conflict.',
          'EVENT_VERSION_CONFLICT',
          409,
        );
      }

      const now = new Date();

      if (command.childIds !== undefined) {
        await tx.eventChild.updateMany({
          where: {
            eventId: command.id,
            deletedAt: null,
            childId: { notIn: command.childIds },
          },
          data: { deletedAt: now },
        });

        for (const cid of command.childIds) {
          const existing = await tx.eventChild.findFirst({
            where: { eventId: command.id, childId: cid },
          });
          if (existing) {
            if (existing.deletedAt !== null) {
              await tx.eventChild.update({
                where: {
                  eventId_childId: { eventId: command.id, childId: cid },
                },
                data: { deletedAt: null, updatedAt: now },
              });
            }
          } else {
            await tx.eventChild.create({
              data: {
                eventId: command.id,
                childId: cid,
                familyId: command.familyId,
              },
            });
          }
        }
      }

      if (command.participants !== undefined) {
        const participantUserIds = command.participants.map((p) => p.userId);
        await tx.eventParticipant.updateMany({
          where: {
            eventId: command.id,
            deletedAt: null,
            userId: { notIn: participantUserIds },
          },
          data: { deletedAt: now },
        });

        for (const p of command.participants) {
          const existing = await tx.eventParticipant.findFirst({
            where: { eventId: command.id, userId: p.userId },
          });
          if (existing) {
            await tx.eventParticipant.update({
              where: {
                eventId_userId: { eventId: command.id, userId: p.userId },
              },
              data: {
                deletedAt: null,
                response: p.response ?? existing.response,
                updatedAt: now,
              },
            });
          } else {
            await tx.eventParticipant.create({
              data: {
                eventId: command.id,
                familyId: command.familyId,
                userId: p.userId,
                response: p.response ?? 'INVITED',
              },
            });
          }
        }
      }

      if (command.reminderRules !== undefined) {
        await tx.eventReminderRule.updateMany({
          where: { eventId: command.id, deletedAt: null },
          data: { deletedAt: now },
        });

        for (const rr of command.reminderRules) {
          const existing = await tx.eventReminderRule.findFirst({
            where: {
              eventId: command.id,
              recipientUserId: rr.recipientUserId,
              offsetMinutes: rr.offsetMinutes,
            },
          });
          if (existing) {
            await tx.eventReminderRule.update({
              where: { id: existing.id },
              data: {
                enabled: rr.enabled ?? true,
                deletedAt: null,
                updatedAt: now,
              },
            });
          } else {
            await tx.eventReminderRule.create({
              data: {
                eventId: command.id,
                familyId: command.familyId,
                recipientUserId: rr.recipientUserId,
                offsetMinutes: rr.offsetMinutes,
                enabled: rr.enabled ?? true,
              },
            });
          }
        }
      }

      const updateData: Prisma.EventUpdateInput = {
        version: { increment: 1 },
        updatedAt: now,
      };

      if (command.type !== undefined) updateData.type = command.type;
      if (command.title !== undefined) updateData.title = command.title;
      if (command.notes !== undefined) updateData.notes = command.notes;
      if (command.allDay !== undefined) updateData.allDay = command.allDay;
      if (command.startAt !== undefined) updateData.startAt = command.startAt;
      if (command.endAt !== undefined) updateData.endAt = command.endAt;
      if (command.localStartDate !== undefined)
        updateData.localStartDate = command.localStartDate;
      if (command.localEndDate !== undefined)
        updateData.localEndDate = command.localEndDate;
      if (command.timezone !== undefined)
        updateData.timezone = command.timezone;
      if (command.isLunar !== undefined) updateData.isLunar = command.isLunar;
      if (command.lunarMonth !== undefined)
        updateData.lunarMonth = command.lunarMonth;
      if (command.lunarDay !== undefined)
        updateData.lunarDay = command.lunarDay;
      if (command.lunarLeap !== undefined)
        updateData.lunarLeap = command.lunarLeap;
      if (command.repeatYearly !== undefined)
        updateData.repeatYearly = command.repeatYearly;
      if (command.inviteCircle !== undefined)
        updateData.inviteCircle = command.inviteCircle;

      await tx.event.update({
        where: { id: command.id },
        data: updateData,
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'event.changed',
          aggregateId: command.id,
          familyId: command.familyId,
          payload: {
            eventId: command.id,
            familyId: command.familyId,
          },
        },
      });

      const updatedRow = await tx.event.findUniqueOrThrow({
        where: { id: command.id },
        include: EVENT_RELATIONS,
      });

      return toEventView(updatedRow);
    });
  }

  async softDeleteEvent(id: string, familyId: string): Promise<void> {
    await this.prisma.$transaction(async (tx: Transaction) => {
      const current = await tx.event.findFirst({
        where: { id, familyId, deletedAt: null },
      });

      if (!current) {
        throw new NotFoundError('Event was not found.');
      }

      const now = new Date();

      await tx.event.update({
        where: { id },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.eventChild.updateMany({
        where: { eventId: id, deletedAt: null },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.eventParticipant.updateMany({
        where: { eventId: id, deletedAt: null },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.eventReminderRule.updateMany({
        where: { eventId: id, deletedAt: null },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.eventReminder.updateMany({
        where: { eventId: id, deletedAt: null },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'event.changed',
          aggregateId: id,
          familyId,
          payload: {
            eventId: id,
            familyId,
          },
        },
      });
    });
  }
}
