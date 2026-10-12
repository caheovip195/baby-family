import {
  ArgumentsHost,
  Catch,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import type { ExceptionFilter } from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import type { Request } from 'express';
import { PinoLogger } from 'nestjs-pino';
import { DomainError } from './domain.error';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  constructor(
    private readonly adapterHost: HttpAdapterHost,
    private readonly logger: PinoLogger,
  ) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const context = host.switchToHttp();
    const request = context.getRequest<Request & { id?: string }>();
    let status: number = HttpStatus.INTERNAL_SERVER_ERROR;
    let code = 'INTERNAL_SERVER_ERROR';
    let message = 'An unexpected error occurred.';
    let details: string[] | undefined;
    if (exception instanceof DomainError) {
      status = exception.statusCode;
      code = exception.code;
      message = exception.message;
    } else if (exception instanceof HttpException) {
      status = exception.getStatus();
      code = HttpStatus[status] ?? 'HTTP_ERROR';
      const response = exception.getResponse();
      if (typeof response === 'string') message = response;
      else if ('message' in response) {
        if (Array.isArray(response.message)) {
          details = response.message.filter(
            (item: unknown): item is string => typeof item === 'string',
          );
          message = 'Request validation failed.';
          code = 'VALIDATION_ERROR';
        } else if (typeof response.message === 'string')
          message = response.message;
      }
    }
    if (status >= 500)
      this.logger.error(
        { err: exception, requestId: request.id },
        'Request failed',
      );
    this.adapterHost.httpAdapter.reply(
      context.getResponse<unknown>(),
      {
        error: { code, message, ...(details ? { details } : {}) },
        requestId: request.id,
        path: request.path,
        timestamp: new Date().toISOString(),
      },
      status,
    );
  }
}
