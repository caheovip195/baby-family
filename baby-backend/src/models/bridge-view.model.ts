/** Ý một Parent đã chọn chia sẻ (chủ đề + lời nhắn mã hoá chung một khối). */
export class BridgeShareRow {
  constructor(
    readonly userId: string,
    readonly feelings: readonly string[],
    readonly needs: readonly string[],
    readonly sharedEnc: Uint8Array | null,
    readonly understood: boolean,
  ) {}
}

/** Bước tiếp theo đang chọn (văn bản tự nhập còn mã hoá, base64). */
export class BridgeNextStepRow {
  constructor(
    readonly version: number,
    readonly code: string,
    readonly textEnc: string | null,
    readonly at: Date | null,
    readonly agreedUserIds: readonly string[],
  ) {}
}

/**
 * Phiên Cầu nối (`us.conflict_sessions`) theo từ vựng API: `NEXT_STEP` ↔
 * `AGREED`, `CLOSED` ↔ `RESOLVED`/`CLOSED` trong DB.
 */
export class BridgeSessionRow {
  constructor(
    readonly id: string,
    readonly initiatorUserId: string,
    readonly partnerUserId: string,
    readonly status: string,
    readonly retentionDays: number,
    readonly nextStep: BridgeNextStepRow | null,
    readonly closeAgreed: readonly string[],
    readonly startedAt: Date | null,
    readonly closedAt: Date | null,
    readonly contentPurged: boolean,
    readonly createdAt: Date,
    readonly shares: readonly BridgeShareRow[],
  ) {}
}
