import { Injectable } from '@nestjs/common';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { PREGNANCY_NAMING_POLICY } from '../config/pregnancy-naming-policy';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type {
  IPregnancyNamingRepository,
  PregnancyNamingMutation,
} from '../interfaces/repositories/pregnancy-naming-repository.interface';
import type { CreateMemoryCommand } from '../interfaces/repositories/memory-content-repository.interface';
import { Memory } from '../models/memory.model';
import { Milestone } from '../models/milestone.model';
import { Pregnancy } from '../models/pregnancy.model';
import { PregnancyNameCandidate } from '../models/pregnancy-name-candidate.model';
import {
  PregnancyNamingEntry,
  PregnancyNamingState,
} from '../models/pregnancy-naming-state.model';
import { MemoryContentRepository } from './memory-content.repository';

type Transaction = Prisma.TransactionClient;

/** Couple-private name persistence; the service decides each business mutation
 * against a current snapshot held under the lifecycle row locks.
 */
@Injectable()
export class PregnancyNamingRepository
  extends MemoryContentRepository
  implements IPregnancyNamingRepository
{
  constructor(private readonly namingPrisma: PrismaService) {
    super(namingPrisma);
  }

  async findPregnancy(id: string): Promise<Pregnancy | null> {
    const row = await this.namingPrisma.pregnancy.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Pregnancy(row) : null;
  }

  async findPregnancyId(nameId: string): Promise<string | null> {
    const row = await this.namingPrisma.pregnancyNameCandidate.findFirst({
      where: { id: nameId, deletedAt: null },
      select: { pregnancyId: true },
    });
    return row?.pregnancyId ?? null;
  }

  read(
    pregnancyId: string,
    actorUserId: string,
  ): Promise<PregnancyNamingState> {
    return this.namingPrisma.$transaction(
      (tx) => this.loadState(tx, pregnancyId, actorUserId),
      {
        isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead,
        timeout: 10000,
      },
    );
  }

  async mutate(
    pregnancyId: string,
    actorUserId: string,
    decide: (state: PregnancyNamingState) => PregnancyNamingMutation,
  ): Promise<PregnancyNamingState> {
    try {
      return await this.namingPrisma.$transaction(
        async (tx) => {
          const pregnancy = await tx.pregnancy.findFirst({
            where: { id: pregnancyId, deletedAt: null },
            select: { familyId: true },
          });
          if (!pregnancy) throw this.notFound();

          // Same family → pregnancy → couple order as family/pregnancy lifecycle
          // operations; a partner transition cannot write into an old pair.
          // NO KEY UPDATE also permits FK KEY SHARE from ordinary memory/outbox
          // inserts that already hold usage, avoiding a usage ↔ family deadlock.
          await tx.$queryRaw`
            SELECT id FROM app.families
            WHERE id = ${pregnancy.familyId}::uuid FOR NO KEY UPDATE
          `;
          await tx.$queryRaw`
            SELECT id FROM app.pregnancies
            WHERE id = ${pregnancyId}::uuid
              AND family_id = ${pregnancy.familyId}::uuid FOR NO KEY UPDATE
          `;
          await tx.$queryRaw`
            SELECT id FROM app.couple_spaces
            WHERE family_id = ${pregnancy.familyId}::uuid
              AND status = 'ACTIVE' AND deleted_at IS NULL
            ORDER BY id FOR NO KEY UPDATE
          `;

          let state = await this.loadState(tx, pregnancyId, actorUserId);
          if (state.milestone) {
            // Trash/purge takes this memory row too. Inspect its fresh status
            // only after locking so a naming write cannot overwrite trash.
            await tx.$queryRaw`
              SELECT id FROM app.memories
              WHERE id = ${state.milestone.memory.id}::uuid
                AND family_id = ${pregnancy.familyId}::uuid FOR UPDATE
            `;
            state = await this.loadState(tx, pregnancyId, actorUserId);
          }
          const mutation = decide(state);
          await this.applyMutation(tx, state, actorUserId, mutation);
          return this.loadState(tx, pregnancyId, actorUserId);
        },
        {
          isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
          timeout: 10000,
        },
      );
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        const metadata = JSON.stringify(error.meta ?? {});
        if (metadata.includes('name_key'))
          throw new DomainError(
            'This pregnancy already has that name.',
            'NAME_DUPLICATE',
            409,
          );
        if (
          metadata.includes('uq_preg_milestone_once') ||
          (metadata.includes('pregnancy_id') &&
            metadata.includes('template_code'))
        )
          throw new DomainError(
            'The pregnancy milestone changed; retry the request.',
            'NAME_MILESTONE_CONFLICT',
            409,
          );
      }
      throw error;
    }
  }

  private async loadState(
    tx: Transaction,
    pregnancyId: string,
    actorUserId: string,
  ): Promise<PregnancyNamingState> {
    const pregnancy = await tx.pregnancy.findFirst({
      where: { id: pregnancyId, deletedAt: null },
    });
    if (!pregnancy) throw this.notFound();
    const family = await tx.family.findFirst({
      where: { id: pregnancy.familyId, status: 'ACTIVE', deletedAt: null },
      select: { timezone: true },
    });
    const pair = await tx.coupleSpace.findFirst({
      where: {
        familyId: pregnancy.familyId,
        status: 'ACTIVE',
        disabledAt: null,
        deletedAt: null,
        OR: [{ parentAUserId: actorUserId }, { parentBUserId: actorUserId }],
      },
    });
    if (!family || !pair) throw this.notFound();
    const memberships = await tx.familyParent.count({
      where: {
        familyId: pregnancy.familyId,
        status: 'ACTIVE',
        leftAt: null,
        deletedAt: null,
        OR: [
          { id: pair.parentAMembershipId, userId: pair.parentAUserId },
          { id: pair.parentBMembershipId, userId: pair.parentBUserId },
        ],
        user: { status: 'ACTIVE', deletedAt: null },
      },
    });
    if (memberships !== 2) throw this.notFound();
    const partnerUserId =
      pair.parentAUserId === actorUserId
        ? pair.parentBUserId
        : pair.parentAUserId;
    const candidates = await tx.pregnancyNameCandidate.findMany({
      where: {
        pregnancyId,
        familyId: pregnancy.familyId,
        coupleSpaceId: pair.id,
        deletedAt: null,
      },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
    });
    const votes = await tx.pregnancyNameVote.findMany({
      where: {
        familyId: pregnancy.familyId,
        coupleSpaceId: pair.id,
        candidateId: { in: candidates.map((candidate) => candidate.id) },
        userId: { in: [actorUserId, partnerUserId] },
        deletedAt: null,
      },
      select: { candidateId: true, userId: true },
    });
    const milestone = await tx.milestone.findFirst({
      where: {
        familyId: pregnancy.familyId,
        pregnancyId,
        templateCode: PREGNANCY_NAMING_POLICY.milestoneTemplateCode,
        deletedAt: null,
      },
      include: { memory: true },
    });
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId: pregnancy.familyId, deletedAt: null },
      include: { planVersion: true },
    });
    return new PregnancyNamingState(
      new Pregnancy(pregnancy),
      pair.id,
      partnerUserId,
      family.timezone,
      candidates.map(
        (candidate) =>
          new PregnancyNamingEntry(
            new PregnancyNameCandidate(candidate),
            votes
              .filter((vote) => vote.candidateId === candidate.id)
              .map((vote) => vote.userId),
          ),
      ),
      milestone
        ? {
            memory: new Memory(milestone.memory),
            milestone: new Milestone(milestone),
          }
        : null,
      entitlement?.planVersion?.deletedAt === null
        ? entitlement.planVersion.quotas
        : null,
    );
  }

  private async applyMutation(
    tx: Transaction,
    state: PregnancyNamingState,
    actorUserId: string,
    mutation: PregnancyNamingMutation,
  ): Promise<void> {
    const familyId = state.pregnancy.familyId;
    const now = new Date();
    if (mutation.type === 'noop') return;
    if (mutation.type === 'create') {
      await tx.pregnancyNameCandidate.create({
        data: {
          id: mutation.id,
          familyId,
          coupleSpaceId: state.coupleSpaceId,
          pregnancyId: state.pregnancy.id,
          nameEnc: new Uint8Array(mutation.nameEnc),
          meaningEnc: mutation.meaningEnc
            ? new Uint8Array(mutation.meaningEnc)
            : null,
          nameKey: mutation.nameKey,
          addedBy: actorUserId,
        },
      });
      return;
    }
    const scope = {
      id: mutation.id,
      familyId,
      pregnancyId: state.pregnancy.id,
      coupleSpaceId: state.coupleSpaceId,
      deletedAt: null,
    };
    if (!state.entries.some((entry) => entry.candidate.id === mutation.id))
      throw this.notFound();
    if (mutation.type === 'like') {
      if (mutation.liked)
        await tx.pregnancyNameVote.upsert({
          where: {
            candidateId_userId: {
              candidateId: mutation.id,
              userId: actorUserId,
            },
          },
          create: {
            candidateId: mutation.id,
            userId: actorUserId,
            familyId,
            coupleSpaceId: state.coupleSpaceId,
          },
          update: { deletedAt: null },
        });
      else
        await tx.pregnancyNameVote.updateMany({
          where: {
            candidateId: mutation.id,
            userId: actorUserId,
            familyId,
            coupleSpaceId: state.coupleSpaceId,
            deletedAt: null,
          },
          data: { deletedAt: now },
        });
      return;
    }
    if (mutation.type === 'remove') {
      await tx.pregnancyNameCandidate.updateMany({
        where: scope,
        data: { deletedAt: now, chosenAt: null, chosenBy: null },
      });
      await tx.pregnancyNameVote.updateMany({
        where: {
          candidateId: mutation.id,
          familyId,
          coupleSpaceId: state.coupleSpaceId,
          deletedAt: null,
        },
        data: { deletedAt: now },
      });
    } else {
      await tx.pregnancyNameCandidate.updateMany({
        where: scope,
        data: {
          chosenAt: mutation.chosen ? now : null,
          chosenBy: mutation.chosen ? actorUserId : null,
        },
      });
    }
    if (mutation.memory)
      await this.writeMilestone(tx, state, actorUserId, mutation.memory);
  }

  private async writeMilestone(
    tx: Transaction,
    state: PregnancyNamingState,
    actorUserId: string,
    command: CreateMemoryCommand,
  ): Promise<void> {
    if (!state.milestone) {
      await this.createInTransaction(tx, command);
      return;
    }
    const memory = state.milestone.memory;
    if (
      memory.title === command.title &&
      memory.body === command.body &&
      memory.visibility === 'PARENTS'
    )
      return;
    await tx.memory.update({
      where: { id: memory.id, familyId: state.pregnancy.familyId },
      data: {
        title: command.title,
        body: command.body,
        visibility: 'PARENTS',
        version: { increment: 1 },
      },
    });
    await tx.outboxEvent.create({
      data: {
        eventType: 'memory.updated',
        aggregateId: memory.id,
        familyId: state.pregnancy.familyId,
        payload: {
          memoryId: memory.id,
          familyId: state.pregnancy.familyId,
          updatedBy: actorUserId,
          fields: ['title', 'body', 'visibility'],
          visibility: 'PARENTS',
        },
      },
    });
  }

  private notFound(): NotFoundError {
    return new NotFoundError('Pregnancy naming was not found.');
  }
}
