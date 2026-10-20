import type { Album } from '../../models/album.model';
export const ALBUM_COLLECTION_REPOSITORY = Symbol(
  'ALBUM_COLLECTION_REPOSITORY',
);
export interface IAlbumCollectionRepository {
  list(familyId: string): Promise<Album[]>;
  find(id: string): Promise<Album | null>;
  create(familyId: string, ownerUserId: string, name: string): Promise<Album>;
  update(
    id: string,
    familyId: string,
    input: { name?: string; coverMemoryId?: string | null },
  ): Promise<Album | null>;
  remove(id: string, familyId: string): Promise<void>;
  memoryIds(id: string, familyId: string): Promise<string[]>;
  addMemories(
    id: string,
    familyId: string,
    userId: string,
    memoryIds: string[],
  ): Promise<void>;
  removeMemory(id: string, familyId: string, memoryId: string): Promise<void>;
}
