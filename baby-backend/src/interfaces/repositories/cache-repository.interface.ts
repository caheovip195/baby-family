import type { DependencyStatus } from '../../common/health/dependency-status';

export const CACHE_REPOSITORY = Symbol('CACHE_REPOSITORY');

export interface CacheSetOptions {
  /** Expiry in milliseconds; omit only for keys that must not expire (spec §9, e.g. `acv:*`). */
  ttlMs?: number;
}

/**
 * Key/value cache and counters (spec §9). PostgreSQL stays the source of truth:
 * callers must tolerate a missing key. Methods throw ServiceUnavailableError when
 * the cache is not configured or unreachable, so security-sensitive callers fail closed.
 */
export interface ICacheRepository {
  isConfigured(): boolean;
  checkHealth(): Promise<DependencyStatus>;
  get(key: string): Promise<string | null>;
  set(key: string, value: string, options?: CacheSetOptions): Promise<void>;
  /** Atomic SET NX; returns false when the key already exists (locks, idempotency). */
  setIfAbsent(key: string, value: string, ttlMs: number): Promise<boolean>;
  /** Atomic increment; the TTL is applied when the counter is created. */
  increment(key: string, ttlMs: number): Promise<number>;
  delete(key: string): Promise<boolean>;
}
