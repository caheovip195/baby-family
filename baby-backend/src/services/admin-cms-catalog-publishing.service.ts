import { Inject, Injectable } from '@nestjs/common';
import { z } from 'zod';
import { DomainError } from '../common/errors/domain.error';
import {
  catalogMissionCreateSchema,
  catalogPlanCreateSchema,
  catalogTrialCreateSchema,
  catalogPublishSchema,
  catalogMissionPublishSchema,
  catalogRetireSchema,
} from '../dto/admin-cms-catalog/admin-cms-catalog-publishing.dto';
import type { CatalogPublishingKind } from '../dto/admin-cms-catalog/admin-cms-catalog-publishing.dto';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import { ADMIN_CMS_CATALOG_PUBLISHING_REPOSITORY } from '../interfaces/repositories/admin-cms-catalog-publishing-repository.interface';
import type { IAdminCmsCatalogPublishingRepository } from '../interfaces/repositories/admin-cms-catalog-publishing-repository.interface';
import type { IAdminCmsCatalogPublishingService } from '../interfaces/services/admin-cms-catalog-publishing-service.interface';
@Injectable()
export class AdminCmsCatalogPublishingService implements IAdminCmsCatalogPublishingService {
  constructor(
    @Inject(ADMIN_CMS_CATALOG_PUBLISHING_REPOSITORY)
    private readonly repository: IAdminCmsCatalogPublishingRepository,
  ) {}
  private authorize(actor: AdminCmsActor, kind: string): CatalogPublishingKind {
    if (!['missions', 'plan-versions', 'trial-policies'].includes(kind))
      throw new DomainError(
        'Catalog version publishing is not supported.',
        'ADMIN_CATALOG_UNSUPPORTED',
        422,
      );
    const roles =
      kind === 'missions'
        ? ['CONTENT', 'SUPER_ADMIN']
        : ['BILLING_OPS', 'OPS', 'SUPER_ADMIN'];
    if (!actor.roles.some((role) => roles.includes(role)))
      throw new DomainError(
        'Admin permission required.',
        'ADMIN_FORBIDDEN',
        403,
      );
    return kind as CatalogPublishingKind;
  }
  private parse<T>(schema: z.ZodType<T>, body: unknown): T {
    const parsed = schema.safeParse(body);
    if (!parsed.success)
      throw new DomainError(
        'Invalid catalog request.',
        'VALIDATION_ERROR',
        400,
      );
    return parsed.data;
  }
  async create(actor: AdminCmsActor, kind: string, body: unknown) {
    const target = this.authorize(actor, kind);
    const { reason, ...input } =
      target === 'missions'
        ? this.parse(catalogMissionCreateSchema, body)
        : target === 'plan-versions'
          ? this.parse(catalogPlanCreateSchema, body)
          : this.parse(catalogTrialCreateSchema, body);
    const row = await this.repository.create(actor.id, target, input, reason);
    return { kind, item: row.data };
  }
  async publish(actor: AdminCmsActor, kind: string, id: string, body: unknown) {
    const target = this.authorize(actor, kind);
    const input =
      target === 'missions'
        ? this.parse(catalogMissionPublishSchema, body)
        : this.parse(catalogPublishSchema, body);
    if (target !== 'missions' && !z.uuid().safeParse(id).success)
      throw new DomainError('Invalid catalog id.', 'VALIDATION_ERROR', 400);
    const row = await this.repository.publish(
      actor.id,
      target,
      id,
      input.reason,
      'availableFrom' in input ? new Date(input.availableFrom) : new Date(),
      'rolloutPct' in input ? (input.rolloutPct ?? 100) : 100,
    );
    return { kind, item: row.data };
  }
  async retire(actor: AdminCmsActor, kind: string, id: string, body: unknown) {
    const target = this.authorize(actor, kind);
    const { reason } = this.parse(catalogRetireSchema, body);
    if (target !== 'missions' && !z.uuid().safeParse(id).success)
      throw new DomainError('Invalid catalog id.', 'VALIDATION_ERROR', 400);
    return {
      kind,
      item: (await this.repository.retire(actor.id, target, id, reason)).data,
    };
  }
  async drafts(actor: AdminCmsActor, kind: string) {
    const target = this.authorize(actor, kind);
    return {
      kind,
      items: (await this.repository.drafts(target)).map((row) => row.data),
    };
  }
}
