/** Spec §7.7 / CHD-05. Purging remains a separate retention workflow. */
export const CHILD_PROFILE_POLICY = {
  archiveBeforeDeleteMs: 7 * 24 * 60 * 60 * 1000,
  trashRetentionMs: 30 * 24 * 60 * 60 * 1000,
  // BF-20261019-001: the app assigns an avatar/cover right after the upload
  // completes; the media worker finishes variants afterwards.
  assignableAssetStatuses: ['UPLOADED', 'PROCESSING', 'READY'],
} as const;
