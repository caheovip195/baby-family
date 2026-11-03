import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateHandoffDto,
  HandoffDto,
  HandoffListQueryDto,
} from '../../dto/us/handoff.dto';

export const HANDOFF_SERVICE = Symbol('HANDOFF_SERVICE');

export interface IHandoffService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    idempotencyKey: string,
    input: CreateHandoffDto,
  ): Promise<HandoffDto>;
  list(
    actor: AuthPrincipal,
    familyId: string,
    query: HandoffListQueryDto,
  ): Promise<HandoffDto[]>;
  acknowledge(
    actor: AuthPrincipal,
    familyId: string,
    handoffId: string,
  ): Promise<HandoffDto>;
}
