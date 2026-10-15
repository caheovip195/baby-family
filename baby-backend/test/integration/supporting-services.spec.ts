import { randomUUID } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import type { Server } from 'node:http';
import path from 'node:path';
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { parse } from 'dotenv';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { ValkeyThrottlerStorage } from '../../src/common/throttling/valkey-throttler.storage';
import { ValkeyConnection } from '../../src/database/valkey.connection';
import { CACHE_REPOSITORY } from '../../src/interfaces/repositories/cache-repository.interface';
import type { ICacheRepository } from '../../src/interfaces/repositories/cache-repository.interface';
import { MAIL_SERVICE } from '../../src/interfaces/services/mail-service.interface';
import type { IMailService } from '../../src/interfaces/services/mail-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../../src/interfaces/services/object-storage-service.interface';

// Uses the local ../baby-storage stack. Values come from TEST_* variables or the
// developer's baby-backend/.env (host URLs). Skipped when neither is available (CI).
const SERVICE_VARIABLES = [
  'REDIS_URL',
  'S3_ENDPOINT',
  'S3_PUBLIC_ENDPOINT',
  'S3_ACCESS_KEY_ID',
  'S3_SECRET_ACCESS_KEY',
  'SMTP_HOST',
  'SMTP_PORT',
] as const;
const envFile = path.resolve(__dirname, '../../.env');
const fileValues = existsSync(envFile)
  ? parse(readFileSync(envFile, 'utf8'))
  : {};
const services = Object.fromEntries(
  SERVICE_VARIABLES.map((name) => [
    name,
    process.env[`TEST_${name}`] ?? fileValues[name] ?? '',
  ]),
) as Record<(typeof SERVICE_VARIABLES)[number], string>;
// Keys this suite creates/deletes live in a separate logical database (15), so the
// cleanup never touches cache or rate-limit state of a locally running API.
if (services.REDIS_URL && !process.env.TEST_REDIS_URL) {
  const url = new URL(services.REDIS_URL);
  url.pathname = '/15';
  services.REDIS_URL = url.toString();
}
const mailpitApi = process.env.TEST_MAILPIT_API_URL ?? 'http://localhost:8025';
const available =
  Boolean(services.REDIS_URL) &&
  Boolean(services.S3_ENDPOINT) &&
  Boolean(services.SMTP_HOST);
const describeStack = available ? describe : describe.skip;
if (!available) {
  console.warn(
    'Skipping supporting-service integration tests: no REDIS_URL/S3_ENDPOINT/SMTP_HOST in TEST_* or .env.',
  );
}

