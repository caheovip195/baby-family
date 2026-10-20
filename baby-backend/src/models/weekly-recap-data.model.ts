export interface WeekStats {
  weekStart: string;
  memoryCount: number;
  photoCount: number;
  videoCount: number;
  milestoneCount: number;
  missionsDone?: number;
  byChild: { childId: string; memoryCount: number }[];
}
export interface WeeklyContent {
  version: number;
  stats: WeekStats;
  milestones: { memoryId: string }[];
  topMemories: { id: string }[];
}
export class WeeklyRecapData {
  constructor(
    readonly stats: WeekStats,
    readonly topIds: string[],
    readonly milestoneIds: string[],
    readonly coverAssetId: string | null,
    readonly appreciationCount: number,
  ) {}
  hasData(): boolean {
    return (
      this.stats.memoryCount > 0 ||
      (this.stats.missionsDone ?? 0) > 0 ||
      this.appreciationCount > 0
    );
  }
  content(): WeeklyContent {
    return {
      version: 1,
      stats: this.stats,
      topMemories: this.topIds.map((id) => ({ id })),
      milestones: this.milestoneIds.map((memoryId) => ({ memoryId })),
    };
  }
}
