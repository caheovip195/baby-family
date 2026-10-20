import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CommentListResponseDto,
  CommentResponseDto,
  ReactionResponseDto,
} from '../../dto/memory/comment-response.dto';
import type { CreateCommentDto } from '../../dto/memory/create-comment.dto';
import type { SetReactionDto } from '../../dto/memory/set-reaction.dto';
import type { UpdateCommentDto } from '../../dto/memory/update-comment.dto';

export const MEMORY_INTERACTION_SERVICE = Symbol('MEMORY_INTERACTION_SERVICE');

/** Comments and reactions on memories for Parents (MEM-07/10, spec §7.12). */
export interface IMemoryInteractionService {
  listComments(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<CommentListResponseDto>;
  /** canComment (spec §6.2): sees the memory and its comments are enabled. */
  addComment(
    actor: AuthPrincipal,
    memoryId: string,
    input: CreateCommentDto,
  ): Promise<CommentResponseDto>;
  /** Own comment only, within 15 minutes. */
  editComment(
    actor: AuthPrincipal,
    commentId: string,
    input: UpdateCommentDto,
  ): Promise<CommentResponseDto>;
  /** Own comment, or any comment for a Parent; replies go with it. */
  deleteComment(actor: AuthPrincipal, commentId: string): Promise<void>;
  setReaction(
    actor: AuthPrincipal,
    memoryId: string,
    input: SetReactionDto,
  ): Promise<ReactionResponseDto>;
  clearReaction(
    actor: AuthPrincipal,
    memoryId: string,
  ): Promise<ReactionResponseDto>;
}
