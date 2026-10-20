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
import { COUPLE_POLICY } from '../config/couple-policy';
import type {
  CreateCheckinDto,
  CheckinHistoryQueryDto,
  CreateCheckinResponseDto,
  CheckinViewDto,
  CheckinTodayDto,
  CheckinHistoryDto,
  CheckinResponseDto,
} from '../dto/us/checkin.dto';
import { COUPLE_CHECKIN_REPOSITORY } from '../interfaces/repositories/couple-checkin-repository.interface';
import type { ICoupleCheckinRepository } from '../interfaces/repositories/couple-checkin-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { ICoupleCheckinService } from '../interfaces/services/couple-checkin-service.interface';
import type {
  CoupleCheckinScope,
  CoupleCheckinView,
} from '../models/couple-checkin-view.model';
@Injectable()
export class CoupleCheckinService implements ICoupleCheckinService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_CHECKIN_REPOSITORY)
    private readonly repository: ICoupleCheckinRepository,
    private readonly config: ConfigService,
  ) {}
  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateCheckinDto,
  ): Promise<CheckinViewDto> {
    const { scope, timezone } = await this.context(actor, familyId, 'write');
    const now = new Date();
    // Spec §7.16.1: “Khó chịu với bạn đời” is never sent to the partner (the app
    // offers the Conflict Bridge instead), whatever the client asks.
    const shared =
      input.share.enabled && !COUPLE_POLICY.privateMoods.includes(input.mood);
    const fields = shared ? input.share.fields : [];
    const row = await this.repository.create(scope, {
      mood: input.mood,
      energy: input.energy ?? null,
      needs: input.needs ?? [],
      noteEnc:
        input.note === undefined
          ? null
          : this.encrypt(input.note, `user:${actor.userId}`),
      sharedNoteEnc:
        shared && fields.includes('note') && input.note !== undefined
          ? this.encrypt(input.note, `couple:${scope.coupleSpaceId}`)
          : null,
      shared,
      sharedFields: fields,
      createdAt: now,
      expiresAt: currentExpiry(now, timezone),
    });
    return this.project(row, scope, false);
  }
  async today(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<CheckinTodayDto> {
    const { scope } = await this.context(actor, familyId, 'read');
    const [mine, partner] = await Promise.all([
      this.repository.latest(scope, scope.userId),
      this.repository.latest(scope, scope.partnerUserId),
    ]);
    const now = new Date();
    return {
      mine: mine?.isCurrent(now) ? this.project(mine, scope, false) : null,
      partner:
        partner?.isCurrent(now) && partner.checkin.shared
          ? this.project(partner, scope, true)
          : null,
    };
  }
  async history(
    actor: AuthPrincipal,
    familyId: string,
    query: CheckinHistoryQueryDto,
  ): Promise<CheckinHistoryDto> {
    const { scope } = await this.context(actor, familyId, 'read');
    const limit = query.limit ?? COUPLE_POLICY.historyDefaultLimit;
    const rows = await this.repository.history(scope, query.cursor, limit + 1);
    return {
      items: rows.slice(0, limit).map((row) => this.project(row, scope, false)),
      nextCursor: rows.length > limit ? rows[limit - 1]!.checkin.id : null,
    };
  }
  async respond(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: CreateCheckinResponseDto,
  ): Promise<CheckinResponseDto> {
    const { scope } = await this.context(actor, familyId, 'write');
    const target = await this.repository.find(scope, id);
    if (!target)
      throw new DomainError(
        'Check-in was not found.',
        'CHECKIN_NOT_FOUND',
        404,
      );
    if (target.checkin.userId === scope.userId)
      throw new DomainError(
        'Only the partner can respond.',
        'CHECKIN_RESPONSE_SELF',
        422,
      );
    if (target.checkin.userId !== scope.partnerUserId || !target.checkin.shared)
      throw new DomainError(
        'Check-in was not found.',
        'CHECKIN_NOT_FOUND',
        404,
      );
    const latest = await this.repository.latest(scope, scope.partnerUserId);
    if (!target.isCurrent(new Date()) || latest?.checkin.id !== id)
      throw new DomainError(
        'Check-in is no longer current.',
        'CHECKIN_NOT_CURRENT',
        422,
      );
    const row = await this.repository.respond(scope, id, input.type);
    return {
      id: row.id,
      checkinId: row.checkinId,
      type: row.type,
      createdAt: row.createdAt.toISOString(),
    };
  }
  async deleteHistory(actor: AuthPrincipal, familyId: string): Promise<void> {
    const { scope } = await this.context(actor, familyId, 'write');
    await this.repository.deleteHistory(scope);
  }
  private async context(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'write',
  ) {
    const family = await this.access.requireParent(actor, familyId, mode);
    if (family.status !== 'ACTIVE')
      throw new DomainError(
        'The family is not active.',
        'FAMILY_NOT_ACTIVE',
        403,
      );
    const scope = await this.repository.resolveScope(familyId, actor.userId);
    if (!scope)
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
    return { scope, timezone: family.timezone };
  }
  private project(
    view: CoupleCheckinView,
    scope: CoupleCheckinScope,
    partner: boolean,
  ): CheckinViewDto {
    const row = view.checkin;
    const result: CheckinViewDto = {
      id: row.id,
      createdAt: row.createdAt.toISOString(),
      expiresAt: row.expiresAt.toISOString(),
    };
    if (!partner) {
      result.shared = row.shared;
      result.sharedFields = row.sharedFields;
    }
    // Explicit whitelist: partner never decrypts the owner's copy of a note.
    if (!partner || row.sharedFields.includes('mood')) result.mood = row.mood;
    if (!partner || row.sharedFields.includes('energy'))
      result.energy = row.energy;
    if (!partner || row.sharedFields.includes('needs'))
      result.needs = row.needs;
    if (!partner || row.sharedFields.includes('note'))
      result.note = this.decrypt(
        partner ? row.sharedNoteEnc : row.noteEnc,
        partner ? `couple:${scope.coupleSpaceId}` : `user:${scope.userId}`,
      );
    return result;
  }
  /** AES-GCM v1 envelope; separate derived keys and AAD for owner/couple copies. */
  private key(scope: string): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32)
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required for notes.',
        'CHECKIN_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return Buffer.from(
      hkdfSync('sha256', key, 'baby-family:us-checkin:v1', scope, 32),
    );
  }
  private encrypt(note: string, scope: string): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(scope), iv);
    cipher.setAAD(Buffer.from(scope));
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
  private decrypt(note: Uint8Array | null, scope: string): string | null {
    if (note === null) return null;
    const key = this.key(scope);
    try {
      const data = Buffer.from(note);
      if (data[0] !== 1 || data.length < 29)
        throw new Error('Invalid envelope');
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        data.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(scope));
      decipher.setAuthTag(data.subarray(13, 29));
      return Buffer.concat([
        decipher.update(data.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'The encrypted note cannot be read.',
        'CHECKIN_NOTE_UNREADABLE',
        503,
      );
    }
  }
}
/** Binary search the next local date boundary, including DST transitions. */
export function currentExpiry(now: Date, timezone: string): Date {
  const formatter = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
  const day = formatter.format(now);
  let low = now.getTime();
  let high = low + COUPLE_POLICY.currentDurationMs;
  if (formatter.format(new Date(high)) === day) return new Date(high);
  while (high - low > 1) {
    const middle = Math.floor((low + high) / 2);
    if (formatter.format(new Date(middle)) === day) low = middle;
    else high = middle;
  }
  return new Date(high);
}
