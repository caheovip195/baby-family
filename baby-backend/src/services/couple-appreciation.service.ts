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
import { COUPLE_APPRECIATION_POLICY } from '../config/couple-appreciation-policy';
import type {
  CreateAppreciationDto,
  AppreciationListQueryDto,
  ReactAppreciationDto,
  ShareRespondAppreciationDto,
  AppreciationViewDto,
  AppreciationWallDto,
} from '../dto/us/appreciation.dto';
import { COUPLE_APPRECIATION_REPOSITORY } from '../interfaces/repositories/couple-appreciation-repository.interface';
import type { ICoupleAppreciationRepository } from '../interfaces/repositories/couple-appreciation-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { ICoupleAppreciationService } from '../interfaces/services/couple-appreciation-service.interface';
import type {
  CoupleAppreciationScope,
  CoupleAppreciationView,
} from '../models/couple-appreciation-view.model';

@Injectable()
export class CoupleAppreciationService implements ICoupleAppreciationService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_APPRECIATION_REPOSITORY)
    private readonly repository: ICoupleAppreciationRepository,
    private readonly config: ConfigService,
  ) {}

  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateAppreciationDto,
  ): Promise<AppreciationViewDto> {
    const scope = await this.context(actor, familyId, 'write');
    let bodyText: string;

    if (input.quick) {
      if (
        !input.linkedType ||
        !input.linkedId ||
        !['MISSION', 'REQUEST'].includes(input.linkedType)
      ) {
        throw new DomainError(
          'Quick appreciation requires linkedType to be MISSION or REQUEST with a valid linkedId.',
          'APPRECIATION_QUICK_LINK_REQUIRED',
          422,
        );
      }
      bodyText =
        input.body?.trim() || COUPLE_APPRECIATION_POLICY.defaultQuickSentence;
    } else {
      const trimmed = input.body?.trim();
      if (!trimmed || trimmed.length === 0) {
        throw new DomainError(
          'Appreciation body is required.',
          'APPRECIATION_BODY_REQUIRED',
          422,
        );
      }
      if (trimmed.length > COUPLE_APPRECIATION_POLICY.maxBodyLength) {
        throw new DomainError(
          `Appreciation body exceeds ${COUPLE_APPRECIATION_POLICY.maxBodyLength} characters.`,
          'APPRECIATION_BODY_TOO_LONG',
          422,
        );
      }
      bodyText = trimmed;
    }

    if (input.linkedType || input.linkedId) {
      if (!input.linkedType || !input.linkedId) {
        throw new DomainError(
          'Both linkedType and linkedId must be provided together.',
          'APPRECIATION_LINK_INVALID',
          422,
        );
      }
      const itemExists = await this.repository.verifyLinkedItem(
        scope,
        input.linkedType,
        input.linkedId,
      );
      if (!itemExists) {
        throw new DomainError(
          'Linked mission/request/memory was not found in this family.',
          'APPRECIATION_LINK_NOT_FOUND',
          422,
        );
      }
    }

    const bodyEnc = this.encrypt(bodyText, `couple:${scope.coupleSpaceId}`);
    const row = await this.repository.create(scope, {
      bodyEnc,
      sticker: input.sticker ?? null,
      linkedType: input.linkedType ?? null,
      linkedId: input.linkedId ?? null,
      createdAt: new Date(),
    });

    return this.project(row, scope);
  }

  async list(
    actor: AuthPrincipal,
    familyId: string,
    query: AppreciationListQueryDto,
  ): Promise<AppreciationWallDto> {
    const scope = await this.context(actor, familyId, 'read');
    const limit = query.limit ?? COUPLE_APPRECIATION_POLICY.defaultLimit;
    const rows = await this.repository.listWall(scope, {
      cursor: query.cursor,
      limit: limit + 1,
      month: query.month,
    });

    return {
      items: rows.slice(0, limit).map((row) => this.project(row, scope)),
      nextCursor: rows.length > limit ? rows[limit - 1]!.appreciation.id : null,
    };
  }

  async react(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: ReactAppreciationDto,
  ): Promise<AppreciationViewDto> {
    const scope = await this.context(actor, familyId, 'write');
    const row = await this.repository.react(scope, id, input.reaction);
    return this.project(row, scope);
  }

  async requestShare(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<AppreciationViewDto> {
    const scope = await this.context(actor, familyId, 'write');
    const row = await this.repository.requestShare(scope, id);
    return this.project(row, scope);
  }

  async respondShare(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: ShareRespondAppreciationDto,
  ): Promise<AppreciationViewDto> {
    const scope = await this.context(actor, familyId, 'write');
    const existing = await this.repository.find(scope, id);
    if (!existing) {
      throw new DomainError(
        'Appreciation was not found.',
        'APPRECIATION_NOT_FOUND',
        404,
      );
    }
    const memoryBody = input.approve
      ? this.decrypt(
          existing.appreciation.bodyEnc,
          `couple:${scope.coupleSpaceId}`,
        )
      : null;
    const row = await this.repository.respondShare(
      scope,
      id,
      input.approve,
      memoryBody,
    );
    return this.project(row, scope);
  }

  async delete(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<void> {
    const scope = await this.context(actor, familyId, 'write');
    await this.repository.delete(scope, id);
  }

  private async context(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'write',
  ): Promise<CoupleAppreciationScope> {
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
    view: CoupleAppreciationView,
    scope: CoupleAppreciationScope,
  ): AppreciationViewDto {
    const row = view.appreciation;
    const body =
      this.decrypt(row.bodyEnc, `couple:${scope.coupleSpaceId}`) ?? '';

    return {
      id: row.id,
      fromUserId: row.fromUserId,
      toUserId: row.toUserId,
      body,
      sticker: row.sticker,
      linkedType: row.linkedType,
      linkedId: row.linkedId,
      familyShareStatus: row.familyShareStatus,
      familyMemoryId: row.familyMemoryId,
      seenAt: row.seenAt ? row.seenAt.toISOString() : null,
      reaction: row.reaction,
      createdAt: row.createdAt.toISOString(),
      isMine: row.fromUserId === scope.userId,
    };
  }

  private key(scope: string): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32) {
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required for appreciation encryption.',
        'APPRECIATION_ENCRYPTION_UNAVAILABLE',
        503,
      );
    }
    return Buffer.from(
      hkdfSync('sha256', key, 'baby-family:us-appreciation:v1', scope, 32),
    );
  }

  private encrypt(text: string, scope: string): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(scope), iv);
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

  private decrypt(data: Uint8Array | null, scope: string): string | null {
    if (data === null) return null;
    const key = this.key(scope);
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
        'The encrypted appreciation cannot be read.',
        'APPRECIATION_BODY_UNREADABLE',
        503,
      );
    }
  }
}
