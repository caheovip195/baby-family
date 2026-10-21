import { createParamDecorator, SetMetadata } from '@nestjs/common';
import type { ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';
import type { AdminCmsActor } from '../../models/admin-cms-auth.model';
export type AdminCmsRequest = Request & { adminActor: AdminCmsActor };
export const ADMIN_CMS_ROLES = 'admin-cms:roles';
export const AdminCmsRoles = (...roles: string[]) =>
  SetMetadata(ADMIN_CMS_ROLES, roles);
export const CurrentAdminCms = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AdminCmsActor =>
    context.switchToHttp().getRequest<AdminCmsRequest>().adminActor,
);
