import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import {
  findGregorianOccurrencesInRange,
  findLunarOccurrencesInRange,
  parseIsoDate,
  solarToLunar,
  toIsoDateString,
} from '../common/time/lunar-calendar';
import { CALENDAR_POLICY } from '../config/calendar-policy';
import type { CalendarQueryDto } from '../dto/calendar/calendar-query.dto';
import type { CalendarResponseDto } from '../dto/calendar/calendar-response.dto';
import type { CreateEventDto } from '../dto/calendar/create-event.dto';
import type {
  CalendarEventParticipantDto,
  CalendarEventReminderRuleDto,
  CalendarSpecialDayDto,
  EventResponseDto,
} from '../dto/calendar/event-response.dto';
import type { UpdateEventDto } from '../dto/calendar/update-event.dto';
import type {
  MyMissionDto,
  PartnerMissionDto,
} from '../dto/mission/mission.dto';
import { CALENDAR_REPOSITORY } from '../interfaces/repositories/calendar-repository.interface';
import type {
  CalendarMissionRow,
  ICalendarRepository,
} from '../interfaces/repositories/calendar-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { ICalendarService } from '../interfaces/services/calendar-service.interface';
import type { CalendarEventView } from '../models/calendar-event-view.model';
import type { Child } from '../models/child.model';

function daysInMonth(year: number, month: number): number {
  return new Date(year, month, 0).getDate();
}

function localDateString(date: Date, timezone: string): string {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-CA', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    })
      .formatToParts(date)
      .map((part) => [part.type, part.value]),
  );
  return `${parts.year}-${parts.month}-${parts.day}`;
}

