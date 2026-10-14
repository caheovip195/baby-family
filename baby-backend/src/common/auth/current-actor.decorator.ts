import { createParamDecorator, UnauthorizedException } from '@nestjs/common';
import type { ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';
import { AUTH_PRINCIPAL } from './auth-principal';
import type { AuthPrincipal } from './auth-principal';

export type AuthenticatedRequest = Request & {
  [AUTH_PRINCIPAL]?: AuthPrincipal;
};

export const CurrentActor = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AuthPrincipal => {
    const actor = context.switchToHttp().getRequest<AuthenticatedRequest>()[
      AUTH_PRINCIPAL
    ];
    if (!actor) throw new UnauthorizedException('An access token is required.');
    return actor;
  },
);
