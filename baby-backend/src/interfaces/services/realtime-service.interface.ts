export const REALTIME_SERVICE = Symbol('REALTIME_SERVICE');

/** Presence của socket realtime (§12, BF-20261101-001). */
export interface IRealtimeService {
  connected(userId: string, socketId: string): Promise<void>;
  disconnected(userId: string, socketId: string): Promise<void>;
  heartbeat(
    entries: ReadonlyArray<{ userId: string; socketId: string }>,
  ): Promise<void>;
}
