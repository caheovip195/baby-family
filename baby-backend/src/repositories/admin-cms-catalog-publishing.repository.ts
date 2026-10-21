import { randomUUID } from 'node:crypto';
import { z } from 'zod';
import {
  catalogPlanCreateSchema,
  catalogTrialCreateSchema,
} from '../dto/admin-cms-catalog/admin-cms-catalog-publishing.dto';
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import { DomainError } from '../common/errors/domain.error';
import type {
  CatalogPublishingKind,
  CatalogPublishingInput,
  CatalogMissionInput,
  CatalogPlanInput,
  CatalogTrialInput,
} from '../dto/admin-cms-catalog/admin-cms-catalog-publishing.dto';
import type { IAdminCmsCatalogPublishingRepository } from '../interfaces/repositories/admin-cms-catalog-publishing-repository.interface';
import { AdminCmsCatalogPublishingEntry } from '../models/admin-cms-catalog-publishing.model';
type Draft = {
  schemaVersion: 1;
  id: string;
  kind: CatalogPublishingKind;
  status: 'DRAFT' | 'PUBLISHED' | 'RETIRED';
  input: CatalogPlanInput | CatalogTrialInput;
};
const prefix = (kind: CatalogPublishingKind) =>
  kind === 'plan-versions' ? 'cms.plan.' : 'cms.trial.';
const conflict = () =>
  new DomainError(
    'Catalog version already exists or has been published.',
    'ADMIN_CATALOG_CONFLICT',
    409,
  );
const missing = () =>
  new DomainError(
    'Catalog entry was not found.',
    'ADMIN_CATALOG_NOT_FOUND',
    404,
  );
