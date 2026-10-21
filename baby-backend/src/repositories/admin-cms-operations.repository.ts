import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { IAdminCmsOperationsRepository } from '../interfaces/repositories/admin-cms-operations-repository.interface';
import {
  AdminCmsOperationsCase,
  AdminCmsOperationsContent,
  AdminCmsOperationsLicense,
} from '../models/admin-cms-operations.model';
type Tx = Prisma.TransactionClient;
@Injectable()
export class AdminCmsOperationsRepository implements IAdminCmsOperationsRepository {
  constructor(private readonly prisma: PrismaService) {}
  private async audit(
    tx: Tx,
    adminId: string,
    action: string,
    entityType: string,
    entityId?: string,
    reason?: string,
    changes: Prisma.InputJsonObject = {},
  ) {
    // Notes can contain pasted child content; keep them in access-controlled action history, never copy to audit.
    await tx.adminAuditEvent.create({
      data: {
        adminId,
        action,
        entityType,
        entityId,
        reasonCode: reason ? 'ADMIN_REVIEW' : null,
        redactedChanges: {
          ...changes,
          ...(reason ? { reasonProvided: true } : {}),
        },
      },
    });
  }
  private async find(tx: Tx, id: string, lock = false) {
    if (lock)
      await tx.$queryRaw`SELECT id FROM ops.moderation_cases WHERE id = ${id}::uuid AND deleted_at IS NULL FOR UPDATE`;
    const row = await tx.moderationCase.findFirst({
      where: { id, deletedAt: null },
      include: {
        moderationCaseReports: {
          where: { deletedAt: null, report: { deletedAt: null } },
          include: { report: true },
        },
        moderationActions: {
          where: { deletedAt: null },
          orderBy: { createdAt: 'asc' },
        },
      },
    });
    if (!row)
      throw new DomainError(
        'Moderation case was not found.',
        'ADMIN_CASE_NOT_FOUND',
        404,
      );
    return row;
  }
  private model(
    row: Awaited<ReturnType<AdminCmsOperationsRepository['find']>>,
  ) {
    const { moderationCaseReports, moderationActions, ...attributes } = row;
    return new AdminCmsOperationsCase({
      ...attributes,
      reports: moderationCaseReports.map(({ report }) => ({
        id: report.id,
        reason: report.reason,
        detail: report.detail,
        severity: report.severity,
        status: report.status,
        createdAt: report.createdAt,
      })),
      actions: moderationActions.map((a) => ({
        id: a.id,
        adminId: a.adminId,
        action: a.action,
        createdAt: a.createdAt,
      })),
    });
  }
  list(
    adminId: string,
    input: { status?: string; offset: number; limit: number },
  ) {
    return this.prisma.$transaction(
      async (tx) => {
        const where = {
          deletedAt: null,
          ...(input.status ? { status: input.status } : {}),
        };
        const rows = await tx.moderationCase.findMany({
          where,
          skip: input.offset,
          take: input.limit,
          orderBy: [{ priority: 'asc' }, { slaDueAt: 'asc' }, { id: 'asc' }],
        });
        const total = await tx.moderationCase.count({ where });
        await this.audit(
          tx,
          adminId,
          'MODERATION_CASE_LIST',
          'MODERATION_CASE',
        );
        return {
          items: rows.map((row) => new AdminCmsOperationsCase(row)),
          total,
        };
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }
  detail(adminId: string, id: string) {
    return this.prisma.$transaction(async (tx) => {
      const row = await this.find(tx, id);
      await this.audit(
        tx,
        adminId,
        'MODERATION_CASE_READ',
        'MODERATION_CASE',
        id,
      );
      return this.model(row);
    });
  }
  private async target(
    tx: Tx,
    row: Awaited<ReturnType<AdminCmsOperationsRepository['find']>>,
  ) {
    const reports = row.moderationCaseReports
      .map((x) => x.report)
      .filter(
        (r) =>
          r.targetId === row.targetId &&
          r.targetType === row.targetType &&
          r.familyId !== null,
      );
    if (!reports.length)
      throw new DomainError(
        'A matching active report is required.',
        'ADMIN_REPORTED_CONTENT_UNAVAILABLE',
        404,
      );
    const familyIds = reports.map((r) => r.familyId!);
    if (row.targetType === 'MEMORY') {
      await tx.$queryRaw`SELECT id FROM app.memories WHERE id = ${row.targetId}::uuid FOR UPDATE`;
      const memory = await tx.memory.findFirst({
        where: {
          id: row.targetId,
          familyId: { in: familyIds },
          deletedAt: null,
          status: { in: ['PUBLISHED', 'ARCHIVED'] },
          visibility: { in: ['FAMILY', 'PARENTS'] },
          OR: [{ unlockAt: null }, { unlockAt: { lte: new Date() } }],
        },
        select: { id: true, title: true, body: true, status: true },
      });
      if (memory) return memory;
    }
    if (row.targetType === 'COMMENT') {
      // Normal interaction writers lock the parent memory before updating a comment.
      await tx.$queryRaw`SELECT m.id FROM app.memories m JOIN app.comments c ON c.memory_id=m.id AND c.family_id=m.family_id WHERE c.id=${row.targetId}::uuid FOR UPDATE OF m`;
      const comment = await tx.comment.findFirst({
        where: {
          id: row.targetId,
          familyId: { in: familyIds },
          deletedAt: null,
          status: { in: ['ACTIVE', 'HIDDEN'] },
          memory: {
            deletedAt: null,
            status: 'PUBLISHED',
            visibility: { in: ['FAMILY', 'PARENTS'] },
            OR: [{ unlockAt: null }, { unlockAt: { lte: new Date() } }],
          },
        },
        select: { id: true, body: true, status: true },
      });
      if (comment) return comment;
    }
    throw new DomainError(
      'Reported content is unavailable or unsupported.',
      'ADMIN_REPORTED_CONTENT_UNAVAILABLE',
      404,
    );
  }
  content(adminId: string, id: string, reason: string) {
    return this.prisma.$transaction(async (tx) => {
      const row = await this.find(tx, id);
      const content = await this.target(tx, row);
      await this.audit(
        tx,
        adminId,
        'MODERATION_CONTENT_READ',
        'MODERATION_CASE',
        id,
        reason,
      );
      await tx.moderationAction.create({
        data: {
          caseId: id,
          adminId,
          action: 'VIEW_CONTENT',
          reasonNote: reason,
        },
      });
      return new AdminCmsOperationsContent(
        id,
        row.targetType,
        row.targetId,
        content,
      );
    });
  }
  status(adminId: string, id: string, status: string, reason: string) {
    return this.prisma.$transaction(async (tx) => {
      const row = await this.find(tx, id, true);
      if (row.status === 'RESOLVED' && status !== 'RESOLVED')
        throw new DomainError(
          'Resolved case cannot be reopened.',
          'ADMIN_CASE_STATE_INVALID',
          409,
        );
      await tx.moderationCase.update({
        where: { id },
        data: {
          status,
          assigneeAdminId: adminId,
          resolvedAt: status === 'RESOLVED' ? new Date() : null,
        },
      });
      await tx.moderationAction.create({
        data: {
          caseId: id,
          adminId,
          action: `SET_${status}`,
          reasonNote: reason,
        },
      });
      await this.audit(
        tx,
        adminId,
        'MODERATION_CASE_STATUS',
        'MODERATION_CASE',
        id,
        reason,
        { previousStatus: row.status, status },
      );
      return this.model(await this.find(tx, id));
    });
  }
  hide(adminId: string, id: string, reason: string) {
    return this.prisma.$transaction(async (tx) => {
      const row = await this.find(tx, id, true);
      if (row.status === 'RESOLVED')
        throw new DomainError(
          'Resolved case cannot be actioned.',
          'ADMIN_CASE_STATE_INVALID',
          409,
        );
      if (!['MEMORY', 'COMMENT'].includes(row.targetType))
        throw new DomainError(
          'This target cannot be hidden.',
          'ADMIN_HIDE_UNSUPPORTED',
          422,
        );
      const content = await this.target(tx, row);
      if (row.targetType === 'MEMORY')
        await tx.memory.update({
          where: { id: content.id },
          data: {
            status: 'ARCHIVED',
            archivedAt: new Date(),
            version: { increment: 1 },
          },
        });
      else {
        // Serialize with normal comment writers, preserve aggregate count on first hide.
        const comment = await tx.comment.findUniqueOrThrow({
          where: { id: content.id },
          select: { memoryId: true },
        });
        await tx.$queryRaw`SELECT id FROM app.memories WHERE id = ${comment.memoryId}::uuid FOR UPDATE`;
        const changed = await tx.comment.updateMany({
          where: { id: content.id, deletedAt: null, status: 'ACTIVE' },
          data: { status: 'HIDDEN' },
        });
        if (changed.count)
          await tx.$executeRaw`UPDATE app.memories SET comment_count=GREATEST(comment_count - 1,0) WHERE id=${comment.memoryId}::uuid`;
      }
      await tx.report.updateMany({
        where: {
          id: { in: row.moderationCaseReports.map((r) => r.reportId) },
          deletedAt: null,
          targetId: row.targetId,
          targetType: row.targetType,
        },
        data: { status: 'ACTION_TAKEN', closedAt: new Date() },
      });
      await tx.moderationAction.create({
        data: { caseId: id, adminId, action: 'HIDE', reasonNote: reason },
      });
      await this.audit(
        tx,
        adminId,
        'MODERATION_CONTENT_HIDE',
        'MODERATION_CASE',
        id,
        reason,
        { targetType: row.targetType, targetId: row.targetId },
      );
      return this.model(await this.find(tx, id));
    });
  }
  license(
    adminId: string,
    familyId: string,
    blocked: boolean,
    reason: string,
    reasonCode: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM billing.family_licenses WHERE family_id=${familyId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      const license = await tx.familyLicense.findFirst({
        where: {
          familyId,
          deletedAt: null,
          family: { deletedAt: null, status: { not: 'DELETED' } },
        },
      });
      if (!license)
        throw new DomainError(
          'Family license was not found.',
          'ADMIN_LICENSE_NOT_FOUND',
          404,
        );
      const result = await tx.familyLicense.update({
        where: { id: license.id },
        data: {
          blockedAt: blocked ? (license.blockedAt ?? new Date()) : null,
          blockReasonCode: blocked ? reasonCode : null,
        },
      });
      // Auth and entitlement queries already join current license on every request.
      await tx.adminAuditEvent.create({
        data: {
          adminId,
          action: blocked ? 'LICENSE_BLOCK' : 'LICENSE_UNBLOCK',
          entityType: 'FAMILY_LICENSE',
          entityId: license.id,
          reasonCode,
          redactedChanges: {
            familyId,
            previousBlocked: !!(license.blockedAt || license.blockReasonCode),
            blocked,
            reasonProvided: !!reason,
          },
        },
      });
      return new AdminCmsOperationsLicense(
        familyId,
        result.blockedAt,
        result.blockReasonCode,
      );
    });
  }
}
