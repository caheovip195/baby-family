import {
  MISSION_POLICY,
  type MissionBoardPolicyLevel,
} from '../config/mission-policy';

export interface MissionBoardCandidate {
  id: string;
  hearts: number;
  category: string;
  weight?: number;
  childIds?: readonly string[];
}

export interface MissionBoardBalanceInput<T extends MissionBoardCandidate> {
  seed: string;
  level: MissionBoardPolicyLevel;
  /** Eligibility, age, preferences and recent exclusions are resolved by caller. */
  pools: readonly [readonly T[], readonly T[]];
  togetherPool?: readonly T[];
  childIds?: readonly string[];
  requiredCategories?: readonly [readonly string[], readonly string[]];
}

export interface MissionBoardBalanceResult<T extends MissionBoardCandidate> {
  parents: [T[], T[]];
  together: T[];
  quota: number;
  heartTotals: [number, number];
  balanceDiff: number;
  fallback: boolean;
  assignedChildIds: Record<string, string[]>;
}

/** Pure deterministic selection helper; contains no database or service I/O. */
export class MissionBoardBalanceModel {
  static generate<T extends MissionBoardCandidate>(
    input: MissionBoardBalanceInput<T>,
  ): MissionBoardBalanceResult<T> {
    const policy = MISSION_POLICY.levels[input.level];
    const rng = this.random(input.seed);
    const pools = input.pools.map((pool) =>
      [...new Map(pool.map((item) => [item.id, item])).values()]
        .filter((item) => Number.isFinite(item.hearts) && item.hearts >= 0)
        .sort((a, b) => a.id.localeCompare(b.id)),
    );
    const required = input.requiredCategories ?? [[], []];
    const eligibleChildren = [...new Set(input.childIds ?? [])].filter((id) =>
      pools.some((pool) =>
        pool.some((candidate) => candidate.childIds?.includes(id)),
      ),
    );
    let selected: [T[], T[]] = [[], []];
    for (let n = policy.parentQuota; n > 0; n--) {
      const coverageChildren =
        2 * n >= eligibleChildren.length ? eligibleChildren : [];
      let best: [T[], T[]] | undefined;
      let bestScore = Number.POSITIVE_INFINITY;
      for (
        let attempt = 0;
        attempt < MISSION_POLICY.sampleAttempts;
        attempt++
      ) {
        // Alternate first pick to avoid systematically favouring either Parent.
        const first = attempt % 2;
        const second = 1 - first;
        const a = this.sample(pools[first]!, n, required[first]!, rng);
        const used = new Set(a.map((item) => item.id));
        const b = this.sample(
          pools[second]!.filter((item) => !used.has(item.id)),
          n,
          required[second]!,
          rng,
        );
        if (a.length !== n || b.length !== n) continue;
        const sets: [T[], T[]] = first === 0 ? [a, b] : [b, a];
        const score = this.score(sets, policy.targetHearts, coverageChildren);
        if (score < bestScore) {
          best = sets;
          bestScore = score;
        }
        if (score === 0) break;
      }
      if (!best) continue;
      for (let repair = 0; repair < MISSION_POLICY.repairAttempts; repair++) {
        let bestRepairScore = this.score(
          best,
          policy.targetHearts,
          coverageChildren,
        );
        if (bestRepairScore === 0) break;
        const occupied = new Set(best.flat().map((item) => item.id));
        let repaired: [T[], T[]] | undefined;
        for (const owner of [0, 1] as const) {
          for (const candidate of pools[owner]!) {
            if (occupied.has(candidate.id)) continue;
            for (let index = 0; index < n; index++) {
              const replacement = [...best[owner]];
              replacement[index] = candidate;
              if (!this.hasRequired(replacement, required[owner])) continue;
              const next: [T[], T[]] =
                owner === 0 ? [replacement, best[1]] : [best[0], replacement];
              const score = this.score(
                next,
                policy.targetHearts,
                coverageChildren,
              );
              if (score < bestRepairScore) {
                bestRepairScore = score;
                repaired = next;
              }
            }
          }
        }
        if (!repaired) break;
        best = repaired;
      }
      if (
        Math.abs(this.total(best[0]) - this.total(best[1])) <=
          MISSION_POLICY.maxBalanceDiff &&
        this.coversChildren(best.flat(), coverageChildren)
      ) {
        selected = best;
        break;
      }
    }
    const heartTotals: [number, number] = [
      this.total(selected[0]),
      this.total(selected[1]),
    ];
    const together =
      rng() < policy.togetherProbability
        ? this.sample(
            [...(input.togetherPool ?? [])].sort((a, b) =>
              a.id.localeCompare(b.id),
            ),
            1,
            [],
            rng,
          )
        : [];
    return {
      parents: selected,
      together,
      quota: selected[0].length,
      heartTotals,
      balanceDiff: Math.abs(heartTotals[0] - heartTotals[1]),
      fallback: selected[0].length < policy.parentQuota,
      assignedChildIds: {
        ...this.assignChildren(selected.flat(), eligibleChildren),
        ...this.assignChildren(together, []),
      },
    };
  }

