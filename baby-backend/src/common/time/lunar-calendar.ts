/**
 * Vietnamese Lunar Calendar pure helper based on astronomical algorithms (Hồ Ngọc Đức).
 * Supports conversion between Solar (Gregorian) and Lunar calendars (UTC+7 / Asia/Ho_Chi_Minh).
 * No external npm packages required.
 */

export interface LunarDate {
  day: number;
  month: number;
  year: number;
  isLeap: boolean;
}

export interface SolarDate {
  day: number;
  month: number;
  year: number;
}

export function jdFromDate(dd: number, mm: number, yyyy: number): number {
  const a = Math.floor((14 - mm) / 12);
  const y = yyyy + 4800 - a;
  const m = mm + 12 * a - 3;
  let jd =
    dd +
    Math.floor((153 * m + 2) / 5) +
    365 * y +
    Math.floor(y / 4) -
    Math.floor(y / 100) +
    Math.floor(y / 400) -
    32045;
  if (jd < 2299161) {
    jd =
      dd + Math.floor((153 * m + 2) / 5) + 365 * y + Math.floor(y / 4) - 32083;
  }
  return jd;
}

export function jdToDate(jd: number): SolarDate {
  let a: number;
  let b: number;
  let c: number;
  if (jd > 2299160) {
    a = jd + 32044;
    b = Math.floor((4 * a + 3) / 146097);
    c = a - Math.floor((146097 * b) / 4);
  } else {
    b = 0;
    c = jd + 32082;
  }
  const d = Math.floor((4 * c + 3) / 1461);
  const e = c - Math.floor((1461 * d) / 4);
  const m = Math.floor((5 * e + 2) / 153);
  const day = e - Math.floor((153 * m + 2) / 5) + 1;
  const month = m + 3 - 12 * Math.floor(m / 10);
  const year = 100 * b + d - 4800 + Math.floor(m / 10);
  return { day, month, year };
}

export function getNewMoonDay(k: number, timeZone = 7): number {
  const T = k / 1236.85;
  const T2 = T * T;
  const T3 = T2 * T;
  const dr = Math.PI / 180;
  let Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
  Jd1 += 0.00033 * Math.sin((166.56 + 132.87 * T - 0.009173 * T2) * dr);
  const M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3;
  const Mprime = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3;
  const F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3;
  let C1 =
    (0.1734 - 0.000393 * T) * Math.sin(M * dr) + 0.0021 * Math.sin(2 * dr * M);
  C1 -= 0.4068 * Math.sin(Mprime * dr) + 0.0161 * Math.sin(2 * dr * Mprime);
  C1 -= 0.0004 * Math.sin(3 * dr * Mprime);
  C1 += 0.0104 * Math.sin(2 * dr * F) - 0.0051 * Math.sin((M + Mprime) * dr);
  C1 -=
    0.0074 * Math.sin((M - Mprime) * dr) + 0.0004 * Math.sin((2 * F + M) * dr);
  C1 -=
    0.0004 * Math.sin((2 * F - M) * dr) -
    0.0006 * Math.sin((2 * F + Mprime) * dr);
  C1 +=
    0.001 * Math.sin((2 * F - Mprime) * dr) +
    0.0005 * Math.sin((2 * Mprime + M) * dr);
  const Jd = Jd1 + C1;
  return Math.floor(Jd + 0.5 + timeZone / 24);
}

export function getSunLongitude(dayNumber: number, timeZone = 7): number {
  const T = (dayNumber - 0.5 - timeZone / 24 - 2451545.0) / 36525;
  const T2 = T * T;
  const dr = Math.PI / 180;
  const L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2;
  const M = 357.5291 + 35999.0503 * T - 0.0001559 * T2 - 0.00000048 * T * T2;
  const C =
    (1.9146 - 0.004817 * T - 0.000014 * T2) * Math.sin(M * dr) +
    (0.019993 - 0.000101 * T) * Math.sin(2 * M * dr) +
    0.00029 * Math.sin(3 * M * dr);
  let theta = L0 + C;
  theta = theta * dr;
  theta = theta - Math.PI * 2 * Math.floor(theta / (Math.PI * 2));
  return Math.floor((theta / Math.PI) * 6);
}

export function getLunarMonth11(yy: number, timeZone = 7): number {
  const off = jdFromDate(31, 12, yy) - 2415021;
  const k = Math.floor(off / 29.530588853);
  let nm = getNewMoonDay(k, timeZone);
  const sunLong = getSunLongitude(nm, timeZone);
  if (sunLong >= 9) {
    nm = getNewMoonDay(k - 1, timeZone);
  }
  return nm;
}

export function getLeapMonthOffset(a11: number, timeZone = 7): number {
  const k = Math.floor((a11 - 2415021.076998695) / 29.530588853 + 0.5);
  let last: number;
  let i = 1;
  let arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  do {
    last = arc;
    i++;
    arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  } while (arc !== last && i < 14);
  return i - 1;
}

