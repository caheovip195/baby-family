import {
  BadRequestException,
  createParamDecorator,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import type { ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';

const VERSION_PATTERN = /^(?:W\/)?"?(\d{1,9})"?$/;

/**
 * Required `If-Match: <version>` header for optimistic locking (spec §3 “Optimistic
 * locking”): missing → 428 PRECONDITION_REQUIRED, malformed → 400. Accepts `3`,
 * `"3"` or `W/"3"`.
 */
export const IfMatchVersion = createParamDecorator(
  (_data: unknown, context: ExecutionContext): number => {
    const value = context
      .switchToHttp()
      .getRequest<Request>()
      .header('if-match');
    if (!value)
      throw new HttpException(
        'If-Match header with the resource version is required.',
        HttpStatus.PRECONDITION_REQUIRED,
      );
    const match = VERSION_PATTERN.exec(value.trim());
    if (!match)
      throw new BadRequestException('If-Match must be a resource version.');
    return Number(match[1]);
  },
);
