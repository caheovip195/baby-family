import type { Family } from '../../models/family.model';
import type { UpdateFamilySettingsDto } from '../../dto/family/family-settings.dto';

export const FAMILY_SETTINGS_REPOSITORY = Symbol('FAMILY_SETTINGS_REPOSITORY');
export interface FamilySettingsContext {
  family: Family;
  role: 'PARENT' | 'CIRCLE' | 'INACTIVE';
}
export interface IFamilySettingsRepository {
  findContext(
    familyId: string,
    userId: string,
  ): Promise<FamilySettingsContext | null>;
  /** Atomically merge supplied keys and enqueue the event; recheck current Parent membership. */
  merge(
    familyId: string,
    userId: string,
    input: UpdateFamilySettingsDto,
  ): Promise<Family | null>;
}
