import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  Paginated,
  PaginationInput,
} from '../../common/pagination/pagination.types';
import type { LifecycleArchivePregnancyDto } from '../../dto/pregnancy/lifecycle-pregnancy.dto';
import type { PregnancyResponseDto } from '../../dto/pregnancy/pregnancy-response.dto';

export const PREGNANCY_LIFECYCLE_SERVICE = Symbol(
  'PREGNANCY_LIFECYCLE_SERVICE',
);

export interface IPregnancyLifecycleService {
  archive(
    actor: AuthPrincipal,
    id: string,
    input: LifecycleArchivePregnancyDto,
  ): Promise<PregnancyResponseDto>;
  restore(actor: AuthPrincipal, id: string): Promise<PregnancyResponseDto>;
  listArchived(
    actor: AuthPrincipal,
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<PregnancyResponseDto>>;
}
