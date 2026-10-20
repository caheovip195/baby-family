import { ValidationError } from '../common/errors/domain.error';
export const PREGNANCY_JOURNEY_POLICY = {
  minWeek: 4,
  maxWeek: 42,
  defaultLimit: 20,
  maxLimit: 100,
} as const;
const dayMs = 86400000;
export function pregnancyGestation(dueDate: Date, at: Date, timezone: string) {
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(at);
  const part = (key: string) =>
    Number(parts.find((p) => p.type === key)!.value);
  const localDay = Date.UTC(part('year'), part('month') - 1, part('day'));
  const daysLeft = Math.round(
    (Date.UTC(
      dueDate.getUTCFullYear(),
      dueDate.getUTCMonth(),
      dueDate.getUTCDate(),
    ) -
      localDay) /
      dayMs,
  );
  const elapsed = Math.max(0, 280 - daysLeft);
  const currentWeek = Math.floor(elapsed / 7);
  return {
    currentWeek,
    currentDay: elapsed % 7,
    daysLeft,
    trimester: currentWeek < 14 ? 1 : currentWeek < 28 ? 2 : 3,
  };
}
/** Prefer supported Accept-Language ranges by quality; otherwise user locale, then vi. */
export function pregnancyLocale(
  header: string | undefined,
  userLocale: string,
): 'vi' | 'en' {
  const candidates = (header ?? '')
    .split(',')
    .map((range, index) => {
      const [language = '', ...params] = range.trim().split(';');
      const quality = params.find((p) => p.trim().startsWith('q='));
      return {
        language: language.toLowerCase().split('-')[0],
        q: quality ? Number(quality.trim().slice(2)) : 1,
        index,
      };
    })
    .filter((x) => Number.isFinite(x.q) && x.q > 0 && x.q <= 1)
    .sort((a, b) => b.q - a.q || a.index - b.index);
  for (const { language } of candidates)
    if (language === 'vi' || language === 'en') return language;
  return userLocale.toLowerCase().split('-')[0] === 'en' ? 'en' : 'vi';
}
export interface JourneyCursor {
  id: string;
  createdAt: Date;
}
export function decodeJourneyCursor(
  value: string,
  pregnancyId: string,
  kind: string,
): JourneyCursor {
  try {
    const raw: unknown = JSON.parse(
      Buffer.from(value, 'base64url').toString('utf8'),
    );
    if (!raw || typeof raw !== 'object') throw new Error();
    const x = raw as Record<string, unknown>;
    if (
      x.pregnancyId !== pregnancyId ||
      x.kind !== kind ||
      typeof x.id !== 'string' ||
      !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
        x.id,
      ) ||
      typeof x.createdAt !== 'string' ||
      !Number.isFinite(Date.parse(x.createdAt))
    )
      throw new Error();
    return { id: x.id, createdAt: new Date(x.createdAt) };
  } catch {
    throw new ValidationError('Invalid pregnancy memory cursor.');
  }
}
export function encodeJourneyCursor(
  cursor: JourneyCursor,
  pregnancyId: string,
  kind: string,
): string {
  return Buffer.from(
    JSON.stringify({
      id: cursor.id,
      createdAt: cursor.createdAt,
      pregnancyId,
      kind,
    }),
  ).toString('base64url');
}
