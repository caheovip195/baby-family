export const CALENDAR_POLICY = {
  maxCalendarRangeDays: 62,
  defaultTimezone: 'Asia/Ho_Chi_Minh',
  allowedTypes: [
    'CHILD',
    'FAMILY',
    'COUPLE',
    'MEMORY_REMINDER',
    'NOTE',
  ] as const,
  circleAllowedTypes: ['CHILD', 'FAMILY'] as const,
  maxTitleLength: 120,
  maxNotesLength: 2000,
  defaultReminderOffsetMinutes: 15,
} as const;

export type EventType = (typeof CALENDAR_POLICY.allowedTypes)[number];
