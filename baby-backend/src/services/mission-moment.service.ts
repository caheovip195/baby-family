import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import type { SaveMissionMomentDto } from '../dto/mission/mission-moment.dto';
import type { MemoryResponseDto } from '../dto/memory/memory-response.dto';
import { MISSION_BOARD_REPOSITORY } from '../interfaces/repositories/mission-board-repository.interface';
import type { IMissionBoardRepository } from '../interfaces/repositories/mission-board-repository.interface';
import { MISSION_MOMENT_REPOSITORY } from '../interfaces/repositories/mission-moment-repository.interface';
import type { IMissionMomentRepository } from '../interfaces/repositories/mission-moment-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../interfaces/services/memory-content-service.interface';
import type { IMemoryContentService } from '../interfaces/services/memory-content-service.interface';
import type { IMissionMomentService } from '../interfaces/services/mission-moment-service.interface';

/**
 * CARE-06 “Lưu lại khoảnh khắc” (BF-20261019-003): the memory is created by the
 * memory service (same validation, quota, visibility, outbox) and linked to the
 * mission's active completion. Retrying with the same Idempotency-Key, or after
 * the link exists, returns the same memory.
 */
@Injectable()
export class MissionMomentService implements IMissionMomentService {
  constructor(
    @Inject(MISSION_BOARD_REPOSITORY)
    private readonly missions: IMissionBoardRepository,
    @Inject(MISSION_MOMENT_REPOSITORY)
    private readonly repository: IMissionMomentRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_CONTENT_SERVICE)
    private readonly memories: IMemoryContentService,
  ) {}

  async save(
    actor: AuthPrincipal,
    missionId: string,
    idempotencyKey: string,
    input: SaveMissionMomentDto,
  ): Promise<MemoryResponseDto> {
    const view = await this.missions.find(missionId);
    if (!view) throw new NotFoundError('Mission not found.');
    const mission = view.mission;
    // Circle and other families get 404/403 from the access check.
    await this.access.requireParent(actor, mission.familyId, 'write');
    if (
      mission.ownerKind !== 'TOGETHER' &&
      mission.ownerUserId !== actor.userId
    )
      throw new DomainError(
        'Only the owner can save this moment.',
        'MISSION_NOT_OWNER',
        403,
      );
    if (mission.status !== 'DONE')
      throw new DomainError(
        'The mission is not done yet.',
        'MISSION_NOT_DONE',
        409,
      );
    const completion = await this.repository.activeCompletion(missionId);
    if (!completion)
      throw new DomainError(
        'The mission is not done yet.',
        'MISSION_NOT_DONE',
        409,
      );
    if (completion.memoryId)
      return this.memories.getById(actor, completion.memoryId);
    const body = input.body?.trim();
    const memory = await this.memories.create(actor, idempotencyKey, {
      familyId: mission.familyId,
      kind: 'MOMENT',
      title: mission.title,
      body: body ? body : null,
      assetIds: input.assetIds ?? [],
      childIds: view.childIds,
      familyMoment: view.childIds.length === 0,
      occurredAt: completion.completedAt.toISOString(),
      visibility: input.visibility ?? 'FAMILY',
    });
    if (!(await this.repository.linkMemory(completion.id, memory.id))) {
      // Another request linked first: keep that one as the mission's moment.
      const linked = await this.repository.activeCompletion(missionId);
      if (linked?.memoryId && linked.memoryId !== memory.id)
        return this.memories.getById(actor, linked.memoryId);
    }
    return memory;
  }
}
