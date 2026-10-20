/** No template repeats inside this window when the catalog allows it. */
const REPEAT_WINDOW_DAYS = 14;

/** Daily Missions policy v1. Persist generatorVersion with every generated board. */
export const MISSION_POLICY = {
  version: 1,
  maxScheduleDays: 60,
  postpartumDays: 42,
  latePregnancyWeek: 28,
  pregnancyDurationWeeks: 40,
  carrierSelfWeight: 2,
  partnerCareWeight: 1.8,
  sharedTiredSupportWeight: 1.5,
  underrepresentedCategoryWeight: 1.3,
  sharedMoodLookbackHours: 12,
  diversityLookbackDays: 7,
  generatorVersion: 1,
  defaultLevel: 'MEDIUM',
  levels: {
    LIGHT: { parentQuota: 2, targetHearts: [8, 10], togetherProbability: 0.5 },
    MEDIUM: { parentQuota: 3, targetHearts: [12, 15], togetherProbability: 1 },
    HEAVY: { parentQuota: 4, targetHearts: [16, 20], togetherProbability: 1 },
  },
  maxBalanceDiff: 2,
  sampleAttempts: 50,
  repairAttempts: 20,
  swapsPerDay: 3,
  swapOptionsCount: 3,
  swapOptionsTtlMs: 10 * 60 * 1000,
  swapMaxHeartDifference: 1,
  undoWindowMs: 30 * 1000,
  customHearts: 2,
  customAwardsPerDay: 3,
  repeatWindowDays: REPEAT_WINDOW_DAYS,
  boardHour: 5,
  // Strict window first, then relax when a small catalog cannot fill the board.
  recentExclusionDays: [REPEAT_WINDOW_DAYS, 7, 0],
  titleMaxLength: 120,
  descriptionMaxLength: 1000,
  templateListMax: 100,
} as const;

export type MissionBoardPolicyLevel = keyof typeof MISSION_POLICY.levels;
