import { ConfigService } from '@nestjs/config';
import { ObservabilityService } from '../../src/services/observability.service';
import { ObservabilitySnapshot } from '../../src/models/observability-snapshot.model';

describe('ObservabilityService', () => {
  const getSnapshot = jest
    .fn()
    .mockResolvedValue(new ObservabilitySnapshot(2, 3, 4, 5));
  let service: ObservabilityService;
  beforeEach(() => {
    service = new ObservabilityService(
      new ConfigService({ METRICS_TOKEN: 'test' }),
      { getSnapshot },
    );
  });

  it('emits cumulative histogram buckets in seconds and rolling-window gauges', async () => {
    service.recordRequest('/memories/:id', 200, 100);
    service.recordRequest('/memories/:id', 200, 200);
    const before = Date.now();
    const metrics = await service.renderMetrics('Bearer test');
    expect(metrics).toContain(
      'baby_family_http_request_duration_seconds_bucket{route="/memories/:id",status="200",le="0.1"} 1',
    );
    expect(metrics).toContain(
      'baby_family_http_request_duration_seconds_bucket{route="/memories/:id",status="200",le="0.25"} 2',
    );
    expect(metrics).toContain(
      'baby_family_http_request_duration_seconds_bucket{route="/memories/:id",status="200",le="+Inf"} 2',
    );
    expect(metrics).toContain('baby_family_jobs_failed_recent 2');
    expect(getSnapshot).toHaveBeenLastCalledWith(expect.any(Date));
    const since = (getSnapshot.mock.calls.at(-1) as [Date])[0].getTime();
    expect(since).toBeGreaterThanOrEqual(before - 900000);
    expect(since).toBeLessThanOrEqual(Date.now() - 900000);
  });

  it('rejects invalid observations and removes unsafe route input', async () => {
    service.recordRequest('/memories?token=secret', 400, 10);
    service.recordRequest('/bad', 700, 10);
    service.recordRequest('/bad', 200, Number.NaN);
    service.recordRequest('/bad', 200, -1);
    const metrics = await service.renderMetrics('Bearer test');
    expect(metrics).toContain('route="unmatched",status="400"');
    expect(metrics).not.toContain('secret');
    expect(metrics).not.toContain('/bad');
  });

  it('bounds cardinality even when callers supply excessive router templates', async () => {
    for (let i = 0; i < 600; i++)
      service.recordRequest(`/route${i}/:id`, 200, 10);
    const metrics = await service.renderMetrics('Bearer test');
    expect(metrics.match(/^baby_family_http_requests_total\{/gm)).toHaveLength(
      500,
    );
  });
});
