import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  JourneyQueryDto,
  JourneyMemoriesQueryDto,
} from '../../dto/pregnancy/journey-query.dto';
import type {
  JourneyResponseDto,
  JourneyMemoriesResponseDto,
} from '../../dto/pregnancy/journey-response.dto';
export const PREGNANCY_JOURNEY_SERVICE = Symbol('PREGNANCY_JOURNEY_SERVICE');
export interface IPregnancyJourneyService {
  journey(
    actor: AuthPrincipal,
    id: string,
    query: JourneyQueryDto,
    language?: string,
  ): Promise<JourneyResponseDto>;
  memories(
    actor: AuthPrincipal,
    id: string,
    query: JourneyMemoriesQueryDto,
  ): Promise<JourneyMemoriesResponseDto>;
}
