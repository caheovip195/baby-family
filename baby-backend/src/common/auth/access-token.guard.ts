import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import type { CanActivate, ExecutionContext } from '@nestjs/common';
import { AUTHENTICATION_SERVICE } from '../../interfaces/services/authentication-service.interface';
import type { IAuthenticationService } from '../../interfaces/services/authentication-service.interface';
import { AUTH_PRINCIPAL } from './auth-principal';
import type { AuthenticatedRequest } from './current-actor.decorator';

@Injectable()
export class AccessTokenGuard implements CanActivate {
  constructor(
    @Inject(AUTHENTICATION_SERVICE)
    private readonly authentication: IAuthenticationService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const authorization = request.headers.authorization;
    const match =
      typeof authorization === 'string' && authorization.length <= 8192
        ? /^Bearer ([A-Za-z0-9_.-]+)$/i.exec(authorization)
        : null;
    if (!match?.[1])
      throw new UnauthorizedException('A Bearer access token is required.');
    request[AUTH_PRINCIPAL] = Object.freeze(
      await this.authentication.verifyAccessToken(match[1]),
    );
    return true;
  }
}
