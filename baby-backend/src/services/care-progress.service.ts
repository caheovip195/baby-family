import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { CARE_PROGRESS_POLICY } from '../config/care-progress-policy';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { CARE_PROGRESS_REPOSITORY } from '../interfaces/repositories/care-progress-repository.interface';
import type {
  CareMissionHistoryRow,
  ICareProgressRepository,
} from '../interfaces/repositories/care-progress-repository.interface';
import type { ICareProgressService } from '../interfaces/services/care-progress-service.interface';
import type {
  HeartsMeQueryDto,
  HeartsMeResponseDto,
} from '../dto/care/hearts-me.dto';
import type { FamilyTreeResponseDto } from '../dto/care/family-tree.dto';
import type {
  CareBadgeDto,
  CareBadgesResponseDto,
} from '../dto/care/care-badge.dto';
import type {
  CareMissionHistoryQueryDto,
  CareMissionHistoryResponseDto,
} from '../dto/care/care-mission-history.dto';
import type {
  MyMissionDto,
  PartnerMissionDto,
} from '../dto/mission/mission.dto';

function localMissionDate(now: Date, timezone: string): string {
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
  return `${parts.year}-${parts.month}-${parts.day}`;
}

@Injectable()
export class CareProgressService implements ICareProgressService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(CARE_PROGRESS_REPOSITORY)
    private readonly repository: ICareProgressRepository,
  ) {}

  async getHeartsMe(
    actor: AuthPrincipal,
    familyId: string,
    query: HeartsMeQueryDto,
  ): Promise<HeartsMeResponseDto> {
    if ('userId' in (query as Record<string, unknown>)) {
      throw new DomainError(
        'Query parameter userId is not allowed.',
        'USER_ID_NOT_ALLOWED',
        400,
      );
    }
    const family = await this.context(actor, familyId);
    const todayStr = localMissionDate(new Date(), family.timezone);
    const todayDate = new Date(`${todayStr}T00:00:00.000Z`);

    const snapshot = await this.repository.getHeartsMe(
      familyId,
      actor.userId,
      todayDate,
      query.cursor,
      query.limit,
    );

    return {
      today: snapshot.today,
      week: snapshot.week,
      total: snapshot.total,
      dailyCap: snapshot.dailyCap,
      history: snapshot.history.map((item) => ({
        at: item.createdAt.toISOString(),
        amount: item.amount,
        reason: item.reason,
        title: item.title,
      })),
      nextCursor: snapshot.nextCursor,
    };
  }

  async getFamilyTree(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyTreeResponseDto> {
    const family = await this.context(actor, familyId);
    const todayStr = localMissionDate(new Date(), family.timezone);
    const todayDate = new Date(`${todayStr}T00:00:00.000Z`);

    const dayOfWeek = todayDate.getUTCDay();
    const mondayOffset = (dayOfWeek + 6) % 7;
    const weekStartDate = new Date(
      todayDate.getTime() - mondayOffset * 86_400_000,
    );
    const weekEndDate = new Date(weekStartDate.getTime() + 6 * 86_400_000);

    const snapshot = await this.repository.getFamilyTree(
      familyId,
      todayDate,
      weekStartDate,
      weekEndDate,
    );

    return {
      level: snapshot.level,
      levelName: snapshot.levelName,
      progressPercent: snapshot.progressPercent,
      fruits: snapshot.fruits,
      flowers: snapshot.flowers,
      bloomedDaysThisWeek: snapshot.bloomedDaysThisWeek,
      today: snapshot.today,
    };
  }

  async getBadges(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<CareBadgesResponseDto> {
    await this.context(actor, familyId);
    const evaluations = await this.repository.getBadges(familyId);

    const items: CareBadgeDto[] = evaluations.map((item) => ({
      code: item.code,
      title: item.titleI18n.vi || item.code,
      titleI18n: item.titleI18n,
      description: item.descI18n.vi || '',
      descI18n: item.descI18n,
      icon: item.icon,
      scope: item.scope,
      earned: item.achieved,
      achieved: item.achieved,
      achievedAt: item.achievedAt?.toISOString() ?? null,
      progress: {
        current: item.current,
        target: item.target,
        percent: item.percent,
      },
    }));

    return { items };
  }

  async getMissionHistory(
    actor: AuthPrincipal,
    familyId: string,
    query: CareMissionHistoryQueryDto,
  ): Promise<CareMissionHistoryResponseDto> {
    if (query.from && query.to) {
      const fromDate = new Date(`${query.from}T00:00:00.000Z`);
      const toDate = new Date(`${query.to}T00:00:00.000Z`);
      if (Number.isNaN(fromDate.getTime()) || Number.isNaN(toDate.getTime())) {
        throw new DomainError(
          'Invalid date format.',
          'MISSION_DATE_RANGE_INVALID',
          400,
        );
      }
      if (fromDate.getTime() > toDate.getTime()) {
        throw new DomainError(
          'from must be before or equal to to.',
          'MISSION_DATE_RANGE_INVALID',
          400,
        );
      }
      const days =
        Math.round((toDate.getTime() - fromDate.getTime()) / 86_400_000) + 1;
      if (days > CARE_PROGRESS_POLICY.maxMissionHistoryDays) {
        throw new DomainError(
          'Mission history query range cannot exceed 92 days.',
          'MISSION_DATE_RANGE_INVALID',
          400,
        );
      }
    } else if (query.from && !query.to) {
      const fromDate = new Date(`${query.from}T00:00:00.000Z`);
      const now = new Date();
      if (
        Math.round((now.getTime() - fromDate.getTime()) / 86_400_000) >
        CARE_PROGRESS_POLICY.maxMissionHistoryDays
      ) {
        throw new DomainError(
          'Mission history query range cannot exceed 92 days.',
          'MISSION_DATE_RANGE_INVALID',
          400,
        );
      }
    }

    await this.context(actor, familyId);
    const { items, nextCursor } = await this.repository.getMissionHistory(
      familyId,
      actor.userId,
      query,
    );

    return {
      items: items.map((item) => this.projectMission(item, actor.userId)),
      nextCursor,
    };
  }

  private async context(actor: AuthPrincipal, familyId: string) {
    const family = await this.access.requireParent(actor, familyId, 'read');
    if (family.status !== 'ACTIVE') {
      throw new DomainError('Family is not active.', 'FAMILY_NOT_ACTIVE', 403);
    }
    return family;
  }

  private projectMission(
    row: CareMissionHistoryRow,
    userId: string,
  ): MyMissionDto | PartnerMissionDto {
    const m = row.mission;
    if (m.ownerKind === 'TOGETHER' || m.ownerUserId === userId) {
      return {
        id: m.id,
        familyId: m.familyId,
        boardDate: m.boardDate.toISOString().slice(0, 10),
        ownerKind: m.ownerKind,
        mine: m.ownerUserId === userId,
        source: m.source,
        templateId: m.templateId,
        title: m.title,
        note: m.note,
        category: m.category,
        targetScope: m.targetScope,
        childIds: row.childIds,
        hearts: m.hearts,
        status: m.status,
        scheduledTime: m.scheduledTime?.toISOString().slice(11, 19) ?? null,
        dueAt: m.dueAt?.toISOString() ?? null,
        completedAt: m.completedAt?.toISOString() ?? null,
        late: m.late,
        canSwap: m.source === 'SYSTEM' && m.status === 'TODO',
        version: m.version,
        events: row.events.map((e) => ({
          type: e.type,
          createdAt: e.createdAt.toISOString(),
        })),
      };
    }
    return {
      id: m.id,
      title: m.title,
      category: m.category,
      childIds: row.childIds,
      status: m.status as 'TODO' | 'DONE',
      completedAt: m.completedAt?.toISOString() ?? null,
      late: m.late,
      thanked: false,
    };
  }
}
