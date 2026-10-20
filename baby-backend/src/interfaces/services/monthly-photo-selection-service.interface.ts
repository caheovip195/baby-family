import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  SetMonthlyPhotoDto,
  MonthlyPhotoSelectionDto,
} from '../../dto/monthly-photo/monthly-photo-selection.dto';
export const MONTHLY_PHOTO_SELECTION_SERVICE = Symbol(
  'MONTHLY_PHOTO_SELECTION_SERVICE',
);
export interface IMonthlyPhotoSelectionService {
  list(
    actor: AuthPrincipal,
    childId: string,
  ): Promise<MonthlyPhotoSelectionDto[]>;
  set(
    actor: AuthPrincipal,
    childId: string,
    monthIndex: number,
    input: SetMonthlyPhotoDto,
  ): Promise<MonthlyPhotoSelectionDto>;
}
