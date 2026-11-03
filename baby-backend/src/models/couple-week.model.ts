/** US-14: số liệu tuần của hai ta (không chia theo người, không có điểm). */
export class CoupleWeekCounts {
  constructor(
    readonly checkins: number,
    readonly requestsHelped: number,
    readonly thanks: number,
    readonly togetherMissions: number,
    readonly together: readonly { title: string; completedAt: Date }[],
  ) {}
}
