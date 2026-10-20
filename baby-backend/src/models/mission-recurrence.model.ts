/**
 * Recurrence of a custom mission series (BF-20261019-003). Stored in
 * `mission_series.rrule` as a small RFC 5545 subset: `FREQ=DAILY` or
 * `FREQ=WEEKLY;BYDAY=MO,WE,FR`. Pauses are `[{from, to}]` local dates.
 */
export const WEEKDAYS = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'] as const;
export type Weekday = (typeof WEEKDAYS)[number];

export interface PausedRange {
  from: string;
  to: string;
}

export class MissionRecurrenceModel {
  /** `days` empty/undefined = every day. */
  static toRrule(days?: readonly Weekday[]): string {
    const unique = WEEKDAYS.filter((day) => days?.includes(day));
    return unique.length === 0 || unique.length === WEEKDAYS.length
      ? 'FREQ=DAILY'
      : `FREQ=WEEKLY;BYDAY=${unique.join(',')}`;
  }

  /** Weekdays of a stored rule; null when the rule is not supported. */
  static days(rrule: string): Weekday[] | null {
    if (rrule === 'FREQ=DAILY') return [...WEEKDAYS];
    const match = /^FREQ=WEEKLY;BYDAY=([A-Z,]+)$/.exec(rrule);
    if (!match) return null;
    const days = match[1]!.split(',');
    return days.every((day) => (WEEKDAYS as readonly string[]).includes(day))
      ? (days as Weekday[])
      : null;
  }

  static pausedRanges(value: unknown): PausedRange[] {
    if (!Array.isArray(value)) return [];
    return value.filter(
      (item): item is PausedRange =>
        typeof item === 'object' &&
        item !== null &&
        typeof (item as PausedRange).from === 'string' &&
        typeof (item as PausedRange).to === 'string',
    );
  }

  /** Whether the series has a mission on `date` (yyyy-MM-dd, family-local). */
  static occursOn(input: {
    rrule: string;
    startDate: string;
    endDate: string | null;
    pausedRanges: unknown;
    date: string;
  }): boolean {
    if (input.date < input.startDate) return false;
    if (input.endDate && input.date > input.endDate) return false;
    const paused = MissionRecurrenceModel.pausedRanges(input.pausedRanges).some(
      (range) => input.date >= range.from && input.date <= range.to,
    );
    if (paused) return false;
    const days = MissionRecurrenceModel.days(input.rrule);
    if (!days) return false;
    const weekday = WEEKDAYS[new Date(`${input.date}T00:00:00Z`).getUTCDay()]!;
    return days.includes(weekday);
  }
}

/** A custom mission series as the application sees it. */
export class MissionSeriesModel {
  constructor(
    readonly id: string,
    readonly familyId: string,
    readonly ownerKind: 'PARENT' | 'TOGETHER',
    readonly ownerUserId: string | null,
    readonly title: string,
    readonly note: string | null,
    readonly category: string,
    readonly childIds: string[],
    readonly timeOfDay: Date | null,
    readonly startDate: Date,
    readonly endDate: Date | null,
    readonly rrule: string,
    readonly pausedRanges: PausedRange[],
    readonly status: string,
    readonly timezone: string,
    readonly version: number,
  ) {}
}

/** CARE-12: one Parent's mission preferences. */
export class MissionPreferenceModel {
  constructor(
    readonly disabledCategories: string[],
    readonly boardPushTime: Date,
    readonly eveningCarryOver: boolean,
    readonly defaultReminderMin: number | null,
  ) {}
}
