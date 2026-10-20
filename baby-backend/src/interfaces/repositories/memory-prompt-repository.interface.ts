import type { Child } from '../../models/child.model';
import type { Pregnancy } from '../../models/pregnancy.model';
import type { MemoryPromptTemplate } from '../../models/memory-prompt-template.model';
import type { MemoryPromptDelivery } from '../../models/memory-prompt-delivery.model';
import type { MemoryPromptSubjectDto } from '../../dto/memory-library/memory-prompt.dto';
export const MEMORY_PROMPT_REPOSITORY = Symbol('MEMORY_PROMPT_REPOSITORY');
export interface IMemoryPromptRepository {
  findSubject(
    familyId: string | null,
    input: MemoryPromptSubjectDto,
  ): Promise<Child | Pregnancy | null>;
  isEnabled(userId: string): Promise<boolean>;
  deliver(input: {
    familyId: string;
    userId: string;
    localDate: Date;
    childId: string | null;
    pregnancyId: string | null;
    ageDays: number | null;
    pregnancyWeek: number | null;
    recentSince: Date;
  }): Promise<{
    template: MemoryPromptTemplate;
    delivery: MemoryPromptDelivery;
  } | null>;
  dismiss(input: {
    familyId: string;
    userId: string;
    code: string;
    childId: string | null;
    pregnancyId: string | null;
    localDate: Date;
  }): Promise<boolean>;
}
