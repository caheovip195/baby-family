import { Prisma } from '../generated/prisma/client';

/**
 * Spec §6.3 Parent memory filter on alias `m`, plus the Parent's trash (MEM-17)
 * so its thumbnails can be signed. Sealed letters (unlock_at in the
 * future, viewer is not the author) never expose their media.
 */
export function parentVisibleMemorySql(userId: string): Prisma.Sql {
  return Prisma.sql`
      (
        (m.deleted_at IS NULL AND (
          (m.status = 'PUBLISHED' AND m.visibility IN ('PARENTS', 'FAMILY'))
          OR m.status = 'PENDING_REVIEW'
          OR (m.author_user_id = ${userId}::uuid
              AND m.status IN ('PUBLISHED', 'PROCESSING', 'DRAFT'))))
        -- Trash (MEM-17, soft-deleted): same audience until purge_after.
        OR (m.status = 'TRASHED' AND m.purge_after > now()
            AND (m.visibility IN ('PARENTS', 'FAMILY')
                 OR m.author_user_id = ${userId}::uuid))
      )
      AND NOT (m.kind = 'LETTER' AND m.unlock_at > now()
               AND m.author_user_id <> ${userId}::uuid)`;
}

/**
 * Asset alias `a` is shown to Parent `userId` through something other than
 * being its own unlinked upload: family avatars/covers, or a memory/perspective
 * the Parent may view. Used both for signing URLs and for deciding whether
 * another Parent's stored copy may be reused (dedup) or attached to a memory.
 */
export function parentSharedAssetSql(userId: string): Prisma.Sql {
  const visibleMemory = parentVisibleMemorySql(userId);
  return Prisma.sql`(
          a.purpose IN ('AVATAR', 'COVER')
          OR EXISTS (
            SELECT 1 FROM app.memory_assets ma
            JOIN app.memories m ON m.id = ma.memory_id AND m.family_id = ma.family_id
            WHERE ma.asset_id = a.id AND ma.family_id = a.family_id
              AND ma.deleted_at IS NULL AND ${visibleMemory})
          OR EXISTS (
            SELECT 1 FROM app.memory_perspectives p
            JOIN app.memories m ON m.id = p.memory_id AND m.family_id = p.family_id
            LEFT JOIN app.memory_perspective_assets pa
              ON pa.perspective_id = p.id AND pa.family_id = p.family_id
              AND pa.asset_id = a.id AND pa.deleted_at IS NULL
            WHERE p.family_id = a.family_id AND p.deleted_at IS NULL
              AND p.status = 'ACTIVE'
              AND (pa.asset_id IS NOT NULL OR p.audio_asset_id = a.id)
              AND ${visibleMemory})
        )`;
}
