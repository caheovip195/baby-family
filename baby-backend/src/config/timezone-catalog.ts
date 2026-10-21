/** Catalog v1: common target-market zones first, then the runtime IANA catalog.
 * Offsets and translated time-zone names come from ICU at request time (DST).
 */
export const TIMEZONE_CATALOG = {
  version: '1',
  locales: ['vi', 'en'],
  preferred: [
    { id: 'Asia/Ho_Chi_Minh', vi: 'Việt Nam', en: 'Vietnam' },
    { id: 'Asia/Bangkok', vi: 'Bangkok', en: 'Bangkok' },
    { id: 'Asia/Singapore', vi: 'Singapore', en: 'Singapore' },
    { id: 'Asia/Tokyo', vi: 'Tokyo', en: 'Tokyo' },
    { id: 'Asia/Seoul', vi: 'Seoul', en: 'Seoul' },
    { id: 'Asia/Shanghai', vi: 'Thượng Hải', en: 'Shanghai' },
    { id: 'Asia/Taipei', vi: 'Đài Bắc', en: 'Taipei' },
    { id: 'Australia/Sydney', vi: 'Sydney', en: 'Sydney' },
    { id: 'Europe/London', vi: 'Luân Đôn', en: 'London' },
    { id: 'Europe/Paris', vi: 'Paris', en: 'Paris' },
    { id: 'America/Los_Angeles', vi: 'Los Angeles', en: 'Los Angeles' },
    { id: 'America/New_York', vi: 'New York', en: 'New York' },
    { id: 'UTC', vi: 'Giờ quốc tế', en: 'Coordinated Universal Time' },
  ],
} as const;

export const TIMEZONE_IDS: readonly string[] = [
  ...new Set([
    ...TIMEZONE_CATALOG.preferred.map((zone) => zone.id),
    ...Intl.supportedValuesOf('timeZone'),
  ]),
];
const canonicalIds = new Set(
  TIMEZONE_IDS.map(
    (timeZone) =>
      new Intl.DateTimeFormat('en', { timeZone }).resolvedOptions().timeZone,
  ),
);

/** Accept IANA aliases for backwards compatibility, but never numeric offsets. */
export function isCatalogTimezone(value: unknown): value is string {
  if (typeof value !== 'string' || value.length > 64 || /^[+-]/.test(value))
    return false;
  try {
    // Any zone ICU knows (incl. Etc/GMT±N outside the listed catalog); bare
    // abbreviations such as EST are rejected by the Area/Location shape.
    const id = new Intl.DateTimeFormat('en', {
      timeZone: value,
    }).resolvedOptions().timeZone;
    return (
      (canonicalIds.has(id) || id.includes('/')) &&
      (value === 'UTC' || value.includes('/'))
    );
  } catch {
    return false;
  }
}
