/**
 * Đối tượng của sách: một bé (scope CHILD) hoặc cả nhà (scope FAMILY,
 * BF-20261030-001 — mọi ký ức của gia đình, [childId] null).
 */
export class YearBookSubject {
  constructor(
    readonly scope: 'CHILD' | 'FAMILY',
    readonly childId: string | null,
    readonly familyId: string,
    readonly name: string,
    /** Năm sớm nhất có sách (năm sinh bé / năm sớm nhất của gia đình). */
    readonly firstYear: number,
  ) {}
}

/** Ký ức của bé trong năm mà người hỏi được xem (ảnh READY). */
export class YearBookMemory {
  constructor(
    readonly id: string,
    readonly kind: string,
    readonly title: string | null,
    readonly body: string | null,
    readonly occurredAt: Date,
    /** YYYY-MM-DD theo múi giờ gia đình. */
    readonly localDate: string,
    readonly assetIds: readonly string[],
  ) {}
}

/** Bản đã lưu (nội dung JSON trong `app.recaps`, period YEAR). */
export class SavedYearBook {
  constructor(
    readonly content: unknown,
    readonly updatedAt: Date,
  ) {}
}

/**
 * Quyền theo gói: [flag] là `features[exportFeature]` của bản gói hiện tại
 * (null = bản gói chưa khai báo), [phase] là giai đoạn quyền truy cập;
 * [share] là `features[circleShareFeature]` (null = chưa khai báo), [circle]
 * là gói có Family Circle.
 */
export class YearBookPlan {
  constructor(
    readonly flag: boolean | null,
    readonly phase: string | null,
    readonly share: boolean | null = null,
    readonly circle = false,
  ) {}
}

/** Sách đã lưu của gia đình (danh sách REC-04). */
export class SavedYearBookSummary {
  constructor(
    readonly scope: 'CHILD' | 'FAMILY',
    readonly childId: string | null,
    readonly name: string,
    readonly year: number,
    readonly content: unknown,
    readonly updatedAt: Date,
  ) {}
}
