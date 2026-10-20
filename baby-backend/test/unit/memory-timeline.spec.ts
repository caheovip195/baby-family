import { TimelineChildContext } from '../../src/models/memory-view.model';
import { timelineSystemCards } from '../../src/services/memory-content.service';

const childId = '00000000-0000-4000-8000-000000000001';
const child = (birth: string, timezone = 'Asia/Ho_Chi_Minh') =>
  new TimelineChildContext(childId, new Date(`${birth}T00:00:00Z`), timezone);

describe('Timeline calendar system cards', () => {
  it('returns stable birth/month ids, dates and local-midnight ordering instants', () => {
    const cards = timelineSystemCards(
      child('2026-06-15'),
      new Date('2026-08-15T00:00:00Z'),
    );
    expect(cards.map((card) => card.item)).toEqual([
      {
        type: 'SYSTEM',
        id: `sys:birth:${childId}`,
        kind: 'BIRTH',
        childId,
        date: '2026-06-15',
      },
      {
        type: 'SYSTEM',
        id: `sys:monthiversary:${childId}:1`,
        kind: 'MONTHIVERSARY',
        childId,
        monthIndex: 1,
        date: '2026-07-15',
      },
      {
        type: 'SYSTEM',
        id: `sys:monthiversary:${childId}:2`,
        kind: 'MONTHIVERSARY',
        childId,
        monthIndex: 2,
        date: '2026-08-15',
      },
    ]);
    expect(cards.map((card) => card.instant.toISOString())).toEqual([
      '2026-06-14T17:00:00.000Z',
      '2026-07-14T17:00:00.000Z',
      '2026-08-14T17:00:00.000Z',
    ]);
  });

  it('clamps month ends without drifting later anniversaries', () => {
    const cards = timelineSystemCards(
      child('2024-01-31'),
      new Date('2024-04-30T10:00:00Z'),
    );
    expect(cards.map((card) => card.item.date)).toEqual([
      '2024-01-31',
      '2024-02-29',
      '2024-03-31',
      '2024-04-30',
    ]);
  });

  it('uses today in the family timezone and excludes incomplete months', () => {
    expect(
      timelineSystemCards(
        child('2026-01-31'),
        new Date('2026-02-27T16:59:59Z'),
      ),
    ).toHaveLength(1);
    expect(
      timelineSystemCards(
        child('2026-01-31'),
        new Date('2026-02-27T17:00:00Z'),
      ),
    ).toHaveLength(2);
  });

  it('handles leap-day birth and year boundaries', () => {
    const cards = timelineSystemCards(
      child('2024-02-29', 'UTC'),
      new Date('2025-02-28T12:00:00Z'),
    );
    expect(cards.at(-1)?.item).toMatchObject({
      date: '2025-02-28',
      monthIndex: 12,
    });
    expect(cards).toHaveLength(13);
  });

  it('has no cards for a future birth date', () => {
    expect(
      timelineSystemCards(
        child('2026-08-15'),
        new Date('2026-08-14T00:00:00Z'),
      ),
    ).toEqual([]);
  });

  it('uses the correct midnight offset on either side of daylight saving', () => {
    const cards = timelineSystemCards(
      child('2026-02-15', 'America/New_York'),
      new Date('2026-04-15T16:00:00Z'),
    );
    expect(cards.map((card) => card.instant.toISOString())).toEqual([
      '2026-02-15T05:00:00.000Z',
      '2026-03-15T04:00:00.000Z',
      '2026-04-15T04:00:00.000Z',
    ]);
  });
});
