/** Một lần bàn giao ca (ghi chú đã mã hoá). */
export class HandoffRow {
  constructor(
    readonly id: string,
    readonly fromUserId: string,
    readonly toUserId: string,
    /** Khoá thao tác của người gửi (thuộc AAD của ghi chú mã hoá). */
    readonly idempotencyKey: string,
    readonly childIds: readonly string[],
    readonly fedAt: Date | null,
    readonly sleptAt: Date | null,
    readonly wokeAt: Date | null,
    readonly noteEnc: Uint8Array | null,
    readonly requestId: string | null,
    readonly acknowledgedAt: Date | null,
    readonly createdAt: Date,
  ) {}
}
