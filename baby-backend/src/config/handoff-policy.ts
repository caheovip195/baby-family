/** Bàn giao ca (7.13.8, BF-20261028-007). */
export const HANDOFF_POLICY = {
  noteMaxLength: 500,
  maxChildren: 10,
  /** Mốc giờ (ăn / ngủ / dậy) chỉ trong 24 giờ qua, lệch đồng hồ tối đa 5 phút. */
  lookbackMs: 24 * 60 * 60 * 1000,
  clockSkewMs: 5 * 60 * 1000,
  listLimit: 50,
} as const;
