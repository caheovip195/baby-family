import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { MISSION_POLICY } from '../../src/config/mission-policy';

interface Template {
  code: string;
  stage: 'PREGNANCY' | 'CHILD' | 'ANY';
  minAgeDays: number | null;
  maxAgeDays: number | null;
  minPregWeek: number | null;
  maxPregWeek: number | null;
  roleFit:
    'ANY_PARENT' | 'PREGNANT_MOTHER' | 'PARTNER_OF_PREGNANT' | 'TOGETHER';
  rolloutPct: number;
  status: string;
  category: string;
}

const catalog = JSON.parse(
  readFileSync(join(process.cwd(), 'prisma/seeds/missions.json'), 'utf8'),
) as { templates: Template[] };
const active = catalog.templates.filter(
  (t) => t.status === 'ACTIVE' && t.rolloutPct === 100,
);

/** Same age/week window rule as MissionBoardRepository.matches. */
const eligible = (t: Template, at: { ageDays?: number; week?: number }) => {
  if (t.stage === 'ANY') return true;
  if (t.stage === 'CHILD')
    return (
      at.ageDays !== undefined &&
      (t.minAgeDays === null || at.ageDays >= t.minAgeDays) &&
      (t.maxAgeDays === null || at.ageDays <= t.maxAgeDays)
    );
  return (
    at.week !== undefined &&
    (t.minPregWeek === null || at.week >= t.minPregWeek) &&
    (t.maxPregWeek === null || at.week <= t.maxPregWeek)
  );
};

/**
 * Checklist “≥ 90 days of content per stage”: at the default level each Parent
 * gets `parentQuota` missions and the couple one TOGETHER mission a day, and a
 * template must not repeat inside `repeatWindowDays`. Enough distinct templates
 * for one window means the strict window never relaxes, for any number of days.
 */
describe('Mission catalog covers every stage without relaxing the repeat window', () => {
  const window = MISSION_POLICY.repeatWindowDays;
  const quota = MISSION_POLICY.levels[MISSION_POLICY.defaultLevel].parentQuota;
  const needParents = 2 * quota * window;
  const needEach = quota * window;
  const needTogether = window;

  const check = (at: { ageDays?: number; week?: number }, label: string) => {
    const pool = active.filter((t) => eligible(t, at));
    const parent = pool.filter((t) => t.roleFit !== 'TOGETHER');
    const mother = parent.filter((t) => t.roleFit !== 'PARTNER_OF_PREGNANT');
    const partner = parent.filter((t) => t.roleFit !== 'PREGNANT_MOTHER');
    const together = pool.filter((t) => t.roleFit === 'TOGETHER');
    // While pregnant or ≤ postpartumDays after birth the carrier must get one
    // SELF mission a day (MissionBoardRepository.generate requiredCategories).
    const perinatal =
      at.week !== undefined ||
      (at.ageDays !== undefined && at.ageDays <= MISSION_POLICY.postpartumDays);
    const carrierSelf = mother.filter((t) => t.category === 'SELF');
    return [
      parent.length < needParents && `${label}: parents ${parent.length}`,
      mother.length < needEach && `${label}: carrier ${mother.length}`,
      partner.length < needEach && `${label}: partner ${partner.length}`,
      together.length < needTogether && `${label}: together ${together.length}`,
      perinatal &&
        carrierSelf.length < window &&
        `${label}: carrier SELF ${carrierSelf.length}`,
    ].filter(Boolean);
  };

  it('has unique codes', () => {
    expect(new Set(active.map((t) => t.code)).size).toBe(active.length);
  });

  it('every pregnancy week 1–42 has a full window of distinct templates', () => {
    const gaps = [];
    for (let week = 1; week <= 42; week++)
      gaps.push(...check({ week }, `week ${week}`));
    expect(gaps).toEqual([]);
  });

  it('every child age from birth to 6 years has a full window of distinct templates', () => {
    const gaps = [];
    for (let ageDays = 0; ageDays <= 6 * 365; ageDays++)
      gaps.push(...check({ ageDays }, `day ${ageDays}`));
    expect(gaps).toEqual([]);
  });
});
