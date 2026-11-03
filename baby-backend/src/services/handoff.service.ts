import {
  createCipheriv,
  createDecipheriv,
  hkdfSync,
  randomBytes,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { HANDOFF_POLICY } from '../config/handoff-policy';
import type {
  CreateHandoffDto,
  HandoffDto,
  HandoffListQueryDto,
} from '../dto/us/handoff.dto';
import { COUPLE_CHECKIN_REPOSITORY } from '../interfaces/repositories/couple-checkin-repository.interface';
import type { ICoupleCheckinRepository } from '../interfaces/repositories/couple-checkin-repository.interface';
import { HANDOFF_REPOSITORY } from '../interfaces/repositories/handoff-repository.interface';
import type { IHandoffRepository } from '../interfaces/repositories/handoff-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IHandoffService } from '../interfaces/services/handoff-service.interface';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';
import type { HandoffRow } from '../models/handoff-view.model';

/**
 * Bàn giao ca (7.13.8, BF-20261028-007): Parent ghi nhanh đã ăn / ngủ / dậy
 * lúc và ghi chú cho bạn đời, kèm Lời nhờ nếu cần. Không phải tracker y tế:
 * không có thống kê, không đánh giá. Ghi chú mã hoá AES-256-GCM theo couple
 * space; Idempotency-Key cho phép gửi lại khi offline mà không trùng.
 */
@Injectable()
export class HandoffService implements IHandoffService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_CHECKIN_REPOSITORY)
    private readonly pairs: ICoupleCheckinRepository,
    @Inject(HANDOFF_REPOSITORY)
    private readonly repository: IHandoffRepository,
    private readonly config: ConfigService,
  ) {}

  async create(
    actor: AuthPrincipal,
    familyId: string,
    idempotencyKey: string,
    input: CreateHandoffDto,
  ): Promise<HandoffDto> {
    const scope = await this.scope(actor, familyId, 'write');
    const replay = await this.repository.findByKey(scope, idempotencyKey);
    if (replay) return this.project(replay, scope);
    const now = Date.now();
    const time = (value?: string) => {
      if (!value) return null;
      const at = new Date(value);
      if (
        at.getTime() > now + HANDOFF_POLICY.clockSkewMs ||
        at.getTime() < now - HANDOFF_POLICY.lookbackMs
      )
        throw new DomainError(
          'Times must be within the last 24 hours.',
          'HANDOFF_TIME_INVALID',
          400,
        );
      return at;
    };
    const fedAt = time(input.fedAt);
    const sleptAt = time(input.sleptAt);
    const wokeAt = time(input.wokeAt);
    const note = input.note?.trim() || null;
    if (!fedAt && !sleptAt && !wokeAt && !note)
      throw new ValidationError('A time or a note is required.');
    const childIds = [...new Set(input.childIds ?? [])];
    if (
      (await this.repository.activeChildIds(familyId, childIds)).length !==
      childIds.length
    )
      throw new ValidationError('childIds must be active children.');
    if (
      input.requestId &&
      !(await this.repository.ownRequestExists(scope, input.requestId))
    )
      throw new ValidationError('requestId must be your own request.');
    const row = await this.repository.create(scope, {
      idempotencyKey,
      childIds,
      fedAt,
      sleptAt,
      wokeAt,
      noteEnc: note ? this.encrypt(note, scope, idempotencyKey) : null,
      requestId: input.requestId ?? null,
    });
    return this.project(row, scope);
  }

  async list(
    actor: AuthPrincipal,
    familyId: string,
    query: HandoffListQueryDto,
  ): Promise<HandoffDto[]> {
    const scope = await this.scope(actor, familyId, 'read');
    const rows = await this.repository.list(
      scope,
      query.limit ?? HANDOFF_POLICY.listLimit,
    );
    return rows.map((row) => this.project(row, scope));
  }

  async acknowledge(
    actor: AuthPrincipal,
    familyId: string,
    handoffId: string,
  ): Promise<HandoffDto> {
    const scope = await this.scope(actor, familyId, 'write');
    const row = await this.repository.acknowledge(scope, handoffId, new Date());
    if (!row) throw new NotFoundError('Handoff was not found.');
    return this.project(row, scope);
  }

  private async scope(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'write',
  ): Promise<CoupleCheckinScope> {
    const family = await this.access.requireParent(actor, familyId, mode);
    if (family.status !== 'ACTIVE')
      throw new DomainError(
        'The family is not active.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
    const scope = await this.pairs.resolveScope(familyId, actor.userId);
    if (!scope)
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
    return scope;
  }

  private project(row: HandoffRow, scope: CoupleCheckinScope): HandoffDto {
    const iso = (value: Date | null) => value?.toISOString() ?? null;
    return {
      id: row.id,
      fromUserId: row.fromUserId,
      toUserId: row.toUserId,
      direction: row.fromUserId === scope.userId ? 'SENT' : 'RECEIVED',
      childIds: [...row.childIds],
      fedAt: iso(row.fedAt),
      sleptAt: iso(row.sleptAt),
      wokeAt: iso(row.wokeAt),
      note: row.noteEnc ? this.decrypt(row.noteEnc, scope, row) : null,
      requestId: row.requestId,
      acknowledgedAt: iso(row.acknowledgedAt),
      createdAt: row.createdAt.toISOString(),
    };
  }

  /** AES-256-GCM v1; khoá dẫn xuất theo couple space, AAD gồm id thao tác. */
  private key(scope: CoupleCheckinScope): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32)
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required.',
        'HANDOFF_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return Buffer.from(
      hkdfSync(
        'sha256',
        key,
        'baby-family:us-handoff:v1',
        `couple:${scope.coupleSpaceId}`,
        32,
      ),
    );
  }

  private encrypt(
    note: string,
    scope: CoupleCheckinScope,
    idempotencyKey: string,
  ): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(scope), iv);
    cipher.setAAD(
      Buffer.from(
        `handoff:${scope.coupleSpaceId}:${scope.userId}:${idempotencyKey}`,
      ),
    );
    const ciphertext = Buffer.concat([
      cipher.update(note, 'utf8'),
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
    data: Uint8Array,
    scope: CoupleCheckinScope,
    row: HandoffRow,
  ): string | null {
    const key = this.key(scope);
    const bytes = Buffer.from(data);
    if (bytes[0] !== 1 || bytes.length < 30) return null;
    try {
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        bytes.subarray(1, 13),
      );
      decipher.setAAD(
        Buffer.from(
          `handoff:${scope.coupleSpaceId}:${row.fromUserId}:${row.idempotencyKey}`,
        ),
      );
      decipher.setAuthTag(bytes.subarray(13, 29));
      return Buffer.concat([
        decipher.update(bytes.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      return null;
    }
  }
}
