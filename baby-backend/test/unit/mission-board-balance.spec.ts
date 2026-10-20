import { MISSION_POLICY } from '../../src/config/mission-policy';
import { HEARTS_POLICY } from '../../src/config/hearts-policy';
import { COUPLE_REQUEST_POLICY } from '../../src/config/couple-request-policy';
import {
  MissionBoardBalanceModel,
  type MissionBoardCandidate,
} from '../../src/models/mission-board-balance.model';

const pool = (prefix: string, hearts = 4): MissionBoardCandidate[] =>
  Array.from({ length: 12 }, (_, index) => ({
    id: `${prefix}-${index}`,
    hearts,
    category: ['CARE', 'SELF', 'PLAY'][index % 3]!,
    weight: 1,
  }));

describe('Daily Mission board balancing', () => {
  it.each(['LIGHT', 'MEDIUM', 'HEAVY'] as const)(
    'preserves equal quotas and bounded Hearts across 100 seeds at %s level',
    (level) => {
      for (let seed = 0; seed < 100; seed++) {
        const candidates = pool('shared');
        const result = MissionBoardBalanceModel.generate({
          seed: `family:2026-10-18:v1:${seed}`,
          level,
          pools: [candidates, candidates],
          togetherPool: pool('together', 8),
        });
        expect(result.quota).toBe(MISSION_POLICY.levels[level].parentQuota);
        expect(result.parents[0]).toHaveLength(result.quota);
        expect(result.parents[1]).toHaveLength(result.quota);
        expect(result.balanceDiff).toBeLessThanOrEqual(2);
        const ids = result.parents.flat().map((item) => item.id);
        expect(new Set(ids).size).toBe(ids.length);
        if (level !== 'LIGHT') expect(result.together).toHaveLength(1);
      }
    },
  );

  it('is reproducible even when database pool ordering changes', () => {
    const candidates = pool('same');
    const input = {
      seed: 'family:date:v1',
      level: 'MEDIUM' as const,
      pools: [candidates, candidates] as const,
    };
    expect(MissionBoardBalanceModel.generate(input)).toEqual(
      MissionBoardBalanceModel.generate({
        ...input,
        pools: [[...candidates].reverse(), [...candidates].reverse()],
      }),
    );
  });

  it('reserves a SELF task for the carrier', () => {
    const candidates = pool('shared');
    const result = MissionBoardBalanceModel.generate({
      seed: 'carrier:date:v1',
      level: 'MEDIUM',
      pools: [candidates, candidates],
      requiredCategories: [['SELF'], []],
    });
    expect(result.quota).toBe(3);
    expect(result.parents[0].some((item) => item.category === 'SELF')).toBe(
      true,
    );
  });

  it('reduces both quotas when only smaller sets can balance', () => {
    const result = MissionBoardBalanceModel.generate({
      seed: 'small-pool',
      level: 'MEDIUM',
      pools: [pool('a', 4).slice(0, 2), pool('b', 4).slice(0, 2)],
    });
    expect(result.quota).toBe(2);
    expect(result.fallback).toBe(true);
    expect(result.parents.map((set) => set.length)).toEqual([2, 2]);
    expect(result.balanceDiff).toBe(0);
  });

  it('uses the configured Hearts target with a varied catalog', () => {
    const candidates = pool('varied').map((item, index) => ({
      ...item,
      hearts: 3 + (index % 3),
    }));
    for (let seed = 0; seed < 30; seed++) {
      const result = MissionBoardBalanceModel.generate({
        seed: `varied:${seed}`,
        level: 'MEDIUM',
        pools: [candidates, candidates],
      });
      expect(result.quota).toBe(3);
      expect(result.balanceDiff).toBeLessThanOrEqual(2);
      for (const hearts of result.heartTotals) {
        expect(hearts).toBeGreaterThanOrEqual(12);
        expect(hearts).toBeLessThanOrEqual(15);
      }
    }
  });

  it('reduces both quotas when full pools cannot meet the Hearts bound', () => {
    const result = MissionBoardBalanceModel.generate({
      seed: 'balanced-fallback',
      level: 'MEDIUM',
      pools: [pool('a', 4), pool('b', 5)],
    });
    expect(result.quota).toBe(2);
    expect(result.heartTotals).toEqual([8, 10]);
    expect(result.balanceDiff).toBe(2);
    expect(result.fallback).toBe(true);
  });

  it('reduces both quotas to zero rather than violate balance', () => {
    const result = MissionBoardBalanceModel.generate({
      seed: 'unbalanced',
      level: 'MEDIUM',
      pools: [pool('a', 1), pool('b', 10)],
    });
    expect(result.quota).toBe(0);
    expect(result.parents).toEqual([[], []]);
    expect(result.balanceDiff).toBe(0);
  });

  it('fails closed for a required category absent from the carrier pool', () => {
    const result = MissionBoardBalanceModel.generate({
      seed: 'no-self',
      level: 'LIGHT',
      pools: [pool('a').filter((item) => item.category !== 'SELF'), pool('b')],
      requiredCategories: [['SELF'], []],
    });
    expect(result.quota).toBe(0);
  });

  it('does not mutate pools and does not count duplicate template ids twice', () => {
    const candidates = pool('same');
    const original = JSON.stringify(candidates);
    const result = MissionBoardBalanceModel.generate({
      seed: 'duplicates',
      level: 'HEAVY',
      pools: [[...candidates, ...candidates], candidates],
    });
    expect(JSON.stringify(candidates)).toBe(original);
    expect(new Set(result.parents.flat().map((item) => item.id)).size).toBe(8);
  });

  it('uses augmenting paths to give distinct tasks to constrained children', () => {
    const items = [
      { id: 'flexible', category: 'CARE', hearts: 4, childIds: ['a', 'b'] },
      { id: 'only-a', category: 'CARE', hearts: 4, childIds: ['a'] },
    ];
    expect(MissionBoardBalanceModel.assignChildren(items, ['a', 'b'])).toEqual({
      flexible: ['b'],
      'only-a': ['a'],
    });
    expect(items[0]!.childIds).toEqual(['a', 'b']);
  });

  it('repairs selection to cover a child with a low-weight eligible task', () => {
    const candidates = pool('child').map((item, index) => ({
      ...item,
      childIds: index === 0 ? ['b'] : ['a'],
      weight: index === 0 ? 0.000001 : 1,
    }));
    for (let seed = 0; seed < 20; seed++) {
      const result = MissionBoardBalanceModel.generate({
        seed: `coverage:${seed}`,
        level: 'MEDIUM',
        pools: [candidates, candidates],
        childIds: ['a', 'b'],
      });
      expect(result.quota).toBe(3);
      expect(new Set(Object.values(result.assignedChildIds).flat())).toEqual(
        new Set(['a', 'b']),
      );
      expect(result.balanceDiff).toBeLessThanOrEqual(2);
    }
  });

  it('covers six children across six parent task slots', () => {
    const ids = ['a', 'b', 'c', 'd', 'e', 'f'];
    const candidates = pool('six').map((item, index) => ({
      ...item,
      childIds: [ids[index % ids.length]!],
    }));
    const result = MissionBoardBalanceModel.generate({
      seed: 'six-children',
      level: 'MEDIUM',
      pools: [candidates, candidates],
      childIds: ids,
    });
    expect(result.quota).toBe(3);
    expect(new Set(Object.values(result.assignedChildIds).flat())).toEqual(
      new Set(ids),
    );
  });

  it('uses one daily Hearts cap shared with requests', () => {
    expect(COUPLE_REQUEST_POLICY.dailyHeartCap).toBe(
      HEARTS_POLICY.dailyHeartCap,
    );
  });
});
