import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { MissionCategory } from '../common/database.enums';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { CARE_STATS_POLICY } from '../config/care-stats-policy';
import type {
  CareStatsQueryDto,
  CareStatsResponseDto,
} from '../dto/care/care-stats.dto';
import {
  CARE_STATS_REPOSITORY,
  type ICareStatsRepository,
} from '../interfaces/repositories/care-stats-repository.interface';
import {
  CATALOG_QUERY_REPOSITORY,
  type ICatalogQueryRepository,
} from '../interfaces/repositories/catalog-query-repository.interface';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type { ICareStatsService } from '../interfaces/services/care-stats-service.interface';

const DAY_MS = 86_400_000;
const dateLabel = (date: Date) => date.toISOString().slice(0, 10);

@Injectable()
export class CareStatsService implements ICareStatsService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(CATALOG_QUERY_REPOSITORY)
    private readonly catalog: ICatalogQueryRepository,
    @Inject(CARE_STATS_REPOSITORY)
    private readonly repository: ICareStatsRepository,
  ) {}

  async get(
    actor: AuthPrincipal,
    familyId: string,
    query: CareStatsQueryDto,
  ): Promise<CareStatsResponseDto> {
    const family = await this.access.requireParent(actor, familyId, 'read');
    if (family.status !== 'ACTIVE')
      throw new DomainError('Family is not active.', 'FAMILY_NOT_ACTIVE', 403);

    const now = new Date();
    const state = await this.catalog.findFamilyBillingState(
      familyId,
      actor.userId,
      now,
    );
    if (!state) throw new NotFoundError('Family was not found.');
    if (state.licenseBlocked || state.entitlement?.accessPhase === 'BLOCKED')
      throw new DomainError(
        'Family license is blocked.',
        'LICENSE_BLOCKED',
        403,
      );
    const entitlement = state.entitlement;
    const features = state.effectivePlan?.features;
    if (
      !entitlement ||
      !['PAID', 'TRIAL'].includes(entitlement.accessPhase) ||
      !entitlement.validUntil ||
      entitlement.validUntil <= now ||
      (entitlement.accessPhase === 'TRIAL' &&
        (!entitlement.trialEndsAt || entitlement.trialEndsAt <= now)) ||
      !features ||
      typeof features !== 'object' ||
      Array.isArray(features) ||
      features[CARE_STATS_POLICY.feature] !== true
    )
      throw new DomainError(
        'The subscription does not include care statistics.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );

    const weekStart = this.weekStart(query.weekStart, family.timezone, now);
    const weekEndExclusive = new Date(weekStart.getTime() + 7 * DAY_MS);
    const snapshot = await this.repository.readWeek(
      familyId,
      weekStart,
      weekEndExclusive,
      query.childId,
    );
    if (!snapshot) throw new NotFoundError('Child was not found.');
    const counts = new Map(
      snapshot.categories.map((row) => [row.code, row.count]),
    );
    const categories = Object.values(MissionCategory)
      .filter((code) => code !== 'COUPLE')
      .map((code) => ({ code, count: counts.get(code) ?? 0 }));
    const bloomedDates = new Set(snapshot.bloomedDates.map(dateLabel));
    const bloomed = Array.from({ length: 7 }, (_, index) =>
      bloomedDates.has(
        dateLabel(new Date(weekStart.getTime() + index * DAY_MS)),
      ),
    );
    return {
      weekStart: dateLabel(weekStart),
      weekEnd: dateLabel(new Date(weekEndExclusive.getTime() - DAY_MS)),
      total: categories.reduce((total, row) => total + row.count, 0),
      categories,
      bloomDays: bloomed.filter(Boolean).length,
      bloomed,
    };
  }

  private weekStart(
    value: string | undefined,
    timezone: string,
    now: Date,
  ): Date {
    const parts = Object.fromEntries(
      new Intl.DateTimeFormat('en-CA', {
        timeZone: timezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      })
        .formatToParts(now)
        .map((part) => [part.type, part.value]),
    );
    // Date-only values label family calendar days; UTC arithmetic avoids DST drift.
    const today = new Date(
      `${parts.year}-${parts.month}-${parts.day}T00:00:00Z`,
    );
    const currentMonday = new Date(
      today.getTime() - ((today.getUTCDay() + 6) % 7) * DAY_MS,
    );
    if (value === undefined) return currentMonday;
    const date = new Date(`${value}T00:00:00Z`);
    if (
      !/^\d{4}-\d{2}-\d{2}$/.test(value) ||
      Number.isNaN(date.getTime()) ||
      dateLabel(date) !== value ||
      date.getUTCDay() !== 1
    )
      throw new DomainError(
        'weekStart must be a valid Monday (YYYY-MM-DD).',
        'CARE_STATS_WEEK_INVALID',
        400,
      );
    if (
      Math.abs(date.getTime() - currentMonday.getTime()) / DAY_MS >
      CARE_STATS_POLICY.maxWeekDistanceDays
    )
      throw new DomainError(
        'weekStart is outside the supported range.',
        'CARE_STATS_RANGE_INVALID',
        400,
      );
    return date;
  }
}
