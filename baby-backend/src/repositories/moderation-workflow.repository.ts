import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { MODERATION_WORKFLOW_POLICY } from '../config/moderation-workflow-policy';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { IModerationWorkflowRepository } from '../interfaces/repositories/moderation-workflow-repository.interface';
import type { JobLease } from '../models/job-lease.model';
import { ModerationWorkflowCase } from '../models/moderation-workflow.model';

@Injectable()
export class ModerationWorkflowRepository implements IModerationWorkflowRepository {
  constructor(private readonly prisma: PrismaService) {}
  private async fence(
    tx: Prisma.TransactionClient,
    lease: JobLease,
  ): Promise<void> {
    const rows = await tx.$queryRaw<{ id: string }[]>`
      SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid
      AND status = 'RUNNING' AND deleted_at IS NULL
      AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId}
      AND lease_expires_at > now() FOR UPDATE`;
    if (!rows.length)
      throw new DomainError('Job lease was lost.', 'JOB_LEASE_LOST', 409);
  }
  attachReport(
    reportId: string,
    lease?: JobLease,
  ): Promise<ModerationWorkflowCase | null> {
    return this.prisma.$transaction(async (tx) => {
      if (lease) await this.fence(tx, lease);
      await tx.$queryRaw`SELECT id FROM app.reports WHERE id = ${reportId}::uuid FOR UPDATE`;
      const report = await tx.report.findFirst({
        where: {
          id: reportId,
          deletedAt: null,
          status: { in: [...MODERATION_WORKFLOW_POLICY.reportStatuses] },
        },
      });
      if (!report) return null;
      // Serialize every writer for this object, including reports from different families.
      await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtextextended(${`moderation:${report.targetType}:${report.targetId}`}, 0))`;
      const linked = await tx.moderationCaseReport.findFirst({
        where: {
          reportId,
          deletedAt: null,
          moderationCase: { deletedAt: null },
        },
        include: { moderationCase: true },
      });
      if (linked) return this.model(linked.moderationCase);
      const current = await tx.moderationCase.findFirst({
        where: {
          targetType: report.targetType,
          targetId: report.targetId,
          deletedAt: null,
          resolvedAt: null,
          status: { in: [...MODERATION_WORKFLOW_POLICY.openStatuses] },
        },
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      });
      const data = {
        priority: Math.min(
          current?.priority ?? report.severity,
          report.severity,
        ),
        slaDueAt:
          current && current.slaDueAt < report.slaDueAt
            ? current.slaDueAt
            : report.slaDueAt,
      };
      const row = current
        ? await tx.moderationCase.update({ where: { id: current.id }, data })
        : await tx.moderationCase.create({
            data: {
              ...data,
              targetType: report.targetType,
              targetId: report.targetId,
            },
          });
      await tx.moderationCaseReport.upsert({
        where: { caseId_reportId: { caseId: row.id, reportId } },
        create: { caseId: row.id, reportId },
        update: { deletedAt: null },
      });
      return this.model(row);
    });
  }
  async unattachedReports(limit: number, familyId?: string): Promise<string[]> {
    const rows = await this.prisma.report.findMany({
      where: {
        deletedAt: null,
        ...(familyId ? { familyId } : {}),
        status: { in: [...MODERATION_WORKFLOW_POLICY.reportStatuses] },
        moderationCaseReports: {
          none: { deletedAt: null, moderationCase: { deletedAt: null } },
        },
      },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      take: limit,
      select: { id: true },
    });
    return rows.map((row) => row.id);
  }
  escalateDue(
    now: Date,
    lease: JobLease,
    limit: number,
    familyId?: string,
  ): Promise<number> {
    return this.prisma.$transaction(async (tx) => {
      await this.fence(tx, lease);
      const rows = await tx.moderationCase.findMany({
        where: {
          deletedAt: null,
          status: {
            in: [...MODERATION_WORKFLOW_POLICY.openStatuses].filter(
              (status) => status !== 'ESCALATED',
            ),
          },
          slaDueAt: { lte: now },
          resolvedAt: null,
          ...(familyId
            ? {
                moderationCaseReports: {
                  some: {
                    deletedAt: null,
                    report: { familyId, deletedAt: null },
                  },
                },
              }
            : {}),
        },
        orderBy: [{ slaDueAt: 'asc' }, { id: 'asc' }],
        take: limit,
        select: { id: true },
      });
      const result = await tx.moderationCase.updateMany({
        where: {
          id: { in: rows.map((row) => row.id) },
          deletedAt: null,
          resolvedAt: null,
          status: {
            in: [...MODERATION_WORKFLOW_POLICY.openStatuses].filter(
              (status) => status !== 'ESCALATED',
            ),
          },
          slaDueAt: { lte: now },
        },
        data: { status: 'ESCALATED' },
      });
      return result.count;
    });
  }
  private model(row: {
    id: string;
    targetType: string;
    targetId: string;
    priority: number;
    status: string;
    slaDueAt: Date;
    createdAt: Date;
    updatedAt: Date;
    deletedAt: Date | null;
  }): ModerationWorkflowCase {
    return new ModerationWorkflowCase(
      row.id,
      row.targetType,
      row.targetId,
      row.priority,
      row.status,
      row.slaDueAt,
      row.createdAt,
      row.updatedAt,
      row.deletedAt,
    );
  }
}
