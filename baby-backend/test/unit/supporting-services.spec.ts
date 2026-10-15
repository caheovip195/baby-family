import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import {
  ServiceUnavailableError,
  ValidationError,
} from '../../src/common/errors/domain.error';
import { ValkeyThrottlerStorage } from '../../src/common/throttling/valkey-throttler.storage';
import { validateEnvironment } from '../../src/config/environment';
import type { Environment } from '../../src/config/environment';
import type { ValkeyConnection } from '../../src/database/valkey.connection';
import { CacheRepository } from '../../src/repositories/cache.repository';
import { MailService } from '../../src/services/mail.service';
import { ObjectStorageService } from '../../src/services/object-storage.service';

const base = { DATABASE_URL: 'postgresql://user:secret@localhost:5432/test' };
const s3 = {
  S3_ENDPOINT: 'http://baby-minio:9000',
  S3_PUBLIC_ENDPOINT: 'http://localhost:9000',
  S3_ACCESS_KEY_ID: 'baby-backend',
  S3_SECRET_ACCESS_KEY: 'unit-test-secret',
};
const config = (input: Record<string, string> = {}) =>
  new ConfigService(
    validateEnvironment({ ...base, ...input }),
  ) as unknown as ConfigService<Environment, true>;

describe('supporting service configuration', () => {
  it('treats empty values as disabled and defaults buckets/public endpoint', () => {
    const env = validateEnvironment({
      ...base,
      REDIS_URL: '',
      S3_ENDPOINT: '',
      SMTP_HOST: '',
    });
    expect(env.REDIS_URL).toBeUndefined();
    expect(env.S3_ENDPOINT).toBeUndefined();
    expect(env.SMTP_HOST).toBeUndefined();
    expect(env.S3_BUCKET_MEDIA).toBe('bf-media');
    expect(env.S3_FORCE_PATH_STYLE).toBe(true);
    const configured = validateEnvironment({
      ...base,
      ...s3,
      S3_PUBLIC_ENDPOINT: '',
    });
    expect(configured.S3_PUBLIC_ENDPOINT).toBe('http://baby-minio:9000');
  });
  it('rejects partial or unsafe settings without echoing secrets', () => {
    expect(() =>
      validateEnvironment({ ...base, REDIS_URL: 'http://localhost:6379' }),
    ).toThrow('REDIS_URL');
    expect(() =>
      validateEnvironment({ ...base, S3_ENDPOINT: 'http://localhost:9000' }),
    ).toThrow('set all or none');
    expect(() =>
      validateEnvironment({ ...base, SMTP_HOST: 'smtp', SMTP_USER: 'u' }),
    ).toThrow('SMTP_USER/SMTP_PASSWORD');
    expect(() =>
      validateEnvironment({
        ...base,
        NODE_ENV: 'production',
        SMTP_HOST: 'smtp.example.com',
      }),
    ).toThrow('production SMTP must use TLS');
    expect(
      validateEnvironment({
        ...base,
        NODE_ENV: 'production',
        SMTP_HOST: 'baby-mailpit',
        SMTP_ALLOW_INSECURE: 'true',
      }).SMTP_ALLOW_INSECURE,
    ).toBe(true);
    expect(() =>
      validateEnvironment({ ...base, S3_BUCKET_MEDIA: 'Bad_Bucket' }),
    ).toThrow('S3_BUCKET_MEDIA');
    try {
      validateEnvironment({ ...base, ...s3, S3_ACCESS_KEY_ID: '' });
    } catch (error) {
      expect(String(error)).not.toContain('unit-test-secret');
    }
  });
});

describe('adapters fail closed when not configured', () => {
  it('cache reports disabled and refuses commands', async () => {
    const cache = new CacheRepository({ client: null } as ValkeyConnection);
    expect(cache.isConfigured()).toBe(false);
    await expect(cache.checkHealth()).resolves.toBe('disabled');
    await expect(cache.get('k')).rejects.toBeInstanceOf(
      ServiceUnavailableError,
    );
  });
  it('object storage and mail report not configured', async () => {
    const storage = new ObjectStorageService(config());
    await expect(storage.checkHealth()).resolves.toBe('disabled');
    await expect(
      storage.createDownloadUrl({ bucket: 'media', key: 'a/b' }),
    ).rejects.toBeInstanceOf(ServiceUnavailableError);
    const mail = new MailService(config());
    expect(mail.isConfigured()).toBe(false);
    await expect(
      mail.send({ to: 'a@example.com', subject: 's', text: 't' }),
    ).rejects.toBeInstanceOf(ServiceUnavailableError);
  });
});

