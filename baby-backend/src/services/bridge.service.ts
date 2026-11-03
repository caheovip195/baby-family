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
import { BRIDGE_POLICY } from '../config/bridge-policy';
import type {
  BridgeNextStepInputDto,
  BridgeSessionDto,
  ClarifyBridgeDto,
  CreateBridgeDto,
} from '../dto/us/bridge.dto';
import { BRIDGE_REPOSITORY } from '../interfaces/repositories/bridge-repository.interface';
import type { IBridgeRepository } from '../interfaces/repositories/bridge-repository.interface';
import { COUPLE_CHECKIN_REPOSITORY } from '../interfaces/repositories/couple-checkin-repository.interface';
import type { ICoupleCheckinRepository } from '../interfaces/repositories/couple-checkin-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type {
  BridgeAction,
  IBridgeService,
} from '../interfaces/services/bridge-service.interface';
import type { BridgeSessionRow } from '../models/bridge-view.model';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';

const DAY_MS = 86_400_000;

const conflict = (message: string) =>
  new DomainError(message, 'BRIDGE_STATE_CONFLICT', 409);

/**
 * Cầu nối khi bất đồng (7.17, US-08…12, BF-20261028-008, bản không AI).
 * Nháp riêng ở lại trên máy; server chỉ nhận các ý đã chọn chia sẻ. Không
 * thắng/thua, không điểm. Chủ đề / lời nhắn / bước tiếp tự nhập mã hoá
 * AES-256-GCM theo couple space. Nội dung tự xoá theo thời hạn lưu (mặc định
 * 30 ngày sau khi đóng); phiên bỏ dở 14 ngày → EXPIRED. Nhánh an toàn (US-13)
 * hoàn toàn trên máy, không có API, không để lại dấu vết.
 */
