import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  AddAlbumMemoriesDto,
  AlbumCollectionResponseDto,
  AlbumMemoriesQueryDto,
  CreateAlbumDto,
  UpdateAlbumDto,
} from '../../dto/album/album-collection.dto';
import type { MemoryFeedResponseDto } from '../../dto/memory/memory-response.dto';
export const ALBUM_COLLECTION_SERVICE = Symbol('ALBUM_COLLECTION_SERVICE');
export interface IAlbumCollectionService {
  list(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<{ items: AlbumCollectionResponseDto[] }>;
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateAlbumDto,
  ): Promise<AlbumCollectionResponseDto>;
  update(
    actor: AuthPrincipal,
    id: string,
    input: UpdateAlbumDto,
  ): Promise<AlbumCollectionResponseDto>;
  remove(actor: AuthPrincipal, id: string): Promise<void>;
  memories(
    actor: AuthPrincipal,
    id: string,
    query: AlbumMemoriesQueryDto,
  ): Promise<MemoryFeedResponseDto>;
  addMemories(
    actor: AuthPrincipal,
    id: string,
    input: AddAlbumMemoriesDto,
  ): Promise<void>;
  removeMemory(
    actor: AuthPrincipal,
    id: string,
    memoryId: string,
  ): Promise<void>;
}