export function solarToLunar(
  dd: number,
  mm: number,
  yyyy: number,
  timeZone = 7,
): LunarDate {
  const dayNumber = jdFromDate(dd, mm, yyyy);
  const k = Math.floor((dayNumber - 2415021.076998695) / 29.530588853);
  let monthStart = getNewMoonDay(k + 1, timeZone);
  if (monthStart > dayNumber) {
    monthStart = getNewMoonDay(k, timeZone);
  }
  let a11 = getLunarMonth11(yyyy, timeZone);
  let b11 = a11;
  let lunarYear: number;
  if (a11 >= monthStart) {
    lunarYear = yyyy;
    a11 = getLunarMonth11(yyyy - 1, timeZone);
  } else {
    lunarYear = yyyy + 1;
    b11 = getLunarMonth11(yyyy + 1, timeZone);
  }
  const lunarDay = dayNumber - monthStart + 1;
  const diff = Math.floor((monthStart - a11) / 29);
  let isLeap = false;
  let lunarMonth = diff + 11;
  if (b11 - a11 > 365) {
    const leapMonthDiff = getLeapMonthOffset(a11, timeZone);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff === leapMonthDiff) {
        isLeap = true;
      }
    }
  }
  if (lunarMonth > 12) {
    lunarMonth = lunarMonth - 12;
  }
  if (lunarMonth >= 11 && diff < 4) {
    lunarYear -= 1;
  }
  return { day: lunarDay, month: lunarMonth, year: lunarYear, isLeap };
}

export function lunarToSolar(
  lunarDay: number,
  lunarMonth: number,
  lunarYear: number,
  isLeap = false,
  timeZone = 7,
): SolarDate {
  // Tháng 11 âm của năm trước (a11) và của năm này (b11), theo Hồ Ngọc Đức.
  const a11 = getLunarMonth11(
    lunarMonth < 11 ? lunarYear - 1 : lunarYear,
    timeZone,
  );
  const b11 = getLunarMonth11(
    lunarMonth < 11 ? lunarYear : lunarYear + 1,
    timeZone,
  );
  const k = Math.floor((a11 - 2415021.076998695) / 29.530588853 + 0.5);
  let offset = lunarMonth - 11;
  if (lunarMonth < 11) {
    offset = lunarMonth + 1;
  }
  if (b11 - a11 > 365) {
    const leapOff = getLeapMonthOffset(a11, timeZone);
    let leapMonth = leapOff - 2;
    if (leapMonth < 0) leapMonth += 12;
    if (isLeap && lunarMonth !== leapMonth) {
      // Requested month is not leap in this year, fall back to normal month
    } else if (isLeap || offset >= leapOff) {
      offset += 1;
    }
  }
  const monthStart = getNewMoonDay(k + offset, timeZone);
  return jdToDate(monthStart + lunarDay - 1);
}

export function toIsoDateString(
  year: number,
  month: number,
  day: number,
): string {
  return `${year.toString().padStart(4, '0')}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
}

export function parseIsoDate(iso: string): SolarDate {
  const parts = iso.split('-').map(Number);
  return {
    year: parts[0] ?? 0,
    month: parts[1] ?? 1,
    day: parts[2] ?? 1,
  };
}

/**
 * Finds occurrences of a recurring yearly lunar date within a given Gregorian date range.
 * Range is at most 62 days, so checking the candidate lunar years covering rangeStart and rangeEnd is sufficient.
 */
export function findLunarOccurrencesInRange(
  lunarDay: number,
  lunarMonth: number,
  isLeap: boolean | null,
  fromIso: string,
  toIso: string,
  timeZone = 7,
): Array<{ date: string; lunarYear: number }> {
  const from = parseIsoDate(fromIso);
  const to = parseIsoDate(toIso);
  const occurrences: Array<{ date: string; lunarYear: number }> = [];

  const startYear = from.year - 1;
  const endYear = to.year + 1;

  for (let y = startYear; y <= endYear; y++) {
    try {
      const solar = lunarToSolar(
        lunarDay,
        lunarMonth,
        y,
        isLeap ?? false,
        timeZone,
      );
      const iso = toIsoDateString(solar.year, solar.month, solar.day);
      if (iso >= fromIso && iso <= toIso) {
        occurrences.push({ date: iso, lunarYear: y });
      }
    } catch {
      // Ignore conversion errors for edge dates
    }
  }

  return occurrences;
}

/**
 * Finds occurrences of a yearly recurring Gregorian date within a date range.
 */
export function findGregorianOccurrencesInRange(
  month: number,
  day: number,
  fromIso: string,
  toIso: string,
): string[] {
  const from = parseIsoDate(fromIso);
  const to = parseIsoDate(toIso);
  const occurrences: string[] = [];

  for (let y = from.year; y <= to.year; y++) {
    let d = day;
    if (month === 2 && day === 29) {
      const isLeapYear = (y % 4 === 0 && y % 100 !== 0) || y % 400 === 0;
      if (!isLeapYear) d = 28;
    }
    const iso = toIsoDateString(y, month, d);
    if (iso >= fromIso && iso <= toIso) {
      occurrences.push(iso);
    }
  }

  return occurrences;
}
