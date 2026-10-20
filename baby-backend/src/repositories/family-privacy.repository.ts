import { Injectable } from '@nestjs/common';
import { cloneDatabaseJson } from '../common/database.types';
import { PrismaService } from '../database/prisma.service';
import type { IFamilyPrivacyRepository } from '../interfaces/repositories/family-privacy-repository.interface';
import { FamilyErasure } from '../models/family-erasure.model';
import { FamilyPrivacySnapshot } from '../models/family-privacy.model';

@Injectable()
export class FamilyPrivacyRepository implements IFamilyPrivacyRepository {
  constructor(private readonly prisma: PrismaService) {}

  findOverview(
    familyId: string,
    userId: string,
  ): Promise<FamilyPrivacySnapshot | null> {
    return this.prisma.$transaction(
      async (tx) => {
        const now = new Date();
        const family = await tx.family.findFirst({
          where: { id: familyId, deletedAt: null, status: { not: 'DELETED' } },
          select: {
            settings: true,
            familyParents: { where: { userId } },
            circleMembers: { where: { userId } },
          },
        });
        if (
          !family ||
          (!family.familyParents.length && !family.circleMembers.length)
        )
          return null;
        const parent = family.familyParents.some(
          (p) =>
            p.status === 'ACTIVE' &&
            p.deletedAt === null &&
            p.leftAt === null &&
            p.joinedAt <= now,
        );
        if (!parent)
          return new FamilyPrivacySnapshot(
            family.circleMembers.some(
              (m) =>
                m.status === 'ACTIVE' &&
                m.deletedAt === null &&
                m.endedAt === null &&
                m.joinedAt <= now,
            )
              ? 'CIRCLE'
              : 'INACTIVE',
            {},
            [],
            0,
            0,
            null,
            null,
          );
        const members = await tx.circleMember.findMany({
          where: {
            familyId,
            deletedAt: null,
            endedAt: null,
            joinedAt: { lte: now },
            status: { in: ['ACTIVE', 'PAUSED', 'SUSPENDED_PLAN'] },
            usersCircleMembersUserIdTousers: {
              deletedAt: null,
              status: 'ACTIVE',
            },
          },
          orderBy: [{ joinedAt: 'asc' }, { id: 'asc' }],
          select: {
            id: true,
            displayName: true,
            relation: true,
            status: true,
            circleGrants: {
              where: {
                familyId,
                deletedAt: null,
                status: 'ACTIVE',
                OR: [
                  { child: { familyId, deletedAt: null } },
                  { pregnancy: { familyId, deletedAt: null } },
                ],
              },
              orderBy: { id: 'asc' },
              select: {
                childId: true,
                pregnancyId: true,
                permission: true,
                allowDownload: true,
              },
            },
          },
        });
        const pendingInvites = await tx.familyInvite.count({
          where: {
            familyId,
            type: 'CIRCLE',
            deletedAt: null,
            status: { in: ['PENDING', 'AWAITING_APPROVAL'] },
            expiresAt: { gt: now },
          },
        });
        const blockedCount = await tx.block.count({
          where: {
            familyId,
            blockerUserId: userId,
            deletedAt: null,
            usersBlocksBlockedUserIdTousers: { deletedAt: null },
          },
        });
        const dataExport = await tx.exportJob.findFirst({
          where: {
            requesterId: userId,
            deletedAt: null,
            OR: [{ familyId }, { familyId: null, scope: 'PERSONAL' }],
          },
          orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
          select: {
            id: true,
            scope: true,
            status: true,
            createdAt: true,
            completedAt: true,
            expiresAt: true,
            errorCode: true,
          },
        });
        const deletion = await tx.familyDeletionRequest.findFirst({
          where: { familyId, deletedAt: null },
          orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        });
        return new FamilyPrivacySnapshot(
          'PARENT',
          cloneDatabaseJson(family.settings),
          members.map((m) => ({
            memberId: m.id,
            displayName: m.displayName,
            relation: m.relation,
            status: m.status,
            grants: m.circleGrants.map((g) => ({
              ...(g.childId
                ? { childId: g.childId }
                : { pregnancyId: g.pregnancyId! }),
              permission: g.permission,
              allowDownload: g.allowDownload,
            })),
          })),
          pendingInvites,
          blockedCount,
          dataExport,
          deletion
            ? new FamilyErasure({
                ...deletion,
                steps: cloneDatabaseJson(deletion.steps),
              })
            : null,
        );
      },
      { isolationLevel: 'RepeatableRead' },
    );
  }
}
