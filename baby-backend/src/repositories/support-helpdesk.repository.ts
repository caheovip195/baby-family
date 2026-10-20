import { Injectable } from '@nestjs/common';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import type { ISupportHelpdeskRepository } from '../interfaces/repositories/support-helpdesk-repository.interface';
import { SupportTicket } from '../models/support-ticket.model';
import { SupportTicketMessage } from '../models/support-ticket-message.model';
import { SupportHelpdeskView } from '../models/support-helpdesk-view.model';
@Injectable()
export class SupportHelpdeskRepository implements ISupportHelpdeskRepository {
  constructor(private readonly prisma: PrismaService) {}
  create(
    input: Parameters<ISupportHelpdeskRepository['create']>[0],
  ): Promise<SupportTicket> {
    return this.prisma.$transaction(async (tx) => {
      if (input.familyId) {
        const now = new Date();
        const family = await tx.family.count({
          where: {
            id: input.familyId,
            deletedAt: null,
            OR: [
              {
                familyParents: {
                  some: {
                    userId: input.userId,
                    status: 'ACTIVE',
                    deletedAt: null,
                    leftAt: null,
                    joinedAt: { lte: now },
                  },
                },
              },
              {
                circleMembers: {
                  some: {
                    userId: input.userId,
                    status: { in: ['ACTIVE', 'PAUSED', 'SUSPENDED_PLAN'] },
                    deletedAt: null,
                    endedAt: null,
                    joinedAt: { lte: now },
                  },
                },
              },
            ],
          },
        });
        if (!family) throw new NotFoundError('Family was not found.');
      }
      const assets = await tx.userAsset.findMany({
        where: {
          id: { in: input.assetIds },
          ownerUserId: input.userId,
          purpose: 'SUPPORT',
          status: 'READY',
          deletedAt: null,
        },
      });
      if (assets.length !== input.assetIds.length)
        throw new DomainError(
          'Attachment was not found or is not ready.',
          'SUPPORT_ATTACHMENT_INVALID',
          422,
        );
      const row = await tx.supportTicket.create({
        data: {
          id: input.id,
          requesterUserId: input.userId,
          familyId: input.familyId,
          category: input.category,
          messageEnc: new Uint8Array(input.messageEnc),
        },
      });
      if (input.assetIds.length)
        await tx.supportTicketAttachment.createMany({
          data: input.assetIds.map((assetId) => ({
            ticketId: row.id,
            ownerUserId: input.userId,
            assetId,
          })),
        });
      return new SupportTicket(row);
    });
  }
  async list(
    userId: string,
    offset: number,
    limit: number,
  ): Promise<SupportTicket[]> {
    return (
      await this.prisma.supportTicket.findMany({
        where: { requesterUserId: userId, deletedAt: null },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        skip: offset,
        take: limit,
      })
    ).map((row) => new SupportTicket(row));
  }
  async detail(
    userId: string,
    id: string,
  ): Promise<SupportHelpdeskView | null> {
    const row = await this.prisma.supportTicket.findFirst({
      where: { id, requesterUserId: userId, deletedAt: null },
      include: {
        supportTicketAttachments: {
          where: {
            deletedAt: null,
            userAsset: { deletedAt: null, status: 'READY' },
          },
        },
        supportTicketMessages: {
          where: { deletedAt: null },
          orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
        },
      },
    });
    return row
      ? new SupportHelpdeskView(
          new SupportTicket(row),
          row.supportTicketAttachments.map((a) => a.assetId),
          row.supportTicketMessages.map((m) => new SupportTicketMessage(m)),
        )
      : null;
  }
  message(
    userId: string,
    ticketId: string,
    id: string,
    bodyEnc: Uint8Array,
  ): Promise<SupportTicketMessage> {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.support_tickets WHERE id = ${ticketId}::uuid AND requester_user_id = ${userId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      const row = await tx.supportTicket.findFirst({
        where: { id: ticketId, requesterUserId: userId, deletedAt: null },
      });
      if (!row) throw new NotFoundError('Ticket was not found.');
      if (['CLOSED', 'RESOLVED'].includes(row.status))
        throw new DomainError(
          'Ticket is closed.',
          'SUPPORT_TICKET_CLOSED',
          409,
        );
      // Lock/update the parent before inserting a reply to serialize concurrent replies.
      await tx.supportTicket.update({
        where: { id: ticketId },
        data: { updatedAt: new Date() },
      });
      return new SupportTicketMessage(
        await tx.supportTicketMessage.create({
          data: {
            id,
            ticketId,
            senderUserId: userId,
            bodyEnc: new Uint8Array(bodyEnc),
          },
        }),
      );
    });
  }
}
