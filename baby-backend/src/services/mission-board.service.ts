import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { MISSION_POLICY } from '../config/mission-policy';
import { requireMissionOwner } from '../models/mission-board-state.model';
import type {
  CreateMissionDto,
  CreateMissionResponseDto,
  CompleteMissionDto,
  MissionActionResponseDto,
  MissionBoardQueryDto,
  MissionBoardResponseDto,
  MissionTemplateQueryDto,
  MyMissionDto,
  PartnerMissionDto,
  SwapMissionDto,
} from '../dto/mission/mission.dto';
import { MISSION_BOARD_REPOSITORY } from '../interfaces/repositories/mission-board-repository.interface';
import type { IMissionBoardRepository } from '../interfaces/repositories/mission-board-repository.interface';
import { COUPLE_REQUEST_REPOSITORY } from '../interfaces/repositories/couple-request-repository.interface';
import type { ICoupleRequestRepository } from '../interfaces/repositories/couple-request-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type {
  IMissionBoardService,
  MissionBoardAction,
} from '../interfaces/services/mission-board-service.interface';
import type { MissionBoardView } from '../models/mission-board-view.model';

@Injectable()
export class MissionBoardService implements IMissionBoardService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MISSION_BOARD_REPOSITORY)
    private readonly repository: IMissionBoardRepository,
    @Inject(COUPLE_REQUEST_REPOSITORY)
    private readonly requests: ICoupleRequestRepository,
  ) {}

  async board(
    actor: AuthPrincipal,
    familyId: string,
    query: MissionBoardQueryDto,
  ): Promise<MissionBoardResponseDto> {
    const family = await this.context(actor, familyId, 'read');
    const today = localMissionDate(new Date(), family.timezone);
    const date = validMissionDate(query.date ?? today);
    const snapshot = await this.repository.board(
      familyId,
      actor.userId,
      date,
      today,
    );
    const items = snapshot.items.filter(
      (item) =>
        item.mission.status !== 'REMOVED' &&
        (!query.childId || item.childIds.includes(query.childId)),
    );
    const mine = items.filter(
      (item) =>
        item.mission.ownerKind === 'PARENT' &&
        item.mission.ownerUserId === actor.userId,
    );
    const partner = items.filter(
      (item) =>
        item.mission.ownerKind === 'PARENT' &&
        item.mission.ownerUserId !== actor.userId &&
        ['TODO', 'DONE'].includes(item.mission.status),
    );
    const together = items.filter(
      (item) => item.mission.ownerKind === 'TOGETHER',
    );
    const count = (rows: MissionBoardView[]) => ({
      done: rows.filter((item) => item.mission.status === 'DONE').length,
      total: rows.length,
    });
    const tab = query.tab ?? 'MINE';
    const selected =
      tab === 'MINE' ? mine : tab === 'PARTNER' ? partner : together;
    const scope = await this.requests.resolveScope(familyId, actor.userId);
    const open = scope
      ? await this.requests.list(scope, { box: 'OPEN', limit: 10000 })
      : [];
    return {
      date,
      level: snapshot.board?.level ?? null,
      tree: {
        leaves: snapshot.items.filter((item) => item.mission.status === 'DONE')
          .length,
        total: snapshot.items.length,
        bloomed: snapshot.board?.bloomedAt != null,
      },
      tabs: {
        mine: count(mine),
        partner: count(partner),
        together: count(together),
      },
      items: selected.map((item) => this.project(item, actor.userId)),
      ...(tab === 'MINE' ? { myHeartsToday: snapshot.myHeartsToday } : {}),
      ...(tab !== 'PARTNER'
        ? {
            swapsLeft: Math.max(
              0,
              MISSION_POLICY.swapsPerDay - snapshot.swapsUsed,
            ),
          }
        : {}),
      openRequestCount: open.filter(
        (item) =>
          item.request.senderUserId === actor.userId &&
          !item.request.volunteered,
      ).length,
    };
  }

  async find(actor: AuthPrincipal, id: string) {
    const family = await this.missionContext(actor, id, 'read');
    const view = await this.repository.find(id);
    const expired =
      view?.mission.status === 'TODO' &&
      view.mission.boardDate.toISOString().slice(0, 10) <
        localMissionDate(new Date(), family.timezone);
    if (
      !view ||
      view.mission.status === 'REMOVED' ||
      (view.mission.ownerKind === 'PARENT' &&
        view.mission.ownerUserId !== actor.userId &&
        (view.mission.status === 'EXPIRED' || expired))
    )
      throw new DomainError('Mission was not found.', 'MISSION_NOT_FOUND', 404);
    if (expired)
      return {
        ...this.projectMine(view, actor.userId),
        status: 'EXPIRED',
        canSwap: false,
      };
    return this.project(view, actor.userId);
  }

  async templates(actor: AuthPrincipal, query: MissionTemplateQueryDto) {
    const familyId =
      query.familyId ??
      (await this.repository.familyIdForActor(actor.userId, query.childId));
    if (!familyId)
      throw new DomainError(
        'Family access denied.',
        'FAMILY_ACCESS_DENIED',
        403,
      );
    await this.context(actor, familyId, 'read');
    return {
      items: await this.repository.templates(
        familyId,
        actor.userId,
        query.category,
        query.childId,
      ),
    };
  }

  async create(
    actor: AuthPrincipal,
    input: CreateMissionDto,
    key: string,
  ): Promise<CreateMissionResponseDto> {
    const family = await this.context(actor, input.familyId, 'write');
    if (
      !['ME', 'TOGETHER'].includes(input.owner) ||
      (input.ownerUserId != null &&
        (input.owner !== 'ME' || input.ownerUserId !== actor.userId))
    )
      throw new DomainError(
        'Missions can only be created for yourself or together.',
        'MISSION_OWNER_INVALID',
        422,
      );
    if (
      (!input.title?.trim() && !input.templateId) ||
      (input.title?.trim() && input.templateId)
    )
      throw new DomainError(
        'Choose a template or a custom title.',
        'MISSION_CONTENT_INVALID',
        422,
      );
    const date = validMissionDate(
      input.boardDate ??
        input.date ??
        localMissionDate(new Date(), family.timezone),
    );
    if (date < localMissionDate(new Date(), family.timezone))
      throw new DomainError(
        'A new mission cannot be scheduled in the past.',
        'MISSION_DATE_INVALID',
        422,
      );
    const horizon = new Date(
      `${localMissionDate(new Date(), family.timezone)}T00:00:00Z`,
    );
    horizon.setUTCDate(horizon.getUTCDate() + MISSION_POLICY.maxScheduleDays);
    if (date > horizon.toISOString().slice(0, 10))
      throw new DomainError(
        'Mission date exceeds the scheduling horizon.',
        'MISSION_DATE_INVALID',
        422,
      );
    if (
      input.scheduledTime &&
      !/^(?:[01]\d|2[0-3]):[0-5]\d$/u.test(input.scheduledTime)
    )
      throw new DomainError(
        'Invalid scheduled time.',
        'MISSION_DATE_INVALID',
        422,
      );
    if (
      input.dueAt &&
      (!/(?:Z|[+-]\d\d:\d\d)$/u.test(input.dueAt) ||
        !Number.isFinite(Date.parse(input.dueAt)) ||
        localMissionDate(new Date(input.dueAt), family.timezone) !== date)
    )
      throw new DomainError(
        'Due time must match the mission date.',
        'MISSION_DATE_INVALID',
        422,
      );
    const childIds = input.childIds ?? [];
    const targetScope =
      input.targetScope ??
      (childIds.length > 1
        ? 'MULTI_CHILD'
        : childIds.length === 1
          ? 'CHILD'
          : 'FAMILY');
    if (
      (targetScope === 'CHILD' && childIds.length !== 1) ||
      (targetScope === 'MULTI_CHILD' && childIds.length < 2) ||
      (['FAMILY', 'COUPLE'].includes(targetScope) && childIds.length !== 0)
    )
      throw new DomainError(
        'Child selection does not match the mission scope.',
        'MISSION_SCOPE_INVALID',
        422,
      );
    if (targetScope === 'COUPLE' && input.owner !== 'TOGETHER')
      throw new DomainError(
        'Couple missions must be together.',
        'MISSION_OWNER_INVALID',
        422,
      );
    const view = await this.repository.create(
      input.familyId,
      actor.userId,
      {
        ...input,
        title: input.title?.trim(),
        boardDate: date,
        targetScope,
        childIds,
      },
      key,
    );
    return { mission: this.projectMine(view, actor.userId), seriesId: null };
  }

  async act(
    actor: AuthPrincipal,
    id: string,
    action: MissionBoardAction,
    key?: string,
    input?: SwapMissionDto | CompleteMissionDto,
  ): Promise<MissionActionResponseDto> {
    await this.missionContext(actor, id, 'write');
    const view = await this.repository.find(id);
    if (!view)
      throw new DomainError('Mission was not found.', 'MISSION_NOT_FOUND', 404);
    requireMissionOwner(view, actor.userId);
    // Repository re-evaluates the shared state decision under its transaction lock.
    const result = await this.repository.act(
      id,
      actor.userId,
      action,
      key,
      input,
    );
    const mission = this.projectMine(result, actor.userId);
    if (action === 'complete') {
      if (!result.tree)
        throw new DomainError(
          'Mission tree is unavailable.',
          'MISSION_TREE_UNAVAILABLE',
          503,
        );
      return {
        mission,
        myHeartsAwarded: result.myHeartsAwarded,
        memoryId: null,
        tree: result.tree,
      };
    }
    if (action === 'swap') return { removedId: id, mission };
    return mission;
  }

  async swapOptions(actor: AuthPrincipal, id: string) {
    await this.missionContext(actor, id, 'write');
    const view = await this.repository.find(id);
    if (!view)
      throw new DomainError('Mission was not found.', 'MISSION_NOT_FOUND', 404);
    requireMissionOwner(view, actor.userId);
    return this.repository.swapOptions(id, actor.userId);
  }

  private async context(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'write',
  ) {
    const family = await this.access.requireParent(actor, familyId, mode);
    if (family.status !== 'ACTIVE')
      throw new DomainError('Family is not active.', 'FAMILY_NOT_ACTIVE', 403);
    return family;
  }
  private async missionContext(
    actor: AuthPrincipal,
    id: string,
    mode: 'read' | 'write',
  ) {
    const familyId = await this.repository.familyIdForMission(id);
    if (!familyId)
      throw new DomainError('Mission was not found.', 'MISSION_NOT_FOUND', 404);
    return this.context(actor, familyId, mode);
  }
  private project(
    view: MissionBoardView,
    userId: string,
  ): MyMissionDto | PartnerMissionDto {
    const row = view.mission;
    if (row.ownerKind === 'TOGETHER' || row.ownerUserId === userId)
      return this.projectMine(view, userId);
    return {
      id: row.id,
      title: row.title,
      category: row.category,
      childIds: view.childIds,
      status: row.status as 'TODO' | 'DONE',
      completedAt: row.completedAt?.toISOString() ?? null,
      late: row.late,
      thanked: false,
    };
  }
  private projectMine(view: MissionBoardView, userId: string): MyMissionDto {
    const row = view.mission;
    return {
      id: row.id,
      familyId: row.familyId,
      boardDate: row.boardDate.toISOString().slice(0, 10),
      ownerKind: row.ownerKind,
      mine: row.ownerUserId === userId,
      source: row.source,
      templateId: row.templateId,
      title: row.title,
      note: row.note,
      category: row.category,
      targetScope: row.targetScope,
      childIds: view.childIds,
      hearts: row.hearts,
      status: row.status,
      scheduledTime: row.scheduledTime?.toISOString().slice(11, 19) ?? null,
      dueAt: row.dueAt?.toISOString() ?? null,
      completedAt: row.completedAt?.toISOString() ?? null,
      late: row.late,
      canSwap: row.source === 'SYSTEM' && row.status === 'TODO',
      version: row.version,
      events: view.events.map((event) => ({
        type: event.type,
        createdAt: event.createdAt.toISOString(),
      })),
    };
  }
}

export function localMissionDate(now: Date, timezone: string): string {
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
function validMissionDate(value: string): string {
  if (
    !/^\d{4}-\d\d-\d\d$/u.test(value) ||
    !Number.isFinite(Date.parse(value)) ||
    new Date(value).toISOString().slice(0, 10) !== value
  )
    throw new DomainError('Invalid mission date.', 'MISSION_DATE_INVALID', 422);
  return value;
}
