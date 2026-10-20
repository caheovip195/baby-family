import type { ReactionType } from '../../common/database.enums';
import type { Comment } from '../../models/comment.model';

export const MEMORY_INTERACTION_REPOSITORY = Symbol(
  'MEMORY_INTERACTION_REPOSITORY',
);

export interface CreateCommentCommand {
  familyId: string;
  memoryId: string;
  authorUserId: string;
  /** Root comment id (one reply level), already checked to be on this memory. */
  parentCommentId: string | null;
  body: string;
}

/** Comments and reactions of memories (spec §7.12). Counters move in the same transaction. */
export interface IMemoryInteractionRepository {
  /** Active comments, oldest first. */
  /** [viewer]: drop comments of users they blocked or reported as hidden. */
  listComments(
    memoryId: string,
    limit: number,
    viewer?: { familyId: string; userId: string },
  ): Promise<Comment[]>;
  findActiveComment(commentId: string): Promise<Comment | null>;
  /** Insert + `memories.comment_count + 1` + outbox `comment.created`. */
  createComment(command: CreateCommentCommand): Promise<Comment>;
  updateCommentBody(commentId: string, body: string): Promise<Comment>;
  /**
   * Soft-deletes the comment and its replies (status DELETED), decrements
   * `comment_count`, outbox `comment.deleted`. Returns the number removed.
   */
  deleteComment(comment: Comment, actorUserId: string): Promise<number>;
  /** Upsert of the person's single reaction; `reaction_count` +1 when new. */
  setReaction(
    familyId: string,
    memoryId: string,
    userId: string,
    type: ReactionType,
  ): Promise<void>;
  /** Removes the person's reaction (no-op when none); `reaction_count` −1. */
  clearReaction(
    familyId: string,
    memoryId: string,
    userId: string,
  ): Promise<void>;
}