describeStack('Valkey + MinIO + Mailpit through real DI', () => {
  let app: INestApplication<Server>;
  let cache: ICacheRepository;
  let storage: IObjectStorageService;
  let mail: IMailService;
  const prefix = `test:${randomUUID()}`;
  const objectKey = `test/${randomUUID()}/orig`;

  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error('Integration tests require a *_test database.');
    // ConfigModule validates when AppModule is first imported: set env, then import.
    Object.assign(process.env, services, {
      THROTTLE_LIMIT: '2',
      THROTTLE_TTL_MS: '3000',
    });
    const { AppModule } = await import('../../src/app.module.js');
    const module = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    cache = app.get(CACHE_REPOSITORY);
    storage = app.get(OBJECT_STORAGE_SERVICE);
    mail = app.get(MAIL_SERVICE);
  });
  afterAll(async () => {
    if (!app) return;
    const client = app.get(ValkeyConnection).client;
    const keys = await client?.keys(`${prefix}:*`);
    if (client && keys?.length) await client.del(...keys);
    await storage.deleteObject({ bucket: 'exports', key: objectKey });
    await app.close();
    delete process.env.THROTTLE_LIMIT;
    delete process.env.THROTTLE_TTL_MS;
  });

  it('reports every configured dependency as ready', async () => {
    await request(app.getHttpServer()).get('/health/ready').expect(200, {
      status: 'ok',
      database: 'up',
      cache: 'up',
      objectStorage: 'up',
    });
  });

  it('stores values, counters and NX locks with TTL in Valkey', async () => {
    await cache.set(`${prefix}:value`, 'hello', { ttlMs: 60_000 });
    await expect(cache.get(`${prefix}:value`)).resolves.toBe('hello');
    await expect(
      cache.setIfAbsent(`${prefix}:lock`, 'a', 60_000),
    ).resolves.toBe(true);
    await expect(
      cache.setIfAbsent(`${prefix}:lock`, 'b', 60_000),
    ).resolves.toBe(false);
    await expect(cache.increment(`${prefix}:counter`, 60_000)).resolves.toBe(1);
    await expect(cache.increment(`${prefix}:counter`, 60_000)).resolves.toBe(2);
    const client = app.get(ValkeyConnection).client!;
    const ttl = await client.pttl(`${prefix}:counter`);
    expect(ttl).toBeGreaterThan(0);
    expect(ttl).toBeLessThanOrEqual(60_000);
    await cache.set(`${prefix}:short`, 'x', { ttlMs: 50 });
    await new Promise((resolve) => setTimeout(resolve, 120));
    await expect(cache.get(`${prefix}:short`)).resolves.toBeNull();
    await expect(cache.delete(`${prefix}:value`)).resolves.toBe(true);
    await expect(cache.delete(`${prefix}:value`)).resolves.toBe(false);
  });

  it('rate-limits through Valkey-backed throttler storage', async () => {
    const client = app.get(ValkeyConnection).client!;
    const server = app.getHttpServer();
    // Start from a fresh window for the default (IP) tracker.
    for (const key of await client.keys('rl:default:*')) await client.del(key);
    await request(server).get('/api/v1/notes').expect(200);
    await request(server).get('/api/v1/notes').expect(200);
    await request(server).get('/api/v1/notes').expect(429);
    const keys = await client.keys('rl:default:*');
    expect(keys.some((key) => key.endsWith(':block'))).toBe(true);
    for (const key of keys) await client.del(key);
  });

  it('matches in-memory throttler semantics (sliding hits, block, blockDuration 0)', async () => {
    const storage = new ValkeyThrottlerStorage(
      app.get(ValkeyConnection).client!,
    );
    const sleep = (ms: number) =>
      new Promise((resolve) => setTimeout(resolve, ms));
    const sliding = `${prefix}:sliding`;
    expect((await storage.increment(sliding, 400, 2, 400, 't')).isBlocked).toBe(
      false,
    );
    await sleep(250);
    expect((await storage.increment(sliding, 400, 2, 400, 't')).isBlocked).toBe(
      false,
    );
    await sleep(200); // first hit expired; a fixed window would also have reset
    expect(await storage.increment(sliding, 400, 2, 400, 't')).toMatchObject({
      totalHits: 2,
      isBlocked: false,
    });
    expect(await storage.increment(sliding, 400, 2, 400, 't')).toMatchObject({
      isBlocked: true,
    });
    await sleep(450);
    expect(await storage.increment(sliding, 400, 2, 400, 't')).toMatchObject({
      totalHits: 1,
      isBlocked: false,
    });

    const noBlock = `${prefix}:no-block`;
    await storage.increment(noBlock, 300, 2, 0, 't');
    await storage.increment(noBlock, 300, 2, 0, 't');
    const refused = await storage.increment(noBlock, 300, 2, 0, 't');
    expect(refused).toMatchObject({ totalHits: 3, isBlocked: true });
    expect(refused.timeToBlockExpire).toBeGreaterThan(0);
    await sleep(350);
    expect(await storage.increment(noBlock, 300, 2, 0, 't')).toMatchObject({
      totalHits: 1,
      isBlocked: false,
    });
    const client = app.get(ValkeyConnection).client!;
    const keys = await client.keys(`rl:t:${prefix}:*`);
    if (keys.length) await client.del(...keys);
  });

  it('uploads/downloads via presigned URLs with the least-privilege key', async () => {
    const body = `baby-family-${randomUUID()}`;
    const upload = await storage.createUploadUrl({
      bucket: 'exports',
      key: objectKey,
      contentType: 'text/plain',
    });
    const mismatched = await fetch(upload.url, {
      method: 'PUT',
      headers: { 'Content-Type': 'image/png' },
      body,
    });
    expect(mismatched.status).toBe(403);
    await expect(
      storage.headObject({ bucket: 'exports', key: objectKey }),
    ).resolves.toBeNull();

    const put = await fetch(upload.url, {
      method: 'PUT',
      headers: upload.headers,
      body,
    });
    expect(put.status).toBe(200);
    await expect(
      storage.headObject({ bucket: 'exports', key: objectKey }),
    ).resolves.toMatchObject({
      size: Buffer.byteLength(body),
      contentType: 'text/plain',
    });

    const download = await storage.createDownloadUrl({
      bucket: 'exports',
      key: objectKey,
      downloadFileName: 'BabyFamily_export.txt',
    });
    const get = await fetch(download.url);
    expect(get.status).toBe(200);
    expect(get.headers.get('content-disposition')).toContain('attachment');
    await expect(get.text()).resolves.toBe(body);

    const tampered = new URL(download.url);
    tampered.searchParams.set('X-Amz-Expires', '604800');
    expect((await fetch(tampered)).status).toBe(403);

    await storage.deleteObject({ bucket: 'exports', key: objectKey });
    await expect(
      storage.headObject({ bucket: 'exports', key: objectKey }),
    ).resolves.toBeNull();
  });

  it('delivers mail to Mailpit', async () => {
    const subject = `Integration ${randomUUID()}`;
    const sent = await mail.send({
      to: 'parent@example.test',
      subject,
      text: 'Mailpit delivery check',
    });
    expect(sent.messageId).toBeTruthy();
    const search = await fetch(
      `${mailpitApi}/api/v1/search?query=${encodeURIComponent(`subject:"${subject}"`)}`,
    );
    const result = (await search.json()) as {
      messages: { ID: string; Subject: string; To: { Address: string }[] }[];
    };
    expect(result.messages).toHaveLength(1);
    expect(result.messages[0]!.To[0]!.Address).toBe('parent@example.test');
    await fetch(`${mailpitApi}/api/v1/messages`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ IDs: [result.messages[0]!.ID] }),
    });
  });
});
