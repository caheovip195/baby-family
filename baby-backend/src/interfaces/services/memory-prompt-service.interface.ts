import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  MemoryPromptResponseDto,
  MemoryPromptSubjectDto,
} from '../../dto/memory-library/memory-prompt.dto';
export const MEMORY_PROMPT_SERVICE = Symbol('MEMORY_PROMPT_SERVICE');
export interface IMemoryPromptService {
  list(
    actor: AuthPrincipal,
    familyId: string,
    input: MemoryPromptSubjectDto,
  ): Promise<MemoryPromptResponseDto>;
  dismiss(
    actor: AuthPrincipal,
    code: string,
    input: MemoryPromptSubjectDto,
  ): Promise<{ dismissed: true }>;
}
