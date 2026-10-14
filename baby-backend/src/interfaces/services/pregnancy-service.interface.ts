import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { CreatePregnancyDto } from '../../dto/pregnancy/create-pregnancy.dto';
import type { UpdatePregnancyDto } from '../../dto/pregnancy/update-pregnancy.dto';
import type { PregnancyResponseDto } from '../../dto/pregnancy/pregnancy-response.dto';
import type {
  Paginated,
  PaginationInput,
} from '../../common/pagination/pagination.types';

export const PREGNANCY_SERVICE = Symbol('PREGNANCY_SERVICE');
export interface IPregnancyService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreatePregnancyDto,
  ): Promise<PregnancyResponseDto>;
  list(
    actor: AuthPrincipal,
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<PregnancyResponseDto>>;
  getById(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<PregnancyResponseDto>;
  update(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: UpdatePregnancyDto,
  ): Promise<PregnancyResponseDto>;
}
