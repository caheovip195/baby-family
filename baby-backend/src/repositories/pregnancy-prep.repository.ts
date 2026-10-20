import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type { IPregnancyPrepRepository } from '../interfaces/repositories/pregnancy-prep-repository.interface';
import type {
  CreatePregnancyPrepDto,
  UpdatePregnancyPrepDto,
} from '../dto/pregnancy/prep.dto';
import { Pregnancy } from '../models/pregnancy.model';
import { PrepItem } from '../models/prep-item.model';

@Injectable()
export class PregnancyPrepRepository implements IPregnancyPrepRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findPregnancy(id: string): Promise<Pregnancy | null> {
    const row = await this.prisma.pregnancy.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Pregnancy(row) : null;
  }
  async findItem(id: string): Promise<PrepItem | null> {
    const row = await this.prisma.prepItem.findFirst({
      where: { id, deletedAt: null, pregnancy: { deletedAt: null } },
    });
    return row ? new PrepItem(row) : null;
  }
  listAndSeed(
    pregnancy: Pregnancy,
    actorUserId: string,
  ): Promise<PrepItem[] | null> {
    return this.prisma.$transaction(async (tx) => {
      if (!(await this.lock(tx, pregnancy.id, pregnancy.familyId, actorUserId)))
        return null;
      // Include tombstones: removing every item must not restore the default checklist.
      const count = await tx.prepItem.count({
        where: { pregnancyId: pregnancy.id, familyId: pregnancy.familyId },
      });
      if (!count) {
        const defaults = await tx.contentItem.findMany({
          where: {
            type: 'PREP_DEFAULT',
            locale: 'vi',
            status: 'ACTIVE',
            deletedAt: null,
          },
          orderBy: [{ sortOrder: 'asc' }, { code: 'asc' }],
        });
        const items = defaults.flatMap((row) => {
          const value = row.data;
          if (!value || typeof value !== 'object' || Array.isArray(value))
            return [];
          const { groupCode, title, sortOrder } = value;
          if (
            typeof groupCode !== 'string' ||
            !/^[A-Z][A-Z0-9_]{0,19}$/.test(groupCode) ||
            typeof title !== 'string' ||
            !title.trim() ||
            title.length > 120 ||
            typeof sortOrder !== 'number' ||
            !Number.isInteger(sortOrder) ||
            sortOrder < 0 ||
            sortOrder > 2147483647
          )
            return [];
          return [
            {
              pregnancyId: pregnancy.id,
              familyId: pregnancy.familyId,
              groupCode,
              title: title.trim(),
              sortOrder,
            },
          ];
        });
        if (items.length) {
          await tx.prepItem.createMany({ data: items });
          await this.event(
            tx,
            pregnancy.familyId,
            pregnancy.id,
            actorUserId,
            'seed',
          );
        }
      }
      return (
        await tx.prepItem.findMany({
          where: {
            pregnancyId: pregnancy.id,
            familyId: pregnancy.familyId,
            deletedAt: null,
          },
          orderBy: [{ groupCode: 'asc' }, { sortOrder: 'asc' }, { id: 'asc' }],
        })
      ).map((row) => new PrepItem(row));
    });
  }
  create(
    pregnancy: Pregnancy,
    actorUserId: string,
    input: CreatePregnancyPrepDto,
  ): Promise<PrepItem | null> {
    return this.prisma.$transaction(async (tx) => {
      if (!(await this.lock(tx, pregnancy.id, pregnancy.familyId, actorUserId)))
        return null;
      const last = await tx.prepItem.aggregate({
        where: {
          pregnancyId: pregnancy.id,
          familyId: pregnancy.familyId,
          groupCode: input.groupCode,
          deletedAt: null,
        },
        _max: { sortOrder: true },
      });
      const row = await tx.prepItem.create({
        data: {
          ...input,
          familyId: pregnancy.familyId,
          pregnancyId: pregnancy.id,
          sortOrder: Math.min((last._max.sortOrder ?? -1) + 1, 2147483647),
        },
      });
      await this.event(
        tx,
        pregnancy.familyId,
        pregnancy.id,
        actorUserId,
        'create',
        row.id,
      );
      return new PrepItem(row);
    });
  }
  update(
    item: PrepItem,
    actorUserId: string,
    input: UpdatePregnancyPrepDto,
  ): Promise<PrepItem | null> {
    return this.prisma.$transaction(async (tx) => {
      if (!(await this.lock(tx, item.pregnancyId, item.familyId, actorUserId)))
        return null;
      const result = await tx.prepItem.updateMany({
        where: {
          id: item.id,
          familyId: item.familyId,
          pregnancyId: item.pregnancyId,
          deletedAt: null,
        },
        data: {
          title: input.title,
          sortOrder: input.sortOrder,
          ...(input.done === undefined
            ? {}
            : {
                doneAt: input.done ? new Date() : null,
                doneBy: input.done ? actorUserId : null,
              }),
        },
      });
      if (!result.count) return null;
      await this.event(
        tx,
        item.familyId,
        item.pregnancyId,
        actorUserId,
        'update',
        item.id,
      );
      return new PrepItem(
        await tx.prepItem.findUniqueOrThrow({ where: { id: item.id } }),
      );
    });
  }
  remove(item: PrepItem, actorUserId: string): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      if (!(await this.lock(tx, item.pregnancyId, item.familyId, actorUserId)))
        return false;
      const result = await tx.prepItem.updateMany({
        where: {
          id: item.id,
          familyId: item.familyId,
          pregnancyId: item.pregnancyId,
          deletedAt: null,
        },
        data: { deletedAt: new Date() },
      });
      if (!result.count) return false;
      await this.event(
        tx,
        item.familyId,
        item.pregnancyId,
        actorUserId,
        'delete',
        item.id,
      );
      return true;
    });
  }
  private async lock(
    tx: Prisma.TransactionClient,
    pregnancyId: string,
    familyId: string,
    userId: string,
  ): Promise<boolean> {
    const rows = await tx.$queryRaw<{ id: string }[]>(Prisma.sql`
      SELECT p.id FROM app.pregnancies p
      WHERE p.id = ${pregnancyId}::uuid AND p.family_id = ${familyId}::uuid AND p.deleted_at IS NULL
        AND EXISTS (SELECT 1 FROM app.family_parents fp JOIN app.users u ON u.id = fp.user_id
          WHERE fp.family_id = p.family_id AND fp.user_id = ${userId}::uuid
            AND fp.status = 'ACTIVE' AND fp.deleted_at IS NULL AND fp.left_at IS NULL AND fp.joined_at <= now()
            AND u.status = 'ACTIVE' AND u.deleted_at IS NULL)
      FOR UPDATE OF p
    `);
    return rows.length > 0;
  }
  private async event(
    tx: Prisma.TransactionClient,
    familyId: string,
    pregnancyId: string,
    actorUserId: string,
    action: string,
    itemId?: string,
  ): Promise<void> {
    await tx.outboxEvent.create({
      data: {
        eventType: 'pregnancy.prep.changed',
        familyId,
        aggregateId: pregnancyId,
        payload: {
          version: 1,
          pregnancyId,
          actorUserId,
          action,
          ...(itemId ? { itemId } : {}),
        },
      },
    });
  }
}
