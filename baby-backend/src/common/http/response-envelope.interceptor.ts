import { Injectable, SetMetadata } from '@nestjs/common';
import type {
  CallHandler,
  ExecutionContext,
  NestInterceptor,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { map } from 'rxjs';
import type { Observable } from 'rxjs';

const RAW_RESPONSE = 'baby-family:raw-response';

/** Opts a controller/handler out of the `{ data }` envelope (health probes, legacy Note sample). */
export const RawResponse = () => SetMetadata(RAW_RESPONSE, true);

/** List results already shaped as `{ data: [...], meta }` (see common/pagination). */
function isEnvelopedList(value: unknown): boolean {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return false;
  const keys = Object.keys(value);
  return (
    keys.includes('data') &&
    Array.isArray((value as { data: unknown }).data) &&
    keys.every(
      (key) => key === 'data' || key === 'meta' || key === 'nextCursor',
    )
  );
}

/** Spec §11.1: successful responses are `{ "data": <payload> }`; 204 stays empty. */
@Injectable()
export class ResponseEnvelopeInterceptor implements NestInterceptor {
  constructor(private readonly reflector: Reflector) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    if (
      context.getType() !== 'http' ||
      this.reflector.getAllAndOverride<boolean>(RAW_RESPONSE, [
        context.getHandler(),
        context.getClass(),
      ])
    )
      return next.handle();
    return next
      .handle()
      .pipe(
        map((value: unknown) =>
          value === undefined || isEnvelopedList(value)
            ? value
            : { data: value },
        ),
      );
  }
}
