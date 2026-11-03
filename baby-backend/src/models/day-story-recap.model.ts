/** REC-01: bé của câu chuyện. */
export class DayStoryChild {
  constructor(
    readonly id: string,
    readonly familyId: string,
  ) {}
}

/** Ký ức trong ngày người hỏi được xem, kèm ảnh READY. */
export class DayStoryMemory {
  constructor(
    readonly id: string,
    readonly kind: string,
    readonly title: string | null,
    readonly body: string | null,
    readonly occurredAt: Date,
    readonly assetIds: readonly string[],
  ) {}
}

/** Câu chuyện đã lưu của bé + ngày. */
export class SavedDayStory {
  constructor(
    readonly id: string,
    readonly title: string,
    readonly body: string | null,
    readonly coverAssetId: string | null,
    readonly memoryIds: readonly string[],
    readonly assetIds: readonly string[],
    readonly visibility: string,
    readonly updatedAt: Date,
  ) {}
}
