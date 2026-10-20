import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateCheckinDto,
  CheckinHistoryQueryDto,
  CreateCheckinResponseDto,
  CheckinViewDto,
  CheckinTodayDto,
  CheckinHistoryDto,
  CheckinResponseDto,
} from '../../dto/us/checkin.dto';
export const COUPLE_CHECKIN_SERVICE = Symbol('COUPLE_CHECKIN_SERVICE');
export interface ICoupleCheckinService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateCheckinDto,
  ): Promise<CheckinViewDto>;
  today(actor: AuthPrincipal, familyId: string): Promise<CheckinTodayDto>;
  history(
    actor: AuthPrincipal,
    familyId: string,
    query: CheckinHistoryQueryDto,
  ): Promise<CheckinHistoryDto>;
  respond(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: CreateCheckinResponseDto,
  ): Promise<CheckinResponseDto>;
  deleteHistory(actor: AuthPrincipal, familyId: string): Promise<void>;
}
