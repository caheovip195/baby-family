import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateSupportHelpdeskDto,
  SupportHelpdeskQueryDto,
  SupportHelpdeskReceipt,
  SupportHelpdeskDetail,
  SupportHelpdeskMessageDto,
} from '../../dto/support-helpdesk/support-helpdesk.dto';
export const SUPPORT_HELPDESK_SERVICE = Symbol('SUPPORT_HELPDESK_SERVICE');
export interface ISupportHelpdeskService {
  catalog(): { version: number; categories: readonly string[] };
  create(
    actor: AuthPrincipal,
    input: CreateSupportHelpdeskDto,
  ): Promise<SupportHelpdeskReceipt>;
  list(
    actor: AuthPrincipal,
    query: SupportHelpdeskQueryDto,
  ): Promise<{ items: SupportHelpdeskReceipt[]; nextOffset: number | null }>;
  detail(actor: AuthPrincipal, id: string): Promise<SupportHelpdeskDetail>;
  message(
    actor: AuthPrincipal,
    id: string,
    input: SupportHelpdeskMessageDto,
  ): Promise<{ id: string; createdAt: string }>;
}
