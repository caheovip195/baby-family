import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import {
  pregnancyGestation,
  pregnancyLocale,
  decodeJourneyCursor,
  encodeJourneyCursor,
  PREGNANCY_JOURNEY_POLICY,
} from '../config/pregnancy-journey-policy';
import { PREGNANCY_JOURNEY_REPOSITORY } from '../interfaces/repositories/pregnancy-journey-repository.interface';
import type { IPregnancyJourneyRepository } from '../interfaces/repositories/pregnancy-journey-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../interfaces/services/memory-content-service.interface';
import type { IMemoryContentService } from '../interfaces/services/memory-content-service.interface';
import type { IPregnancyJourneyService } from '../interfaces/services/pregnancy-journey-service.interface';
import type {
  JourneyQueryDto,
  JourneyMemoriesQueryDto,
} from '../dto/pregnancy/journey-query.dto';
import type {
  JourneyResponseDto,
  JourneyWeekContent,
} from '../dto/pregnancy/journey-response.dto';
@Injectable()
export class PregnancyJourneyService implements IPregnancyJourneyService {
  constructor(
    @Inject(PREGNANCY_JOURNEY_REPOSITORY)
    private readonly repository: IPregnancyJourneyRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_CONTENT_SERVICE)
    private readonly content: IMemoryContentService,
  ) {}
  private async context(actor: AuthPrincipal, id: string) {
    const pregnancy = await this.repository.findPregnancy(id);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    const family = await this.access.requireParent(
      actor,
      pregnancy.familyId,
      'read',
    );
    return { pregnancy, family };
  }
  async journey(
    actor: AuthPrincipal,
    id: string,
    query: JourneyQueryDto,
    language?: string,
  ): Promise<JourneyResponseDto> {
    const { pregnancy, family } = await this.context(actor, id);
    if (
      query.week !== undefined &&
      (!Number.isInteger(query.week) || query.week < 4 || query.week > 42)
    )
      throw new ValidationError('Week must be between 4 and 42.');
    const gestation =
      pregnancy.dueDate && pregnancy.status === 'ACTIVE'
        ? pregnancyGestation(pregnancy.dueDate, new Date(), family.timezone)
        : {
            currentWeek: null,
            currentDay: null,
            daysLeft: null,
            trimester: null,
          };
    const number = query.week ?? gestation.currentWeek;
    const locale = pregnancyLocale(
      language,
      await this.repository.userLocale(actor.userId),
    );
    const item =
      number !== null && number >= 4 && number <= 42
        ? await this.repository.weekContent(number, locale)
        : null;
    const raw = item?.data;
    let content: JourneyWeekContent | null = null;
    if (
      raw &&
      typeof raw === 'object' &&
      !Array.isArray(raw) &&
      typeof raw.emoji === 'string' &&
      typeof raw.label === 'string' &&
      typeof raw.tip === 'string' &&
      typeof raw.lengthCm === 'number'
    )
      content = {
        emoji: raw.emoji,
        label: raw.label,
        tip: raw.tip,
        lengthCm: raw.lengthCm,
        ...(typeof raw.weightG === 'number' ? { weightG: raw.weightG } : {}),
      };
    return {
      pregnancyId: id,
      dueDate: pregnancy.dueDate?.toISOString().slice(0, 10) ?? null,
      ...gestation,
      week: {
        number,
        size:
          content && pregnancy.showSizeContent
            ? {
                emoji: content.emoji,
                label: content.label,
                lengthCm: content.lengthCm,
                ...(content.weightG === undefined
                  ? {}
                  : { weightG: content.weightG }),
              }
            : null,
        tip: content?.tip ?? null,
      },
    };
  }
  async memories(
    actor: AuthPrincipal,
    id: string,
    query: JourneyMemoriesQueryDto,
  ) {
    const { pregnancy, family } = await this.context(actor, id);
    const limit = query.limit ?? PREGNANCY_JOURNEY_POLICY.defaultLimit;
    const rows = await this.repository.memories(
      family.id,
      id,
      actor.userId,
      query.kind,
      query.cursor ? decodeJourneyCursor(query.cursor, id, query.kind) : null,
      limit,
    );
    const page = rows.slice(0, limit);
    const data = await Promise.all(
      page.map(async (row) => ({
        ...(await this.content.getById(actor, row.id)),
        week: pregnancy.dueDate
          ? pregnancyGestation(
              pregnancy.dueDate,
              row.occurredAt,
              family.timezone,
            ).currentWeek
          : null,
      })),
    );
    const last = page.at(-1);
    return {
      data,
      nextCursor:
        rows.length > limit && last
          ? encodeJourneyCursor(last, id, query.kind)
          : null,
    };
  }
}
