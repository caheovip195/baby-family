import type { SupportTicket } from './support-ticket.model';
import type { SupportTicketMessage } from './support-ticket-message.model';
export class SupportHelpdeskView {
  constructor(
    readonly ticket: SupportTicket,
    readonly attachmentAssetIds: string[],
    readonly messages: SupportTicketMessage[],
  ) {}
}
