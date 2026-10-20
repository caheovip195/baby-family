import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type {
  CreateMissionSeriesInput,
  IMissionRecurrenceRepository,
  MissionSeriesRow,
} from '../interfaces/repositories/mission-recurrence-repository.interface';
import {
  MissionRecurrenceModel,
  MissionSeriesModel,
} from '../models/mission-recurrence.model';

const withChildren = {
  missionSeriesChildren: { where: { deletedAt: null } },
} as const;

type Loaded = Prisma.MissionSeriesGetPayload<{ include: typeof withChildren }>;

function row(value: Loaded): MissionSeriesRow {
  return new MissionSeriesModel(
    value.id,
    value.familyId,
    value.ownerKind === 'TOGETHER' ? 'TOGETHER' : 'PARENT',
    value.ownerUserId,
    value.title,
    value.note,
    value.category,
    value.missionSeriesChildren.map((child) => child.childId),
    value.timeOfDay,
    value.startDate,
    value.endDate,
    value.rrule,
    MissionRecurrenceModel.pausedRanges(value.pausedRanges),
    value.status,
    value.timezone,
    value.version,
  );
}

@Injectable()
export class MissionRecurrenceRepository implements IMissionRecurrenceRepository {
  constructor(private readonly prisma: PrismaService) {}

  async familyContext(familyId: string) {
    const family = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
      select: { timezone: true },
    });
    if (!family) return null;
    const [children, pair] = await Promise.all([
      this.prisma.child.findMany({
        where: { familyId, deletedAt: null, status: 'ACTIVE' },
        select: { id: true },
      }),
      this.prisma.coupleSpace.findFirst({
        where: {
          familyId,
          deletedAt: null,
          status: 'ACTIVE',
          disabledAt: null,
        },
        select: { id: true },
      }),
    ]);
    return {
      timezone: family.timezone,
      childIds: children.map((child) => child.id),
      coupleActive: pair !== null,
    };
  }

  async create(input: CreateMissionSeriesInput): Promise<MissionSeriesRow> {
    return this.prisma.$transaction(async (tx) => {
      const series = await tx.missionSeries.create({
        data: {
          familyId: input.familyId,
          createdBy: input.createdBy,
          ownerKind: input.ownerKind,
          ownerUserId: input.ownerKind === 'PARENT' ? input.createdBy : null,
          title: input.title,
          note: input.note,
          category: input.category as never,
          targetScope: input.targetScope as never,
          // Custom series: 2 Hearts (BR-069, DB CHECK).
          hearts: 2,
          rrule: input.rrule,
          timeOfDay: input.timeOfDay,
          startDate: input.startDate,
          endDate: input.endDate,
          timezone: input.timezone,
        },
      });
      if (input.childIds.length)
        await tx.missionSeriesChild.createMany({
          data: input.childIds.map((childId) => ({
            seriesId: series.id,
            childId,
            familyId: input.familyId,
          })),
        });
      return row(
        await tx.missionSeries.findUniqueOrThrow({
          where: { id: series.id },
          include: withChildren,
        }),
      );
    });
  }

  async list(familyId: string): Promise<MissionSeriesRow[]> {
    const rows = await this.prisma.missionSeries.findMany({
      where: { familyId, deletedAt: null, status: { not: 'ENDED' } },
      include: withChildren,
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
    });
    return rows.map(row);
  }

  async find(id: string): Promise<MissionSeriesRow | null> {
    const value = await this.prisma.missionSeries.findFirst({
      where: { id, deletedAt: null },
      include: withChildren,
    });
    return value ? row(value) : null;
  }

  async pause(id: string, ranges: { from: string; to: string }[]) {
    await this.prisma.missionSeries.update({
      where: { id },
      data: {
        pausedRanges: ranges,
        version: { increment: 1 },
      },
    });
  }

  async end(id: string, fromDate: Date) {
    const now = new Date();
    await this.prisma.$transaction([
      this.prisma.mission.updateMany({
        where: { seriesId: id, boardDate: { gte: fromDate }, status: 'TODO' },
        data: {
          status: 'REMOVED',
          removedReason: 'SERIES_EDIT',
          removedAt: now,
          version: { increment: 1 },
        },
      }),
      this.prisma.missionSeries.update({
        where: { id },
        data: {
          status: 'ENDED',
          deletedAt: now,
          version: { increment: 1 },
        },
      }),
    ]);
  }
}
