import type { Pregnancy } from './pregnancy.model';
import type { PregnancyNameCandidate } from './pregnancy-name-candidate.model';
import type { Memory } from './memory.model';
import type { Milestone } from './milestone.model';

export class PregnancyNamingEntry {
  constructor(
    readonly candidate: PregnancyNameCandidate,
    readonly likedByUserIds: string[],
  ) {}
}

export class PregnancyNamingState {
  constructor(
    readonly pregnancy: Pregnancy,
    readonly coupleSpaceId: string,
    readonly partnerUserId: string,
    readonly timezone: string,
    readonly entries: PregnancyNamingEntry[],
    readonly milestone: { memory: Memory; milestone: Milestone } | null,
    readonly quotas: unknown,
  ) {}
}