@Injectable()
export class CalendarService implements ICalendarService {
  constructor(
    @Inject(CALENDAR_REPOSITORY)
    private readonly repository: ICalendarRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async getCalendar(
    actor: AuthPrincipal,
    familyId: string,
    query: CalendarQueryDto,
  ): Promise<CalendarResponseDto> {
    this.validateDateRange(query.from, query.to);

    const ctx = await this.repository.findFamilyContext(familyId, actor.userId);

    if (!ctx.family) {
      throw new NotFoundError('Family was not found.');
    }

    if (!ctx.isParent && !ctx.isCircle) {
      throw new DomainError(
        'Family access denied.',
        'FAMILY_ACCESS_DENIED',
        403,
      );
    }

    if (ctx.isParent) {
      await this.access.requireParent(actor, familyId, 'read');
    } else {
      if (ctx.family.status !== 'ACTIVE') {
        throw new DomainError(
          'Family is not active.',
          'FAMILY_NOT_ACTIVE',
          403,
        );
      }
    }

    const fromDate = new Date(`${query.from}T00:00:00.000Z`);
    const toDate = new Date(`${query.to}T23:59:59.999Z`);

    const [events, missionRows, children] = await Promise.all([
      this.repository.findEventsForCalendar(
        familyId,
        fromDate,
        toDate,
        query.childId,
      ),
      ctx.isParent
        ? this.repository.findCalendarMissions(
            familyId,
            new Date(`${query.from}T00:00:00.000Z`),
            new Date(`${query.to}T00:00:00.000Z`),
            query.childId,
          )
        : Promise.resolve([]),
      this.repository.findFamilyChildren(familyId, query.childId),
    ]);

    const resolvedEvents = this.resolveCalendarEvents(
      events,
      query.from,
      query.to,
      ctx.isCircle,
      ctx.grantedChildIds,
    );

    const timezone = ctx.family.timezone || CALENDAR_POLICY.defaultTimezone;
    const todayStr = localDateString(new Date(), timezone);

    const missions: (MyMissionDto | PartnerMissionDto)[] = [];
    if (ctx.isParent) {
      for (const row of missionRows) {
        const projected = this.projectMission(row, actor.userId, todayStr);
        if (projected) {
          missions.push(projected);
        }
      }
    }

    const visibleChildren = ctx.isCircle
      ? children.filter((c) => ctx.grantedChildIds.includes(c.id))
      : children;

    const specialDays = this.computeSpecialDays(
      visibleChildren,
      query.from,
      query.to,
    );

    return {
      from: query.from,
      to: query.to,
      events: resolvedEvents,
      missions,
      specialDays,
    };
  }

  async createEvent(
    actor: AuthPrincipal,
    dto: CreateEventDto,
  ): Promise<EventResponseDto> {
    await this.access.requireParent(actor, dto.familyId, 'write');

    this.validateEventInput(dto);

    const timezone = dto.timezone ?? CALENDAR_POLICY.defaultTimezone;
    const startAt = new Date(dto.startAt);
    const endAt = dto.endAt ? new Date(dto.endAt) : null;

    const localStartDate = dto.localStartDate
      ? new Date(`${dto.localStartDate}T00:00:00.000Z`)
      : new Date(`${localDateString(startAt, timezone)}T00:00:00.000Z`);

    const localEndDate = dto.localEndDate
      ? new Date(`${dto.localEndDate}T00:00:00.000Z`)
      : endAt
        ? new Date(`${localDateString(endAt, timezone)}T00:00:00.000Z`)
        : null;

    if (localEndDate && localEndDate.getTime() < localStartDate.getTime()) {
      throw new DomainError(
        'End date must be at or after start date.',
        'EVENT_DATE_INVALID',
        422,
      );
    }

    const eventView = await this.repository.createEvent({
      familyId: dto.familyId,
      type: dto.type,
      title: dto.title.trim(),
      notes: dto.notes?.trim() ?? null,
      allDay: dto.allDay ?? true,
      startAt,
      endAt,
      localStartDate,
      localEndDate,
      timezone,
      isLunar: dto.isLunar ?? false,
      lunarMonth: dto.lunarMonth ?? null,
      lunarDay: dto.lunarDay ?? null,
      lunarLeap: dto.lunarLeap ?? null,
      repeatYearly: dto.repeatYearly ?? false,
      inviteCircle: dto.inviteCircle ?? false,
      createdBy: actor.userId,
      childIds: dto.childIds,
      participants: dto.participants,
      reminderRules: dto.reminderRules,
    });

    return this.toEventResponseDto(eventView);
  }

  async getEvent(
    actor: AuthPrincipal,
    eventId: string,
  ): Promise<EventResponseDto> {
    const event = await this.repository.findEventById(eventId);
    if (!event) {
      throw new NotFoundError('Event was not found.');
    }

    const ctx = await this.repository.findFamilyContext(
      event.familyId,
      actor.userId,
    );

    if (ctx.isParent) {
      await this.access.requireParent(actor, event.familyId, 'read');
      return this.toEventResponseDto(event);
    }

    if (ctx.isCircle) {
      if (!event.isVisibleToCircle(ctx.grantedChildIds)) {
        throw new NotFoundError('Event was not found.');
      }
      return this.toEventResponseDto(event);
    }

    throw new DomainError('Family access denied.', 'FAMILY_ACCESS_DENIED', 403);
  }

  async updateEvent(
    actor: AuthPrincipal,
    eventId: string,
    dto: UpdateEventDto,
  ): Promise<EventResponseDto> {
    const existing = await this.repository.findEventById(eventId);
    if (!existing) {
      throw new NotFoundError('Event was not found.');
    }

    await this.access.requireParent(actor, existing.familyId, 'write');

    const mergedType = dto.type ?? existing.type;
    const mergedInviteCircle = dto.inviteCircle ?? existing.inviteCircle;

    if (
      ['COUPLE', 'NOTE', 'MEMORY_REMINDER'].includes(mergedType) &&
      mergedInviteCircle
    ) {
      throw new DomainError(
        'Circle cannot be invited to this event type.',
        'EVENT_INVITE_CIRCLE_INVALID',
        422,
      );
    }

    const mergedIsLunar = dto.isLunar ?? existing.isLunar;
    const mergedLunarMonth =
      dto.lunarMonth !== undefined ? dto.lunarMonth : existing.lunarMonth;
    const mergedLunarDay =
      dto.lunarDay !== undefined ? dto.lunarDay : existing.lunarDay;

    if (mergedIsLunar) {
      if (mergedLunarMonth == null || mergedLunarDay == null) {
        throw new DomainError(
          'Lunar events require lunar month and day.',
          'EVENT_LUNAR_DATE_INVALID',
          422,
        );
      }
      if (mergedLunarMonth < 1 || mergedLunarMonth > 12) {
        throw new DomainError(
          'Lunar month must be between 1 and 12.',
          'EVENT_LUNAR_DATE_INVALID',
          422,
        );
      }
      if (mergedLunarDay < 1 || mergedLunarDay > 30) {
        throw new DomainError(
          'Lunar day must be between 1 and 30.',
          'EVENT_LUNAR_DATE_INVALID',
          422,
        );
      }
    }

    let startAt: Date | undefined;
    let endAt: Date | null | undefined;
    if (dto.startAt) {
      startAt = new Date(dto.startAt);
      if (Number.isNaN(startAt.getTime())) {
        throw new DomainError('Invalid start date.', 'EVENT_DATE_INVALID', 422);
      }
    }
    if (dto.endAt !== undefined) {
      if (dto.endAt === null) {
        endAt = null;
      } else {
        endAt = new Date(dto.endAt);
        if (Number.isNaN(endAt.getTime())) {
          throw new DomainError('Invalid end date.', 'EVENT_DATE_INVALID', 422);
        }
      }
    }

    const effectiveStart = startAt ?? existing.startAt;
    const effectiveEnd = endAt !== undefined ? endAt : existing.endAt;
    if (effectiveEnd && effectiveEnd.getTime() < effectiveStart.getTime()) {
      throw new DomainError(
        'End date must be at or after start date.',
        'EVENT_DATE_INVALID',
        422,
      );
    }

    const localStartDate = dto.localStartDate
      ? new Date(`${dto.localStartDate}T00:00:00.000Z`)
      : undefined;
    const localEndDate =
      dto.localEndDate !== undefined
        ? dto.localEndDate === null
          ? null
          : new Date(`${dto.localEndDate}T00:00:00.000Z`)
        : undefined;

    const effectiveLocalStart = localStartDate ?? existing.localStartDate;
    const effectiveLocalEnd =
      localEndDate !== undefined ? localEndDate : existing.localEndDate;
    if (
      effectiveLocalEnd &&
      effectiveLocalEnd.getTime() < effectiveLocalStart.getTime()
    ) {
      throw new DomainError(
        'End date must be at or after start date.',
        'EVENT_DATE_INVALID',
        422,
      );
    }

    const updated = await this.repository.updateEvent({
      id: eventId,
      familyId: existing.familyId,
      type: dto.type,
      title: dto.title?.trim(),
      notes: dto.notes !== undefined ? (dto.notes?.trim() ?? null) : undefined,
      allDay: dto.allDay,
      startAt,
      endAt,
      localStartDate,
      localEndDate,
      timezone: dto.timezone,
      isLunar: dto.isLunar,
      lunarMonth: dto.lunarMonth,
      lunarDay: dto.lunarDay,
      lunarLeap: dto.lunarLeap,
      repeatYearly: dto.repeatYearly,
      inviteCircle: dto.inviteCircle,
      childIds: dto.childIds,
      participants: dto.participants,
      reminderRules: dto.reminderRules,
      expectedVersion: dto.version,
    });

    return this.toEventResponseDto(updated);
  }

  async deleteEvent(
    actor: AuthPrincipal,
    eventId: string,
  ): Promise<{ deleted: boolean }> {
    const existing = await this.repository.findEventById(eventId);
    if (!existing) {
      throw new NotFoundError('Event was not found.');
    }

    await this.access.requireParent(actor, existing.familyId, 'write');

    await this.repository.softDeleteEvent(eventId, existing.familyId);

    return { deleted: true };
  }

  private validateDateRange(from: string, to: string): void {
    const fromDate = new Date(`${from}T00:00:00.000Z`);
    const toDate = new Date(`${to}T00:00:00.000Z`);

    if (Number.isNaN(fromDate.getTime()) || Number.isNaN(toDate.getTime())) {
      throw new DomainError(
        'Invalid date format.',
        'CALENDAR_DATE_RANGE_INVALID',
        400,
      );
    }

    if (fromDate.getTime() > toDate.getTime()) {
      throw new DomainError(
        'from must be before or equal to to.',
        'CALENDAR_DATE_RANGE_INVALID',
        400,
      );
    }

    const days =
      Math.round((toDate.getTime() - fromDate.getTime()) / 86_400_000) + 1;

    if (days > CALENDAR_POLICY.maxCalendarRangeDays) {
      throw new DomainError(
        'Calendar query range cannot exceed 62 days.',
        'CALENDAR_DATE_RANGE_INVALID',
        400,
      );
    }
  }

  private validateEventInput(dto: CreateEventDto): void {
    if (
      ['COUPLE', 'NOTE', 'MEMORY_REMINDER'].includes(dto.type) &&
      dto.inviteCircle
    ) {
      throw new DomainError(
        'Circle cannot be invited to this event type.',
        'EVENT_INVITE_CIRCLE_INVALID',
        422,
      );
    }

    if (dto.isLunar) {
      if (dto.lunarMonth == null || dto.lunarDay == null) {
        throw new DomainError(
          'Lunar events require lunar month and day.',
          'EVENT_LUNAR_DATE_INVALID',
          422,
        );
      }
      if (dto.lunarMonth < 1 || dto.lunarMonth > 12) {
        throw new DomainError(
          'Lunar month must be between 1 and 12.',
          'EVENT_LUNAR_DATE_INVALID',
          422,
        );
      }
      if (dto.lunarDay < 1 || dto.lunarDay > 30) {
        throw new DomainError(
          'Lunar day must be between 1 and 30.',
          'EVENT_LUNAR_DATE_INVALID',
          422,
        );
      }
    }

    const startAt = new Date(dto.startAt);
    if (Number.isNaN(startAt.getTime())) {
      throw new DomainError('Invalid start date.', 'EVENT_DATE_INVALID', 422);
    }

    if (dto.endAt) {
      const endAt = new Date(dto.endAt);
      if (
        Number.isNaN(endAt.getTime()) ||
        endAt.getTime() < startAt.getTime()
      ) {
        throw new DomainError(
          'End date must be at or after start date.',
          'EVENT_DATE_INVALID',
          422,
        );
      }
    }
  }

  private resolveCalendarEvents(
    events: import('../models/calendar-event-view.model').CalendarEventView[],
    fromIso: string,
    toIso: string,
    isCircle: boolean,
    grantedChildIds: string[],
  ): EventResponseDto[] {
    const result: EventResponseDto[] = [];

    for (const view of events) {
      if (isCircle && !view.isVisibleToCircle(grantedChildIds)) {
        continue;
      }

      if (view.repeatYearly) {
        if (view.isLunar && view.lunarMonth && view.lunarDay) {
          const occurrences = findLunarOccurrencesInRange(
            view.lunarDay,
            view.lunarMonth,
            view.lunarLeap,
            fromIso,
            toIso,
          );
          for (const occ of occurrences) {
            result.push(this.toEventResponseDto(view, occ.date));
          }
        } else {
          const startStr =
            view.localStartDate instanceof Date
              ? view.localStartDate.toISOString().slice(0, 10)
              : String(view.localStartDate).slice(0, 10);
          const parsed = parseIsoDate(startStr);
          const occurrences = findGregorianOccurrencesInRange(
            parsed.month,
            parsed.day,
            fromIso,
            toIso,
          );
          for (const occ of occurrences) {
            result.push(this.toEventResponseDto(view, occ));
          }
        }
      } else {
        const startStr =
          view.localStartDate instanceof Date
            ? view.localStartDate.toISOString().slice(0, 10)
            : String(view.localStartDate).slice(0, 10);
        const endStr = view.localEndDate
          ? view.localEndDate instanceof Date
            ? view.localEndDate.toISOString().slice(0, 10)
            : String(view.localEndDate).slice(0, 10)
          : startStr;

        if (startStr <= toIso && endStr >= fromIso) {
          result.push(this.toEventResponseDto(view, startStr));
        }
      }
    }

    result.sort((a, b) => {
      const dateCmp = (a.occurrenceDate ?? '').localeCompare(
        b.occurrenceDate ?? '',
      );
      if (dateCmp !== 0) return dateCmp;
      const startCmp = a.startAt.localeCompare(b.startAt);
      if (startCmp !== 0) return startCmp;
      return a.id.localeCompare(b.id);
    });

    return result;
  }

  private toEventResponseDto(
    view: CalendarEventView,
    occurrenceDate?: string,
  ): EventResponseDto {
    const localStartStr =
      view.event.localStartDate instanceof Date
        ? view.event.localStartDate.toISOString().slice(0, 10)
        : String(view.event.localStartDate).slice(0, 10);

    const localEndStr = view.event.localEndDate
      ? view.event.localEndDate instanceof Date
        ? view.event.localEndDate.toISOString().slice(0, 10)
        : String(view.event.localEndDate).slice(0, 10)
      : null;

    return {
      id: view.event.id,
      familyId: view.event.familyId,
      type: view.event.type,
      title: view.event.title,
      notes: view.event.notes,
      allDay: view.event.allDay,
      startAt: view.event.startAt.toISOString(),
      endAt: view.event.endAt?.toISOString() ?? null,
      isLunar: view.event.isLunar,
      lunarMonth: view.event.lunarMonth,
      lunarDay: view.event.lunarDay,
      lunarLeap: view.event.lunarLeap,
      repeatYearly: view.event.repeatYearly,
      inviteCircle: view.event.inviteCircle,
      createdBy: view.event.createdBy,
      createdAt: view.event.createdAt.toISOString(),
      updatedAt: view.event.updatedAt.toISOString(),
      timezone: view.event.timezone,
      localStartDate: localStartStr,
      localEndDate: localEndStr,
      rrule: view.event.rrule,
      version: view.event.version,
      childIds: view.childIds,
      participants: view.participants.map((p): CalendarEventParticipantDto => ({
        userId: p.userId,
        response: p.response,
        respondedAt: p.respondedAt?.toISOString() ?? null,
      })),
      reminderRules: view.reminderRules.map(
        (r): CalendarEventReminderRuleDto => ({
          id: r.id,
          recipientUserId: r.recipientUserId,
          offsetMinutes: r.offsetMinutes,
          enabled: r.enabled,
        }),
      ),
      occurrenceDate: occurrenceDate ?? localStartStr,
    };
  }

  private projectMission(
    row: CalendarMissionRow,
    userId: string,
    todayStr: string,
  ): MyMissionDto | PartnerMissionDto | null {
    const m = row.mission;

    if (m.status === 'REMOVED') {
      return null;
    }

    const boardDateStr = m.boardDate.toISOString().slice(0, 10);
    const isMineOrTogether =
      m.ownerKind === 'TOGETHER' || m.ownerUserId === userId;

    if (isMineOrTogether) {
      return {
        id: m.id,
        familyId: m.familyId,
        boardDate: boardDateStr,
        ownerKind: m.ownerKind,
        mine: m.ownerUserId === userId,
        source: m.source,
        templateId: m.templateId,
        title: m.title,
        note: m.note,
        category: m.category,
        targetScope: m.targetScope,
        childIds: row.childIds,
        hearts: m.hearts,
        status: m.status,
        scheduledTime: m.scheduledTime?.toISOString().slice(11, 19) ?? null,
        dueAt: m.dueAt?.toISOString() ?? null,
        completedAt: m.completedAt?.toISOString() ?? null,
        late: m.late,
        canSwap: m.source === 'SYSTEM' && m.status === 'TODO',
        version: m.version,
        events: row.events.map((e) => ({
          type: e.type,
          createdAt: e.createdAt.toISOString(),
        })),
      };
    }

    // Partner mission
    if (m.status === 'EXPIRED') {
      return null;
    }

    if (m.status === 'TODO' && boardDateStr < todayStr) {
      return null;
    }

    if (m.status !== 'TODO' && m.status !== 'DONE') {
      return null;
    }

    return {
      id: m.id,
      title: m.title,
      category: m.category,
      childIds: row.childIds,
      status: m.status,
      completedAt: m.completedAt?.toISOString() ?? null,
      late: m.late,
      thanked: false,
    };
  }

  private computeSpecialDays(
    children: Child[],
    fromIso: string,
    toIso: string,
  ): CalendarSpecialDayDto[] {
    const specialDays: CalendarSpecialDayDto[] = [];
    const fromParts = parseIsoDate(fromIso);
    const toParts = parseIsoDate(toIso);

    for (const child of children) {
      const birthDateStr =
        child.birthDate instanceof Date
          ? child.birthDate.toISOString().slice(0, 10)
          : String(child.birthDate).slice(0, 10);
      const birthParts = parseIsoDate(birthDateStr);
      const childName = child.nickname ?? child.name ?? 'Bé';

      // 1. Birthdays
      for (let y = fromParts.year; y <= toParts.year; y++) {
        if (y > birthParts.year) {
          const maxDay = daysInMonth(y, birthParts.month);
          const d = Math.min(birthParts.day, maxDay);
          const bdayIso = toIsoDateString(y, birthParts.month, d);
          if (bdayIso >= fromIso && bdayIso <= toIso) {
            const ageYears = y - birthParts.year;
            specialDays.push({
              date: bdayIso,
              type: 'BIRTHDAY',
              childId: child.id,
              childName,
              title: `Sinh nhật ${childName} (${ageYears} tuổi)`,
              ageYears,
              isLunar: false,
            });
          }
        }
      }

      // 2. Monthiversaries
      if (child.monthlyPhotoMode !== 'OFF') {
        if (!child.monthlyPhotoLunar) {
          // Solar monthiversaries
          for (let k = 1; k <= 60; k++) {
            if (k < 12 || (k >= 12 && k % 3 === 0)) {
              const totalMonths = birthParts.month - 1 + k;
              const targetYear = birthParts.year + Math.floor(totalMonths / 12);
              const targetMonth = (totalMonths % 12) + 1;
              const maxDay = daysInMonth(targetYear, targetMonth);
              const targetDay = Math.min(birthParts.day, maxDay);
              const miversaryIso = toIsoDateString(
                targetYear,
                targetMonth,
                targetDay,
              );

              if (miversaryIso >= fromIso && miversaryIso <= toIso) {
                specialDays.push({
                  date: miversaryIso,
                  type: 'MONTHIVERSARY',
                  childId: child.id,
                  childName,
                  title: `${childName} tròn ${k} tháng`,
                  ageMonths: k,
                  isLunar: false,
                });
              }
            }
          }
        } else {
          // Lunar monthiversaries
          const birthLunar = solarToLunar(
            birthParts.year,
            birthParts.month,
            birthParts.day,
          );

          // Iterate each day in fromIso..toIso range
          const startDate = new Date(`${fromIso}T00:00:00.000Z`);
          const endDate = new Date(`${toIso}T00:00:00.000Z`);
          const current = new Date(startDate);

          while (current.getTime() <= endDate.getTime()) {
            const curIso = current.toISOString().slice(0, 10);
            const curParts = parseIsoDate(curIso);
            const curLunar = solarToLunar(
              curParts.year,
              curParts.month,
              curParts.day,
            );

            if (curLunar.day === birthLunar.day) {
              const elapsedMonths =
                (curLunar.year - birthLunar.year) * 12 +
                (curLunar.month - birthLunar.month);

              if (
                elapsedMonths > 0 &&
                (elapsedMonths < 12 ||
                  (elapsedMonths >= 12 && elapsedMonths % 3 === 0))
              ) {
                specialDays.push({
                  date: curIso,
                  type: 'MONTHIVERSARY',
                  childId: child.id,
                  childName,
                  title: `${childName} tròn ${elapsedMonths} tháng (Âm lịch)`,
                  ageMonths: elapsedMonths,
                  isLunar: true,
                });
              }
            }

            // Also check lunar birthday
            if (
              curLunar.day === birthLunar.day &&
              curLunar.month === birthLunar.month &&
              curLunar.year > birthLunar.year
            ) {
              const ageYears = curLunar.year - birthLunar.year;
              specialDays.push({
                date: curIso,
                type: 'BIRTHDAY',
                childId: child.id,
                childName,
                title: `Sinh nhật ${childName} (${ageYears} tuổi - Âm lịch)`,
                ageYears,
                isLunar: true,
              });
            }

            current.setDate(current.getDate() + 1);
          }
        }
      }
    }

    specialDays.sort((a, b) => {
      const dateCmp = a.date.localeCompare(b.date);
      if (dateCmp !== 0) return dateCmp;
      return a.childId.localeCompare(b.childId);
    });

    return specialDays;
  }
}
