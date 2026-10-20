import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../src/database/prisma.service';
import type { Prisma } from '../../src/generated/prisma/client';
import { validateEnvironment } from '../../src/config/environment';
import { JOBS } from '../../src/config/jobs';
import { PUSH_POLICY } from '../../src/config/push-policy';
import { PermanentJobError } from '../../src/common/errors/job.error';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { PUSH_DELIVERY_REPOSITORY } from '../../src/interfaces/repositories/push-delivery-repository.interface';
import { PUSH_SENDER } from '../../src/interfaces/services/push-sender.interface';
import type { IPushSender } from '../../src/interfaces/services/push-sender.interface';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { PushDeliveryRepository } from '../../src/repositories/push-delivery.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { PushDeliveryService } from '../../src/services/push-delivery.service';
import { JobLease } from '../../src/models/job-lease.model';

/** Real PostgreSQL claims and durable runner, with an entirely offline provider. */
describe('Push delivery (PostgreSQL, durable jobs)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let service: PushDeliveryService;
  let runner: JobRunnerService;
  const send = jest.fn<
    ReturnType<IPushSender['send']>,
    Parameters<IPushSender['send']>
  >();
  const familyId = randomUUID();
  const billingPlanId = randomUUID();
  const billingPlanVersionId = randomUUID();
  const userId = randomUUID();
  const deviceId = randomUUID();
  const eventId = randomUUID();
  const templateCode = `TEST_PUSH_${randomUUID().slice(0, 8)}`;
  // Before any other suite's real-time data: the global claim only sees this suite's deliveries.
  const now = new Date('2020-02-01T02:00:00Z');
  const joined = new Date('2019-01-01T00:00:00Z');

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Push tests require a *_test database.');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService(validateEnvironment(process.env)),
        },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        { provide: PUSH_DELIVERY_REPOSITORY, useClass: PushDeliveryRepository },
        { provide: PUSH_SENDER, useValue: { send } },
        JobRunnerService,
        PushDeliveryService,
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    runner = module.get(JobRunnerService);
    service = module.get(PushDeliveryService);
    await prisma.user.create({
      data: {
        id: userId,
        displayName: 'Push test parent',
        status: 'ACTIVE',
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Push test family',
        createdBy: userId,
        status: 'ACTIVE',
      },
    });
    await prisma.plan.create({
      data: {
        id: billingPlanId,
        code: `PUSH_${billingPlanId.slice(0, 8)}`,
        displayNameI18n: { vi: 'Push fixture' },
      },
    });
    await prisma.planVersion.create({
      data: {
        id: billingPlanVersionId,
        planId: billingPlanId,
        version: 1,
        quotas: {},
        features: {},
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: billingPlanVersionId,
        validUntil: new Date('2021-02-01T02:00:00Z'),
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
        joinedAt: joined,
      },
    });
    await prisma.userDevice.create({
      data: {
        id: deviceId,
        userId,
        platform: 'IOS',
        pushEnabled: true,
        pushToken: `test-${deviceId}`,
        timezone: 'Asia/Ho_Chi_Minh',
        locale: 'en',
      },
    });
    await prisma.event.create({
      data: {
        id: eventId,
        familyId,
        type: 'FAMILY',
        title: 'Private event title',
        startAt: now,
        localStartDate: new Date('2020-02-01'),
        timezone: 'Asia/Ho_Chi_Minh',
        createdBy: userId,
      },
    });
    await prisma.notificationTemplate.createMany({
      data: ['vi', 'en'].map((locale) => ({
        code: templateCode,
        locale,
        title: locale === 'en' ? 'Hello {{actorName}}' : 'Chào {{actorName}}',
        body: 'New update {{actorName}}',
        category: 'MEMORIES',
      })),
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
    await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
    await prisma.jobRun.deleteMany({ where: { familyId } });
  }
  beforeEach(async () => {
    await clear();
    await prisma.userDevice.updateMany({
      where: { userId, id: { not: deviceId } },
      data: { pushEnabled: false, deletedAt: now },
    });
    send
      .mockReset()
      .mockResolvedValue({ status: 'sent', messageId: 'offline-provider-id' });
    await prisma.userDevice.update({
      where: { id: deviceId },
      data: {
        pushEnabled: true,
        pushToken: `test-${deviceId}`,
        deletedAt: null,
      },
    });
    await prisma.familyParent.updateMany({
      where: { familyId },
      data: { status: 'ACTIVE' },
    });
  });
  afterAll(async () => {
    if (!prisma) return;
    try {
      await clear();
      await prisma.notificationTemplate.deleteMany({
        where: { code: templateCode },
      });
      await prisma.event.deleteMany({ where: { familyId } });
      await prisma.userDevice.deleteMany({ where: { userId } });
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.familyEntitlement.deleteMany({ where: { familyId } });
      await prisma.planVersion.deleteMany({
        where: { id: billingPlanVersionId },
      });
      await prisma.plan.deleteMany({ where: { id: billingPlanId } });
      // License identities have mandatory retention; retire this spec's fixture only.
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
      await prisma.user.update({
        where: { id: userId },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
    } finally {
      await module.close();
    }
  });
  async function notification(at = now, sensitive = false) {
    const n = await prisma.notification.create({
      data: {
        familyId,
        recipientUserId: userId,
        eventId: randomUUID(),
        templateCode,
        category: 'MEMORIES',
        subjectType: 'calendar_event',
        subjectId: eventId,
        sensitive,
        createdAt: at,
        payloadReference: {
          params: { actorName: 'Papa', secret: 'never send this' },
          deepLink: `babyfamily://calendar/events/${eventId}`,
        },
      },
    });
    await prisma.notificationDelivery.create({
      data: {
        notificationId: n.id,
        channel: 'PUSH',
        targetKey: userId,
        nextAttemptAt: at,
      },
    });
    return n;
  }
  function run(at = now, key = randomUUID()) {
    return runner.execute(
      JOBS.deliverPush,
      {
        familyId,
        scopeKey: key,
        scheduledFor: at,
        idempotencyKey: `push-test:${key}`,
      },
      (ctx) => service.deliver(at, ctx),
    );
  }
  async function deviceDelivery(notificationId: string) {
    return prisma.notificationDelivery.findFirstOrThrow({
      where: { notificationId, deviceId },
    });
  }
  it('sends a localized safe message once across repeated durable jobs and concurrent claims', async () => {
    const n = await notification();
    await Promise.all([run(), run()]);
    await run();
    expect(send).toHaveBeenCalledTimes(1);
    expect(send.mock.calls[0]?.[0]).toEqual({
      token: `test-${deviceId}`,
      title: 'Hello Papa',
      body: 'New update Papa',
      data: {
        notificationId: n.id,
        deepLink: `babyfamily://calendar/events/${eventId}`,
      },
    });
    const delivery = await deviceDelivery(n.id);
    expect(delivery.status).toBe('SENT');
    expect(
      await prisma.notificationDeliveryAttempt.count({
        where: { deliveryId: delivery.id },
      }),
    ).toBe(1);
    expect(
      await prisma.jobAttempt.count({ where: { jobRun: { familyId } } }),
    ).toBe(3);
  });
  it('delays default quiet hours in the device timezone until 06:30', async () => {
    const quietNow = new Date('2020-02-01T16:00Z');
    const n = await notification(quietNow);
    await run(quietNow);
    expect(send).not.toHaveBeenCalled();
    expect((await deviceDelivery(n.id)).nextAttemptAt).toEqual(
      new Date('2020-02-01T23:30Z'),
    );
    await run(new Date('2020-02-01T23:30Z'));
    expect(send).toHaveBeenCalledTimes(1);
  });
  it('enforces the three nonurgent pushes per local day and keeps the inbox', async () => {
    const notifications = [];
    for (let i = 0; i < 4; i++) notifications.push(await notification());
    await run();
    expect(send).toHaveBeenCalledTimes(3);
    expect(await prisma.notification.count({ where: { familyId } })).toBe(4);
    const skipped = await prisma.notificationDelivery.findMany({
      where: { notification: { familyId }, lastErrorCode: 'SKIPPED_CAP' },
    });
    expect(skipped).toHaveLength(1);
    expect(skipped[0]?.status).toBe('CANCELLED');
  });
  it('hides sensitive content even for a template that contains content', async () => {
    await notification(now, true);
    await run();
    expect(send.mock.calls[0]?.[0]).toMatchObject({
      title: 'Baby Family',
      body: 'You have a new update from Papa & Mama',
    });
    expect(JSON.stringify(send.mock.calls)).not.toContain('never send this');
    expect(send.mock.calls[0]?.[0].data).toEqual(
      expect.objectContaining({
        notificationId: expect.any(String),
        deepLink: expect.any(String),
      }),
    );
    expect(Object.keys(send.mock.calls[0]![0].data).sort()).toEqual([
      'deepLink',
      'notificationId',
    ]);
  });
  it.each(['disabled', 'missing-token', 'deleted'])(
    'does not send to a %s device',
    async (state) => {
      await notification();
      await prisma.userDevice.update({
        where: { id: deviceId },
        data:
          state === 'disabled'
            ? { pushEnabled: false }
            : state === 'deleted'
              ? { deletedAt: now }
              : { pushToken: null },
      });
      await run();
      expect(send).not.toHaveBeenCalled();
    },
  );
  it('rechecks family membership before sending', async () => {
    await notification();
    await prisma.familyParent.updateMany({
      where: { familyId },
      data: { status: 'LEFT' },
    });
    await run();
    expect(send).not.toHaveBeenCalled();
  });
  it('clears an invalid token and persists permanent failure and attempt', async () => {
    const n = await notification();
    send.mockResolvedValue({
      status: 'invalid-token',
      code: 'FCM_UNREGISTERED',
    });
    await run();
    expect(
      (await prisma.userDevice.findUniqueOrThrow({ where: { id: deviceId } }))
        .pushToken,
    ).toBeNull();
    const delivery = await deviceDelivery(n.id);
    expect(delivery).toMatchObject({
      status: 'FAILED',
      lastErrorCode: 'FAILED_PERMANENT',
      attempts: 1,
    });
    expect(
      await prisma.notificationDeliveryAttempt.findFirst({
        where: { deliveryId: delivery.id },
      }),
    ).toMatchObject({ outcome: 'FAILED', errorCode: 'FCM_UNREGISTERED' });
    await run();
    expect(send).toHaveBeenCalledTimes(1);
  });
  it('backs off transient failures and stops after the configured bound', async () => {
    const n = await notification();
    send.mockResolvedValue({ status: 'transient', code: 'FCM_UNAVAILABLE' });
    await run();
    let delivery = await deviceDelivery(n.id);
    expect(delivery).toMatchObject({
      status: 'RETRY_WAIT',
      attempts: 1,
    });
    expect(delivery.nextAttemptAt!.getTime()).toBeGreaterThanOrEqual(
      now.getTime() + PUSH_POLICY.backoffMs,
    );
    expect(delivery.nextAttemptAt!.getTime()).toBeLessThan(
      now.getTime() + PUSH_POLICY.backoffMs + 5000,
    );
    await run();
    expect(send).toHaveBeenCalledTimes(1);
    let at = now;
    for (let i = 1; i < PUSH_POLICY.maxAttempts; i++) {
      at = delivery.nextAttemptAt!;
      await run(at);
      delivery = await deviceDelivery(n.id);
    }
    expect(delivery).toMatchObject({
      status: 'FAILED',
      attempts: PUSH_POLICY.maxAttempts,
      nextAttemptAt: null,
    });
    expect(send).toHaveBeenCalledTimes(PUSH_POLICY.maxAttempts);
    expect(
      await prisma.notificationDeliveryAttempt.count({
        where: { deliveryId: delivery.id },
      }),
    ).toBe(PUSH_POLICY.maxAttempts);
    await run(new Date(at.getTime() + 3600000));
    expect(send).toHaveBeenCalledTimes(PUSH_POLICY.maxAttempts);
  });
  it('counts each logical notification once across multiple devices', async () => {
    const secondDeviceId = randomUUID();
    await prisma.userDevice.create({
      data: {
        id: secondDeviceId,
        userId,
        platform: 'ANDROID',
        pushEnabled: true,
        pushToken: `test-${secondDeviceId}`,
        timezone: 'Asia/Ho_Chi_Minh',
        locale: 'en',
      },
    });
    for (let i = 0; i < 4; i++) await notification();
    await run();
    await run();
    expect(send).toHaveBeenCalledTimes(6);
    const sent = await prisma.notificationDelivery.findMany({
      where: { notification: { familyId }, status: 'SENT' },
    });
    expect(new Set(sent.map((d) => d.notificationId)).size).toBe(3);
    expect(sent).toHaveLength(6);
    expect(
      await prisma.notificationDelivery.count({
        where: { notification: { familyId }, lastErrorCode: 'SKIPPED_CAP' },
      }),
    ).toBe(2);
  });
  it('closes an abandoned send as unknown and never replays the ambiguous provider call', async () => {
    const n = await notification();
    const key = randomUUID();
    const repository = module.get<PushDeliveryRepository>(
      PUSH_DELIVERY_REPOSITORY,
    );
    await expect(
      runner.execute(
        JOBS.deliverPush,
        {
          familyId,
          scopeKey: key,
          scheduledFor: now,
          idempotencyKey: `push-test:${key}`,
        },
        async (ctx) => {
          const candidate = await repository.claim(now, ctx.lease, () => ({
            action: 'send',
          }));
          expect(candidate?.notificationId).toBe(n.id);
          throw new PermanentJobError(
            'SIMULATED_CRASH',
            'Simulated worker exit after reservation.',
          );
        },
      ),
    ).rejects.toThrow('Simulated worker exit');
    expect(await deviceDelivery(n.id)).toMatchObject({
      status: 'CANCELLED',
      lastErrorCode: 'SEND_IN_FLIGHT',
      attempts: 1,
    });
    await run();
    await run();
    const delivery = await deviceDelivery(n.id);
    expect(delivery).toMatchObject({
      status: 'FAILED',
      lastErrorCode: 'DELIVERY_UNKNOWN',
      attempts: 1,
    });
    expect(
      await prisma.notificationDeliveryAttempt.findFirst({
        where: { deliveryId: delivery.id },
      }),
    ).toMatchObject({
      outcome: 'UNKNOWN',
      errorCode: 'DELIVERY_UNKNOWN',
      finishedAt: expect.any(Date),
    });
    expect(send).not.toHaveBeenCalled();
  });
  it('rechecks Circle grants and rebuilds child names after partial revocation', async () => {
    const circleId = randomUUID(),
      circleDevice = randomUUID(),
      childId = randomUUID(),
      secondChildId = randomUUID(),
      memoryId = randomUUID(),
      memberId = randomUUID();
    try {
      await prisma.user.create({
        data: { id: circleId, displayName: 'Push circle', status: 'ACTIVE' },
      });
      await prisma.userDevice.create({
        data: {
          id: circleDevice,
          userId: circleId,
          platform: 'IOS',
          pushEnabled: true,
          pushToken: `test-${circleDevice}`,
          timezone: 'Asia/Ho_Chi_Minh',
        },
      });
      await prisma.child.create({
        data: {
          id: childId,
          familyId,
          nickname: 'Push child',
          birthDate: new Date('2018-01-01'),
          colorIndex: 1,
          createdBy: userId,
        },
      });
      await prisma.child.create({
        data: {
          id: secondChildId,
          familyId,
          nickname: 'Revoked child',
          birthDate: new Date('2018-01-01'),
          colorIndex: 2,
          createdBy: userId,
        },
      });
      await prisma.notificationTemplate.updateMany({
        where: { code: templateCode },
        data: { body: 'New update {{childNames}}' },
      });
      await prisma.circleMember.create({
        data: {
          id: memberId,
          familyId,
          userId: circleId,
          relation: 'CAREGIVER',
          displayName: 'Circle',
          invitedBy: userId,
          joinedAt: joined,
        },
      });
      const grant = await prisma.circleGrant.create({
        data: {
          familyId,
          circleMemberId: memberId,
          childId,
          permission: 'VIEW',
          createdBy: userId,
        },
      });
      const secondGrant = await prisma.circleGrant.create({
        data: {
          familyId,
          circleMemberId: memberId,
          childId: secondChildId,
          permission: 'VIEW',
          createdBy: userId,
        },
      });
      await prisma.memory.create({
        data: {
          id: memoryId,
          familyId,
          authorUserId: userId,
          authorRole: 'PARENT',
          occurredAt: now,
          occurredLocalDate: new Date('2020-02-01'),
          visibility: 'FAMILY',
          status: 'PUBLISHED',
        },
      });
      await prisma.memoryChild.create({
        data: { familyId, memoryId, childId, ageMonth: 25 },
      });
      await prisma.memoryChild.create({
        data: { familyId, memoryId, childId: secondChildId, ageMonth: 25 },
      });
      async function circleNotification() {
        const n = await notification();
        await prisma.notification.update({
          where: { id: n.id },
          data: {
            recipientUserId: circleId,
            subjectType: 'memory',
            subjectId: memoryId,
            payloadReference: {
              params: { childNames: ['Push child', 'Revoked child'] },
              deepLink: `babyfamily://memories/${memoryId}`,
            },
          },
        });
        return n;
      }
      await circleNotification();
      await run();
      expect(send).toHaveBeenCalledTimes(1);
      expect(send.mock.calls[0]?.[0].body).toContain('Revoked child');
      await circleNotification();
      await prisma.circleGrant.update({
        where: { id: secondGrant.id },
        data: { deletedAt: now },
      });
      await run();
      expect(send).toHaveBeenCalledTimes(2);
      expect(send.mock.calls[1]?.[0].body).toContain('Push child');
      expect(send.mock.calls[1]?.[0].body).not.toContain('Revoked child');
      const denied = await circleNotification();
      await prisma.circleGrant.update({
        where: { id: grant.id },
        data: { deletedAt: now },
      });
      await run();
      expect(send).toHaveBeenCalledTimes(2);
      expect(
        await prisma.notificationDelivery.findFirst({
          where: { notificationId: denied.id },
        }),
      ).toMatchObject({ status: 'CANCELLED', lastErrorCode: 'ACCESS_REVOKED' });
    } finally {
      await clear();
      await prisma.memoryChild.deleteMany({ where: { memoryId } });
      await prisma.memory.deleteMany({ where: { id: memoryId } });
      await prisma.circleGrant.deleteMany({
        where: { circleMemberId: memberId },
      });
      await prisma.circleMember.deleteMany({ where: { id: memberId } });
      await prisma.child.deleteMany({
        where: { id: { in: [childId, secondChildId] } },
      });
      await prisma.notificationTemplate.updateMany({
        where: { code: templateCode },
        data: { body: 'New update {{actorName}}' },
      });
      await prisma.userDevice.deleteMany({ where: { userId: circleId } });
      await prisma.user.deleteMany({ where: { id: circleId } });
    }
  });
  it.each([
    ['NOTI_MEMORY_REVIEW_REQUESTED', 'PENDING_REVIEW'],
    ['NOTI_MEMORY_APPROVED', 'PROCESSING'],
    ['NOTI_MEMORY_APPROVED', 'PUBLISHED'],
    ['NOTI_MEMORY_REJECTED', 'REJECTED'],
  ] as const)(
    'delivers %s with current review ACL, strips preview params and cancels stale/revoked deliveries',
    async (reviewTemplate, status) => {
      const circleId = randomUUID();
      const circleDevice = randomUUID();
      const memoryId = randomUUID();
      const memberId = randomUUID();
      const pendingReview = reviewTemplate === 'NOTI_MEMORY_REVIEW_REQUESTED';
      // Keep catalog fixtures isolated: only template lookup is substituted; ACL,
      // claims, device fanout, attempts and delivery persistence use PostgreSQL.
      const templates = await prisma.notificationTemplate.findMany({
        where: { code: templateCode },
      });
      const transaction = prisma.$transaction.bind(prisma);
      const templateLookup = jest
        .spyOn(prisma, '$transaction')
        .mockImplementation(
          (
            callback: (tx: Prisma.TransactionClient) => Promise<unknown>,
            options?: {
              timeout?: number;
              maxWait?: number;
              isolationLevel?: Prisma.TransactionIsolationLevel;
            },
          ) =>
            transaction(
              (tx) =>
                callback(
                  new Proxy(tx, {
                    get(target, property) {
                      if (property === 'notificationTemplate')
                        return new Proxy(target.notificationTemplate, {
                          get(delegate, method) {
                            if (method === 'findMany')
                              return () =>
                                Promise.resolve(
                                  templates.map((template) => ({
                                    ...template,
                                    title: 'Memory update',
                                    body: 'Review status updated {{childNames}} {{actorName}}',
                                  })),
                                );
                            return Reflect.get(delegate, method) as unknown;
                          },
                        });
                      return Reflect.get(target, property) as unknown;
                    },
                  }),
                ),
              options,
            ),
        );
      try {
        await prisma.user.create({
          data: {
            id: circleId,
            displayName: 'Review author',
            status: 'ACTIVE',
          },
        });
        await prisma.circleMember.create({
          data: {
            id: memberId,
            familyId,
            userId: circleId,
            relation: 'OTHER',
            displayName: 'Review author',
            joinedAt: joined,
          },
        });
        await prisma.userDevice.create({
          data: {
            id: circleDevice,
            userId: circleId,
            platform: 'IOS',
            pushEnabled: true,
            pushToken: `test-${circleDevice}`,
            timezone: 'Asia/Ho_Chi_Minh',
            locale: 'en',
          },
        });
        await prisma.memory.create({
          data: {
            id: memoryId,
            familyId,
            authorUserId: circleId,
            authorRole: 'CIRCLE',
            status,
            visibility: 'FAMILY',
            occurredAt: now,
            occurredLocalDate: now,
            reviewedAt: pendingReview ? null : now,
            reviewedBy: pendingReview ? null : userId,
          },
        });
        async function reviewNotification() {
          const n = await notification();
          await prisma.notification.update({
            where: { id: n.id },
            data: {
              templateCode: reviewTemplate,
              recipientUserId: pendingReview ? userId : circleId,
              subjectType: 'memory',
              subjectId: memoryId,
              payloadReference: {
                params: {
                  actorUserId: pendingReview ? circleId : userId,
                  familyId,
                  entityId: memoryId,
                  childNames: ['Private child'],
                  actorName: 'Private actor',
                  reason: 'Private rejection reason',
                },
                deepLink: `babyfamily://memories/${memoryId}`,
              },
            },
          });
          return n;
        }
        const sent = await reviewNotification();
        await run();
        expect(
          await prisma.notificationDelivery.findMany({
            where: { notificationId: sent.id },
            select: { status: true, lastErrorCode: true },
          }),
        ).toEqual(
          expect.arrayContaining([expect.objectContaining({ status: 'SENT' })]),
        );
        expect(send).toHaveBeenCalledTimes(1);
        expect(send.mock.calls[0]?.[0].data.notificationId).toBe(sent.id);
        expect(JSON.stringify(send.mock.calls)).not.toMatch(/Private|reason/);
        const wrongAudience = await reviewNotification();
        await prisma.notification.update({
          where: { id: wrongAudience.id },
          data: { recipientUserId: pendingReview ? circleId : userId },
        });
        await run();
        expect(send).toHaveBeenCalledTimes(1);
        expect(
          await prisma.notificationDelivery.findFirst({
            where: { notificationId: wrongAudience.id },
          }),
        ).toMatchObject({
          status: 'CANCELLED',
          lastErrorCode: 'ACCESS_REVOKED',
        });
        const denied = await reviewNotification();
        if (pendingReview)
          await prisma.familyParent.updateMany({
            where: { familyId, userId },
            data: { leftAt: now },
          });
        else
          await prisma.circleMember.update({
            where: { id: memberId },
            data: { endedAt: now },
          });
        await run();
        expect(send).toHaveBeenCalledTimes(1);
        expect(
          await prisma.notificationDelivery.findFirst({
            where: { notificationId: denied.id },
          }),
        ).toMatchObject({
          status: 'CANCELLED',
          lastErrorCode: 'ACCESS_REVOKED',
        });
        await prisma.familyParent.updateMany({
          where: { familyId, userId },
          data: { leftAt: null },
        });
        await prisma.circleMember.update({
          where: { id: memberId },
          data: { endedAt: null },
        });
        const stale = await reviewNotification();
        await prisma.memory.update({
          where: { id: memoryId },
          data: {
            status:
              status === 'REJECTED' || pendingReview ? 'PUBLISHED' : 'REJECTED',
          },
        });
        await run();
        expect(send).toHaveBeenCalledTimes(1);
        expect(
          await prisma.notificationDelivery.findFirst({
            where: { notificationId: stale.id },
          }),
        ).toMatchObject({
          status: 'CANCELLED',
          lastErrorCode: 'ACCESS_REVOKED',
        });
      } finally {
        templateLookup.mockRestore();
        await clear();
        await prisma.familyParent.updateMany({
          where: { familyId, userId },
          data: { leftAt: null },
        });
        await prisma.memory.deleteMany({ where: { id: memoryId, familyId } });
        await prisma.circleMember.deleteMany({
          where: { id: memberId, familyId },
        });
        await prisma.userDevice.deleteMany({ where: { userId: circleId } });
        await prisma.user.deleteMany({ where: { id: circleId } });
      }
    },
  );
  it('rejects a stale fencing lease before claiming or sending', async () => {
    await notification();
    await expect(
      service.deliver(now, {
        signal: new AbortController().signal,
        lease: new JobLease(randomUUID(), 1, 1n, 3, 'missing'),
      }),
    ).rejects.toThrow(/lease/i);
    expect(send).not.toHaveBeenCalled();
  });
});
