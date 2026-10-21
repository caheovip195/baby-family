import { randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { MISSION_POLICY } from '../../src/config/mission-policy';
import { PrismaService } from '../../src/database/prisma.service';
import type { Prisma } from '../../src/generated/prisma/client';
import { MISSION_BOARD_REPOSITORY } from '../../src/interfaces/repositories/mission-board-repository.interface';
import type { IMissionBoardRepository } from '../../src/interfaces/repositories/mission-board-repository.interface';

/**
 * Checklist “catalog ≥ 90 days of content per stage”: the real generator lays
 * out 90 consecutive boards for families at different stages; no catalog
 * template may come back inside the strict repeat window (the window is only
 * relaxed when the catalog runs short).
 */
describe('Mission catalog: 90 days without breaking the repeat window', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let repository: IMissionBoardRepository;
  const DAYS = 90;
  const day = (offset: number) =>
    new Date(Date.UTC(2027, 0, 4) + offset * 86_400_000)
      .toISOString()
      .slice(0, 10);
  const families: string[] = [];
  const users: string[] = [];

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    const config = new ConfigService(validateEnvironment(process.env));
    const { AppModule } = await import('../../src/app.module.js');
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(ConfigService)
      .useValue(config)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    prisma = app.get(PrismaService);
    repository = app.get<IMissionBoardRepository>(MISSION_BOARD_REPOSITORY);
    const catalog = JSON.parse(
      await readFile(join(process.cwd(), 'prisma/seeds/missions.json'), 'utf8'),
    ) as { templates: Prisma.MissionTemplateCreateManyInput[] };
    // The fixture installs the published catalog explicitly (no db:seed).
    await prisma.missionTemplate.createMany({
      data: catalog.templates,
      skipDuplicates: true,
    });
  });

  afterAll(async () => {
    try {
      if (prisma && families.length) {
        const where = { familyId: { in: families } };
        await prisma.$transaction(async (tx) => {
          await tx.missionChild.deleteMany({ where });
          await tx.mission.deleteMany({ where });
          await tx.dailyMissionBoard.deleteMany({ where });
          await tx.child.deleteMany({ where });
          await tx.pregnancy.deleteMany({ where });
          await tx.coupleSpace.deleteMany({ where });
          await tx.familyParent.deleteMany({ where });
        });
        await prisma.family.updateMany({
          where: { id: { in: families } },
          data: { deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
      }
    } finally {
      await app?.close();
    }
  });

  async function family(stage: { ageDays?: number; pregWeek?: number }) {
    const familyId = randomUUID(),
      a = randomUUID(),
      b = randomUUID();
    families.push(familyId);
    users.push(a, b);
    await prisma.user.createMany({
      data: [a, b].map((id) => ({
        id,
        displayName: 'Synthetic catalog fixture',
        status: 'ACTIVE',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic catalog family',
        createdBy: a,
        status: 'ACTIVE',
        activatedAt: new Date('2026-01-01T00:00:00Z'),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    const pa = await prisma.familyParent.create({
      data: { familyId, userId: a, slot: 'A', kind: 'FATHER', callName: 'A' },
    });
    const pb = await prisma.familyParent.create({
      data: { familyId, userId: b, slot: 'B', kind: 'MOTHER', callName: 'B' },
    });
    await prisma.coupleSpace.create({
      data: {
        familyId,
        parentAUserId: a,
        parentBUserId: b,
        parentAMembershipId: pa.id,
        parentBMembershipId: pb.id,
      },
    });
    const start = new Date(`${day(0)}T00:00:00Z`).getTime();
    if (stage.ageDays !== undefined)
      await prisma.child.create({
        data: {
          familyId,
          nickname: 'Synthetic child',
          birthDate: new Date(start - stage.ageDays * 86_400_000),
          colorIndex: 1,
          createdBy: a,
        },
      });
    if (stage.pregWeek !== undefined)
      await prisma.pregnancy.create({
        data: {
          familyId,
          seqNo: 1,
          nickname: 'Synthetic pregnancy',
          status: 'ACTIVE',
          dueDate: new Date(
            start +
              (MISSION_POLICY.pregnancyDurationWeeks - stage.pregWeek) *
                7 *
                86_400_000,
          ),
          createdBy: b,
        },
      });
    return familyId;
  }

  it.each([
    ['newborn', { ageDays: 0 }],
    ['2–5 months', { ageDays: 60 }],
    ['3–4 months', { ageDays: 100 }],
    ['2 years', { ageDays: 730 }],
    ['late pregnancy', { pregWeek: 30 }],
    ['toddler', { ageDays: 500 }],
    ['preschooler', { ageDays: 1200 }],
    ['early pregnancy', { pregWeek: 6 }],
    ['mid pregnancy', { pregWeek: 18 }],
  ])('%s: no template repeats inside the window', async (_name, stage) => {
    const familyId = await family(stage);
    for (let offset = 0; offset < DAYS; offset++)
      expect(await repository.prepareBoard(familyId, day(offset))).toBe(true);
    const rows = await prisma.mission.findMany({
      where: { familyId, source: 'SYSTEM', templateId: { not: null } },
      select: {
        templateId: true,
        boardDate: true,
        ownerKind: true,
        missionTemplate: { select: { code: true, category: true } },
      },
      orderBy: { boardDate: 'asc' },
    });
    const days = new Set(rows.map((row) => row.boardDate.toISOString()));
    expect(days.size).toBe(DAYS);
    const first = rows.length ? rows[0]!.boardDate.getTime() / 86_400_000 : 0;
    const last = new Map<string, number>();
    const repeats: string[] = [];
    for (const row of rows) {
      const at = row.boardDate.getTime() / 86_400_000;
      const before = last.get(row.templateId!);
      if (before !== undefined && at - before < MISSION_POLICY.repeatWindowDays)
        repeats.push(
          `${row.missionTemplate?.code} (${row.missionTemplate?.category}, ${row.ownerKind}) after ${at - before} days on day ${at - first}`,
        );
      last.set(row.templateId!, at);
    }
    expect(repeats).toEqual([]);
  });
});
