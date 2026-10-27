export type OfflineEntity = 'memory' | 'memoryComment' | 'memoryReaction';
export type OfflineChangeData = {
  id: string;
  version?: number;
  memoryId?: string;
  userId?: string;
  type?: string;
  body?: string;
  authorUserId?: string;
  parentCommentId?: string | null;
};
/** A viewer-scoped, append-only change receipt. No content is persisted in the receipt. */
export class OfflineChange {
  constructor(
    readonly cursorId: string,
    readonly id: string,
    readonly entity: OfflineEntity,
    readonly memoryId: string,
    readonly op: 'upsert' | 'delete',
    readonly updatedAt: Date,
    readonly data?: OfflineChangeData,
  ) {}
}
