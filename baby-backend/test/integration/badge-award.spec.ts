import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../src/database/prisma.service';
import { validateEnvironment } from '../../src/config/environment';
import { JOBS } from '../../src/config/jobs';
import { BADGE_AWARD_REPOSITORY } from '../../src/interfaces/repositories/badge-award-repository.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { BadgeAwardRepository } from '../../src/repositories/badge-award.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { BadgeAwardService } from '../../src/services/badge-award.service';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { CareProgressRepository } from '../../src/repositories/care-progress.repository';

describe('Badge awards (PostgreSQL)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let service: BadgeAwardService;
  let runner: JobRunnerService;
  const familyId = randomUUID();
  const [parentA, parentB, circle] = [randomUUID(), randomUUID(), randomUUID()];
  const teamCode = `TEST_TEAM_${randomUUID().slice(0, 8)}`;
  const privateCode = `TEST_HEART_${randomUUID().slice(0, 8)}`;
  let eventId: string;
  const now = new Date();
  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
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
          eventType: 'mission.changed',
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
  it('awards only once, emits outbox, notifies parents and keeps Hearts private', async () => {
    const run = (suffix: string) =>
      runner.execute(
        JOBS.awardBadges,
        {
          scopeKey: `${familyId}:${suffix}`,
          scheduledFor: now,
          idempotencyKey: `badge-test:${familyId}:${suffix}`,
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
});
