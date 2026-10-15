import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type {
  IJobExecutionRepository,
  JobClaim,
  JobFailure,
  JobRunDefinition,
} from '../interfaces/repositories/job-execution-repository.interface';
import { JobLease } from '../models/job-lease.model';

const TRANSACTION_OPTIONS = {
  isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
  timeout: 10000,
};
const FINISHED = new Set(['SUCCEEDED', 'FAILED', 'SKIPPED']);

interface RunRow {
  id: string;
  status: string;
  attempts: number;
  max_attempts: number;
  lease_live: boolean;
}

@Injectable()
export class JobExecutionRepository implements IJobExecutionRepository {
  constructor(private readonly prisma: PrismaService) {}

  claim(
    definition: JobRunDefinition,
    workerId: string,
    leaseMs: number,
  ): Promise<JobClaim> {
    return this.prisma.$transaction(async (tx) => {
      await tx.$executeRaw`
        INSERT INTO ops.job_runs
          (job_name, scope_key, family_id, scheduled_for, idempotency_key,
           max_attempts, input_reference)
        VALUES (${definition.jobName}, ${definition.scopeKey},
                ${definition.familyId}::uuid, ${definition.scheduledFor},
                ${definition.idempotencyKey}, ${definition.maxAttempts},
                ${JSON.stringify(definition.inputReference)}::jsonb)
        ON CONFLICT DO NOTHING`;
      const [run] = await tx.$queryRaw<RunRow[]>`
        SELECT id, status, attempts, max_attempts,
               (lease_expires_at IS NOT NULL AND lease_expires_at > now()) AS lease_live
        FROM ops.job_runs
        WHERE deleted_at IS NULL
          AND (idempotency_key = ${definition.idempotencyKey}
               OR (job_name = ${definition.jobName}
                   AND scope_key = ${definition.scopeKey}
                   AND scheduled_for = ${definition.scheduledFor}))
        ORDER BY (idempotency_key = ${definition.idempotencyKey}) DESC
        LIMIT 1
        FOR UPDATE`;
      if (!run) return { kind: 'busy' };
      if (FINISHED.has(run.status))
        return { kind: 'finished', status: run.status };
      if (run.status === 'RUNNING') {
        if (run.lease_live) return { kind: 'busy' };
        // The previous owner died or stalled: its attempt timed out.
        await tx.$executeRaw`
          UPDATE ops.job_attempts
          SET status = 'TIMED_OUT', finished_at = now(), error_code = 'LEASE_EXPIRED'
          WHERE run_id = ${run.id}::uuid AND status = 'RUNNING'`;
      }
      if (run.attempts >= run.max_attempts) {
        await tx.$executeRaw`
          UPDATE ops.job_runs
          SET status = 'FAILED', finished_at = now(), lease_owner = NULL,
              lease_expires_at = NULL, last_error_code = 'ATTEMPTS_EXHAUSTED'
          WHERE id = ${run.id}::uuid`;
        return { kind: 'exhausted' };
      }
      const [claimed] = await tx.$queryRaw<
        { attempts: number; fencing_token: bigint }[]
      >`
        UPDATE ops.job_runs
        SET status = 'RUNNING', attempts = attempts + 1,
            fencing_token = fencing_token + 1, lease_owner = ${workerId},
            lease_expires_at = now() + make_interval(secs => ${leaseMs / 1000}),
            heartbeat_at = now(), started_at = COALESCE(started_at, now()),
            next_attempt_at = NULL
        WHERE id = ${run.id}::uuid
        RETURNING attempts, fencing_token`;
      await tx.jobAttempt.create({
        data: {
          runId: run.id,
          attemptNumber: claimed!.attempts,
          workerId,
          fencingToken: claimed!.fencing_token,
        },
      });
      return {
        kind: 'claimed',
        lease: new JobLease(
          run.id,
          claimed!.attempts,
          claimed!.fencing_token,
          run.max_attempts,
          workerId,
        ),
      };
    }, TRANSACTION_OPTIONS);
  }

  async heartbeat(lease: JobLease, leaseMs: number): Promise<boolean> {
    const updated = await this.prisma.$executeRaw`
      UPDATE ops.job_runs
      SET lease_expires_at = now() + make_interval(secs => ${leaseMs / 1000}),
          heartbeat_at = now()
      WHERE id = ${lease.runId}::uuid AND status = 'RUNNING'
        AND fencing_token = ${lease.fencingToken}`;
    return updated === 1;
  }

  succeed(
    lease: JobLease,
    checkpoint: Record<string, number>,
  ): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.$executeRaw`
        UPDATE ops.job_runs
        SET status = 'SUCCEEDED', finished_at = now(), lease_owner = NULL,
            lease_expires_at = NULL, last_error_code = NULL,
            last_error_summary = NULL,
            checkpoint = ${JSON.stringify(checkpoint)}::jsonb
        WHERE id = ${lease.runId}::uuid AND status = 'RUNNING'
          AND fencing_token = ${lease.fencingToken}`;
      if (updated !== 1) return false;
      await tx.$executeRaw`
        UPDATE ops.job_attempts SET status = 'SUCCEEDED', finished_at = now()
        WHERE run_id = ${lease.runId}::uuid AND fencing_token = ${lease.fencingToken}
          AND status = 'RUNNING'`;
      return true;
    }, TRANSACTION_OPTIONS);
  }

  fail(
    lease: JobLease,
    failure: JobFailure,
  ): Promise<'RETRY_WAIT' | 'FAILED' | null> {
    const final = failure.permanent || lease.isLastAttempt();
    const status = final ? 'FAILED' : 'RETRY_WAIT';
    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.$executeRaw`
        UPDATE ops.job_runs
        SET status = ${status},
            finished_at = CASE WHEN ${final} THEN now() ELSE NULL END,
            next_attempt_at = CASE WHEN ${final} THEN NULL ELSE ${failure.retryAt}::timestamptz END,
            lease_owner = NULL, lease_expires_at = NULL,
            last_error_code = ${failure.code},
            last_error_summary = ${failure.summary}
        WHERE id = ${lease.runId}::uuid AND status = 'RUNNING'
          AND fencing_token = ${lease.fencingToken}`;
      if (updated !== 1) return null;
      await tx.$executeRaw`
        UPDATE ops.job_attempts
        SET status = 'FAILED', finished_at = now(), error_code = ${failure.code},
            error_summary = ${failure.summary}
        WHERE run_id = ${lease.runId}::uuid AND fencing_token = ${lease.fencingToken}
          AND status = 'RUNNING'`;
      return status;
    }, TRANSACTION_OPTIONS);
  }
}
