import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  ApproveMemoryDto,
  RejectMemoryDto,
} from '../../dto/memory-review/memory-review.dto';
import type { MemoryResponseDto } from '../../dto/memory/memory-response.dto';
export const MEMORY_REVIEW_SERVICE = Symbol('MEMORY_REVIEW_SERVICE');
export interface IMemoryReviewService {
  pending(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<{ data: MemoryResponseDto[] }>;
  approve(
    actor: AuthPrincipal,
    id: string,
    input: ApproveMemoryDto,
  ): Promise<MemoryResponseDto>;
  reject(
    actor: AuthPrincipal,
    id: string,
    input: RejectMemoryDto,
  ): Promise<{ id: string; status: string }>;
}
