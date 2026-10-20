import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  MissionSettingsResponseDto,
  UpdateMissionFamilySettingsDto,
  UpdateMissionPreferencesDto,
} from '../../dto/mission/mission-config.dto';

export const MISSION_CONFIG_SERVICE = Symbol('MISSION_CONFIG_SERVICE');

/** CARE-12 mission settings (BF-20261019-003). */
export interface IMissionConfigService {
  /** Family board level + the caller's own preferences. */
  get(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<MissionSettingsResponseDto>;
  updateFamily(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateMissionFamilySettingsDto,
  ): Promise<MissionSettingsResponseDto>;
  updateMine(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateMissionPreferencesDto,
  ): Promise<MissionSettingsResponseDto>;
}
