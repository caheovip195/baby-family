import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IAlbumCollectionRepository } from '../interfaces/repositories/album-collection-repository.interface';
import { Album } from '../models/album.model';
import { DomainError, NotFoundError } from '../common/errors/domain.error';

@Injectable()
export class AlbumCollectionRepository implements IAlbumCollectionRepository {
  constructor(private readonly prisma: PrismaService) {}
  async list(familyId: string): Promise<Album[]> {
    return (
      await this.prisma.album.findMany({
        where: { familyId, deletedAt: null },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      })
    ).map((row) => new Album(row));
  }
  async find(id: string): Promise<Album | null> {
    const row = await this.prisma.album.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Album(row) : null;
  }
  async create(
    familyId: string,
    ownerUserId: string,
    name: string,
  ): Promise<Album> {
    return new Album(
      await this.prisma.album.create({ data: { familyId, ownerUserId, name } }),
    );
  }
  async update(
    id: string,
    familyId: string,
    input: { name?: string; coverMemoryId?: string | null },
  ): Promise<Album | null> {
    return this.prisma.$transaction(async (tx) => {
      const albums = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM app.albums WHERE id = ${id}::uuid AND family_id = ${familyId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      if (!albums.length) return null;
      // Revalidate after the album lock: a concurrent remove may have committed
      // after service validation but before this transaction acquired the lock.
      if (input.coverMemoryId) {
        const member = await tx.albumMemory.findFirst({
          where: {
            albumId: id,
            familyId,
            memoryId: input.coverMemoryId,
            deletedAt: null,
          },
          select: { memoryId: true },
        });
        if (!member)
          throw new DomainError(
            'The cover must be an active memory in this album.',
            'ALBUM_COVER_INVALID',
            422,
          );
      }
      const changed = await tx.album.updateMany({
        where: { id, familyId, deletedAt: null },
        data: input,
      });
      if (!changed.count) return null;
      return new Album(await tx.album.findUniqueOrThrow({ where: { id } }));
    });
  }
  async remove(id: string, familyId: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const now = new Date();
      await tx.album.updateMany({
        where: { id, familyId, deletedAt: null },
        data: { deletedAt: now },
      });
      await tx.albumMemory.updateMany({
        where: { albumId: id, familyId, deletedAt: null },
        data: { deletedAt: now },
      });
    });
  }
  async memoryIds(id: string, familyId: string): Promise<string[]> {
    return (
      await this.prisma.albumMemory.findMany({
        where: { albumId: id, familyId, deletedAt: null },
        orderBy: [{ addedAt: 'desc' }, { memoryId: 'desc' }],
        select: { memoryId: true },
      })
    ).map((row) => row.memoryId);
  }
  async addMemories(
    id: string,
    familyId: string,
    userId: string,
    memoryIds: string[],
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      // Serialize membership changes with album soft deletion/cover updates.
      const albums = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM app.albums WHERE id = ${id}::uuid AND family_id = ${familyId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      if (!albums.length) throw new NotFoundError('Album was not found.');
      for (const memoryId of memoryIds)
        await tx.albumMemory.upsert({
          where: { albumId_memoryId: { albumId: id, memoryId } },
          create: { albumId: id, memoryId, familyId, addedBy: userId },
          update: { deletedAt: null, addedBy: userId },
        });
    });
  }
  async removeMemory(
    id: string,
    familyId: string,
    memoryId: string,
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      // Always lock, even when the memory is not currently the cover. Otherwise
      // a concurrent cover assignment could race the link removal.
      const albums = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM app.albums WHERE id = ${id}::uuid AND family_id = ${familyId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      if (!albums.length) throw new NotFoundError('Album was not found.');
      await tx.album.updateMany({
        where: { id, familyId, deletedAt: null, coverMemoryId: memoryId },
        data: { coverMemoryId: null },
      });
      await tx.albumMemory.updateMany({
        where: { albumId: id, familyId, memoryId, deletedAt: null },
        data: { deletedAt: new Date() },
      });
    });
  }
}
