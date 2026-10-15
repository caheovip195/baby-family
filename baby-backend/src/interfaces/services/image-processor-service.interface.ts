export const IMAGE_PROCESSOR_SERVICE = Symbol('IMAGE_PROCESSOR_SERVICE');

/** A generated file in the worker temp directory. */
export interface ProcessedFile {
  /** Variant code (t320, m1080, …) or `orig` for the replaced original. */
  code: string;
  path: string;
  mime: string;
  sizeBytes: number;
  width: number | null;
  height: number | null;
  durationMs: number | null;
}

export interface ProcessedImage {
  width: number;
  height: number;
  capturedAt: Date | null;
  blurhash: string;
  /** Renditions including `orig`, the metadata-free original (spec §10.3). */
  variants: ProcessedFile[];
}

export interface ImageProcessingOptions {
  /** Plan feature `media.keepOriginal`: keep the original pixels (metadata-free). */
  keepOriginal: boolean;
  workDir: string;
}

/** Image decoding/re-encoding (spec §10.3). Throws PermanentJobError for bad input. */
export interface IImageProcessorService {
  process(
    inputPath: string,
    options: ImageProcessingOptions,
  ): Promise<ProcessedImage>;
  /** Grid thumbnail (t320.webp) from a still frame, e.g. a video poster. */
  thumbnail(inputPath: string, workDir: string): Promise<ProcessedFile>;
}
