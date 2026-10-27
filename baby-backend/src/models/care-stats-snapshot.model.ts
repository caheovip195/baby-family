export class CareStatsCategoryCount {
  constructor(
    readonly code: string,
    readonly count: number,
  ) {}
}

/** Aggregate read model; contains no actor or mission details. */
export class CareStatsSnapshot {
  constructor(
    readonly categories: readonly CareStatsCategoryCount[],
    readonly bloomedDates: readonly Date[],
  ) {}
}