describe('CacheRepository', () => {
  const client = {
    get: jest.fn(),
    set: jest.fn(),
    eval: jest.fn(),
    del: jest.fn(),
    ping: jest.fn(),
  };
  const cache = new CacheRepository({
    client: client as unknown as Redis,
  } as ValkeyConnection);
  it('validates keys/TTL and hides client errors', async () => {
    await expect(cache.get('has space')).rejects.toBeInstanceOf(
      ValidationError,
    );
    await expect(cache.setIfAbsent('k', 'v', 0)).rejects.toBeInstanceOf(
      ValidationError,
    );
    client.get.mockRejectedValueOnce(new Error('redis://:secret@host'));
    const error = (await cache.get('k').catch((e: unknown) => e)) as Error;
    expect(error).toBeInstanceOf(ServiceUnavailableError);
    expect(error.message).not.toContain('secret');
    client.ping.mockRejectedValueOnce(new Error('down'));
    await expect(cache.checkHealth()).resolves.toBe('down');
  });
  it('maps SET NX and counters', async () => {
    client.set.mockResolvedValueOnce('OK').mockResolvedValueOnce(null);
    await expect(cache.setIfAbsent('lock:a', '1', 1000)).resolves.toBe(true);
    await expect(cache.setIfAbsent('lock:a', '1', 1000)).resolves.toBe(false);
    expect(client.set).toHaveBeenCalledWith('lock:a', '1', 'PX', 1000, 'NX');
    client.eval.mockResolvedValueOnce(3);
    await expect(cache.increment('quota:x', 5000)).resolves.toBe(3);
  });
});

describe('ObjectStorageService presigning (local, no network)', () => {
  const storage = new ObjectStorageService(config(s3));
  it('signs PUT for the public endpoint with content-type and no SDK checksum', async () => {
    const upload = await storage.createUploadUrl({
      bucket: 'media',
      key: 'fam/f1/a/a1/orig',
      contentType: 'image/jpeg',
    });
    const url = new URL(upload.url);
    expect(url.origin).toBe('http://localhost:9000');
    expect(url.pathname).toBe('/bf-media/fam/f1/a/a1/orig');
    expect(url.searchParams.get('X-Amz-SignedHeaders')).toBe(
      'content-type;host',
    );
    expect(url.searchParams.get('X-Amz-Expires')).toBe('900');
    expect(upload.url).not.toMatch(/x-amz-checksum|x-amz-sdk-checksum/i);
    expect(upload.headers).toEqual({ 'Content-Type': 'image/jpeg' });
  });
  it('signs GET with attachment disposition and validates input', async () => {
    const download = await storage.createDownloadUrl({
      bucket: 'userMedia',
      key: 'usr/u1/j/a1/orig',
      expiresInSeconds: 600,
      downloadFileName: 'BabyFamily_2026-03-12_1.jpg',
    });
    const url = new URL(download.url);
    expect(url.pathname.startsWith('/bf-user-media/')).toBe(true);
    expect(url.searchParams.get('response-content-disposition')).toContain(
      'attachment; filename="BabyFamily_2026-03-12_1.jpg"',
    );
    for (const key of ['../x', '/abs', 'a//b', 'a/../b', 'with space']) {
      await expect(
        storage.createDownloadUrl({ bucket: 'media', key }),
      ).rejects.toBeInstanceOf(ValidationError);
    }
    await expect(
      storage.createDownloadUrl({
        bucket: 'media',
        key: 'a',
        expiresInSeconds: 8 * 24 * 3600,
      }),
    ).rejects.toBeInstanceOf(ValidationError);
    await expect(
      storage.createUploadUrl({
        bucket: 'media',
        key: 'a',
        contentType: 'image/jpeg\r\nx: y',
      }),
    ).rejects.toBeInstanceOf(ValidationError);
  });
});

describe('MailService validation', () => {
  const mail = new MailService(config({ SMTP_HOST: 'localhost' }));
  afterAll(() => mail.onModuleDestroy());
  it.each([
    { to: [], subject: 's' },
    { to: 'not-an-address', subject: 's' },
    { to: 'a@example.com', subject: 'line\r\nBcc: x@example.com' },
    { to: 'a@example.com', subject: ' ' },
  ])('rejects %j', async ({ to, subject }) => {
    await expect(mail.send({ to, subject, text: 't' })).rejects.toBeInstanceOf(
      ValidationError,
    );
  });
});

describe('ValkeyThrottlerStorage', () => {
  it('maps the script result and falls back to memory on outage', async () => {
    const evalMock = jest
      .fn()
      .mockResolvedValueOnce([3, 1500, 1, 60000])
      .mockRejectedValueOnce(new Error('Connection is closed'));
    const storage = new ValkeyThrottlerStorage({
      eval: evalMock,
    } as unknown as Redis);
    await expect(
      storage.increment('k', 60000, 2, 60000, 'default'),
    ).resolves.toEqual({
      totalHits: 3,
      timeToExpire: 2,
      isBlocked: true,
      timeToBlockExpire: 60,
    });
    expect(evalMock.mock.calls[0]).toEqual(
      expect.arrayContaining(['rl:default:k:hits', 'rl:default:k:block']),
    );
    await expect(
      storage.increment('k', 60000, 2, 60000, 'default'),
    ).resolves.toMatchObject({ totalHits: 1, isBlocked: false });
  });
});
