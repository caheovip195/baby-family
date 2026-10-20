import { DomainError } from '../common/errors/domain.error';
import { MISSION_POLICY } from '../config/mission-policy';
import type { MissionStatus } from '../common/database.enums';
import type { MissionBoardView } from './mission-board-view.model';

const TRANSITIONS = {
  complete: ['TODO', 'EXPIRED'],
  undo: ['DONE'],
  swap: ['TODO'],
  remove: ['TODO'],
} as const;

export function requireMissionOwner(
  view: MissionBoardView,
  userId: string,
): void {
  if (
    view.mission.ownerKind !== 'TOGETHER' &&
    view.mission.ownerUserId !== userId
  )
    throw new DomainError(
      'Only the mission owner can act.',
      'MISSION_NOT_OWNER',
      403,
    );
}

/** Pure business decision, also evaluated inside the repository's mission lock. */
export function decideMissionTransition(
  view: MissionBoardView,
  userId: string,
  action: keyof typeof TRANSITIONS,
  today: string,
  now: Date,
): { status: MissionStatus; late?: boolean } {
  const row = view.mission;
  requireMissionOwner(view, userId);
  if (!(TRANSITIONS[action] as readonly string[]).includes(row.status))
    throw new DomainError(
      'The mission cannot perform this transition.',
      'INVALID_MISSION_TRANSITION',
      409,
    );
  const day = row.boardDate.toISOString().slice(0, 10);
  if (action === 'complete') {
    if (day > today)
      throw new DomainError(
        'A future mission cannot be completed.',
        'INVALID_MISSION_TRANSITION',
        409,
      );
    const yesterday = new Date(`${today}T00:00:00Z`);
    yesterday.setUTCDate(yesterday.getUTCDate() - 1);
    if (day < yesterday.toISOString().slice(0, 10))
      throw new DomainError(
        'The late completion window has closed.',
        'MISSION_LATE_WINDOW_CLOSED',
        422,
      );
    return { status: 'DONE', late: row.status === 'EXPIRED' || day < today };
  }
  if (action === 'undo') {
    if (row.completedBy !== userId)
      throw new DomainError(
        'Only the completing Parent can undo.',
        'MISSION_NOT_OWNER',
        403,
      );
    if (
      !row.completedAt ||
      now.getTime() - row.completedAt.getTime() > MISSION_POLICY.undoWindowMs
    )
      throw new DomainError(
        'The undo window has closed.',
        'MISSION_UNDO_WINDOW_CLOSED',
        409,
      );
    return { status: row.late ? 'EXPIRED' : 'TODO', late: false };
  }
  if (day !== today && action === 'swap')
    throw new DomainError(
      'Only today missions can be swapped.',
      'INVALID_MISSION_TRANSITION',
      409,
    );
  if (action === 'swap' && row.source !== 'SYSTEM')
    throw new DomainError(
      'Only system missions can be swapped.',
      'INVALID_MISSION_TRANSITION',
      409,
    );
  return { status: 'REMOVED' };
}
