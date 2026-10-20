import { HEARTS_POLICY } from './hearts-policy';

export const CARE_PROGRESS_POLICY = {
  version: 1,
  treeLevelNames: {
    1: 'Hạt mầm',
    2: 'Mầm non',
    3: 'Cây non',
    4: 'Cây xanh',
    5: 'Cây trổ hoa',
    6: 'Cây kết trái',
    7: 'Cây cổ thụ',
  } as Record<number, string>,
  treeLevelThresholds: HEARTS_POLICY.treeLevelThresholds,
  fruitEveryHearts: HEARTS_POLICY.fruitEveryHearts,
  dailyHeartCap: HEARTS_POLICY.dailyHeartCap,
  maxMissionHistoryDays: 92,
  defaultLimit: 20,
  maxLimit: 100,
} as const;
