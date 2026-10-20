import type { SupportHelpdeskView } from '../../models/support-helpdesk-view.model';
import type { SupportTicket } from '../../models/support-ticket.model';
import type { SupportTicketMessage } from '../../models/support-ticket-message.model';
export const SUPPORT_HELPDESK_REPOSITORY = Symbol(
  'SUPPORT_HELPDESK_REPOSITORY',
);
export interface ISupportHelpdeskRepository {
  create(input: {
    id: string;
    userId: string;
    familyId: string | null;
    category: string;
    messageEnc: Uint8Array;
    assetIds: string[];
  }): Promise<SupportTicket>;
  list(userId: string, offset: number, limit: number): Promise<SupportTicket[]>;
  detail(userId: string, id: string): Promise<SupportHelpdeskView | null>;
  message(
    userId: string,
    ticketId: string,
    id: string,
    bodyEnc: Uint8Array,
  ): Promise<SupportTicketMessage>;
}
