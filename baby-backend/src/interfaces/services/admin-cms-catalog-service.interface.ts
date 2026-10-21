import type { AdminCmsCatalogQueryDto } from '../../dto/admin-cms-catalog/admin-cms-catalog.dto';
export const ADMIN_CMS_CATALOG_SERVICE = Symbol('ADMIN_CMS_CATALOG_SERVICE');
export interface IAdminCmsCatalogService {
  list(
    adminId: string,
    kind: string,
    query: AdminCmsCatalogQueryDto,
  ): Promise<{
    kind: string;
    items: Record<string, unknown>[];
    nextOffset: number | null;
    mutationSupported: false;
    mutationPolicy: 'IMMUTABLE_PUBLISHED_VERSIONS';
  }>;
}
