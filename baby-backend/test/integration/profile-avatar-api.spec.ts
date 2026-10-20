import { ServiceUnavailableError } from '../../src/common/errors/domain.error';
import { createHash, randomUUID } from 'node:crypto';
import { readFileSync } from 'node:fs';
import type { Server } from 'node:http';
import path from 'node:path';
import { ValidationPipe, UnauthorizedException } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { parse } from 'dotenv';
import { LoggerModule } from 'nestjs-pino';
import sharp from 'sharp';
import request from 'supertest';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { ProfileImageController } from '../../src/controllers/profile-image.controller';
import { UserController } from '../../src/controllers/user.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { ACCOUNT_REPOSITORY } from '../../src/interfaces/repositories/account-repository.interface';
import { PROFILE_IMAGE_REPOSITORY } from '../../src/interfaces/repositories/profile-image-repository.interface';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { IMAGE_PROCESSOR_SERVICE } from '../../src/interfaces/services/image-processor-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../../src/interfaces/services/object-storage-service.interface';
import { PROFILE_IMAGE_SERVICE } from '../../src/interfaces/services/profile-image-service.interface';
import { USER_SERVICE } from '../../src/interfaces/services/user-service.interface';
import { AccountRepository } from '../../src/repositories/account.repository';
import { ProfileImageRepository } from '../../src/repositories/profile-image.repository';
import { UserRepository } from '../../src/repositories/user.repository';
import { ImageProcessorService } from '../../src/services/image-processor.service';
import { ObjectStorageService } from '../../src/services/object-storage.service';
import { ProfileImageService } from '../../src/services/profile-image.service';
import { UserService } from '../../src/services/user.service';

interface Intent {
  assetId: string;
  status: string;
  upload?: {
    mode: string;
    method: string;
    url: string;
    headers: Record<string, string>;
    expiresAt: string;
  };
}
const data = <T>(r: { body: unknown }) => (r.body as { data: T }).data;
const errorCode = (r: { body: unknown }) =>
  (r.body as { error: { code: string } }).error.code;

