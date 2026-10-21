import { Inject, Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { ADMIN_CMS_CATALOG_KINDS } from '../dto/admin-cms-catalog/admin-cms-catalog.dto';
import type {
  AdminCmsCatalogKind,
  AdminCmsCatalogQueryDto,
} from '../dto/admin-cms-catalog/admin-cms-catalog.dto';
import { ADMIN_CMS_CATALOG_REPOSITORY } from '../interfaces/repositories/admin-cms-catalog-repository.interface';
import type { IAdminCmsCatalogRepository } from '../interfaces/repositories/admin-cms-catalog-repository.interface';
import type { IAdminCmsCatalogService } from '../interfaces/services/admin-cms-catalog-service.interface';
@Injectable()
export class AdminCmsCatalogService implements IAdminCmsCatalogService {
  constructor(
    @Inject(ADMIN_CMS_CATALOG_REPOSITORY)
    private readonly repository: IAdminCmsCatalogRepository,
  ) {}
  async list(adminId: string, kind: string, query: AdminCmsCatalogQueryDto) {
    if (!(ADMIN_CMS_CATALOG_KINDS as readonly string[]).includes(kind))
      throw new DomainError(
        'Catalog was not found.',
        'ADMIN_CATALOG_NOT_FOUND',
        404,
      );
    const offset = query.offset ?? 0,
      limit = query.limit ?? 50;
    const rows = await this.repository.list(
      adminId,
      kind as AdminCmsCatalogKind,
      offset,
      limit + 1,
    );
    return {
      kind,
      items: rows.slice(0, limit).map((row) => row.data),
      nextOffset: rows.length > limit ? offset + limit : null,
      mutationSupported: false as const,
      mutationPolicy: 'IMMUTABLE_PUBLISHED_VERSIONS' as const,
    };
  }
}
