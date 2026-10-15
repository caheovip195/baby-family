import type { Job, Worker } from 'bullmq';
import { DelayedError } from 'bullmq';
import { Redis } from 'ioredis';
import { JobBusyError } from '../common/errors/job.error';

/** BullMQ workers need dedicated connections with unlimited per-request retries. */
export function createQueueConnection(url: string): Redis {
  const connection = new Redis(url, { maxRetriesPerRequest: null });
  connection.on('error', () => undefined); // reconnects; readiness reports outages
  return connection;
}

const BUSY_RETRY_MS = 30_000;
const DRAIN_TIMEOUT_MS = 45_000;

/**
 * Another worker holds a live lease on the run: postpone this delivery without
 * consuming one of its attempts.
 */
export async function postponeIfBusy(
  error: unknown,
  job: Job,
  token: string | undefined,
): Promise<void> {
  if (!(error instanceof JobBusyError) || !token) return;
  await job.moveToDelayed(Date.now() + BUSY_RETRY_MS, token);
  throw new DelayedError();
}

/**
 * Stops taking jobs and waits for running ones; after the deadline the remaining
 * jobs are released as stalled and their DB leases expire (recovered later).
 */
export async function drainWorker(
  worker: Worker | null,
  connection: Redis | null,
): Promise<void> {
  if (worker) {
    let timer: NodeJS.Timeout | undefined;
    const deadline = new Promise<'timeout'>((resolve) => {
      timer = setTimeout(() => resolve('timeout'), DRAIN_TIMEOUT_MS);
    });
    const closed = await Promise.race([
      worker.close().then(() => 'closed'),
      deadline,
    ]);
    clearTimeout(timer);
    if (closed === 'timeout') await worker.close(true);
  }
  // BullMQ does not close connections it was given.
  connection?.disconnect();
}
