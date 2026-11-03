import { ConfigService } from '@nestjs/config';
import type { PinoLogger } from 'nestjs-pino';
import { ErrorReporterService } from '../../src/services/error-reporter.service';
import { validateEnvironment } from '../../src/config/environment';

describe('Error reporter', () => {
  const logger = { error: jest.fn(), warn: jest.fn() };
  afterEach(() => jest.restoreAllMocks());
  it('logs allowlisted metadata only and sends nothing without DSN', () => {
    const fetcher = jest.spyOn(globalThis, 'fetch');
    const reporter = new ErrorReporterService(
      new ConfigService({}),
      logger as unknown as PinoLogger,
    );
    reporter.report({
      requestId: 'r1',
      route: '/children/:id',
      status: 500,
      secret: 'private',
    } as Parameters<typeof reporter.report>[0]);
    expect(logger.error).toHaveBeenCalledWith(
      { requestId: 'r1', route: '/children/:id', status: 500 },
      'Request failed',
    );
    expect(fetcher).not.toHaveBeenCalled();
  });
  it('sends a metadata-only Sentry envelope when enabled', async () => {
    const fetcher = jest
      .spyOn(globalThis, 'fetch')
      .mockResolvedValue(new Response('', { status: 200 }));
    const reporter = new ErrorReporterService(
      new ConfigService({
        ERROR_REPORTING_DSN: 'https://public@example.com/sentry/42',
      }),
      logger as unknown as PinoLogger,
    );
    reporter.report({ requestId: 'r1', route: '/children/:id', status: 500 });
    await Promise.resolve();
    expect(fetcher).toHaveBeenCalledWith(
      'https://example.com/sentry/api/42/envelope/',
      expect.objectContaining({
        method: 'POST',
        signal: expect.any(AbortSignal),
      }),
    );
    const options = fetcher.mock.calls[0]?.[1];
    const body = typeof options?.body === 'string' ? options.body : '';
    expect(body).not.toContain('public');
    const event = JSON.parse(body.split('\n')[2] ?? '{}') as Record<
      string,
      unknown
    >;
    expect(event.tags).toEqual({
      requestId: 'r1',
      route: '/children/:id',
      status: 500,
    });
  });
  it('BF-20261028-001: job failures send allowlisted tags only', async () => {
    const fetcher = jest
      .spyOn(globalThis, 'fetch')
      .mockResolvedValue(new Response('', { status: 200 }));
    const reporter = new ErrorReporterService(
      new ConfigService({
        ERROR_REPORTING_DSN: 'https://public@example.com/42',
      }),
      logger as unknown as PinoLogger,
    );
    reporter.reportJob({
      job: 'media.process-asset',
      code: 'CHECKSUM_MISMATCH',
      attempt: 2,
      familyId: 'private',
    } as Parameters<typeof reporter.reportJob>[0]);
    await Promise.resolve();
    expect(logger.error).toHaveBeenCalledWith(
      { job: 'media.process-asset', code: 'CHECKSUM_MISMATCH', attempt: 2 },
      'Job failed',
    );
    const options = fetcher.mock.calls[0]?.[1];
    const body = typeof options?.body === 'string' ? options.body : '';
    expect(body).not.toContain('private');
    const event = JSON.parse(body.split('\n')[2] ?? '{}') as Record<
      string,
      unknown
    >;
    expect(event.message).toBe('Background job failed');
    expect(event.tags).toEqual({
      job: 'media.process-asset',
      code: 'CHECKSUM_MISMATCH',
      attempt: 2,
    });
  });
  it('rejects invalid observability configuration without echoing secrets', () => {
    const base = { DATABASE_URL: 'postgresql://localhost/baby_family_test' };
    expect(() =>
      validateEnvironment({ ...base, METRICS_TOKEN: 'short' }),
    ).toThrow('METRICS_TOKEN');
    expect(() =>
      validateEnvironment({ ...base, LOG_FORMAT: 'unknown' }),
    ).toThrow('LOG_FORMAT');
    expect(() =>
      validateEnvironment({
        ...base,
        ERROR_REPORTING_DSN: 'http://secret@example.com/1',
      }),
    ).toThrow('ERROR_REPORTING_DSN');
  });
});
