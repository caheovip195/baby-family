import { Injectable } from '@nestjs/common';
import { cloneDatabaseJson } from '../common/database.types';
import { DomainError } from '../common/errors/domain.error';
import { FAMILY_ERASURE_POLICY as POLICY } from '../config/family-erasure-policy';
import { PrismaService } from '../database/prisma.service';
import type { FamilyDeletionRequest, Prisma } from '../generated/prisma/client';
import type { IFamilyErasureRepository } from '../interfaces/repositories/family-erasure-repository.interface';
import { FamilyErasure } from '../models/family-erasure.model';
import type { JobLease } from '../models/job-lease.model';
const model = (row: FamilyDeletionRequest) =>
  new FamilyErasure({ ...row, steps: cloneDatabaseJson(row.steps) });
const active = ['PENDING_APPROVAL', 'SCHEDULED', 'RUNNING'];
const conflict = (code: string) =>
  new DomainError('Family deletion transition is unavailable.', code, 409);
@Injectable()
export class FamilyErasureRepository implements IFamilyErasureRepository {
  constructor(private readonly prisma: PrismaService) {}
  async latest(familyId: string) {
    const row = await this.prisma.familyDeletionRequest.findFirst({
      where: { familyId, deletedAt: null },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
    });
    return row ? model(row) : null;
  }
  transition(
    familyId: string,
    userId: string,
    action: 'request' | 'confirm' | 'cancel',
    now: Date,
    reason?: string,
  ): Promise<FamilyErasure> {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${familyId}::uuid FOR UPDATE`;
      const family = await tx.family.findFirst({
        where: { id: familyId, deletedAt: null, status: { not: 'DELETED' } },
      });
      const parents = await tx.familyParent.findMany({
        where: {
          familyId,
          status: 'ACTIVE',
          deletedAt: null,
          leftAt: null,
          joinedAt: { lte: now },
        },
      });
      if (!family || !parents.some((p) => p.userId === userId))
        throw new DomainError('Family was not found.', 'NOT_FOUND', 404);
      let row = await tx.familyDeletionRequest.findFirst({
        where: { familyId, deletedAt: null, status: { in: active } },
      });
      if (action === 'request') {
        if (row) return model(row);
        if (
          !['ACTIVE', 'PARTNER_LEFT'].includes(family.status) ||
          (family.status === 'ACTIVE' && parents.length !== 2) ||
          (family.status === 'PARTNER_LEFT' && parents.length !== 1)
        )
          throw conflict('FAMILY_DELETION_UNAVAILABLE');
        row = await tx.familyDeletionRequest.create({
          data: {
            familyId,
            requestedBy: userId,
            reasonCode: reason,
            createdAt: now,
            steps: {
              policyVersion: POLICY.version,
              graceDays: POLICY.graceDays,
              previousStatus: family.status,
            },
          },
        });
        await this.approve(tx, row, userId, now);
        if (family.status === 'PARTNER_LEFT')
          row = await this.schedule(tx, row, now);
      } else {
        if (!row) {
          const last = await tx.familyDeletionRequest.findFirst({
            where: { familyId, deletedAt: null },
            orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
          });
          if (action === 'cancel' && last?.status === 'CANCELLED')
            return model(last);
          throw conflict('FAMILY_DELETION_NOT_PENDING');
        }
        if (
          row.status === 'RUNNING' ||
          (row.executeAfter && row.executeAfter <= now)
        )
          throw conflict('FAMILY_DELETION_TOO_LATE');
        if (action === 'confirm') {
          if (row.requestedBy === userId)
            throw new DomainError(
              'The other Parent must confirm.',
              'FAMILY_DELETION_PARTNER_REQUIRED',
              403,
            );
          if (row.status === 'SCHEDULED') return model(row);
          if (parents.length !== 2)
            throw conflict('FAMILY_DELETION_MEMBERSHIP_CHANGED');
          await this.approve(tx, row, userId, now);
          row = await this.schedule(tx, row, now);
        } else {
          const snapshot = model(row).steps;
          const prior =
            typeof snapshot === 'object' &&
            snapshot !== null &&
            !Array.isArray(snapshot)
              ? snapshot.previousStatus
              : null;
          await tx.familyDeletionApproval.upsert({
            where: {
              requestId_userId_requestVersion: {
                requestId: row.id,
                userId,
                requestVersion: row.requestVersion,
              },
            },
            create: {
              requestId: row.id,
              familyId,
              userId,
              requestVersion: row.requestVersion,
              decision: 'DECLINED',
              decidedAt: now,
            },
            update: { decision: 'DECLINED', decidedAt: now },
          });
          row = await tx.familyDeletionRequest.update({
            where: { id: row.id },
            data: { status: 'CANCELLED', cancelledAt: now },
          });
          if (family.status === 'DELETION_SCHEDULED')
            await tx.family.update({
              where: { id: familyId },
              data: {
                status:
                  parents.length === 1 || prior === 'PARTNER_LEFT'
                    ? 'PARTNER_LEFT'
                    : 'ACTIVE',
                deletionScheduledAt: null,
                accessVersion: { increment: 1 },
              },
            });
          await this.event(tx, row, 'family.deletion_cancelled');
        }
      }
      return model(row);
    });
  }
  async due(now: Date, limit: number, familyId?: string) {
    return (
      await this.prisma.familyDeletionRequest.findMany({
        where: {
          familyId,
          status: 'SCHEDULED',
          deletedAt: null,
          executeAfter: { lte: now },
        },
        orderBy: [{ executeAfter: 'asc' }, { id: 'asc' }],
        take: limit,
      })
    ).map(model);
  }
  complete(id: string, now: Date, lease: JobLease): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const owned = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR SHARE`;
      if (!owned.length)
        throw new DomainError('Job lease expired.', 'JOB_LEASE_LOST', 409);
      const found = await tx.familyDeletionRequest.findUnique({
        where: { id },
      });
      if (!found) return false;
      // Every transition locks family before request, including the executor.
      await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${found.familyId}::uuid FOR UPDATE`;
      const row = await tx.familyDeletionRequest.findFirst({
        where: {
          id,
          deletedAt: null,
          status: 'SCHEDULED',
          executeAfter: { lte: now },
        },
      });
      if (!row) return false;
      const family = await tx.family.findFirst({
        where: {
          id: row.familyId,
          status: 'DELETION_SCHEDULED',
          deletedAt: null,
        },
      });
      if (!family) throw conflict('FAMILY_DELETION_LIFECYCLE_CHANGED');
      await tx.asset.updateMany({
        where: { familyId: row.familyId, status: { not: 'DELETED' } },
        data: { status: 'DELETED', deletedAt: now, purgeAfter: now },
      });
      await tx.family.update({
        where: { id: row.familyId },
        data: {
          status: 'DELETED',
          deletedAt: now,
          accessVersion: { increment: 1 },
        },
      });
      await tx.familyDeletionRequest.update({
        where: { id },
        data: { status: 'COMPLETED', completedAt: now },
      });
      await this.event(tx, row, 'family.deleted');
      return true;
    });
  }
  private async approve(
    tx: Prisma.TransactionClient,
    row: FamilyDeletionRequest,
    userId: string,
    now: Date,
  ) {
    await tx.familyDeletionApproval.create({
      data: {
        requestId: row.id,
        familyId: row.familyId,
        userId,
        requestVersion: row.requestVersion,
        decision: 'APPROVED',
        decidedAt: now,
      },
    });
  }
  private async schedule(
    tx: Prisma.TransactionClient,
    row: FamilyDeletionRequest,
    now: Date,
  ) {
    const snapshot = model(row).steps;
    const days =
      typeof snapshot === 'object' &&
      snapshot !== null &&
      !Array.isArray(snapshot)
        ? snapshot.graceDays
        : null;
    if (typeof days !== 'number' || days <= 0)
      throw conflict('FAMILY_DELETION_POLICY_INVALID');
    const scheduled = await tx.familyDeletionRequest.update({
      where: { id: row.id },
      data: {
        status: 'SCHEDULED',
        executeAfter: new Date(now.getTime() + days * 86400000),
      },
    });
    await tx.family.update({
      where: { id: row.familyId },
      data: {
        status: 'DELETION_SCHEDULED',
        deletionScheduledAt: scheduled.executeAfter,
        accessVersion: { increment: 1 },
      },
    });
    await this.event(tx, scheduled, 'family.deletion_scheduled');
    return scheduled;
  }
  private async event(
    tx: Prisma.TransactionClient,
    row: FamilyDeletionRequest,
    eventType: string,
  ) {
    await tx.outboxEvent.create({
      data: {
        eventType,
        familyId: row.familyId,
        aggregateId: row.id,
        payload: { version: 1, requestId: row.id },
      },
    });
  }
}
