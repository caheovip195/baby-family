import { solarToLunar } from './lunar-calendar';

export function completedPhotoMonths(born: Date, at: Date, lunar: boolean) {
  const dateParts = (date: Date) => ({
    day: date.getUTCDate(),
    month: date.getUTCMonth() + 1,
    year: date.getUTCFullYear(),
  });
  const b = lunar
    ? solarToLunar(
        born.getUTCDate(),
        born.getUTCMonth() + 1,
        born.getUTCFullYear(),
      )
    : dateParts(born);
  const a = lunar
    ? solarToLunar(at.getUTCDate(), at.getUTCMonth() + 1, at.getUTCFullYear())
    : dateParts(at);
  const elapsed = lunar
    ? Math.round(
        (at.getTime() -
          (a.day - 1) * 86400000 -
          (born.getTime() - (b.day - 1) * 86400000)) /
          (29.530588853 * 86400000),
      )
    : (a.year - b.year) * 12 + a.month - b.month;
  return (
    elapsed -
    (a.day <
    Math.min(
      b.day,
      lunar
        ? lunarMonthDays(at)
        : new Date(Date.UTC(a.year, a.month, 0)).getUTCDate(),
    )
      ? 1
      : 0)
  );
}

/** Find the end of the current Vietnamese lunar month, including leap months. */
function lunarMonthDays(at: Date): number {
  const current = solarToLunar(
    at.getUTCDate(),
    at.getUTCMonth() + 1,
    at.getUTCFullYear(),
  );
  let last = current.day;
  for (let step = 1; step <= 30; step++) {
    const next = new Date(at.getTime() + step * 86400000);
    const lunar = solarToLunar(
      next.getUTCDate(),
      next.getUTCMonth() + 1,
      next.getUTCFullYear(),
    );
    if (
      lunar.month !== current.month ||
      lunar.year !== current.year ||
      lunar.isLeap !== current.isLeap
    )
      break;
    last = lunar.day;
  }
  return last;
}
