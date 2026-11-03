/** Nhắn tin trong gia đình (BF-20261101-001). */
export const CHAT_POLICY = {
  version: 1,
  /** FAMILY: Parent + người thân đang có quyền; COUPLE: chỉ hai Parent. */
  kinds: ['FAMILY', 'COUPLE'] as const,
  bodyMaxLength: 4000,
  pageLimit: 50,
  maxPageLimit: 100,
  /** Presence (Valkey): khoá hết hạn nếu instance chết mà không kịp dọn. */
  presenceTtlMs: 90_000,
  presenceHeartbeatMs: 30_000,
  /** Tín hiệu “đang nhập” tối đa mỗi người mỗi cuộc trò chuyện. */
  typingMinIntervalMs: 2_000,
  /** Room Socket.IO theo user (§12: fan-out theo user, không lộ cấu trúc room). */
  userRoom: (userId: string) => `user:${userId}`,
} as const;

export type ChatKind = (typeof CHAT_POLICY.kinds)[number];