describe('AUTH-04 account avatar (focused Nest + PostgreSQL + MinIO)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let storage: IObjectStorageService;
  let image: Buffer;
  const userId = randomUUID(),
    otherId = randomUUID();
  const configValues = parse(
    readFileSync(path.resolve(__dirname, '../../.env'), 'utf8'),
  );
  const auth = (id: string = userId) => `Bearer ${id}`;
  const intent = (
    key = randomUUID(),
    bytes = image,
    id = userId,
    mime = 'image/png',
  ) =>
    request(app.getHttpServer())
      .post('/api/v1/me/avatar/upload-intents')
      .set('Authorization', auth(id))
      .set('Idempotency-Key', key)
      .send({
        purpose: 'AVATAR',
        mime,
        size: bytes.length,
        sha256: createHash('sha256').update(bytes).digest('hex'),
      });
  const complete = (id: string, user = userId) =>
    request(app.getHttpServer())
      .post(`/api/v1/me/avatar/${id}/complete`)
      .set('Authorization', auth(user))
      .send({});
  const patch = (body: object, user = userId) =>
    request(app.getHttpServer())
      .patch('/api/v1/me')
      .set('Authorization', auth(user))
      .send(body);
  async function put(upload: NonNullable<Intent['upload']>, bytes: Buffer) {
    const result = await fetch(upload.url, {
      method: 'PUT',
      headers: upload.headers,
      body: new Uint8Array(bytes),
    });
    expect(result.status).toBe(200);
  }
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    const s3 = Object.fromEntries(
      [
        'S3_ENDPOINT',
        'S3_PUBLIC_ENDPOINT',
        'S3_ACCESS_KEY_ID',
        'S3_SECRET_ACCESS_KEY',
      ].map((k) => [k, process.env[`TEST_${k}`] ?? configValues[k]]),
    );
    const config = new ConfigService(
      validateEnvironment({ ...process.env, ...s3 }),
    );
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [ProfileImageController, UserController],
      providers: [
        PrismaService,
        { provide: ConfigService, useValue: config },
        {
          provide: AUTHENTICATION_SERVICE,
          useValue: {
            verifyAccessToken: (token: string) => {
              if (token !== userId && token !== otherId)
                throw new UnauthorizedException();
              return {
                userId: token,
                sessionId: randomUUID(),
                tokenVersion: 1,
              };
            },
          },
        },
        { provide: APPLICATION_ACCESS_SERVICE, useValue: {} },
        { provide: PROFILE_IMAGE_SERVICE, useClass: ProfileImageService },
        { provide: PROFILE_IMAGE_REPOSITORY, useClass: ProfileImageRepository },
        { provide: OBJECT_STORAGE_SERVICE, useClass: ObjectStorageService },
        { provide: IMAGE_PROCESSOR_SERVICE, useClass: ImageProcessorService },
        { provide: USER_SERVICE, useClass: UserService },
        { provide: USER_REPOSITORY, useClass: UserRepository },
        { provide: ACCOUNT_REPOSITORY, useClass: AccountRepository },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
    prisma = module.get(PrismaService);
    storage = module.get(OBJECT_STORAGE_SERVICE);
    expect(storage.isConfigured()).toBe(true);
    for (const id of [userId, otherId])
      await prisma.user.create({
        data: { id, displayName: 'Synthetic avatar fixture' },
      });
    image = await sharp({
      create: { width: 20, height: 20, channels: 3, background: '#f0b0c0' },
    })
      .png()
      .withMetadata({ exif: { IFD0: { Artist: 'Synthetic metadata' } } })
      .toBuffer();
  });
  afterAll(async () => {
    if (prisma) {
      await prisma.user.updateMany({
        where: { id: { in: [userId, otherId] } },
        data: { avatarAssetId: null },
      });
      for (const asset of await prisma.userAsset.findMany({
        where: { ownerUserId: { in: [userId, otherId] } },
      })) {
        for (const key of await storage.listKeys(
          'userMedia',
          `usr/${asset.ownerUserId}/avatar/${asset.id}/`,
        ))
          await storage.eraseObjectVersions({ bucket: 'userMedia', key });
      }
      await prisma.userAsset.deleteMany({
        where: { ownerUserId: { in: [userId, otherId] } },
      });
      await prisma.user.deleteMany({
        where: { id: { in: [userId, otherId] } },
      });
    }
    await app?.close();
  });
  it('uploads without family, completes idempotently, attaches and serves stripped avatar; clears with null', async () => {
    const key = randomUUID();
    const first = await intent(key).expect(201),
      value = data<Intent>(first);
    expect(value.status).toBe('PENDING_UPLOAD');
    expect(value.upload?.mode).toBe('single');
    expect(errorCode(await complete(value.assetId).expect(409))).toBe(
      'UPLOAD_NOT_FOUND',
    );
    expect(data<Intent>(await intent(key).expect(201)).assetId).toBe(
      value.assetId,
    );
    expect(
      errorCode(await patch({ avatarAssetId: value.assetId }).expect(422)),
    ).toBe('AVATAR_ASSET_INVALID');
    await put(value.upload!, image);
    expect(data<Intent>(await complete(value.assetId).expect(200)).status).toBe(
      'READY',
    );
    await complete(value.assetId).expect(200);
    // Reusing the still-valid PUT can only recreate raw, never replace the served rendition.
    await put(value.upload!, image);
    expect(
      await storage.headObject({
        bucket: 'userMedia',
        key: `usr/${userId}/avatar/${value.assetId}/raw`,
      }),
    ).not.toBeNull();
    await complete(value.assetId).expect(200);
    expect(
      await storage.headObject({
        bucket: 'userMedia',
        key: `usr/${userId}/avatar/${value.assetId}/raw`,
      }),
    ).toBeNull();
    expect(data<Intent>(await intent(key).expect(201)).upload).toBeUndefined();
    const updated = data<{
      avatarAssetId: string;
      avatarUrl: string;
      avatarUrlExpiresAt: string;
    }>(
      await patch({
        avatarAssetId: value.assetId,
        displayName: 'Avatar profile updated',
      }).expect(200),
    );
    expect(updated.avatarAssetId).toBe(value.assetId);
    expect(new Date(updated.avatarUrlExpiresAt).getTime()).toBeGreaterThan(
      Date.now(),
    );
    const downloaded = await fetch(updated.avatarUrl);
    expect(downloaded.status).toBe(200);
    const metadata = await sharp(
      Buffer.from(await downloaded.arrayBuffer()),
    ).metadata();
    expect(metadata.format).toBe('webp');
    expect(metadata.exif).toBeUndefined();
    expect(metadata.xmp).toBeUndefined();
    const me = data<{
      avatarUrl: string;
      avatarAssetId: string;
      displayName: string;
    }>(
      await request(app.getHttpServer())
        .get('/api/v1/me')
        .set('Authorization', auth())
        .expect(200),
    );
    expect(me.avatarAssetId).toBe(value.assetId);
    expect(me.displayName).toBe('Avatar profile updated');
    expect(me.avatarUrl).toContain('/avatar.webp');
    const cleared = data<{ avatarAssetId: null; avatarUrl: null }>(
      await patch({ avatarAssetId: null }).expect(200),
    );
    expect(cleared.avatarAssetId).toBeNull();
    expect(cleared.avatarUrl).toBeNull();
  });
  it('rejects another account avatar and completion, unknown/deleted/support assets and expired upload', async () => {
    const first = data<Intent>(await intent().expect(201));
    await put(first.upload!, image);
    await complete(first.assetId).expect(200);
    expect(
      errorCode(
        await patch({ avatarAssetId: first.assetId }, otherId).expect(422),
      ),
    ).toBe('AVATAR_ASSET_INVALID');
    await complete(first.assetId, otherId).expect(404);
    expect(
      errorCode(await patch({ avatarAssetId: randomUUID() }).expect(422)),
    ).toBe('AVATAR_ASSET_INVALID');
    await prisma.userAsset.update({
      where: { id: first.assetId },
      data: { deletedAt: new Date() },
    });
    await patch({ avatarAssetId: first.assetId }).expect(422);
    const support = await prisma.userAsset.create({
      data: {
        ownerUserId: userId,
        purpose: 'SUPPORT',
        status: 'READY',
        storageKey: `usr/${userId}/support/${randomUUID()}`,
        mime: 'image/png',
        declaredSize: 1n,
      },
    });
    await patch({ avatarAssetId: support.id }).expect(422);
    const expired = data<Intent>(await intent().expect(201));
    await prisma.userAsset.update({
      where: { id: expired.assetId },
      data: { purgeAfter: new Date(0) },
    });
    expect(errorCode(await complete(expired.assetId).expect(409))).toBe(
      'UPLOAD_EXPIRED',
    );
  });
  it('recovers when raw deletion fails after the READY commit', async () => {
    const value = data<Intent>(await intent().expect(201));
    await put(value.upload!, image);
    const erase = jest
      .spyOn(storage, 'eraseObjectVersions')
      .mockRejectedValueOnce(
        new ServiceUnavailableError('Synthetic storage outage.'),
      );
    try {
      await complete(value.assetId).expect(503);
      const stored = await prisma.userAsset.findUniqueOrThrow({
        where: { id: value.assetId },
      });
      expect(stored.status).toBe('READY');
      expect(stored.purgeAfter).not.toBeNull();
      await complete(value.assetId).expect(200);
      expect(
        await storage.headObject({
          bucket: 'userMedia',
          key: stored.storageKey,
        }),
      ).toBeNull();
    } finally {
      erase.mockRestore();
    }
  });
  it('validates intent/replay and rejects non-images with unchanged profile', async () => {
    const key = randomUUID();
    await intent(key).expect(201);
    expect(errorCode(await intent(key, Buffer.from('other')).expect(409))).toBe(
      'IDEMPOTENCY_KEY_REUSED',
    );
    expect(
      errorCode(
        await intent(randomUUID(), image, userId, 'application/pdf').expect(
          422,
        ),
      ),
    ).toBe('MEDIA_TYPE_UNSUPPORTED');
    const bytes = Buffer.from('invalid image payload');
    const invalid = data<Intent>(await intent(randomUUID(), bytes).expect(201));
    await put(invalid.upload!, bytes);
    expect(errorCode(await complete(invalid.assetId).expect(422))).toBe(
      'AVATAR_IMAGE_INVALID',
    );
    await patch({ avatarAssetId: 'invalid' }).expect(400);
    await request(app.getHttpServer()).get('/api/v1/me').expect(401);
  });
});
