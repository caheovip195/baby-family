import type { ProcessedFile } from './image-processor-service.interface';

export const MEDIA_TRANSCODER_SERVICE = Symbol('MEDIA_TRANSCODER_SERVICE');

export interface MediaProbe {
  durationMs: number;
  width: number | null;
  height: number | null;
  hasVideo: boolean;
  hasAudio: boolean;
}

/** Video/audio processing (spec §10.4). Throws PermanentJobError for bad input. */
export interface IMediaTranscoderService {
  probe(inputPath: string, signal: AbortSignal): Promise<MediaProbe>;
  /** H.264/AAC mp4, short side ≤ 1080, faststart, no metadata (`v1080`). */
  transcodeVideo(
    inputPath: string,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile>;
  /** JPEG frame of a transcoded video (`poster`). */
  extractPoster(
    videoPath: string,
    durationMs: number,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile>;
  /** AAC m4a 96 kbps without metadata (`a`). */
  transcodeAudio(
    inputPath: string,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile>;
  /** Lossless remux of the original with all metadata (e.g. GPS atoms) removed. */
  stripMetadata(
    inputPath: string,
    extension: string,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile>;
}
