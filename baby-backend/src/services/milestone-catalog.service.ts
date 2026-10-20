import { Inject, Injectable } from '@nestjs/common';
import { z } from 'zod';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { solarToLunar, lunarToSolar } from '../common/time/lunar-calendar';
import { MILESTONE_POLICY } from '../config/milestone-policy';
import type {
  MilestoneCatalogQueryDto,
  MilestoneListQueryDto,
} from '../dto/milestone/milestone-query.dto';
import type {
  MilestoneCatalogResponseDto,
  MilestoneListResponseDto,
} from '../dto/milestone/milestone-response.dto';
import { MILESTONE_CATALOG_REPOSITORY } from '../interfaces/repositories/milestone-catalog-repository.interface';
import type {
  IMilestoneCatalogRepository,
  MilestoneSubjectContext,
} from '../interfaces/repositories/milestone-catalog-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IMilestoneCatalogService } from '../interfaces/services/milestone-catalog-service.interface';
import type { DatabaseJsonValue } from '../common/database.types';
const cursorSchema = z.object({
  route: z.literal('milestones'),
  d: z.iso.date(),
  i: z.uuid(),
});
const dateRuleSchema = z.discriminatedUnion('type', [
  z.object({
    type: z.literal('LUNAR_FESTIVAL'),
    month: z.number().int().min(1).max(12),
    day: z.number().int().min(1).max(29),
  }),
  z.object({
    type: z.literal('BIRTH_MONTHS'),
    months: z.number().int().nonnegative(),
  }),
  z.object({
    type: z.literal('BIRTH_DAYS'),
    days: z.number().int().nonnegative(),
  }),
]);
@Injectable()
export class MilestoneCatalogService implements IMilestoneCatalogService {
  constructor(
    @Inject(MILESTONE_CATALOG_REPOSITORY)
    private readonly repository: IMilestoneCatalogRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async catalog(
    actor: AuthPrincipal,
    query: MilestoneCatalogQueryDto,
  ): Promise<MilestoneCatalogResponseDto> {
    if (query.childId && query.pregnancyId)
      throw new ValidationError('Choose one subject.');
    const id = query.childId ?? query.pregnancyId;
    const subject = id
      ? await this.requireSubject(actor, id, !!query.pregnancyId)
      : null;
    const templates = await this.repository.templates(subject?.pregnancy);
    const achieved = subject
      ? await this.repository.records(
          subject,
          actor.userId,
          !subject.parent,
          null,
        )
      : [];
    const categories: MilestoneCatalogResponseDto['categories'] = [];
    for (const template of templates) {
      let group = categories.find(
        (item) => item.category === template.category,
      );
      if (!group) {
        group = { category: template.category, templates: [] };
        categories.push(group);
      }
      const record = achieved.find(
        (item) => item.milestone.templateCode === template.code,
      )?.milestone;
      group.templates.push({
        code: template.code,
        icon: template.icon,
        titleI18n: template.titleI18n,
        promptI18n: template.promptI18n,
        isTraditional: template.isTraditional,
        dateRule: template.dateRule,
        suggestedDate: suggestedDate(
          template.dateRule,
          subject?.birthDate ?? null,
          template.isTraditional && !!subject?.traditionalUseLunar,
        ),
        achieved: record
          ? {
              milestoneId: record.id,
              memoryId: record.memoryId,
              occurredOn: record.occurredOn.toISOString().slice(0, 10),
            }
          : null,
      });
    }
    return { categories };
  }
  async list(
    actor: AuthPrincipal,
    id: string,
    pregnancy: boolean,
    query: MilestoneListQueryDto,
  ): Promise<MilestoneListResponseDto> {
    const subject = await this.requireSubject(actor, id, pregnancy);
    let after = null;
    if (query.cursor) {
      try {
        const value = cursorSchema.parse(
          JSON.parse(Buffer.from(query.cursor, 'base64url').toString('utf8')),
        );
        after = { occurredOn: new Date(value.d), id: value.i };
      } catch {
        throw new ValidationError('cursor is invalid.');
      }
    }
    const limit = query.limit ?? MILESTONE_POLICY.defaultLimit;
    const rows = await this.repository.records(
      subject,
      actor.userId,
      !subject.parent,
      after,
      limit,
    );
    const page = rows.slice(0, limit);
    const last = page.at(-1)?.milestone;
    return {
      data: page.map(({ milestone, memory, coverAssetId }) => ({
        milestoneId: milestone.id,
        memoryId: milestone.memoryId,
        occurredOn: milestone.occurredOn.toISOString().slice(0, 10),
        templateCode: milestone.templateCode,
        customTitle: milestone.customTitle,
        memory: {
          id: memory.id,
          title: memory.title,
          kind: memory.kind,
          occurredAt: memory.occurredAt.toISOString(),
          coverAssetId,
        },
      })),
      nextCursor:
        rows.length > limit && last
          ? Buffer.from(
              JSON.stringify({
                route: 'milestones',
                d: last.occurredOn.toISOString().slice(0, 10),
                i: last.id,
              }),
            ).toString('base64url')
          : null,
    };
  }
  private async requireSubject(
    actor: AuthPrincipal,
    id: string,
    pregnancy: boolean,
  ): Promise<MilestoneSubjectContext> {
    const subject = await this.repository.subject(id, pregnancy, actor.userId);
    if (!subject) throw new NotFoundError('Subject was not found.');
    if (subject.parent)
      await this.access.requireParent(actor, subject.familyId, 'read');
    else {
      const circle = subject.circle;
      if (!circle) throw new NotFoundError('Subject was not found.');
      if (!circle.active)
        throw new DomainError(
          'Circle membership is inactive.',
          'CIRCLE_INACTIVE',
          403,
        );
      if (!circle.granted) throw new NotFoundError('Subject was not found.');
      if (!circle.enabled || !circle.familyActive || !circle.licensed)
        throw new DomainError(
          'Circle access is unavailable.',
          'CIRCLE_ACCESS_DENIED',
          403,
        );
    }
    return subject;
  }
}
function suggestedDate(
  rule: DatabaseJsonValue | null,
  birth: Date | null,
  lunar: boolean,
): string | null {
  const result = dateRuleSchema.safeParse(rule);
  if (!birth || !result.success) return null;
  const value = result.data;
  if (value.type === 'LUNAR_FESTIVAL') {
    const born = solarToLunar(
      birth.getUTCDate(),
      birth.getUTCMonth() + 1,
      birth.getUTCFullYear(),
    );
    for (const year of [born.year, born.year + 1]) {
      const festival = lunarToSolar(value.day, value.month, year);
      const date = new Date(
        Date.UTC(festival.year, festival.month - 1, festival.day),
      );
      if (date >= birth) return date.toISOString().slice(0, 10);
    }
    return null;
  }
  if (value.type === 'BIRTH_DAYS')
    return new Date(birth.getTime() + value.days * 86400000)
      .toISOString()
      .slice(0, 10);
  if (lunar) {
    const original = solarToLunar(
      birth.getUTCDate(),
      birth.getUTCMonth() + 1,
      birth.getUTCFullYear(),
    );
    const total = original.month - 1 + value.months;
    let target = lunarToSolar(
      original.day,
      (total % 12) + 1,
      original.year + Math.floor(total / 12),
    );
    const roundtrip = solarToLunar(target.day, target.month, target.year);
    if (
      roundtrip.month !== (total % 12) + 1 ||
      roundtrip.day !== original.day
    ) {
      target = lunarToSolar(
        original.day - 1,
        (total % 12) + 1,
        original.year + Math.floor(total / 12),
      );
    }
    return new Date(Date.UTC(target.year, target.month - 1, target.day))
      .toISOString()
      .slice(0, 10);
  }
  const first = new Date(
    Date.UTC(birth.getUTCFullYear(), birth.getUTCMonth() + value.months, 1),
  );
  const last = new Date(
    Date.UTC(first.getUTCFullYear(), first.getUTCMonth() + 1, 0),
  ).getUTCDate();
  first.setUTCDate(Math.min(birth.getUTCDate(), last));
  return first.toISOString().slice(0, 10);
}
