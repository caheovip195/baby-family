import type { CalendarEventView } from '../../models/calendar-event-view.model';
import type { Child } from '../../models/child.model';
import type { Family } from '../../models/family.model';
import type { Mission } from '../../models/mission.model';
import type { EventType } from '../../config/calendar-policy';

export const CALENDAR_REPOSITORY = Symbol('CALENDAR_REPOSITORY');

export interface FamilyCalendarContext {
  family: Family | null;
  isParent: boolean;
  isCircle: boolean;
  grantedChildIds: string[];
}

export interface CalendarMissionRow {
  mission: Mission;
  childIds: string[];
  events: { type: string; createdAt: Date }[];
}

export interface CreateEventCommand {
  familyId: string;
  type: EventType;
  title: string;
  notes?: string | null;
  allDay: boolean;
  startAt: Date;
  endAt?: Date | null;
  localStartDate: Date;
  localEndDate?: Date | null;
  timezone: string;
  isLunar: boolean;
  lunarMonth?: number | null;
  lunarDay?: number | null;
  lunarLeap?: boolean | null;
  repeatYearly: boolean;
  inviteCircle: boolean;
  createdBy: string;
  childIds?: string[];
  participants?: Array<{
    userId: string;
    response?: string;
  }>;
  reminderRules?: Array<{
    recipientUserId: string;
    offsetMinutes: number;
    enabled?: boolean;
  }>;
}

export interface UpdateEventCommand {
  id: string;
  familyId: string;
  type?: EventType;
  title?: string;
  notes?: string | null;
  allDay?: boolean;
  startAt?: Date;
  endAt?: Date | null;
  localStartDate?: Date;
  localEndDate?: Date | null;
  timezone?: string;
  isLunar?: boolean;
  lunarMonth?: number | null;
  lunarDay?: number | null;
  lunarLeap?: boolean | null;
  repeatYearly?: boolean;
  inviteCircle?: boolean;
  childIds?: string[];
  participants?: Array<{
    userId: string;
    response?: string;
  }>;
  reminderRules?: Array<{
    recipientUserId: string;
    offsetMinutes: number;
    enabled?: boolean;
  }>;
  expectedVersion?: number;
}

export interface ICalendarRepository {
  findFamilyContext(
    familyId: string,
    userId: string,
  ): Promise<FamilyCalendarContext>;

  findEventsForCalendar(
    familyId: string,
    fromDate: Date,
    toDate: Date,
    childId?: string,
  ): Promise<CalendarEventView[]>;

  findEventById(id: string): Promise<CalendarEventView | null>;

  findFamilyChildren(familyId: string, childId?: string): Promise<Child[]>;

  findCalendarMissions(
    familyId: string,
    fromDate: Date,
    toDate: Date,
    childId?: string,
  ): Promise<CalendarMissionRow[]>;

  createEvent(command: CreateEventCommand): Promise<CalendarEventView>;

  updateEvent(command: UpdateEventCommand): Promise<CalendarEventView>;

  softDeleteEvent(id: string, familyId: string): Promise<void>;
}
