import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import type {
  PerspectiveContentResponseDto,
  PutPerspectiveContentDto,
} from '../dto/memory-library/perspective-content.dto';
import { MEMORY_PERSPECTIVE_CONTENT_REPOSITORY } from '../interfaces/repositories/memory-perspective-content-repository.interface';
import type { IMemoryPerspectiveContentRepository } from '../interfaces/repositories/memory-perspective-content-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { MEMORY_LIBRARY_SERVICE } from '../interfaces/services/memory-library-service.interface';
import type { IMemoryLibraryService } from '../interfaces/services/memory-library-service.interface';
import type { IMemoryPerspectiveContentService } from '../interfaces/services/memory-perspective-content-service.interface';
import type { MemoryPerspective } from '../models/memory-perspective.model';

@Injectable()
export class MemoryPerspectiveContentService implements IMemoryPerspectiveContentService {
  constructor(
    @Inject(MEMORY_PERSPECTIVE_CONTENT_REPOSITORY)
    private readonly repository: IMemoryPerspectiveContentRepository,
    @Inject(MEMORY_LIBRARY_SERVICE)
    private readonly library: IMemoryLibraryService,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async list(actor: AuthPrincipal, memoryId: string) {
    const memory = await this.library.read(actor, memoryId);
    if (memory.sealed) throw new NotFoundError('Memory was not found.');
    const { isParent } = await this.library.requireFamily(
      actor,
      memory.familyId,
    );
    const rows = await this.repository.list(
      memoryId,
      memory.familyId,
      isParent,
    );
    return { items: rows.map(project) };
  }

  async put(
    actor: AuthPrincipal,
    memoryId: string,
    input: PutPerspectiveContentDto,
  ) {
    const memory = await this.library.read(actor, memoryId);
    if (memory.sealed) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, memory.familyId, 'write');
    if (memory.authorRole !== 'PARENT' || memory.authorUserId === actor.userId)
      throw new DomainError(
        'Only the other Parent can tell a second perspective.',
        'PERSPECTIVE_OTHER_PARENT_REQUIRED',
        403,
      );
    const existing = await this.repository.findOwn(memoryId, actor.userId);
    const body =
      input.body === undefined
        ? (existing?.body ?? null)
        : input.body?.trim() || null;
    const audioAssetId =
      input.audioAssetId === undefined
        ? (existing?.audioAssetId ?? null)
        : input.audioAssetId;
    if (!body && !audioAssetId)
      throw new DomainError(
        'A perspective needs text or audio.',
        'PERSPECTIVE_CONTENT_REQUIRED',
        422,
      );
    if (audioAssetId) {
      const audio = await this.repository.findAudio(
        audioAssetId,
        memory.familyId,
        actor.userId,
      );
      if (
        !audio ||
        audio.kind !== 'AUDIO' ||
        !['READY', 'UPLOADED'].includes(audio.status) ||
        (audio.privateOwnerUserId !== null &&
          audio.privateOwnerUserId !== actor.userId)
      )
        throw new DomainError(
          'Audio must be uploaded in this family and accessible.',
          'PERSPECTIVE_AUDIO_INVALID',
          422,
        );
    }
    return project(
      await this.repository.save({
        memoryId,
        familyId: memory.familyId,
        authorUserId: actor.userId,
        body,
        audioAssetId,
        hiddenFromCircle:
          input.hiddenFromCircle ?? existing?.hiddenFromCircle ?? false,
      }),
    );
  }

  async remove(actor: AuthPrincipal, memoryId: string) {
    const memory = await this.library.read(actor, memoryId);
    if (memory.sealed) throw new NotFoundError('Memory was not found.');
    await this.access.requireParent(actor, memory.familyId, 'write');
    if (memory.authorUserId === actor.userId || memory.authorRole !== 'PARENT')
      throw new DomainError(
        'Only the other Parent may delete their perspective.',
        'PERSPECTIVE_OTHER_PARENT_REQUIRED',
        403,
      );
    await this.repository.remove(memoryId, memory.familyId, actor.userId);
  }
}
function project(row: MemoryPerspective): PerspectiveContentResponseDto {
  return {
    id: row.id,
    memoryId: row.memoryId,
    authorUserId: row.authorUserId,
    body: row.body,
    audioAssetId: row.audioAssetId,
    hiddenFromCircle: row.hiddenFromCircle,
    version: row.version,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}
