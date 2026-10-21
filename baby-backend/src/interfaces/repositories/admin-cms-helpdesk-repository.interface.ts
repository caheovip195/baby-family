import type { SupportTicket } from '../../models/support-ticket.model';
import type { SupportTicketMessage } from '../../models/support-ticket-message.model';
export const ADMIN_CMS_HELPDESK_REPOSITORY = Symbol(
  'ADMIN_CMS_HELPDESK_REPOSITORY',
);
export interface AdminCmsTicketAudit {
  adminId: string;
  reasonCode: string;
}
export interface IAdminCmsHelpdeskRepository {
  list(
    adminId: string,
    offset: number,
    limit: number,
    status?: string,
  ): Promise<SupportTicket[]>;
  readForContent(
    adminId: string,
    id: string,
    reasonCode: string,
  ): Promise<SupportTicket>;
  reply(
    audit: AdminCmsTicketAudit,
    ticketId: string,
    messageId: string,
    bodyEnc: Uint8Array,
  ): Promise<SupportTicketMessage>;
  status(
    audit: AdminCmsTicketAudit,
    ticketId: string,
    status: string,
  ): Promise<SupportTicket>;
}
