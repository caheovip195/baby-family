import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { SaveMissionMomentDto } from '../../dto/mission/mission-moment.dto';
import type { MemoryResponseDto } from '../../dto/memory/memory-response.dto';

export const MISSION_MOMENT_SERVICE = Symbol('MISSION_MOMENT_SERVICE');

export interface IMissionMomentService {
  /** CARE-06: a DONE mission (mine or TOGETHER) becomes a family moment. */
  save(
    actor: AuthPrincipal,
    missionId: string,
    idempotencyKey: string,
    input: SaveMissionMomentDto,
  ): Promise<MemoryResponseDto>;
}
