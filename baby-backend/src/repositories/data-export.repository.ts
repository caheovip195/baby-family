import { enqueueTransactionalMail } from './transactional-mail-outbox';
import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { JOBS } from '../config/jobs';
import { ACCOUNT_DELETION_POLICY } from '../config/account-deletion-policy';
import { PrismaService } from '../database/prisma.service';
import type { Prisma, ExportJob } from '../generated/prisma/client';
import type {
  CreateDataExportInput,
  IDataExportRepository,
} from '../interfaces/repositories/data-export-repository.interface';
import { DataExport, DataExportSnapshot } from '../models/data-export.model';
import { Asset } from '../models/asset.model';
import { JournalEntry } from '../models/journal-entry.model';
import { MoodCheckin } from '../models/mood-checkin.model';
import { Appreciation } from '../models/appreciation.model';
import { Request } from '../models/request.model';
import type { JobLease } from '../models/job-lease.model';
import { cloneDatabaseJson } from '../common/database.types';

function model(row: ExportJob): DataExport {
  return new DataExport({
    ...row,
    accessSnapshot: cloneDatabaseJson(row.accessSnapshot),
  });
}
@Injectable()
export class DataExportRepository implements IDataExportRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(input: CreateDataExportInput): Promise<DataExport> {
    return this.prisma.$transaction(async (tx) => {
      const users = await tx.$queryRaw<
        { id: string }[]
      >`SELECT id FROM app.users WHERE id = ${input.userId}::uuid AND deleted_at IS NULL AND status = 'ACTIVE' FOR UPDATE`;
      if (!users.length)
        throw new DomainError('Account unavailable.', 'ACCOUNT_NOT_FOUND', 404);
      if (
        await tx.exportJob.count({
          where: {
            requesterId: input.userId,
            deletedAt: null,
            status: { in: ['QUEUED', 'PROCESSING'] },
          },
        })
      ) {
        throw new DomainError(
          'An export is already active.',
          'EXPORT_ALREADY_ACTIVE',
          409,
        );
      }
      if (
        (await tx.exportJob.count({
          where: { requesterId: input.userId, createdAt: { gte: input.since } },
        })) >= input.maxRequests
      ) {
        throw new DomainError(
          'Export request limit reached.',
          'EXPORT_RATE_LIMITED',
          429,
        );
      }
      if (input.scope === 'FAMILY')
        await this.requireFamily(tx, input.userId, input.familyId);
      return model(
        await tx.exportJob.create({
          data: {
            requesterId: input.userId,
            familyId: input.familyId,
            scope: input.scope,
            expiresAt: new Date(
              Date.now() + ACCOUNT_DELETION_POLICY.export.retentionMs,
            ),
            accessSnapshot: {
              policyVersion: input.policyVersion,
              format: 'JSON_MANIFEST_V1',
            },
          },
        }),
      );
    });
  }
  async find(userId: string, id: string): Promise<DataExport | null> {
    const row = await this.prisma.exportJob.findFirst({
      where: { id, requesterId: userId, deletedAt: null },
    });
    if (!row) return null;
    if (row.scope === 'FAMILY')
      await this.requireFamily(this.prisma, userId, row.familyId);
    return model(row);
  }
  async pending(limit: number): Promise<DataExport[]> {
    return (
      await this.prisma.exportJob.findMany({
        where: { deletedAt: null, status: { in: ['QUEUED', 'PROCESSING'] } },
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
        take: limit,
      })
    ).map(model);
  }
  async expired(now: Date, limit: number): Promise<DataExport[]> {
    return (
      await this.prisma.exportJob.findMany({
        where: {
          deletedAt: null,
          status: { in: ['COMPLETED', 'EXPIRED', 'FAILED'] },
          expiresAt: { lte: now },
        },
        orderBy: { expiresAt: 'asc' },
        take: limit,
      })
    ).map(model);
  }
  async begin(id: string, lease: JobLease): Promise<DataExport | null> {
    return this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      const row = await tx.exportJob.findFirst({
        where: {
          id,
          deletedAt: null,
          status: { in: ['QUEUED', 'PROCESSING'] },
        },
      });
      if (!row) return null;
      await this.lockUser(tx, row.requesterId);
      if (row.scope === 'FAMILY')
        await this.requireFamily(tx, row.requesterId, row.familyId);
      return model(
        await tx.exportJob.update({
          where: { id },
          data: {
            status: 'PROCESSING',
            accessRecheckedAt: new Date(),
            errorCode: null,
          },
        }),
      );
    });
  }
  async snapshot(job: DataExport): Promise<DataExportSnapshot> {
    // One repeatable-read snapshot avoids exporting half of a concurrent update.
    return this.prisma.$transaction(
      async (tx) => {
        const take = ACCOUNT_DELETION_POLICY.export.maxRows + 1;
        const personal = job.scope === 'PERSONAL';
        if (!personal)
          await this.requireFamily(tx, job.requesterId, job.familyId);
        const memories = await tx.memory.findMany({
          where: {
            deletedAt: null,
            trashedAt: null,
            ...(personal
              ? { authorUserId: job.requesterId }
              : {
                  familyId: job.familyId!,
                  visibility: { in: ['PARENTS', 'FAMILY'] },
                  status: 'PUBLISHED',
                  OR: [{ unlockAt: null }, { unlockAt: { lte: new Date() } }],
                }),
          },
          select: {
            id: true,
            familyId: true,
            authorUserId: true,
            title: true,
            body: true,
            occurredAt: true,
            visibility: true,
            feeling: true,
            quoteContext: true,
            memoryChildren: {
              where: { deletedAt: null },
              select: { childId: true },
            },
            memoryPeople: {
              where: { deletedAt: null },
              select: { userId: true, displayName: true },
            },
            memoryPerspectives: {
              where: {
                deletedAt: null,
                trashedAt: null,
                ...(personal ? { authorUserId: job.requesterId } : {}),
              },
              select: { id: true, authorUserId: true, body: true },
            },
          },
          take,
        });
        const ids = memories.map((m) => m.id);
        const monthly = !personal
          ? await tx.monthlyPhoto.findMany({
              where: {
                familyId: job.familyId!,
                deletedAt: null,
                memoryId: { in: ids },
              },
              select: {
                childId: true,
                monthIndex: true,
                pregWeek: true,
                memoryId: true,
                assetId: true,
              },
              take,
            })
          : [];
        const assets = await tx.asset.findMany({
          where: {
            deletedAt: null,
            status: 'READY',
            ...(personal
              ? {
                  uploaderUserId: job.requesterId,
                  OR: [
                    { privateOwnerUserId: null },
                    { privateOwnerUserId: job.requesterId },
                  ],
                }
              : {
                  familyId: job.familyId!,
                  purpose: 'MEMORY',
                  privateOwnerUserId: null,
                  OR: [
                    {
                      memoryAssets: {
                        some: { deletedAt: null, memoryId: { in: ids } },
                      },
                    },
                    {
                      memoryPerspectiveAssets: {
                        some: {
                          deletedAt: null,
                          memoryPerspective: {
                            deletedAt: null,
                            trashedAt: null,
                            memoryId: { in: ids },
                          },
                        },
                      },
                    },
                    {
                      memoryPerspectives: {
                        some: {
                          deletedAt: null,
                          trashedAt: null,
                          memoryId: { in: ids },
                        },
                      },
                    },
                    { id: { in: monthly.map((row) => row.assetId) } },
                  ],
                }),
          },
          take,
        });
        const journal = personal
          ? await tx.journalEntry.findMany({
              where: { userId: job.requesterId, deletedAt: null },
              take,
            })
          : [];
        const moods = personal
          ? await tx.moodCheckin.findMany({
              where: { userId: job.requesterId, deletedAt: null },
              take,
            })
          : [];
        const appreciations = personal
          ? await tx.appreciation.findMany({
              where: {
                deletedAt: null,
                OR: [
                  { fromUserId: job.requesterId, deletedByFromAt: null },
                  { toUserId: job.requesterId, deletedByToAt: null },
                ],
              },
              take,
            })
          : [];
        const requests = personal
          ? await tx.request.findMany({
              where: {
                deletedAt: null,
                OR: [
                  { senderUserId: job.requesterId },
                  { receiverUserId: job.requesterId },
                ],
              },
              take,
            })
          : [];
        const hearts = personal
          ? await tx.heartLedger.findMany({
              where: { deletedAt: null, userId: job.requesterId },
              select: {
                id: true,
                familyId: true,
                amount: true,
                reason: true,
                sourceType: true,
                sourceId: true,
                createdAt: true,
              },
              take,
            })
          : [];
        const perspectives = personal
          ? await tx.memoryPerspective.findMany({
              where: {
                authorUserId: job.requesterId,
                deletedAt: null,
                trashedAt: null,
              },
              select: {
                id: true,
                familyId: true,
                memoryId: true,
                body: true,
                audioAssetId: true,
                createdAt: true,
              },
              take,
            })
          : [];
        const milestones = !personal
          ? await tx.milestone.findMany({
              where: {
                familyId: job.familyId!,
                deletedAt: null,
                memoryId: { in: ids },
              },
              select: {
                id: true,
                childId: true,
                memoryId: true,
                occurredOn: true,
              },
              take,
            })
          : [];
        const children = !personal
          ? await tx.child.findMany({
              where: { deletedAt: null, familyId: job.familyId! },
              select: { id: true, nickname: true, birthDate: true },
              take,
            })
          : [];
        if (
          [
            memories,
            assets,
            journal,
            moods,
            appreciations,
            requests,
            hearts,
            children,
            perspectives,
            monthly,
            milestones,
          ].some((rows) => rows.length > ACCOUNT_DELETION_POLICY.export.maxRows)
        )
          throw new DomainError(
            'Export exceeds MVP size limit.',
            'EXPORT_TOO_LARGE',
            422,
          );
        return new DataExportSnapshot(
          {
            memories,
            ...(personal ? { hearts } : {}),
            children,
            perspectives,
            monthly,
            milestones,
          },
          journal.map((r) => new JournalEntry(r)),
          moods.map((r) => new MoodCheckin(r)),
          appreciations.map((r) => new Appreciation(r)),
          requests.map((r) => new Request(r)),
          assets.map((r) => new Asset(r)),
        );
      },
      { isolationLevel: 'RepeatableRead', timeout: 30000 },
    );
  }
  async complete(
    job: DataExport,
    key: string,
    bytes: number,
    expiresAt: Date,
    lease: JobLease,
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      await this.lockUser(tx, job.requesterId);
      if (job.scope === 'FAMILY')
        await this.requireFamily(tx, job.requesterId, job.familyId);
      const result = await tx.exportJob.updateMany({
        where: { id: job.id, status: 'PROCESSING', deletedAt: null },
        data: {
          status: 'COMPLETED',
          storageKey: key,
          sizeBytes: BigInt(bytes),
          expiresAt,
          completedAt: new Date(),
          accessRecheckedAt: new Date(),
        },
      });
      if (result.count !== 1)
        throw new DomainError(
          'Export access revoked.',
          'EXPORT_ACCESS_REVOKED',
          403,
        );
      await enqueueTransactionalMail(
        tx,
        'EXPORT_READY',
        job.requesterId,
        job.id,
      );
    });
  }
  async fail(id: string, code: string, lease: JobLease): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      await tx.exportJob.updateMany({
        where: {
          id,
          deletedAt: null,
          status: { in: ['QUEUED', 'PROCESSING'] },
        },
        data: { status: 'FAILED', errorCode: code },
      });
    });
  }
  async reconcileFailed(lease: JobLease): Promise<number> {
    return this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      return tx.$executeRaw`UPDATE app.export_jobs AS export SET status = 'FAILED', error_code = 'EXPORT_BUILD_FAILED' WHERE deleted_at IS NULL AND status IN ('QUEUED', 'PROCESSING') AND EXISTS (SELECT 1 FROM ops.job_runs AS run WHERE run.job_name = ${JOBS.dataExport.name} AND run.scope_key = export.id::text AND run.status = 'FAILED' AND run.deleted_at IS NULL)`;
    });
  }
  async retire(id: string, lease: JobLease): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.assertLease(tx, lease);
      await tx.exportJob.updateMany({
        where: { id, deletedAt: null, expiresAt: { lte: new Date() } },
        data: { status: 'EXPIRED', deletedAt: new Date(), storageKey: null },
      });
    });
  }
  private async requireFamily(
    tx: Prisma.TransactionClient,
    userId: string,
    familyId: string | null,
  ): Promise<void> {
    if (
      !familyId ||
      !(await tx.familyParent.findFirst({
        where: {
          familyId,
          userId,
          status: 'ACTIVE',
          deletedAt: null,
          leftAt: null,
          user: { deletedAt: null, status: 'ACTIVE' },
          family: {
            deletedAt: null,
            status: { notIn: ['DELETED'] },
            familyLicense: {
              deletedAt: null,
            },
          },
        },
      }))
    )
      throw new DomainError(
        'Export access revoked.',
        'EXPORT_ACCESS_REVOKED',
        403,
      );
  }
  private async lockUser(
    tx: Prisma.TransactionClient,
    userId: string,
  ): Promise<void> {
    const users = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM app.users WHERE id = ${userId}::uuid AND deleted_at IS NULL AND status = 'ACTIVE' FOR UPDATE`;
    if (!users.length)
      throw new DomainError('Account unavailable.', 'ACCOUNT_NOT_FOUND', 404);
  }
  private async assertLease(
    tx: Prisma.TransactionClient,
    lease: JobLease,
  ): Promise<void> {
    const owned = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND deleted_at IS NULL AND lease_expires_at > clock_timestamp() FOR SHARE`;
    if (!owned.length) throw new Error('Export job lease lost.');
  }
}
