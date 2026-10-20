import { Inject, Injectable, Optional } from '@nestjs/common';
import { AUTH_PRINCIPAL } from '../common/auth/auth-principal';
import {
  acceptLanguageLocale,
  REQUEST_LOCALE,
  supportedLocale,
} from '../common/i18n/request-locale';
import type {
  LocalizedRequest,
  SupportedLocale,
} from '../common/i18n/request-locale';
import { USER_REPOSITORY } from '../interfaces/repositories/user-repository.interface';
import type { IUserRepository } from '../interfaces/repositories/user-repository.interface';
import type { IRequestLocaleService } from '../interfaces/services/request-locale-service.interface';

@Injectable()
export class RequestLocaleService implements IRequestLocaleService {
  constructor(
    @Optional()
    @Inject(USER_REPOSITORY)
    private readonly users?: IUserRepository,
  ) {}

  async resolve(request: LocalizedRequest): Promise<SupportedLocale> {
    const cached = request[REQUEST_LOCALE];
    if (cached) return cached;
    let locale = acceptLanguageLocale(request.headers['accept-language']);
    const actor = request[AUTH_PRINCIPAL];
    if (!locale && actor && this.users) {
      try {
        const user = await this.users.findByKey(
          { privileged: true },
          { id: actor.userId },
        );
        locale = supportedLocale(user?.locale);
      } catch {
        // Language resolution must not replace the original failure during an outage.
      }
    }
    request[REQUEST_LOCALE] = locale ?? 'vi';
    return request[REQUEST_LOCALE];
  }
}
