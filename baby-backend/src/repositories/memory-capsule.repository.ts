import { Prisma } from '../generated/prisma/client';
import { memoryContentScope } from './memory-content-visibility';
import { Injectable } from '@nestjs/common';
import { cloneDatabaseJson } from '../common/database.types';
import { FamilyEntitlement } from '../models/family-entitlement.model';
import { MEMORY_LETTER_RELEASE_POLICY } from '../config/jobs';
import { PrismaService } from '../database/prisma.service';
import type {
  IMemoryCapsuleRepository,
  CapsuleAccess,
  CapsuleView,
} from '../interfaces/repositories/memory-capsule-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { Memory } from '../models/memory.model';
import { MemoryLetter } from '../models/memory-letter.model';

@Injectable()
export class MemoryCapsuleRepository implements IMemoryCapsuleRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findAccess(
    childId: string,
    userId: string,
  ): Promise<CapsuleAccess | null> {
    const now = new Date();
    const child = await this.prisma.child.findFirst({
      where: { id: childId, deletedAt: null },
      include: {
        family: {
          include: {
            familyParents: { where: { userId } },
            circleMembers: {
              where: { userId },
              include: {
                circleGrants: {
                  where: { childId, status: 'ACTIVE', deletedAt: null },
                },
              },
            },
            familyEntitlement: { include: { planVersion: true } },
            familyLicense: true,
          },
        },
      },
    });
    if (!child || child.family.deletedAt || child.family.status === 'DELETED')
      return null;
    const family = child.family;
    if (!family.familyParents.length && !family.circleMembers.length)
      return null;
    const parent = family.familyParents.some(
      (p) =>
        p.status === 'ACTIVE' && !p.deletedAt && !p.leftAt && p.joinedAt <= now,
    );
    const circle = family.circleMembers.find(
      (c) =>
        c.status === 'ACTIVE' &&
        !c.deletedAt &&
        !c.endedAt &&
        c.joinedAt <= now,
    );
    return {
      entitlement: family.familyEntitlement
        ? new FamilyEntitlement(family.familyEntitlement)
        : null,
      features:
        family.familyEntitlement?.planVersion &&
        !family.familyEntitlement.planVersion.deletedAt
          ? cloneDatabaseJson(family.familyEntitlement.planVersion.features)
          : null,
      familyId: child.familyId,
      role: parent ? 'PARENT' : circle ? 'CIRCLE' : 'INACTIVE',
      granted: child.status === 'ACTIVE' && !!circle?.circleGrants.length,
      familyActive: family.status === 'ACTIVE',
      licenseBlocked:
        family.familyEntitlement?.accessPhase === 'BLOCKED' ||
        !!family.familyLicense?.blockedAt ||
        !!family.familyLicense?.deletedAt,
    };
  }
  async list(
    childId: string,
    familyId: string,
    userId: string,
    circle: boolean,
  ): Promise<CapsuleView[]> {
    const circleScope = circle
      ? await memoryContentScope(this.prisma, familyId, userId)
      : null;
    const rows = await this.prisma.memoryLetter.findMany({
      where: {
        childId,
        familyId,
        deletedAt: null,
        memory: {
          familyId,
          kind: 'LETTER',
          deletedAt: null,
          OR: circle
            ? [{ status: 'PUBLISHED', unlockAt: null, visibility: 'FAMILY' }]
            : [
                {
                  authorUserId: userId,
                  status: { in: ['PUBLISHED', 'PROCESSING', 'DRAFT'] },
                },
                { status: 'PUBLISHED', unlockAt: { not: null } },
                {
                  status: 'PUBLISHED',
                  visibility: { in: ['PARENTS', 'FAMILY'] },
                },
              ],
          // A linked pregnancy that ended privately must never leak to Circle.
          ...(circle
            ? {
                AND: [
                  ...(circleScope ? [circleScope.where] : []),
                  {
                    OR: [
                      { pregnancyId: null },
                      {
                        pregnancy: {
                          deletedAt: null,
                          status: { in: ['ACTIVE', 'COMPLETED'] },
                        },
                      },
                    ],
                  },
                ],
              }
            : {}),
        },
      },
      include: {
        memory: {
          include: {
            memoryAsset: {
              where: { deletedAt: null, asset: { deletedAt: null } },
              orderBy: { sortOrder: 'asc' },
            },
          },
        },
      },
      orderBy: [{ memory: { occurredAt: 'desc' } }, { memoryId: 'desc' }],
    });
    return rows.map((row) => ({
      memory: new Memory(row.memory),
      letter: new MemoryLetter(row),
      assetIds: row.memory.memoryAsset.map((a) => a.assetId),
    }));
  }
  async releaseDue(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<number> {
    return this.prisma.$transaction(async (tx) => {
      context.signal.throwIfAborted();
      const { lease } = context;
      const owned = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR UPDATE`;
      if (!owned.length) throw new Error('Memory release job lease lost.');
      const due = await tx.$queryRaw<
        { id: string }[]
      >`SELECT m.id FROM app.memories m JOIN app.memory_letters l ON l.memory_id = m.id AND l.family_id = m.family_id JOIN app.families f ON f.id = m.family_id WHERE m.kind = 'LETTER' AND m.status = 'PUBLISHED' AND m.deleted_at IS NULL AND l.deleted_at IS NULL AND m.unlock_at <= ${now} AND f.deleted_at IS NULL AND f.status IN ('ACTIVE', 'PARTNER_LEFT') AND (m.pregnancy_id IS NULL OR EXISTS (SELECT 1 FROM app.pregnancies p WHERE p.id = m.pregnancy_id AND p.family_id = m.family_id AND p.deleted_at IS NULL AND p.status IN ('ACTIVE', 'COMPLETED'))) AND ${familyId ? Prisma.sql`m.family_id = ${familyId}::uuid` : Prisma.sql`TRUE`} ORDER BY m.unlock_at, m.id LIMIT ${MEMORY_LETTER_RELEASE_POLICY.batchSize} FOR UPDATE OF m SKIP LOCKED`;
      let released = 0;
      for (const { id } of due) {
        context.signal.throwIfAborted();
        const letter = await tx.memoryLetter.findUniqueOrThrow({
          where: { memoryId: id },
        });
        const memory = await tx.memory.update({
          where: { id },
          data: {
            unlockAt: null,
            visibility: letter.releaseVisibility,
            version: { increment: 1 },
          },
        });
        await tx.outboxEvent.create({
          data: {
            familyId: memory.familyId,
            aggregateId: id,
            eventType: 'memory.letter.released',
            payload: { memoryId: id, familyId: memory.familyId },
          },
        });
        released++;
      }
      context.signal.throwIfAborted();
      const stillOwned = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL`;
      if (!stillOwned.length) throw new Error('Memory release job lease lost.');
      return released;
    });
  }
}
