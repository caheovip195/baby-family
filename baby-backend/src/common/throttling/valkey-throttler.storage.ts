import { randomUUID } from 'node:crypto';
import { Logger } from '@nestjs/common';
import { ThrottlerStorageService } from '@nestjs/throttler';
import type { ThrottlerStorage } from '@nestjs/throttler';
import type { Redis } from 'ioredis';

type ThrottlerStorageRecord = Awaited<
  ReturnType<ThrottlerStorage['increment']>
>;

// Sliding log per throttler/key (sorted set of hit expiries, spec §9), shared by all
// API replicas. Mirrors @nestjs/throttler's in-memory storage: each hit expires on its
// own; with blockDuration > 0 exceeding the limit blocks the key and the count restarts
// after the block; with blockDuration = 0 requests are refused until the oldest hit expires.
// Returns {totalHits, timeToExpireMs, isBlocked, timeToBlockExpireMs}.
const INCREMENT_SCRIPT = `
local time = redis.call('TIME')
local now = tonumber(time[1]) * 1000 + math.floor(tonumber(time[2]) / 1000)
local ttl = tonumber(ARGV[1])
local limit = tonumber(ARGV[2])
local block = tonumber(ARGV[3])
redis.call('ZREMRANGEBYSCORE', KEYS[1], '-inf', now)
local blockTtl = redis.call('PTTL', KEYS[2])
if blockTtl > 0 then
  return {limit + 1, blockTtl, 1, blockTtl}
end
local hits = redis.call('ZCARD', KEYS[1])
if block <= 0 and hits >= limit then
  local oldest = redis.call('ZRANGE', KEYS[1], 0, 0, 'WITHSCORES')
  local wait = math.max(tonumber(oldest[2]) - now, 0)
  return {hits + 1, wait, 1, wait}
end
redis.call('ZADD', KEYS[1], now + ttl, ARGV[4])
redis.call('PEXPIRE', KEYS[1], ttl)
hits = hits + 1
if block > 0 and hits > limit then
  redis.call('SET', KEYS[2], '1', 'PX', block)
  redis.call('DEL', KEYS[1])
  return {hits, ttl, 1, block}
end
return {hits, ttl, 0, 0}`;

const OUTAGE_LOG_INTERVAL_MS = 60_000;

/**
 * ThrottlerStorage backed by Valkey (`rl:*` keys, spec §9). If Valkey is unreachable
 * it degrades to per-instance in-memory limiting instead of failing every request.
 */
export class ValkeyThrottlerStorage implements ThrottlerStorage {
  private readonly logger = new Logger(ValkeyThrottlerStorage.name);
  private readonly fallback = new ThrottlerStorageService();
  private lastOutageLog = 0;

  constructor(private readonly client: Redis) {}

  async increment(
    key: string,
    ttl: number,
    limit: number,
    blockDuration: number,
    throttlerName: string,
  ): Promise<ThrottlerStorageRecord> {
    const base = `rl:${throttlerName}:${key}`;
    try {
      const result = (await this.client.eval(
        INCREMENT_SCRIPT,
        2,
        `${base}:hits`,
        `${base}:block`,
        ttl,
        limit,
        blockDuration,
        randomUUID(),
      )) as [number, number, number, number];
      const [totalHits, ttlMs, blocked, blockMs] = result.map(Number);
      return {
        totalHits: totalHits!,
        timeToExpire: Math.ceil(ttlMs! / 1000),
        isBlocked: blocked === 1,
        timeToBlockExpire: Math.ceil(blockMs! / 1000),
      };
    } catch (error) {
      this.logOutage(error);
      return this.fallback.increment(
        key,
        ttl,
        limit,
        blockDuration,
        throttlerName,
      );
    }
  }

  private logOutage(error: unknown): void {
    const now = Date.now();
    if (now - this.lastOutageLog < OUTAGE_LOG_INTERVAL_MS) return;
    this.lastOutageLog = now;
    this.logger.warn(
      `Valkey rate-limit storage unavailable, using in-memory fallback: ${error instanceof Error ? error.message : 'unknown error'}`,
    );
  }
}
