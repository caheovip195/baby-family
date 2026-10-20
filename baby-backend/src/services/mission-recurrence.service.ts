import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import type {
  CreateMissionSeriesDto,
  MissionSeriesResponseDto,
  PauseMissionSeriesDto,
} from '../dto/mission/mission-recurrence.dto';
import { MISSION_RECURRENCE_REPOSITORY } from '../interfaces/repositories/mission-recurrence-repository.interface';
import type {
  IMissionRecurrenceRepository,
  MissionSeriesRow,
} from '../interfaces/repositories/mission-recurrence-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IMissionRecurrenceService } from '../interfaces/services/mission-recurrence-service.interface';
import { MissionRecurrenceModel } from '../models/mission-recurrence.model';
import { localMissionDate } from './mission-board.service';

const day = (value: string) => new Date(`${value}T00:00:00.000Z`);
const iso = (value: Date | null) => value?.toISOString().slice(0, 10) ?? null;

/**
 * Custom repeating missions (spec §7.13.6): only for MY or TOGETHER missions
 * (never the partner alone, BR-020), 2 Hearts each, outside the system board
 * quota. Missions are materialized per day when the board is laid out.
 */
@Injectable()
export class MissionRecurrenceService implements IMissionRecurrenceService {
  constructor(
    @Inject(MISSION_RECURRENCE_REPOSITORY)
    private readonly repository: IMissionRecurrenceRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateMissionSeriesDto,
  ): Promise<MissionSeriesResponseDto> {
    await this.access.requireParent(actor, familyId, 'write');
    const context = await this.repository.familyContext(familyId);
    if (!context) throw new NotFoundError('Family not found.');
    const ownerKind = input.owner === 'TOGETHER' ? 'TOGETHER' : 'PARENT';
    if (ownerKind === 'TOGETHER' && !context.coupleActive)
      throw new DomainError(
        'Papa & Mama space is not active.',
        'MISSION_OWNER_INVALID',
        422,
      );
    const childIds = input.childIds ?? [];
    if (childIds.some((id) => !context.childIds.includes(id)))
      throw new DomainError(
        'A child is not in this family.',
        'MISSION_SCOPE_INVALID',
        422,
      );
    const today = localMissionDate(new Date(), context.timezone);
    if (input.startDate < today || (input.endDate ?? '9999') < input.startDate)
      throw new DomainError(
        'The series dates are not valid.',
        'MISSION_SERIES_DATES_INVALID',
        422,
      );
    const row = await this.repository.create({
      familyId,
      createdBy: actor.userId,
      ownerKind,
      title: input.title.trim(),
      note: input.note?.trim() || null,
      category: input.category ?? 'CUSTOM',
      targetScope:
        childIds.length > 1
          ? 'MULTI_CHILD'
          : childIds.length
            ? 'CHILD'
            : 'FAMILY',
      childIds,
      timeOfDay: input.scheduledTime
        ? new Date(`1970-01-01T${input.scheduledTime}:00.000Z`)
        : null,
      startDate: day(input.startDate),
      endDate: input.endDate ? day(input.endDate) : null,
      rrule: MissionRecurrenceModel.toRrule(input.days),
      timezone: context.timezone,
    });
    return this.view(row, actor.userId);
  }

  async list(actor: AuthPrincipal, familyId: string) {
    await this.access.requireParent(actor, familyId, 'read');
    const rows = await this.repository.list(familyId);
    return {
      items: rows
        .filter((row) => this.visible(row, actor.userId))
        .map((row) => this.view(row, actor.userId)),
    };
  }

  async pause(
    actor: AuthPrincipal,
    seriesId: string,
    input: PauseMissionSeriesDto,
  ): Promise<MissionSeriesResponseDto> {
    const row = await this.editable(actor, seriesId);
    if (input.to < input.from)
      throw new DomainError(
        'The pause dates are not valid.',
        'MISSION_SERIES_DATES_INVALID',
        422,
      );
    const ranges = [
      ...MissionRecurrenceModel.pausedRanges(row.pausedRanges),
      { from: input.from, to: input.to },
    ];
    await this.repository.pause(seriesId, ranges);
    const paused = await this.repository.find(seriesId);
    return this.view(paused ?? row, actor.userId);
  }

  async end(actor: AuthPrincipal, seriesId: string): Promise<void> {
    const row = await this.editable(actor, seriesId);
    const context = await this.repository.familyContext(row.familyId);
    const today = localMissionDate(
      new Date(),
      context?.timezone ?? row.timezone,
    );
    // Today's and future TODO missions go; DONE ones stay in the history.
    await this.repository.end(seriesId, day(today));
  }

  /** Only the owner (or either Parent for TOGETHER) edits; others get 404. */
  private async editable(actor: AuthPrincipal, seriesId: string) {
    const row = await this.repository.find(seriesId);
    if (!row) throw new NotFoundError('Series not found.');
    await this.access.requireParent(actor, row.familyId, 'write');
    if (!this.visible(row, actor.userId))
      throw new NotFoundError('Series not found.');
    return row;
  }

  private visible(row: MissionSeriesRow, userId: string) {
    return row.ownerKind === 'TOGETHER' || row.ownerUserId === userId;
  }

  private view(
    row: MissionSeriesRow,
    userId: string,
  ): MissionSeriesResponseDto {
    return {
      id: row.id,
      title: row.title,
      note: row.note,
      ownerKind: row.ownerKind === 'TOGETHER' ? 'TOGETHER' : 'PARENT',
      mine: row.ownerUserId === userId,
      category: row.category,
      childIds: row.childIds,
      scheduledTime: row.timeOfDay?.toISOString().slice(11, 16) ?? null,
      startDate: iso(row.startDate)!,
      endDate: iso(row.endDate),
      days: MissionRecurrenceModel.days(row.rrule) ?? [],
      pausedRanges: MissionRecurrenceModel.pausedRanges(row.pausedRanges),
      status: row.status,
      version: row.version,
    };
  }
}
