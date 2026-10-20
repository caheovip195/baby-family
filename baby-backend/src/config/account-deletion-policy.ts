/** Versioned defaults; snapshots on requests prevent retroactive grace changes. */
export const ACCOUNT_DELETION_POLICY = {
  version: '2026-10-18.v1',
  graceMs: 30 * 86_400_000,
  batchSize: 25,
  reauthMaxAgeSeconds: 300,
  export: {
    windowMs: 24 * 60 * 60 * 1000,
    maxRequests: 3,
    maxRows: 10000,
    maxBytes: 25 * 1024 * 1024,
    urlTtlSeconds: 900,
    retentionMs: 7 * 86_400_000,
  },
} as const;
