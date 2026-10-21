import { Inject, Injectable } from '@nestjs/common';
import type { CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ADMIN_CMS_AUTH_SERVICE } from '../../interfaces/services/admin-cms-auth-service.interface';
import type { IAdminCmsAuthService } from '../../interfaces/services/admin-cms-auth-service.interface';
import { DomainError } from '../errors/domain.error';
import { ADMIN_CMS_ROLES } from './admin-cms-actor.decorator';
import type { AdminCmsRequest } from './admin-cms-actor.decorator';
@Injectable()
export class AdminCmsGuard implements CanActivate {
  constructor(
    @Inject(ADMIN_CMS_AUTH_SERVICE) private readonly auth: IAdminCmsAuthService,
    private readonly reflector: Reflector,
  ) {}
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AdminCmsRequest>();
    const value = request.headers.authorization;
    const match =
      typeof value === 'string' && value.length < 8192
        ? /^Bearer ([A-Za-z0-9_.-]+)$/i.exec(value)
        : null;
    if (!match?.[1])
      throw new DomainError(
        'Admin authentication required.',
        'ADMIN_UNAUTHORIZED',
        401,
      );
    request.adminActor = Object.freeze(await this.auth.authenticate(match[1]));
    const roles = this.reflector.getAllAndOverride<string[]>(ADMIN_CMS_ROLES, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (
      roles?.length &&
      !request.adminActor.roles.some(
        (role) =>
          roles.includes(role) || role === 'ADMIN' || role === 'SUPER_ADMIN',
      )
    ) {
      await this.auth.recordDenied(request.adminActor);
      throw new DomainError(
        'Admin permission required.',
        'ADMIN_FORBIDDEN',
        403,
      );
    }
    return true;
  }
}
