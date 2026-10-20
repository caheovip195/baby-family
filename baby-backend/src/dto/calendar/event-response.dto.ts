export interface CalendarEventParticipantDto {
  userId: string;
  response: string;
  respondedAt: string | null;
}

export interface CalendarEventReminderRuleDto {
  id: string;
  recipientUserId: string;
  offsetMinutes: number;
  enabled: boolean;
}

export interface EventResponseDto {
  id: string;
  familyId: string;
  type: string;
  title: string;
  notes: string | null;
  allDay: boolean;
  startAt: string;
  endAt: string | null;
  isLunar: boolean;
  lunarMonth: number | null;
  lunarDay: number | null;
  lunarLeap: boolean | null;
  repeatYearly: boolean;
  inviteCircle: boolean;
  createdBy: string;
  createdAt: string;
  updatedAt: string;
  timezone: string;
  localStartDate: string;
  localEndDate: string | null;
  rrule: string | null;
  version: number;
  childIds: string[];
  participants: CalendarEventParticipantDto[];
  reminderRules: CalendarEventReminderRuleDto[];
  occurrenceDate?: string;
}

export interface CalendarSpecialDayDto {
  date: string;
  type: 'BIRTHDAY' | 'MONTHIVERSARY';
  childId: string;
  childName: string;
  title: string;
  ageYears?: number;
  ageMonths?: number;
  isLunar?: boolean;
}
