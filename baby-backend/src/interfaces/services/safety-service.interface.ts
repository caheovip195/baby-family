import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  BlockListResponseDto,
  CreateBlockDto,
  CreateReportDto,
  ReportResponseDto,
} from '../../dto/safety/safety.dto';

export const SAFETY_SERVICE = Symbol('SAFETY_SERVICE');
export interface ISafetyService {
  report(
    actor: AuthPrincipal,
    input: CreateReportDto,
  ): Promise<ReportResponseDto>;
  block(actor: AuthPrincipal, input: CreateBlockDto): Promise<void>;
  unblock(
    actor: AuthPrincipal,
    familyId: string,
    userId: string,
  ): Promise<void>;
  blocks(actor: AuthPrincipal, familyId: string): Promise<BlockListResponseDto>;
}
