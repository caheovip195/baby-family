import { MEMORY_HEART_AWARD_SERVICE } from '../../src/interfaces/services/memory-heart-award-service.interface';
import { MEMORY_HEART_AWARD_REPOSITORY } from '../../src/interfaces/repositories/memory-heart-award-repository.interface';
import { MemoryHeartAwardService } from '../../src/services/memory-heart-award.service';
import { MemoryHeartAwardRepository } from '../../src/repositories/memory-heart-award.repository';
import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import {
  JOBS,
  OUTBOX_ROUTES,
  OUTBOX_ADDITIONAL_ROUTES,
  OUTBOX_NO_CONSUMER,
} from '../../src/config/jobs';
import { OUTBOX_RELAY_REPOSITORY } from '../../src/interfaces/repositories/outbox-relay-repository.interface';
import { JOB_QUEUE_SERVICE } from '../../src/interfaces/services/job-queue-service.interface';
import { OutboxRelayService } from '../../src/services/outbox-relay.service';
import { OutboxRelayRepository } from '../../src/repositories/outbox-relay.repository';
import { OutboxDelivery } from '../../src/models/outbox-delivery.model';
import { BADGE_AWARD_REPOSITORY } from '../../src/interfaces/repositories/badge-award-repository.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { BadgeAwardRepository } from '../../src/repositories/badge-award.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { BadgeAwardService } from '../../src/services/badge-award.service';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { CareProgressRepository } from '../../src/repositories/care-progress.repository';

