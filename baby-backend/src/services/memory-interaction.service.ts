import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { MEMORY_POLICY } from '../config/memory-policy';
import type {
  CommentListResponseDto,
  CommentResponseDto,
  ReactionResponseDto,
} from '../dto/memory/comment-response.dto';
import type { CreateCommentDto } from '../dto/memory/create-comment.dto';
import type { SetReactionDto } from '../dto/memory/set-reaction.dto';
import type { UpdateCommentDto } from '../dto/memory/update-comment.dto';
import { MEMORY_CONTENT_REPOSITORY } from '../interfaces/repositories/memory-content-repository.interface';
import type { IMemoryContentRepository } from '../interfaces/repositories/memory-content-repository.interface';
import { MEMORY_INTERACTION_REPOSITORY } from '../interfaces/repositories/memory-interaction-repository.interface';
import type { IMemoryInteractionRepository } from '../interfaces/repositories/memory-interaction-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type {
  FamilyAccessMode,
  IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type { IMemoryInteractionService } from '../interfaces/services/memory-interaction-service.interface';
import type { Comment } from '../models/comment.model';
import type { MemoryView } from '../models/memory-view.model';

@Injectable()
export class MemoryInteractionService implements IMemoryInteractionService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEMORY_CONTENT_REPOSITORY)
    private readonly memories: IMemoryContentRepository,
    @Inject(MEMORY_INTERACTION_REPOSITORY)
    private readonly repository: IMemoryInteractionRepository,
  ) {}

  async listComments(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<CommentListResponseDto> {
    const view = await this.visibleMemory(actor, memoryId, 'read');
    this.assertNotSealed(actor, view);
    const comments = await this.repository.listComments(
      memoryId,
      MEMORY_POLICY.commentListMax,
      { familyId: view.memory.familyId, userId: actor.userId },
    );
    return { data: comments.map(project) };
  }

  async addComment(
    actor: AuthPrincipal,
    memoryId: string,
    input: CreateCommentDto,
  ): Promise<CommentResponseDto> {
    const view = await this.visibleMemory(actor, memoryId, 'write');
    this.assertNotSealed(actor, view);
    if (!view.memory.commentsEnabled)
      throw new DomainError(
        'Comments are turned off for this memory.',
        'COMMENTS_DISABLED',
        403,
      );
    const body = requireBody(input.body);
    let parentCommentId: string | null = null;
    if (input.parentCommentId) {
      const parent = await this.repository.findActiveComment(
        input.parentCommentId,
      );
      if (!parent || parent.memoryId !== memoryId)
        throw new DomainError(
          'The comment to reply to was not found.',
          'COMMENT_PARENT_INVALID',
          422,
        );
      // One reply level (spec §7.12): a reply to a reply joins the root thread.
      parentCommentId = parent.parentCommentId ?? parent.id;
    }
    const comment = await this.repository.createComment({
      familyId: view.memory.familyId,
      memoryId,
      authorUserId: actor.userId,
      parentCommentId,
      body,
    });
    return project(comment);
  }

  async editComment(
    actor: AuthPrincipal,
    commentId: string,
    input: UpdateCommentDto,
  ): Promise<CommentResponseDto> {
    const comment = await this.commentOnVisibleMemory(actor, commentId);
    if (comment.authorUserId !== actor.userId)
      throw new DomainError(
        'Only the author can edit a comment.',
        'COMMENT_NOT_AUTHOR',
        403,
      );
    if (
      Date.now() - comment.createdAt.getTime() >
      MEMORY_POLICY.commentEditWindowMs
    )
      throw new DomainError(
        'Comments can be edited for 15 minutes.',
        'COMMENT_EDIT_EXPIRED',
        403,
      );
    return project(
      await this.repository.updateCommentBody(
        commentId,
        requireBody(input.body),
      ),
    );
  }

  async deleteComment(actor: AuthPrincipal, commentId: string): Promise<void> {
    // Every caller here is a Parent: they may remove any comment of the family.
    const comment = await this.commentOnVisibleMemory(actor, commentId);
    await this.repository.deleteComment(comment, actor.userId);
  }

  async setReaction(
    actor: AuthPrincipal,
    memoryId: string,
    input: SetReactionDto,
  ): Promise<ReactionResponseDto> {
    const view = await this.visibleMemory(actor, memoryId, 'read');
    if (this.access.requireContentAccess)
      await this.access.requireContentAccess(
        actor,
        view.memory.familyId,
        'write',
      );
    else await this.access.requireParent(actor, view.memory.familyId, 'write');
    this.assertNotSealed(actor, view);
    await this.repository.setReaction(
      view.memory.familyId,
      memoryId,
      actor.userId,
      input.type,
    );
    return this.reactionState(actor, view.memory.familyId, memoryId);
  }

  async clearReaction(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<ReactionResponseDto> {
    const view = await this.visibleMemory(actor, memoryId, 'read');
    if (this.access.requireContentAccess)
      await this.access.requireContentAccess(
        actor,
        view.memory.familyId,
        'write',
      );
    else await this.access.requireParent(actor, view.memory.familyId, 'write');
    await this.repository.clearReaction(
      view.memory.familyId,
      memoryId,
      actor.userId,
    );
    return this.reactionState(actor, view.memory.familyId, memoryId);
  }

  /** canViewMemory (spec §6.3); hidden and missing are both 404. */
  private async visibleMemory(
    actor: AuthPrincipal,
    memoryId: string,
    mode: FamilyAccessMode,
  ): Promise<MemoryView> {
    const familyId = await this.memories.findFamilyId(memoryId);
    if (!familyId) throw new NotFoundError('Memory was not found.');
    if (mode === 'read' && this.access.requireContentAccess)
      await this.access.requireContentAccess(actor, familyId, mode);
    else await this.access.requireParent(actor, familyId, mode);
    const view = await this.memories.findVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!view) throw new NotFoundError('Memory was not found.');
    return view;
  }

  private async commentOnVisibleMemory(
    actor: AuthPrincipal,
    commentId: string,
  ): Promise<Comment> {
    const comment = await this.repository.findActiveComment(commentId);
    if (!comment) throw new NotFoundError('Comment was not found.');
    try {
      await this.visibleMemory(actor, comment.memoryId, 'write');
    } catch (error) {
      // Do not reveal comments of memories the actor cannot see.
      if (error instanceof NotFoundError)
        throw new NotFoundError('Comment was not found.');
      throw error;
    }
    return comment;
  }

  /** A sealed letter (spec §6.3) shows nothing to react or comment on. */
  private assertNotSealed(actor: AuthPrincipal, view: MemoryView): void {
    if (view.isSealedFor(actor.userId, new Date()))
      throw new NotFoundError('Memory was not found.');
  }

  private async reactionState(
    actor: AuthPrincipal,
    familyId: string,
    memoryId: string,
  ): Promise<ReactionResponseDto> {
    const view = await this.memories.findVisibleToParent(
      familyId,
      actor.userId,
      memoryId,
    );
    if (!view) throw new NotFoundError('Memory was not found.');
    return {
      memoryId,
      reactions: view.reactionCounts,
      myReaction: view.reactionOf(actor.userId),
      reactionCount: view.memory.reactionCount,
    };
  }
}

function requireBody(value: string): string {
  const body = value.trim();
  if (!body)
    throw new DomainError('A comment needs some text.', 'COMMENT_EMPTY', 422);
  return body;
}

function project(comment: Comment): CommentResponseDto {
  return {
    id: comment.id,
    memoryId: comment.memoryId,
    authorUserId: comment.authorUserId,
    parentCommentId: comment.parentCommentId,
    body: comment.body,
    createdAt: comment.createdAt.toISOString(),
    editedAt: comment.editedAt?.toISOString() ?? null,
  };
}
