import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { JournalEntry as JournalEntryRow } from '../generated/prisma/client';
import type {
  ICoupleJournalRepository,
  CreateJournalEntryCommand,
  UpdateJournalEntryCommand,
  CreateJournalShareCommand,
} from '../interfaces/repositories/couple-journal-repository.interface';
import { JournalEntry } from '../models/journal-entry.model';
import {
  CoupleJournalScope,
  CoupleJournalEntryView,
} from '../models/couple-journal-view.model';

const orderBy: Prisma.JournalEntryOrderByWithRelationInput[] = [
  { createdAt: 'desc' },
  { id: 'desc' },
];

function view(
  row: JournalEntryRow,
  assetIds: string[] = [],
): CoupleJournalEntryView {
  return new CoupleJournalEntryView(new JournalEntry(row), assetIds);
}

@Injectable()
export class CoupleJournalRepository implements ICoupleJournalRepository {
  constructor(private readonly prisma: PrismaService) {}

  async resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleJournalScope | null> {
    const pair = await this.prisma.coupleSpace.findFirst({
      where: {
        familyId,
        status: 'ACTIVE',
        deletedAt: null,
        disabledAt: null,
        OR: [{ parentAUserId: userId }, { parentBUserId: userId }],
      },
    });

    return pair
      ? new CoupleJournalScope(
          familyId,
          userId,
          pair.id,
          pair.parentAUserId === userId
            ? pair.parentBUserId
            : pair.parentAUserId,
        )
      : null;
  }

  async verifyAssets(
    scope: CoupleJournalScope,
    assetIds: string[],
  ): Promise<boolean> {
    if (assetIds.length === 0) return true;

    const assets = await this.prisma.asset.findMany({
      where: {
        id: { in: assetIds },
        familyId: scope.familyId,
        uploaderUserId: scope.userId,
        purpose: 'JOURNAL',
        // The app attaches a photo right after the upload completes; the media
        // worker finishes variants afterwards (BF-20261019-004).
        status: { in: ['UPLOADED', 'PROCESSING', 'READY'] },
        deletedAt: null,
      },
      select: { id: true },
    });

    return assets.length === assetIds.length;
  }

  async create(
    scope: CoupleJournalScope,
    command: CreateJournalEntryCommand,
  ): Promise<CoupleJournalEntryView> {
    return this.prisma.$transaction(async (tx) => {
      const row = await tx.journalEntry.create({
        data: {
          familyId: scope.familyId,
          userId: scope.userId,
          titleEnc: command.titleEnc ? new Uint8Array(command.titleEnc) : null,
          bodyEnc: new Uint8Array(command.bodyEnc),
          mood: command.mood,
          createdAt: command.createdAt,
        },
      });

      if (command.assetIds.length > 0) {
        await tx.journalAsset.createMany({
          data: command.assetIds.map((assetId, index) => ({
            entryId: row.id,
            assetId,
            familyId: scope.familyId,
            ownerUserId: scope.userId,
            sortOrder: index,
            createdAt: command.createdAt,
          })),
        });
      }

      await tx.outboxEvent.create({
        data: {
          eventType: 'us.journal.created',
          familyId: scope.familyId,
          aggregateId: row.id,
          payload: {
            entryId: row.id,
            familyId: scope.familyId,
            userId: scope.userId,
          },
        },
      });

      return view(row, command.assetIds);
    });
  }

  async findById(
    scope: CoupleJournalScope,
    id: string,
  ): Promise<CoupleJournalEntryView | null> {
    const row = await this.prisma.journalEntry.findFirst({
      where: {
        id,
        familyId: scope.familyId,
        userId: scope.userId,
        deletedAt: null,
      },
      include: {
        journalAssets: {
          where: { deletedAt: null },
          orderBy: { sortOrder: 'asc' },
        },
      },
    });

    return row
      ? view(
          row,
          row.journalAssets.map((a) => a.assetId),
        )
      : null;
  }

  async list(
    scope: CoupleJournalScope,
    cursor: string | undefined,
    limit: number,
  ): Promise<CoupleJournalEntryView[]> {
    const where: Prisma.JournalEntryWhereInput = {
      familyId: scope.familyId,
      userId: scope.userId,
      deletedAt: null,
    };

    const anchor = cursor
      ? await this.prisma.journalEntry.findFirst({
          where: { ...where, id: cursor },
        })
      : null;

    if (cursor && !anchor) {
      throw new DomainError(
        'The journal cursor is invalid.',
        'JOURNAL_CURSOR_INVALID',
        400,
      );
    }

    const rows = await this.prisma.journalEntry.findMany({
      where: {
        ...where,
        ...(anchor
          ? {
              OR: [
                { createdAt: { lt: anchor.createdAt } },
                { createdAt: anchor.createdAt, id: { lt: anchor.id } },
              ],
            }
          : {}),
      },
      include: {
        journalAssets: {
          where: { deletedAt: null },
          orderBy: { sortOrder: 'asc' },
        },
      },
      orderBy,
      take: limit,
    });

    return rows.map((row) =>
      view(
        row,
        row.journalAssets.map((a) => a.assetId),
      ),
    );
  }

