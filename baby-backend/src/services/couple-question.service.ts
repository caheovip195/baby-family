import {
  createCipheriv,
  createDecipheriv,
  createHash,
  hkdfSync,
  randomBytes,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, ValidationError } from '../common/errors/domain.error';
import {
  COUPLE_QUESTION_CATALOG,
  COUPLE_QUESTION_POLICY,
  type CoupleQuestion,
} from '../config/couple-question-catalog';
import type {
  AnswerCoupleQuestionDto,
  CoupleQuestionTodayDto,
  CoupleWeekDto,
  CoupleWeekQueryDto,
} from '../dto/us/couple-question.dto';
import { COUPLE_CHECKIN_REPOSITORY } from '../interfaces/repositories/couple-checkin-repository.interface';
import type { ICoupleCheckinRepository } from '../interfaces/repositories/couple-checkin-repository.interface';
import { COUPLE_QUESTION_REPOSITORY } from '../interfaces/repositories/couple-question-repository.interface';
import type { ICoupleQuestionRepository } from '../interfaces/repositories/couple-question-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { ICoupleQuestionService } from '../interfaces/services/couple-question-service.interface';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';

const DAY_MS = 86_400_000;

/**
 * Câu hỏi kết nối (US-01 khối 3) và US-14 Tuần của hai ta (BF-20261027-002).
 * Chỉ hai Parent của couple space đang hoạt động; câu trả lời của bạn đời chỉ
 * hiện khi cả hai đã trả lời câu của cùng ngày. Không có điểm, không chia số
 * liệu theo người.
 */
