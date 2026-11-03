/** Quyền dùng AI của một người trong gia đình (gói + cài đặt + hạn mức). */
export class AiAccess {
  constructor(
    readonly planEnabled: boolean,
    readonly perMonth: number,
    readonly userEnabled: boolean,
    readonly features: Readonly<Record<string, boolean>>,
  ) {}
}

/** Lượt gọi đang giữ chỗ hạn mức. */
export class AiReservation {
  constructor(
    readonly invocationId: string,
    readonly reservationId: string,
  ) {}
}
