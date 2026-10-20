import type { JobContext } from './job-runner-service.interface';
export const BADGE_AWARD_SERVICE = Symbol('BADGE_AWARD_SERVICE');
export interface IBadgeAwardService {
  award(
    now: Date,
    context: JobContext,
    eventId?: string,
  ): Promise<Record<string, number>>;
}
