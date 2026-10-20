import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import { JOBS } from '../../src/config/jobs';
import type { JobPolicy } from '../../src/config/jobs';
import { EVENT_REMINDER_SCHEDULE_REPOSITORY } from '../../src/interfaces/repositories/event-reminder-schedule-repository.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { EventReminderScheduleRepository } from '../../src/repositories/event-reminder-schedule.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { EventReminderScheduleService } from '../../src/services/event-reminder-schedule.service';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { JobLease } from '../../src/models/job-lease.model';
import type { JobContext } from '../../src/interfaces/services/job-runner-service.interface';

/** Focused composition root deliberately excludes the application's shared DI file. */
describe('Event reminders (PostgreSQL, durable jobs)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let service: EventReminderScheduleService;
  let runner: JobRunnerService;
  const familyId = randomUUID();
  const parent = randomUUID();
  const circle = randomUUID();
  const childId = randomUUID();
  const memberId = randomUUID();
  const now = new Date('2030-02-01T00:00:00.000Z');
  const startAt = new Date('2030-02-02T02:00:00.000Z');

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Event reminders require a *_test database.');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService(validateEnvironment(process.env)),
        },
        {
          provide: EVENT_REMINDER_SCHEDULE_REPOSITORY,
          useClass: EventReminderScheduleRepository,
        },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        EventReminderScheduleService,
        JobRunnerService,
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    service = module.get(EventReminderScheduleService);
    runner = module.get(JobRunnerService);
    await prisma.user.createMany({
      data: [parent, circle].map((id) => ({
        id,
        displayName: 'Reminder test user',
        status: 'ACTIVE',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Reminder test family',
        createdBy: parent,
        status: 'ACTIVE',
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: parent,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await prisma.child.create({
      data: {
        id: childId,
        nickname: 'Reminder child',
        familyId,
        birthDate: new Date('2028-01-01'),
        colorIndex: 1,
        createdBy: parent,
      },
    });
    await prisma.circleMember.create({
      data: {
        id: memberId,
        familyId,
        userId: circle,
        relation: 'CAREGIVER',
        displayName: 'Circle',
        status: 'ACTIVE',
        invitedBy: parent,
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        childId,
        circleMemberId: memberId,
        permission: 'VIEW',
        createdBy: parent,
      },
    });
  });

  async function clear() {
    await prisma.notification.deleteMany({ where: { familyId } });
    await prisma.eventReminder.deleteMany({ where: { familyId } });
    await prisma.eventReminderRule.deleteMany({ where: { familyId } });
    await prisma.eventChild.deleteMany({ where: { familyId } });
    await prisma.event.deleteMany({ where: { familyId } });
    await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
    await prisma.jobRun.deleteMany({ where: { familyId } });
  }
  beforeEach(clear);
  afterAll(async () => {
    if (!prisma) return;
    try {
      await clear();
      await prisma.circleGrant.deleteMany({ where: { familyId } });
      await prisma.circleMember.deleteMany({ where: { familyId } });
      await prisma.child.deleteMany({ where: { familyId } });
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.family.deleteMany({ where: { id: familyId } });
      await prisma.user.deleteMany({ where: { id: { in: [parent, circle] } } });
    } finally {
      await module.close();
    }
  });

  async function event(type = 'FAMILY', recipient = parent, withChild = false) {
    const row = await prisma.event.create({
      data: {
        familyId,
        type,
        title: 'Private test title',
        notes: 'Never copy notes',
        createdBy: parent,
        startAt,
        allDay: false,
        localStartDate: new Date('2030-02-02'),
        timezone: 'Asia/Ho_Chi_Minh',
        inviteCircle: type === 'FAMILY' || type === 'CHILD',
      },
    });
    await prisma.eventReminderRule.create({
      data: {
        familyId,
        eventId: row.id,
        recipientUserId: recipient,
        offsetMinutes: 60,
      },
    });
    if (withChild)
      await prisma.eventChild.create({
        data: { familyId, eventId: row.id, childId },
      });
    return row;
  }
  function run(
    policy: JobPolicy,
    work: (context: JobContext) => Promise<Record<string, number>>,
    key = randomUUID(),
  ) {
    return runner.execute(
      policy,
      {
        familyId,
        scopeKey: key,
        scheduledFor: now,
        idempotencyKey: `reminder-test:${key}`,
      },
      work,
    );
  }
  const plan = (id?: string) =>
    run(JOBS.planEventReminders, (ctx) => service.plan(now, ctx, id));
  const dispatch = () =>
    run(JOBS.dispatchEventReminders, (ctx) => service.dispatch(startAt, ctx));

  it('plans idempotently across different durable runs and records attempts', async () => {
    const row = await event();
    await plan(row.id);
    await plan(row.id);
    const reminders = await prisma.eventReminder.findMany({
      where: { eventId: row.id },
    });
    expect(reminders).toHaveLength(1);
    expect(reminders[0]!.occurrenceAt).toEqual(startAt);
    expect(reminders[0]!.dueAt).toEqual(new Date(startAt.getTime() - 3600000));
    expect(
      await prisma.jobAttempt.count({ where: { jobRun: { familyId } } }),
    ).toBe(2);
  });

  it('plans a yearly lunar occurrence in the rolling horizon', async () => {
    const row = await event();
    await prisma.event.update({
      where: { id: row.id },
      data: {
        startAt: new Date('2025-01-29T02:00Z'),
        localStartDate: new Date('2025-01-29'),
        repeatYearly: true,
        isLunar: true,
        lunarMonth: 1,
        lunarDay: 1,
        lunarLeap: false,
      },
    });
    await run(JOBS.planEventReminders, (ctx) =>
      service.plan(new Date('2026-02-10'), ctx, row.id),
    );
    await run(JOBS.planEventReminders, (ctx) =>
      service.plan(new Date('2026-02-10'), ctx, row.id),
    );
    const reminders = await prisma.eventReminder.findMany({
      where: { eventId: row.id },
    });
    expect(reminders).toHaveLength(1);
    expect(reminders[0]!.occurrenceAt).toEqual(
      new Date('2026-02-17T02:00:00.000Z'),
    );
  });

  it('cancels old unsent instances after time change, replans, and cancels on delete', async () => {
    const row = await event();
    await plan(row.id);
    const moved = new Date(startAt.getTime() + 86400000);
    await prisma.event.update({
      where: { id: row.id },
      data: {
        startAt: moved,
        localStartDate: new Date('2030-02-03'),
        version: { increment: 1 },
      },
    });
    await plan(row.id);
    const instances = await prisma.eventReminder.findMany({
      where: { eventId: row.id },
      orderBy: { occurrenceAt: 'asc' },
    });
    expect(instances).toHaveLength(2);
    expect(instances[0]!.cancelledAt).not.toBeNull();
    expect(instances[1]!.cancelledAt).toBeNull();
    await prisma.event.update({
      where: { id: row.id },
      data: { deletedAt: now },
    });
    await plan(row.id);
    expect(
      await prisma.eventReminder.count({
        where: { eventId: row.id, cancelledAt: null },
      }),
    ).toBe(0);
  });

  it('dispatches once under concurrent runs and stores calendar link and safe params', async () => {
    const row = await event();
    await plan(row.id);
    await Promise.all([dispatch(), dispatch()]);
    await dispatch();
    const inbox = await prisma.notification.findMany({ where: { familyId } });
    expect(inbox).toHaveLength(1);
    expect(inbox[0]).toMatchObject({
      recipientUserId: parent,
      templateCode: 'NOTI_EVENT_REMINDER',
    });
    expect(inbox[0]!.payloadReference).toMatchObject({
      tab: 'FAMILY',
      deepLink: `babyfamily://calendar/events/${row.id}`,
      params: {
        eventId: row.id,
        eventType: 'FAMILY',
        occurrenceAt: startAt.toISOString(),
        offsetMinutes: 60,
      },
    });
    expect(JSON.stringify(inbox)).not.toContain('Never copy notes');
    expect(
      await prisma.eventReminder.count({
        where: { eventId: row.id, sentAt: { not: null } },
      }),
    ).toBe(1);
  });

  it.each(['COUPLE', 'NOTE', 'MEMORY_REMINDER'])(
    'never sends %s to Circle even if a legacy reminder exists',
    async (type) => {
      const row = await event(type, circle, true);
      await prisma.eventReminder.create({
        data: {
          familyId,
          eventId: row.id,
          recipientUserId: circle,
          offsetMinutes: 60,
          occurrenceAt: startAt,
          dueAt: now,
        },
      });
      await dispatch();
      expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
      expect(
        (
          await prisma.eventReminder.findFirstOrThrow({
            where: { eventId: row.id },
          })
        ).cancelledAt,
      ).not.toBeNull();
    },
  );

  it.each(['COUPLE', 'NOTE'])(
    'stores no title/content for sensitive %s reminders',
    async (type) => {
      const row = await event(type);
      await plan(row.id);
      await dispatch();
      const inbox = await prisma.notification.findFirstOrThrow({
        where: { familyId },
      });
      expect(inbox.sensitive).toBe(true);
      expect(inbox.payloadReference).toMatchObject({
        tab: type === 'COUPLE' ? 'US' : 'FAMILY',
      });
      expect(JSON.stringify(inbox.payloadReference)).not.toContain(
        'Private test title',
      );
      expect(JSON.stringify(inbox.payloadReference)).not.toContain(
        'Never copy notes',
      );
    },
  );

  it('requires a current child grant for Circle and rechecks revoked grants before sending', async () => {
    const denied = await event('FAMILY', circle);
    const allowed = await event('CHILD', circle, true);
    await plan();
    expect(
      await prisma.eventReminder.count({
        where: { eventId: allowed.id, cancelledAt: null },
      }),
    ).toBe(1);
    await prisma.circleGrant.updateMany({
      where: { familyId },
      data: { deletedAt: now },
    });
    try {
      await dispatch();
      expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
      expect(
        await prisma.eventReminder.count({
          where: { eventId: denied.id, cancelledAt: null },
        }),
      ).toBe(0);
    } finally {
      await prisma.circleGrant.updateMany({
        where: { familyId },
        data: { deletedAt: null },
      });
    }
  });

  it('refuses stale fencing leases without writing reminders or notifications', async () => {
    await event();
    const context: JobContext = {
      signal: new AbortController().signal,
      lease: new JobLease(randomUUID(), 1, 1n, 3, 'missing'),
    };
    await expect(service.plan(now, context)).rejects.toThrow(/lease/i);
    await expect(service.dispatch(startAt, context)).rejects.toThrow(/lease/i);
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
    expect(await prisma.eventReminder.count({ where: { familyId } })).toBe(0);
  });
});
