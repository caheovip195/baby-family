import { IsOptional, IsUUID } from 'class-validator';
import type { MemoryKind } from '../../common/database.enums';
import type { DatabaseJsonValue } from '../../common/database.types';

export class MemoryPromptSubjectDto {
  @IsOptional()
  @IsUUID()
  childId?: string;

  @IsOptional()
  @IsUUID()
  pregnancyId?: string;
}
export interface MemoryPromptResponseDto {
  items: {
    code: string;
    deliveryId: string;
    targetKind: MemoryKind;
    textI18n: DatabaseJsonValue;
    childId: string | null;
    pregnancyId: string | null;
  }[];
}
