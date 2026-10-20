import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type {
  BlockedUserRecord,
  CreateReportCommand,
  FamilyRoleOf,
  ISafetyRepository,
  ReportRecord,
} from '../interfaces/repositories/safety-repository.interface';

const OPEN_STATUSES = ['NEW', 'TRIAGE', 'IN_REVIEW', 'NEED_INFO'] as const;

@Injectable()
export class SafetyRepository implements ISafetyRepository {
  constructor(private readonly prisma: PrismaService) {}

  async roleOf(familyId: string, userId: string): Promise<FamilyRoleOf> {
    const now = new Date();
    const parent = await this.prisma.familyParent.count({
      where: {
        familyId,
        userId,
        status: 'ACTIVE',
        deletedAt: null,
        leftAt: null,
        joinedAt: { lte: now },
        family: { deletedAt: null },
      },
    });
    if (parent) return 'PARENT';
    const circle = await this.prisma.circleMember.count({
      where: {
        familyId,
        userId,
        status: { in: ['ACTIVE', 'PAUSED', 'SUSPENDED_PLAN'] },
        deletedAt: null,
        endedAt: null,
        joinedAt: { lte: now },
      },
    });
    return circle ? 'CIRCLE' : null;
  }

  async commentContext(
    familyId: string,
    commentId: string,
  ): Promise<{ memoryId: string; authorUserId: string } | null> {
    const row = await this.prisma.comment.findFirst({
      where: { id: commentId, familyId, status: 'ACTIVE', deletedAt: null },
      select: { memoryId: true, authorUserId: true },
    });
    return row ?? null;
  }

  createReport(command: CreateReportCommand): Promise<ReportRecord> {
    return this.prisma.$transaction(async (tx) => {
      // Serialises double taps on "Gửi báo cáo" for the same target.
      const key = `report:${command.reporterUserId}:${command.targetType}:${command.targetId}`;
      await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtext(${key}))`;
      if (command.hideForReporter && command.targetType !== 'USER')
        await tx.reportHide.upsert({
          where: {
            userId_targetType_targetId: {
              userId: command.reporterUserId,
              targetType: command.targetType,
              targetId: command.targetId,
            },
          },
          create: {
            userId: command.reporterUserId,
            targetType: command.targetType,
            targetId: command.targetId,
          },
          update: { deletedAt: null, updatedAt: new Date() },
        });
      const open = await tx.report.findFirst({
        where: {
          reporterUserId: command.reporterUserId,
          targetType: command.targetType,
          targetId: command.targetId,
          status: { in: [...OPEN_STATUSES] },
          deletedAt: null,
        },
        orderBy: { createdAt: 'desc' },
      });
      if (open)
        return { id: open.id, status: open.status, createdAt: open.createdAt };
      const row = await tx.report.create({
        data: {
          reporterUserId: command.reporterUserId,
          familyId: command.familyId,
          targetType: command.targetType,
          targetId: command.targetId,
          targetOwnerId: command.targetOwnerId,
          reason: command.reason,
          detail: command.detail,
          severity: command.severity,
          hideForReporter: command.hideForReporter,
          slaDueAt: command.slaDueAt,
        },
      });
      return { id: row.id, status: row.status, createdAt: row.createdAt };
    });
  }

  async block(
    familyId: string,
    blockerUserId: string,
    blockedUserId: string,
  ): Promise<void> {
    await this.prisma.block.upsert({
      where: {
        familyId_blockerUserId_blockedUserId: {
          familyId,
          blockerUserId,
          blockedUserId,
        },
      },
      create: { familyId, blockerUserId, blockedUserId },
      update: { deletedAt: null, updatedAt: new Date() },
    });
  }

  async unblock(
    familyId: string,
    blockerUserId: string,
    blockedUserId: string,
  ): Promise<void> {
    await this.prisma.block.updateMany({
      where: { familyId, blockerUserId, blockedUserId, deletedAt: null },
      data: { deletedAt: new Date(), updatedAt: new Date() },
    });
  }

  async listBlocks(
    familyId: string,
    blockerUserId: string,
  ): Promise<BlockedUserRecord[]> {
    const rows = await this.prisma.block.findMany({
      where: { familyId, blockerUserId, deletedAt: null },
      include: {
        usersBlocksBlockedUserIdTousers: { select: { displayName: true } },
      },
      orderBy: { updatedAt: 'desc' },
    });
    return rows.map((row) => ({
      userId: row.blockedUserId,
      displayName: row.usersBlocksBlockedUserIdTousers.displayName,
      blockedAt: row.updatedAt,
    }));
  }
}
