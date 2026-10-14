import type { Pregnancy } from '../../models/pregnancy.model';

export const PREGNANCY_COMMAND_REPOSITORY = Symbol(
  'PREGNANCY_COMMAND_REPOSITORY',
);
export interface CreateNextPregnancyInput {
  nickname: string;
  dueDate: Date | null;
  expectedCount: number;
  createdBy: string;
}
export interface IPregnancyCommandRepository {
  /** Allocate a never-reused family sequence and create atomically. */
  createNext(
    familyId: string,
    input: CreateNextPregnancyInput,
  ): Promise<Pregnancy>;
}