  async update(
    scope: CoupleJournalScope,
    id: string,
    command: UpdateJournalEntryCommand,
  ): Promise<CoupleJournalEntryView> {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.journalEntry.findFirst({
        where: {
          id,
          familyId: scope.familyId,
          userId: scope.userId,
          deletedAt: null,
        },
      });

      if (!existing) {
        throw new DomainError(
          'Journal entry was not found.',
          'JOURNAL_ENTRY_NOT_FOUND',
          404,
        );
      }

      const now = new Date();
      const updateData: Prisma.JournalEntryUpdateInput = {
        updatedAt: now,
      };

      if (command.titleEnc !== undefined) {
        updateData.titleEnc = command.titleEnc
          ? new Uint8Array(command.titleEnc)
          : null;
      }
      if (command.bodyEnc !== undefined) {
        updateData.bodyEnc = new Uint8Array(command.bodyEnc);
      }
      if (command.mood !== undefined) {
        updateData.mood = command.mood;
      }

      const updated = await tx.journalEntry.update({
        where: { id },
        data: updateData,
      });

      let assetIds: string[];
      if (command.assetIds !== undefined) {
        await tx.journalAsset.updateMany({
          where: { entryId: id, deletedAt: null },
          data: { deletedAt: now, updatedAt: now },
        });

        if (command.assetIds.length > 0) {
          await tx.journalAsset.createMany({
            data: command.assetIds.map((assetId, index) => ({
              entryId: id,
              assetId,
              familyId: scope.familyId,
              ownerUserId: scope.userId,
              sortOrder: index,
              createdAt: now,
            })),
          });
        }
        assetIds = command.assetIds;
      } else {
        const currentAssets = await tx.journalAsset.findMany({
          where: { entryId: id, deletedAt: null },
          orderBy: { sortOrder: 'asc' },
        });
        assetIds = currentAssets.map((a) => a.assetId);
      }

      return view(updated, assetIds);
    });
  }

  async delete(scope: CoupleJournalScope, id: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const existing = await tx.journalEntry.findFirst({
        where: {
          id,
          familyId: scope.familyId,
          userId: scope.userId,
          deletedAt: null,
        },
      });

      if (!existing) {
        throw new DomainError(
          'Journal entry was not found.',
          'JOURNAL_ENTRY_NOT_FOUND',
          404,
        );
      }

      const now = new Date();
      await tx.journalEntry.update({
        where: { id },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.journalAsset.updateMany({
        where: { entryId: id, deletedAt: null },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.journalShare.updateMany({
        where: { entryId: id, deletedAt: null },
        data: { deletedAt: now, updatedAt: now },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'us.journal.deleted',
          familyId: scope.familyId,
          aggregateId: id,
          payload: {
            entryId: id,
            familyId: scope.familyId,
            userId: scope.userId,
          },
        },
      });
    });
  }

  async createShare(
    scope: CoupleJournalScope,
    command: CreateJournalShareCommand,
  ): Promise<{ id: string; entryId: string; explicitlySharedAt: Date }> {
    return this.prisma.$transaction(async (tx) => {
      const share = await tx.journalShare.create({
        data: {
          entryId: command.entryId,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          ownerUserId: scope.userId,
          recipientUserId: scope.partnerUserId,
          snippetEnc: new Uint8Array(command.snippetEnc),
          explicitlySharedAt: command.explicitlySharedAt,
        },
      });

      await tx.outboxEvent.create({
        data: {
          eventType: 'us.journal.shared',
          familyId: scope.familyId,
          aggregateId: share.id,
          payload: {
            shareId: share.id,
            entryId: command.entryId,
            familyId: scope.familyId,
            coupleSpaceId: scope.coupleSpaceId,
            ownerUserId: scope.userId,
            recipientUserId: scope.partnerUserId,
          },
        },
      });

      return {
        id: share.id,
        entryId: share.entryId,
        explicitlySharedAt: share.explicitlySharedAt,
      };
    });
  }
}
