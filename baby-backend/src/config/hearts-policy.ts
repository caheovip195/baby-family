/** Shared policy for all Hearts writers; existing awards retain their ledger value. */
export const HEARTS_POLICY = {
  version: 1,
  dailyHeartCap: 75,
  treeLevelThresholds: [0, 100, 300, 700, 1500, 3000, 6000],
  fruitEveryHearts: 3000,
} as const;
