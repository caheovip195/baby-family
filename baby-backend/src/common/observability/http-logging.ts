import { randomUUID } from 'node:crypto';
import type { IncomingMessage, ServerResponse } from 'node:http';
import type { Request } from 'express';
import type { Options } from 'pino-http';

/** Never fall back to originalUrl/path: both may contain personal data. */
export function safeRoute(request: IncomingMessage): string {
  const route: unknown = (request as Request).route;
  if (
    route &&
    typeof route === 'object' &&
    'path' in route &&
    typeof route.path === 'string'
  ) {
    return route.path;
  }
  return 'unmatched';
}

export function requestId(request: IncomingMessage): string {
  const incoming = request.headers['x-request-id'];
  // Same contract as before structured logging: a bounded safe charset.
  return typeof incoming === 'string' && /^[a-zA-Z0-9_-]{1,100}$/.test(incoming)
    ? incoming
    : randomUUID();
}

export function completionFields(
  req: IncomingMessage,
  res: ServerResponse,
  duration: unknown,
) {
  return {
    requestId: (req as IncomingMessage & { id?: string }).id,
    route: safeRoute(req),
    status: res.statusCode,
    durationMs:
      typeof duration === 'number' && Number.isFinite(duration)
        ? Math.max(0, duration)
        : 0,
  };
}

export function httpLoggingOptions(
  level: string,
  format: 'json' | 'pretty',
): Options {
  return {
    level,
    customLogLevel: (_req, res, err) =>
      err || res.statusCode >= 500
        ? 'error'
        : res.statusCode >= 400
          ? 'warn'
          : 'info',
    ...(format === 'pretty'
      ? { transport: { target: 'pino-pretty', options: { colorize: false } } }
      : {}),
    formatters: { level: (label) => ({ level: label }) },
    genReqId: (req, res) => {
      const id = requestId(req);
      res.setHeader('X-Request-Id', id);
      return id;
    },
    serializers: {
      req: (req: { id?: string }) => ({ requestId: req.id }),
      res: () => undefined,
      // Error messages/stacks can embed SQL parameters, tokens and private content.
      err: () => ({ type: 'Error', message: 'Operation failed' }),
    },
    customSuccessObject: (req, res, value: { responseTime?: number }) =>
      completionFields(req, res, value.responseTime),
    customErrorObject: (req, res, _err, value: { responseTime?: number }) =>
      completionFields(req, res, value.responseTime),
    customSuccessMessage: () => 'Request completed',
    customErrorMessage: () => 'Request failed',
    redact: [
      'req.headers',
      'req.body',
      'res.headers',
      'token',
      'otp',
      'password',
      'authorization',
      'cookie',
    ],
  };
}
