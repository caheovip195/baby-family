import type { Prisma } from '../generated/prisma/client';
import type { PrismaService } from '../database/prisma.service';

/**
 * RPT-01/02 (BF-20261019-006): what one viewer must not see in a family —
 * authors they blocked and memories/comments they reported with "hide for me".
 * Read on every query, before pagination, like the Circle grants.
 */
export async function viewerExclusions(
  prisma: Pick<PrismaService, 'block' | 'reportHide'>,
  familyId: string,
  userId: string,
): Promise<{
  blockedUserIds: string[];
  hiddenMemoryIds: string[];
  hiddenCommentIds: string[];
}> {
  const [blocks, hides] = await Promise.all([
    prisma.block.findMany({
      where: { familyId, blockerUserId: userId, deletedAt: null },
      select: { blockedUserId: true },
    }),
    prisma.reportHide.findMany({
      where: {
        userId,
        deletedAt: null,
        targetType: { in: ['MEMORY', 'COMMENT'] },
      },
      select: { targetType: true, targetId: true },
    }),
  ]);
  return {
    blockedUserIds: blocks.map((row) => row.blockedUserId),
    hiddenMemoryIds: hides
      .filter((row) => row.targetType === 'MEMORY')
      .map((row) => row.targetId),
    hiddenCommentIds: hides
      .filter((row) => row.targetType === 'COMMENT')
      .map((row) => row.targetId),
  };
}

/** Memory filter for [viewerExclusions]; `{}` when nothing is excluded. */
export function memoryExclusionWhere(exclusions: {
  blockedUserIds: string[];
  hiddenMemoryIds: string[];
}): Prisma.MemoryWhereInput {
  return {
    ...(exclusions.blockedUserIds.length
      ? { authorUserId: { notIn: exclusions.blockedUserIds } }
      : {}),
    ...(exclusions.hiddenMemoryIds.length
      ? { id: { notIn: exclusions.hiddenMemoryIds } }
      : {}),
  };
}
