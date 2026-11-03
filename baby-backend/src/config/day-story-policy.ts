/** REC-01 Câu chuyện ngày (BF-20261028-006). */
export const DAY_STORY_POLICY = {
  titleMaxLength: 120,
  bodyMaxLength: 5000,
  /** Ảnh kèm tối đa trong một câu chuyện. */
  maxPhotos: 30,
  /** Ký ức trong ngày trả về tối đa. */
  maxMemories: 100,
} as const;
