import type { JobPolicy } from './jobs';
export const WEEKLY_RECAP_POLICY = {
  version: 1,
  batchSize: 25,
  topLimit: 10,
  everyMs: 3600000,
  catchUpWeeks: 4,
  /**
   * REC-02 “Lưu vào timeline” (BF-20261030-004): ký ức tạo từ recap — tiêu đề
   * theo ngôn ngữ của người lưu (`{start}`–`{end}` dd/mm), tối đa ảnh lấy từ
   * ký ức nổi bật; mặc định chỉ Bố Mẹ xem (recap gồm cả ký ức riêng của Bố Mẹ).
   */
  timelineTitle: {
    vi: 'Tuần của nhà mình {start}–{end}',
    en: "Our family's week {start}–{end}",
  } as Record<string, string>,
  timelineMaxPhotos: 6,
  /** Cờ gói cho chia sẻ recap với người thân; chưa khai báo → `circle.enabled`. */
  circleShareFeature: 'recap.circleShare',
} as const;
export const WEEKLY_RECAP_JOB: JobPolicy = {
  queue: 'recaps',
  name: 'recap.weekly-build',
  maxAttempts: 3,
  backoffMs: 10000,
  leaseMs: 300000,
};
