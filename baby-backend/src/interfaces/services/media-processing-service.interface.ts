import type { JobContext } from './job-runner-service.interface';

export const MEDIA_PROCESSING_SERVICE = Symbol('MEDIA_PROCESSING_SERVICE');

/** Worker step of the media pipeline (spec §10.2 step 5, §10.3, §10.4). */
export interface IMediaProcessingService {
  /**
   * Verifies the SHA-256, writes metadata-free renditions under an attempt-specific
   * prefix, commits READY (fenced) and only then erases the raw upload and stale
   * renditions. Idempotent: a READY asset only gets its cleanup re-run. Throws
   * PermanentJobError (asset FAILED) for invalid media; other errors are retryable.
   */
  processAsset(
    assetId: string,
    context: JobContext,
  ): Promise<Record<string, number>>;
}
