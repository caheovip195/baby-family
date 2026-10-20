import { jest } from '@jest/globals';
import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import type { TestingModule } from '@nestjs/testing';
import { Test } from '@nestjs/testing';
import { validateEnvironment } from '../../src/config/environment';
import { MODERATION_SLA_JOB } from '../../src/config/moderation-workflow-policy';
import { MEMORY_CONTENT_REPOSITORY } from '../../src/interfaces/repositories/memory-content-repository.interface';
import { SAFETY_REPOSITORY } from '../../src/interfaces/repositories/safety-repository.interface';
import { SafetyRepository } from '../../src/repositories/safety.repository';
import { SafetyService } from '../../src/services/safety.service';
import { PrismaService } from '../../src/database/prisma.service';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import type { IJobExecutionRepository } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { MODERATION_WORKFLOW_REPOSITORY } from '../../src/interfaces/repositories/moderation-workflow-repository.interface';
import { JOB_RUNNER_SERVICE } from '../../src/interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../../src/interfaces/services/job-runner-service.interface';
import { MODERATION_WORKFLOW_SERVICE } from '../../src/interfaces/services/moderation-workflow-service.interface';
import type { IModerationWorkflowService } from '../../src/interfaces/services/moderation-workflow-service.interface';
import { JobLease } from '../../src/models/job-lease.model';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { ModerationWorkflowRepository } from '../../src/repositories/moderation-workflow.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { ModerationWorkflowService } from '../../src/services/moderation-workflow.service';

