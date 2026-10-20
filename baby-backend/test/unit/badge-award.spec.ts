import { BadgeAwardService } from '../../src/services/badge-award.service';
import type {
  IBadgeAwardRepository,
  BadgeAwardSnapshot,
} from '../../src/interfaces/repositories/badge-award-repository.interface';
import { JobLease } from '../../src/models/job-lease.model';

describe('Badge award policy', () => {
  it('isolates Hearts, ignores unknown rules and evaluates family metrics', async () => {
    const snapshot: BadgeAwardSnapshot = {
      parentIds: ['a', 'b'],
      heartsByUser: { a: 10, b: 0 },
      metrics: { TOGETHER_MISSIONS: 5 },
      badges: [
        {
          code: 'TEAM',
          scope: 'FAMILY',
          rule: { metric: 'TOGETHER_MISSIONS', target: 5 },
        },
        {
          code: 'PRIVATE',
          scope: 'USER',
          rule: { metric: 'HEARTS_TOTAL', target: 10 },
        },
        {
          code: 'LEAK',
          scope: 'FAMILY',
          rule: { metric: 'HEARTS_TOTAL', target: 1 },
        },
        {
          code: 'UNKNOWN',
          scope: 'FAMILY',
          rule: { metric: 'UNKNOWN', target: 1 },
        },
        {
          code: 'BAD',
          scope: 'FAMILY',
          rule: { metric: 'TOGETHER_MISSIONS', target: 0 },
        },
      ],
    };
    const repository: IBadgeAwardRepository = {
      families: jest.fn(),
      eventFamily: jest.fn().mockResolvedValue('family'),
      award: jest.fn((_id, _now, _ctx, evaluate) => {
        expect(evaluate(snapshot)).toEqual([
          { badgeCode: 'TEAM', subjectUserId: null },
          { badgeCode: 'PRIVATE', subjectUserId: 'a' },
        ]);
        return Promise.resolve(2);
      }),
    };
    const context = {
      signal: new AbortController().signal,
      lease: new JobLease('run', 1, 1n, 3, 'worker'),
    };
    expect(
      await new BadgeAwardService(repository).award(
        new Date(),
        context,
        'event',
      ),
    ).toEqual({ awarded: 2, families: 1 });
  });
});
