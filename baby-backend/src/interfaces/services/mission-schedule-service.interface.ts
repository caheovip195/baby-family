import type { JobContext } from './job-runner-service.interface';

export const MISSION_SCHEDULE_SERVICE = Symbol('MISSION_SCHEDULE_SERVICE');

/** Background mission work (BF-20261019-003): morning boards. */
export interface IMissionScheduleService {
  /**
   * Creates today's board for every ACTIVE family whose local time has passed
   * the configured board hour; idempotent per family and local date.
   */
  prepareDueBoards(
    now: Date,
    context: JobContext,
  ): Promise<Record<string, number>>;
}
