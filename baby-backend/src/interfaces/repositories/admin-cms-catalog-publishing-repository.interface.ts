import type {
  CatalogPublishingKind,
  CatalogPublishingInput,
} from '../../dto/admin-cms-catalog/admin-cms-catalog-publishing.dto';
import type { AdminCmsCatalogPublishingEntry } from '../../models/admin-cms-catalog-publishing.model';
export const ADMIN_CMS_CATALOG_PUBLISHING_REPOSITORY = Symbol(
  'ADMIN_CMS_CATALOG_PUBLISHING_REPOSITORY',
);
export interface IAdminCmsCatalogPublishingRepository {
  create(
    adminId: string,
    kind: CatalogPublishingKind,
    input: CatalogPublishingInput,
    reason: string,
  ): Promise<AdminCmsCatalogPublishingEntry>;
  publish(
    adminId: string,
    kind: CatalogPublishingKind,
    id: string,
    reason: string,
    availableFrom: Date,
    rolloutPct: number,
  ): Promise<AdminCmsCatalogPublishingEntry>;
  retire(
    adminId: string,
    kind: CatalogPublishingKind,
    id: string,
    reason: string,
  ): Promise<AdminCmsCatalogPublishingEntry>;
  drafts(
    kind: CatalogPublishingKind,
  ): Promise<AdminCmsCatalogPublishingEntry[]>;
}
