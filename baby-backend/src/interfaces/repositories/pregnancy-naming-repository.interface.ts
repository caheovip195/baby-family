import type { Pregnancy } from '../../models/pregnancy.model';
import type { PregnancyNamingState } from '../../models/pregnancy-naming-state.model';
import type { CreateMemoryCommand } from './memory-content-repository.interface';

export const PREGNANCY_NAMING_REPOSITORY = Symbol(
  'PREGNANCY_NAMING_REPOSITORY',
);

export type PregnancyNamingMutation =
  | {
      type: 'create';
      id: string;
      nameEnc: Uint8Array;
      meaningEnc: Uint8Array | null;
      nameKey: string;
    }
  | { type: 'like'; id: string; liked: boolean }
  | {
      type: 'choose';
      id: string;
      chosen: boolean;
      memory: CreateMemoryCommand | null;
    }
  | { type: 'remove'; id: string; memory: CreateMemoryCommand | null }
  | { type: 'noop' };

export interface IPregnancyNamingRepository {
  findPregnancy(id: string): Promise<Pregnancy | null>;
  findPregnancyId(nameId: string): Promise<string | null>;
  read(pregnancyId: string, actorUserId: string): Promise<PregnancyNamingState>;
  /** Serialize by family → pregnancy → couple; callback contains business rules only.
   * Apply name/vote and memory/milestone/outbox changes in the same transaction.
   */
  mutate(
    pregnancyId: string,
    actorUserId: string,
    decide: (state: PregnancyNamingState) => PregnancyNamingMutation,
  ): Promise<PregnancyNamingState>;
}
