/** Account avatars are small single PUTs, independent of family billing. */
export const PROFILE_IMAGE_POLICY = {
  version: 1,
  maxBytes: 5 * 1024 * 1024,
  uploadTtlSeconds: 900,
  reservationTtlMs: 24 * 60 * 60 * 1000,
} as const;
