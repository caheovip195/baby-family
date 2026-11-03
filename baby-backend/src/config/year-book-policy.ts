/** REC-04 Year Story / Sách của con (BF-20261028-013). */
export const YEAR_BOOK_POLICY = {
  /** Ảnh chọn sẵn mỗi chương (tháng) khi chưa lưu. */
  defaultPhotosPerChapter: 4,
  /** Ký ức tối đa mỗi chương / ảnh tối đa mỗi ký ức trong sách. */
  maxItemsPerChapter: 20,
  maxAssetsPerItem: 6,
  maxMemoriesPerYear: 1000,
  titleMaxLength: 80,
  captionMaxLength: 300,
  /** Tính năng gói cho phép xuất PDF (gói khác chỉ xem trước). */
  exportFeature: 'yearbook.export',
  /** Ưu tiên khi tự chọn (cột mốc trước). */
  preferredKinds: ['MILESTONE', 'MONTHLY_PHOTO', 'MOMENT'],
  /** Thư gửi tương lai không vào sách. */
  excludedKinds: ['LETTER'],
  /** Phiên bản cấu trúc nội dung lưu trong `app.recaps.content`. */
  contentVersion: 1,
  /**
   * Bản gói chưa khai báo `exportFeature`: chỉ giai đoạn này được xuất
   * (dùng thử chỉ xem trước). Gói mới khai báo cờ thì cờ quyết định.
   */
  exportPhasesWhenUndeclared: ['PAID'],
  /**
   * Bản cho ông bà (BF-20261030-002): cờ gói cho phép chia sẻ sách với người
   * thân; bản gói chưa khai báo thì theo `circle.enabled` (gói có Family
   * Circle — hiện là Family).
   */
  circleShareFeature: 'yearbook.circleShare',
  circleFeature: 'circle.enabled',
  minYear: 2000,
} as const;
