import { Injectable } from '@nestjs/common';
import { ValidationError } from '../common/errors/domain.error';
import { TIMEZONE_CATALOG, TIMEZONE_IDS } from '../config/timezone-catalog';
import type { TimezoneCatalogResponseDto } from '../dto/catalog/timezone-catalog.dto';
import type { ITimezoneCatalogService } from '../interfaces/services/timezone-catalog-service.interface';

@Injectable()
export class TimezoneCatalogService implements ITimezoneCatalogService {
  list(locale: 'vi' | 'en' = 'vi'): TimezoneCatalogResponseDto {
    if (!TIMEZONE_CATALOG.locales.includes(locale))
      throw new ValidationError('Locale must be vi or en.');
    const now = new Date();
    return {
      version: TIMEZONE_CATALOG.version,
      items: TIMEZONE_IDS.map((id) => {
        const parts = new Intl.DateTimeFormat(locale, {
          timeZone: id,
          timeZoneName: 'longGeneric',
        }).formatToParts(now);
        const name = parts.find((part) => part.type === 'timeZoneName')!.value;
        const preferred = TIMEZONE_CATALOG.preferred.find(
          (zone) => zone.id === id,
        );
        const offset = new Intl.DateTimeFormat('en', {
          timeZone: id,
          timeZoneName: 'longOffset',
        })
          .formatToParts(now)
          .find((part) => part.type === 'timeZoneName')!.value;
        const match = /^GMT([+-])(\d{2}):(\d{2})$/.exec(offset);
        const offsetMinutes = match
          ? (Number(match[2]) * 60 + Number(match[3])) *
            (match[1] === '-' ? -1 : 1)
          : 0;
        return {
          id,
          label: `${preferred?.[locale] ?? id} — ${name}`,
          offsetMinutes,
        };
      }),
    };
  }
}
