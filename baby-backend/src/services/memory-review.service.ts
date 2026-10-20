import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import {
  MEMORY_CONTENT_SERVICE,
  type IMemoryContentService,
} from '../interfaces/services/memory-content-service.interface';
import {
  MEMORY_REVIEW_REPOSITORY,
  type IMemoryReviewRepository,
} from '../interfaces/repositories/memory-review-repository.interface';
import type { IMemoryReviewService } from '../interfaces/services/memory-review-service.interface';
import type {
  ApproveMemoryDto,
  RejectMemoryDto,
} from '../dto/memory-review/memory-review.dto';
@Injectable()
export class MemoryReviewService implements IMemoryReviewService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_REVIEW_REPOSITORY)
    private readonly repository: IMemoryReviewRepository,
    @Inject(MEMORY_CONTENT_SERVICE)
    private readonly memories: IMemoryContentService,
  ) {}
  async pending(actor: AuthPrincipal, familyId: string) {
    await this.requireParent(actor, familyId, 'read');
    const rows = await this.repository.list(familyId);
    return {
      data: await Promise.all(
        rows.map((row) => this.memories.getById(actor, row.id)),
      ),
    };
  }
  async approve(actor: AuthPrincipal, id: string, input: ApproveMemoryDto) {
    await this.review(actor, id, 'APPROVE', input);
    return this.memories.getById(actor, id);
  }
  async reject(actor: AuthPrincipal, id: string, input: RejectMemoryDto) {
    const memory = await this.review(actor, id, 'REJECT', input);
    return { id: memory.id, status: memory.status };
  }
  private async requireParent(
    actor: AuthPrincipal,
    familyId: string,
    mode: 'read' | 'write',
  ) {
    if (this.access.requireContentAccess) {
      const scope = await this.access.requireContentAccess(
        actor,
        familyId,
        mode,
      );
      if (!scope.isParent)
        throw new DomainError(
          'Only Parents may review memories.',
          'PARENT_REQUIRED',
          403,
        );
    } else await this.access.requireParent(actor, familyId, mode);
  }
  private async review(
    actor: AuthPrincipal,
    id: string,
    decision: 'APPROVE' | 'REJECT',
    input: ApproveMemoryDto & RejectMemoryDto,
  ) {
    const memory = await this.repository.find(id);
    if (!memory) throw new NotFoundError('Memory was not found.');
    await this.requireParent(actor, memory.familyId, 'write');
    return this.repository.review({
      memoryId: id,
      familyId: memory.familyId,
      actorUserId: actor.userId,
      decision,
      ...input,
    });
  }
}
