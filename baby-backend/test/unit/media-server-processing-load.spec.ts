import { ConfigService } from '@nestjs/config';
import { MediaTranscoderService } from '../../src/services/media-transcoder.service';
import { ImageProcessorService } from '../../src/services/image-processor.service';
import { MediaQueueWorker } from '../../src/workers/media.worker';

const mockSharp = { loads: 0 };

jest.mock('sharp', () => {
  mockSharp.loads += 1;
  return {
    __esModule: true,
    default: () => {
      throw new Error('decode failed');
    },
  };
});

const unused = {} as never;

function worker(mode: string, assertAvailable: jest.Mock) {
  return new MediaQueueWorker(
    new ConfigService({
      MEDIA_SERVER_PROCESSING: mode,
      REDIS_URL: 'redis://127.0.0.1:1',
    }),
    unused,
    unused,
    { assertAvailable } as never,
  );
}

describe('server media processing is opt-in', () => {
  it('loads sharp only when an image is processed', async () => {
    const service = new ImageProcessorService();
    expect(mockSharp.loads).toBe(0);

    await expect(service.thumbnail('in.jpg', 'dir')).rejects.toThrow(
      'decode failed',
    );
    expect(mockSharp.loads).toBe(1);
  });

  it('does not look for ffmpeg when disabled', async () => {
    const assertAvailable = jest.fn();

    await worker('disabled', assertAvailable).onApplicationBootstrap();

    expect(assertAvailable).not.toHaveBeenCalled();
  });

  it('stops a legacy worker at start when ffmpeg is missing', async () => {
    const assertAvailable = jest.fn().mockRejectedValue(new Error('no ffmpeg'));

    await expect(
      worker('legacy', assertAvailable).onApplicationBootstrap(),
    ).rejects.toThrow('no ffmpeg');
  });

  it('names the image to build when the tool cannot run', async () => {
    const service = new MediaTranscoderService(
      new ConfigService({
        FFMPEG_PATH: '/nonexistent/ffmpeg',
        FFPROBE_PATH: '/nonexistent/ffprobe',
      }),
    );

    await expect(service.assertAvailable()).rejects.toThrow(
      'WORKER_BUILD_TARGET=worker-legacy',
    );
  });
});
