/** REC-03: số liệu một tháng tuổi của một bé theo quyền xem của người hỏi. */
export class MonthRecapData {
  constructor(
    readonly moments: number,
    readonly firsts: number,
    readonly voices: number,
    readonly firstMemoryIds: readonly string[],
    readonly voiceMemoryIds: readonly string[],
    /** Ảnh tháng theo `month_index` (chỉ ảnh người hỏi được xem). */
    readonly photos: ReadonlyMap<number, { memoryId: string; assetId: string }>,
  ) {}
}

export class MonthRecapChild {
  constructor(
    readonly id: string,
    readonly familyId: string,
    readonly birthDate: Date,
  ) {}
}
