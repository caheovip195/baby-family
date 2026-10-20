import type { CalendarEventView } from './calendar-event-view.model';
import type { Child } from './child.model';
import type { Mission } from './mission.model';

export class CalendarView {
  constructor(
    readonly from: string,
    readonly to: string,
    readonly events: CalendarEventView[],
    readonly missions: Mission[],
    readonly children: Child[],
  ) {}
}
