import {
  createCipheriv,
  createDecipheriv,
  randomBytes,
  randomUUID,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { SUPPORT_HELPDESK_POLICY as P } from '../config/support-helpdesk-policy';
import type {
  CreateSupportHelpdeskDto,
  SupportHelpdeskQueryDto,
  SupportHelpdeskReceipt,
  SupportHelpdeskDetail,
  SupportHelpdeskMessageDto,
} from '../dto/support-helpdesk/support-helpdesk.dto';
import { SUPPORT_HELPDESK_REPOSITORY } from '../interfaces/repositories/support-helpdesk-repository.interface';
import type { ISupportHelpdeskRepository } from '../interfaces/repositories/support-helpdesk-repository.interface';
import type { ISupportHelpdeskService } from '../interfaces/services/support-helpdesk-service.interface';
import type { SupportTicket } from '../models/support-ticket.model';
/** Existing bytea columns hold a versioned authenticated envelope; no child data is loaded. */
@Injectable()
export class SupportHelpdeskService implements ISupportHelpdeskService {
  constructor(
    @Inject(SUPPORT_HELPDESK_REPOSITORY)
    private readonly repository: ISupportHelpdeskRepository,
    private readonly config: ConfigService,
  ) {}
  catalog() {
    return { version: P.version, categories: P.categories };
  }
  async create(
    actor: AuthPrincipal,
    input: CreateSupportHelpdeskDto,
  ): Promise<SupportHelpdeskReceipt> {
    if (!(P.categories as readonly string[]).includes(input.category))
      throw new DomainError(
        'Unknown category.',
        'SUPPORT_CATEGORY_INVALID',
        422,
      );
    const id = randomUUID();
    const messageEnc = this.encrypt(
      JSON.stringify({
        version: 1,
        categoryVersion: P.version,
        subject: input.subject,
        body: input.body,
      }),
      `ticket:${id}:${actor.userId}`,
    );
    return this.receipt(
      await this.repository.create({
        id,
        userId: actor.userId,
        familyId: input.familyId ?? null,
        category: input.category,
        messageEnc,
        assetIds: input.attachmentAssetIds ?? [],
      }),
    );
  }
  async list(actor: AuthPrincipal, query: SupportHelpdeskQueryDto) {
    const offset = query.offset ?? 0,
      limit = query.limit ?? P.pageSize;
    const rows = await this.repository.list(actor.userId, offset, limit + 1);
    return {
      items: rows.slice(0, limit).map((row) => this.receipt(row)),
      nextOffset: rows.length > limit ? offset + limit : null,
    };
  }
  async detail(
    actor: AuthPrincipal,
    id: string,
  ): Promise<SupportHelpdeskDetail> {
    const view = await this.repository.detail(actor.userId, id);
    if (!view) throw new NotFoundError('Ticket was not found.');
    let payload: unknown;
    try {
      payload = JSON.parse(
        this.decrypt(view.ticket.messageEnc, `ticket:${id}:${actor.userId}`),
      );
    } catch (error) {
      if (error instanceof DomainError) throw error;
      throw new DomainError(
        'Support content is unavailable.',
        'SUPPORT_CONTENT_UNAVAILABLE',
        503,
      );
    }
    if (
      typeof payload !== 'object' ||
      payload === null ||
      !('version' in payload) ||
      payload.version !== 1 ||
      !('subject' in payload) ||
      typeof payload.subject !== 'string' ||
      !('body' in payload) ||
      typeof payload.body !== 'string' ||
      !('categoryVersion' in payload) ||
      typeof payload.categoryVersion !== 'number'
    )
      throw new DomainError(
        'Unsupported ticket payload.',
        'SUPPORT_CONTENT_UNAVAILABLE',
        503,
      );
    return {
      ...this.receipt(view.ticket),
      category: view.ticket.category,
      categoryVersion: payload.categoryVersion,
      subject: payload.subject,
      body: payload.body,
      familyId: view.ticket.familyId,
      attachmentAssetIds: view.attachmentAssetIds,
      messages: view.messages.map((message) => ({
        id: message.id,
        sender: message.senderAdminId ? 'SUPPORT' : 'USER',
        body: this.decrypt(message.bodyEnc, `message:${id}:${message.id}`),
        createdAt: message.createdAt.toISOString(),
      })),
    };
  }
  async message(
    actor: AuthPrincipal,
    id: string,
    input: SupportHelpdeskMessageDto,
  ) {
    if (!(await this.repository.detail(actor.userId, id)))
      throw new NotFoundError('Ticket was not found.');
    const messageId = randomUUID();
    const row = await this.repository.message(
      actor.userId,
      id,
      messageId,
      this.encrypt(input.body, `message:${id}:${messageId}`),
    );
    return { id: row.id, createdAt: row.createdAt.toISOString() };
  }
  private receipt(row: SupportTicket): SupportHelpdeskReceipt {
    return {
      id: row.id,
      code: `HT-${row.createdAt.toISOString().slice(2, 10).replace(/-/g, '')}-${row.id.toUpperCase()}`,
      status: row.status,
      createdAt: row.createdAt.toISOString(),
    };
  }
  private key(): Buffer {
    const encoded = this.config.get<string>('SUPPORT_ENCRYPTION_KEY') ?? '';
    const key = Buffer.from(encoded, 'base64');
    if (key.length !== 32 || key.toString('base64') !== encoded)
      throw new DomainError(
        'Support encryption is unavailable.',
        'SUPPORT_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return key;
  }
  private encrypt(text: string, aad: string): Uint8Array {
    const iv = randomBytes(12),
      cipher = createCipheriv('aes-256-gcm', this.key(), iv);
    cipher.setAAD(Buffer.from(`support:v1:${aad}`));
    const encrypted = Buffer.concat([
      cipher.update(text, 'utf8'),
      cipher.final(),
    ]);
    return Buffer.concat([
      Buffer.from([1]),
      iv,
      cipher.getAuthTag(),
      encrypted,
    ]);
  }
  private decrypt(bytes: Uint8Array, aad: string): string {
    const key = this.key();
    try {
      const buffer = Buffer.from(bytes);
      if (buffer.length < 29 || buffer[0] !== 1)
        throw new Error('Invalid envelope');
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        buffer.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(`support:v1:${aad}`));
      decipher.setAuthTag(buffer.subarray(13, 29));
      return Buffer.concat([
        decipher.update(buffer.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'Support content is unavailable.',
        'SUPPORT_CONTENT_UNAVAILABLE',
        503,
      );
    }
  }
}
