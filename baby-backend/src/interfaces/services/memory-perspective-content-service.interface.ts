import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  PerspectiveContentResponseDto,
  PutPerspectiveContentDto,
} from '../../dto/memory-library/perspective-content.dto';
export const MEMORY_PERSPECTIVE_CONTENT_SERVICE = Symbol(
  'MEMORY_PERSPECTIVE_CONTENT_SERVICE',
);
export interface IMemoryPerspectiveContentService {
  list(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<{ items: PerspectiveContentResponseDto[] }>;
  put(
    actor: AuthPrincipal,
    memoryId: string,
    input: PutPerspectiveContentDto,
  ): Promise<PerspectiveContentResponseDto>;
  remove(actor: AuthPrincipal, memoryId: string): Promise<void>;
}
