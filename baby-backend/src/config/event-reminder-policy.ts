/** Versioned planner/dispatcher policy. Missed ticks catch up from PostgreSQL. */
export const EVENT_REMINDER_POLICY = {
  version: 1,
  horizonDays: 14,
  batchSize: 100,
  plannerEveryMs: 15 * 60 * 1000,
  dispatcherEveryMs: 60 * 1000,
} as const;
