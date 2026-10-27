import { Inject, Injectable } from '@nestjs/common';
import { z } from 'zod';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { OFFLINE_SYNC_POLICY } from '../config/offline-sync-policy';
import type { ChangesQueryDto } from '../dto/offline-sync/changes-query.dto';
import {
  OFFLINE_SYNC_REPOSITORY,
  type IOfflineSyncRepository,
} from '../interfaces/repositories/offline-sync-repository.interface';
import {
  MEMORY_LIBRARY_REPOSITORY,
  type IMemoryLibraryRepository,
} from '../interfaces/repositories/memory-library-repository.interface';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import type {
  IOfflineSyncService,
  ChangesResponse,
} from '../interfaces/services/offline-sync-service.interface';
const cursorSchema = z.object({
  v: z.literal(1),
  f: z.uuid(),
  u: z.uuid(),
  since: z.iso.datetime(),
  at: z.iso.datetime(),
  id: z.uuid(),
});
@Injectable()
export class OfflineSyncService implements IOfflineSyncService {
  constructor(
    @Inject(OFFLINE_SYNC_REPOSITORY)
    private readonly repository: IOfflineSyncRepository,
    @Inject(MEMORY_LIBRARY_REPOSITORY)
    private readonly library: IMemoryLibraryRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async changes(
    actor: AuthPrincipal,
    familyId: string,
    query: ChangesQueryDto,
  ): Promise<ChangesResponse> {
    const membership = await this.library.familyAccess(familyId, actor.userId);
    if (!membership || (!membership.isParent && !membership.circleActive))
      throw new NotFoundError('Family was not found.');
    if (!this.access.requireContentAccess)
      throw new NotFoundError('Family was not found.');
    await this.access.requireContentAccess(actor, familyId, 'read');
    const now = new Date();
    const parsed = query.cursor
      ? cursorSchema.safeParse(decode(query.cursor))
      : null;
    if (
      parsed &&
      (!parsed.success ||
        parsed.data.f !== familyId ||
        parsed.data.u !== actor.userId)
    )
      throw new ValidationError('Invalid changes cursor.');
    const cursor = parsed?.success ? parsed.data : null;
    const since = cursor
      ? new Date(cursor.since)
      : new Date(
          now.getTime() - OFFLINE_SYNC_POLICY.initialWindowDays * 86400000,
        );
    if (
      since > now ||
      (cursor && new Date(cursor.at) > new Date(now.getTime() + 60000))
    )
      throw new ValidationError('Invalid changes cursor.');
    if (
      cursor &&
      new Date(cursor.at).getTime() <
        now.getTime() - OFFLINE_SYNC_POLICY.initialWindowDays * 86400000
    )
      throw new DomainError(
        'Clear family cache and reload feed.',
        'SYNC_CURSOR_EXPIRED',
        409,
      );
    const limit = query.limit ?? OFFLINE_SYNC_POLICY.defaultLimit;
    if (
      !Number.isInteger(limit) ||
      limit < 1 ||
      limit > OFFLINE_SYNC_POLICY.maxLimit
    )
      throw new ValidationError('Invalid changes limit.');
    const rows = await this.repository.pull(
      familyId,
      actor.userId,
      since,
      cursor ? { at: new Date(cursor.at), id: cursor.id } : null,
      limit,
    );
    const page = rows.slice(0, limit),
      last = page.at(-1);
    const position = last
      ? { at: last.updatedAt.toISOString(), id: last.cursorId }
      : cursor
        ? { at: cursor.at, id: cursor.id }
        : {
            at: now.toISOString(),
            id: '00000000-0000-0000-0000-000000000000',
          };
    return {
      items: page.map((row) => ({
        entity: row.entity,
        id: row.id,
        ...(row.entity !== 'memory' ? { memoryId: row.memoryId } : {}),
        op: row.op,
        updatedAt: row.updatedAt.toISOString(),
        ...(row.op === 'upsert' && row.data
          ? {
              data: row.data,
              ...(row.data.version !== undefined
                ? { version: row.data.version }
                : {}),
            }
          : {}),
      })),
      nextCursor: Buffer.from(
        JSON.stringify({
          v: 1,
          f: familyId,
          u: actor.userId,
          since: since.toISOString(),
          ...position,
        }),
      ).toString('base64url'),
      hasMore: rows.length > limit,
    };
  }
}
function decode(cursor: string): unknown {
  try {
    return JSON.parse(
      Buffer.from(cursor, 'base64url').toString('utf8'),
    ) as unknown;
  } catch {
    return null;
  }
}
