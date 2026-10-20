import { createHash } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type { Child as ChildRow } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  BirthChildInput,
  IBirthConversionWorkflowRepository,
} from '../interfaces/repositories/birth-conversion-workflow-repository.interface';
import { Child } from '../models/child.model';
import { Pregnancy } from '../models/pregnancy.model';
const mapChild = (row: ChildRow): Child =>
  new Child({
    ...row,
    profile: cloneDatabaseJson(row.profile),
    birthStats: cloneDatabaseJson(row.birthStats),
  });
function ageMonth(occurred: Date, birth: Date): number {
  const value =
    (occurred.getUTCFullYear() - birth.getUTCFullYear()) * 12 +
    occurred.getUTCMonth() -
    birth.getUTCMonth() -
    (occurred.getUTCDate() < birth.getUTCDate() ? 1 : 0);
  if (value < -32768 || value > 32767)
    throw new ValidationError('Memory age exceeds the supported range.');
  return value;
}
@Injectable()
export class BirthConversionWorkflowRepository implements IBirthConversionWorkflowRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findPregnancy(id: string): Promise<Pregnancy | null> {
    const row = await this.prisma.pregnancy.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Pregnancy(row) : null;
  }
  async convert(
    pregnancy: Pregnancy,
    key: string,
    userId: string,
    children: BirthChildInput[],
  ): Promise<Child[]> {
    try {
      return await this.prisma.$transaction(async (tx) => {
        await tx.$queryRaw(
          Prisma.sql`SELECT id FROM app.families WHERE id = ${pregnancy.familyId}::uuid FOR UPDATE`,
        );
        await tx.$queryRaw(
          Prisma.sql`SELECT id FROM app.pregnancies WHERE id = ${pregnancy.id}::uuid FOR UPDATE`,
        );
        const current = await tx.pregnancy.findFirst({
          where: {
            id: pregnancy.id,
            familyId: pregnancy.familyId,
            deletedAt: null,
          },
        });
        if (!current) throw new NotFoundError('Pregnancy was not found.');
        const conversion = await tx.birthConversion.findUnique({
          where: { pregnancyId: pregnancy.id },
        });
        if (conversion) {
          if (conversion.idempotencyKey !== key)
            throw new DomainError(
              'Pregnancy has already been converted.',
              'PREGNANCY_ALREADY_CONVERTED',
              409,
            );
          const receipt = await tx.idempotencyRecord.findUnique({
            where: {
              scopeKey_operation_idempotencyKey: {
                scopeKey: pregnancy.id,
                operation: 'pregnancy.birth',
                idempotencyKey: key,
              },
            },
          });
          if (receipt?.responseReference) {
            const snapshots =
              receipt.responseReference as unknown as ChildRow[];
            return snapshots.map((row) =>
              mapChild({
                ...row,
                birthDate: new Date(row.birthDate),
                birthTime: row.birthTime ? new Date(row.birthTime) : null,
                createdAt: new Date(row.createdAt),
                updatedAt: new Date(row.updatedAt),
                archivedAt: row.archivedAt ? new Date(row.archivedAt) : null,
                deletedAt: row.deletedAt ? new Date(row.deletedAt) : null,
                deletionRequestedAt: row.deletionRequestedAt
                  ? new Date(row.deletionRequestedAt)
                  : null,
                purgeAfter: row.purgeAfter ? new Date(row.purgeAfter) : null,
              }),
            );
          }
          const links = await tx.birthConversionChild.findMany({
            where: {
              pregnancyId: pregnancy.id,
              familyId: pregnancy.familyId,
              deletedAt: null,
            },
          });
          return (
            await tx.child.findMany({
              where: {
                familyId: pregnancy.familyId,
                id: { in: links.map((link) => link.childId) },
              },
              orderBy: { birthOrder: 'asc' },
            })
          ).map(mapChild);
        }
        if (
          await tx.birthConversion.findUnique({
            where: { idempotencyKey: key },
          })
        )
          throw new DomainError(
            'Idempotency-Key belongs to another conversion.',
            'IDEMPOTENCY_KEY_CONFLICT',
            409,
          );
        if (current.status !== 'ACTIVE')
          throw new DomainError(
            'Only an active pregnancy can be converted.',
            'PREGNANCY_NOT_ACTIVE',
            409,
          );
        if (children.length < 1 || children.length > current.expectedCount)
          throw new ValidationError('Provide 1..expectedCount children.');
        const siblings = await tx.child.findMany({
          where: { familyId: pregnancy.familyId, deletedAt: null },
          select: { colorIndex: true, sortOrder: true },
        });
        const used = new Set(siblings.map((child) => child.colorIndex));
        let order = Math.max(-1, ...siblings.map((child) => child.sortOrder));
        if (order + children.length > 32767)
          throw new ValidationError('Child sort order capacity exceeded.');
        const memories = await tx.memory.findMany({
          where: {
            familyId: pregnancy.familyId,
            pregnancyId: pregnancy.id,
            deletedAt: null,
          },
          select: { id: true, occurredLocalDate: true },
        });
        for (const child of children)
          for (const memory of memories)
            ageMonth(memory.occurredLocalDate, child.birthDate);
        // Share the same durable usage lock as MemoryContentRepository writers.
        await tx.$executeRaw`INSERT INTO billing.family_usage (family_id) VALUES (${pregnancy.familyId}::uuid) ON CONFLICT (family_id) DO NOTHING`;
        const [usage] = await tx.$queryRaw<
          { memory_count: number }[]
        >`SELECT memory_count FROM billing.family_usage WHERE family_id = ${pregnancy.familyId}::uuid FOR UPDATE`;
        const entitlement = await tx.familyEntitlement.findFirst({
          where: { familyId: pregnancy.familyId, deletedAt: null },
          include: { planVersion: true },
        });
        const quotas = entitlement?.planVersion?.quotas;
        if (!quotas || typeof quotas !== 'object' || Array.isArray(quotas))
          throw new DomainError(
            'Plan quotas are unavailable.',
            'PLAN_CONFIGURATION_INVALID',
            403,
          );
        const quota = quotas.memoryCount;
        if (
          quota !== undefined &&
          (typeof quota !== 'number' ||
            !Number.isSafeInteger(quota) ||
            quota < 0)
        )
          throw new DomainError(
            'Memory quota is invalid.',
            'PLAN_CONFIGURATION_INVALID',
            403,
          );
        if (
          typeof quota === 'number' &&
          (usage?.memory_count ?? 0) + children.length > quota
        )
          throw new DomainError(
            'Memory quota of the current plan is exceeded.',
            'QUOTA_MEMORY_COUNT_EXCEEDED',
            402,
          );
        await tx.$executeRaw`UPDATE billing.family_usage SET memory_count = memory_count + ${children.length}, version = version + 1 WHERE family_id = ${pregnancy.familyId}::uuid`;
        await tx.birthConversion.create({
          data: {
            pregnancyId: pregnancy.id,
            familyId: pregnancy.familyId,
            idempotencyKey: key,
            createdBy: userId,
          },
        });
        const created: Child[] = [];
        for (const [index, input] of children.entries()) {
          const colorIndex =
            Array.from({ length: 8 }, (_, i) => i + 1).find(
              (color) => !used.has(color),
            ) ?? ((siblings.length + index) % 8) + 1;
          used.add(colorIndex);
          const row = await tx.child.create({
            data: {
              ...input,
              familyId: pregnancy.familyId,
              pregnancyId: pregnancy.id,
              birthOrder: index + 1,
              createdBy: userId,
              colorIndex,
              sortOrder: ++order,
            },
          });
          await tx.birthConversionChild.create({
            data: {
              pregnancyId: pregnancy.id,
              familyId: pregnancy.familyId,
              childId: row.id,
            },
          });
          created.push(mapChild(row));
        }
        // Shared opening chapter (§7.6), retaining the pregnancy privacy boundary.
        for (const child of created) {
          if (memories.length)
            await tx.memoryChild.createMany({
              data: memories.map((memory) => ({
                familyId: pregnancy.familyId,
                memoryId: memory.id,
                childId: child.id,
                addedBy: userId,
                ageMonth: ageMonth(memory.occurredLocalDate, child.birthDate),
              })),
            });
        }
        for (const child of created) {
          const birthMemory = await tx.memory.create({
            data: {
              familyId: pregnancy.familyId,
              authorUserId: userId,
              authorRole: 'PARENT',
              kind: 'MILESTONE',
              body: 'Chào đời',
              occurredAt: child.birthDate,
              occurredLocalDate: child.birthDate,
              visibility: 'PARENTS',
              status: 'PUBLISHED',
            },
          });
          await tx.memoryChild.create({
            data: {
              familyId: pregnancy.familyId,
              memoryId: birthMemory.id,
              childId: child.id,
              addedBy: userId,
              ageMonth: 0,
            },
          });
          await tx.milestone.create({
            data: {
              familyId: pregnancy.familyId,
              childId: child.id,
              memoryId: birthMemory.id,
              customTitle: 'Chào đời',
              occurredOn: child.birthDate,
              createdBy: userId,
            },
          });
        }
        const pregnancyMilestones = await tx.milestone.findMany({
          where: {
            familyId: pregnancy.familyId,
            pregnancyId: pregnancy.id,
            deletedAt: null,
            memory: { deletedAt: null },
          },
        });
        if (pregnancyMilestones.length)
          await tx.milestone.createMany({
            data: created.flatMap((child) =>
              pregnancyMilestones.map((milestone) => ({
                familyId: pregnancy.familyId,
                childId: child.id,
                fromMilestoneId: milestone.id,
                memoryId: milestone.memoryId,
                templateCode: milestone.templateCode,
                customTitle: milestone.customTitle,
                occurredOn: milestone.occurredOn,
                createdBy: userId,
              })),
            ),
          });
        const grants = await tx.circleGrant.findMany({
          where: {
            familyId: pregnancy.familyId,
            pregnancyId: pregnancy.id,
            status: 'ACTIVE',
            deletedAt: null,
            circleMember: { status: 'ACTIVE', deletedAt: null, endedAt: null },
          },
        });
        if (grants.length)
          await tx.circleGrant.createMany({
            data: created.flatMap((child) =>
              grants.map((grant) => ({
                familyId: pregnancy.familyId,
                childId: child.id,
                circleMemberId: grant.circleMemberId,
                permission: grant.permission,
                allowDownload: grant.allowDownload,
                createdBy: userId,
              })),
            ),
          });
        await tx.pregnancy.update({
          where: { id: pregnancy.id },
          data: {
            status: 'COMPLETED',
            completedAt: new Date(),
            version: { increment: 1 },
          },
        });
        await tx.outboxEvent.create({
          data: {
            eventType: 'pregnancy.birth_converted',
            aggregateId: pregnancy.id,
            familyId: pregnancy.familyId,
            payload: {
              pregnancyId: pregnancy.id,
              childIds: created.map((child) => child.id),
            },
          },
        });
        await tx.idempotencyRecord.create({
          data: {
            scopeKey: pregnancy.id,
            operation: 'pregnancy.birth',
            idempotencyKey: key,
            actorUserId: userId,
            familyId: pregnancy.familyId,
            requestHash: createHash('sha256')
              .update(JSON.stringify(children))
              .digest(),
            status: 'SUCCEEDED',
            resultEntityType: 'pregnancy',
            resultEntityId: pregnancy.id,
            responseCode: 201,
            responseReference: JSON.parse(
              JSON.stringify(created),
            ) as Prisma.InputJsonValue,
          },
        });
        return created;
      });
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      )
        throw new DomainError(
          'Idempotency-Key conflicts with another conversion.',
          'IDEMPOTENCY_KEY_CONFLICT',
          409,
        );
      throw error;
    }
  }
}