/** BF-20261019-010: isolated composition root, no production DI/worker changes. */
describe('Moderation workflow (PostgreSQL)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let workflow: IModerationWorkflowService;
  let repository: ModerationWorkflowRepository;
  let runner: IJobRunnerService;
  const familyId = randomUUID();
  const userId = randomUUID();
  const reportedUser = randomUUID();
  const targetIds = new Set<string>();
  const due = new Date('2020-01-01T00:00:00Z');

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    module = await Test.createTestingModule({
      providers: [
        {
          provide: ConfigService,
          useValue: new ConfigService(validateEnvironment(process.env)),
        },
        PrismaService,
        SafetyService,
        { provide: SAFETY_REPOSITORY, useClass: SafetyRepository },
        { provide: MEMORY_CONTENT_REPOSITORY, useValue: {} },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        { provide: JOB_RUNNER_SERVICE, useClass: JobRunnerService },
        {
          provide: MODERATION_WORKFLOW_REPOSITORY,
          useClass: ModerationWorkflowRepository,
        },
        {
          provide: MODERATION_WORKFLOW_SERVICE,
          useClass: ModerationWorkflowService,
        },
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    repository = module.get(MODERATION_WORKFLOW_REPOSITORY);
    workflow = module.get(MODERATION_WORKFLOW_SERVICE);
    runner = module.get(JOB_RUNNER_SERVICE);
    await prisma.user.create({
      data: { id: userId, displayName: 'Synthetic moderation user' },
    });
    await prisma.user.create({
      data: { id: reportedUser, displayName: 'Synthetic reported user' },
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic moderation family',
        createdBy: userId,
      },
    });
    await prisma.familyParent.createMany({
      data: [
        { familyId, userId, slot: 'A', kind: 'FATHER', callName: 'Papa' },
        {
          familyId,
          userId: reportedUser,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    targetIds.add(reportedUser);
  });

  afterAll(async () => {
    if (!prisma) return;
    try {
      const scope = { targetId: { in: [...targetIds] } };
      await prisma.moderationCaseReport.deleteMany({
        where: { moderationCase: scope },
      });
      await prisma.moderationCase.deleteMany({ where: scope });
      await prisma.report.deleteMany({ where: { familyId } });
      // Fixture cleanup only: finalize this spec's unfinished synthetic runs.
      await prisma.jobRun.updateMany({
        where: {
          familyId,
          status: { in: ['PENDING', 'RUNNING', 'RETRY_WAIT'] },
        },
        data: { status: 'FAILED', finishedAt: new Date() },
      });
      await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
      await prisma.jobRun.deleteMany({ where: { familyId } });
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.family.delete({ where: { id: familyId } });
      await prisma.user.deleteMany({
        where: { id: { in: [userId, reportedUser] } },
      });
    } finally {
      await module.close();
    }
  });

  async function report(
    targetId: string = randomUUID(),
    severity = 2,
    slaDueAt = new Date('2020-01-03T00:00:00Z'),
  ) {
    targetIds.add(targetId);
    return prisma.report.create({
      data: {
        reporterUserId: userId,
        familyId,
        targetType: 'MEMORY',
        targetId,
        severity,
        slaDueAt,
        reason: severity === 1 ? 'CHILD_SAFETY' : 'OTHER',
      },
    });
  }

  it('serializes concurrent reports of one target, inherits highest severity and earliest SLA', async () => {
    const first = await report();
    const urgent = await report(first.targetId, 1, due);
    const [a, b] = await Promise.all([
      repository.attachReport(first.id),
      repository.attachReport(urgent.id),
    ]);
    expect(a!.id).toBe(b!.id);
    const row = await prisma.moderationCase.findUniqueOrThrow({
      where: { id: a!.id },
    });
    expect(row).toMatchObject({
      priority: 1,
      status: 'OPEN',
      slaDueAt: due,
      deletedAt: null,
    });
    expect(row.createdAt).toBeInstanceOf(Date);
    expect(row.updatedAt).toBeInstanceOf(Date);
    await repository.attachReport(urgent.id);
    expect(
      await prisma.moderationCaseReport.count({ where: { caseId: row.id } }),
    ).toBe(2);
  });

  it('recovers orphan reports and escalates once with durable run/attempt history', async () => {
    const orphan = await report();
    await expect(workflow.runScheduled(due, familyId)).resolves.toBe(
      'SUCCEEDED',
    );
    await expect(workflow.runScheduled(due, familyId)).resolves.toBe(
      'ALREADY_FINISHED',
    );
    const link = await prisma.moderationCaseReport.findFirstOrThrow({
      where: { reportId: orphan.id },
      include: { moderationCase: true },
    });
    expect(link.moderationCase.status).toBe('ESCALATED');
    const run = await prisma.jobRun.findFirstOrThrow({
      where: { familyId, jobName: MODERATION_SLA_JOB.name },
      include: { jobAttempts: true },
    });
    expect(run.status).toBe('SUCCEEDED');
    expect(run.jobAttempts).toHaveLength(1);
    expect(run.jobAttempts[0]!.status).toBe('SUCCEEDED');
    expect(run.checkpoint).toMatchObject({ attached: 1 });
    // An escalated case is still open and accepts additional reports.
    const followup = await report(orphan.targetId);
    expect((await repository.attachReport(followup.id))!.id).toBe(link.caseId);
  });

  it('starts a new case after resolution and excludes deleted/closed reports', async () => {
    const first = await report();
    const initial = await repository.attachReport(first.id);
    await prisma.moderationCase.update({
      where: { id: initial!.id },
      data: { status: 'RESOLVED', resolvedAt: new Date() },
    });
    const second = await report(first.targetId);
    const next = await repository.attachReport(second.id);
    expect(next!.id).not.toBe(initial!.id);
    const deleted = await report();
    await prisma.report.update({
      where: { id: deleted.id },
      data: { deletedAt: new Date() },
    });
    expect(await repository.attachReport(deleted.id)).toBeNull();
    const closed = await report();
    await prisma.report.update({
      where: { id: closed.id },
      data: { status: 'CLOSED' },
    });
    expect(await repository.attachReport(closed.id)).toBeNull();
  });

  it('rejects stale fencing before attachment or escalation, without business writes', async () => {
    const row = await report();
    const lease = new JobLease(randomUUID(), 1, 1n, 3, 'missing');
    await expect(repository.attachReport(row.id, lease)).rejects.toMatchObject({
      code: 'JOB_LEASE_LOST',
    });
    await expect(
      repository.escalateDue(new Date(), lease, 100, familyId),
    ).rejects.toMatchObject({ code: 'JOB_LEASE_LOST' });
    expect(
      await prisma.moderationCaseReport.count({ where: { reportId: row.id } }),
    ).toBe(0);
  });

  it('recovers an expired attempt and fences out the former owner', async () => {
    const runs = module.get<IJobExecutionRepository>(JOB_EXECUTION_REPOSITORY);
    const definition = {
      jobName: MODERATION_SLA_JOB.name,
      familyId,
      scopeKey: familyId,
      scheduledFor: new Date('2020-01-04'),
      idempotencyKey: `moderation-spec-crash:${familyId}`,
      maxAttempts: 3,
      inputReference: {},
    };
    const first = await runs.claim(definition, 'synthetic-old', 120_000);
    if (first.kind !== 'claimed') throw new Error('Expected first claim');
    await prisma.jobRun.update({
      where: { id: first.lease.runId },
      data: { leaseExpiresAt: due },
    });
    const next = await runs.claim(definition, 'synthetic-recovery', 120_000);
    if (next.kind !== 'claimed') throw new Error('Expected recovery claim');
    const row = await report();
    await expect(
      repository.attachReport(row.id, first.lease),
    ).rejects.toMatchObject({ code: 'JOB_LEASE_LOST' });
    expect(await repository.attachReport(row.id, next.lease)).not.toBeNull();
    expect(await runs.succeed(next.lease, { recovered: 1 })).toBe(true);
    const attempts = await prisma.jobAttempt.findMany({
      where: { runId: next.lease.runId },
      orderBy: { attemptNumber: 'asc' },
    });
    expect(attempts.map((attempt) => attempt.status)).toEqual([
      'TIMED_OUT',
      'SUCCEEDED',
    ]);
  });

  it('persists a transient failure and resumes the same run with a new attempt', async () => {
    const request = {
      familyId,
      scopeKey: familyId,
      scheduledFor: new Date('2020-01-02'),
      idempotencyKey: `moderation-spec-retry:${familyId}`,
    };
    await expect(
      runner.execute(MODERATION_SLA_JOB, request, () =>
        Promise.reject(new Error('Synthetic retry')),
      ),
    ).rejects.toThrow('Synthetic retry');
    const failed = await prisma.jobRun.findUniqueOrThrow({
      where: { idempotencyKey: request.idempotencyKey },
    });
    expect(failed.status).toBe('RETRY_WAIT');
    await expect(
      runner.execute(MODERATION_SLA_JOB, request, (context) =>
        workflow.reconcile(new Date(), context, familyId),
      ),
    ).resolves.toBe('SUCCEEDED');
    const attempts = await prisma.jobAttempt.findMany({
      where: { runId: failed.id },
      orderBy: { attemptNumber: 'asc' },
    });
    expect(attempts.map((row) => row.status)).toEqual(['FAILED', 'SUCCEEDED']);
  });
  it('hooks SafetyService after report commit and recovers a deferred hook failure', async () => {
    const actor = { userId, sessionId: randomUUID(), tokenVersion: 1 };
    const input = {
      familyId,
      targetType: 'USER' as const,
      targetId: reportedUser,
      reason: 'OTHER' as const,
    };
    const safety = module.get(SafetyService);
    const receipt = await safety.report(actor, input);
    const first = await prisma.moderationCaseReport.findFirstOrThrow({
      where: { reportId: receipt.id },
    });
    await prisma.report.update({
      where: { id: receipt.id },
      data: { status: 'CLOSED' },
    });
    await prisma.moderationCase.update({
      where: { id: first.caseId },
      data: { status: 'RESOLVED', resolvedAt: new Date() },
    });
    const failingHook = jest
      .spyOn(repository, 'attachReport')
      .mockRejectedValueOnce(new Error('Synthetic unavailable'));
    let deferredId: string;
    try {
      const deferred = await safety.report(actor, input);
      deferredId = deferred.id;
      expect(deferred.status).toBe('NEW');
      expect(
        await prisma.moderationCaseReport.count({
          where: { reportId: deferred.id },
        }),
      ).toBe(0);
    } finally {
      failingHook.mockRestore();
    }
    await expect(
      workflow.runScheduled(new Date('2020-01-05'), familyId),
    ).resolves.toBe('SUCCEEDED');
    expect(
      await prisma.moderationCaseReport.count({
        where: { reportId: deferredId },
      }),
    ).toBe(1);
    // Existing concentrated test modules can omit the new optional provider.
    const legacy = await Test.createTestingModule({
      providers: [
        SafetyService,
        { provide: SAFETY_REPOSITORY, useValue: new SafetyRepository(prisma) },
        { provide: MEMORY_CONTENT_REPOSITORY, useValue: {} },
      ],
    }).compile();
    try {
      expect((await legacy.get(SafetyService).report(actor, input)).id).toBe(
        deferredId,
      );
    } finally {
      await legacy.close();
    }
  });
});
