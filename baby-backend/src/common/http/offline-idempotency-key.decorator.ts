import { BadRequestException, createParamDecorator } from '@nestjs/common';
import type { ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';

function read(context: ExecutionContext): string | undefined {
  const value = context
    .switchToHttp()
    .getRequest<Request>()
    .header('idempotency-key');
  if (value === undefined) return undefined;
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
      value,
    )
  )
    throw new BadRequestException('Idempotency-Key header must be a UUID.');
  return value.toLowerCase();
}
export const OptionalIdempotencyKey = createParamDecorator(
  (_: unknown, context: ExecutionContext) => read(context),
);
