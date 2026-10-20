import { Inject, Injectable } from '@nestjs/common';
import { BADGE_AWARD_POLICY } from '../config/badge-award-policy';
import { BADGE_AWARD_REPOSITORY } from '../interfaces/repositories/badge-award-repository.interface';
import type {
  BadgeAwardDecision,
  BadgeAwardSnapshot,
  IBadgeAwardRepository,
} from '../interfaces/repositories/badge-award-repository.interface';
import type { IBadgeAwardService } from '../interfaces/services/badge-award-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';

@Injectable()
export class BadgeAwardService implements IBadgeAwardService {
  constructor(
    @Inject(BADGE_AWARD_REPOSITORY)
    private readonly repository: IBadgeAwardRepository,
  ) {}
  async award(
    now: Date,
    context: JobContext,
    eventId?: string,
  ): Promise<Record<string, number>> {
    let awarded = 0;
    let families = 0;
    if (eventId) {
      const familyId = await this.repository.eventFamily(eventId);
      if (familyId) {
        awarded += await this.repository.award(familyId, now, context, (s) =>
          this.evaluate(s),
        );
        families++;
      }
    } else {
      let cursor: string | undefined;
      for (;;) {
        context.signal.throwIfAborted();
        const ids = await this.repository.families(cursor);
        for (const id of ids) {
          context.signal.throwIfAborted();
          awarded += await this.repository.award(id, now, context, (s) =>
            this.evaluate(s),
          );
          families++;
        }
        if (ids.length < BADGE_AWARD_POLICY.batchSize) break;
        cursor = ids.at(-1);
      }
    }
    return { awarded, families };
  }
  private evaluate(snapshot: BadgeAwardSnapshot): BadgeAwardDecision[] {
    const decisions: BadgeAwardDecision[] = [];
    for (const badge of snapshot.badges) {
      const rule = badge.rule as { metric?: unknown; target?: unknown } | null;
      if (
        !rule ||
        typeof rule.metric !== 'string' ||
        typeof rule.target !== 'number' ||
        !Number.isFinite(rule.target) ||
        rule.target <= 0
      )
        continue;
      const privateHearts = (
        BADGE_AWARD_POLICY.privateHeartsMetrics as readonly string[]
      ).includes(rule.metric);
      if (privateHearts) {
        // BR-018: a malformed FAMILY Hearts rule must never expose personal totals.
        if (badge.scope !== 'USER' && badge.scope !== 'PERSON') continue;
        for (const userId of snapshot.parentIds) {
          if ((snapshot.heartsByUser[userId] ?? 0) >= rule.target)
            decisions.push({ badgeCode: badge.code, subjectUserId: userId });
        }
      } else if (
        badge.scope === 'FAMILY' &&
        (snapshot.metrics[rule.metric] ?? 0) >= rule.target
      ) {
        decisions.push({ badgeCode: badge.code, subjectUserId: null });
      }
    }
    return decisions;
  }
}
