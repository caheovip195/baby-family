import type { JobContext } from '../services/job-runner-service.interface';

export const BADGE_AWARD_REPOSITORY = Symbol('BADGE_AWARD_REPOSITORY');
export interface BadgeAwardCandidate {
  code: string;
  scope: string;
  rule: unknown;
}
export interface BadgeAwardSnapshot {
  badges: BadgeAwardCandidate[];
  parentIds: string[];
  metrics: Record<string, number>;
  heartsByUser: Record<string, number>;
}
export interface BadgeAwardDecision {
  badgeCode: string;
  subjectUserId: string | null;
}
export interface IBadgeAwardRepository {
  eventFamily(eventId: string): Promise<string | null>;
  families(after?: string): Promise<string[]>;
  award(
    familyId: string,
    now: Date,
    context: JobContext,
    evaluate: (snapshot: BadgeAwardSnapshot) => BadgeAwardDecision[],
  ): Promise<number>;
}
