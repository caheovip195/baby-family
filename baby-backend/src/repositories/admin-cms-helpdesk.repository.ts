import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import type {
  IAdminCmsHelpdeskRepository,
  AdminCmsTicketAudit,
} from '../interfaces/repositories/admin-cms-helpdesk-repository.interface';
import { SupportTicket } from '../models/support-ticket.model';
import { SupportTicketMessage } from '../models/support-ticket-message.model';
@Injectable()
export class AdminCmsHelpdeskRepository implements IAdminCmsHelpdeskRepository {
  constructor(private readonly prisma: PrismaService) {}
  async list(adminId: string, offset: number, limit: number, status?: string) {
    return this.prisma.$transaction(async (tx) => {
      const rows = await tx.supportTicket.findMany({
        where: { deletedAt: null, ...(status ? { status } : {}) },
        skip: offset,
        take: limit,
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      });
      await tx.adminAuditEvent.create({
        data: {
          adminId,
          action: 'SUPPORT_TICKETS_LIST',
          entityType: 'SUPPORT_TICKET',
          redactedChanges: { offset, limit, status: status ?? null },
        },
      });
      return rows.map((row) => new SupportTicket(row));
    });
  }
  async readForContent(adminId: string, id: string, reasonCode: string) {
    return this.prisma.$transaction(async (tx) => {
      const row = await tx.supportTicket.findFirst({
        where: { id, deletedAt: null },
      });
      if (!row) throw new NotFoundError('Ticket was not found.');
      await tx.adminAuditEvent.create({
        data: {
          adminId,
          action: 'SUPPORT_TICKET_CONTENT_READ',
          entityType: 'SUPPORT_TICKET',
          entityId: id,
          reasonCode,
        },
      });
      return new SupportTicket(row);
    });
  }
  async reply(
    audit: AdminCmsTicketAudit,
    ticketId: string,
    messageId: string,
    bodyEnc: Uint8Array,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.support_tickets WHERE id = ${ticketId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      const row = await tx.supportTicket.findFirst({
        where: { id: ticketId, deletedAt: null },
      });
      if (!row) throw new NotFoundError('Ticket was not found.');
      if (['CLOSED', 'RESOLVED'].includes(row.status))
        throw new DomainError(
          'Ticket is closed.',
          'SUPPORT_TICKET_CLOSED',
          409,
        );
      const message = await tx.supportTicketMessage.create({
        data: {
          id: messageId,
          ticketId,
          senderAdminId: audit.adminId,
          bodyEnc: new Uint8Array(bodyEnc),
        },
      });
      await tx.supportTicket.update({
        where: { id: ticketId },
        data: {
          status: 'WAITING_USER',
          assignedAdminId: audit.adminId,
          updatedAt: new Date(),
        },
      });
      await tx.adminAuditEvent.create({
        data: {
          ...audit,
          action: 'SUPPORT_TICKET_REPLY',
          entityType: 'SUPPORT_TICKET',
          entityId: ticketId,
          redactedChanges: { messageId, status: 'WAITING_USER' },
        },
      });
      return new SupportTicketMessage(message);
    });
  }
  async status(audit: AdminCmsTicketAudit, ticketId: string, status: string) {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.support_tickets WHERE id = ${ticketId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      const before = await tx.supportTicket.findFirst({
        where: { id: ticketId, deletedAt: null },
      });
      if (!before) throw new NotFoundError('Ticket was not found.');
      const row = await tx.supportTicket.update({
        where: { id: ticketId },
        data: {
          status,
          closedAt: ['RESOLVED', 'CLOSED'].includes(status) ? new Date() : null,
          assignedAdminId: audit.adminId,
        },
      });
      await tx.adminAuditEvent.create({
        data: {
          ...audit,
          action: 'SUPPORT_TICKET_STATUS_CHANGE',
          entityType: 'SUPPORT_TICKET',
          entityId: ticketId,
          redactedChanges: { before: before.status, after: status },
        },
      });
      return new SupportTicket(row);
    });
  }
}
