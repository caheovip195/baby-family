import { ERROR_REPORTER } from '../../interfaces/services/error-reporter.interface';
import type { IErrorReporter } from '../../interfaces/services/error-reporter.interface';
import { safeRoute } from '../observability/http-logging';
import {
  ArgumentsHost,
  Catch,
  HttpException,
  HttpStatus,
  Inject,
  Optional,
} from '@nestjs/common';
import type { ExceptionFilter } from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import type { Request } from 'express';
import { PinoLogger } from 'nestjs-pino';
import { DomainError } from './domain.error';
import { REQUEST_LOCALE_SERVICE } from '../../interfaces/services/request-locale-service.interface';
import type { IRequestLocaleService } from '../../interfaces/services/request-locale-service.interface';
import { acceptLanguageLocale, REQUEST_LOCALE } from '../i18n/request-locale';
import type { LocalizedRequest } from '../i18n/request-locale';
import { localizedErrorMessage } from '../i18n/error-message-catalog';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  constructor(
    private readonly adapterHost: HttpAdapterHost,
    private readonly logger: PinoLogger,
    @Optional()
    @Inject(REQUEST_LOCALE_SERVICE)
    private readonly locales?: IRequestLocaleService,
    @Optional()
    @Inject(ERROR_REPORTER)
    private readonly errorReporter?: IErrorReporter,
  ) {}

  async catch(exception: unknown, host: ArgumentsHost): Promise<void> {
    const context = host.switchToHttp();
    const request = context.getRequest<
      LocalizedRequest & Request & { id?: string }
    >();
    let status: number = HttpStatus.INTERNAL_SERVER_ERROR;
    let code = 'INTERNAL_SERVER_ERROR';
    let details: string[] | undefined;
    if (exception instanceof DomainError) {
      status = exception.statusCode;
      code = exception.code;
    } else if (exception instanceof HttpException) {
      status = exception.getStatus();
      code = HttpStatus[status] ?? 'HTTP_ERROR';
      const response = exception.getResponse();
      if (typeof response !== 'string' && 'message' in response) {
        if (Array.isArray(response.message)) {
          details = response.message.filter(
            (item: unknown): item is string => typeof item === 'string',
          );
          code = 'VALIDATION_ERROR';
        } else if (
          status >= 500 &&
          typeof response.message === 'string' &&
          response.message !== HttpStatus[status]
        ) {
          // Operational detail (e.g. readiness: which dependency is down) is
          // kept untranslated; `message` is the localized catalog text.
          details = [response.message];
        }
      }
    }
    if (status >= 500) {
      const metadata = {
        requestId: request.id,
        route: safeRoute(request),
        status,
      };
      if (this.errorReporter) this.errorReporter.report(metadata);
      else this.logger.error(metadata, 'Request failed');
    }
    const locale = this.locales
      ? await this.locales.resolve(request)
      : (request[REQUEST_LOCALE] ??
        acceptLanguageLocale(request.headers['accept-language']) ??
        'vi');
    const message = localizedErrorMessage(code, status, locale);
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
