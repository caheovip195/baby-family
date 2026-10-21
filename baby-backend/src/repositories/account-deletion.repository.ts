import { enqueueTransactionalMail } from './transactional-mail-outbox';
import { Injectable } from '@nestjs/common';
import { cloneDatabaseJson } from '../common/database.types';
import { DomainError } from '../common/errors/domain.error';
import { ACCOUNT_DELETION_POLICY } from '../config/account-deletion-policy';
import { PrismaService } from '../database/prisma.service';
import type { DeletionRequest as DeletionRequestRow } from '../generated/prisma/client';
import { Prisma } from '../generated/prisma/client';
import type {
  IAccountDeletionRepository,
  RequestAccountDeletionCommand,
} from '../interfaces/repositories/account-deletion-repository.interface';
import {
  AccountDeletionPurgeObject,
  AccountDeletionRequest,
  AccountDeletionScope,
  type AccountDeletionStep,
} from '../models/account-deletion.model';
import type { JobLease } from '../models/job-lease.model';

type Tx = Prisma.TransactionClient;
const ANONYMOUS = 'Người dùng đã rời';
function model(row: DeletionRequestRow): AccountDeletionRequest {
  return new AccountDeletionRequest({
    ...row,
    steps: cloneDatabaseJson(row.steps),
  });
}

@Injectable()
export class AccountDeletionRepository implements IAccountDeletionRepository {
  constructor(private readonly prisma: PrismaService) {}

  preview(userId: string): Promise<AccountDeletionScope> {
    return this.prisma.$transaction((tx) => this.scope(tx, userId));
  }

