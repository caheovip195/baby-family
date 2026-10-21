import { Global, Inject, Injectable, Module } from '@nestjs/common';
import type {
  MiddlewareConsumer,
  NestMiddleware,
  NestModule,
} from '@nestjs/common';
import type { Request, Response, NextFunction } from 'express';
import { DatabaseModule } from '../../database/database.module';
import { MetricsController } from '../../controllers/metrics.controller';
import { OBSERVABILITY_SERVICE } from '../../interfaces/services/observability-service.interface';
import type { IObservabilityService } from '../../interfaces/services/observability-service.interface';
import { OBSERVABILITY_REPOSITORY } from '../../interfaces/repositories/observability-repository.interface';
import { ERROR_REPORTER } from '../../interfaces/services/error-reporter.interface';
import { ObservabilityService } from '../../services/observability.service';
import { ObservabilityRepository } from '../../repositories/observability.repository';
import { ErrorReporterService } from '../../services/error-reporter.service';
import { safeRoute } from './http-logging';

@Injectable()
export class RequestMetricsMiddleware implements NestMiddleware {
  constructor(
    @Inject(OBSERVABILITY_SERVICE)
    private readonly metrics: IObservabilityService,
  ) {}
  use(request: Request, response: Response, next: NextFunction): void {
    const start = performance.now();
    response.once('finish', () =>
      this.metrics.recordRequest(
        safeRoute(request),
        response.statusCode,
        performance.now() - start,
      ),
    );
    next();
  }
}
@Global()
@Module({
  imports: [DatabaseModule],
  controllers: [MetricsController],
  providers: [
    { provide: OBSERVABILITY_REPOSITORY, useClass: ObservabilityRepository },
    { provide: OBSERVABILITY_SERVICE, useClass: ObservabilityService },
    { provide: ERROR_REPORTER, useClass: ErrorReporterService },
    RequestMetricsMiddleware,
  ],
  exports: [OBSERVABILITY_SERVICE, ERROR_REPORTER],
})
export class ObservabilityModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(RequestMetricsMiddleware).forRoutes('{*path}');
  }
}
