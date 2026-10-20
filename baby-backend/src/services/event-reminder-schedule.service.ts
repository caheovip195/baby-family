import { CALENDAR_POLICY } from '../config/calendar-policy';
import { Inject, Injectable } from '@nestjs/common';
import {
  findGregorianOccurrencesInRange,
  findLunarOccurrencesInRange,
  parseIsoDate,
} from '../common/time/lunar-calendar';
import { EVENT_REMINDER_POLICY } from '../config/event-reminder-policy';
import { EVENT_REMINDER_SCHEDULE_REPOSITORY } from '../interfaces/repositories/event-reminder-schedule-repository.interface';
import type {
  IEventReminderScheduleRepository,
  ReminderDispatchSnapshot,
  ReminderEventSnapshot,
  ReminderNotification,
  ReminderPlan,
} from '../interfaces/repositories/event-reminder-schedule-repository.interface';
import type { IEventReminderScheduleService } from '../interfaces/services/event-reminder-schedule-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import type { Event } from '../models/event.model';
const DAY = 86_400_000;
function parts(date: Date, timezone: string): Record<string, string> {
  return Object.fromEntries(
    new Intl.DateTimeFormat('en-CA', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(date)
      .map((p) => [p.type, p.value]),
  );
}
function localDate(date: Date, timezone: string): string {
  const p = parts(date, timezone);
  return `${p.year}-${p.month}-${p.day}`;
}
/** Resolve an event's wall clock in the occurrence year, including DST offsets. */
function wallClock(date: string, time: string, timezone: string): Date {
  const desired = Date.parse(`${date}T${time}Z`);
  let instant = desired;
  for (let i = 0; i < 4; i++) {
    const p = parts(new Date(instant), timezone);
    const wall = Date.parse(
      `${p.year}-${p.month}-${p.day}T${p.hour}:${p.minute}:${p.second}Z`,
    );
    const correction = desired - wall;
    if (!correction) break;
    instant += correction;
  }
  return new Date(instant);
}
@Injectable()
export class EventReminderScheduleService implements IEventReminderScheduleService {
  constructor(
    @Inject(EVENT_REMINDER_SCHEDULE_REPOSITORY)
    private readonly reminders: IEventReminderScheduleRepository,
  ) {}
  async plan(
    now: Date,
    context: JobContext,
    eventId?: string,
  ): Promise<Record<string, number>> {
    context.signal.throwIfAborted();
    const horizon = new Date(
      now.getTime() + EVENT_REMINDER_POLICY.horizonDays * DAY,
    );
    const planned = await this.reminders.reconcile(
      now,
      context,
      (snapshot) => this.plans(snapshot, now, horizon),
      eventId,
    );
    return { planned };
  }
  async dispatch(
    now: Date,
    context: JobContext,
  ): Promise<Record<string, number>> {
    let sent = 0,
      cancelled = 0;
    for (;;) {
      context.signal.throwIfAborted();
      const result = await this.reminders.dispatchBatch(
        now,
        context,
        (snapshot) => this.notification(snapshot),
      );
      sent += result.sent;
      cancelled += result.cancelled;
      if (result.claimed < EVENT_REMINDER_POLICY.batchSize) break;
    }
    return { sent, cancelled };
  }
  occurrences(event: Event, from: Date, to: Date): Date[] {
    if (!event.repeatYearly)
      return event.startAt >= from && event.startAt <= to
        ? [event.startAt]
        : [];
    const fromIso = localDate(from, event.timezone),
      toIso = localDate(to, event.timezone);
    const initial = parseIsoDate(
      event.localStartDate.toISOString().slice(0, 10),
    );
    const dates =
      event.isLunar && event.lunarDay && event.lunarMonth
        ? findLunarOccurrencesInRange(
            event.lunarDay,
            event.lunarMonth,
            event.lunarLeap,
            fromIso,
            toIso,
          ).map((o) => o.date)
        : findGregorianOccurrencesInRange(
            initial.month,
            initial.day,
            fromIso,
            toIso,
          );
    const p = parts(event.startAt, event.timezone);
    const time = event.allDay
      ? '00:00:00'
      : `${p.hour}:${p.minute}:${p.second}`;
    return dates
      .map((date) => wallClock(date, time, event.timezone))
      .filter((date) => date >= from && date <= to && date >= event.startAt);
  }
  private plans(
    snapshot: ReminderEventSnapshot,
    now: Date,
    horizon: Date,
  ): ReminderPlan[] {
    if (snapshot.event.deletedAt || !snapshot.familyActive) return [];
    const occurrences = this.occurrences(snapshot.event, now, horizon);
    // Preserve valid overdue work so schedule recovery does not discard missed reminders.
    for (const reminder of snapshot.outstanding) {
      if (
        reminder.occurrenceAt < now &&
        this.occurrences(
          snapshot.event,
          reminder.occurrenceAt,
          reminder.occurrenceAt,
        ).length &&
        !occurrences.some(
          (d) => d.getTime() === reminder.occurrenceAt.getTime(),
        )
      )
        occurrences.push(reminder.occurrenceAt);
    }
    return occurrences.flatMap((occurrenceAt) =>
      snapshot.rules.map((rule) => ({
        ...rule,
        occurrenceAt,
        dueAt: new Date(occurrenceAt.getTime() - rule.offsetMinutes * 60_000),
      })),
    );
  }
  private notification(
    s: ReminderDispatchSnapshot,
  ): ReminderNotification | null {
    const e = s.event,
      r = s.reminder;
    if (e.deletedAt || !s.familyActive || !s.userActive) return null;
    if (
      !s.isParent &&
      !(
        s.isCircle &&
        (CALENDAR_POLICY.circleAllowedTypes as readonly string[]).includes(
          e.type,
        ) &&
        e.inviteCircle &&
        s.hasGrantedChild
      )
    )
      return null;
    if (e.type === 'MEMORY_REMINDER' && e.createdBy !== r.recipientUserId)
      return null;
    if (
      !s.rules.some(
        (rule) =>
          rule.recipientUserId === r.recipientUserId &&
          rule.offsetMinutes === r.offsetMinutes,
      )
    )
      return null;
    if (!this.occurrences(e, r.occurrenceAt, r.occurrenceAt).length)
      return null;
    const sensitive = ['COUPLE', 'NOTE'].includes(e.type);
    return {
      sensitive,
      tab: e.type === 'COUPLE' ? 'US' : 'FAMILY',
      params: {
        eventId: e.id,
        eventType: e.type,
        occurrenceAt: r.occurrenceAt.toISOString(),
        offsetMinutes: r.offsetMinutes,
        ...(sensitive ? {} : { title: e.title }),
      },
      deepLink: `babyfamily://calendar/events/${e.id}`,
    };
  }
}
