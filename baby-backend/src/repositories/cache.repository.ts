import { Injectable } from '@nestjs/common';
import type { Redis } from 'ioredis';
import {
  ServiceUnavailableError,
  ValidationError,
} from '../common/errors/domain.error';
import { ValkeyConnection } from '../database/valkey.connection';
import type { DependencyStatus } from '../common/health/dependency-status';
import type {
  CacheSetOptions,
  ICacheRepository,
} from '../interfaces/repositories/cache-repository.interface';

// INCR then set the TTL only when the counter was just created, atomically.
const INCREMENT_WITH_TTL = `
local value = redis.call('INCR', KEYS[1])
if value == 1 then redis.call('PEXPIRE', KEYS[1], ARGV[1]) end
return value`;

@Injectable()
/** Valkey/Redis-backed key/value repository (spec §9). */
export class CacheRepository implements ICacheRepository {
  constructor(private readonly connection: ValkeyConnection) {}

  isConfigured(): boolean {
    return this.connection.client !== null;
  }

  async checkHealth(): Promise<DependencyStatus> {
    const client = this.connection.client;
    if (!client) return 'disabled';
    try {
      return (await client.ping()) === 'PONG' ? 'up' : 'down';
    } catch {
      return 'down';
    }
  }

  get(key: string): Promise<string | null> {
    return this.run(key, (client) => client.get(key));
  }

  async set(
    key: string,
    value: string,
    options: CacheSetOptions = {},
  ): Promise<void> {
    const { ttlMs } = options;
    if (ttlMs !== undefined) assertTtl(ttlMs);
    await this.run(key, (client) =>
      ttlMs === undefined
        ? client.set(key, value)
        : client.set(key, value, 'PX', ttlMs),
    );
  }

  async setIfAbsent(
    key: string,
    value: string,
    ttlMs: number,
  ): Promise<boolean> {
    assertTtl(ttlMs);
    const result = await this.run(key, (client) =>
      client.set(key, value, 'PX', ttlMs, 'NX'),
    );
    return result === 'OK';
  }

  async increment(key: string, ttlMs: number): Promise<number> {
    assertTtl(ttlMs);
    const result = await this.run(key, (client) =>
      client.eval(INCREMENT_WITH_TTL, 1, key, ttlMs),
    );
    return Number(result);
  }

  async delete(key: string): Promise<boolean> {
    return (await this.run(key, (client) => client.del(key))) > 0;
  }

  private async run<T>(
    key: string,
    command: (client: Redis) => Promise<T>,
  ): Promise<T> {
    assertKey(key);
    const client = this.connection.client;
    if (!client) throw new ServiceUnavailableError('Cache is not configured.');
    try {
      return await command(client);
    } catch {
      // Never surface connection details or key contents to callers.
      throw new ServiceUnavailableError('Cache is unavailable.');
    }
  }
}

function assertKey(key: string): void {
  if (key.length === 0 || key.length > 512 || /\s/.test(key)) {
    throw new ValidationError(
      'Cache key must be 1-512 non-whitespace characters.',
    );
  }
}

function assertTtl(ttlMs: number): void {
  if (!Number.isSafeInteger(ttlMs) || ttlMs < 1) {
    throw new ValidationError('Cache TTL must be a positive integer (ms).');
  }
}
