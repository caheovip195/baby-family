import { open, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { Injectable } from '@nestjs/common';
import { encode } from 'blurhash';
import exifr from 'exifr';
import sharp from 'sharp';
import type { Metadata, Sharp } from 'sharp';
import { PermanentJobError } from '../common/errors/job.error';
import {
  stripJpegMetadata,
  stripPngMetadata,
} from '../common/media/image-metadata';
import type {
  IImageProcessorService,
  ImageProcessingOptions,
  ProcessedFile,
  ProcessedImage,
} from '../interfaces/services/image-processor-service.interface';

// Decompression-bomb guard (spec §10.3).
const LIMIT_INPUT_PIXELS = 100_000_000;
const EXIF_SCAN_BYTES = 1024 * 1024;
const FORMATS: Record<string, { mime: string; extension: string }> = {
  jpeg: { mime: 'image/jpeg', extension: 'jpg' },
  png: { mime: 'image/png', extension: 'png' },
  webp: { mime: 'image/webp', extension: 'webp' },
  // Static GIFs only: the first frame is kept, re-encoded as PNG.
  gif: { mime: 'image/png', extension: 'png' },
};

@Injectable()
export class ImageProcessorService implements IImageProcessorService {
  async process(
    inputPath: string,
    options: ImageProcessingOptions,
  ): Promise<ProcessedImage> {
    let metadata: Metadata;
    try {
      metadata = await this.open(inputPath).metadata();
    } catch {
      throw new PermanentJobError(
        'IMAGE_UNREADABLE',
        'Image cannot be decoded.',
      );
    }
    const format = metadata.format ? FORMATS[metadata.format] : undefined;
    if (!format)
      throw new PermanentJobError(
        'UNSUPPORTED_FORMAT',
        'Image format is not supported.',
      );
    const capturedAt = await capturedAtOf(inputPath);
    // .rotate() applies EXIF orientation; outputs carry no metadata by default.
    const oriented = () => this.open(inputPath).rotate();
    try {
      const variants = await Promise.all([
        this.write(oriented, options.workDir, 't320', 'webp', 320, (image) =>
          image.webp({ quality: 70 }),
        ),
        this.write(oriented, options.workDir, 'm1080', 'webp', 1080, (image) =>
          image.webp({ quality: 80 }),
        ),
        this.write(oriented, options.workDir, 'l2048', 'jpg', 2048, (image) =>
          image.jpeg({ quality: 85, progressive: true }),
        ),
      ]);
      const original = await this.original(
        inputPath,
        metadata,
        format,
        options,
        oriented,
      );
      const { data, info } = await oriented()
        .resize(32, 32, { fit: 'inside' })
        .ensureAlpha()
        .raw()
        .toBuffer({ resolveWithObject: true });
      return {
        width: metadata.autoOrient?.width ?? metadata.width ?? 0,
        height: metadata.autoOrient?.height ?? metadata.height ?? 0,
        capturedAt,
        blurhash: encode(
          new Uint8ClampedArray(data),
          info.width,
          info.height,
          4,
          3,
        ),
        variants: [...variants, original],
      };
    } catch (error) {
      if (error instanceof PermanentJobError) throw error;
      throw new PermanentJobError(
        'IMAGE_UNREADABLE',
        'Image cannot be decoded.',
      );
    }
  }

  async thumbnail(inputPath: string, workDir: string): Promise<ProcessedFile> {
    return this.write(
      () => this.open(inputPath).rotate(),
      workDir,
      't320',
      'webp',
      320,
      (image) => image.webp({ quality: 70 }),
    );
  }

  /**
   * Metadata-free original (spec §10.3). Plans with `media.keepOriginal` keep the
   * exact pixels of JPEG/PNG with metadata stripped losslessly; WebP/GIF and other
   * plans get a re-encode (full size for keepOriginal, otherwise long edge 3072).
   */
  private async original(
    inputPath: string,
    metadata: Metadata,
    format: { mime: string; extension: string },
    options: ImageProcessingOptions,
    oriented: () => Sharp,
  ): Promise<ProcessedFile> {
    if (
      options.keepOriginal &&
      (metadata.format === 'jpeg' || metadata.format === 'png')
    ) {
      const input = await readFile(inputPath);
      const clean =
        metadata.format === 'jpeg'
          ? stripJpegMetadata(input, metadata.orientation)
          : stripPngMetadata(input);
      const target = path.join(options.workDir, `orig.${format.extension}`);
      await writeFile(target, clean);
      return {
        code: 'orig',
        path: target,
        mime: format.mime,
        sizeBytes: clean.length,
        width: metadata.width ?? null,
        height: metadata.height ?? null,
        durationMs: null,
      };
    }
    const file = await this.write(
      oriented,
      options.workDir,
      'orig',
      format.extension,
      options.keepOriginal ? null : 3072,
      (image) =>
        format.extension === 'jpg'
          ? image.jpeg({ quality: options.keepOriginal ? 95 : 90 })
          : format.extension === 'webp'
            ? image.webp({ quality: options.keepOriginal ? 95 : 90 })
            : image.png(),
    );
    return { ...file, mime: format.mime };
  }

  private open(inputPath: string): Sharp {
    return sharp(inputPath, {
      limitInputPixels: LIMIT_INPUT_PIXELS,
      failOn: 'error',
    });
  }

  private async write(
    source: () => Sharp,
    workDir: string,
    code: string,
    extension: string,
    longEdge: number | null,
    encodeAs: (image: Sharp) => Sharp,
  ): Promise<ProcessedFile> {
    const target = path.join(workDir, `${code}.${extension}`);
    let image = source();
    if (longEdge)
      image = image.resize(longEdge, longEdge, {
        fit: 'inside',
        withoutEnlargement: true,
      });
    const info = await encodeAs(image).toFile(target);
    return {
      code,
      path: target,
      mime: MIME_BY_EXTENSION[extension] ?? 'application/octet-stream',
      sizeBytes: info.size,
      width: info.width,
      height: info.height,
      durationMs: null,
    };
  }
}

const MIME_BY_EXTENSION: Record<string, string> = {
  jpg: 'image/jpeg',
  png: 'image/png',
  webp: 'image/webp',
};

/** EXIF lives in the first segments; read a bounded head with an explicit close. */
async function capturedAtOf(inputPath: string): Promise<Date | null> {
  const file = await open(inputPath, 'r');
  try {
    const head = Buffer.alloc(EXIF_SCAN_BYTES);
    const { bytesRead } = await file.read(head, 0, EXIF_SCAN_BYTES, 0);
    const tags = (await exifr.parse(head.subarray(0, bytesRead), [
      'DateTimeOriginal',
    ])) as { DateTimeOriginal?: unknown } | undefined;
    const value = tags?.DateTimeOriginal;
    return value instanceof Date && !Number.isNaN(value.getTime())
      ? value
      : null;
  } catch {
    return null; // missing/corrupt EXIF is not an error
  } finally {
    await file.close();
  }
}
