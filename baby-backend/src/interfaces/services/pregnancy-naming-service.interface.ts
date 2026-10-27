import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreatePregnancyNameDto,
  PregnancyNameItemDto,
  PregnancyNamesDto,
} from '../../dto/pregnancy/naming.dto';

export const PREGNANCY_NAMING_SERVICE = Symbol('PREGNANCY_NAMING_SERVICE');

export interface IPregnancyNamingService {
  list(actor: AuthPrincipal, pregnancyId: string): Promise<PregnancyNamesDto>;
  create(
    actor: AuthPrincipal,
    pregnancyId: string,
    input: CreatePregnancyNameDto,
  ): Promise<PregnancyNameItemDto>;
  like(
    actor: AuthPrincipal,
    nameId: string,
    liked: boolean,
  ): Promise<PregnancyNameItemDto>;
  choose(
    actor: AuthPrincipal,
    nameId: string,
    chosen: boolean,
  ): Promise<PregnancyNameItemDto>;
  remove(actor: AuthPrincipal, nameId: string): Promise<void>;
}
