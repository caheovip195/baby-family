import { Inject, Injectable, Logger } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import { MISSION_POLICY } from '../config/mission-policy';
import { MISSION_BOARD_REPOSITORY } from '../interfaces/repositories/mission-board-repository.interface';
import type { IMissionBoardRepository } from '../interfaces/repositories/mission-board-repository.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import type { IMissionScheduleService } from '../interfaces/services/mission-schedule-service.interface';
import { localMissionDate } from './mission-board.service';

@Injectable()
export class MissionScheduleService implements IMissionScheduleService {
  private readonly logger = new Logger(MissionScheduleService.name);
  constructor(
    @Inject(MISSION_BOARD_REPOSITORY)
    private readonly repository: IMissionBoardRepository,
  ) {}

  async prepareDueBoards(now: Date, context: JobContext) {
    let created = 0;
    let skipped = 0;
    for (const family of await this.repository.familiesForBoards()) {
      context.signal.throwIfAborted();
      if (localHour(now, family.timezone) < MISSION_POLICY.boardHour) {
        skipped++;
        continue;
      }
      try {
        const made = await this.repository.prepareBoard(
          family.familyId,
          localMissionDate(now, family.timezone),
        );
        if (made) created++;
        else skipped++;
      } catch (error) {
        // A family that cannot get a board yet (e.g. no couple space) must not
        // block the others; the board is still created on first open.
        if (!(error instanceof DomainError)) throw error;
        this.logger.warn(`Board skipped (${error.code})`);
        skipped++;
      }
    }
    return { created, skipped };
  }
}

/** Hour of day (0–23) in the family timezone. */
export function localHour(now: Date, timezone: string): number {
  const hour = new Intl.DateTimeFormat('en-GB', {
    timeZone: timezone,
    hour: '2-digit',
    hourCycle: 'h23',
  }).format(now);
  return Number(hour);
}
