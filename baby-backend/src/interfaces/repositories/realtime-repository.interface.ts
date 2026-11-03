export const REALTIME_REPOSITORY = Symbol('REALTIME_REPOSITORY');

/**
 * Realtime (§12, BF-20261101-001): phát tín hiệu nhỏ theo room `user:{id}` và
 * presence trên Valkey. Mọi lỗi hạ tầng được nuốt: realtime chỉ là gợi ý,
 * client luôn đồng bộ lại qua REST.
 */
export interface IRealtimeRepository {
  emitToUsers(
    userIds: readonly string[],
    event: string,
    payload: Record<string, string | number | null>,
  ): void;
  markOnline(userId: string, socketId: string): Promise<void>;
  markOffline(userId: string, socketId: string): Promise<void>;
  /** Gia hạn presence cho các socket đang sống trên instance này. */
  refresh(
    entries: ReadonlyArray<{ userId: string; socketId: string }>,
  ): Promise<void>;
  onlineUserIds(userIds: readonly string[]): Promise<Set<string>>;
}
