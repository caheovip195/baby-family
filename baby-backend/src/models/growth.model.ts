/** CHD-06: bé được đo (ngày sinh để chặn ngày đo trước khi sinh). */
export class GrowthChild {
  constructor(
    readonly id: string,
    readonly familyId: string,
    readonly birthDate: Date,
  ) {}
}

/** Một lần đo trong ngày `measuredOn` (YYYY-MM-DD). */
export class GrowthEntry {
  constructor(
    readonly id: string,
    readonly measuredOn: string,
    readonly weightGrams: number | null,
    readonly heightMm: number | null,
    readonly note: string | null,
    readonly createdBy: string,
    readonly updatedAt: Date,
  ) {}
}
