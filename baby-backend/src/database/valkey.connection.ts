import { Injectable, Logger } from '@nestjs/common';
import type { OnApplicationShutdown, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Redis } from 'ioredis';
import type { Environment } from '../config/environment';

/**
 * Shared Valkey/Redis connection (spec §9) for cache and rate-limit storage.
 * `client` is null when REDIS_URL is not configured. Commands fail fast while
 * disconnected (no offline queue) and ioredis keeps reconnecting in the background.
 * BullMQ needs its own connection (`maxRetriesPerRequest: null`) and must not reuse this one.
 */
@Injectable()
export class ValkeyConnection implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger(ValkeyConnection.name);
  readonly client: Redis | null;

  constructor(config: ConfigService<Environment, true>) {
    const url = config.get('REDIS_URL', { infer: true });
    this.client = url
      ? new Redis(url, {
          lazyConnect: true,
          enableOfflineQueue: false,
          maxRetriesPerRequest: 1,
          connectTimeout: 5000,
          commandTimeout: 2000,
          retryStrategy: (attempt) => Math.min(attempt * 200, 5000),
        })
      : null;
    // Without a listener ioredis reports connection errors as unhandled events.
    this.client?.on('error', (error: Error) =>
      this.logger.warn(`Valkey connection error: ${error.message}`),
    );
  }

  async onModuleInit(): Promise<void> {
    if (!this.client) return;
    try {
      await this.client.connect();
    } catch (error) {
      // Readiness reports the outage; the API itself keeps serving.
      this.logger.warn(
        `Valkey unavailable at startup: ${error instanceof Error ? error.message : 'unknown error'}`,
      );
    }
  }

  async onApplicationShutdown(): Promise<void> {
    if (!this.client) return;
    if (this.client.status !== 'ready') {
      this.client.disconnect();
      return;
    }
    try {
      await this.client.quit();
    } catch {
      this.client.disconnect();
    }
  }
}
