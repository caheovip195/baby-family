import type {
  AdminCmsHelpdeskQueryDto,
  AdminCmsHelpdeskReplyDto,
  AdminCmsHelpdeskStatusDto,
} from '../../dto/admin-cms-helpdesk/admin-cms-helpdesk.dto';
import type { SupportHelpdeskDetail } from '../../dto/support-helpdesk/support-helpdesk.dto';
export const ADMIN_CMS_HELPDESK_SERVICE = Symbol('ADMIN_CMS_HELPDESK_SERVICE');
export interface AdminCmsTicketMetadata {
  id: string;
  requesterUserId: string | null;
  familyId: string | null;
  category: string;
  status: string;
  assignedAdminId: string | null;
  createdAt: string;
  updatedAt: string;
  closedAt: string | null;
}
export interface IAdminCmsHelpdeskService {
  list(
    adminId: string,
    query: AdminCmsHelpdeskQueryDto,
  ): Promise<{ items: AdminCmsTicketMetadata[]; nextOffset: number | null }>;
  detail(
    adminId: string,
    id: string,
    reasonCode: string,
  ): Promise<SupportHelpdeskDetail>;
  reply(
    adminId: string,
    id: string,
    input: AdminCmsHelpdeskReplyDto,
  ): Promise<{ id: string; sender: 'SUPPORT'; createdAt: string }>;
  status(
    adminId: string,
    id: string,
    input: AdminCmsHelpdeskStatusDto,
  ): Promise<AdminCmsTicketMetadata>;
}
