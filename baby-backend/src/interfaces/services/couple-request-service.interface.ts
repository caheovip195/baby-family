import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { CoupleRequestAction } from '../../config/couple-request-policy';
import type {
  CreateRequestDto,
  CreateRequestResponseDto,
  RequestAcknowledgeDto,
  RequestDeclineDto,
  RequestListQueryDto,
  RequestListResponseDto,
  RequestReminderDto,
  RequestViewDto,
} from '../../dto/us/request.dto';
export const COUPLE_REQUEST_SERVICE = Symbol('COUPLE_REQUEST_SERVICE');
export type RequestActionInput =
  RequestDeclineDto | RequestAcknowledgeDto | RequestReminderDto;
export interface ICoupleRequestService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateRequestDto,
    idempotencyKey: string,
  ): Promise<CreateRequestResponseDto>;
  list(
    actor: AuthPrincipal,
    familyId: string,
    query: RequestListQueryDto,
  ): Promise<RequestListResponseDto>;
  find(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<RequestViewDto>;
  act(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    action: CoupleRequestAction,
    input?: RequestActionInput,
  ): Promise<RequestViewDto>;
}
