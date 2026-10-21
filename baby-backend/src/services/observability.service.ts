import { timingSafeEqual, createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { ConfigService } from '@nestjs/config';
import { OBSERVABILITY_REPOSITORY } from '../interfaces/repositories/observability-repository.interface';
import type { IObservabilityRepository } from '../interfaces/repositories/observability-repository.interface';
import type { IObservabilityService } from '../interfaces/services/observability-service.interface';

const BUCKETS_SECONDS = [
  0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10,
];
const MAX_SERIES = 500;
const WINDOW_SECONDS = 900;

type RequestSeries = {
  route: string;
  status: number;
  count: number;
  sum: number;
  buckets: number[];
};

@Injectable()
export class ObservabilityService implements IObservabilityService {
  private readonly requests = new Map<string, RequestSeries>();

  constructor(
    private readonly config: ConfigService,
    @Inject(OBSERVABILITY_REPOSITORY)
    private readonly repository: IObservabilityRepository,
  ) {}

  recordRequest(route: string, status: number, durationMs: number): void {
    if (!Number.isInteger(status) || status < 100 || status > 599) return;
    if (!Number.isFinite(durationMs) || durationMs < 0) return;
    // Only router templates are accepted by contract; URL/query/body values must
    // never reach this API. Limit series to bound memory even with dynamic routes.
    const safeRoute =
      route.length <= 200 && /^\/[a-zA-Z0-9_/:.*{}-]*$/.test(route)
        ? route
        : 'unmatched';
    const key = `${safeRoute}:${status}`;
    let series = this.requests.get(key);
    if (!series) {
      if (this.requests.size >= MAX_SERIES) return;
      series = {
        route: safeRoute,
        status,
        count: 0,
        sum: 0,
        buckets: BUCKETS_SECONDS.map(() => 0),
      };
      this.requests.set(key, series);
    }
    const seconds = durationMs / 1000;
    series.count++;
    series.sum += seconds;
    BUCKETS_SECONDS.forEach((upperBound, index) => {
      if (seconds <= upperBound) series.buckets[index]!++;
    });
  }

  async renderMetrics(authorization?: string): Promise<string> {
    const token = this.config.get<string>('METRICS_TOKEN');
    if (!token) {
      throw new DomainError('Not found.', 'METRICS_DISABLED', 404);
    }
    const hash = (value: string) => createHash('sha256').update(value).digest();
    if (!timingSafeEqual(hash(authorization ?? ''), hash(`Bearer ${token}`))) {
      throw new DomainError(
        'Invalid metrics credentials.',
        'METRICS_UNAUTHORIZED',
        401,
      );
    }
    const snapshot = await this.repository
      .getSnapshot(new Date(Date.now() - WINDOW_SECONDS * 1000))
      .catch(() => {
        throw new DomainError(
          'Metrics storage unavailable.',
          'METRICS_UNAVAILABLE',
          503,
        );
      });
    const lines = [
      '# HELP baby_family_http_requests_total Completed HTTP requests in this process.',
      '# TYPE baby_family_http_requests_total counter',
      '# HELP baby_family_http_request_duration_seconds HTTP request duration in seconds.',
      '# TYPE baby_family_http_request_duration_seconds histogram',
    ];
    for (const series of this.requests.values()) {
      const labels = `route="${series.route}",status="${series.status}"`;
      lines.push(`baby_family_http_requests_total{${labels}} ${series.count}`);
      BUCKETS_SECONDS.forEach((upperBound, index) => {
        lines.push(
          `baby_family_http_request_duration_seconds_bucket{${labels},le="${upperBound}"} ${series.buckets[index]}`,
        );
      });
      lines.push(
        `baby_family_http_request_duration_seconds_bucket{${labels},le="+Inf"} ${series.count}`,
        `baby_family_http_request_duration_seconds_count{${labels}} ${series.count}`,
        `baby_family_http_request_duration_seconds_sum{${labels}} ${series.sum}`,
      );
    }
    for (const [name, help, value] of [
      [
        'jobs_failed_recent',
        'Active job runs failed in the last 900 seconds.',
        snapshot.failedJobs,
      ],
      [
        'job_attempts_timed_out_recent',
        'Active attempts timed out in the last 900 seconds.',
        snapshot.timedOutAttempts,
      ],
      [
        'jobs_backlog',
        'Active PENDING or RETRY_WAIT job runs including delayed retries.',
        snapshot.jobBacklog,
      ],
      [
        'outbox_backlog',
        'Active unpublished outbox events including delayed events.',
        snapshot.outboxBacklog,
      ],
    ] as const) {
      lines.push(
        `# HELP baby_family_${name} ${help}`,
        `# TYPE baby_family_${name} gauge`,
        `baby_family_${name} ${value}`,
      );
    }
    return `${lines.join('\n')}\n`;
  }
}
