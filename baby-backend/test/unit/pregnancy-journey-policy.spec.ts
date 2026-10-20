import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  pregnancyGestation,
  pregnancyLocale,
  encodeJourneyCursor,
  decodeJourneyCursor,
} from '../../src/config/pregnancy-journey-policy';

describe('pregnancyGestation', () => {
  const due = new Date('2026-10-19T00:00:00Z');
  it('uses family calendar dates across UTC midnight', () => {
    expect(
      pregnancyGestation(
        due,
        new Date('2026-10-18T17:01:00Z'),
        'Asia/Ho_Chi_Minh',
      ),
    ).toEqual({ currentWeek: 40, currentDay: 0, daysLeft: 0, trimester: 3 });
    expect(
      pregnancyGestation(
        due,
        new Date('2026-10-18T16:59:00Z'),
        'Asia/Ho_Chi_Minh',
      ),
    ).toEqual({ currentWeek: 39, currentDay: 6, daysLeft: 1, trimester: 3 });
  });
  it('handles early gestation, conception clamp and overdue days', () => {
    expect(
      pregnancyGestation(due, new Date('2026-01-26T00:00:00Z'), 'UTC'),
    ).toEqual({ currentWeek: 2, currentDay: 0, daysLeft: 266, trimester: 1 });
    expect(
      pregnancyGestation(due, new Date('2025-01-01T00:00:00Z'), 'UTC'),
    ).toMatchObject({ currentWeek: 0, currentDay: 0, trimester: 1 });
    expect(
      pregnancyGestation(due, new Date('2026-11-03T00:00:00Z'), 'UTC'),
    ).toEqual({ currentWeek: 42, currentDay: 1, daysLeft: -15, trimester: 3 });
  });
  it('uses calendar days through daylight-saving transitions', () => {
    expect(
      pregnancyGestation(
        new Date('2026-03-09T00:00:00Z'),
        new Date('2026-03-08T08:00:00Z'),
        'America/New_York',
      ),
    ).toMatchObject({ daysLeft: 1, currentWeek: 39, currentDay: 6 });
  });
});

describe('pregnancyLocale', () => {
  it('negotiates supported languages by quality and ignores disabled ranges', () => {
    expect(pregnancyLocale('en;q=0.2,vi;q=0.9', 'en')).toBe('vi');
    expect(pregnancyLocale('en;q=0,vi;q=0.8', 'en')).toBe('vi');
    expect(pregnancyLocale('en-US,en;q=0.8', 'vi')).toBe('en');
  });
  it('falls back to the supported user locale, then Vietnamese', () => {
    expect(pregnancyLocale(undefined, 'en-US')).toBe('en');
    expect(pregnancyLocale('fr-FR', 'en')).toBe('en');
    expect(pregnancyLocale('fr-FR', 'fr')).toBe('vi');
  });
});

describe('pregnancy memory cursor', () => {
  const pregnancy = '1321530e-875f-4a5f-bce8-60547334d837';
  const row = {
    id: 'bc5c109c-8a5f-4f10-b64d-51b18b84f693',
    createdAt: new Date('2026-10-19T00:00:00Z'),
  };
  it('roundtrips and binds pages to their pregnancy and memory kind', () => {
    const model = {
      ...row,
      title: 'Synthetic model field',
      body: 'x'.repeat(1000),
    };
    const cursor = encodeJourneyCursor(model, pregnancy, 'BUMP');
    expect(cursor.length).toBeLessThan(500);
    expect(
      JSON.parse(Buffer.from(cursor, 'base64url').toString('utf8')),
    ).not.toHaveProperty('body');
    expect(decodeJourneyCursor(cursor, pregnancy, 'BUMP')).toEqual(row);
    expect(() =>
      decodeJourneyCursor(cursor, pregnancy, 'ULTRASOUND'),
    ).toThrow();
    expect(() =>
      decodeJourneyCursor(cursor, 'another-pregnancy', 'BUMP'),
    ).toThrow();
  });
  it('rejects malformed cursors', () => {
    for (const cursor of [
      'bad',
      Buffer.from('{}').toString('base64url'),
      Buffer.from(
        JSON.stringify({
          ...row,
          id: '-'.repeat(36),
          pregnancyId: pregnancy,
          kind: 'BUMP',
        }),
      ).toString('base64url'),
    ])
      expect(() => decodeJourneyCursor(cursor, pregnancy, 'BUMP')).toThrow();
  });
});

describe('versioned pregnancy week catalog', () => {
  it('covers every week 4–42 exactly once for Vietnamese and English', () => {
    const rows = JSON.parse(
      readFileSync(
        resolve(process.cwd(), 'prisma/seeds/pregnancy-weeks.json'),
        'utf8',
      ),
    ) as {
      type: string;
      code: string;
      locale: string;
      version: number;
      data: { emoji: string; lengthCm: number; label: string; tip: string };
    }[];
    expect(rows).toHaveLength(78);
    const keys = new Set(rows.map((row) => `${row.code}/${row.locale}`));
    expect(keys.size).toBe(78);
    for (let week = 4; week <= 42; week++)
      for (const locale of ['vi', 'en'])
        expect(keys.has(`W${String(week).padStart(2, '0')}/${locale}`)).toBe(
          true,
        );
    for (const row of rows) {
      expect(row.type).toBe('PREGNANCY_WEEK');
      expect(row.version).toBeGreaterThanOrEqual(1);
      expect(row.data.emoji.length).toBeGreaterThan(0);
      expect(row.data.label.length).toBeGreaterThan(0);
      expect(row.data.lengthCm).toBeGreaterThanOrEqual(0);
      expect(row.data.tip.length).toBeGreaterThan(0);
      expect(row.data.tip.length).toBeLessThanOrEqual(200);
    }
  });
});
