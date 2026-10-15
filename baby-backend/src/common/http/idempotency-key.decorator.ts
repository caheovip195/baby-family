import { BadRequestException, createParamDecorator } from '@nestjs/common';
import type { ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Required `Idempotency-Key` header (UUID) for state-changing POSTs (spec §11.1). */
export const IdempotencyKey = createParamDecorator(
  (_data: unknown, context: ExecutionContext): string => {
    const value = context
      .switchToHttp()
      .getRequest<Request>()
      .header('idempotency-key');
    if (!value || !UUID_PATTERN.test(value))
      throw new BadRequestException('Idempotency-Key header must be a UUID.');
    return value.toLowerCase();
  },
);
