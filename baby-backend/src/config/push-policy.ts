import { NOTIFICATION_POLICY } from './notification-policy';

/** Change the version when delivery/retry defaults change. */
export const PUSH_POLICY = {
  everyMs: 60_000,
  batchSize: 100,
  maxAttempts: 3,
  backoffMs: 60_000,
  ...NOTIFICATION_POLICY,
  version: 1,
};

export function pushTimezone(value: string): string {
  try {
    new Intl.DateTimeFormat('en', { timeZone: value }).format();
    return value;
  } catch {
    return PUSH_POLICY.defaultTimezone;
  }
}

/** Walk actual instants so DST gaps/folds do not assume a 24-hour day. */
export function afterPushQuiet(
  now: Date,
  zone: string,
  start: string,
  end: string,
): Date {
  const minutes = (v: string) =>
    Number(v.slice(0, 2)) * 60 + Number(v.slice(3, 5));
  const a = minutes(start),
    b = minutes(end);
  if (a === b) return now;
  const format = new Intl.DateTimeFormat('en-GB', {
    timeZone: pushTimezone(zone),
    hour: '2-digit',
    minute: '2-digit',
    hourCycle: 'h23',
  });
  const quiet = (d: Date) => {
    const t = minutes(format.format(d));
    return a > b ? t >= a || t < b : t >= a && t < b;
  };
  if (!quiet(now)) return now;
  for (
    let t = Math.floor(now.getTime() / 60000) * 60000 + 60000;
    t < now.getTime() + 27 * 3600000;
    t += 60000
  ) {
    const candidate = new Date(t);
    if (!quiet(candidate)) return candidate;
  }
  throw new Error('Invalid quiet hours.');
}
