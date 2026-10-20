/** Read projections only: no persistence or business orchestration. */
export class TimelineMonthlyCover {
  constructor(
    readonly monthIndex: number,
    readonly memoryId: string,
    readonly assetId: string,
    readonly birthDate: Date,
    readonly occurredLocalDate: Date,
    readonly monthlyPhotoLunar: boolean,
  ) {}
}
export class TimelineMonthCounts {
  constructor(
    readonly monthIndex: number,
    readonly memoryCount: number,
    readonly firstsCount: number,
    readonly quotesCount: number,
  ) {}
}
export class TimelineWeeklyRecap {
  constructor(
    readonly id: string,
    readonly childId: string | null,
    readonly periodStart: Date,
  ) {}
}
