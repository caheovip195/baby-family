import type { Gender } from '../../common/database.enums';
import type { Child } from '../../models/child.model';
import type { Pregnancy } from '../../models/pregnancy.model';
export const BIRTH_CONVERSION_WORKFLOW_REPOSITORY = Symbol(
  'BIRTH_CONVERSION_WORKFLOW_REPOSITORY',
);
export interface BirthChildInput {
  name: string;
  nickname: string | null;
  gender: Gender;
  birthDate: Date;
  birthTime: Date | null;
  birthStats?: { weightGram?: number; lengthMm?: number };
}
export interface IBirthConversionWorkflowRepository {
  findPregnancy(id: string): Promise<Pregnancy | null>;
  convert(
    pregnancy: Pregnancy,
    key: string,
    userId: string,
    children: BirthChildInput[],
  ): Promise<Child[]>;
}
