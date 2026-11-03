/** Cầu nối khi bất đồng (7.17, BF-20261028-008) — mã lựa chọn khớp catalog app. */
export const BRIDGE_POLICY = {
  feelings: [
    'hurt',
    'angry',
    'exhausted',
    'misunderstood',
    'overwhelmed',
    'disappointed',
  ],
  needs: [
    'space',
    'listened',
    'apology',
    'practical_help',
    'calm_talk',
    'care',
  ],
  nextSteps: [
    'rest_20',
    'hug',
    'watch_kids_30',
    'talk_after_sleep',
    'request_tomorrow',
    'schedule_talk',
    'custom',
  ],
  /** Thời hạn lưu sau khi đóng (0 = xoá ngay khi đóng), mặc định 30 ngày. */
  retentionDays: [0, 7, 30, 90],
  defaultRetentionDays: 30,
  /** Không hoạt động 14 ngày → EXPIRED. */
  inactiveExpiryMs: 14 * 24 * 60 * 60 * 1000,
  topicMaxLength: 60,
  messageMaxLength: 500,
  nextStepTextMaxLength: 120,
  listLimit: 20,
} as const;

export const BRIDGE_LIVE_STATUSES = [
  'INVITED',
  'ACTIVE',
  'PAUSED',
  'NEXT_STEP',
] as const;
