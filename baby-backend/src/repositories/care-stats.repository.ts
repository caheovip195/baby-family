import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type { ICareStatsRepository } from '../interfaces/repositories/care-stats-repository.interface';
import {
  CareStatsCategoryCount,
  CareStatsSnapshot,
} from '../models/care-stats-snapshot.model';

@Injectable()
export class CareStatsRepository implements ICareStatsRepository {
  constructor(private readonly prisma: PrismaService) {}

  readWeek(
    familyId: string,
    weekStart: Date,
    weekEndExclusive: Date,
    childId?: string,
  ): Promise<CareStatsSnapshot | null> {
    return this.prisma.$transaction(
      async (tx) => {
        if (
          childId &&
          !(await tx.child.findFirst({
            where: {
              id: childId,
              familyId,
              deletedAt: null,
              status: { not: 'DELETED' },
            },
            select: { id: true },
          }))
        )
          return null;

        const boardDate = { gte: weekStart, lt: weekEndExclusive };
        const [categories, boards] = await Promise.all([
          tx.mission.groupBy({
            by: ['category'],
            where: {
              familyId,
              boardDate,
              status: 'DONE',
              deletedAt: null,
              category: { not: 'COUPLE' },
              targetScope: { not: 'COUPLE' },
              missionCompletionsMissionCompletionsMissionIdFamilyIdTomissions: {
                some: { familyId, undoneAt: null, deletedAt: null },
              },
              ...(childId
                ? {
                    missionChildren: {
                      some: {
                        familyId,
                        childId,
                        deletedAt: null,
                        child: {
                          familyId,
                          deletedAt: null,
                          status: { not: 'DELETED' },
                        },
                      },
                    },
                  }
                : {}),
            },
            _count: { _all: true },
          }),
          tx.dailyMissionBoard.findMany({
            where: {
              familyId,
              boardDate,
              bloomedAt: { not: null },
              deletedAt: null,
            },
            select: { boardDate: true },
          }),
        ]);

        return new CareStatsSnapshot(
          categories.map(
            (row) => new CareStatsCategoryCount(row.category, row._count._all),
          ),
          boards.map((row) => row.boardDate),
        );
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }
}
