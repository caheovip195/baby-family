import {
  createCipheriv,
  createDecipheriv,
  hkdfSync,
  randomBytes,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { COUPLE_JOURNAL_POLICY } from '../config/couple-journal-policy';
import type {
  CreateJournalEntryDto,
  UpdateJournalEntryDto,
  JournalListQueryDto,
  ShareJournalExcerptDto,
  JournalEntryViewDto,
  JournalListDto,
  JournalShareResponseDto,
} from '../dto/us/journal.dto';
import { COUPLE_JOURNAL_REPOSITORY } from '../interfaces/repositories/couple-journal-repository.interface';
import type { ICoupleJournalRepository } from '../interfaces/repositories/couple-journal-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { ICoupleJournalService } from '../interfaces/services/couple-journal-service.interface';
import type {
  CoupleJournalScope,
  CoupleJournalEntryView,
} from '../models/couple-journal-view.model';

@Injectable()
export class CoupleJournalService implements ICoupleJournalService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_JOURNAL_REPOSITORY)
    private readonly repository: ICoupleJournalRepository,
    private readonly config: ConfigService,
  ) {}

  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateJournalEntryDto,
  ): Promise<JournalEntryViewDto> {
    const scope = await this.context(actor, familyId, 'write');

    const trimmedBody = input.body.trim();
    if (!trimmedBody) {
      throw new DomainError(
        'Journal entry body is required.',
        'JOURNAL_BODY_REQUIRED',
        422,
      );
    }
    if (trimmedBody.length > COUPLE_JOURNAL_POLICY.maxBodyLength) {
      throw new DomainError(
        `Journal entry body exceeds ${COUPLE_JOURNAL_POLICY.maxBodyLength} characters.`,
        'JOURNAL_BODY_TOO_LONG',
        422,
      );
    }

    const trimmedTitle = input.title?.trim() || null;
    if (
      trimmedTitle &&
      trimmedTitle.length > COUPLE_JOURNAL_POLICY.maxTitleLength
    ) {
      throw new DomainError(
        `Journal entry title exceeds ${COUPLE_JOURNAL_POLICY.maxTitleLength} characters.`,
        'JOURNAL_TITLE_TOO_LONG',
        422,
      );
    }

    const assetIds = input.assetIds ?? [];
    if (assetIds.length > COUPLE_JOURNAL_POLICY.maxAssetsPerEntry) {
      throw new DomainError(
        `Maximum ${COUPLE_JOURNAL_POLICY.maxAssetsPerEntry} assets per journal entry.`,
        'JOURNAL_ASSET_LIMIT_EXCEEDED',
        422,
      );
    }

    if (assetIds.length > 0) {
      const valid = await this.repository.verifyAssets(scope, assetIds);
      if (!valid) {
        throw new DomainError(
          'One or more assets are invalid, not ready, or do not belong to the author for journal use.',
          'JOURNAL_ASSET_INVALID',
          422,
        );
      }
    }

    const userScope = `user:${scope.userId}`;
    const bodyEnc = this.encrypt(
      trimmedBody,
      userScope,
      'baby-family:us-journal:v1',
    );
    const titleEnc = trimmedTitle
      ? this.encrypt(trimmedTitle, userScope, 'baby-family:us-journal:v1')
      : null;

    const row = await this.repository.create(scope, {
      titleEnc,
      bodyEnc,
      mood: input.mood ?? null,
      assetIds,
      createdAt: new Date(),
    });

    return this.project(row, scope);
  }

  async list(
    actor: AuthPrincipal,
    familyId: string,
    query: JournalListQueryDto,
  ): Promise<JournalListDto> {
    const scope = await this.context(actor, familyId, 'read');
    const limit = query.limit ?? COUPLE_JOURNAL_POLICY.defaultLimit;
    const rows = await this.repository.list(scope, query.cursor, limit + 1);

    return {
      items: rows.slice(0, limit).map((row) => this.project(row, scope)),
      nextCursor: rows.length > limit ? rows[limit - 1]!.entry.id : null,
    };
  }

  async findById(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<JournalEntryViewDto> {
    const scope = await this.context(actor, familyId, 'read');
    const row = await this.repository.findById(scope, id);
    if (!row) {
      throw new DomainError(
        'Journal entry was not found.',
        'JOURNAL_ENTRY_NOT_FOUND',
        404,
      );
    }
    return this.project(row, scope);
  }

  async update(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: UpdateJournalEntryDto,
  ): Promise<JournalEntryViewDto> {
    const scope = await this.context(actor, familyId, 'write');
    const existing = await this.repository.findById(scope, id);
    if (!existing) {
      throw new DomainError(
        'Journal entry was not found.',
        'JOURNAL_ENTRY_NOT_FOUND',
        404,
      );
    }

    const userScope = `user:${scope.userId}`;
    let bodyEnc: Uint8Array | undefined;
    if (input.body !== undefined) {
      const trimmed = input.body.trim();
      if (!trimmed) {
        throw new DomainError(
          'Journal entry body is required.',
          'JOURNAL_BODY_REQUIRED',
          422,
        );
      }
      if (trimmed.length > COUPLE_JOURNAL_POLICY.maxBodyLength) {
        throw new DomainError(
          `Journal entry body exceeds ${COUPLE_JOURNAL_POLICY.maxBodyLength} characters.`,
          'JOURNAL_BODY_TOO_LONG',
          422,
        );
      }
      bodyEnc = this.encrypt(trimmed, userScope, 'baby-family:us-journal:v1');
    }

    let titleEnc: Uint8Array | null | undefined;
    if (input.title !== undefined) {
      const trimmedTitle = input.title.trim();
      if (
        trimmedTitle &&
        trimmedTitle.length > COUPLE_JOURNAL_POLICY.maxTitleLength
      ) {
        throw new DomainError(
          `Journal entry title exceeds ${COUPLE_JOURNAL_POLICY.maxTitleLength} characters.`,
          'JOURNAL_TITLE_TOO_LONG',
          422,
        );
      }
      titleEnc = trimmedTitle
        ? this.encrypt(trimmedTitle, userScope, 'baby-family:us-journal:v1')
        : null;
    }

    if (input.assetIds !== undefined) {
      if (input.assetIds.length > COUPLE_JOURNAL_POLICY.maxAssetsPerEntry) {
        throw new DomainError(
          `Maximum ${COUPLE_JOURNAL_POLICY.maxAssetsPerEntry} assets per journal entry.`,
          'JOURNAL_ASSET_LIMIT_EXCEEDED',
          422,
        );
      }
      if (input.assetIds.length > 0) {
        const valid = await this.repository.verifyAssets(scope, input.assetIds);
        if (!valid) {
          throw new DomainError(
            'One or more assets are invalid, not ready, or do not belong to the author for journal use.',
            'JOURNAL_ASSET_INVALID',
            422,
          );
        }
      }
    }

    const updated = await this.repository.update(scope, id, {
      titleEnc,
      bodyEnc,
      mood: input.mood,
      assetIds: input.assetIds,
    });

    return this.project(updated, scope);
  }

  async delete(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<void> {
    const scope = await this.context(actor, familyId, 'write');
    await this.repository.delete(scope, id);
  }

  async share(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: ShareJournalExcerptDto,
  ): Promise<JournalShareResponseDto> {
    const scope = await this.context(actor, familyId, 'write');
    const existing = await this.repository.findById(scope, id);
    if (!existing) {
      throw new DomainError(
        'Journal entry was not found.',
        'JOURNAL_ENTRY_NOT_FOUND',
        404,
      );
    }

    const userScope = `user:${scope.userId}`;
    const fullBody =
      this.decrypt(
        existing.entry.bodyEnc,
        userScope,
        'baby-family:us-journal:v1',
      ) ?? '';

    if (!fullBody.includes(input.excerpt)) {
      throw new DomainError(
        'The excerpt must be an exact substring of the journal entry body.',
        'JOURNAL_EXCERPT_NOT_IN_BODY',
        422,
      );
    }

    const coupleScope = `couple:${scope.coupleSpaceId}`;
    const snippetEnc = this.encrypt(
      input.excerpt,
      coupleScope,
      'baby-family:us-journal-share:v1',
    );

    const share = await this.repository.createShare(scope, {
      entryId: id,
      snippetEnc,
      explicitlySharedAt: new Date(),
    });

    return {
      id: share.id,
      entryId: share.entryId,
      excerpt: input.excerpt,
      explicitlySharedAt: share.explicitlySharedAt.toISOString(),
    };
  }

  private async context(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'write',
  ): Promise<CoupleJournalScope> {
    const family = await this.access.requireParent(actor, familyId, mode);
    if (family.status !== 'ACTIVE') {
      throw new DomainError(
        'The family is not active.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
    }
    const scope = await this.repository.resolveScope(familyId, actor.userId);
    if (!scope) {
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
    }
    return scope;
  }

  private project(
    view: CoupleJournalEntryView,
    scope: CoupleJournalScope,
  ): JournalEntryViewDto {
    const row = view.entry;
    const userScope = `user:${scope.userId}`;
    const title = row.titleEnc
      ? this.decrypt(row.titleEnc, userScope, 'baby-family:us-journal:v1')
      : null;
    const body =
      this.decrypt(row.bodyEnc, userScope, 'baby-family:us-journal:v1') ?? '';

    return {
      id: row.id,
      userId: row.userId,
      title,
      body,
      mood: row.mood,
      assetIds: view.assetIds,
      createdAt: row.createdAt.toISOString(),
      updatedAt: row.updatedAt.toISOString(),
    };
  }

  private key(scope: string, hkdfInfo: string): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32) {
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required for journal encryption.',
        'JOURNAL_ENCRYPTION_UNAVAILABLE',
        503,
      );
    }
    return Buffer.from(hkdfSync('sha256', key, hkdfInfo, scope, 32));
  }

  private encrypt(text: string, scope: string, hkdfInfo: string): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(scope, hkdfInfo), iv);
    cipher.setAAD(Buffer.from(scope));
    const ciphertext = Buffer.concat([
      cipher.update(text, 'utf8'),
      cipher.final(),
    ]);
    return Buffer.concat([
      Buffer.from([1]),
      iv,
      cipher.getAuthTag(),
      ciphertext,
    ]);
  }

  private decrypt(
    data: Uint8Array | null,
    scope: string,
    hkdfInfo: string,
  ): string | null {
    if (data === null) return null;
    const key = this.key(scope, hkdfInfo);
    try {
      const buf = Buffer.from(data);
      if (buf[0] !== 1 || buf.length < 29) {
        throw new Error('Invalid envelope');
      }
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        buf.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(scope));
      decipher.setAuthTag(buf.subarray(13, 29));
      return Buffer.concat([
        decipher.update(buf.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'The encrypted journal content cannot be read.',
        'JOURNAL_BODY_UNREADABLE',
        503,
      );
    }
  }
}
