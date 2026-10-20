import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import { WEEKLY_RECAP_POLICY } from '../config/weekly-recap-policy';
import type {
  WeeklyRecapQueryDto,
  WeeklyRecapResponse,
} from '../dto/recap/weekly-recap.dto';
import {
  WEEKLY_RECAP_REPOSITORY,
  type IWeeklyRecapRepository,
} from '../interfaces/repositories/weekly-recap-repository.interface';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type { IWeeklyRecapService } from '../interfaces/services/weekly-recap-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
export function shiftWeekDate(day: string, days: number): string {
  const date = new Date(day);
  date.setUTCDate(date.getUTCDate() + days);
  return date.toISOString().slice(0, 10);
}
export function weekStart(now: Date, timezone: string): string {
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(now);
  const val = (key: string) => parts.find((p) => p.type === key)!.value;
  const day = val('year') + '-' + val('month') + '-' + val('day');
  return shiftWeekDate(day, -((new Date(day).getUTCDay() + 6) % 7));
}
@Injectable()
export class WeeklyRecapService implements IWeeklyRecapService {
  constructor(
    @Inject(WEEKLY_RECAP_REPOSITORY)
    private readonly repository: IWeeklyRecapRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async build(now: Date, context: JobContext) {
    let after: string | undefined;
    let built = 0,
      skipped = 0;
    do {
      const families = await this.repository.families(after);
      if (!families.length) break;
      for (const family of families) {
        context.signal.throwIfAborted();
        const current = weekStart(now, family.timezone);
        for (
          let offset = 1;
          offset <= WEEKLY_RECAP_POLICY.catchUpWeeks;
          offset++
        ) {
          const start = shiftWeekDate(current, -7 * offset),
            end = shiftWeekDate(start, 6);
          const result = await this.repository.aggregate(
            family.id,
            start,
            end,
            family.timezone,
          );
          context.signal.throwIfAborted();
          if (!result.hasData()) {
            skipped++;
            continue;
          }
          await this.repository.save(family.id, start, end, result, context);
          built++;
        }
      }
      after = families.at(-1)!.id;
      if (families.length < WEEKLY_RECAP_POLICY.batchSize) break;
    } while (after);
    return { built, skipped };
  }
  private async viewer(actor: AuthPrincipal, familyId: string) {
    if (this.access.requireContentAccess)
      return this.access.requireContentAccess(actor, familyId, 'read');
    return {
      family: await this.access.requireParent(actor, familyId, 'read'),
      isParent: true,
    };
  }
  async list(
    actor: AuthPrincipal,
    familyId: string,
    query: WeeklyRecapQueryDto,
  ) {
    if (
      query.cursor &&
      (Number.isNaN(Date.parse(query.cursor)) ||
        new Date(query.cursor).toISOString().slice(0, 10) !== query.cursor)
    )
      throw new ValidationError('Invalid recap cursor.');
    const viewer = await this.viewer(actor, familyId);
    const rows = await this.repository.list(
      familyId,
      !viewer.isParent,
      query.cursor,
      query.limit + 1,
    );
    const items: WeeklyRecapResponse[] = [];
    for (const row of rows.slice(0, query.limit)) {
      const start = row.periodStart.toISOString().slice(0, 10),
        end = row.periodEnd.toISOString().slice(0, 10);
      const result = await this.repository.aggregate(
        familyId,
        start,
        end,
        viewer.family.timezone,
        { userId: actor.userId, isParent: viewer.isParent },
      );
      items.push({
        id: row.id,
        periodStart: start,
        periodEnd: end,
        visibility: row.visibility,
        content: result.content(),
        coverAssetId: result.coverAssetId,
        ...(viewer.isParent
          ? {
              contentParentsOnly: {
                version: 1,
                appreciationCount: result.appreciationCount,
              },
            }
          : {}),
      });
    }
    return {
      items,
      nextCursor: rows.length > query.limit ? items.at(-1)!.periodStart : null,
    };
  }
  async latest(actor: AuthPrincipal, familyId: string) {
    const page = await this.list(actor, familyId, { limit: 1 });
    if (!page.items[0]) throw new NotFoundError('Weekly recap was not found.');
    return page.items[0];
  }
  async stats(actor: AuthPrincipal, familyId: string) {
    const viewer = await this.viewer(actor, familyId);
    const start = weekStart(new Date(), viewer.family.timezone);
    return (
      await this.repository.aggregate(
        familyId,
        start,
        shiftWeekDate(start, 6),
        viewer.family.timezone,
        {
          userId: actor.userId,
          isParent: viewer.isParent,
          includePrivate: true,
        },
      )
    ).stats;
  }
}
