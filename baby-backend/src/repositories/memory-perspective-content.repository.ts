import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import { NotFoundError } from '../common/errors/domain.error';
import type {
  IMemoryPerspectiveContentRepository,
  SavePerspectiveContent,
} from '../interfaces/repositories/memory-perspective-content-repository.interface';
import { MemoryPerspective } from '../models/memory-perspective.model';
import { Asset } from '../models/asset.model';
import { parentSharedAssetSql } from './parent-asset-visibility.sql';

@Injectable()
export class MemoryPerspectiveContentRepository implements IMemoryPerspectiveContentRepository {
  constructor(private readonly prisma: PrismaService) {}
  async list(memoryId: string, familyId: string, includeHidden: boolean) {
    const rows = await this.prisma.memoryPerspective.findMany({
      where: {
        memoryId,
        familyId,
        deletedAt: null,
        status: 'ACTIVE',
        ...(includeHidden ? {} : { hiddenFromCircle: false }),
        memory: { deletedAt: null, status: 'PUBLISHED' },
      },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
    });
    return rows.map((row) => new MemoryPerspective(row));
  }
  async findOwn(memoryId: string, authorUserId: string) {
    const row = await this.prisma.memoryPerspective.findUnique({
      where: { memoryId_authorUserId: { memoryId, authorUserId } },
    });
    return row && row.deletedAt === null && row.status === 'ACTIVE'
      ? new MemoryPerspective(row)
      : null;
  }
  async findAudio(id: string, familyId: string, actorUserId: string) {
    const visible = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT a.id FROM app.assets a
      WHERE a.id = ${id}::uuid AND a.family_id = ${familyId}::uuid
        AND a.deleted_at IS NULL AND a.purpose = 'MEMORY'
        AND a.private_owner_user_id IS NULL
        AND (a.uploader_user_id = ${actorUserId}::uuid
             OR ${parentSharedAssetSql(actorUserId)})`;
    if (!visible.length) return null;
    const row = await this.prisma.asset.findFirst({
      where: { id, familyId, deletedAt: null },
    });
    return row ? new Asset(row) : null;
  }
  async findMedia(assetIds: string[], familyId: string, actorUserId: string) {
    if (!assetIds.length) return [];
    const visible = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT a.id::text AS id FROM app.assets a
      WHERE a.id = ANY(${assetIds}::uuid[]) AND a.family_id = ${familyId}::uuid
        AND a.deleted_at IS NULL AND a.purpose = 'MEMORY'
        AND a.private_owner_user_id IS NULL
        AND (a.uploader_user_id = ${actorUserId}::uuid
             OR ${parentSharedAssetSql(actorUserId)})`;
    const ids = visible.map((row) => row.id);
    const rows = await this.prisma.asset.findMany({
      where: { id: { in: ids }, familyId, deletedAt: null },
    });
    return rows.map((row) => new Asset(row));
  }
  async assetIds(perspectiveIds: string[]) {
    const rows = perspectiveIds.length
      ? await this.prisma.memoryPerspectiveAsset.findMany({
          where: { perspectiveId: { in: perspectiveIds }, deletedAt: null },
          orderBy: [{ perspectiveId: 'asc' }, { sortOrder: 'asc' }],
          select: { perspectiveId: true, assetId: true },
        })
      : [];
    const map = new Map<string, string[]>();
    for (const row of rows)
      map.set(row.perspectiveId, [
        ...(map.get(row.perspectiveId) ?? []),
        row.assetId,
      ]);
    return map;
  }
  save(command: SavePerspectiveContent) {
    const { assetIds, ...fields } = command;
    return this.prisma.$transaction(async (tx) => {
      await this.lock(tx, command.memoryId, command.familyId);
      const row = await tx.memoryPerspective.upsert({
        where: {
          memoryId_authorUserId: {
            memoryId: command.memoryId,
            authorUserId: command.authorUserId,
          },
        },
        create: fields,
        update: {
          body: command.body,
          audioAssetId: command.audioAssetId,
          hiddenFromCircle: command.hiddenFromCircle,
          status: 'ACTIVE',
          deletedAt: null,
          trashedAt: null,
          version: { increment: 1 },
        },
      });
      if (assetIds !== undefined) {
        // Thay cả bộ: bỏ ảnh không còn chọn, khôi phục / thêm ảnh theo thứ tự.
        const now = new Date();
        await tx.memoryPerspectiveAsset.updateMany({
          where: {
            perspectiveId: row.id,
            deletedAt: null,
            assetId: { notIn: assetIds },
          },
          data: { deletedAt: now },
        });
        for (const [index, assetId] of assetIds.entries())
          await tx.memoryPerspectiveAsset.upsert({
            where: {
              perspectiveId_assetId: { perspectiveId: row.id, assetId },
            },
            create: {
              perspectiveId: row.id,
              assetId,
              familyId: command.familyId,
              sortOrder: index,
            },
            update: { sortOrder: index, deletedAt: null },
          });
      }
      await this.changed(tx, command.memoryId, command.familyId, row.id);
      return new MemoryPerspective(row);
    });
  }
  async remove(memoryId: string, familyId: string, authorUserId: string) {
    await this.prisma.$transaction(async (tx) => {
      await this.lock(tx, memoryId, familyId);
      const own = await tx.memoryPerspective.findUnique({
        where: { memoryId_authorUserId: { memoryId, authorUserId } },
      });
      if (!own || own.deletedAt || own.status !== 'ACTIVE') return;
      await tx.memoryPerspective.update({
        where: { id: own.id },
        data: {
          deletedAt: new Date(),
          trashedAt: new Date(),
          status: 'TRASHED',
          version: { increment: 1 },
        },
      });
      await this.changed(tx, memoryId, familyId, own.id);
    });
  }
  private async lock(
    tx: Prisma.TransactionClient,
    memoryId: string,
    familyId: string,
  ) {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM app.memories WHERE id = ${memoryId}::uuid AND family_id = ${familyId}::uuid AND deleted_at IS NULL AND status = 'PUBLISHED' FOR UPDATE`;
    if (!rows.length) throw new NotFoundError('Memory was not found.');
  }
  private async changed(
    tx: Prisma.TransactionClient,
    memoryId: string,
    familyId: string,
    perspectiveId: string,
  ) {
    const count = await tx.memoryPerspective.count({
      where: { memoryId, familyId, status: 'ACTIVE', deletedAt: null },
    });
    await tx.memory.update({
      where: { id: memoryId },
      data: { perspectiveCount: count, version: { increment: 1 } },
    });
    await tx.outboxEvent.create({
      data: {
        eventType: 'memory.perspective.changed',
        aggregateId: memoryId,
        familyId,
        payload: { memoryId, perspectiveId },
      },
    });
  }
}
