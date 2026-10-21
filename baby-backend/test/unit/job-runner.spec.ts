import { ConfigService } from '@nestjs/config';
import { DomainError } from '../../src/common/errors/domain.error';
import {
  JobBusyError,
  PermanentJobError,
} from '../../src/common/errors/job.error';
import type { Environment } from '../../src/config/environment';
import { JOBS, OUTBOX_NO_CONSUMER, OUTBOX_ROUTES } from '../../src/config/jobs';
import type { IJobExecutionRepository } from '../../src/interfaces/repositories/job-execution-repository.interface';
import type { IJobQueueService } from '../../src/interfaces/services/job-queue-service.interface';
import type { IOutboxRelayRepository } from '../../src/interfaces/repositories/outbox-relay-repository.interface';
import { JobLease } from '../../src/models/job-lease.model';
import { OutboxDelivery } from '../../src/models/outbox-delivery.model';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { OutboxRelayService } from '../../src/services/outbox-relay.service';

const config = new ConfigService({
  WORKER_ID: 'unit-worker',
}) as unknown as ConfigService<Environment, true>;
const request = {
  scopeKey: 'asset-1',
  scheduledFor: new Date(0),
  idempotencyKey: 'media.process-asset:asset-1',
};

describe('JobRunnerService', () => {
  const runs: jest.Mocked<IJobExecutionRepository> = {
    claim: jest.fn(),
    heartbeat: jest.fn().mockResolvedValue(true),
    succeed: jest.fn().mockResolvedValue(true),
    fail: jest.fn().mockResolvedValue('RETRY_WAIT'),
  };
  const runner = new JobRunnerService(runs, config);
  const lease = (attempt = 1) =>
    new JobLease('run-1', attempt, 7n, 5, 'unit-worker');

  it('records success with the handler checkpoint', async () => {
    runs.claim.mockResolvedValueOnce({ kind: 'claimed', lease: lease() });
    await expect(
      runner.execute(JOBS.processAsset, request, () =>
        Promise.resolve({ processed: 1 }),
      ),
    ).resolves.toBe('SUCCEEDED');
    expect(runs.claim).toHaveBeenCalledWith(
      expect.objectContaining({
        jobName: 'media.process-asset',
        maxAttempts: 5,
      }),
      'unit-worker',
      JOBS.processAsset.leaseMs,
    );
    expect(runs.succeed).toHaveBeenCalledWith(expect.any(JobLease), {
      processed: 1,
    });
  });

  it('does not rerun finished runs and reports busy leases as retryable', async () => {
    runs.claim.mockResolvedValueOnce({ kind: 'finished', status: 'SUCCEEDED' });
    const handler = jest.fn();
    await expect(
      runner.execute(JOBS.processAsset, request, handler),
    ).resolves.toBe('ALREADY_FINISHED');
    runs.claim.mockResolvedValueOnce({ kind: 'busy' });
    await expect(
      runner.execute(JOBS.processAsset, request, handler),
    ).rejects.toBeInstanceOf(JobBusyError);
    runs.claim.mockResolvedValueOnce({ kind: 'exhausted' });
    await expect(
      runner.execute(JOBS.processAsset, request, handler),
    ).rejects.toBeInstanceOf(PermanentJobError);
    expect(handler).not.toHaveBeenCalled();
  });

  it('schedules a backoff retry for transient errors with a sanitized summary', async () => {
    runs.claim.mockResolvedValueOnce({ kind: 'claimed', lease: lease(2) });
    const secret = new Error('postgresql://user:secret@db/x');
    const before = Date.now();
    await expect(
      runner.execute(JOBS.processAsset, request, () => Promise.reject(secret)),
    ).rejects.toBe(secret);
    const failure = runs.fail.mock.calls.at(-1)![1];
    expect(failure).toMatchObject({
      code: 'TRANSIENT_ERROR',
      summary: 'Error',
      permanent: false,
    });
    // attempt 2 → base backoff × 2
    expect(failure.retryAt.getTime()).toBeGreaterThanOrEqual(before + 20_000);
  });

  it('marks permanent and domain errors with their codes', async () => {
    runs.claim.mockResolvedValueOnce({ kind: 'claimed', lease: lease() });
    await expect(
      runner.execute(JOBS.processAsset, request, () =>
        Promise.reject(new PermanentJobError('CHECKSUM_MISMATCH', 'bad hash')),
      ),
    ).rejects.toBeInstanceOf(PermanentJobError);
    expect(runs.fail.mock.calls.at(-1)![1]).toMatchObject({
      code: 'CHECKSUM_MISMATCH',
      permanent: true,
    });
    runs.claim.mockResolvedValueOnce({ kind: 'claimed', lease: lease() });
    await expect(
      runner.execute(JOBS.processAsset, request, () =>
        Promise.reject(
          new DomainError(
            'Object storage is unavailable.',
            'SERVICE_UNAVAILABLE',
            503,
          ),
        ),
      ),
    ).rejects.toBeInstanceOf(DomainError);
    expect(runs.fail.mock.calls.at(-1)![1]).toMatchObject({
      code: 'SERVICE_UNAVAILABLE',
      permanent: false,
    });
  });

  it('fails the attempt when the lease was lost before completion', async () => {
    runs.claim.mockResolvedValueOnce({ kind: 'claimed', lease: lease() });
    runs.succeed.mockResolvedValueOnce(false);
    await expect(
      runner.execute(JOBS.processAsset, request, () => Promise.resolve({})),
    ).rejects.toThrow('lease was lost');
  });
});