  request(
    command: RequestAccountDeletionCommand,
  ): Promise<AccountDeletionRequest> {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.users WHERE id = ${command.userId}::uuid FOR UPDATE`;
      const user = await tx.user.findFirst({
        where: { id: command.userId, deletedAt: null },
      });
      if (!user || user.tokenVersion !== command.tokenVersion)
        throw new DomainError(
          'Reauthentication expired.',
          'REAUTH_REQUIRED',
          401,
        );
      const existing = await tx.deletionRequest.findFirst({
        where: {
          userId: command.userId,
          status: { in: ['SCHEDULED', 'RUNNING'] },
          deletedAt: null,
        },
      });
      if (existing) return model(existing);
      if (user.status !== 'ACTIVE')
        throw new DomainError(
          'Account is unavailable.',
          'ACCOUNT_UNAVAILABLE',
          409,
        );
      const session = await tx.userSession.findFirst({
        where: {
          id: command.sessionId,
          userId: command.userId,
          deletedAt: null,
          revokedAt: null,
          expiresAt: { gt: command.now },
          absoluteExpiresAt: { gt: command.now },
        },
      });
      if (!session)
        throw new DomainError(
          'Reauthentication expired.',
          'REAUTH_REQUIRED',
          401,
        );
      const scope = await this.scope(tx, command.userId);
      if (scope.familyId) {
        await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${scope.familyId}::uuid FOR UPDATE`;
        const fresh = await this.scope(tx, command.userId);
        const expected = fresh.otherParentCount
          ? 'PARTNER_CONTINUES'
          : 'DELETE_FAMILY';
        if (command.familyChoice !== expected)
          throw new DomainError(
            'Family deletion choice does not match membership.',
            'DELETION_FAMILY_CHOICE_INVALID',
            422,
          );
      } else if (command.familyChoice !== 'NONE')
        throw new DomainError(
          'No parent family exists.',
          'DELETION_FAMILY_CHOICE_INVALID',
          422,
        );
      const row = await tx.deletionRequest.create({
        data: {
          id: command.id,
          userId: command.userId,
          source: 'APP',
          familyId: scope.familyId,
          requestedMembershipId: scope.membershipId,
          familyChoice: command.familyChoice,
          sharedContentChoice: command.sharedContentChoice,
          requestedAt: command.now,
          executeAfter: command.executeAfter,
          steps: { policyVersion: command.policyVersion },
        },
      });
      await tx.exportJob.updateMany({
        where: { requesterId: command.userId, deletedAt: null },
        data: { status: 'EXPIRED', expiresAt: command.now },
      });
      await this.revoke(tx, command.userId, command.now);
      await tx.user.update({
        where: { id: command.userId },
        data: { status: 'DELETION_PENDING', tokenVersion: { increment: 1 } },
      });
      await enqueueTransactionalMail(
        tx,
        'ACCOUNT_DELETION_SCHEDULED',
        command.userId,
        row.id,
      );
      return model(row);
    });
  }

  cancel(
    userId: string,
    tokenVersion: number,
    now: Date,
  ): Promise<AccountDeletionRequest> {
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.users WHERE id = ${userId}::uuid FOR UPDATE`;
      const user = await tx.user.findFirst({
        where: {
          id: userId,
          deletedAt: null,
          status: 'DELETION_PENDING',
          tokenVersion,
        },
      });
      if (!user)
        throw new DomainError(
          'Reauthentication expired.',
          'REAUTH_REQUIRED',
          401,
        );
      await tx.$queryRaw`SELECT id FROM app.deletion_requests WHERE user_id = ${userId}::uuid AND status IN ('SCHEDULED', 'RUNNING') AND deleted_at IS NULL FOR UPDATE`;
      const row = await tx.deletionRequest.findFirst({
        where: {
          userId,
          deletedAt: null,
          status: 'SCHEDULED',
          executeAfter: { gt: now },
        },
      });
      if (!row)
        throw new DomainError(
          'Deletion can no longer be cancelled.',
          'DELETION_CANNOT_CANCEL',
          409,
        );
      await tx.user.update({
        where: { id: userId },
        data: { status: 'ACTIVE', tokenVersion: { increment: 1 } },
      });
      return model(
        await tx.deletionRequest.update({
          where: { id: row.id },
          data: { status: 'CANCELLED', cancelledAt: now },
        }),
      );
    });
  }

  async findDue(now: Date, limit: number): Promise<AccountDeletionRequest[]> {
    const rows = await this.prisma.deletionRequest.findMany({
      where: {
        deletedAt: null,
        status: { in: ['SCHEDULED', 'RUNNING'] },
        executeAfter: { lte: now },
      },
      orderBy: [{ executeAfter: 'asc' }, { id: 'asc' }],
      take: limit,
    });
    return rows.map((row) => model(row));
  }

  executeDatabaseStep(
    id: string,
    step: AccountDeletionStep,
    now: Date,
    lease: JobLease,
  ): Promise<AccountDeletionRequest> {
    return this.mutate(id, now, lease, async (tx, row) => {
      if (row.hasStep(step)) return;
      const userId = row.userId;
      if (step === 'PRIVATE_DATA') {
        // Bounded explicit account-erasure purge includes previously deleted payloads.
        // Parent content is purged only after all dependent rows have been removed.
        if (await this.purgePrivateBatch(tx, userId)) return;
        // Drafts are private account content, independent of the shared-content choice.
        await tx.asset.updateMany({
          where: {
            memoryAssets: {
              some: { memory: { authorUserId: userId, status: 'DRAFT' } },
            },
            NOT: {
              OR: [
                {
                  memoryAssets: {
                    some: {
                      memory: {
                        deletedAt: null,
                        OR: [
                          { authorUserId: { not: userId } },
                          { status: { not: 'DRAFT' } },
                        ],
                      },
                    },
                  },
                },
                {
                  memoryPerspectiveAssets: {
                    some: { memoryPerspective: { deletedAt: null } },
                  },
                },
                { memoryPerspectives: { some: { deletedAt: null } } },
                {
                  journalAssets: {
                    some: { ownerUserId: { not: userId }, deletedAt: null },
                  },
                },
              ],
            },
          },
          data: { status: 'DELETED', deletedAt: now, purgeAfter: now },
        });
        await tx.memory.updateMany({
          where: { authorUserId: userId, status: 'DRAFT' },
          data: {
            status: 'PURGED',
            title: null,
            body: null,
            locationLabel: null,
            quoteContext: null,
            rejectReason: null,
            deletedAt: now,
            trashedAt: now,
            purgeAfter: now,
          },
        });
        await tx.conflictSession.updateMany({
          where: { openedBy: userId },
          data: { nextStep: Prisma.DbNull, topic: null, deletedAt: now },
        });
        await tx.dataKey.updateMany({
          where: { userId, ownerType: 'USER' },
          data: { wrappedDek: null, destroyedAt: now, deletedAt: now },
        });
        await tx.coupleSpace.updateMany({
          where: {
            OR: [{ parentAUserId: userId }, { parentBUserId: userId }],
            deletedAt: null,
          },
          data: {
            status: 'UNLINKED',
            disabledAt: now,
            pairVersion: { increment: 1 },
          },
        });
        await tx.asset.updateMany({
          where: { privateOwnerUserId: userId },
          data: { deletedAt: now, purgeAfter: now, status: 'DELETED' },
        });
      } else if (step === 'CIRCLE') {
        await tx.circleGrant.updateMany({
          where: { circleMember: { userId }, deletedAt: null },
          data: { deletedAt: now },
        });
        await tx.circleMember.updateMany({
          where: { userId, deletedAt: null },
          data: {
            status: 'LEFT',
            endedAt: now,
            displayName: ANONYMOUS,
            deletedAt: now,
          },
        });
      } else if (step === 'SHARED_CONTENT') {
        if (row.sharedContentChoice === 'DELETE') {
          await tx.comment.updateMany({
            where: { authorUserId: userId },
            data: { body: ANONYMOUS, deletedAt: now },
          });
          await tx.memoryPerspective.updateMany({
            where: { authorUserId: userId },
            data: {
              body: null,
              status: 'DELETED',
              deletedAt: now,
              trashedAt: now,
            },
          });
          await tx.asset.updateMany({
            where: {
              privateOwnerUserId: null,
              OR: [
                {
                  memoryAssets: { some: { memory: { authorUserId: userId } } },
                },
                {
                  memoryPerspectiveAssets: {
                    some: { memoryPerspective: { authorUserId: userId } },
                  },
                },
                { memoryPerspectives: { some: { authorUserId: userId } } },
              ],
              NOT: {
                OR: [
                  {
                    memoryAssets: {
                      some: {
                        memory: {
                          authorUserId: { not: userId },
                          deletedAt: null,
                        },
                      },
                    },
                  },
                  {
                    memoryPerspectiveAssets: {
                      some: {
                        memoryPerspective: {
                          authorUserId: { not: userId },
                          deletedAt: null,
                        },
                      },
                    },
                  },
                  {
                    memoryPerspectives: {
                      some: { authorUserId: { not: userId }, deletedAt: null },
                    },
                  },
                ],
              },
            },
            data: { status: 'DELETED', deletedAt: now, purgeAfter: now },
          });
          await tx.memory.updateMany({
            where: { authorUserId: userId },
            data: {
              status: 'PURGED',
              title: null,
              body: null,
              locationLabel: null,
              quoteContext: null,
              rejectReason: null,
              deletedAt: now,
              trashedAt: now,
              purgeAfter: now,
            },
          });
        }
        await tx.memoryPerson.updateMany({
          where: { userId },
          data: { displayName: ANONYMOUS },
        });
        await tx.mission.updateMany({
          where: { ownerUserId: userId, status: 'TODO', deletedAt: null },
          data: {
            status: 'REMOVED',
            removedAt: now,
            removedReason: 'ACCOUNT_DELETED',
          },
        });
        // Immutable Hearts rows remain linked to the anonymized account (§20.1).
      } else if (
        step === 'FAMILY_DATA' &&
        row.familyChoice === 'DELETE_FAMILY' &&
        row.familyId
      ) {
        await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${row.familyId}::uuid FOR UPDATE`;
        const others = await tx.familyParent.count({
          where: {
            familyId: row.familyId,
            userId: { not: userId },
            status: 'ACTIVE',
            deletedAt: null,
          },
        });
        if (others)
          throw new DomainError(
            'Family acquired another parent after the deletion request.',
            'DELETION_FAMILY_CHANGED',
            409,
          );
        // Snapshot a durable erasure marker so lease/crash retries resume rather
        // than repeatedly touching rows processed by earlier attempts.
        const savedSteps =
          row.steps &&
          typeof row.steps === 'object' &&
          !Array.isArray(row.steps)
            ? row.steps
            : {};
        const markerStep = savedSteps.FAMILY_PURGE_STARTED;
        const markerValue =
          markerStep &&
          typeof markerStep === 'object' &&
          !Array.isArray(markerStep)
            ? markerStep.completedAt
            : null;
        const marker =
          typeof markerValue === 'string' ? new Date(markerValue) : now;
        if (!row.hasStep('FAMILY_PURGE_STARTED'))
          await this.checkpoint(tx, row, 'FAMILY_PURGE_STARTED', marker);
        // Hide the aggregate immediately, then resume one bounded child batch per call.
        await tx.family.updateMany({
          where: { id: row.familyId, deletedAt: null },
          data: {
            status: 'DELETED',
            name: ANONYMOUS,
            settings: {},
            coverAssetId: null,
            deletedAt: now,
            accessVersion: { increment: 1 },
          },
        });
        if (await this.purgeFamilyBatch(tx, row.familyId, marker)) return;
      } else if (step === 'MEMBERSHIP') {
        await tx.familyParent.updateMany({
          where: { userId, status: 'ACTIVE', deletedAt: null },
          data: { status: 'LEFT', leftAt: now },
        });
        if (row.familyId && row.familyChoice === 'PARTNER_CONTINUES') {
          await tx.family.updateMany({
            where: { id: row.familyId, deletedAt: null },
            data: { status: 'PARTNER_LEFT', accessVersion: { increment: 1 } },
          });
          await tx.outboxEvent.create({
            data: {
              familyId: row.familyId,
              aggregateId: row.familyId,
              eventType: 'family.entitlement.recompute',
              payload: { familyId: row.familyId, reason: 'ACCOUNT_DELETED' },
            },
          });
        }
      } else if (step === 'IDENTITY') {
        await this.revoke(tx, userId, now);
        // Retain minimum identity record while removing all provider identifiers/PII.
        const identities = await tx.authIdentity.findMany({
          where: { userId },
        });
        for (const identity of identities)
          await tx.authIdentity.update({
            where: { id: identity.id },
            data: {
              providerUid: `deleted:${identity.id}`,
              email: null,
              providerRefreshTokenEnc: null,
              deletedAt: now,
            },
          });
        await tx.userConsent.updateMany({
          where: { userId },
          data: { deletedAt: now },
        });
        await tx.userSetting.updateMany({
          where: { userId },
          data: { deletedAt: now },
        });
        await tx.notificationDeliveryAttempt.deleteMany({
          where: {
            notificationDelivery: { notification: { recipientUserId: userId } },
          },
        });
        await tx.notificationDelivery.deleteMany({
          where: { notification: { recipientUserId: userId } },
        });
        await tx.notification.deleteMany({
          where: { recipientUserId: userId },
        });
        await tx.user.update({
          where: { id: userId },
          data: {
            displayName: ANONYMOUS,
            avatarAssetId: null,
            status: 'DELETED',
            deletedAt: now,
            tokenVersion: { increment: 1 },
          },
        });
      }
      await this.checkpoint(tx, row, step, now);
    });
  }

  completeStep(
    id: string,
    step: string,
    now: Date,
    lease: JobLease,
    details?: string,
  ): Promise<AccountDeletionRequest> {
    return this.mutate(id, now, lease, async (tx, row) => {
      if (!row.hasStep(step))
        await this.checkpoint(tx, row, step, now, details);
    });
  }

  complete(
    id: string,
    now: Date,
    lease: JobLease,
  ): Promise<AccountDeletionRequest> {
    return this.mutate(id, now, lease, async (tx, row) => {
      const required: AccountDeletionStep[] = [
        'PRIVATE_DATA',
        'CIRCLE',
        'SHARED_CONTENT',
        'FAMILY_DATA',
        'MEMBERSHIP',
        'IDENTITY',
      ];
      if (
        !required.every((step) => row.hasStep(step)) ||
        !row.hasStep('OBJECTS') ||
        !row.hasStep('APPLE_REVOKE')
      )
        throw new DomainError(
          'Deletion has unfinished steps.',
          'DELETION_INCOMPLETE',
          409,
        );
      await tx.deletionRequest.update({
        where: { id },
        data: { status: 'COMPLETED', completedAt: now, failureCode: null },
      });
    });
  }

  async fail(id: string, code: string, lease: JobLease): Promise<void> {
    await this.mutate(id, new Date(), lease, async (tx) => {
      await tx.deletionRequest.update({
        where: { id },
        data: { failureCode: code.slice(0, 80) },
      });
    });
  }

  async findPurgeObjects(
    id: string,
    limit: number,
  ): Promise<AccountDeletionPurgeObject[]> {
    const row = await this.prisma.deletionRequest.findFirst({
      where: { id, deletedAt: null, status: 'RUNNING' },
    });
    if (!row) return [];
    const assets = await this.prisma.asset.findMany({
      where: {
        status: 'DELETED',
        purgeAfter: { not: null },
        OR: [
          { privateOwnerUserId: row.userId },
          {
            memoryAssets: {
              some: { memory: { authorUserId: row.userId, status: 'PURGED' } },
            },
          },
          ...(row.familyChoice === 'DELETE_FAMILY' && row.familyId
            ? [{ familyId: row.familyId }]
            : []),
          ...(row.sharedContentChoice === 'DELETE'
            ? [
                {
                  memoryAssets: {
                    some: { memory: { authorUserId: row.userId } },
                  },
                },
                {
                  memoryPerspectiveAssets: {
                    some: { memoryPerspective: { authorUserId: row.userId } },
                  },
                },
                { memoryPerspectives: { some: { authorUserId: row.userId } } },
              ]
            : []),
        ],
      },
      include: { assetVariants: true },
      take: limit,
      orderBy: { id: 'asc' },
    });
    const exports = await this.prisma.exportJob.findMany({
      where: { requesterId: row.userId, storageKey: { not: null } },
      take: limit,
      orderBy: { id: 'asc' },
    });
    return [
      ...exports.map(
        (job) =>
          new AccountDeletionPurgeObject(
            job.id,
            'exports',
            job.storageKey!,
            'export',
          ),
      ),
      ...assets.flatMap((asset) => [
        new AccountDeletionPurgeObject(
          asset.id,
          asset.storageBucket,
          asset.storageKey,
        ),
        ...asset.assetVariants.map(
          (variant) =>
            new AccountDeletionPurgeObject(
              asset.id,
              variant.storageBucket,
              variant.storageKey,
            ),
        ),
      ]),
    ];
  }

  async markObjectsPurged(
    id: string,
    objects: AccountDeletionPurgeObject[],
    now: Date,
    lease: JobLease,
  ): Promise<void> {
    await this.mutate(id, now, lease, async (tx) => {
      const exportIds = objects
        .filter((object) => object.kind === 'export')
        .map((object) => object.assetId);
      await tx.exportJob.updateMany({
        where: { id: { in: exportIds } },
        data: { storageKey: null, status: 'EXPIRED', deletedAt: now },
      });
      const assetIds = [
        ...new Set(
          objects
            .filter((object) => object.kind === 'asset')
            .map((object) => object.assetId),
        ),
      ];
      await tx.asset.updateMany({
        where: { id: { in: assetIds }, status: 'DELETED' },
        data: { purgeAfter: null },
      });
      await tx.assetVariant.updateMany({
        where: { assetId: { in: assetIds } },
        data: { deletedAt: now },
      });
    });
  }

  private async purgePrivateBatch(tx: Tx, userId: string): Promise<boolean> {
    const conditions: [string, Prisma.Sql][] = [
      [
        'us.journal_shares',
        Prisma.sql`owner_user_id = ${userId}::uuid OR recipient_user_id = ${userId}::uuid`,
      ],
      ['us.journal_assets', Prisma.sql`owner_user_id = ${userId}::uuid`],
      ['us.journal_entries', Prisma.sql`user_id = ${userId}::uuid`],
      [
        'us.mood_responses',
        Prisma.sql`user_id = ${userId}::uuid OR checkin_id IN (SELECT id FROM us.mood_checkins WHERE user_id = ${userId}::uuid) OR request_id IN (SELECT id FROM us.requests WHERE sender_user_id = ${userId}::uuid)`,
      ],
      ['us.mood_checkins', Prisma.sql`user_id = ${userId}::uuid`],
      [
        'us.request_children',
        Prisma.sql`request_id IN (SELECT id FROM us.requests WHERE sender_user_id = ${userId}::uuid)`,
      ],
      ['us.requests', Prisma.sql`sender_user_id = ${userId}::uuid`],
      ['us.conflict_entries', Prisma.sql`user_id = ${userId}::uuid`],
      ['us.conflict_confirmations', Prisma.sql`user_id = ${userId}::uuid`],
      ['us.connection_answers', Prisma.sql`user_id = ${userId}::uuid`],
      ['us.appreciations', Prisma.sql`from_user_id = ${userId}::uuid`],
      [
        'us.pregnancy_name_votes',
        Prisma.sql`user_id = ${userId}::uuid OR candidate_id IN (SELECT id FROM us.pregnancy_name_candidates WHERE added_by = ${userId}::uuid)`,
      ],
      ['us.pregnancy_name_candidates', Prisma.sql`added_by = ${userId}::uuid`],
    ];
    for (const [table, where] of conditions) {
      // The table list is static repository code; no caller-controlled identifiers.
      const count = await tx.$executeRaw(
        Prisma.sql`DELETE FROM ${Prisma.raw(table)} WHERE ctid IN (SELECT ctid FROM ${Prisma.raw(table)} WHERE (${where}) LIMIT ${ACCOUNT_DELETION_POLICY.batchSize})`,
      );
      if (count > 0) return true;
    }
    return false;
  }

  private async purgeFamilyBatch(
    tx: Tx,
    familyId: string,
    now: Date,
  ): Promise<boolean> {
    // Each table is explicit so billing, immutable Hearts and deletion/job history
    // retain their independently defined retention rules.
    const privateTables = [
      'journal_shares',
      'journal_assets',
      'journal_entries',
      'mood_responses',
      'mood_checkins',
      'request_children',
      'requests',
      'conflict_entries',
      'conflict_confirmations',
      'conflict_sessions',
      'connection_answers',
      'appreciations',
      'pregnancy_name_votes',
      'pregnancy_name_candidates',
    ];
    for (const table of privateTables) {
      const qualified = Prisma.raw(`us.${table}`);
      const count = await tx.$executeRaw(
        Prisma.sql`DELETE FROM ${qualified} WHERE ctid IN (SELECT ctid FROM ${qualified} WHERE family_id = ${familyId}::uuid LIMIT ${ACCOUNT_DELETION_POLICY.batchSize})`,
      );
      if (count > 0) return true;
    }
    const tables: [string, Prisma.Sql][] = [
      [
        'app.assets',
        Prisma.sql`status = 'DELETED', purge_after = ${now}, deleted_at = ${now}`,
      ],
      [
        'app.memories',
        Prisma.sql`status = 'PURGED', title = NULL, body = NULL, location_label = NULL, quote_context = NULL, reject_reason = NULL, deleted_at = ${now}, trashed_at = ${now}, purge_after = ${now}`,
      ],
      [
        'app.children',
        Prisma.sql`name = NULL, nickname = NULL, avatar_asset_id = NULL, cover_asset_id = NULL, profile = '{}'::jsonb, birth_stats = NULL, deleted_at = ${now}`,
      ],
      [
        'app.missions',
        Prisma.sql`title = ${ANONYMOUS}, note = NULL, deleted_at = ${now}`,
      ],
      [
        'app.circle_members',
        Prisma.sql`status = 'LEFT', display_name = ${ANONYMOUS}, ended_at = ${now}, deleted_at = ${now}`,
      ],
      ['app.comments', Prisma.sql`body = ${ANONYMOUS}, deleted_at = ${now}`],
      [
        'app.memory_perspectives',
        Prisma.sql`body = NULL, status = 'DELETED', deleted_at = ${now}`,
      ],
      [
        'app.pregnancies',
        Prisma.sql`nickname = ${ANONYMOUS}, cover_asset_id = NULL, deleted_at = ${now}`,
      ],
      [
        'app.albums',
        Prisma.sql`name = ${ANONYMOUS}, cover_memory_id = NULL, deleted_at = ${now}`,
      ],
      ['app.album_memories', Prisma.sql`deleted_at = ${now}`],
      ['app.memory_assets', Prisma.sql`deleted_at = ${now}`],
      ['app.memory_perspective_assets', Prisma.sql`deleted_at = ${now}`],
      ['app.memory_children', Prisma.sql`deleted_at = ${now}`],
      [
        'app.memory_people',
        Prisma.sql`display_name = NULL, deleted_at = ${now}`,
      ],
      ['app.memory_letters', Prisma.sql`deleted_at = ${now}`],
      ['app.memory_pins', Prisma.sql`deleted_at = ${now}`],
      ['app.prep_items', Prisma.sql`title = ${ANONYMOUS}, deleted_at = ${now}`],
      [
        'app.care_weekly_snapshots',
        Prisma.sql`metrics = '{}'::jsonb, deleted_at = ${now}`,
      ],
      ['app.monthly_photos', Prisma.sql`deleted_at = ${now}`],
      ['app.milestones', Prisma.sql`custom_title = NULL, deleted_at = ${now}`],
      [
        'app.events',
        Prisma.sql`title = ${ANONYMOUS}, notes = NULL, deleted_at = ${now}`,
      ],
      ['app.event_children', Prisma.sql`deleted_at = ${now}`],
      ['app.event_participants', Prisma.sql`deleted_at = ${now}`],
      ['app.event_reminder_rules', Prisma.sql`deleted_at = ${now}`],
      ['app.event_reminders', Prisma.sql`deleted_at = ${now}`],
      ['app.reactions', Prisma.sql`deleted_at = ${now}`],
      ['app.favorites', Prisma.sql`deleted_at = ${now}`],
      [
        'app.recaps',
        Prisma.sql`content = '{}'::jsonb, content_parents_only = NULL, deleted_at = ${now}`,
      ],
      ['app.circle_grants', Prisma.sql`deleted_at = ${now}`],
      [
        'app.family_invites',
        Prisma.sql`payload = '{}'::jsonb, deleted_at = ${now}`,
      ],
      ['app.mission_children', Prisma.sql`deleted_at = ${now}`],
      ['app.mission_completions', Prisma.sql`deleted_at = ${now}`],
      [
        'app.mission_series',
        Prisma.sql`title = ${ANONYMOUS}, note = NULL, deleted_at = ${now}`,
      ],
      ['app.mission_series_children', Prisma.sql`deleted_at = ${now}`],
      ['app.mission_preferences', Prisma.sql`deleted_at = ${now}`],
      ['app.story_views', Prisma.sql`deleted_at = ${now}`],
      [
        'app.couple_spaces',
        Prisma.sql`status = 'UNLINKED', disabled_at = ${now}, deleted_at = ${now}`,
      ],
    ];
    for (const [table, data] of tables) {
      const count = await tx.$executeRaw(
        Prisma.sql`UPDATE ${Prisma.raw(table)} SET ${data} WHERE ctid IN (SELECT ctid FROM ${Prisma.raw(table)} WHERE family_id = ${familyId}::uuid AND (deleted_at IS DISTINCT FROM ${now}) LIMIT ${ACCOUNT_DELETION_POLICY.batchSize})`,
      );
      if (count > 0) return true;
    }
    return false;
  }

  private async scope(tx: Tx, userId: string): Promise<AccountDeletionScope> {
    const user = await tx.user.findFirst({
      where: { id: userId, deletedAt: null },
    });
    if (!user)
      throw new DomainError('Account was not found.', 'ACCOUNT_NOT_FOUND', 404);
    const membership = await tx.familyParent.findFirst({
      where: {
        userId,
        status: 'ACTIVE',
        deletedAt: null,
        family: { deletedAt: null },
      },
    });
    const otherParentCount = membership
      ? await tx.familyParent.count({
          where: {
            familyId: membership.familyId,
            status: 'ACTIVE',
            deletedAt: null,
            userId: { not: userId },
          },
        })
      : 0;
    const isPayer =
      (await tx.subscription.count({
        where: { purchaserUserId: userId, deletedAt: null, autoRenew: true },
      })) > 0;
    return new AccountDeletionScope(
      userId,
      user.status,
      membership?.familyId ?? null,
      membership?.id ?? null,
      otherParentCount,
      isPayer,
    );
  }

  private async revoke(tx: Tx, userId: string, now: Date): Promise<void> {
    await tx.userSession.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: now, revokeReason: 'ACCOUNT_DELETION' },
    });
    await tx.userDevice.updateMany({
      where: { userId },
      data: { pushToken: null, pushEnabled: false },
    });
  }

  private async checkpoint(
    tx: Tx,
    row: AccountDeletionRequest,
    step: string,
    now: Date,
    details?: string,
  ): Promise<void> {
    const current = await tx.deletionRequest.findUniqueOrThrow({
      where: { id: row.id },
      select: { steps: true },
    });
    const cloned = cloneDatabaseJson(current.steps);
    const prior =
      typeof cloned === 'object' && cloned !== null && !Array.isArray(cloned)
        ? cloned
        : {};
    await tx.deletionRequest.update({
      where: { id: row.id },
      data: {
        steps: {
          ...prior,
          [step]: {
            completedAt: now.toISOString(),
            ...(details ? { details } : {}),
          },
        },
        failureCode: null,
      },
    });
  }

  private mutate(
    id: string,
    now: Date,
    lease: JobLease,
    action: (tx: Tx, row: AccountDeletionRequest) => Promise<void>,
  ): Promise<AccountDeletionRequest> {
    return this.prisma.$transaction(
      async (tx) => {
        const owned = await tx.$queryRaw<
          { id: string }[]
        >`SELECT id FROM ops.job_runs WHERE id = ${lease.runId}::uuid AND status = 'RUNNING' AND fencing_token = ${lease.fencingToken} AND lease_owner = ${lease.workerId} AND lease_expires_at > clock_timestamp() AND deleted_at IS NULL FOR SHARE`;
        if (!owned.length)
          throw new DomainError('Job lease expired.', 'JOB_LEASE_LOST', 409);
        await tx.$queryRaw`SELECT id FROM app.deletion_requests WHERE id = ${id}::uuid FOR UPDATE`;
        const found = await tx.deletionRequest.findFirst({
          where: { id, deletedAt: null },
        });
        if (
          !found ||
          !['SCHEDULED', 'RUNNING', 'COMPLETED'].includes(found.status)
        )
          throw new DomainError(
            'Deletion request is unavailable.',
            'DELETION_NOT_FOUND',
            404,
          );
        if (found.status === 'COMPLETED') return model(found);
        if (found.familyId) {
          await tx.$queryRaw`SELECT id FROM app.families WHERE id = ${found.familyId}::uuid FOR UPDATE`;
          if (found.familyChoice === 'DELETE_FAMILY') {
            const others = await tx.familyParent.count({
              where: {
                familyId: found.familyId,
                userId: { not: found.userId },
                status: 'ACTIVE',
                deletedAt: null,
              },
            });
            if (others) {
              await tx.deletionRequest.update({
                where: { id },
                data: { familyChoice: 'PARTNER_CONTINUES' },
              });
            }
          }
        }
        if (found.executeAfter > now)
          throw new DomainError(
            'Grace period is active.',
            'DELETION_NOT_DUE',
            409,
          );
        const row = model(
          await tx.deletionRequest.update({
            where: { id },
            data: { status: 'RUNNING' },
          }),
        );
        await action(tx, row);
        return model(
          await tx.deletionRequest.findUniqueOrThrow({ where: { id } }),
        );
      },
      { timeout: 20000 },
    );
  }
}
