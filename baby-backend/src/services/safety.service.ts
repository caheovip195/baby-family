import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { SAFETY_POLICY } from '../config/safety-policy';
import type {
  BlockListResponseDto,
  CreateBlockDto,
  CreateReportDto,
  ReportResponseDto,
} from '../dto/safety/safety.dto';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../interfaces/repositories/memory-content-repository.interface';
import type { IMemoryContentRepository } from '../interfaces/repositories/memory-content-repository.interface';
import { SAFETY_REPOSITORY } from '../interfaces/repositories/safety-repository.interface';
import type {
  FamilyRoleOf,
  ISafetyRepository,
} from '../interfaces/repositories/safety-repository.interface';
import { MODERATION_WORKFLOW_SERVICE } from '../interfaces/services/moderation-workflow-service.interface';
import type { IModerationWorkflowService } from '../interfaces/services/moderation-workflow-service.interface';
import type { ISafetyService } from '../interfaces/services/safety-service.interface';

/**
 * RPT-01 report and RPT-02 block (spec §7.23–7.24). Only content the reporter
 * can see may be reported (hidden and missing both answer 404); blocks are
 * per family and hide the blocked person's memories/comments for the blocker.
 */
@Injectable()
export class SafetyService implements ISafetyService {
  constructor(
    @Inject(SAFETY_REPOSITORY) private readonly repository: ISafetyRepository,
    @Inject(MEMORY_CONTENT_REPOSITORY)
    private readonly memories: IMemoryContentRepository,
    @Optional()
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access?: IApplicationAccessService,
    @Optional()
    @Inject(MODERATION_WORKFLOW_SERVICE)
    private readonly moderation?: IModerationWorkflowService,
  ) {}

  async report(
    actor: AuthPrincipal,
    input: CreateReportDto,
  ): Promise<ReportResponseDto> {
    await this.requireMember(input.familyId, actor.userId);
    const owner = await this.targetOwner(actor, input);
    if (owner === actor.userId)
      throw new DomainError(
        'You cannot report your own content.',
        'REPORT_SELF_NOT_ALLOWED',
        422,
      );
    const severity =
      input.reason === 'CHILD_SAFETY'
        ? SAFETY_POLICY.severity.CHILD_SAFETY
        : SAFETY_POLICY.severity.default;
    const report = await this.repository.createReport({
      reporterUserId: actor.userId,
      familyId: input.familyId,
      targetType: input.targetType,
      targetId: input.targetId,
      targetOwnerId: owner,
      reason: input.reason,
      detail: input.note?.trim() || null,
      severity,
      slaDueAt: new Date(Date.now() + SAFETY_POLICY.slaMs[severity]),
      hideForReporter: input.hideForMe ?? false,
    });
    await this.moderation?.reportCreated(report.id);
    const day = report.createdAt.toISOString().slice(2, 10).replace(/-/g, '');
    return {
      id: report.id,
      code: `BC-${day}-${report.id.slice(-4).toUpperCase()}`,
      status: report.status,
      createdAt: report.createdAt.toISOString(),
    };
  }

  async block(actor: AuthPrincipal, input: CreateBlockDto): Promise<void> {
    await this.requireWrite(actor, input.familyId);
    const mine = await this.requireMember(input.familyId, actor.userId);
    if (input.userId === actor.userId)
      throw new DomainError(
        'You cannot block yourself.',
        'BLOCK_SELF_NOT_ALLOWED',
        422,
      );
    const theirs = await this.repository.roleOf(input.familyId, input.userId);
    if (!theirs) throw new NotFoundError('Member was not found.');
    // Papa & Mama share the family; leaving it is the path, not a block.
    if (mine === 'PARENT' && theirs === 'PARENT')
      throw new DomainError(
        'A Parent cannot block the other Parent.',
        'BLOCK_PARTNER_NOT_ALLOWED',
        422,
      );
    await this.repository.block(input.familyId, actor.userId, input.userId);
  }

  async unblock(
    actor: AuthPrincipal,
    familyId: string,
    userId: string,
  ): Promise<void> {
    await this.requireMember(familyId, actor.userId);
    await this.requireWrite(actor, familyId);
    await this.repository.unblock(familyId, actor.userId, userId);
  }

  async blocks(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<BlockListResponseDto> {
    await this.requireMember(familyId, actor.userId);
    const rows = await this.repository.listBlocks(familyId, actor.userId);
    return {
      items: rows.map((row) => ({
        userId: row.userId,
        displayName: row.displayName,
        blockedAt: row.blockedAt.toISOString(),
      })),
    };
  }

  private async requireWrite(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<void> {
    if (!this.access)
      throw new DomainError(
        'Family access verification unavailable.',
        'FAMILY_ACCESS_UNAVAILABLE',
        503,
      );
    if (this.access.requireContentAccess)
      await this.access.requireContentAccess(actor, familyId, 'write');
    else await this.access.requireParent(actor, familyId, 'write');
  }

  private async requireMember(
    familyId: string,
    userId: string,
  ): Promise<Exclude<FamilyRoleOf, null>> {
    const role = await this.repository.roleOf(familyId, userId);
    if (!role) throw new NotFoundError('Family was not found.');
    return role;
  }

  /** Owner of a target the actor can see; 404 when hidden or missing. */
  private async targetOwner(
    actor: AuthPrincipal,
    input: CreateReportDto,
  ): Promise<string | null> {
    const visibleMemory = async (memoryId: string) => {
      const view = await this.memories.findVisibleToParent(
        input.familyId,
        actor.userId,
        memoryId,
      );
      if (!view) throw new NotFoundError('Target was not found.');
      return view;
    };
    switch (input.targetType) {
      case 'MEMORY':
        return (await visibleMemory(input.targetId)).memory.authorUserId;
      case 'COMMENT': {
        const comment = await this.repository.commentContext(
          input.familyId,
          input.targetId,
        );
        if (!comment) throw new NotFoundError('Target was not found.');
        await visibleMemory(comment.memoryId);
        return comment.authorUserId;
      }
      case 'USER':
        if (!(await this.repository.roleOf(input.familyId, input.targetId)))
          throw new NotFoundError('Target was not found.');
        return input.targetId;
    }
  }
}
