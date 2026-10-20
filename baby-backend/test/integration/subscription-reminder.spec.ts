import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { validateEnvironment } from '../../src/config/environment';
import { SUBSCRIPTION_REMINDER_JOB } from '../../src/config/subscription-reminder-policy';
import { PrismaService } from '../../src/database/prisma.service';
import { SUBSCRIPTION_REMINDER_REPOSITORY } from '../../src/interfaces/repositories/subscription-reminder-repository.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { SubscriptionReminderRepository } from '../../src/repositories/subscription-reminder.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { SubscriptionReminderService } from '../../src/services/subscription-reminder.service';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { JobLease } from '../../src/models/job-lease.model';
import { PushDeliveryRepository } from '../../src/repositories/push-delivery.repository';
import type { JobContext } from '../../src/interfaces/services/job-runner-service.interface';

/** Each scan is explicitly scoped to this spec's family, including recovery runs. */
describe('Subscription reminder SUB-06/07 (PostgreSQL)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let service: SubscriptionReminderService;
  let runner: JobRunnerService;
  let push: PushDeliveryRepository;
  const familyId = randomUUID();
  const parents = [randomUUID(), randomUUID()];
  const licenseId = randomUUID();
  const planId = randomUUID();
  const planVersionId = randomUUID();
  const policyId = randomUUID();
  const grantId = randomUUID();
  const now = new Date('2020-02-01T02:00:00Z'); // 09:00 family time, before other specs' pending pushes.
  const ends = new Date('2020-02-02T02:00:00Z');
  const started = new Date('2020-01-26T02:00:00Z');
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('This spec requires baby_family_test.');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService(validateEnvironment(process.env)),
        },
        {
          provide: SUBSCRIPTION_REMINDER_REPOSITORY,
          useClass: SubscriptionReminderRepository,
        },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        SubscriptionReminderService,
        JobRunnerService,
        PushDeliveryRepository,
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    service = module.get(SubscriptionReminderService);
    runner = module.get(JobRunnerService);
    push = module.get(PushDeliveryRepository);
    await prisma.user.createMany({
      data: parents.map((id) => ({
        id,
        displayName: 'Subscription spec parent',
        status: 'ACTIVE',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Subscription spec family',
        status: 'ACTIVE',
        createdBy: parents[0]!,
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    await prisma.familyParent.createMany({
      data: parents.map((userId, i) => ({
        familyId,
        userId,
        slot: i ? 'B' : 'A',
        kind: i ? 'MOTHER' : 'FATHER',
        callName: 'Parent',
        joinedAt: started,
      })),
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `SUB_TEST_${planId.slice(0, 8)}`,
        displayNameI18n: { vi: 'Spec' },
      },
    });
    await prisma.planVersion.create({
      data: { id: planVersionId, planId, version: 1, quotas: {}, features: {} },
    });
    // Inactive historical policy must still drive its existing grant.
    await prisma.trialPolicy.create({
      data: {
        id: policyId,
        code: `SUB_POLICY_${policyId.slice(0, 8)}`,
        version: 3,
        planVersionId,
        durationSeconds: 604800n,
        reminderOffsetsSeconds: [172800, 86400],
        active: false,
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    await prisma.licenseGrant.create({
      data: {
        id: grantId,
        familyId,
        licenseId,
        planVersionId,
        source: 'TRIAL',
        trialPolicyId: policyId,
        provenanceKey: `spec:${familyId}`,
        validFrom: started,
        validUntil: ends,
      },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'TRIAL',
        sourceGrantId: grantId,
        effectivePlanVersionId: planVersionId,
        trialStartedAt: started,
        trialEndsAt: ends,
        validUntil: ends,
      },
    });
  });
  async function clear() {
    await prisma.notificationDeliveryAttempt.deleteMany({
      where: { notificationDelivery: { notification: { familyId } } },
    });
    await prisma.notificationDelivery.deleteMany({
      where: { notification: { familyId } },
    });
    await prisma.notification.deleteMany({ where: { familyId } });
    await prisma.jobRun.updateMany({
      where: { familyId, status: { in: ['PENDING', 'RUNNING', 'RETRY_WAIT'] } },
      data: {
        status: 'FAILED',
        finishedAt: now,
        leaseOwner: null,
        leaseExpiresAt: null,
      },
    });
    await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
    await prisma.jobRun.deleteMany({ where: { familyId } });
  }
  beforeEach(async () => {
    await clear();
    await prisma.familyLicense.update({
      where: { id: licenseId },
      data: { blockedAt: null, blockReasonCode: null },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'TRIAL',
        sourceGrantId: grantId,
        inGrace: false,
        validUntil: ends,
        trialEndsAt: ends,
      },
    });
  });
  afterAll(async () => {
    if (!prisma) return;
    try {
      await clear();
      await prisma.familyEntitlement.deleteMany({ where: { familyId } });
      // Billing identity/grant ledgers reject physical deletion even in test DB.
      // Retire only this spec's fixture family/users; preserve its policy provenance.
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
      await prisma.user.updateMany({
        where: { id: { in: parents } },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
    } finally {
      await module.close();
    }
  });
  let runSequence = 0;
  function run(
    at = now,
    handler?: (context: JobContext) => Promise<Record<string, number>>,
  ) {
    return runner.execute(
      SUBSCRIPTION_REMINDER_JOB,
      {
        familyId,
        scopeKey: familyId,
        scheduledFor: new Date(at.getTime() + runSequence++),
        idempotencyKey: `sub-spec:${familyId}:${randomUUID()}`,
      },
      handler ?? ((context) => service.dispatch(at, context, familyId)),
    );
  }
  it('returns trial banner with server time, seconds, immutable granted policy offsets', async () => {
    expect(await service.status(familyId, now)).toEqual({
      kind: 'TRIAL',
      serverTime: now,
      expiresAt: ends,
      remainingSeconds: 86400,
      reminderOffsetsSeconds: [172800, 86400],
      policyCode: `SUB_POLICY_${policyId.slice(0, 8)}`,
      policyVersion: 3,
      nextReminderAt: null,
      dismissible: true,
    });
  });
  it('creates inbox and pending PUSH for both Parents; retry/new run/hiding never duplicates', async () => {
    await run();
    await run();
    const rows = await prisma.notification.findMany({
      where: { familyId },
      include: { notificationDeliveries: true },
    });
    expect(rows).toHaveLength(2);
    expect(rows.map((n) => n.recipientUserId).sort()).toEqual(
      [...parents].sort(),
    );
    expect(
      rows.every(
        (n) =>
          n.templateCode === 'NOTI_TRIAL_ENDING' &&
          n.category === 'BILLING' &&
          n.notificationDeliveries.length === 1,
      ),
    ).toBe(true);
    await prisma.notification.updateMany({
      where: { familyId },
      data: { deletedAt: now, dismissedAt: now },
    });
    await run();
    expect(await prisma.notification.count({ where: { familyId } })).toBe(2);
    expect(
      await prisma.jobAttempt.count({
        where: { jobRun: { familyId }, status: 'SUCCEEDED' },
      }),
    ).toBe(3);
  });
  it('coalesces missed thresholds to newest due offset, and waits until local 09:00', async () => {
    await run(new Date('2020-02-01T01:59:00Z'));
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
    await run();
    const n = await prisma.notification.findFirstOrThrow({
      where: { familyId },
    });
    expect(n.payloadReference).toMatchObject({ offsetSeconds: 86400 });
  });
  it('natural expiry without recompute returns EXPIRED and sends one expiry event per Parent', async () => {
    expect(await service.status(familyId, ends)).toMatchObject({
      kind: 'EXPIRED',
      remainingSeconds: 0,
      dismissible: false,
    });
    await run(ends);
    await run(new Date(ends.getTime() + 86400000));
    expect(
      await prisma.notification.count({
        where: { familyId, templateCode: 'NOTI_TRIAL_EXPIRED' },
      }),
    ).toBe(2);
  });
  it('recovers expired grant/policy after recompute clears sourceGrantId and validUntil', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'EXPIRED', sourceGrantId: null, validUntil: null },
    });
    expect(await service.status(familyId, ends)).toMatchObject({
      kind: 'EXPIRED',
      expiresAt: ends,
      policyVersion: 3,
      reminderOffsetsSeconds: [172800, 86400],
    });
    await run(ends);
    const rows = await prisma.notification.findMany({ where: { familyId } });
    expect(
      await prisma.$transaction((tx) =>
        Promise.all(rows.map((n) => push['canView'](tx, n, ends))),
      ),
    ).toEqual([true, true]);
    expect(
      await prisma.notification.count({
        where: { familyId, templateCode: 'NOTI_TRIAL_EXPIRED' },
      }),
    ).toBe(2);
  });
  it('does not emit expired subscription pushes beyond the four-week catch-up window', async () => {
    await run(new Date(ends.getTime() + 28 * 86400000 + 1000));
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
  });
  it('reports grace and paid-expired banner and notification with no trial offsets', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'PAID', inGrace: true },
    });
    expect(await service.status(familyId, now)).toMatchObject({
      kind: 'GRACE',
      policyVersion: 1,
      reminderOffsetsSeconds: [604800, 86400],
    });
    await run();
    expect(
      await prisma.notification.count({
        where: { familyId, templateCode: 'NOTI_SUBSCRIPTION_GRACE' },
      }),
    ).toBe(2);
    await run(ends);
    expect(
      await prisma.notification.count({
        where: { familyId, templateCode: 'NOTI_SUBSCRIPTION_EXPIRED' },
      }),
    ).toBe(2);
  });
  it('skips BLOCKED/INCOMPLETE families, with a non-dismissible blocked banner', async () => {
    await prisma.familyLicense.update({
      where: { id: licenseId },
      data: { blockedAt: now },
    });
    expect(await service.status(familyId, now)).toMatchObject({
      kind: 'BLOCKED',
      dismissible: false,
    });
    await run();
    await prisma.familyLicense.update({
      where: { id: licenseId },
      data: { blockedAt: null },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'INCOMPLETE' },
    });
    await run();
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
  });
  it('rejects stale fencing without side effects and writes failed attempt history', async () => {
    await expect(
      run(now, (context) =>
        service.dispatch(
          now,
          {
            ...context,
            lease: new JobLease(
              context.lease.runId,
              1,
              context.lease.fencingToken + 1n,
              3,
              context.lease.workerId,
            ),
          },
          familyId,
        ),
      ),
    ).rejects.toThrow('lease lost');
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
    expect(
      await prisma.jobAttempt.count({
        where: { jobRun: { familyId }, status: 'FAILED' },
      }),
    ).toBe(1);
  });
  it('push ACL allows billing expiry, denies ordinary content and rejects stale reminders after renewal', async () => {
    await run(ends);
    const rows = await prisma.notification.findMany({ where: { familyId } });
    const allowed = await prisma.$transaction((tx) =>
      Promise.all(rows.map((n) => push['canView'](tx, n, ends))),
    );
    expect(allowed).toEqual([true, true]);
    const regular = await prisma.notification.create({
      data: {
        familyId,
        eventId: randomUUID(),
        recipientUserId: parents[0]!,
        templateCode: 'NOTI_TRIAL_ENDING',
        category: 'MEMORIES',
        subjectType: 'memory',
        subjectId: randomUUID(),
      },
    });
    expect(
      await prisma.$transaction((tx) => push['canView'](tx, regular, ends)),
    ).toBe(false);
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'PAID',
        validUntil: new Date('2021-01-01T00:00:00Z'),
      },
    });
    const renewed = await prisma.$transaction((tx) =>
      Promise.all(rows.map((n) => push['canView'](tx, n, ends))),
    );
    expect(renewed).toEqual([false, false]);
  });
});
