import { EventReminderScheduleService } from '../../src/services/event-reminder-schedule.service';
import type { IEventReminderScheduleRepository } from '../../src/interfaces/repositories/event-reminder-schedule-repository.interface';
import { Event } from '../../src/models/event.model';

function event(overrides: Partial<Event> = {}): Event {
  return new Event({
    id: 'event',
    familyId: 'family',
    type: 'FAMILY',
    title: 'Annual event',
    notes: null,
    allDay: false,
    startAt: new Date('2025-03-09T13:00:00Z'),
    endAt: null,
    isLunar: false,
    lunarMonth: null,
    lunarDay: null,
    lunarLeap: null,
    repeatYearly: true,
    inviteCircle: false,
    createdBy: 'parent',
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    timezone: 'America/New_York',
    localStartDate: new Date('2025-03-09'),
    localEndDate: null,
    rrule: null,
    version: 1,
    ...overrides,
  });
}

describe('Event reminder recurrence', () => {
  const service = new EventReminderScheduleService(
    {} as IEventReminderScheduleRepository,
  );
  it('preserves the local clock across differing yearly DST offsets', () => {
    expect(
      service.occurrences(
        event(),
        new Date('2026-03-09T00:00Z'),
        new Date('2026-03-10T00:00Z'),
      ),
    ).toEqual([new Date('2026-03-09T13:00:00Z')]);
    expect(
      service.occurrences(
        event(),
        new Date('2027-03-09T00:00Z'),
        new Date('2027-03-10T00:00Z'),
      ),
    ).toEqual([new Date('2027-03-09T14:00:00Z')]);
  });
  it('resolves an all-day annual event to local midnight', () => {
    expect(
      service.occurrences(
        event({ allDay: true }),
        new Date('2027-03-09T00:00Z'),
        new Date('2027-03-10T00:00Z'),
      ),
    ).toEqual([new Date('2027-03-09T05:00:00Z')]);
  });
  it('does not backfill annual occurrences before the event starts', () => {
    expect(
      service.occurrences(
        event(),
        new Date('2024-03-09T00:00Z'),
        new Date('2024-03-10T00:00Z'),
      ),
    ).toEqual([]);
  });
  it('uses the existing lunar occurrence finder', () => {
    const lunar = event({
      timezone: 'Asia/Ho_Chi_Minh',
      startAt: new Date('2025-01-29T02:00Z'),
      localStartDate: new Date('2025-01-29'),
      isLunar: true,
      lunarMonth: 1,
      lunarDay: 1,
      lunarLeap: false,
    });
    expect(
      service.occurrences(
        lunar,
        new Date('2026-02-10'),
        new Date('2026-02-24'),
      ),
    ).toEqual([new Date('2026-02-17T02:00Z')]);
  });
  it('clamps February 29 consistently with the calendar finder', () => {
    expect(
      service.occurrences(
        event({
          timezone: 'UTC',
          startAt: new Date('2024-02-29T09:00Z'),
          localStartDate: new Date('2024-02-29'),
        }),
        new Date('2025-02-27'),
        new Date('2025-03-01'),
      ),
    ).toEqual([new Date('2025-02-28T09:00Z')]);
  });
  it('includes a one-off event at the exact boundary only once', () => {
    const oneOff = event({ repeatYearly: false });
    expect(service.occurrences(oneOff, oneOff.startAt, oneOff.startAt)).toEqual(
      [oneOff.startAt],
    );
    expect(
      service.occurrences(
        oneOff,
        new Date(oneOff.startAt.getTime() + 1),
        new Date('2026-01-01'),
      ),
    ).toEqual([]);
  });
});
