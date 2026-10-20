import type {
  LocalizedRequest,
  SupportedLocale,
} from '../../common/i18n/request-locale';

export const REQUEST_LOCALE_SERVICE = Symbol('REQUEST_LOCALE_SERVICE');
export interface IRequestLocaleService {
  resolve(request: LocalizedRequest): Promise<SupportedLocale>;
}
