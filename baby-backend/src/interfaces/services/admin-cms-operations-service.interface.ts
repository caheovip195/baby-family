import type { AdminCmsActor } from '../../models/admin-cms-auth.model';
import type {
  AdminCmsOperationsListDto,
  AdminCmsOperationsStatusDto,
  AdminCmsOperationsActionDto,
  AdminCmsOperationsBlockDto,
  AdminCmsOperationsReasonDto,
} from '../../dto/admin-cms-operations/admin-cms-operations.dto';
import type {
  AdminCmsOperationsCaseAttributes,
  AdminCmsOperationsContent,
  AdminCmsOperationsLicense,
} from '../../models/admin-cms-operations.model';
export const ADMIN_CMS_OPERATIONS_SERVICE = Symbol(
  'ADMIN_CMS_OPERATIONS_SERVICE',
);
export interface IAdminCmsOperationsService {
  list(
    actor: AdminCmsActor,
    input: AdminCmsOperationsListDto,
  ): Promise<{ items: AdminCmsOperationsCaseAttributes[]; total: number }>;
  detail(
    actor: AdminCmsActor,
    id: string,
  ): Promise<AdminCmsOperationsCaseAttributes>;
  content(
    actor: AdminCmsActor,
    id: string,
    input: AdminCmsOperationsReasonDto,
  ): Promise<AdminCmsOperationsContent>;
  status(
    actor: AdminCmsActor,
    id: string,
    input: AdminCmsOperationsStatusDto,
  ): Promise<AdminCmsOperationsCaseAttributes>;
  hide(
    actor: AdminCmsActor,
    id: string,
    input: AdminCmsOperationsActionDto,
  ): Promise<AdminCmsOperationsCaseAttributes>;
  license(
    actor: AdminCmsActor,
    id: string,
    blocked: boolean,
    input: AdminCmsOperationsBlockDto,
  ): Promise<AdminCmsOperationsLicense>;
}
