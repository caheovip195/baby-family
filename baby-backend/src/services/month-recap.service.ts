import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { MONTH_RECAP_POLICY } from '../config/month-recap-policy';
import type {
  MonthRecapDto,
  MonthRecapQueryDto,
} from '../dto/memory/month-recap.dto';
import { MONTH_RECAP_REPOSITORY } from '../interfaces/repositories/month-recap-repository.interface';
import type { IMonthRecapRepository } from '../interfaces/repositories/month-recap-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IMonthRecapService } from '../interfaces/services/month-recap-service.interface';
import { ageInMonths } from './memory-content.service';

/**
 * REC-03 Tổng kết tháng tuổi (BF-20261027-003): tháng `m` là khoảng từ khi bé
 * tròn `m-1` tới khi tròn `m` tháng (ký ức có `age_month = m-1`), kèm ảnh
 * tháng `m` và `m-1`. Tính khi đọc theo quyền xem của người hỏi (Parent hoặc
 * người thân được cấp bé này); không lưu bản tổng kết.
 */
@Injectable()
export class MonthRecapService implements IMonthRecapService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MONTH_RECAP_REPOSITORY)
    private readonly repository: IMonthRecapRepository,
  ) {}

  async get(
    actor: AuthPrincipal,
    childId: string,
    query: MonthRecapQueryDto,
  ): Promise<MonthRecapDto> {
    const child = await this.repository.child(childId);
    if (!child) throw new NotFoundError('Child was not found.');
    if (!this.access.requireContentAccess)
      throw new DomainError(
        'Content access is unavailable.',
        'SERVICE_UNAVAILABLE',
        503,
      );
    const { family } = await this.access.requireContentAccess(
      actor,
      child.familyId,
      'read',
    );
    if (
      !(await this.repository.canSeeChild(
        child.familyId,
        actor.userId,
        child.id,
      ))
    )
      throw new NotFoundError('Child was not found.');
    const today = new Date(
      `${localDay(new Date(), family.timezone)}T00:00:00.000Z`,
    );
    const completed = ageInMonths(child.birthDate, today);
    if (completed < 1)
      throw new DomainError(
        'The first month is not complete yet.',
        'MONTH_RECAP_NOT_READY',
        404,
      );
    const month = query.monthIndex ?? completed;
    if (month > completed)
      throw new ValidationError('monthIndex must be a completed month.');
    const data = await this.repository.recap(
      child.familyId,
      actor.userId,
      child.id,
      month - 1,
      [month, month - 1],
      MONTH_RECAP_POLICY.highlightLimit,
    );
    const end = monthStart(child.birthDate, month);
    end.setUTCDate(end.getUTCDate() - 1);
    return {
      childId: child.id,
      monthIndex: month,
      start: day(monthStart(child.birthDate, month - 1)),
      end: day(end),
      moments: data.moments,
      firsts: data.firsts,
      voices: data.voices,
      firstMemoryIds: [...data.firstMemoryIds],
      voiceMemoryIds: [...data.voiceMemoryIds],
      currentPhoto: data.photos.get(month) ?? null,
      previousPhoto: data.photos.get(month - 1) ?? null,
    };
  }
}

/**
 * Ngày đầu tiên bé tròn [months] tháng — khớp `ageInMonths`: sinh ngày 31 thì
 * tháng chỉ có 30 ngày tính từ ngày 1 tháng sau.
 */
export function monthStart(birthDate: Date, months: number): Date {
  const year = birthDate.getUTCFullYear();
  const month = birthDate.getUTCMonth() + months;
  const birthDay = birthDate.getUTCDate();
  const daysInMonth = new Date(Date.UTC(year, month + 1, 0)).getUTCDate();
  return birthDay <= daysInMonth
    ? new Date(Date.UTC(year, month, birthDay))
    : new Date(Date.UTC(year, month + 1, 1));
}

function day(date: Date): string {
  return date.toISOString().slice(0, 10);
}

function localDay(now: Date, timezone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(now);
}