  /** Maximum bipartite matching: each child reserves a different task slot. */
  static assignChildren(
    items: readonly MissionBoardCandidate[],
    childIds: readonly string[],
  ): Record<string, string[]> {
    const assigned = new Map<number, string>();
    const reserve = (childId: string, visited: Set<number>): boolean => {
      for (let index = 0; index < items.length; index++) {
        if (visited.has(index) || !items[index]!.childIds?.includes(childId))
          continue;
        visited.add(index);
        const previous = assigned.get(index);
        if (!previous || reserve(previous, visited)) {
          assigned.set(index, childId);
          return true;
        }
      }
      return false;
    };
    for (const id of [...new Set(childIds)].sort()) reserve(id, new Set());
    const counts = new Map<string, number>();
    for (const id of assigned.values())
      counts.set(id, (counts.get(id) ?? 0) + 1);
    const result: Record<string, string[]> = {};
    for (const [index, item] of items.entries()) {
      const id =
        assigned.get(index) ??
        [...(item.childIds ?? [])].sort(
          (a, b) =>
            (counts.get(a) ?? 0) - (counts.get(b) ?? 0) || a.localeCompare(b),
        )[0];
      result[item.id] = id ? [id] : [];
      if (id && !assigned.has(index)) counts.set(id, (counts.get(id) ?? 0) + 1);
    }
    return result;
  }

  private static coversChildren(
    items: readonly MissionBoardCandidate[],
    ids: readonly string[],
  ): boolean {
    const covered = new Set(
      Object.values(this.assignChildren(items, ids)).flat(),
    );
    return ids.every((id) => covered.has(id));
  }

  private static total(items: readonly MissionBoardCandidate[]): number {
    return items.reduce((sum, item) => sum + item.hearts, 0);
  }

  private static hasRequired(
    items: readonly MissionBoardCandidate[],
    categories: readonly string[],
  ): boolean {
    return categories.every((category) =>
      items.some((item) => item.category === category),
    );
  }

  private static sample<T extends MissionBoardCandidate>(
    pool: readonly T[],
    n: number,
    required: readonly string[],
    rng: () => number,
  ): T[] {
    const remaining = [...pool];
    const result: T[] = [];
    for (let i = 0; i < n && remaining.length > 0; i++) {
      const missing = required.find(
        (category) => !result.some((item) => item.category === category),
      );
      const eligible = remaining.filter(
        (item) => !missing || item.category === missing,
      );
      if (eligible.length === 0) return [];
      const weights = eligible.map((item) => {
        const base = Number.isFinite(item.weight)
          ? Math.max(0, item.weight ?? 1)
          : 1;
        return (
          base *
          (result.some((old) => old.category === item.category) ? 1 : 1.3)
        );
      });
      const total = weights.reduce((sum, weight) => sum + weight, 0);
      let ticket = rng() * total;
      let choice = eligible[eligible.length - 1]!;
      for (let index = 0; index < eligible.length; index++) {
        ticket -= total === 0 ? 1 : weights[index]!;
        if (ticket <= 0) {
          choice = eligible[index]!;
          break;
        }
      }
      result.push(choice);
      remaining.splice(remaining.indexOf(choice), 1);
    }
    return this.hasRequired(result, required) ? result : [];
  }

  private static score(
    sets: readonly [
      readonly MissionBoardCandidate[],
      readonly MissionBoardCandidate[],
    ],
    target: readonly [number, number],
    childIds: readonly string[],
  ): number {
    const totals = sets.map((set) => this.total(set));
    const distance = (value: number) =>
      Math.max(0, target[0] - value, value - target[1]);
    const childCounts = new Map<string, number>();
    for (const item of sets.flat()) {
      for (const id of item.childIds ?? [])
        childCounts.set(id, (childCounts.get(id) ?? 0) + 1);
    }
    const counts = [...childCounts.values()];
    const imbalance = counts.length
      ? Math.max(...counts) - Math.min(...counts)
      : 0;
    const covered = new Set(
      Object.values(this.assignChildren(sets.flat(), childIds)).flat(),
    );
    const missingChildren = childIds.filter((id) => !covered.has(id)).length;
    return (
      1000 * missingChildren +
      10 *
        Math.max(
          0,
          Math.abs(totals[0]! - totals[1]!) - MISSION_POLICY.maxBalanceDiff,
        ) +
      distance(totals[0]!) +
      distance(totals[1]!) +
      imbalance
    );
  }

  private static random(seed: string): () => number {
    let state = 2166136261;
    for (let i = 0; i < seed.length; i++)
      state = Math.imul(state ^ seed.charCodeAt(i), 16777619);
    return () => {
      state += 0x6d2b79f5;
      let t = Math.imul(state ^ (state >>> 15), state | 1);
      t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }
}
