import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  BridgeNextStepInputDto,
  BridgeSessionDto,
  ClarifyBridgeDto,
  CreateBridgeDto,
} from '../../dto/us/bridge.dto';

export const BRIDGE_SERVICE = Symbol('BRIDGE_SERVICE');

export type BridgeAction =
  'join' | 'pause' | 'understood' | 'confirm' | 'close';

export interface IBridgeService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    idempotencyKey: string,
    input: CreateBridgeDto,
  ): Promise<BridgeSessionDto>;
  list(actor: AuthPrincipal, familyId: string): Promise<BridgeSessionDto[]>;
  get(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
  ): Promise<BridgeSessionDto>;
  act(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    action: BridgeAction,
  ): Promise<BridgeSessionDto>;
  clarify(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    input: ClarifyBridgeDto,
  ): Promise<BridgeSessionDto>;
  nextStep(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    input: BridgeNextStepInputDto,
  ): Promise<BridgeSessionDto>;
}
