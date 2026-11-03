/** CHD-06 Tăng trưởng (BF-20261028-004): giới hạn nhập, không có chuẩn tham chiếu. */
export const GROWTH_POLICY = {
  minWeightGrams: 200,
  maxWeightGrams: 200_000,
  minHeightMm: 150,
  maxHeightMm: 2_500,
  noteMaxLength: 200,
  /** Số lần đo trả về tối đa (mỗi ngày một lần). */
  listLimit: 1_000,
} as const;
