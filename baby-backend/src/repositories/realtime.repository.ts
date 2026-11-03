import { Injectable, Logger } from '@nestjs/common';
import { CHAT_POLICY } from '../config/chat-policy';
import { RealtimeServerHolder } from '../common/realtime/realtime-server.holder';
import { ValkeyConnection } from '../database/valkey.connection';
import type { IRealtimeRepository } from '../interfaces/repositories/realtime-repository.interface';

const key = (userId: string) => `presence:user:${userId}`;

/** Socket.IO emit + presence Valkey (bộ nhớ khi không có REDIS_URL). */
@Injectable()
export class RealtimeRepository implements IRealtimeRepository {
  private readonly logger = new Logger(RealtimeRepository.name);
  /** Dự phòng một instance khi không cấu hình Valkey (dev/test). */
  private readonly local = new Map<string, Set<string>>();

  constructor(
    private readonly holder: RealtimeServerHolder,
    private readonly valkey: ValkeyConnection,
  ) {}

  emitToUsers(
    userIds: readonly string[],
    event: string,
    payload: Record<string, string | number | null>,
  ): void {
    const server = this.holder.server;
    if (!server || !userIds.length) return;
    server
      .to([...new Set(userIds)].map((id) => CHAT_POLICY.userRoom(id)))
      .emit(event, payload);
  }

  async markOnline(userId: string, socketId: string): Promise<void> {
    const client = this.valkey.client;
    if (!client) {
      const set = this.local.get(userId) ?? new Set<string>();
      set.add(socketId);
      this.local.set(userId, set);
      return;
    }
    await this.safe(() =>
      client
        .multi()
        .sadd(key(userId), socketId)
        .pexpire(key(userId), CHAT_POLICY.presenceTtlMs)
        .exec(),
    );
  }

  async markOffline(userId: string, socketId: string): Promise<void> {
    const client = this.valkey.client;
    if (!client) {
      const set = this.local.get(userId);
      set?.delete(socketId);
      if (set && !set.size) this.local.delete(userId);
      return;
    }
    await this.safe(() => client.srem(key(userId), socketId));
  }

  async refresh(
    entries: ReadonlyArray<{ userId: string; socketId: string }>,
  ): Promise<void> {
    const client = this.valkey.client;
    if (!client || !entries.length) return;
    const multi = client.multi();
    for (const entry of entries)
      multi
        .sadd(key(entry.userId), entry.socketId)
        .pexpire(key(entry.userId), CHAT_POLICY.presenceTtlMs);
    await this.safe(() => multi.exec());
  }

  async onlineUserIds(userIds: readonly string[]): Promise<Set<string>> {
    const client = this.valkey.client;
    if (!client) return new Set(userIds.filter((id) => this.local.has(id)));
    const online = new Set<string>();
    await this.safe(async () => {
      const counts = await Promise.all(
        userIds.map((id) => client.scard(key(id))),
      );
      counts.forEach((count, index) => {
        if (count > 0) online.add(userIds[index]!);
      });
    });
    return online;
  }

  private async safe(run: () => Promise<unknown>): Promise<void> {
    try {
      await run();
    } catch (error) {
      // Mất presence chỉ làm push gửi thừa; không chặn nhắn tin.
      this.logger.warn(
        `Realtime presence unavailable: ${error instanceof Error ? error.message : 'unknown'}`,
      );
    }
  }
}
