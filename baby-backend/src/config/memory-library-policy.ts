/** Versioned server policy; shared rate-limit storage keys include this version. */
export const MEMORY_LIBRARY_POLICY = {
  version: 1,
  downloadTtlSeconds: 600,
  downloadsPerWindow: 30,
  downloadWindowMs: 60_000,
} as const;
