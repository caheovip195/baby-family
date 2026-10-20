import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  AddAlbumMemoriesDto,
  AlbumCollectionResponseDto,
  AlbumMemoriesQueryDto,
  CreateAlbumDto,
  UpdateAlbumDto,
} from '../dto/album/album-collection.dto';
import type { MemoryResponseDto } from '../dto/memory/memory-response.dto';
import { ALBUM_COLLECTION_REPOSITORY } from '../interfaces/repositories/album-collection-repository.interface';
import type { IAlbumCollectionRepository } from '../interfaces/repositories/album-collection-repository.interface';
import type { IAlbumCollectionService } from '../interfaces/services/album-collection-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEMORY_LIBRARY_SERVICE } from '../interfaces/services/memory-library-service.interface';
import type { IMemoryLibraryService } from '../interfaces/services/memory-library-service.interface';
import type { Album } from '../models/album.model';

@Injectable()
export class AlbumCollectionService implements IAlbumCollectionService {
  constructor(
    @Inject(ALBUM_COLLECTION_REPOSITORY)
    private readonly repository: IAlbumCollectionRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_LIBRARY_SERVICE)
    private readonly library: IMemoryLibraryService,
  ) {}
  async list(actor: AuthPrincipal, familyId: string) {
    const viewer = await this.library.requireFamily(actor, familyId);
    const albums = (await this.repository.list(familyId)).filter(
      (album) => viewer.isParent || !album.isSensitive,
    );
    return {
      items: await Promise.all(
        albums.map((album) => this.project(actor, album)),
      ),
    };
  }
  async create(actor: AuthPrincipal, familyId: string, input: CreateAlbumDto) {
    await this.access.requireParent(actor, familyId, 'write');
    return this.project(
      actor,
      await this.repository.create(familyId, actor.userId, input.name),
    );
  }
  async update(actor: AuthPrincipal, id: string, input: UpdateAlbumDto) {
    const album = await this.editable(actor, id);
    if (input.name === undefined && input.coverMemoryId === undefined)
      throw new ValidationError('An album update must contain a field.');
    if (input.coverMemoryId) {
      const memory = await this.library.read(actor, input.coverMemoryId);
      if (
        memory.familyId !== album.familyId ||
        !(await this.repository.memoryIds(id, album.familyId)).includes(
          input.coverMemoryId,
        )
      )
        throw new DomainError(
          'The cover must be a visible memory in this album.',
          'ALBUM_COVER_INVALID',
          422,
        );
    }
    const changed = await this.repository.update(id, album.familyId, input);
    if (!changed) throw new NotFoundError('Album was not found.');
    return this.project(actor, changed);
  }
  async remove(actor: AuthPrincipal, id: string) {
    const album = await this.editable(actor, id);
    await this.repository.remove(id, album.familyId);
  }
  async memories(
    actor: AuthPrincipal,
    id: string,
    query: AlbumMemoriesQueryDto,
  ) {
    const album = await this.visibleAlbum(actor, id);
    const ids = await this.repository.memoryIds(id, album.familyId);
    const offset = query.cursor ? ids.indexOf(query.cursor) : -1;
    if (query.cursor && offset < 0)
      throw new ValidationError('Invalid album cursor.');
    const limit = query.limit ?? 20;
    const data: MemoryResponseDto[] = [];
    for (const memoryId of ids.slice(offset + 1)) {
      const memory = await this.visibleMemory(actor, album, memoryId);
      if (memory) data.push(memory);
      if (data.length > limit) break;
    }
    return {
      data: data.slice(0, limit),
      nextCursor: data.length > limit ? data[limit - 1]!.id : null,
    };
  }
  async addMemories(
    actor: AuthPrincipal,
    id: string,
    input: AddAlbumMemoriesDto,
  ) {
    const album = await this.editable(actor, id);
    for (const memoryId of input.memoryIds) {
      const memory = await this.library.read(actor, memoryId);
      if (memory.familyId !== album.familyId)
        throw new DomainError(
          'The memory belongs to another family.',
          'ALBUM_MEMORY_INVALID',
          422,
        );
    }
    await this.repository.addMemories(
      id,
      album.familyId,
      actor.userId,
      input.memoryIds,
    );
  }
  async removeMemory(actor: AuthPrincipal, id: string, memoryId: string) {
    const album = await this.editable(actor, id);
    await this.repository.removeMemory(id, album.familyId, memoryId);
  }
  private async visibleAlbum(actor: AuthPrincipal, id: string): Promise<Album> {
    const album = await this.repository.find(id);
    if (!album) throw new NotFoundError('Album was not found.');
    const viewer = await this.library.requireFamily(actor, album.familyId);
    if (!viewer.isParent && album.isSensitive)
      throw new NotFoundError('Album was not found.');
    return album;
  }
  private async editable(actor: AuthPrincipal, id: string): Promise<Album> {
    const album = await this.visibleAlbum(actor, id);
    const viewer = await this.library.requireFamily(actor, album.familyId);
    if (viewer.isParent)
      await this.access.requireParent(actor, album.familyId, 'write');
    else if (album.ownerUserId !== actor.userId)
      throw new DomainError(
        'Only the album owner or a Parent can edit it.',
        'ALBUM_EDIT_FORBIDDEN',
        403,
      );
    return album;
  }
  private async visibleMemory(
    actor: AuthPrincipal,
    album: Album,
    memoryId: string,
  ): Promise<MemoryResponseDto | null> {
    try {
      const memory = await this.library.read(actor, memoryId);
      return memory.familyId === album.familyId ? memory : null;
    } catch (error) {
      if (error instanceof DomainError && error.statusCode === 404) return null;
      throw error;
    }
  }
  private async project(
    actor: AuthPrincipal,
    album: Album,
  ): Promise<AlbumCollectionResponseDto> {
    // Visibility is delegated to the same reader as favorites/downloads. Counts,
    // explicit cover and fallback cover all use that identical per-viewer filter.
    let memoryCount = 0;
    let cover: MemoryResponseDto | null = null;
    let first: MemoryResponseDto | null = null;
    for (const memoryId of await this.repository.memoryIds(
      album.id,
      album.familyId,
    )) {
      const memory = await this.visibleMemory(actor, album, memoryId);
      if (!memory) continue;
      memoryCount++;
      first ??= memory;
      if (memoryId === album.coverMemoryId) cover = memory;
    }
    cover ??= first;
    return {
      id: album.id,
      familyId: album.familyId,
      ownerUserId: album.ownerUserId,
      name: album.name,
      isSensitive: album.isSensitive,
      coverMemoryId: cover?.id ?? null,
      cover,
      memoryCount,
      createdAt: album.createdAt.toISOString(),
    };
  }
}