describe('OutboxRelayService', () => {
  const outbox: jest.Mocked<IOutboxRelayRepository> = {
    claim: jest.fn(),
    markPublished: jest.fn().mockResolvedValue(true),
    markFailed: jest.fn(),
  };
  const queue: jest.Mocked<IJobQueueService> = {
    isConfigured: jest.fn().mockReturnValue(true),
    enqueue: jest.fn(),
    schedule: jest.fn(),
  };
  const relay = new OutboxRelayService(outbox, queue);
  const delivery = (aggregateId: string | null, attempts = 1) =>
    new OutboxDelivery(
      1n,
      'event-1',
      'media.asset_uploaded',
      aggregateId,
      'family-1',
      attempts,
      3n,
    );

  it('enqueues by event id and marks events published', async () => {
    outbox.claim.mockResolvedValueOnce([delivery('asset-1')]);
    await expect(relay.relayBatch()).resolves.toBe(1);
    // Routed event types plus audited ones acknowledged without a consumer
    // (docs/outbox.md).
    expect(outbox.claim).toHaveBeenCalledWith(
      [...Object.keys(OUTBOX_ROUTES), ...Object.keys(OUTBOX_NO_CONSUMER)],
      expect.any(String),
      expect.any(Number),
      expect.any(Number),
    );
    expect(queue.enqueue).toHaveBeenCalledWith(
      JOBS.processAsset,
      'evt-event-1',
      {
        assetId: 'asset-1',
        eventId: 'event-1',
      },
    );
    expect(outbox.markPublished).toHaveBeenCalled();
  });

  it('keeps events pending with capped backoff when enqueueing fails', async () => {
    outbox.claim.mockResolvedValueOnce([
      delivery('asset-1', 30),
      delivery(null),
    ]);
    queue.enqueue.mockRejectedValueOnce(new Error('valkey down'));
    const before = Date.now();
    await relay.relayBatch();
    expect(outbox.markPublished).not.toHaveBeenCalledWith(
      expect.objectContaining({ attempts: 30 }),
    );
    expect(outbox.markFailed).toHaveBeenCalledTimes(2);
    const retryAt = outbox.markFailed.mock.calls[0]![2];
    expect(retryAt.getTime()).toBeLessThanOrEqual(
      before + 5 * 60 * 1000 + 1000,
    );
  });
});
