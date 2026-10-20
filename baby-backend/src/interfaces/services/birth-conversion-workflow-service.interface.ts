import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  BirthConversionDto,
  BirthConversionResponseDto,
} from '../../dto/pregnancy/birth-conversion.dto';
export const BIRTH_CONVERSION_WORKFLOW_SERVICE = Symbol(
  'BIRTH_CONVERSION_WORKFLOW_SERVICE',
);
export interface IBirthConversionWorkflowService {
  convert(
    actor: AuthPrincipal,
    pregnancyId: string,
    key: string,
    input: BirthConversionDto,
  ): Promise<BirthConversionResponseDto>;
}
