import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test, type TestingModule } from '@nestjs/testing';
import { DomainError } from '../../src/common/errors/domain.error';
import { validateEnvironment } from '../../src/config/environment';
import {
  TRANSACTIONAL_MAIL_JOBS,
  TRANSACTIONAL_MAIL_TEMPLATES,
  type TransactionalMailKind,
} from '../../src/config/transactional-mail-policy';
import { PrismaService } from '../../src/database/prisma.service';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { TRANSACTIONAL_MAIL_REPOSITORY } from '../../src/interfaces/repositories/transactional-mail-repository.interface';
import { JOB_QUEUE_SERVICE } from '../../src/interfaces/services/job-queue-service.interface';
import { MAIL_SERVICE } from '../../src/interfaces/services/mail-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { JobContext } from '../../src/interfaces/services/job-runner-service.interface';
import { JobLease } from '../../src/models/job-lease.model';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import {
  enqueueTransactionalMail,
  recordVerifiedIdentityEmail,
} from '../../src/repositories/transactional-mail-outbox';
import { TransactionalMailRepository } from '../../src/repositories/transactional-mail.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { MailService } from '../../src/services/mail.service';
import { TransactionalMailService } from '../../src/services/transactional-mail.service';
interface Inbox {
  messages: { ID: string }[];
}
interface Message {
  Subject: string;
  Text: string;
  To: { Address: string }[];
}
describe('Transactional mail: isolated Nest, PostgreSQL and real SMTP', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let service: TransactionalMailService;
  let runner: JobRunnerService;
  let mail: MailService;
  const familyId = randomUUID(),
    userId = randomUUID();
  const inbox = `transactional-${userId}@test.local`;
  const api = process.env.TEST_MAILPIT_API_URL ?? 'http://127.0.0.1:8025';
  const queue = {
    isConfigured: () => true,
    enqueue: jest.fn().mockResolvedValue(undefined),
    schedule: jest.fn().mockResolvedValue(undefined),
  };
  const storage = {
    createDownloadUrl: jest.fn((input: { expiresInSeconds: number }) =>
      Promise.resolve({
        url: 'https://downloads.test/export-signed',
        expiresAt: new Date(Date.now() + input.expiresInSeconds * 1000),
      }),
    ),
  };
  let sequence = 0;
  const identities: string[] = [];
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService(
            validateEnvironment({
              ...process.env,
              SMTP_HOST: process.env.TEST_SMTP_HOST ?? '127.0.0.1',
              SMTP_PORT: process.env.TEST_SMTP_PORT ?? '1025',
            }),
          ),
        },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        {
          provide: TRANSACTIONAL_MAIL_REPOSITORY,
          useClass: TransactionalMailRepository,
        },
        { provide: MAIL_SERVICE, useClass: MailService },
        { provide: OBJECT_STORAGE_SERVICE, useValue: storage },
        { provide: JOB_QUEUE_SERVICE, useValue: queue },
        JobRunnerService,
        TransactionalMailService,
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    service = module.get(TransactionalMailService);
    runner = module.get(JobRunnerService);
    mail = module.get(MAIL_SERVICE);
    await prisma.user.create({
      data: {
        id: userId,
        displayName: 'Private person never mailed',
        status: 'ACTIVE',
        locale: 'vi',
      },
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Private family never mailed',
        status: 'ACTIVE',
        createdBy: userId,
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Private papa x9',
        joinedAt: new Date(Date.now() - 60000),
      },
    });
  });
  async function messages() {
    const response = await fetch(
      `${api}/api/v1/search?query=${encodeURIComponent(`to:${inbox}`)}`,
    );
    expect(response.ok).toBe(true);
    return (await response.json()) as Inbox;
  }
  async function identity(
    provider: 'GOOGLE' | 'APPLE' | 'PHONE',
    verified = true,
  ) {
    const row = await prisma.authIdentity.create({
      data: { userId, provider, providerUid: randomUUID(), email: inbox },
    });
    identities.push(row.id);
    if (verified && provider !== 'PHONE')
      await prisma.$transaction((tx) =>
        recordVerifiedIdentityEmail(tx, row.id, inbox),
      );
    return row;
  }
  async function clean() {
    jest.restoreAllMocks();
    const ids = (await messages()).messages.map((row) => row.ID);
    if (ids.length > 0) {
      // Mailpit: one DELETE /api/v1/messages with the IDs of this spec's inbox.
      const removed = await fetch(`${api}/api/v1/messages`, {
        method: 'DELETE',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ IDs: ids }),
      });
      expect(removed.ok).toBe(true);
    }
    await prisma.jobRun.updateMany({
      where: { familyId, status: { in: ['RUNNING', 'RETRY_WAIT', 'PENDING'] } },
      data: {
        status: 'FAILED',
        finishedAt: new Date(),
        leaseOwner: null,
        leaseExpiresAt: null,
      },
    });
    await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
    await prisma.jobRun.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({
      where: {
        OR: [
          {
            eventType: 'mail.transactional',
            payload: { path: ['userId'], equals: userId },
          },
          { eventType: 'auth.email_verified', aggregateId: { in: identities } },
        ],
      },
    });
    await prisma.exportJob.deleteMany({ where: { requesterId: userId } });
    await prisma.deletionRequest.deleteMany({ where: { userId } });
    await prisma.familyDeletionRequest.deleteMany({ where: { familyId } });
    await prisma.authIdentity.deleteMany({ where: { userId } });
  }
  beforeEach(async () => {
    await clean();
    queue.enqueue.mockClear();
    storage.createDownloadUrl.mockClear();
    await prisma.user.update({
      where: { id: userId },
      data: { locale: 'vi', status: 'ACTIVE' },
    });
    await prisma.family.update({
      where: { id: familyId },
      data: { status: 'ACTIVE' },
    });
    await prisma.familyParent.updateMany({
      where: { familyId, userId },
      data: { status: 'ACTIVE', leftAt: null, deletedAt: null },
    });
    await identity('GOOGLE');
  });
  afterAll(async () => {
    if (!prisma) return;
    try {
      await clean();
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.family.delete({ where: { id: familyId } });
      await prisma.user.delete({ where: { id: userId } });
    } finally {
      await module.close();
    }
  });
  async function event(kind: TransactionalMailKind) {
    let referenceId: string = randomUUID();
    const deadline = new Date(Date.now() + 3600000);
    if (kind === 'EXPORT_READY') {
      referenceId = (
        await prisma.exportJob.create({
          data: {
            requesterId: userId,
            familyId,
            scope: 'FAMILY',
            status: 'COMPLETED',
            storageKey: `${familyId}/archive.zip`,
            expiresAt: deadline,
          },
        })
      ).id;
    } else if (kind.startsWith('ACCOUNT_DELETION_')) {
      referenceId = (
        (await prisma.deletionRequest.findFirst({ where: { userId } })) ??
        (await prisma.deletionRequest.create({
          data: {
            userId,
            familyId,
            source: 'APP',
            familyChoice: 'KEEP',
            sharedContentChoice: 'KEEP',
            executeAfter: deadline,
          },
        }))
      ).id;
    } else if (kind.startsWith('FAMILY_DELETION_')) {
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'DELETION_SCHEDULED' },
      });
      referenceId = (
        (await prisma.familyDeletionRequest.findFirst({
          where: { familyId },
        })) ??
        (await prisma.familyDeletionRequest.create({
          data: {
            familyId,
            requestedBy: userId,
            status: 'SCHEDULED',
            executeAfter: deadline,
          },
        }))
      ).id;
    }
    await prisma.$transaction((tx) =>
      enqueueTransactionalMail(tx, kind, userId, referenceId),
    );
    const row = await prisma.outboxEvent.findFirstOrThrow({
      where: {
        aggregateId: referenceId,
        payload: { path: ['kind'], equals: kind },
      },
    });
    return { eventId: row.eventId, referenceId };
  }
  function run(
    eventId: string,
    handler?: (context: JobContext) => Promise<Record<string, number>>,
  ) {
    return runner.execute(
      TRANSACTIONAL_MAIL_JOBS.deliver,
      {
        familyId,
        scopeKey: eventId,
        scheduledFor: new Date(Date.now() + sequence++),
        idempotencyKey: `mail-event:${eventId}`,
      },
      handler ?? ((context) => service.deliver(eventId, context)),
    );
  }
  async function state(eventId: string) {
    return (await prisma.outboxEvent.findUniqueOrThrow({ where: { eventId } }))
      .payload as { state: string };
  }
  const kinds = Object.keys(
    TRANSACTIONAL_MAIL_TEMPLATES.vi,
  ) as TransactionalMailKind[];
  it.each(['vi', 'en'] as const)(
    'delivers all seven versioned %s templates once without private content',
    async (locale) => {
      await prisma.user.update({ where: { id: userId }, data: { locale } });
      for (const kind of kinds) {
        const { eventId } = await event(kind);
        expect(await run(eventId)).toBe('SUCCEEDED');
        expect(await run(eventId)).toBe('ALREADY_FINISHED');
        expect((await state(eventId)).state).toBe('SENT');
      }
      const found = await messages();
      expect(found.messages).toHaveLength(7);
      const bodies = await Promise.all(
        found.messages.map(
          async (row) =>
            (await (
              await fetch(`${api}/api/v1/message/${row.ID}`)
            ).json()) as Message,
        ),
      );
      for (const kind of kinds)
        expect(
          bodies.some(
            (message) =>
              message.Subject ===
                TRANSACTIONAL_MAIL_TEMPLATES[locale][kind][0] &&
              message.Text.includes(
                TRANSACTIONAL_MAIL_TEMPLATES[locale][kind][1],
              ),
          ),
        ).toBe(true);
      for (const message of bodies) {
        expect(message.To.map((to) => to.Address)).toContain(inbox);
        expect(message.Text).toContain('Baby Family · v1');
        expect(message.Text).not.toContain('Private');
      }
      expect(storage.createDownloadUrl).toHaveBeenCalledTimes(1);
      expect(
        storage.createDownloadUrl.mock.calls[0]![0].expiresInSeconds,
      ).toBeLessThanOrEqual(900);
      expect(
        await prisma.jobAttempt.count({
          where: { jobRun: { familyId }, status: 'SUCCEEDED' },
        }),
      ).toBe(7);
    },
  );
  it('rejects PHONE and unverified social email, accepts verified Apple proof', async () => {
    await prisma.authIdentity.deleteMany({ where: { userId } });
    await identity('PHONE');
    await identity('GOOGLE', false);
    const skipped = await event('PHONE_CHANGED');
    await run(skipped.eventId);
    expect((await state(skipped.eventId)).state).toBe('SKIPPED');
    expect((await messages()).messages).toHaveLength(0);
    await identity('APPLE');
    const sent = await event('SIGN_IN_METHOD_ADDED');
    await run(sent.eventId);
    expect((await messages()).messages).toHaveLength(1);
  });
  it('rechecks cancellation, export expiry and revoked Parent ACL before signing or sending', async () => {
    const account = await event('ACCOUNT_DELETION_SCHEDULED');
    await prisma.deletionRequest.update({
      where: { id: account.referenceId },
      data: { status: 'CANCELLED' },
    });
    await run(account.eventId);
    const family = await event('FAMILY_DELETION_REMINDER');
    await prisma.familyDeletionRequest.update({
      where: { id: family.referenceId },
      data: { status: 'CANCELLED' },
    });
    await run(family.eventId);
    const expired = await event('EXPORT_READY');
    await prisma.exportJob.update({
      where: { id: expired.referenceId },
      data: { expiresAt: new Date(Date.now() - 1000) },
    });
    await run(expired.eventId);
    const revoked = await event('EXPORT_READY');
    await prisma.familyParent.updateMany({
      where: { familyId, userId },
      data: { status: 'LEFT', leftAt: new Date() },
    });
    await run(revoked.eventId);
    for (const row of [account, family, expired, revoked])
      expect((await state(row.eventId)).state).toBe('SKIPPED');
    expect((await messages()).messages).toHaveLength(0);
    expect(storage.createDownloadUrl).not.toHaveBeenCalled();
  });
  it('retries definite SMTP rejection with durable attempt history and one delivery', async () => {
    const { eventId } = await event('PHONE_CHANGED');
    const spy = jest
      .spyOn(mail, 'send')
      .mockRejectedValueOnce(
        new DomainError(
          'Mail delivery was rejected.',
          'MAIL_DELIVERY_RETRYABLE',
          503,
        ),
      );
    await expect(run(eventId)).rejects.toMatchObject({
      code: 'MAIL_DELIVERY_RETRYABLE',
    });
    expect((await state(eventId)).state).toBe('READY');
    await run(eventId);
    expect(spy).toHaveBeenCalledTimes(2);
    expect((await messages()).messages).toHaveLength(1);
    expect(
      (
        await prisma.jobAttempt.findMany({
          where: { jobRun: { familyId } },
          orderBy: { attemptNumber: 'asc' },
        })
      ).map((row) => row.status),
    ).toEqual(['FAILED', 'SUCCEEDED']);
  });
  it('keeps ambiguous SMTP outcome UNKNOWN and forbids automatic resend', async () => {
    const { eventId } = await event('SIGN_IN_METHOD_ADDED');
    const spy = jest
      .spyOn(mail, 'send')
      .mockRejectedValueOnce(new Error('Socket closed after DATA'));
    await expect(run(eventId)).rejects.toThrow('Socket');
    expect((await state(eventId)).state).toBe('UNKNOWN');
    await expect(run(eventId)).rejects.toMatchObject({
      code: 'MAIL_OUTCOME_UNKNOWN',
    });
    expect(spy).toHaveBeenCalledTimes(1);
    expect(
      await prisma.jobRun.findFirst({ where: { familyId } }),
    ).toMatchObject({
      status: 'FAILED',
      attempts: 2,
      lastErrorCode: 'MAIL_OUTCOME_UNKNOWN',
    });
    expect((await messages()).messages).toHaveLength(0);
  });
  it('rejects stale fencing before SMTP', async () => {
    const { eventId } = await event('PHONE_CHANGED');
    await expect(
      run(eventId, (context) =>
        service.deliver(eventId, {
          ...context,
          lease: new JobLease(
            context.lease.runId,
            context.lease.attemptNumber,
            context.lease.fencingToken + 1n,
            3,
            context.lease.workerId,
          ),
        }),
      ),
    ).rejects.toMatchObject({ code: 'JOB_LEASE_LOST' });
    expect((await state(eventId)).state).toBe('READY');
    expect((await messages()).messages).toHaveLength(0);
    expect(
      await prisma.jobAttempt.count({
        where: { jobRun: { familyId }, status: 'FAILED' },
      }),
    ).toBe(1);
  });
  it('reconciles scoped schedule/reminder keys idempotently and recovers lost enqueue', async () => {
    await event('ACCOUNT_DELETION_SCHEDULED');
    await event('FAMILY_DELETION_SCHEDULED');
    const reconcile = () =>
      runner.execute(
        TRANSACTIONAL_MAIL_JOBS.reconcile,
        {
          familyId,
          scopeKey: familyId,
          scheduledFor: new Date(Date.now() + sequence++),
          idempotencyKey: `mail-spec:${familyId}:${randomUUID()}`,
        },
        (context) => service.reconcile(new Date(), context, familyId, userId),
      );
    await reconcile();
    await reconcile();
    const rows = await prisma.outboxEvent.findMany({
      where: {
        eventType: 'mail.transactional',
        payload: { path: ['userId'], equals: userId },
      },
    });
    expect(rows).toHaveLength(4);
    expect(
      new Set(rows.map((row) => (row.payload as { kind: string }).kind)),
    ).toEqual(
      new Set([
        'ACCOUNT_DELETION_SCHEDULED',
        'ACCOUNT_DELETION_REMINDER',
        'FAMILY_DELETION_SCHEDULED',
        'FAMILY_DELETION_REMINDER',
      ]),
    );
    expect(queue.enqueue).toHaveBeenCalledTimes(8);
    const ids = new Set(rows.map((row) => row.eventId));
    for (const call of queue.enqueue.mock.calls as [
      unknown,
      string,
      { eventId: string },
    ][]) {
      expect(ids.has(call[2].eventId)).toBe(true);
      expect(call[1]).toBe(`evt-${call[2].eventId}`);
    }
    queue.enqueue.mockClear();
    await run(rows[0]!.eventId);
    await reconcile();
    expect(queue.enqueue).toHaveBeenCalledTimes(3);
  });
});
