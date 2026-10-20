import { MissionRecurrenceModel } from '../../src/models/mission-recurrence.model';

describe('MissionRecurrenceModel', () => {
  const base = {
    rrule: 'FREQ=DAILY',
    startDate: '2026-10-19',
    endDate: null,
    pausedRanges: [],
  };

  it('stores every day as DAILY and selected days as WEEKLY', () => {
    expect(MissionRecurrenceModel.toRrule()).toBe('FREQ=DAILY');
    expect(MissionRecurrenceModel.toRrule(['FR', 'MO', 'MO'])).toBe(
      'FREQ=WEEKLY;BYDAY=MO,FR',
    );
    expect(MissionRecurrenceModel.days('FREQ=WEEKLY;BYDAY=MO,FR')).toEqual([
      'MO',
      'FR',
    ]);
    expect(MissionRecurrenceModel.days('FREQ=MONTHLY')).toBeNull();
  });

  it('respects start, end, weekdays and pauses', () => {
    // 2026-10-19 is a Monday.
    expect(
      MissionRecurrenceModel.occursOn({ ...base, date: '2026-10-18' }),
    ).toBe(false);
    expect(
      MissionRecurrenceModel.occursOn({ ...base, date: '2026-10-19' }),
    ).toBe(true);
    expect(
      MissionRecurrenceModel.occursOn({
        ...base,
        endDate: '2026-10-20',
        date: '2026-10-21',
      }),
    ).toBe(false);
    expect(
      MissionRecurrenceModel.occursOn({
        ...base,
        rrule: 'FREQ=WEEKLY;BYDAY=MO,WE',
        date: '2026-10-20',
      }),
    ).toBe(false);
    expect(
      MissionRecurrenceModel.occursOn({
        ...base,
        rrule: 'FREQ=WEEKLY;BYDAY=MO,WE',
        date: '2026-10-21',
      }),
    ).toBe(true);
    expect(
      MissionRecurrenceModel.occursOn({
        ...base,
        pausedRanges: [{ from: '2026-10-22', to: '2026-10-23' }, 'junk'],
        date: '2026-10-23',
      }),
    ).toBe(false);
    // Unsupported rules never materialize.
    expect(
      MissionRecurrenceModel.occursOn({
        ...base,
        rrule: 'FREQ=MONTHLY',
        date: '2026-10-19',
      }),
    ).toBe(false);
  });
});
