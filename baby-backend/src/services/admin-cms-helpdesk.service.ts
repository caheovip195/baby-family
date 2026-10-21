import { createCipheriv, randomBytes, randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DomainError } from '../common/errors/domain.error';
import { ADMIN_CMS_HELPDESK_REPOSITORY } from '../interfaces/repositories/admin-cms-helpdesk-repository.interface';
import type { IAdminCmsHelpdeskRepository } from '../interfaces/repositories/admin-cms-helpdesk-repository.interface';
import { SUPPORT_HELPDESK_SERVICE } from '../interfaces/services/support-helpdesk-service.interface';
import type { ISupportHelpdeskService } from '../interfaces/services/support-helpdesk-service.interface';
import type {
  IAdminCmsHelpdeskService,
  AdminCmsTicketMetadata,
} from '../interfaces/services/admin-cms-helpdesk-service.interface';
import type {
  AdminCmsHelpdeskQueryDto,
  AdminCmsHelpdeskReplyDto,
  AdminCmsHelpdeskStatusDto,
} from '../dto/admin-cms-helpdesk/admin-cms-helpdesk.dto';
import type { SupportTicket } from '../models/support-ticket.model';
@Injectable()
export class AdminCmsHelpdeskService implements IAdminCmsHelpdeskService {
  constructor(
    @Inject(ADMIN_CMS_HELPDESK_REPOSITORY)
    private readonly repository: IAdminCmsHelpdeskRepository,
    @Inject(SUPPORT_HELPDESK_SERVICE)
    private readonly helpdesk: ISupportHelpdeskService,
    private readonly config: ConfigService,
  ) {}
  async list(adminId: string, query: AdminCmsHelpdeskQueryDto) {
    const offset = query.offset ?? 0,
      limit = query.limit ?? 50;
    const rows = await this.repository.list(
      adminId,
      offset,
      limit + 1,
      query.status,
    );
    return {
      items: rows.slice(0, limit).map((row) => this.metadata(row)),
      nextOffset: rows.length > limit ? offset + limit : null,
    };
  }
  async detail(adminId: string, id: string, reasonCode: string) {
    const ticket = await this.repository.readForContent(
      adminId,
      id,
      reasonCode,
    );
    if (!ticket.requesterUserId)
      throw new DomainError(
        'Support content is unavailable.',
        'SUPPORT_CONTENT_UNAVAILABLE',
        503,
      );
    // Requester identity comes only from the audited ticket. This reuses the existing
    // content projection/decryption; no app session or user-selected principal is accepted.
    return this.helpdesk.detail(
      {
        userId: ticket.requesterUserId,
        sessionId: 'admin-case-access',
        tokenVersion: 0,
      },
      id,
    );
  }
  async reply(adminId: string, id: string, input: AdminCmsHelpdeskReplyDto) {
    const messageId = randomUUID();
    const encoded = this.config.get<string>('SUPPORT_ENCRYPTION_KEY') ?? '',
      key = Buffer.from(encoded, 'base64');
    if (key.length !== 32 || key.toString('base64') !== encoded)
      throw new DomainError(
        'Support encryption is unavailable.',
        'SUPPORT_ENCRYPTION_UNAVAILABLE',
        503,
      );
    const iv = randomBytes(12),
      cipher = createCipheriv('aes-256-gcm', key, iv);
    cipher.setAAD(Buffer.from(`support:v1:message:${id}:${messageId}`));
    const encrypted = Buffer.concat([
      cipher.update(input.body, 'utf8'),
      cipher.final(),
    ]);
    const row = await this.repository.reply(
      { adminId, reasonCode: input.reasonCode },
      id,
      messageId,
      Buffer.concat([Buffer.from([1]), iv, cipher.getAuthTag(), encrypted]),
    );
    return {
      id: row.id,
      sender: 'SUPPORT' as const,
      createdAt: row.createdAt.toISOString(),
    };
  }
  async status(adminId: string, id: string, input: AdminCmsHelpdeskStatusDto) {
    return this.metadata(
      await this.repository.status(
        { adminId, reasonCode: input.reasonCode },
        id,
        input.status,
      ),
    );
  }
  private metadata(row: SupportTicket): AdminCmsTicketMetadata {
    return {
      id: row.id,
      requesterUserId: row.requesterUserId,
      familyId: row.familyId,
      category: row.category,
      status: row.status,
      assignedAdminId: row.assignedAdminId,
      createdAt: row.createdAt.toISOString(),
      updatedAt: row.updatedAt.toISOString(),
      closedAt: row.closedAt?.toISOString() ?? null,
    };
  }
}
