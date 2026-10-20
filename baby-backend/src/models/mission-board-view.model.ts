import type { MissionCategory, MissionScope } from '../common/database.enums';
import type { Mission } from './mission.model';
export class MissionBoardView {
  constructor(
    readonly mission: Mission,
    readonly childIds: string[],
    readonly events: { type: string; createdAt: Date }[] = [],
    readonly myHeartsAwarded: number = 0,
    readonly tree?: { leaves: number; total: number; bloomed: boolean },
  ) {}
}
export class MissionTemplateView {
  constructor(
    readonly id: string,
    readonly title: string,
    readonly category: MissionCategory,
    readonly hearts: number,
    readonly targetScope: MissionScope,
    readonly multiChildOk: boolean,
    readonly durationMin: number,
    readonly roleFit: string,
  ) {}
}
export interface MissionBoardSnapshot {
  board: { level: string; bloomedAt: Date | null } | null;
  items: MissionBoardView[];
  swapsUsed: number;
  myHeartsToday: number;
}
