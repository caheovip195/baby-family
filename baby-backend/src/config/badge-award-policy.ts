/** Catalog rules are authoritative; unsupported rules fail closed. */
export const BADGE_AWARD_POLICY = {
  version: 1,
  batchSize: 100,
  dailyEveryMs: 24 * 60 * 60 * 1000,
  templateCode: 'NOTI_BADGE_EARNED',
  deepLink: 'babyfamily://care/badges',
  privateHeartsMetrics: ['HEARTS', 'HEARTS_TOTAL', 'TOTAL_HEARTS'],
} as const;
