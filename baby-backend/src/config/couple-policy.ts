/** Versioned US-02 catalog; codes match the deployed PostgreSQL enums. */
export const COUPLE_POLICY = {
  version: 1,
  moods: [
    'GOOD',
    'OKAY',
    'TIRED',
    'EXHAUSTED',
    'STRESSED',
    'SAD',
    'UPSET',
    'UPSET_WITH_PARTNER',
    'OVERWHELMED',
    'LONELY',
    'NEED_AFFECTION',
  ],
  /** Moods never shared with the partner, whatever the request says. */
  privateMoods: ['UPSET_WITH_PARTNER'] as readonly string[],
  needs: ['BREAK', 'HELP_CHILD', 'QUIET', 'HUG', 'TALK', 'REASSURANCE'],
  sharedFields: ['mood', 'energy', 'needs', 'note'],
  responseTypes: ['SEEN', 'ASK', 'ON_IT', 'HUG'],
  currentDurationMs: 6 * 60 * 60 * 1000,
  noteMaxLength: 500,
  historyDefaultLimit: 20,
  historyMaxLimit: 100,
} as const;
export type CoupleMood = (typeof COUPLE_POLICY.moods)[number];
export type CoupleNeed = (typeof COUPLE_POLICY.needs)[number];
export type CoupleSharedField = (typeof COUPLE_POLICY.sharedFields)[number];
export type CoupleResponseType = (typeof COUPLE_POLICY.responseTypes)[number];
