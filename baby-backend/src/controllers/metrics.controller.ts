import { Controller, Get, Headers, Inject, Res } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import type { Response } from 'express';
import { RawResponse } from '../common/http/response-envelope.interceptor';
import { OBSERVABILITY_SERVICE } from '../interfaces/services/observability-service.interface';
import type { IObservabilityService } from '../interfaces/services/observability-service.interface';

@RawResponse()
@SkipThrottle()
@Controller('metrics')
export class MetricsController {
  constructor(
    @Inject(OBSERVABILITY_SERVICE)
    private readonly observability: IObservabilityService,
  ) {}

  @Get()
  async getMetrics(
    @Res({ passthrough: true }) response: Response,
    @Headers('authorization') authorization?: string,
  ): Promise<string> {
    response.setHeader('Cache-Control', 'no-store');
    const metrics = await this.observability.renderMetrics(authorization);
    response.setHeader(
      'Content-Type',
      'text/plain; version=0.0.4; charset=utf-8',
    );
    return metrics;
  }
}
