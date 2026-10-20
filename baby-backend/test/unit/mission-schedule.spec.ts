import { DomainError } from '../../src/common/errors/domain.error';
import type { IMissionBoardRepository } from '../../src/interfaces/repositories/mission-board-repository.interface';
import type { JobContext } from '../../src/interfaces/services/job-runner-service.interface';
import {
  MissionScheduleService,
  localHour,
} from '../../src/services/mission-schedule.service';

describe('MissionScheduleService (morning boards)', () => {
  const context = {
    signal: new AbortController().signal,
  } as unknown as JobContext;

  function service(prepared: string[], failing = new Set<string>()) {
    const repository = {
      familiesForBoards: () =>
        Promise.resolve([
          { familyId: 'vn', timezone: 'Asia/Ho_Chi_Minh' },
          { familyId: 'us', timezone: 'America/Los_Angeles' },
          { familyId: 'broken', timezone: 'Asia/Ho_Chi_Minh' },
        ]),
      prepareBoard: (familyId: string, date: string) => {
        if (failing.has(familyId))
          return Promise.reject(
            new DomainError('x', 'MISSION_BOARD_PARENTS_REQUIRED', 409),
          );
        prepared.push(`${familyId}@${date}`);
        return Promise.resolve(true);
      },
    } as unknown as IMissionBoardRepository;
    return new MissionScheduleService(repository);
  }

  it('reads the hour in the family timezone', () => {
    const at = new Date('2026-10-19T01:00:00Z');
    expect(localHour(at, 'Asia/Ho_Chi_Minh')).toBe(8);
    expect(localHour(at, 'America/Los_Angeles')).toBe(18);
  });

  it('prepares only families past the board hour, using their local date', async () => {
    const prepared: string[] = [];
    // 22:00 UTC = 05:00 next day in Vietnam, 15:00 the same day in LA.
    const result = await service(
      prepared,
      new Set(['broken']),
    ).prepareDueBoards(new Date('2026-10-18T22:00:00Z'), context);
    expect(prepared).toEqual(['vn@2026-10-19', 'us@2026-10-18']);
    expect(result).toEqual({ created: 2, skipped: 1 });
  });

  it('skips everyone before the board hour', async () => {
    const prepared: string[] = [];
    // 21:00 UTC = 04:00 in Vietnam; 14:00 in LA still passes.
    await service(prepared).prepareDueBoards(
      new Date('2026-10-18T21:00:00Z'),
      context,
    );
    expect(prepared).toEqual(['us@2026-10-18']);
  });
});
