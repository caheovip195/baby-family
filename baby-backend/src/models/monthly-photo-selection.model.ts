import type { Child } from './child.model';
import type { Memory } from './memory.model';
/** Handwritten workflow projection; persistence models remain generated. */
export class MonthlyPhotoSelection {
  constructor(
    readonly monthIndex: number,
    readonly memoryId: string,
    readonly assetId: string,
    readonly occurredAt: Date,
    readonly occurredLocalDate: Date,
  ) {}
}
export class MonthlyPhotoCandidate {
  constructor(
    readonly memory: Memory,
    readonly childIds: string[],
    readonly imageReady: boolean,
  ) {}
}
export class MonthlyPhotoChild {
  constructor(
    readonly child: Child,
    readonly readable: boolean,
  ) {}
}
