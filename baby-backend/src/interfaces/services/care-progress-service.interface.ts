import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  HeartsMeQueryDto,
  HeartsMeResponseDto,
} from '../../dto/care/hearts-me.dto';
import type { FamilyTreeResponseDto } from '../../dto/care/family-tree.dto';
import type { CareBadgesResponseDto } from '../../dto/care/care-badge.dto';
import type {
  CareMissionHistoryQueryDto,
  CareMissionHistoryResponseDto,
} from '../../dto/care/care-mission-history.dto';

export const CARE_PROGRESS_SERVICE = Symbol('CARE_PROGRESS_SERVICE');

export interface ICareProgressService {
  getHeartsMe(
    actor: AuthPrincipal,
    familyId: string,
    query: HeartsMeQueryDto,
  ): Promise<HeartsMeResponseDto>;

  getFamilyTree(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyTreeResponseDto>;

  getBadges(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<CareBadgesResponseDto>;

  getMissionHistory(
    actor: AuthPrincipal,
    familyId: string,
    query: CareMissionHistoryQueryDto,
  ): Promise<CareMissionHistoryResponseDto>;
}
