import { AsyncLocalStorage } from 'node:async_hooks';
import type { AuthenticatedRequest } from '../auth/current-actor.decorator';

export type SupportedLocale = 'vi' | 'en';
export const REQUEST_LOCALE = Symbol('REQUEST_LOCALE');
export type LocalizedRequest = AuthenticatedRequest & {
  [REQUEST_LOCALE]?: SupportedLocale;
};

/** Per-request storage; never reuse one caller's language for notification recipients. */
export const requestLocaleContext = new AsyncLocalStorage<SupportedLocale>();

export function supportedLocale(
  value: string | undefined,
): SupportedLocale | undefined {
  const language = value?.trim().toLowerCase().split('-')[0];
  return language === 'vi' || language === 'en' ? language : undefined;
}

/** Respect preference weights, regional tags and q=0 exclusions. */
export function acceptLanguageLocale(
  header: string | undefined,
): SupportedLocale | undefined {
  if (!header || header.length > 4096) return undefined;
  return header
    .split(',')
    .map((entry, index) => {
      const [tag, ...parameters] = entry.trim().split(';');
      const quality = parameters.find((parameter) =>
        parameter.trim().startsWith('q='),
      );
      const raw = quality?.trim().slice(2);
      const weight =
        raw === undefined
          ? 1
          : /^(?:0(?:\.\d{0,3})?|1(?:\.0{0,3})?)$/.test(raw)
            ? Number(raw)
            : 0;
      return { locale: supportedLocale(tag), weight, index };
    })
    .filter((entry) => entry.locale !== undefined && entry.weight > 0)
    .sort(
      (left, right) => right.weight - left.weight || left.index - right.index,
    )[0]?.locale;
}
