import {
  createCipheriv,
  createDecipheriv,
  createHmac,
  hkdfSync,
  randomBytes,
  randomUUID,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { COUPLE_REQUEST_POLICY as POLICY } from '../config/couple-request-policy';
import type { CoupleRequestAction } from '../config/couple-request-policy';
import type {
  CreateRequestDto,
  RequestListQueryDto,
  RequestViewDto,
} from '../dto/us/request.dto';
import { COUPLE_REQUEST_REPOSITORY } from '../interfaces/repositories/couple-request-repository.interface';
import type {
  ICoupleRequestRepository,
  RequestMutation,
} from '../interfaces/repositories/couple-request-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type {
  ICoupleRequestService,
  RequestActionInput,
} from '../interfaces/services/couple-request-service.interface';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';
import type { CoupleRequestView } from '../models/couple-request-view.model';

// TODO: self-do needs a defined request-to-mission projection (title, category,
// scope and privacy). Do not copy encrypted couple content into family missions
// until that projection is supported by the mission workflow.
@Injectable()
export class CoupleRequestService implements ICoupleRequestService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_REQUEST_REPOSITORY)
    private readonly repository: ICoupleRequestRepository,
    private readonly config: ConfigService,
  ) {}
  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateRequestDto,
    idempotencyKey: string,
  ) {
    const { scope, timezone } = await this.context(actor, familyId, 'write');
    const now = new Date();
    const title = input.title?.trim() || null;
    const need = input.needCode ?? null;
    if (input.kind === 'NEED') {
      if (
        !need ||
        !['QUIET', 'HUG', 'TALK', 'REASSURANCE'].includes(need) ||
        input.templateId ||
        title ||
        input.dueKind ||
        input.dueAt ||
        input.durationMin
      )
        throw new DomainError(
          'Invalid NEED fields.',
          'REQUEST_CONTENT_INVALID',
          422,
        );
    } else if (
      (!title && !input.templateId && !need) ||
      (title && input.templateId) ||
      (need && !['BREAK', 'HELP_CHILD'].includes(need)) ||
      (need === 'BREAK' && !input.durationMin) ||
      (input.durationMin && need !== 'BREAK')
    ) {
      throw new DomainError(
        'Invalid TASK fields.',
        'REQUEST_CONTENT_INVALID',
        422,
      );
    }
    // HMAC prevents a dictionary attack on private titles in DB dumps. Time,
    // urgency and message cannot bypass the same-content decline cooldown.
    const contentKey = createHmac('sha256', this.key(scope, 'content-key'))
      .update(
        JSON.stringify([
          input.kind,
          need,
          input.templateId ?? null,
          title
            ?.normalize('NFKC')
            .toLocaleLowerCase('vi')
            .replace(/\s+/gu, ' ') ?? null,
        ]),
      )
      .digest();
    const normalized = {
      kind: input.kind,
      needCode: need,
      templateId: input.templateId ?? null,
      title,
      durationMin: input.durationMin ?? null,
      childIds: [...(input.childIds ?? [])].sort(),
      dueKind: input.dueKind ?? null,
      dueAt: input.dueAt ?? null,
      urgency: input.urgency ?? 'NORMAL',
      message: input.message ?? null,
    };
    const requestHash = createHmac('sha256', this.key(scope, 'idempotency'))
      .update(JSON.stringify(normalized))
      .digest();
    // Replay before evaluating dates: a retry can arrive after the original due time.
    const replay = await this.repository.findReplay(
      scope,
      idempotencyKey,
      requestHash,
    );
    if (replay)
      return {
        request: this.project(replay.view, scope),
        openCount: replay.openCount,
        openLimit: POLICY.openLimit,
      };
    const dueAt =
      input.kind === 'TASK' ? requestDueAt(input, now, timezone) : null;
    const id = randomUUID();
    const aad = `request:${id}:couple:${scope.coupleSpaceId}`;
    const result = await this.repository.create(scope, {
      id,
      kind: input.kind,
      needCode: need,
      templateId: input.templateId ?? null,
      titleEnc: title ? this.encrypt(title, scope, `${aad}:title`) : null,
      durationMin: input.durationMin ?? null,
      contentKey,
      messageEnc:
        input.message == null
          ? null
          : this.encrypt(input.message, scope, `${aad}:message`),
      dueKind: input.kind === 'TASK' ? input.dueKind! : null,
      dueAt,
      urgency: input.urgency ?? 'NORMAL',
      talkAt: null,
      expiresAt: new Date(
        (dueAt ?? now).getTime() +
          (input.kind === 'TASK' ? POLICY.taskExpiryMs : POLICY.needExpiryMs),
      ),
      now,
      childIds: input.childIds ?? [],
      idempotencyKey,
      requestHash,
      idempotencyExpiresAt: new Date(now.getTime() + POLICY.maxDueMs),
    });
    return {
      request: this.project(result.view, scope),
      openCount: result.openCount,
      openLimit: POLICY.openLimit,
    };
  }
  async list(
    actor: AuthPrincipal,
    familyId: string,
    query: RequestListQueryDto,
  ) {
    const { scope } = await this.context(actor, familyId, 'read');
    const limit = query.limit ?? POLICY.defaultLimit;
    const rows = await this.repository.list(scope, { ...query, limit });
    return {
      items: rows.slice(0, limit).map((row) => this.project(row, scope)),
      nextCursor: rows.length > limit ? rows[limit - 1]!.request.id : null,
    };
  }
  async find(actor: AuthPrincipal, familyId: string, id: string) {
    const { scope } = await this.context(actor, familyId, 'read');
    const view = await this.repository.find(scope, id);
    if (!view)
      throw new DomainError('Request was not found.', 'REQUEST_NOT_FOUND', 404);
    this.participant(view, scope);
    return this.project(view, scope);
  }
  async act(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    action: CoupleRequestAction,
    input?: RequestActionInput,
  ) {
    const { scope } = await this.context(actor, familyId, 'write');
    const view = await this.repository.transition(scope, id, (row) => {
      this.participant(row, scope);
      const request = row.request;
      const senderAction = action === 'cancel';
      if (
        (senderAction ? request.senderUserId : request.receiverUserId) !==
        scope.userId
      )
        throw new DomainError(
          'Only the designated participant can perform this action.',
          'REQUEST_NOT_PARTICIPANT',
          403,
        );
      const now = new Date();
      const open =
        POLICY.openStatuses.includes(request.status) && request.expiresAt > now;
      const pending = request.status === 'SENT' || request.status === 'SEEN';
      const allowed =
        open &&
        (action === 'cancel' ||
          action === 'remind-me' ||
          (action === 'seen' && request.status === 'SENT') ||
          (action === 'accept' && pending && request.kind === 'TASK') ||
          (action === 'decline' && pending) ||
          (action === 'acknowledge' && pending && request.kind === 'NEED') ||
          (action === 'done' &&
            request.status === 'ACCEPTED' &&
            request.kind === 'TASK'));
      if (!allowed)
        throw new DomainError(
          'The request cannot perform this transition.',
          'INVALID_REQUEST_TRANSITION',
          409,
        );
      const mutation: RequestMutation = {
        eventType: `us.request.${action === 'remind-me' ? 'reminder_set' : action}`,
      };
      switch (action) {
        case 'seen':
          return { ...mutation, status: 'SEEN', seenAt: now };
        case 'accept':
          return { ...mutation, status: 'ACCEPTED', respondedAt: now };
        case 'decline':
          return {
            ...mutation,
            status: 'DECLINED',
            respondedAt: now,
            declineReason:
              input && 'reasonCode' in input
                ? (input.reasonCode ?? null)
                : null,
          };
        case 'cancel':
          return { ...mutation, status: 'CANCELLED', cancelledAt: now };
        case 'done':
          return { ...mutation, status: 'DONE', doneAt: now };
        case 'acknowledge': {
          if (!input || !('type' in input))
            throw new DomainError(
              'Acknowledgement type is required.',
              'REQUEST_CONTENT_INVALID',
              422,
            );
          const talkAt =
            input.type === 'TALK_TIME' ? futureDate(input.talkAt, now) : null;
          if (
            talkAt &&
            talkAt.getTime() > request.createdAt.getTime() + POLICY.maxDueMs
          )
            throw new DomainError(
              'Talk time exceeds the request horizon.',
              'REQUEST_DUE_INVALID',
              422,
            );
          return {
            ...mutation,
            status: 'ACKNOWLEDGED',
            respondedAt: now,
            ackType: input.type,
            talkAt,
          };
        }
        case 'remind-me': {
          if (request.reminderAt)
            throw new DomainError(
              'The reminder was already used.',
              'REQUEST_REMINDER_USED',
              409,
            );
          const at = futureDate(
            input && 'at' in input ? input.at : undefined,
            now,
          );
          if (at >= request.expiresAt)
            throw new DomainError(
              'Reminder must precede expiry.',
              'REQUEST_DUE_INVALID',
              422,
            );
          return { ...mutation, reminderAt: at };
        }
      }
    });
    return this.project(view, scope);
  }
  private participant(view: CoupleRequestView, scope: CoupleCheckinScope) {
    if (
      ![view.request.senderUserId, view.request.receiverUserId].includes(
        scope.userId,
      )
    )
      throw new DomainError(
        'The actor is not a request participant.',
        'REQUEST_NOT_PARTICIPANT',
        403,
      );
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
    view: CoupleRequestView,
    scope: CoupleCheckinScope,
  ): RequestViewDto {
    const row = view.request;
    const aad = `request:${row.id}:couple:${scope.coupleSpaceId}`;
    return {
      id: row.id,
      senderUserId: row.senderUserId,
      receiverUserId: row.receiverUserId,
      kind: row.kind,
      needCode: row.needCode,
      templateId: row.templateId,
      title: this.decrypt(row.titleEnc, scope, `${aad}:title`),
      durationMin: row.durationMin,
      childIds: view.childIds,
      message: this.decrypt(row.messageEnc, scope, `${aad}:message`),
      dueKind: row.dueKind,
      dueAt: row.dueAt?.toISOString() ?? null,
      urgency: row.urgency,
      status: row.status,
      volunteered: row.volunteered,
      declineReason: row.declineReason,
      ackType: row.ackType,
      talkAt: row.talkAt?.toISOString() ?? null,
      reminderAt: row.reminderAt?.toISOString() ?? null,
      ...(row.receiverUserId === scope.userId
        ? { heartsAwarded: row.heartsAwarded }
        : {}),
      selfMissionId: row.selfMissionId,
      seenAt: row.seenAt?.toISOString() ?? null,
      respondedAt: row.respondedAt?.toISOString() ?? null,
      doneAt: row.doneAt?.toISOString() ?? null,
      cancelledAt: row.cancelledAt?.toISOString() ?? null,
      expiresAt: row.expiresAt.toISOString(),
      createdAt: row.createdAt.toISOString(),
      updatedAt: row.updatedAt.toISOString(),
      version: row.version,
    };
  }
  /** Same configured key source as check-ins; purpose/couple separated HKDF keys. */
  private key(scope: CoupleCheckinScope, purpose = 'encryption'): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const master = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!master || master.length !== 32)
      throw new DomainError(
        'Couple encryption is unavailable.',
        'REQUEST_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return Buffer.from(
      hkdfSync(
        'sha256',
        master,
        'baby-family:us-request:v1',
        `${scope.coupleSpaceId}:${purpose}`,
        32,
      ),
    );
  }
  private encrypt(
    text: string,
    scope: CoupleCheckinScope,
    aad: string,
  ): Uint8Array {
    const iv = randomBytes(12),
      cipher = createCipheriv('aes-256-gcm', this.key(scope), iv);
    cipher.setAAD(Buffer.from(aad));
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
    value: Uint8Array | null,
    scope: CoupleCheckinScope,
    aad: string,
  ): string | null {
    if (value === null) return null;
    const key = this.key(scope);
    try {
      const data = Buffer.from(value);
      if (data.length < 29 || data[0] !== 1)
        throw new Error('Invalid envelope');
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        data.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(aad));
      decipher.setAuthTag(data.subarray(13, 29));
      return Buffer.concat([
        decipher.update(data.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'The encrypted request cannot be read.',
        'REQUEST_UNREADABLE',
        503,
      );
    }
  }
}
function futureDate(value: string | undefined, now: Date): Date {
  const date =
    value && /^\d{4}-\d\d-\d\dT.*(?:Z|[+-]\d\d:\d\d)$/u.test(value)
      ? new Date(value)
      : new Date(NaN);
  if (
    !Number.isFinite(date.getTime()) ||
    date <= now ||
    date.getTime() > now.getTime() + POLICY.maxDueMs
  )
    throw new DomainError(
      'The due time must be in the future and within seven days.',
      'REQUEST_DUE_INVALID',
      422,
    );
  return date;
}
/** Defaults use local calendar dates, including DST; explicit instants keep their offset. */
export function requestDueAt(
  input: CreateRequestDto,
  now: Date,
  timezone: string,
): Date {
  if (input.dueKind === 'NOW') {
    if (input.dueAt)
      throw new DomainError(
        'NOW cannot include a due time.',
        'REQUEST_DUE_INVALID',
        422,
      );
    return now;
  }
  if (
    input.dueKind === 'TODAY_AT' ||
    (input.dueKind === 'TOMORROW' && input.dueAt)
  ) {
    const due = futureDate(input.dueAt ?? undefined, now);
    const dateFormatter = new Intl.DateTimeFormat('en-CA', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    });
    const localDay = (date: Date) => {
      const parts = Object.fromEntries(
        dateFormatter
          .formatToParts(date)
          .map((part) => [part.type, part.value]),
      );
      return Date.UTC(
        Number(parts.year),
        Number(parts.month) - 1,
        Number(parts.day),
      );
    };
    const expected =
      localDay(now) + (input.dueKind === 'TOMORROW' ? 86_400_000 : 0);
    if (localDay(due) !== expected)
      throw new DomainError(
        'The due time does not match the selected local day.',
        'REQUEST_DUE_INVALID',
        422,
      );
    return due;
  }
  if (input.dueKind !== 'TONIGHT' && input.dueKind !== 'TOMORROW')
    throw new DomainError(
      'A TASK requires a due kind.',
      'REQUEST_DUE_INVALID',
      422,
    );
  if (input.dueAt)
    throw new DomainError(
      'TONIGHT uses the configured local hour.',
      'REQUEST_DUE_INVALID',
      422,
    );
  const fmt = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hourCycle: 'h23',
  });
  const parts = (date: Date) =>
    Object.fromEntries(fmt.formatToParts(date).map((p) => [p.type, p.value]));
  const p = parts(now);
  const target = Date.UTC(
    Number(p.year),
    Number(p.month) - 1,
    Number(p.day) + (input.dueKind === 'TOMORROW' ? 1 : 0),
    input.dueKind === 'TONIGHT' ? POLICY.tonightHour : POLICY.tomorrowHour,
  );
  let instant = target;
  for (let n = 0; n < 4; n++) {
    const local = parts(new Date(instant));
    const rendered = Date.UTC(
      Number(local.year),
      Number(local.month) - 1,
      Number(local.day),
      Number(local.hour),
      Number(local.minute),
      Number(local.second),
    );
    instant += target - rendered;
  }
  return futureDate(new Date(instant).toISOString(), now);
}
