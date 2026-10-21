import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PinoLogger } from 'nestjs-pino';
import type {
  ErrorReport,
  IErrorReporter,
} from '../interfaces/services/error-reporter.interface';

@Injectable()
export class ErrorReporterService implements IErrorReporter {
  constructor(
    private readonly config: ConfigService,
    private readonly logger: PinoLogger,
  ) {}

  report(event: ErrorReport): void {
    // Rebuild an allowlist even if a caller passes additional properties at runtime.
    const safe = {
      requestId: event.requestId,
      route: event.route,
      status: event.status,
    };
    this.logger.error(safe, 'Request failed');
    const configured = this.config.get<string>('ERROR_REPORTING_DSN');
    if (!configured) return;
    const dsn = new URL(configured);
    const project = dsn.pathname.split('/').pop();
    const prefix = dsn.pathname.slice(0, dsn.pathname.lastIndexOf('/'));
    const endpoint = `${dsn.origin}${prefix}/api/${project}/envelope/`;
    const id = randomUUID().replaceAll('-', '');
    const payload = [
      JSON.stringify({ event_id: id, sent_at: new Date().toISOString() }),
      JSON.stringify({ type: 'event' }),
      JSON.stringify({
        event_id: id,
        timestamp: Date.now() / 1000,
        platform: 'node',
        level: 'error',
        message: 'HTTP request failed',
        tags: safe,
      }),
    ].join('\n');
    // Best effort, bounded timeout, no retry or response-body logging on the request path.
    void fetch(endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-sentry-envelope',
        'X-Sentry-Auth': `Sentry sentry_version=7,sentry_key=${dsn.username}`,
      },
      body: payload,
      signal: AbortSignal.timeout(2000),
    })
      .then((response) => {
        void response.body?.cancel().catch(() => undefined);
        if (!response.ok) this.logger.warn('Error reporting delivery failed');
      })
      .catch(() => this.logger.warn('Error reporting delivery failed'));
  }
}
