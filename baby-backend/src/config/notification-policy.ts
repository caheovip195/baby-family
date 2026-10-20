/** Versioned defaults for NOTI-01; changing defaults requires a new policy version. */
export const NOTIFICATION_POLICY = {
  version: 1,
  retentionDays: 90,
  groupWindowMs: 30 * 60 * 1000,
  nonUrgentPushDailyCap: 3,
  defaultTimezone: 'Asia/Ho_Chi_Minh',
  quietStart: '22:00',
  quietEnd: '06:30',
  categoryDefaults: {
    MEMORIES: true,
    REQUESTS: true,
    US: true,
    APPRECIATION: true,
    PROMOTIONS: false,
  },
  /** Existing user_settings JSON uses MEMORY; preserve it when adopting canonical groups. */
  categoryAliases: {
    MEMORIES: ['MEMORY'],
    REQUESTS: [],
    US: [],
    APPRECIATION: [],
    PROMOTIONS: [],
  },
  /** Only names and identifiers may cross the notification boundary. */
  safeParamKeys: [
    'entityId',
    'actorUserId',
    'actorName',
    'authorUserId',
    'memoryId',
    'commentId',
    'requestId',
    'checkinId',
    'appreciationId',
    'familyId',
    'childIds',
    'childNames',
    'senderUserId',
    'receiverUserId',
  ],
} as const;

export type NotificationCategory =
  keyof typeof NOTIFICATION_POLICY.categoryDefaults;
