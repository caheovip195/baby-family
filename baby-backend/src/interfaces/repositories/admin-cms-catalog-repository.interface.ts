import type { AdminCmsCatalogKind } from '../../dto/admin-cms-catalog/admin-cms-catalog.dto';
import type { AdminCmsCatalogEntry } from '../../models/admin-cms-catalog-entry.model';
export const ADMIN_CMS_CATALOG_REPOSITORY = Symbol(
  'ADMIN_CMS_CATALOG_REPOSITORY',
);
export interface IAdminCmsCatalogRepository {
  list(
    adminId: string,
    kind: AdminCmsCatalogKind,
    offset: number,
    limit: number,
  ): Promise<AdminCmsCatalogEntry[]>;
}