@Injectable()
export class CoupleQuestionService implements ICoupleQuestionService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(COUPLE_CHECKIN_REPOSITORY)
    private readonly pairs: ICoupleCheckinRepository,
    @Inject(COUPLE_QUESTION_REPOSITORY)
    private readonly repository: ICoupleQuestionRepository,
    private readonly config: ConfigService,
  ) {}

  async today(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<CoupleQuestionTodayDto> {
    const { scope, timezone } = await this.context(actor, familyId, 'read');
    return this.project(scope, localDay(new Date(), timezone));
  }

  async answer(
    actor: AuthPrincipal,
    familyId: string,
    input: AnswerCoupleQuestionDto,
  ): Promise<CoupleQuestionTodayDto> {
    const { scope, timezone } = await this.context(actor, familyId, 'write');
    const day = localDay(new Date(), timezone);
    const question = questionOf(scope.coupleSpaceId, day);
    await this.repository.saveAnswer(
      scope,
      dateOnly(day),
      question.code,
      this.encrypt(input.answer, scope, day),
    );
    return this.project(scope, day);
  }

  async week(
    actor: AuthPrincipal,
    familyId: string,
    query: CoupleWeekQueryDto,
  ): Promise<CoupleWeekDto> {
    const { scope, timezone } = await this.context(actor, familyId, 'read');
    const today = localDay(new Date(), timezone);
    const thisMonday = addDays(today, -(weekday(today) - 1));
    const monday = query.weekStart ?? thisMonday;
    if (
      !isValidDay(monday) ||
      weekday(monday) !== 1 ||
      monday > thisMonday ||
      daysBetween(monday, today) > COUPLE_QUESTION_POLICY.weekMaxLookbackDays
    )
      throw new ValidationError(
        'weekStart must be a Monday within the last year.',
      );
    const sunday = addDays(monday, 6);
    const counts = await this.repository.week(
      scope,
      zonedMidnight(monday, timezone),
      zonedMidnight(addDays(monday, 7), timezone),
      COUPLE_QUESTION_POLICY.weekTogetherLimit,
    );
    return {
      weekStart: monday,
      weekEnd: sunday,
      checkins: counts.checkins,
      requestsHelped: counts.requestsHelped,
      thanks: counts.thanks,
      togetherMissions: counts.togetherMissions,
      together: counts.together.map((item) => ({
        title: item.title,
        date: item.completedAt.toISOString(),
      })),
    };
  }

  private async project(
    scope: CoupleCheckinScope,
    day: string,
  ): Promise<CoupleQuestionTodayDto> {
    const question = questionOf(scope.coupleSpaceId, day);
    const answers = await this.repository.answers(scope, dateOnly(day));
    const mine = answers.find((row) => row.userId === scope.userId);
    const partner = answers.find((row) => row.userId === scope.partnerUserId);
    const read = (row: typeof mine) =>
      row ? this.decrypt(row.answerEnc, scope, day) : null;
    return {
      date: day,
      code: question.code,
      textI18n: { ...question.text },
      myAnswer: read(mine),
      partnerAnswered: partner !== undefined,
      // Chỉ hiện khi cả hai đã trả lời (đặc tả US-01 khối 3).
      partnerAnswer: mine && partner ? read(partner) : null,
    };
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
    const scope = await this.pairs.resolveScope(familyId, actor.userId);
    if (!scope)
      throw new DomainError(
        'Active couple space was not found.',
        'COUPLE_SPACE_NOT_FOUND',
        404,
      );
    return { scope, timezone: family.timezone };
  }

  /** AES-256-GCM v1; khoá dẫn xuất theo couple space, AAD gồm ngày. */
  private key(scope: CoupleCheckinScope): Buffer {
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const key = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!key || key.length !== 32)
      throw new DomainError(
        'A 32-byte base64 COUPLE_CHECKIN_ENCRYPTION_KEY is required.',
        'QUESTION_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return Buffer.from(
      hkdfSync(
        'sha256',
        key,
        'baby-family:us-question:v1',
        `couple:${scope.coupleSpaceId}`,
        32,
      ),
    );
  }

  private aad(scope: CoupleCheckinScope, day: string): Buffer {
    return Buffer.from(`question:${scope.coupleSpaceId}:${day}`);
  }

  private encrypt(
    answer: string,
    scope: CoupleCheckinScope,
    day: string,
  ): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(scope), iv);
    cipher.setAAD(this.aad(scope, day));
    const ciphertext = Buffer.concat([
      cipher.update(answer, 'utf8'),
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
    day: string,
  ): string {
    const key = this.key(scope);
    try {
      const bytes = Buffer.from(data);
      if (bytes[0] !== 1 || bytes.length < 30)
        throw new Error('Invalid envelope');
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        bytes.subarray(1, 13),
      );
      decipher.setAAD(this.aad(scope, day));
      decipher.setAuthTag(bytes.subarray(13, 29));
      return Buffer.concat([
        decipher.update(bytes.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'The encrypted answer cannot be read.',
        'QUESTION_ANSWER_UNREADABLE',
        503,
      );
    }
  }
}

/** Câu của ngày: cố định cho cả hai người, đổi theo ngày và theo cặp. */
export function questionOf(coupleSpaceId: string, day: string): CoupleQuestion {
  const questions = COUPLE_QUESTION_CATALOG.questions;
  const digest = createHash('sha256')
    .update(`${coupleSpaceId}:${day}`)
    .digest();
  return questions[digest.readUInt32BE(0) % questions.length]!;
}

/** Ngày hiện tại `YYYY-MM-DD` theo múi giờ gia đình. */
export function localDay(now: Date, timezone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(now);
}

/** Thời điểm 00:00 của ngày [day] tại [timezone] (đúng cả khi đổi giờ DST). */
export function zonedMidnight(day: string, timezone: string): Date {
  const base = Date.parse(`${day}T00:00:00Z`);
  let guess = base;
  for (let i = 0; i < 3; i++) {
    const parts = new Intl.DateTimeFormat('en-US', {
      timeZone: timezone,
      hourCycle: 'h23',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    }).formatToParts(new Date(guess));
    const get = (type: string) =>
      Number(parts.find((part) => part.type === type)?.value);
    const shown = Date.UTC(
      get('year'),
      get('month') - 1,
      get('day'),
      get('hour'),
      get('minute'),
      get('second'),
    );
    const next = guess - (shown - base);
    if (next === guess) break;
    guess = next;
  }
  return new Date(guess);
}

function dateOnly(day: string): Date {
  return new Date(`${day}T00:00:00.000Z`);
}

function addDays(day: string, days: number): string {
  return new Date(dateOnly(day).getTime() + days * DAY_MS)
    .toISOString()
    .slice(0, 10);
}

/** 1 = thứ Hai … 7 = Chủ nhật. */
function weekday(day: string): number {
  return ((dateOnly(day).getUTCDay() + 6) % 7) + 1;
}

function daysBetween(from: string, to: string): number {
  return Math.round(
    (dateOnly(to).getTime() - dateOnly(from).getTime()) / DAY_MS,
  );
}

function isValidDay(day: string): boolean {
  const date = dateOnly(day);
  return !Number.isNaN(date.getTime()) && date.toISOString().startsWith(day);
}