describe('Outbox badge fan-out (PostgreSQL)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let service: BadgeAwardService;
  let runner: JobRunnerService;
  const familyId = randomUUID();
  const [parentA, parentB, circle] = [randomUUID(), randomUUID(), randomUUID()];
  const teamCode = `OUTBOX_TEAM_${randomUUID().slice(0, 8)}`;
  const privateCode = `OUTBOX_HEART_${randomUUID().slice(0, 8)}`;
  let eventId: string;
  const now = new Date();
  const enqueue = jest
    .fn<Promise<void>, unknown[]>()
    .mockResolvedValue(undefined);
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires *_test database.');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService(validateEnvironment(process.env)),
        },
        { provide: BADGE_AWARD_REPOSITORY, useClass: BadgeAwardRepository },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        OutboxRelayRepository,
        {
          provide: OUTBOX_RELAY_REPOSITORY,
          inject: [PrismaService, OutboxRelayRepository],
          // Limit delivery to this spec's family; real repository persists fencing.
          useFactory: (db: PrismaService, repo: OutboxRelayRepository) => ({
            claim: async (types: string[]) =>
              (
                await db.outboxEvent.findMany({
                  where: {
                    familyId,
                    eventType: { in: types },
                    publishedAt: null,
                    deletedAt: null,
                  },
                  orderBy: { id: 'asc' },
                })
              ).map(
                (r) =>
                  new OutboxDelivery(
                    r.id,
                    r.eventId,
                    r.eventType,
                    r.aggregateId,
                    r.familyId,
                    r.attempts,
                    r.fencingToken,
                  ),
              ),
            markPublished: repo.markPublished.bind(repo),
            markFailed: repo.markFailed.bind(repo),
          }),
        },
        { provide: JOB_QUEUE_SERVICE, useValue: { enqueue } },
        OutboxRelayService,
        {
          provide: MEMORY_HEART_AWARD_REPOSITORY,
          useClass: MemoryHeartAwardRepository,
        },
        {
          provide: MEMORY_HEART_AWARD_SERVICE,
          useClass: MemoryHeartAwardService,
        },
        BadgeAwardService,
        JobRunnerService,
      ],
    }).compile();
    await module.init();
    prisma = module.get(PrismaService);
    service = module.get(BadgeAwardService);
    runner = module.get(JobRunnerService);
    await prisma.user.createMany({
      data: [parentA, parentB, circle].map((id) => ({
        id,
        displayName: 'Badge fixture',
        status: 'ACTIVE',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Badge fixture',
        createdBy: parentA,
        status: 'ACTIVE',
      },
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parentA,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: parentB,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'CAREGIVER',
        displayName: 'Circle',
        status: 'ACTIVE',
        invitedBy: parentA,
      },
    });
    await prisma.badge.createMany({
      data: [
        {
          code: teamCode,
          titleI18n: { vi: 'Test' },
          descI18n: {},
          icon: 'star',
          scope: 'FAMILY',
          rule: { metric: 'TOGETHER_MISSIONS', target: 1 },
        },
        {
          code: privateCode,
          titleI18n: { vi: 'Private' },
          descI18n: {},
          icon: 'heart',
          scope: 'USER',
          rule: { metric: 'HEARTS_TOTAL', target: 1 },
        },
      ],
    });
    await prisma.mission.create({
      data: {
        familyId,
        title: 'Together fixture',
        source: 'CUSTOM',
        targetScope: 'FAMILY',
        hearts: 2,
        completedAt: now,
        completedBy: parentA,
        ownerKind: 'TOGETHER',
        category: 'TOGETHER',
        status: 'DONE',
        boardDate: now,
        createdBy: parentA,
      },
    });
    await prisma.heartLedger.create({
      data: {
        familyId,
        userId: parentA,
        sourceType: 'MISSION',
        sourceId: randomUUID(),
        reason: 'CUSTOM_COMPLETED',
        amount: 1,
        localDate: now,
      },
    });
    eventId = (
      await prisma.outboxEvent.create({
        data: {
          familyId,
          aggregateId: familyId,
          eventType: 'us.request.done',
          payload: { familyId },
        },
      })
    ).eventId;
  });
  afterAll(async () => {
    if (prisma) {
      const deletedAt = new Date();
      await prisma.badge.updateMany({
        where: { code: { in: [teamCode, privateCode] } },
        data: { status: 'INACTIVE', deletedAt },
      });
      await prisma.family.updateMany({
        where: { id: familyId },
        data: { deletedAt },
      });
      await prisma.user.updateMany({
        where: { id: { in: [parentA, parentB, circle] } },
        data: { deletedAt },
      });
    }
    await module?.close();
  });
  it('retries partial fan-out before marking published and preserves queue IDs', async () => {
    const relay = module.get(OutboxRelayService);
    enqueue
      .mockResolvedValueOnce(undefined)
      .mockRejectedValueOnce(new Error('queue unavailable'));
    await relay.relayBatch();
    expect(
      (await prisma.outboxEvent.findFirstOrThrow({ where: { eventId } }))
        .publishedAt,
    ).toBeNull();
    enqueue.mockClear();
    await relay.relayBatch();
    expect(enqueue.mock.calls.map((c) => c[1])).toEqual([
      `evt-${eventId}`,
      `evt-${eventId}-${JOBS.awardBadges.name}`,
    ]);
    expect(
      (await prisma.outboxEvent.findFirstOrThrow({ where: { eventId } }))
        .publishedAt,
    ).not.toBeNull();
  });
  it('acknowledges audit events without queueing and retains unknown types', async () => {
    await prisma.outboxEvent.createMany({
      data: ['memory.original.downloaded', 'future.unknown'].map(
        (eventType) => ({
          familyId,
          aggregateId: familyId,
          eventType,
          payload: {},
        }),
      ),
    });
    enqueue.mockClear();
    await module.get(OutboxRelayService).relayBatch();
    expect(enqueue).not.toHaveBeenCalled();
    const rows = await prisma.outboxEvent.findMany({
      where: {
        familyId,
        eventType: { in: ['memory.original.downloaded', 'future.unknown'] },
      },
    });
    expect(
      rows.find((r) => r.eventType === 'memory.original.downloaded')
        ?.publishedAt,
    ).not.toBeNull();
    expect(
      rows.find((r) => r.eventType === 'future.unknown')?.publishedAt,
    ).toBeNull();
    for (const key of Object.keys(OUTBOX_NO_CONSUMER)) {
      expect(Object.hasOwn(OUTBOX_ROUTES, key)).toBe(false);
      expect(Object.hasOwn(OUTBOX_ADDITIONAL_ROUTES, key)).toBe(false);
    }
  });
  it('awards only once, emits outbox, notifies parents and keeps Hearts private', async () => {
    const run = (suffix: string) =>
      runner.execute(
        JOBS.awardBadges,
        {
          scopeKey: `${familyId}:${suffix}`,
          scheduledFor: now,
          idempotencyKey: `outbox-consumer-test:${familyId}:${suffix}`,
          familyId,
        },
        (ctx) => service.award(now, ctx, eventId),
      );
    expect(await run('one')).toBe('SUCCEEDED');
    expect(await run('one')).toBe('ALREADY_FINISHED');
    expect(await run('two')).toBe('SUCCEEDED');
    expect(
      await prisma.familyBadge.count({
        where: { familyId, badgeCode: { in: [teamCode, privateCode] } },
      }),
    ).toBe(2);
    expect(
      await prisma.outboxEvent.count({
        where: { familyId, eventType: 'badge.earned' },
      }),
    ).toBe(2);
    const rows = await prisma.notification.findMany({
      where: { familyId, templateCode: 'NOTI_BADGE_EARNED' },
    });
    expect(rows).toHaveLength(3);
    expect(rows.some((n) => n.recipientUserId === circle)).toBe(false);
    const privateRows = rows.filter(
      (n) =>
        (n.payloadReference as { params: { badgeCode: string } }).params
          .badgeCode === privateCode,
    );
    expect(privateRows.map((n) => n.recipientUserId)).toEqual([parentA]);
    const visible = await new CareProgressRepository(prisma).getBadges(
      familyId,
    );
    expect(visible.find((b) => b.code === teamCode)).toMatchObject({
      achieved: true,
      achievedAt: now,
    });
    expect(visible.some((b) => b.code === privateCode)).toBe(false);
  });
  it('awards content once, shares memory/perspective quota and enforces the daily cap', async () => {
    const createdAt = new Date('2026-10-21T04:00:00Z');
    const localDate = new Date('2026-10-21T00:00:00Z');
    const ids: string[] = [];
    const hearts = module.get<MemoryHeartAwardService>(
      MEMORY_HEART_AWARD_SERVICE,
    );
    const run = async (id: string, suffix: string) =>
      runner.execute(
        JOBS.awardBadges,
        {
          familyId,
          scopeKey: `${familyId}:${suffix}`,
          scheduledFor: now,
          idempotencyKey: `hearts:${familyId}:${suffix}`,
        },
        async (context) => ({ changed: await hearts.award(id, context) }),
      );
    for (let i = 0; i < 6; i++) {
      const memory = await prisma.memory.create({
        data: {
          familyId,
          authorUserId: parentB,
          authorRole: 'PARENT',
          body: 'Fixture',
          kind: 'MOMENT',
          status: 'PUBLISHED',
          visibility: 'PARENTS',
          occurredAt: createdAt,
          occurredLocalDate: localDate,
          createdAt,
        },
      });
      ids.push(memory.id);
      const event = await prisma.outboxEvent.create({
        data: {
          familyId,
          aggregateId: memory.id,
          eventType: 'memory.published',
          payload: {},
        },
      });
      expect(await run(event.eventId, `${i}`)).toBe('SUCCEEDED');
      expect(await run(event.eventId, `${i}-duplicate`)).toBe('SUCCEEDED');
    }
    expect(
      await prisma.heartLedger.count({
        where: { familyId, userId: parentB, sourceType: 'MEMORY' },
      }),
    ).toBe(5);
    const counter = await prisma.heartDailyCounter.findUniqueOrThrow({
      where: { userId_localDate: { userId: parentB, localDate } },
    });
    expect(counter).toMatchObject({ total: 10, memoryCount: 5 });
    const perspective = await prisma.memoryPerspective.create({
      data: {
        memoryId: ids[0]!,
        familyId,
        authorUserId: parentB,
        body: 'Fixture',
        createdAt,
      },
    });
    const event = await prisma.outboxEvent.create({
      data: {
        familyId,
        aggregateId: ids[0],
        eventType: 'memory.perspective.changed',
        payload: { perspectiveId: perspective.id },
      },
    });
    await run(event.eventId, 'perspective-cap');
    expect(
      await prisma.heartLedger.count({
        where: { familyId, userId: parentB, sourceType: 'PERSPECTIVE' },
      }),
    ).toBe(0);
    await prisma.heartDailyCounter.create({
      data: { familyId, userId: parentA, localDate, total: 74 },
    });
    const own = await prisma.memoryPerspective.create({
      data: {
        memoryId: ids[0]!,
        familyId,
        authorUserId: parentA,
        body: 'Fixture',
        createdAt,
      },
    });
    const ownEvent = await prisma.outboxEvent.create({
      data: {
        familyId,
        aggregateId: ids[0],
        eventType: 'memory.perspective.changed',
        payload: { perspectiveId: own.id },
      },
    });
    await run(ownEvent.eventId, 'perspective-partial');
    await run(ownEvent.eventId, 'perspective-retry');
    expect(
      await prisma.heartLedger.findFirst({
        where: { familyId, sourceId: own.id },
      }),
    ).toMatchObject({ amount: 1, userId: parentA });
    expect(
      await prisma.heartDailyCounter.findUniqueOrThrow({
        where: { userId_localDate: { userId: parentA, localDate } },
      }),
    ).toMatchObject({ total: 75, memoryCount: 1 });
    expect(
      await prisma.familyTree.findUniqueOrThrow({ where: { familyId } }),
    ).toMatchObject({ totalHearts: 11 });
  });
});
