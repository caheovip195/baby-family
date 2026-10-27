import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CareStatsQueryDto,
  CareStatsResponseDto,
} from '../../dto/care/care-stats.dto';

export const CARE_STATS_SERVICE = Symbol('CARE_STATS_SERVICE');

export interface ICareStatsService {
  get(
    actor: AuthPrincipal,
    familyId: string,
    query: CareStatsQueryDto,
  ): Promise<CareStatsResponseDto>;
}
