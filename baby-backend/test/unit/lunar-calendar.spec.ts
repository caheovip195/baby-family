import {
  solarToLunar,
  lunarToSolar,
  findLunarOccurrencesInRange,
  findGregorianOccurrencesInRange,
  jdFromDate,
  jdToDate,
} from '../../src/common/time/lunar-calendar';

describe('Vietnamese Lunar Calendar Helper', () => {
  it('converts Julian Day Number to Date and back correctly', () => {
    const jd = jdFromDate(18, 10, 2026);
    const date = jdToDate(jd);
    expect(date).toEqual({ day: 18, month: 10, year: 2026 });
  });

  it('converts known Gregorian Tet and festival dates to Vietnamese Lunar dates', () => {
    // 2026-02-17 is Lunar 2026-01-01 (Mùng 1 Tết Bính Ngọ)
    const tet2026 = solarToLunar(17, 2, 2026);
    expect(tet2026.day).toBe(1);
    expect(tet2026.month).toBe(1);
    expect(tet2026.year).toBe(2026);
    expect(tet2026.isLeap).toBe(false);

    // 2025-01-29 is Lunar 2025-01-01 (Mùng 1 Tết Ất Tỵ)
    const tet2025 = solarToLunar(29, 1, 2025);
    expect(tet2025.day).toBe(1);
    expect(tet2025.month).toBe(1);
    expect(tet2025.year).toBe(2025);

    // 2024-02-10 is Lunar 2024-01-01 (Mùng 1 Tết Giáp Thìn)
    const tet2024 = solarToLunar(10, 2, 2024);
    expect(tet2024.day).toBe(1);
    expect(tet2024.month).toBe(1);
    expect(tet2024.year).toBe(2024);

    // 2026-09-25 is Lunar 2026-08-15 (Rằm Trung Thu 2026)
    const midAutumn2026 = solarToLunar(25, 9, 2026);
    expect(midAutumn2026.day).toBe(15);
    expect(midAutumn2026.month).toBe(8);
  });

  it('converts Lunar dates back to Gregorian dates correctly', () => {
    // Lunar 1/1/2026 -> 2026-02-17
    const solarTet2026 = lunarToSolar(1, 1, 2026);
    expect(solarTet2026).toEqual({ day: 17, month: 2, year: 2026 });

    // Lunar 15/8/2026 -> 2026-09-25
    const solarMidAutumn2026 = lunarToSolar(15, 8, 2026);
    expect(solarMidAutumn2026).toEqual({ day: 25, month: 9, year: 2026 });

    // Roundtrip test for 30 consecutive days in 2026
    for (let day = 1; day <= 28; day++) {
      const lunar = solarToLunar(day, 6, 2026);
      const solar = lunarToSolar(
        lunar.day,
        lunar.month,
        lunar.year,
        lunar.isLeap,
      );
      expect(solar).toEqual({ day, month: 6, year: 2026 });
    }
  });

  it('finds recurring lunar occurrences in a date range', () => {
    // Lunar 1/1 recurring: should find 2026-02-17 in Feb 2026
    const occurrences = findLunarOccurrencesInRange(
      1,
      1,
      false,
      '2026-02-01',
      '2026-02-28',
    );
    expect(occurrences).toEqual([{ date: '2026-02-17', lunarYear: 2026 }]);

    // Range outside occurrence returns empty
    const outside = findLunarOccurrencesInRange(
      1,
      1,
      false,
      '2026-03-01',
      '2026-03-31',
    );
    expect(outside).toEqual([]);
  });

  it('finds recurring Gregorian occurrences in a date range', () => {
    const birthdayOccurrences = findGregorianOccurrencesInRange(
      10,
      18,
      '2026-10-01',
      '2026-10-31',
    );
    expect(birthdayOccurrences).toEqual(['2026-10-18']);

    // Feb 29 on non-leap year maps to Feb 28
    const leapBirthday = findGregorianOccurrencesInRange(
      2,
      29,
      '2025-02-01',
      '2025-02-28',
    );
    expect(leapBirthday).toEqual(['2025-02-28']);
  });
});
