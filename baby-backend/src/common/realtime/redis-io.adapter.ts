import { Logger } from '@nestjs/common';
import type { INestApplicationContext } from '@nestjs/common';
import { IoAdapter } from '@nestjs/platform-socket.io';
import { createAdapter } from '@socket.io/redis-adapter';
import { Redis } from 'ioredis';
import type { Server, ServerOptions } from 'socket.io';

/**
 * Socket.IO qua Valkey pub/sub (§12: scale ngang nhiều instance API). Không
 * có REDIS_URL → adapter bộ nhớ (một instance, dev/test).
 */
export class RedisIoAdapter extends IoAdapter {
  private readonly log = new Logger(RedisIoAdapter.name);
  private clients: Redis[] = [];

  constructor(
    app: INestApplicationContext,
    private readonly url: string | undefined,
  ) {
    super(app);
  }

  override createIOServer(port: number, options?: ServerOptions): Server {
    const server = super.createIOServer(port, options);
    if (!this.url) return server;
    const pub = new Redis(this.url, { maxRetriesPerRequest: null });
    const sub = pub.duplicate();
    for (const client of [pub, sub])
      client.on('error', (error: Error) =>
        this.log.warn(`Realtime Valkey error: ${error.message}`),
      );
    this.clients = [pub, sub];
    server.adapter(createAdapter(pub, sub));
    return server;
  }

  override async close(server: Server): Promise<void> {
    await super.close(server);
    for (const client of this.clients) client.disconnect();
    this.clients = [];
  }
}
