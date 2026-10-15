import { execFile } from 'node:child_process';
import { stat } from 'node:fs/promises';
import path from 'node:path';
import { promisify } from 'node:util';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { z } from 'zod';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import type { ProcessedFile } from '../interfaces/services/image-processor-service.interface';
import type {
  IMediaTranscoderService,
  MediaProbe,
} from '../interfaces/services/media-transcoder-service.interface';

const run = promisify(execFile);
const PROBE_TIMEOUT_MS = 60_000;
const TRANSCODE_TIMEOUT_MS = 30 * 60 * 1000;

const probeSchema = z.object({
  format: z.object({ duration: z.string().optional() }).optional(),
  streams: z
    .array(
      z.object({
        codec_type: z.string().optional(),
        width: z.number().optional(),
        height: z.number().optional(),
        duration: z.string().optional(),
      }),
    )
    .default([]),
});

/** Runs ffprobe/ffmpeg with argument arrays (no shell), timeouts and cancellation. */
@Injectable()
export class MediaTranscoderService implements IMediaTranscoderService {
  private readonly ffmpeg: string;
  private readonly ffprobe: string;

  constructor(config: ConfigService<Environment, true>) {
    this.ffmpeg = config.get('FFMPEG_PATH', { infer: true });
    this.ffprobe = config.get('FFPROBE_PATH', { infer: true });
  }

  async probe(inputPath: string, signal: AbortSignal): Promise<MediaProbe> {
    let stdout: string;
    try {
      ({ stdout } = await run(
        this.ffprobe,
        [
          '-v',
          'error',
          '-show_streams',
          '-show_format',
          '-of',
          'json',
          inputPath,
        ],
        { timeout: PROBE_TIMEOUT_MS, signal, maxBuffer: 4 * 1024 * 1024 },
      ));
    } catch (error) {
      throw this.toolError(error, signal);
    }
    const parsed = probeSchema.safeParse(JSON.parse(stdout));
    if (!parsed.success)
      throw new PermanentJobError(
        'MEDIA_UNREADABLE',
        'Media cannot be probed.',
      );
    const streams = parsed.data.streams;
    const video = streams.find((stream) => stream.codec_type === 'video');
    const seconds = Number(
      parsed.data.format?.duration ?? video?.duration ?? Number.NaN,
    );
    if (!Number.isFinite(seconds) || seconds <= 0)
      throw new PermanentJobError('MEDIA_UNREADABLE', 'Media has no duration.');
    return {
      durationMs: Math.round(seconds * 1000),
      width: video?.width ?? null,
      height: video?.height ?? null,
      hasVideo: Boolean(video),
      hasAudio: streams.some((stream) => stream.codec_type === 'audio'),
    };
  }

  transcodeVideo(
    inputPath: string,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile> {
    const target = path.join(workDir, 'v1080.mp4');
    // Spec §10.4: -map_metadata -1 drops location atoms (©xyz).
    return this.transcode(
      [
        '-i',
        inputPath,
        '-map_metadata',
        '-1',
        '-map',
        '0:v:0',
        '-map',
        '0:a:0?',
        '-c:v',
        'libx264',
        '-preset',
        'veryfast',
        '-crf',
        '23',
        '-profile:v',
        'high',
        '-pix_fmt',
        'yuv420p',
        '-vf',
        "scale='if(gt(iw,ih),-2,min(1080,iw))':'if(gt(iw,ih),min(1080,ih),-2)'",
        '-c:a',
        'aac',
        '-b:a',
        '128k',
        '-movflags',
        '+faststart',
        target,
      ],
      { code: 'v1080', path: target, mime: 'video/mp4' },
      signal,
    );
  }

  extractPoster(
    videoPath: string,
    durationMs: number,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile> {
    const target = path.join(workDir, 'poster.jpg');
    const at = Math.min(1, durationMs / 2000).toFixed(3);
    return this.transcode(
      ['-ss', at, '-i', videoPath, '-frames:v', '1', '-q:v', '3', target],
      { code: 'poster', path: target, mime: 'image/jpeg' },
      signal,
    );
  }

  transcodeAudio(
    inputPath: string,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile> {
    const target = path.join(workDir, 'a.m4a');
    return this.transcode(
      [
        '-i',
        inputPath,
        '-map_metadata',
        '-1',
        '-vn',
        '-c:a',
        'aac',
        '-b:a',
        '96k',
        target,
      ],
      { code: 'a', path: target, mime: 'audio/mp4' },
      signal,
    );
  }

  stripMetadata(
    inputPath: string,
    extension: string,
    workDir: string,
    signal: AbortSignal,
  ): Promise<ProcessedFile> {
    const target = path.join(workDir, `orig-clean.${extension}`);
    return this.transcode(
      [
        '-i',
        inputPath,
        '-map',
        '0',
        '-map_metadata',
        '-1',
        '-c',
        'copy',
        target,
      ],
      { code: 'orig', path: target, mime: '' },
      signal,
    );
  }

  private async transcode(
    args: string[],
    output: { code: string; path: string; mime: string },
    signal: AbortSignal,
  ): Promise<ProcessedFile> {
    try {
      await run(
        this.ffmpeg,
        ['-hide_banner', '-nostdin', '-y', '-v', 'error', ...args],
        {
          timeout: TRANSCODE_TIMEOUT_MS,
          signal,
          maxBuffer: 4 * 1024 * 1024,
        },
      );
    } catch (error) {
      throw this.toolError(error, signal);
    }
    const { size } = await stat(output.path);
    return {
      ...output,
      sizeBytes: size,
      width: null,
      height: null,
      durationMs: null,
    };
  }

  /** Tool exit code ≠ 0 means bad input (permanent); spawn/abort errors are transient. */
  private toolError(error: unknown, signal: AbortSignal): Error {
    if (signal.aborted) return new Error('Media processing was cancelled.');
    const code = (error as { code?: unknown }).code;
    if (typeof code === 'number')
      return new PermanentJobError(
        'MEDIA_UNREADABLE',
        'Media cannot be processed.',
      );
    return new Error('Media tool is unavailable.');
  }
}
