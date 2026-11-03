import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type {
  GrowthValues,
  IGrowthRepository,
} from '../interfaces/repositories/growth-repository.interface';
import { GrowthChild, GrowthEntry } from '../models/growth.model';

type Row = {
  id: string;
  measuredOn: Date;
  weightGrams: number | null;
  heightMm: number | null;
  note: string | null;
  createdBy: string;
  updatedAt: Date;
};

const toEntry = (row: Row) =>
  new GrowthEntry(
    row.id,
    row.measuredOn.toISOString().slice(0, 10),
    row.weightGrams,
    row.heightMm,
    row.note,
    row.createdBy,
    row.updatedAt,
  );

/** CHD-06 (BF-20261028-004): CRUD lần đo theo bé + ngày. */
@Injectable()
export class GrowthRepository implements IGrowthRepository {
  constructor(private readonly prisma: PrismaService) {}

  async child(childId: string): Promise<GrowthChild | null> {
    const row = await this.prisma.child.findFirst({
      where: { id: childId, deletedAt: null, status: { not: 'DELETED' } },
      select: { id: true, familyId: true, birthDate: true },
    });
    return row ? new GrowthChild(row.id, row.familyId, row.birthDate) : null;
  }

  async list(childId: string, limit: number): Promise<GrowthEntry[]> {
    const rows = await this.prisma.growthMeasurement.findMany({
      where: { childId, deletedAt: null },
      orderBy: { measuredOn: 'asc' },
      take: limit,
    });
    return rows.map(toEntry);
  }

  upsert(
    child: GrowthChild,
    measuredOn: string,
    values: GrowthValues,
    userId: string,
  ): Promise<GrowthEntry> {
    const day = new Date(`${measuredOn}T00:00:00.000Z`);
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.growthMeasurement.findFirst({
        where: { childId: child.id, measuredOn: day, deletedAt: null },
        select: { id: true },
      });
      const row = existing
        ? await tx.growthMeasurement.update({
            where: { id: existing.id },
            data: values,
          })
        : await tx.growthMeasurement.create({
            data: {
              ...values,
              familyId: child.familyId,
              childId: child.id,
              measuredOn: day,
              createdBy: userId,
            },
          });
      return toEntry(row);
    });
  }

  async remove(childId: string, measuredOn: string): Promise<boolean> {
    const result = await this.prisma.growthMeasurement.updateMany({
      where: {
        childId,
        measuredOn: new Date(`${measuredOn}T00:00:00.000Z`),
        deletedAt: null,
      },
      data: { deletedAt: new Date() },
    });
    return result.count > 0;
  }
}
