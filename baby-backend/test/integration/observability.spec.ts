import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpAdapterHost, Reflector } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import { LoggerModule, PinoLogger } from 'nestjs-pino';
import { RequestMetricsMiddleware } from '../../src/common/observability/observability.module';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { configureApp } from '../../src/bootstrap';
import { MetricsController } from '../../src/controllers/metrics.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { OBSERVABILITY_REPOSITORY } from '../../src/interfaces/repositories/observability-repository.interface';
import { OBSERVABILITY_SERVICE } from '../../src/interfaces/services/observability-service.interface';
import { ObservabilityRepository } from '../../src/repositories/observability.repository';
import { ObservabilityService } from '../../src/services/observability.service';

describe('Metrics HTTP endpoint + PostgreSQL (read-only)', () => {
  let app: INestApplication<Server>;
  const token = 'observability-spec-token';

  beforeAll(async () => {
    const databaseUrl = process.env.DATABASE_URL ?? '';
    if (new URL(databaseUrl).pathname !== '/baby_family_test') {
      throw new Error('Observability integration requires baby_family_test.');
    }
    const config = new ConfigService({
      DATABASE_URL: databaseUrl,
      DATABASE_POOL_SIZE: 2,
      CORS_ORIGINS: [],
      SWAGGER_ENABLED: false,
      METRICS_TOKEN: token,
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [MetricsController],
      providers: [
        { provide: ConfigService, useValue: config },
        PrismaService,
        RequestMetricsMiddleware,
        {
          provide: OBSERVABILITY_REPOSITORY,
          useClass: ObservabilityRepository,
        },
        { provide: OBSERVABILITY_SERVICE, useClass: ObservabilityService },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>({
      logger: false,
    });
    configureApp(app);
    const middleware = app.get(RequestMetricsMiddleware);
    app.use(middleware.use.bind(middleware));
    app.useGlobalInterceptors(new ResponseEnvelopeInterceptor(new Reflector()));
    app.useGlobalFilters(
      new HttpExceptionFilter(
        app.get(HttpAdapterHost),
        await app.resolve(PinoLogger),
      ),
    );
    await app.init();
  });

  afterAll(async () => {
    await app?.close();
  });

  it('requires Bearer credentials before querying the operational repository', async () => {
    const repository = app.get<ObservabilityRepository>(
      OBSERVABILITY_REPOSITORY,
    );
    const snapshot = jest.spyOn(repository, 'getSnapshot');
    for (const authorization of [
      '',
      'Bearer wrong',
      'Basic observability-spec-token',
    ]) {
      const result = await request(app.getHttpServer())
        .get('/metrics')
        .set('Authorization', authorization)
        .expect(401);
      expect(result.body).toMatchObject({
        error: { code: 'METRICS_UNAUTHORIZED' },
        path: '/metrics',
      });
    }
    expect(snapshot).not.toHaveBeenCalled();
    snapshot.mockRestore();
  });

  it('renders real PostgreSQL aggregates and raw Prometheus histogram text', async () => {
    const service = app.get<ObservabilityService>(OBSERVABILITY_SERVICE);
    service.recordRequest('/api/v1/children/:childId', 200, 100);
    const result = await request(app.getHttpServer())
      .get('/metrics')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);
    expect(result.headers['content-type']).toContain('text/plain;');
    expect(result.headers['content-type']).toContain('version=0.0.4');
    expect(result.headers['cache-control']).toBe('no-store');
    expect(result.text).toContain(
      'baby_family_http_requests_total{route="/api/v1/children/:childId",status="200"} 1',
    );
    for (const metric of [
      'jobs_failed_recent',
      'job_attempts_timed_out_recent',
      'jobs_backlog',
      'outbox_backlog',
    ]) {
      expect(result.text).toMatch(new RegExp(`baby_family_${metric} \\d+\\n`));
    }
    expect(result.text).toContain(
      'baby_family_http_requests_total{route="/metrics",status="401"} 3',
    );
    expect(result.text).not.toContain('observability-spec-token');
    expect(result.text).not.toContain('"data"');
  });

  it('returns 404 when metrics are disabled', async () => {
    app.get(ConfigService).set('METRICS_TOKEN', '');
    try {
      const response = await request(app.getHttpServer())
        .get('/metrics')
        .expect(404);
      expect(response.body).toMatchObject({
        error: { code: 'METRICS_DISABLED' },
        path: '/metrics',
      });
    } finally {
      app.get(ConfigService).set('METRICS_TOKEN', token);
    }
  });

  it('returns 503 without leaking database failures', async () => {
    const repository = app.get<ObservabilityRepository>(
      OBSERVABILITY_REPOSITORY,
    );
    const snapshot = jest
      .spyOn(repository, 'getSnapshot')
      .mockRejectedValueOnce(new Error('private database failure'));
    const response = await request(app.getHttpServer())
      .get('/metrics')
      .set('Authorization', `Bearer ${token}`)
      .expect(503);
    expect(response.body).toMatchObject({
      error: { code: 'METRICS_UNAVAILABLE' },
      path: '/metrics',
    });
    expect(response.text).not.toContain('private database failure');
    snapshot.mockRestore();
  });
});