function readDraft(value: unknown, kind: CatalogPublishingKind): Draft {
  const envelope = z
    .object({
      schemaVersion: z.literal(1),
      id: z.uuid(),
      kind: z.literal(kind),
      status: z.enum(['DRAFT', 'PUBLISHED', 'RETIRED']),
      input: z.record(z.string(), z.unknown()),
    })
    .strict()
    .safeParse(value);
  if (!envelope.success)
    throw new DomainError(
      'Catalog draft format is unsupported.',
      'ADMIN_CATALOG_DRAFT_INVALID',
      409,
    );
  const input =
    kind === 'plan-versions'
      ? catalogPlanCreateSchema.safeParse({
          ...envelope.data.input,
          reason: 'stored-draft',
        })
      : catalogTrialCreateSchema.safeParse({
          ...envelope.data.input,
          reason: 'stored-draft',
        });
  if (!input.success)
    throw new DomainError(
      'Catalog draft format is unsupported.',
      'ADMIN_CATALOG_DRAFT_INVALID',
      409,
    );
  return envelope.data as unknown as Draft;
}
function model(row: object, status: string) {
  return new AdminCmsCatalogPublishingEntry({
    ...(JSON.parse(
      JSON.stringify(row, (_key, value: unknown) =>
        typeof value === 'bigint' ? value.toString() : value,
      ),
    ) as Record<string, unknown>),
    status,
  });
}
@Injectable()
export class AdminCmsCatalogPublishingRepository implements IAdminCmsCatalogPublishingRepository {
  constructor(private readonly prisma: PrismaService) {}
  private async transaction<T>(
    work: (tx: Prisma.TransactionClient) => Promise<T>,
  ): Promise<T> {
    try {
      return await this.prisma.$transaction(async (tx) => {
        await tx.$queryRaw`SELECT pg_advisory_xact_lock(hashtext('admin-cms-catalog-publishing'))::text`;
        return work(tx);
      });
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        ['P2002', 'P2003', 'P2034'].includes(error.code)
      )
        throw conflict();
      throw error;
    }
  }
  private audit(
    tx: Prisma.TransactionClient,
    adminId: string,
    kind: CatalogPublishingKind,
    id: string,
    action: string,
    reason: string,
  ) {
    return tx.adminAuditEvent.create({
      data: {
        adminId,
        action: `CATALOG_${action}`,
        entityType: kind,
        entityId: id,
        reasonCode: reason,
        redactedChanges: { kind, id, action },
      },
    });
  }
  async create(
    adminId: string,
    kind: CatalogPublishingKind,
    input: CatalogPublishingInput,
    reason: string,
  ) {
    return this.transaction(async (tx) => {
      if (kind === 'missions') {
        const row = await tx.missionTemplate.create({
          data: {
            ...(input as CatalogMissionInput),
            status: 'DRAFT',
            rolloutPct: 0,
          },
        });
        await this.audit(tx, adminId, kind, row.code, 'DRAFT_CREATE', reason);
        return model(row, 'DRAFT');
      }
      const data = input as CatalogPlanInput | CatalogTrialInput;
      if (kind === 'plan-versions') {
        const plan = data as CatalogPlanInput;
        if (
          !(await tx.plan.findFirst({
            where: { id: plan.planId, deletedAt: null },
          }))
        )
          throw missing();
        if (
          await tx.planVersion.findUnique({
            where: {
              planId_version: { planId: plan.planId, version: plan.version },
            },
          })
        )
          throw conflict();
      } else {
        const trial = data as CatalogTrialInput;
        if (
          !(await tx.planVersion.findFirst({
            where: {
              id: trial.planVersionId,
              deletedAt: null,
              plan: { deletedAt: null },
            },
          }))
        )
          throw missing();
        if (
          await tx.trialPolicy.findUnique({
            where: {
              code_version: { code: trial.code, version: trial.version },
            },
          })
        )
          throw conflict();
      }
      const drafts = await tx.appConfig.findMany({
        where: { key: { startsWith: prefix(kind) }, deletedAt: null },
      });
      if (
        drafts.some((row) => {
          const draft = readDraft(row.value, kind);
          return (
            draft.status === 'DRAFT' &&
            draft.input.version === data.version &&
            (kind === 'plan-versions'
              ? (draft.input as CatalogPlanInput).planId ===
                (data as CatalogPlanInput).planId
              : (draft.input as CatalogTrialInput).code ===
                (data as CatalogTrialInput).code)
          );
        })
      )
        throw conflict();
      const id = randomUUID();
      const draft: Draft = {
        schemaVersion: 1,
        id,
        kind,
        status: 'DRAFT',
        input: data,
      };
      await tx.appConfig.create({
        data: {
          key: prefix(kind) + id,
          value: draft,
          updatedBy: adminId,
        },
      });
      await this.audit(tx, adminId, kind, id, 'DRAFT_CREATE', reason);
      return model({ id, ...data }, 'DRAFT');
    });
  }
  async publish(
    adminId: string,
    kind: CatalogPublishingKind,
    id: string,
    reason: string,
    availableFrom: Date,
    rolloutPct: number,
  ) {
    return this.transaction(async (tx) => {
      if (kind === 'missions') {
        const row = await tx.missionTemplate.findFirst({
          where: { code: id, deletedAt: null },
        });
        if (!row) throw missing();
        if (row.status !== 'DRAFT') throw conflict();
        const published = await tx.missionTemplate.update({
          where: { id: row.id },
          data: { status: 'ACTIVE', rolloutPct },
        });
        await this.audit(tx, adminId, kind, id, 'PUBLISH', reason);
        return model(published, 'PUBLISHED');
      }
      const config = await tx.appConfig.findFirst({
        where: { key: prefix(kind) + id, deletedAt: null },
      });
      if (!config) {
        const existing =
          kind === 'plan-versions'
            ? await tx.planVersion.findFirst({ where: { id, deletedAt: null } })
            : await tx.trialPolicy.findFirst({
                where: { id, deletedAt: null },
              });
        if (existing) throw conflict();
        throw missing();
      }
      const draft = readDraft(config.value, kind);
      if (draft.status !== 'DRAFT') throw conflict();
      let row: object;
      if (kind === 'plan-versions') {
        const input = draft.input as CatalogPlanInput;
        if (
          !(await tx.plan.findFirst({
            where: { id: input.planId, deletedAt: null, active: true },
          }))
        )
          throw missing();
        row = await tx.planVersion.create({
          data: { id, ...input, availableFrom },
        });
      } else {
        const input = draft.input as CatalogTrialInput;
        if (
          await tx.trialPolicy.findFirst({
            where: { code: input.code, active: true, deletedAt: null },
          })
        )
          throw conflict();
        const plan = await tx.planVersion.findFirst({
          where: {
            id: input.planVersionId,
            deletedAt: null,
            plan: { deletedAt: null, active: true },
          },
        });
        if (
          !plan ||
          plan.availableFrom > availableFrom ||
          (plan.retiredAt !== null && plan.retiredAt <= availableFrom)
        )
          throw new DomainError(
            'Trial requires a plan available at publication.',
            'ADMIN_CATALOG_PLAN_UNAVAILABLE',
            422,
          );
        row = await tx.trialPolicy.create({
          data: {
            id,
            ...input,
            durationSeconds: BigInt(input.durationSeconds),
            active: true,
            publishedAt: availableFrom,
          },
        });
      }
      await tx.appConfig.update({
        where: { key: config.key },
        data: {
          value: {
            ...draft,
            status: 'PUBLISHED',
          },
          updatedBy: adminId,
        },
      });
      await this.audit(tx, adminId, kind, id, 'PUBLISH', reason);
      return model(row, 'PUBLISHED');
    });
  }
  async retire(
    adminId: string,
    kind: CatalogPublishingKind,
    id: string,
    reason: string,
  ) {
    return this.transaction(async (tx) => {
      let row: object;
      if (kind === 'missions') {
        const found = await tx.missionTemplate.findFirst({
          where: { code: id, deletedAt: null },
        });
        if (!found) throw missing();
        row = await tx.missionTemplate.update({
          where: { id: found.id },
          data: { status: 'RETIRED', rolloutPct: 0 },
        });
      } else {
        const config = await tx.appConfig.findFirst({
          where: { key: prefix(kind) + id, deletedAt: null },
        });
        const draft = config ? readDraft(config.value, kind) : undefined;
        const persisted =
          draft?.status === 'RETIRED'
            ? kind === 'plan-versions'
              ? await tx.planVersion.findFirst({
                  where: { id, deletedAt: null },
                })
              : await tx.trialPolicy.findFirst({
                  where: { id, deletedAt: null },
                })
            : null;
        if (
          draft &&
          (draft.status === 'DRAFT' ||
            (draft.status === 'RETIRED' && !persisted))
        ) {
          row = { id, ...draft.input };
        } else if (kind === 'plan-versions') {
          const found = await tx.planVersion.findFirst({
            where: { id, deletedAt: null },
          });
          if (!found) throw missing();
          if (
            await tx.trialPolicy.findFirst({
              where: { planVersionId: id, active: true, deletedAt: null },
            })
          )
            throw new DomainError(
              'Retire active trial policies before retiring their plan version.',
              'ADMIN_CATALOG_CONFLICT',
              409,
            );
          row = await tx.planVersion.update({
            where: { id },
            data: {
              retiredAt:
                found.retiredAt ??
                new Date(Math.max(Date.now(), found.availableFrom.getTime())),
            },
          });
        } else {
          const found = await tx.trialPolicy.findFirst({
            where: { id, deletedAt: null },
          });
          if (!found) throw missing();
          row = await tx.trialPolicy.update({
            where: { id },
            data: {
              active: false,
              retiredAt:
                found.retiredAt ??
                new Date(
                  Math.max(Date.now(), found.publishedAt?.getTime() ?? 0),
                ),
            },
          });
        }
        if (config && draft)
          await tx.appConfig.update({
            where: { key: config.key },
            data: {
              value: {
                ...draft,
                status: 'RETIRED',
              },
              updatedBy: adminId,
            },
          });
      }
      await this.audit(tx, adminId, kind, id, 'RETIRE', reason);
      return model(row, 'RETIRED');
    });
  }
  async drafts(kind: CatalogPublishingKind) {
    if (kind === 'missions')
      return (
        await this.prisma.missionTemplate.findMany({
          where: { status: 'DRAFT', deletedAt: null },
          orderBy: { code: 'asc' },
        })
      ).map((row) => model(row, 'DRAFT'));
    const rows = await this.prisma.appConfig.findMany({
      where: { key: { startsWith: prefix(kind) }, deletedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    return rows.flatMap((row) => {
      const draft = readDraft(row.value, kind);
      return draft.status === 'DRAFT'
        ? [model({ id: draft.id, ...draft.input }, 'DRAFT')]
        : [];
    });
  }
}
