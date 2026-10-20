import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateMissionSeriesDto,
  MissionSeriesResponseDto,
  PauseMissionSeriesDto,
} from '../../dto/mission/mission-recurrence.dto';

export const MISSION_RECURRENCE_SERVICE = Symbol('MISSION_RECURRENCE_SERVICE');

/** Custom repeating missions (BF-20261019-003). */
export interface IMissionRecurrenceService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateMissionSeriesDto,
  ): Promise<MissionSeriesResponseDto>;
  /** Mine and TOGETHER series; the partner's own series are not listed. */
  list(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<{ items: MissionSeriesResponseDto[] }>;
  pause(
    actor: AuthPrincipal,
    seriesId: string,
    input: PauseMissionSeriesDto,
  ): Promise<MissionSeriesResponseDto>;
  end(actor: AuthPrincipal, seriesId: string): Promise<void>;
}
