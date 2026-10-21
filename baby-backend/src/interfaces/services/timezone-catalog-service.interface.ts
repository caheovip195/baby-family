import type { TimezoneCatalogResponseDto } from '../../dto/catalog/timezone-catalog.dto';

export const TIMEZONE_CATALOG_SERVICE = Symbol('TIMEZONE_CATALOG_SERVICE');
export interface ITimezoneCatalogService {
  list(locale?: 'vi' | 'en'): TimezoneCatalogResponseDto;
}
