import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import type { IAuthAccessRepository } from '../interfaces/repositories/auth-access-repository.interface';
import { AuthSessionState } from '../models/auth-session-state.model';
import { FamilyAccessState } from '../models/family-access-state.model';
import { Family } from '../models/family.model';
import { FamilyEntitlement } from '../models/family-entitlement.model';

@Injectable()
export class AuthAccessRepository implements IAuthAccessRepository {
  constructor(private readonly prisma: PrismaService) {}

  findUserSessionState(
    sessionId: string,
    userId: string,
    now: Date,
  ): Promise<AuthSessionState | null> {
    return this.prisma.$transaction(
      async (tx) => {
        const where = {
          id: sessionId,
          userId,
          deletedAt: null,
          revokedAt: null,
          replacedBy: null,
          expiresAt: { gt: now },
          absoluteExpiresAt: { gt: now },
        };
        const select = {
          id: true,
          userId: true,
          user: { select: { tokenVersion: true } },
        } as const;
        let row = await tx.userSession.findFirst({
          where: { ...where, user: { status: 'ACTIVE', deletedAt: null } },
          select,
        });
        // Keep ordinary active-session verification independent of deletion recovery.
        if (!row) {
          const pending = await tx.userSession.findFirst({
            where: {
              ...where,
              user: { status: 'DELETION_PENDING', deletedAt: null },
            },
            select: {
              ...select,
              user: { select: { tokenVersion: true, status: true } },
            },
          });
          if (pending?.user.status !== 'DELETION_PENDING') return null;
          const grace = await tx.deletionRequest.findFirst({
            where: {
              userId,
              deletedAt: null,
              status: 'SCHEDULED',
              executeAfter: { gt: now },
            },
            select: { id: true },
          });
          if (!grace) return null;
          row = pending;
        }

        return row
          ? new AuthSessionState({
              sessionId: row.id,
              userId: row.userId,
              tokenVersion: row.user.tokenVersion,
            })
          : null;
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }

  findFamilyAccessState(
    familyId: string,
    userId: string,
    now: Date,
  ): Promise<FamilyAccessState | null> {
    const activeParent = {
      status: 'ACTIVE' as const,
      deletedAt: null,
      leftAt: null,
      joinedAt: { lte: now },
      user: { status: 'ACTIVE' as const, deletedAt: null },
    };
    return this.prisma.$transaction(
      async (tx) => {
        const row = await tx.family.findFirst({
          where: {
            id: familyId,
            deletedAt: null,
            status: { not: 'DELETED' },
            familyParents: { some: { ...activeParent, userId } },
          },
          include: {
            _count: { select: { familyParents: { where: activeParent } } },
            familyLicense: true,
          },
        });
        if (!row) return null;
        const license = row.familyLicense;
        const licenseBlocked =
          !license ||
          license.deletedAt !== null ||
          license.blockedAt !== null ||
          license.blockReasonCode !== null;
        const entitlement =
          license && license.deletedAt === null
            ? await tx.familyEntitlement.findFirst({
                where: { familyId, licenseId: license.id, deletedAt: null },
              })
            : null;
        return new FamilyAccessState({
          family: new Family({
            ...row,
            settings: cloneDatabaseJson(row.settings),
          }),
          activeParentCount: row._count.familyParents,
          licenseBlocked,
          entitlement: entitlement ? new FamilyEntitlement(entitlement) : null,
        });
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }
}
