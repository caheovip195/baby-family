import type { AdminCmsActor } from '../../models/admin-cms-auth.model';
export const ADMIN_CMS_CATALOG_PUBLISHING_SERVICE = Symbol(
  'ADMIN_CMS_CATALOG_PUBLISHING_SERVICE',
);
export interface IAdminCmsCatalogPublishingService {
  create(
    actor: AdminCmsActor,
    kind: string,
    body: unknown,
  ): Promise<{ kind: string; item: Record<string, unknown> }>;
  publish(
    actor: AdminCmsActor,
    kind: string,
    id: string,
    body: unknown,
  ): Promise<{ kind: string; item: Record<string, unknown> }>;
  retire(
    actor: AdminCmsActor,
    kind: string,
    id: string,
    body: unknown,
  ): Promise<{ kind: string; item: Record<string, unknown> }>;
  drafts(
    actor: AdminCmsActor,
    kind: string,
  ): Promise<{ kind: string; items: Record<string, unknown>[] }>;
}
