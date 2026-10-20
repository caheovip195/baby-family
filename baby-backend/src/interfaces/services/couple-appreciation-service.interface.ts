import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateAppreciationDto,
  AppreciationListQueryDto,
  ReactAppreciationDto,
  ShareRespondAppreciationDto,
  AppreciationViewDto,
  AppreciationWallDto,
} from '../../dto/us/appreciation.dto';

export const COUPLE_APPRECIATION_SERVICE = Symbol(
  'COUPLE_APPRECIATION_SERVICE',
);

export interface ICoupleAppreciationService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateAppreciationDto,
  ): Promise<AppreciationViewDto>;
  list(
    actor: AuthPrincipal,
    familyId: string,
    query: AppreciationListQueryDto,
  ): Promise<AppreciationWallDto>;
  react(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: ReactAppreciationDto,
  ): Promise<AppreciationViewDto>;
  requestShare(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<AppreciationViewDto>;
  respondShare(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: ShareRespondAppreciationDto,
  ): Promise<AppreciationViewDto>;
  delete(actor: AuthPrincipal, familyId: string, id: string): Promise<void>;
}
