import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { CalendarQueryDto } from '../../dto/calendar/calendar-query.dto';
import type { CalendarResponseDto } from '../../dto/calendar/calendar-response.dto';
import type { CreateEventDto } from '../../dto/calendar/create-event.dto';
import type { EventResponseDto } from '../../dto/calendar/event-response.dto';
import type { UpdateEventDto } from '../../dto/calendar/update-event.dto';

export const CALENDAR_SERVICE = Symbol('CALENDAR_SERVICE');

export interface ICalendarService {
  getCalendar(
    actor: AuthPrincipal,
    familyId: string,
    query: CalendarQueryDto,
  ): Promise<CalendarResponseDto>;

  createEvent(
    actor: AuthPrincipal,
    dto: CreateEventDto,
  ): Promise<EventResponseDto>;

  getEvent(actor: AuthPrincipal, eventId: string): Promise<EventResponseDto>;

  updateEvent(
    actor: AuthPrincipal,
    eventId: string,
    dto: UpdateEventDto,
  ): Promise<EventResponseDto>;

  deleteEvent(
    actor: AuthPrincipal,
    eventId: string,
  ): Promise<{ deleted: boolean }>;
}
