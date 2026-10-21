import type {
  AdminCmsOperationsCase,
  AdminCmsOperationsContent,
  AdminCmsOperationsLicense,
} from '../../models/admin-cms-operations.model';
export const ADMIN_CMS_OPERATIONS_REPOSITORY = Symbol(
  'ADMIN_CMS_OPERATIONS_REPOSITORY',
);
export interface IAdminCmsOperationsRepository {
  list(
    adminId: string,
    input: { status?: string; offset: number; limit: number },
  ): Promise<{ items: AdminCmsOperationsCase[]; total: number }>;
  detail(adminId: string, id: string): Promise<AdminCmsOperationsCase>;
  content(
    adminId: string,
    id: string,
    reason: string,
  ): Promise<AdminCmsOperationsContent>;
  status(
    adminId: string,
    id: string,
    status: string,
    reason: string,
  ): Promise<AdminCmsOperationsCase>;
  hide(
    adminId: string,
    id: string,
    reason: string,
  ): Promise<AdminCmsOperationsCase>;
  license(
    adminId: string,
    familyId: string,
    blocked: boolean,
    reason: string,
    reasonCode: string,
  ): Promise<AdminCmsOperationsLicense>;
}
