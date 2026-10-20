import { Inject, Injectable } from '@nestjs/common';
import type {
  CallHandler,
  ExecutionContext,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { REQUEST_LOCALE_SERVICE } from '../../interfaces/services/request-locale-service.interface';
import type { IRequestLocaleService } from '../../interfaces/services/request-locale-service.interface';
import { requestLocaleContext } from './request-locale';
import type { LocalizedRequest } from './request-locale';

@Injectable()
export class RequestLocaleInterceptor implements NestInterceptor {
  constructor(
    @Inject(REQUEST_LOCALE_SERVICE)
    private readonly locales: IRequestLocaleService,
  ) {}

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<unknown>> {
    const request = context.switchToHttp().getRequest<LocalizedRequest>();
    const locale = await this.locales.resolve(request);
    return new Observable((subscriber) =>
      requestLocaleContext.run(locale, () =>
        next.handle().subscribe(subscriber),
      ),
    );
  }
}
