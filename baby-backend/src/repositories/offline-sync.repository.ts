import { createHash } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type {
  ChangesPosition,
  IOfflineSyncRepository,
} from '../interfaces/repositories/offline-sync-repository.interface';
import {
  OfflineChange,
  type OfflineChangeData,
  type OfflineEntity,
} from '../models/offline-change.model';
import { memoryContentScope } from './memory-content-visibility';
import { viewerExclusions } from './viewer-exclusions';

type State = {
  entity: OfflineEntity;
  id: string;
  memoryId: string;
  op: 'upsert' | 'delete';
  fingerprint: string;
  data: OfflineChangeData | null;
};
type Receipt = {
  id: string;
  entity: OfflineEntity;
  entity_id: string;
  memory_id: string;
  op: 'upsert' | 'delete';
  fingerprint: string;
  updated_at: Date;
};

@Injectable()
export class OfflineSyncRepository implements IOfflineSyncRepository {
  constructor(private readonly prisma: PrismaService) {}
  pull(
    familyId: string,
    userId: string,
    since: Date,
    after: ChangesPosition | null,
    limit: number,
  ): Promise<OfflineChange[]> {
    return this.prisma.$transaction(
      async (tx) => {
        // Serialize all pulls for one viewer/family, including log timestamp assignment.
        await tx.$queryRaw`SELECT pg_advisory_xact_lock(hashtextextended(${familyId + ':' + userId}, 0))::text`;
        const scope = await memoryContentScope(tx, familyId, userId);
        const exclusions = await viewerExclusions(tx, familyId, userId);
        const parentFeed = Prisma.sql`m.deleted_at IS NULL AND (
        (m.status='PUBLISHED' AND m.visibility IN ('PARENTS','FAMILY'))
        OR m.status='PENDING_REVIEW'
        OR (m.status='PROCESSING' AND m.author_role='CIRCLE' AND m.reviewed_at IS NOT NULL AND m.visibility='FAMILY')
        OR (m.author_user_id=${userId}::uuid AND m.status IN ('PUBLISHED','PROCESSING')))
        AND NOT (m.kind='LETTER' AND m.unlock_at > now() AND m.author_user_id<>${userId}::uuid)`;
        const audience = scope.isParent ? parentFeed : scope.sql;
        const exclude = Prisma.sql`NOT (m.author_user_id = ANY(${exclusions.blockedUserIds}::uuid[])) AND NOT (m.id = ANY(${exclusions.hiddenMemoryIds}::uuid[]))`;
        const states = await tx.$queryRaw<State[]>`
        WITH memories AS (
          SELECT m.*, ((${audience}) AND ${exclude}) AS visible,
            (${scope.isParent} AND (${scope.sql}) AND ${exclude} AND m.status='TRASHED') AS trash_visible
          FROM app.memories m WHERE m.family_id=${familyId}::uuid
        ), entities AS (
          SELECT 'memory'::text AS entity, m.id::text AS id, m.id AS "memoryId",
            CASE WHEN m.visible THEN 'upsert' ELSE 'delete' END AS op,
            CASE WHEN m.visible THEN jsonb_build_object('id',m.id,'version',m.version) END AS data,
            m.updated_at::text AS source
          FROM memories m WHERE m.visible OR m.trash_visible
          UNION ALL
          SELECT 'memoryComment', c.id::text, c.memory_id,
            CASE WHEN c.deleted_at IS NULL AND c.status='ACTIVE' THEN 'upsert' ELSE 'delete' END,
            CASE WHEN c.deleted_at IS NULL AND c.status='ACTIVE' THEN jsonb_build_object('id',c.id,'memoryId',c.memory_id,'body',c.body,'authorUserId',c.author_user_id,'parentCommentId',c.parent_comment_id) END,
            c.updated_at::text
          FROM app.comments c JOIN memories m ON m.id=c.memory_id AND m.family_id=c.family_id
          WHERE m.visible AND NOT (c.author_user_id=ANY(${exclusions.blockedUserIds}::uuid[])) AND NOT (c.id=ANY(${exclusions.hiddenCommentIds}::uuid[]))
          UNION ALL
          SELECT 'memoryReaction', r.memory_id::text || ':' || r.user_id::text, r.memory_id,
            CASE WHEN r.deleted_at IS NULL THEN 'upsert' ELSE 'delete' END,
            CASE WHEN r.deleted_at IS NULL THEN jsonb_build_object('id',r.memory_id::text || ':' || r.user_id::text,'memoryId',r.memory_id,'userId',r.user_id,'type',r.type) END,
            r.updated_at::text
          FROM app.reactions r JOIN memories m ON m.id=r.memory_id AND m.family_id=r.family_id WHERE m.visible
        )
        SELECT entity,id,"memoryId",op,data, source AS fingerprint FROM entities`;
        const current = new Map(states.map((s) => [s.entity + ':' + s.id, s]));
        const latest = await tx.$queryRaw<Receipt[]>`
        SELECT DISTINCT ON (entity,entity_id) * FROM app.offline_memory_changes
        WHERE family_id=${familyId}::uuid AND user_id=${userId}::uuid AND deleted_at IS NULL
        ORDER BY entity,entity_id,updated_at DESC,id DESC`;
        const previous = new Map(
          latest.map((r) => [r.entity + ':' + r.entity_id, r]),
        );
        // Revoke only identities this viewer was previously authorized to synchronize.
        for (const old of latest) {
          const key = old.entity + ':' + old.entity_id;
          if (!current.has(key))
            current.set(key, {
              entity: old.entity,
              id: old.entity_id,
              memoryId: old.memory_id,
              op: 'delete',
              fingerprint: 'delete',
              data: null,
            });
        }
        const pending: State[] = [];
        for (const [key, s] of current) {
          s.fingerprint =
            s.op === 'delete'
              ? 'delete'
              : createHash('sha256')
                  .update(JSON.stringify([s.fingerprint, s.data]))
                  .digest('hex');
          if (previous.get(key)?.fingerprint !== s.fingerprint) pending.push(s);
        }
        if (pending.length) {
          // Strictly newer than every earlier committed batch, even within one millisecond.
          const [clock] = await tx.$queryRaw<{ at: Date }[]>`
          SELECT GREATEST(date_trunc('milliseconds',clock_timestamp()),COALESCE(max(updated_at)+interval '1 millisecond',${since})) AS at
          FROM app.offline_memory_changes WHERE family_id=${familyId}::uuid AND user_id=${userId}::uuid`;
          const at = clock!.at;
          for (let offset = 0; offset < pending.length; offset += 2000) {
            const batch = pending.slice(offset, offset + 2000);
            await tx.$executeRaw(Prisma.sql`
          INSERT INTO app.offline_memory_changes(family_id,user_id,entity,entity_id,memory_id,op,fingerprint,created_at,updated_at)
          VALUES ${Prisma.join(batch.map((s) => Prisma.sql`(${familyId}::uuid,${userId}::uuid,${s.entity},${s.id},${s.memoryId}::uuid,${s.op},${s.fingerprint},${at},${at})`))}`);
          }
        }
        const position = after
          ? Prisma.sql`AND (updated_at,id)>(${after.at},${after.id}::uuid)`
          : Prisma.sql`AND updated_at >= ${since}`;
        const rows = await tx.$queryRaw<Receipt[]>`
        SELECT * FROM app.offline_memory_changes WHERE family_id=${familyId}::uuid AND user_id=${userId}::uuid AND deleted_at IS NULL
        ${position} ORDER BY updated_at,id LIMIT ${limit + 1}`;
        return rows.map((r) => {
          const state = current.get(r.entity + ':' + r.entity_id);
          // An older queued upsert must never reveal data after an ACL revocation.
          const op =
            r.op === 'delete' || state?.op !== 'upsert' ? 'delete' : 'upsert';
          return new OfflineChange(
            r.id,
            r.entity_id,
            r.entity,
            r.memory_id,
            op,
            r.updated_at,
            op === 'upsert' ? (state?.data ?? undefined) : undefined,
          );
        });
      },
      { timeout: 30000 },
    );
  }
}
