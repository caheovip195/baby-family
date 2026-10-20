import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreatePregnancyPrepDto,
  UpdatePregnancyPrepDto,
  PregnancyPrepItemDto,
  PregnancyPrepGroupDto,
} from '../../dto/pregnancy/prep.dto';
export const PREGNANCY_PREP_SERVICE = Symbol('PREGNANCY_PREP_SERVICE');
export interface IPregnancyPrepService {
  list(
    actor: AuthPrincipal,
    pregnancyId: string,
  ): Promise<PregnancyPrepGroupDto[]>;
  create(
    actor: AuthPrincipal,
    pregnancyId: string,
    input: CreatePregnancyPrepDto,
  ): Promise<PregnancyPrepItemDto>;
  update(
    actor: AuthPrincipal,
    id: string,
    input: UpdatePregnancyPrepDto,
  ): Promise<PregnancyPrepItemDto>;
  remove(actor: AuthPrincipal, id: string): Promise<void>;
}