@Injectable()
export class BridgeService implements IBridgeService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_CHECKIN_REPOSITORY)
    private readonly pairs: ICoupleCheckinRepository,
    @Inject(BRIDGE_REPOSITORY)
    private readonly repository: IBridgeRepository,
    private readonly config: ConfigService,
  ) {}

  async create(
    actor: AuthPrincipal,
    familyId: string,
    // Một phiên mở mỗi cặp nên gửi lại tự trùng về phiên đó; key giữ cho
    // hợp đồng chung của lệnh xếp hàng được (app luôn gửi).
    _idempotencyKey: string,
    input: CreateBridgeDto,
  ): Promise<BridgeSessionDto> {
    const scope = await this.scope(actor, familyId, 'write');
    const feelings = [...new Set(input.feelings)];
    const needs = [...new Set(input.needs)];
    const topic = input.topic?.trim() || null;
    const message = input.message?.trim() || null;
    if (!feelings.length && !needs.length && !message)
      throw new ValidationError('Share at least one feeling, need or message.');
    const share = {
      feelings,
      needs,
      sharedEnc: this.sealShare(topic, message, scope),
    };
    await this.repository.housekeep(scope, new Date());
    const live = await this.repository.live(scope);
    if (live) {
      // Mỗi cặp một phiên mở: gửi lại (offline) hoặc bạn đời góp ý của mình
      // vào phiên đã mời (giai đoạn 3) đều ghi vào phiên đó.
      await this.repository.saveShare(scope, live.id, share);
      if (
        live.initiatorUserId !== scope.userId &&
        (live.status === 'INVITED' || live.status === 'PAUSED')
      )
        await this.repository.update(scope, live.id, {
          status: 'ACTIVE',
          ...(live.startedAt ? {} : { startedAt: new Date() }),
        });
      return this.load(scope, live.id);
    }
    const row = await this.repository.create(
      scope,
      input.retentionDays ?? BRIDGE_POLICY.defaultRetentionDays,
      share,
    );
    return this.project(row, scope);
  }

  async list(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<BridgeSessionDto[]> {
    const scope = await this.scope(actor, familyId, 'read');
    await this.repository.housekeep(scope, new Date());
    return (await this.repository.list(scope, BRIDGE_POLICY.listLimit)).map(
      (row) => this.project(row, scope),
    );
  }

  async get(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
  ): Promise<BridgeSessionDto> {
    const scope = await this.scope(actor, familyId, 'read');
    await this.repository.housekeep(scope, new Date());
    return this.load(scope, sessionId);
  }

  async act(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    action: BridgeAction,
  ): Promise<BridgeSessionDto> {
    const scope = await this.scope(actor, familyId, 'write');
    await this.repository.housekeep(scope, new Date());
    const row = await this.live(scope, sessionId);
    const me = scope.userId;
    switch (action) {
      case 'join':
        if (
          row.partnerUserId !== me ||
          !['INVITED', 'PAUSED'].includes(row.status)
        )
          throw conflict(
            'Only the invited partner can join a waiting session.',
          );
        await this.repository.update(scope, row.id, {
          status: 'ACTIVE',
          ...(row.startedAt ? {} : { startedAt: new Date() }),
        });
        break;
      case 'pause':
        // Ai cũng tạm dừng được, bất kỳ lúc nào; không báo gì tiêu cực.
        await this.repository.update(scope, row.id, { status: 'PAUSED' });
        break;
      case 'understood': {
        if (!['ACTIVE', 'NEXT_STEP'].includes(row.status))
          throw conflict('The session is not active.');
        await this.repository.setUnderstood(scope, row.id);
        const after = await this.live(scope, sessionId);
        const both = [after.initiatorUserId, after.partnerUserId].every(
          (userId) =>
            after.shares.some(
              (share) => share.userId === userId && share.understood,
            ),
        );
        if (both && after.status === 'ACTIVE')
          await this.repository.update(scope, row.id, { status: 'NEXT_STEP' });
        break;
      }
      case 'confirm':
        if (!row.nextStep) throw conflict('No next step was chosen.');
        await this.repository.confirmStep(scope, row.id, row.nextStep.version);
        break;
      case 'close': {
        const agreed = [...new Set([...row.closeAgreed, me])];
        const closed = agreed.length >= 2;
        const now = new Date();
        await this.repository.update(scope, row.id, {
          closeAgreed: agreed,
          ...(closed
            ? {
                status: 'CLOSED',
                closedAt: now,
                purgeAt: new Date(now.getTime() + row.retentionDays * DAY_MS),
              }
            : {}),
        });
        if (closed && row.retentionDays === 0)
          await this.repository.housekeep(scope, now);
        break;
      }
    }
    return this.load(scope, sessionId);
  }

  async clarify(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    input: ClarifyBridgeDto,
  ): Promise<BridgeSessionDto> {
    const scope = await this.scope(actor, familyId, 'write');
    const row = await this.live(scope, sessionId);
    if (!['ACTIVE', 'NEXT_STEP'].includes(row.status))
      throw conflict('The session is not active.');
    const message = input.message.trim();
    if (!message) throw new ValidationError('message is required.');
    const mine = row.shares.find((share) => share.userId === scope.userId);
    const previous = this.openShare(mine?.sharedEnc ?? null, scope);
    await this.repository.saveShare(
      scope,
      row.id,
      {
        feelings: [...(mine?.feelings ?? [])],
        needs: [...(mine?.needs ?? [])],
        sharedEnc: this.sealShare(previous.topic, message, scope),
      },
      true,
    );
    if (row.status === 'NEXT_STEP')
      await this.repository.update(scope, row.id, { status: 'ACTIVE' });
    return this.load(scope, sessionId);
  }

  async nextStep(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    input: BridgeNextStepInputDto,
  ): Promise<BridgeSessionDto> {
    const scope = await this.scope(actor, familyId, 'write');
    const row = await this.live(scope, sessionId);
    if (!['ACTIVE', 'NEXT_STEP'].includes(row.status))
      throw conflict('The session is not active.');
    const text = input.text?.trim() || null;
    if (input.code === 'custom' && !text)
      throw new ValidationError('A custom next step needs text.');
    const sealed = this.seal(text, scope, 'next-step');
    await this.repository.update(scope, row.id, {
      status: 'NEXT_STEP',
      nextStep: {
        code: input.code,
        textEnc: sealed ? Buffer.from(sealed).toString('base64') : null,
        at: input.at ? new Date(input.at) : null,
      },
    });
    return this.load(scope, sessionId);
  }

  private async live(
    scope: CoupleCheckinScope,
    sessionId: string,
  ): Promise<BridgeSessionRow> {
    const row = await this.repository.find(scope, sessionId);
    if (!row) throw new NotFoundError('Bridge session was not found.');
    if (row.status === 'CLOSED' || row.status === 'EXPIRED')
      throw conflict('The session is closed.');
    return row;
  }

  private async load(scope: CoupleCheckinScope, sessionId: string) {
    const row = await this.repository.find(scope, sessionId);
    if (!row) throw new NotFoundError('Bridge session was not found.');
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

  private project(
    row: BridgeSessionRow,
    scope: CoupleCheckinScope,
  ): BridgeSessionDto {
    const purged = row.contentPurged;
    const step = row.nextStep;
    return {
      id: row.id,
      status: row.status,
      initiatorUserId: row.initiatorUserId,
      startedAt: row.startedAt?.toISOString() ?? null,
      closedAt: row.closedAt?.toISOString() ?? null,
      retentionDays: row.retentionDays,
      contentPurged: purged,
      shares: purged
        ? []
        : row.shares.map((share) => ({
            userId: share.userId,
            feelings: [...share.feelings],
            needs: [...share.needs],
            ...this.openShare(share.sharedEnc, scope),
            understood: share.understood,
          })),
      nextStep:
        step && !purged
          ? {
              code: step.code,
              text: step.textEnc
                ? this.open(
                    Buffer.from(step.textEnc, 'base64'),
                    scope,
                    'next-step',
                  )
                : null,
              at: step.at?.toISOString() ?? null,
              agreedUserIds: [...step.agreedUserIds],
            }
          : null,
      closeAgreedUserIds: [...row.closeAgreed],
      createdAt: row.createdAt.toISOString(),
    };
  }

  /** Chủ đề + lời nhắn chia sẻ: một khối JSON mã hoá. */
  private sealShare(
    topic: string | null,
    message: string | null,
    scope: CoupleCheckinScope,
  ): Uint8Array | null {
    return topic === null && message === null
      ? null
      : this.seal(JSON.stringify({ topic, message }), scope, 'share');
  }

  private openShare(
    data: Uint8Array | null,
    scope: CoupleCheckinScope,
  ): { topic: string | null; message: string | null } {
    const text = this.open(data, scope, 'share');
    if (!text) return { topic: null, message: null };
    try {
      const value = JSON.parse(text) as { topic?: unknown; message?: unknown };
      return {
        topic: typeof value.topic === 'string' ? value.topic : null,
        message: typeof value.message === 'string' ? value.message : null,
      };
    } catch {
      return { topic: null, message: null };
    }
  }

  private key(scope: CoupleCheckinScope): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32)
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required.',
        'BRIDGE_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return Buffer.from(
      hkdfSync(
        'sha256',
        key,
        'baby-family:us-bridge:v1',
        `couple:${scope.coupleSpaceId}`,
        32,
      ),
    );
  }

  /** v1 | iv(12) | tag(16) | ciphertext; AAD = couple space + loại field. */
  private seal(
    value: string | null,
    scope: CoupleCheckinScope,
    field: string,
  ): Uint8Array | null {
    if (value === null) return null;
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(scope), iv);
    cipher.setAAD(Buffer.from(`bridge:${scope.coupleSpaceId}:${field}`));
    const ciphertext = Buffer.concat([
      cipher.update(value, 'utf8'),
      cipher.final(),
    ]);
    return Buffer.concat([
      Buffer.from([1]),
      iv,
      cipher.getAuthTag(),
      ciphertext,
    ]);
  }

  private open(
    data: Uint8Array | null,
    scope: CoupleCheckinScope,
    field: string,
  ): string | null {
    if (!data) return null;
    const bytes = Buffer.from(data);
    if (bytes[0] !== 1 || bytes.length < 30) return null;
    try {
      const decipher = createDecipheriv(
        'aes-256-gcm',
        this.key(scope),
        bytes.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(`bridge:${scope.coupleSpaceId}:${field}`));
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
