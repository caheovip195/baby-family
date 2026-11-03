import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  MemoryResponseDto,
  MemoryFeedResponseDto,
} from '../../dto/memory/memory-response.dto';
import type {
  LibraryQueryDto,
  OriginalDownloadResponse,
} from '../../dto/memory-library/library-query.dto';
export const MEMORY_LIBRARY_SERVICE = Symbol('MEMORY_LIBRARY_SERVICE');
export interface IMemoryLibraryService {
  requireFamily(
    actor: AuthPrincipal,
    familyId: string,
    mode?: 'read' | 'download',
  ): Promise<{ isParent: boolean }>;
  read(
    actor: AuthPrincipal,
    id: string,
    mode?: 'read' | 'download',
  ): Promise<MemoryResponseDto>;
  favorite(actor: AuthPrincipal, id: string, enabled: boolean): Promise<void>;
  favorites(
    actor: AuthPrincipal,
    familyId: string,
    query: LibraryQueryDto,
  ): Promise<MemoryFeedResponseDto>;
  /** [perspectiveId]: bản gốc ảnh/video của góc nhìn (BF-20261030-009). */
  download(
    actor: AuthPrincipal,
    id: string,
    perspectiveId?: string,
  ): Promise<OriginalDownloadResponse>;
}
