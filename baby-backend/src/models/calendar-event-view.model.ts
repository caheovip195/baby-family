import type { Event } from './event.model';
import type { EventParticipant } from './event-participant.model';
import type { EventReminderRule } from './event-reminder-rule.model';

export class CalendarEventView {
  constructor(
    readonly event: Event,
    readonly childIds: string[],
    readonly participants: EventParticipant[],
    readonly reminderRules: EventReminderRule[],
  ) {}

  get id(): string {
    return this.event.id;
  }

  get familyId(): string {
    return this.event.familyId;
  }

  get type(): string {
    return this.event.type;
  }

  get title(): string {
    return this.event.title;
  }

  get notes(): string | null {
    return this.event.notes;
  }

  get allDay(): boolean {
    return this.event.allDay;
  }

  get startAt(): Date {
    return this.event.startAt;
  }

  get endAt(): Date | null {
    return this.event.endAt;
  }

  get isLunar(): boolean {
    return this.event.isLunar;
  }

  get lunarMonth(): number | null {
    return this.event.lunarMonth;
  }

  get lunarDay(): number | null {
    return this.event.lunarDay;
  }

  get lunarLeap(): boolean | null {
    return this.event.lunarLeap;
  }

  get repeatYearly(): boolean {
    return this.event.repeatYearly;
  }

  get inviteCircle(): boolean {
    return this.event.inviteCircle;
  }

  get createdBy(): string {
    return this.event.createdBy;
  }

  get createdAt(): Date {
    return this.event.createdAt;
  }

  get updatedAt(): Date {
    return this.event.updatedAt;
  }

  get timezone(): string {
    return this.event.timezone;
  }

  get localStartDate(): Date {
    return this.event.localStartDate;
  }

  get localEndDate(): Date | null {
    return this.event.localEndDate;
  }

  get rrule(): string | null {
    return this.event.rrule;
  }

  get version(): number {
    return this.event.version;
  }

  /**
   * COUPLE events are strictly for Parents; Circle never sees them.
   * Circle only sees events where inviteCircle is true and
   * if childIds are present, the circle member must be granted access to at least one child.
   */
  isVisibleToCircle(grantedChildIds: string[]): boolean {
    if (!this.event.inviteCircle) return false;
    if (this.event.type === 'COUPLE') return false;
    if (this.childIds.length === 0) return true;
    return this.childIds.some((id) => grantedChildIds.includes(id));
  }
}
