import { ConfigService } from '@nestjs/config';
import {
  ConflictError,
  DomainError,
} from '../../src/common/errors/domain.error';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import type { ICatalogQueryRepository } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import type { IMediaRepository } from '../../src/interfaces/repositories/media-repository.interface';
import type { IObjectStorageService } from '../../src/interfaces/services/object-storage-service.interface';
import { Asset } from '../../src/models/asset.model';
import type { AssetAttributes } from '../../src/models/asset.model';
import { MediaUpload } from '../../src/models/media-upload.model';
import { MediaService } from '../../src/services/media.service';

const actor: AuthPrincipal = {
  userId: '00000000-0000-4000-8000-00000000000a',
  sessionId: '00000000-0000-4000-8000-0000000000aa',
  tokenVersion: 1,
};
const familyId = '00000000-0000-4000-8000-0000000000f1';
const assetId = '00000000-0000-4000-8000-0000000000a1';

function asset(overrides: Partial<AssetAttributes> = {}): Asset {
  const now = new Date();
  return new Asset({
    id: assetId,
    familyId,
    uploaderUserId: actor.userId,
    kind: 'IMAGE',
    purpose: 'MEMORY',
    status: 'PENDING_UPLOAD',
    storageKey: `fam/${familyId}/a/${assetId}/orig`,
    multipartUploadId: null,
    mime: 'image/jpeg',
    declaredSize: 1000n,
    sizeBytes: null,
    width: null,
    height: null,
    durationMs: null,
    sha256: new Uint8Array(32),
    sourceSha256: null,
    sourceKey: null,
    capturedAt: null,
    blurhash: null,
    keepOriginal: false,
    failureReason: null,
    createdAt: now,
    readyAt: null,
    deletedAt: null,
    purgeAfter: null,
    updatedAt: now,
    storageBucket: 'bf-media',
    privateOwnerUserId: null,
    ...overrides,
  });
}
const reservation = (expiresAt = new Date(Date.now() + 60_000)) => ({
  status: 'RESERVED',
  reservedBytes: 1000n,
  expiresAt,
  idempotencyKey: 'k',
});

describe('MediaService', () => {
  const access = { requireParent: jest.fn() };
  const catalog = { findFamilyBillingState: jest.fn() };
  const media: jest.Mocked<IMediaRepository> = {
    reserveUpload: jest.fn(),
    findUpload: jest.fn(),
    attachMultipartUpload: jest.fn(),
    confirmUpload: jest.fn(),
    failUpload: jest.fn(),
    findFamilyIds: jest.fn(),
    findViewableByParent: jest.fn(),
    findViewableByCircle: jest.fn(),
    hasContributeChild: jest.fn(),
    startProcessing: jest.fn(),
    findAssetView: jest.fn(),
    findEffectivePlan: jest.fn(),
    completeProcessing: jest.fn(),
    failProcessing: jest.fn(),
    failStaleProcessing: jest.fn(),
    findStuckProcessing: jest.fn(),
    findPurgeCandidates: jest.fn(),
    retireAsset: jest.fn(),
    findAssetsAwaitingObjectPurge: jest.fn(),
    markObjectsPurged: jest.fn(),
    findUncompletedUploads: jest.fn(),
  };
  const storage = {
    isConfigured: jest.fn().mockReturnValue(true),
    bucketName: jest.fn().mockReturnValue('bf-media'),
    bucketOf: jest.fn().mockReturnValue('media'),
    headObject: jest.fn(),
    deleteObject: jest.fn(),
    createMultipartUpload: jest.fn(),
    abortMultipartUpload: jest.fn(),
    createPartUploadUrls: jest.fn(),
    createUploadUrl: jest.fn(),
    createDownloadUrl: jest.fn(),
    completeMultipartUpload: jest.fn(),
  };
  const service = new MediaService(
    access,
    catalog as unknown as ICatalogQueryRepository,
    media,
    storage as unknown as IObjectStorageService,
    new ConfigService({ MEDIA_SERVER_PROCESSING: 'legacy' }),
  );
  const intent = {
    familyId,
    kind: 'IMAGE' as const,
    purpose: 'MEMORY' as const,
    mime: 'image/jpeg',
    size: 1000,
    sha256: 'a'.repeat(64),
    variants: ['m1080', 't320'].map((code) => ({
      code,
      mime: 'image/jpeg',
      size: 100,
      sha256: 'b'.repeat(64),
    })),
  };
  beforeEach(() => {
    access.requireParent.mockResolvedValue({});
    storage.isConfigured.mockReturnValue(true);
    storage.bucketOf.mockReturnValue('media');
  });

  it('fails closed when plan quotas or storage are unavailable', async () => {
    catalog.findFamilyBillingState.mockResolvedValueOnce({
      effectivePlan: { quotas: {} },
    });
    await expect(
      service.createUploadIntent(actor, 'k', intent),
    ).rejects.toMatchObject({ statusCode: 503 });
    catalog.findFamilyBillingState.mockResolvedValueOnce({
      effectivePlan: { quotas: { storageBytes: 10 } },
    });
    storage.isConfigured.mockReturnValueOnce(false);
    await expect(
      service.createUploadIntent(actor, 'k', intent),
    ).rejects.toMatchObject({ statusCode: 503 });
    expect(media.reserveUpload).not.toHaveBeenCalled();
  });

  it('checks membership before anything else', async () => {
    access.requireParent.mockRejectedValueOnce(
      new DomainError('no', 'NOT_FOUND', 404),
    );
    await expect(
      service.createUploadIntent(actor, 'k', intent),
    ).rejects.toMatchObject({ statusCode: 404 });
    expect(catalog.findFamilyBillingState).not.toHaveBeenCalled();
  });

  it('rejects expired uploads and other uploaders', async () => {
    media.findUpload.mockResolvedValueOnce(
      new MediaUpload(asset(), reservation(new Date(Date.now() - 1))),
    );
    await expect(
      service.completeUpload(actor, assetId, {}),
    ).rejects.toMatchObject({ code: 'UPLOAD_EXPIRED' });
    media.findUpload.mockResolvedValueOnce(
      new MediaUpload(
        asset({ uploaderUserId: '00000000-0000-4000-8000-0000000000bb' }),
        reservation(),
      ),
    );
    await expect(
      service.completeUpload(actor, assetId, {}),
    ).rejects.toMatchObject({ code: 'MEDIA_NOT_UPLOADER', statusCode: 403 });
  });

  it('deletes and fails uploads whose stored type differs', async () => {
    media.findUpload.mockResolvedValueOnce(
      new MediaUpload(asset(), reservation()),
    );
    storage.headObject.mockResolvedValueOnce({
      size: 1000,
      contentType: 'image/png',
      etag: null,
    });
    await expect(
      service.completeUpload(actor, assetId, {}),
    ).rejects.toMatchObject({ code: 'UPLOAD_MIME_MISMATCH', statusCode: 422 });
    expect(storage.deleteObject).toHaveBeenCalled();
    expect(media.failUpload).toHaveBeenCalledWith(assetId, 'MIME_MISMATCH');
    expect(media.confirmUpload).not.toHaveBeenCalled();
  });

  it('recovers a multipart upload already assembled by a previous complete', async () => {
    const big = asset({
      kind: 'VIDEO',
      mime: 'video/mp4',
      declaredSize: 21n * 1024n * 1024n,
      multipartUploadId: 'gone',
    });
    media.findUpload.mockResolvedValueOnce(new MediaUpload(big, reservation()));
    storage.completeMultipartUpload.mockRejectedValueOnce(
      new ConflictError('Multipart upload no longer exists.'),
    );
    storage.headObject.mockResolvedValueOnce({
      size: 21 * 1024 * 1024,
      contentType: 'video/mp4',
      etag: null,
    });
    media.confirmUpload.mockResolvedValueOnce(asset({ status: 'UPLOADED' }));
    const parts = [1, 2, 3].map((n) => ({ n, etag: `e${n}` }));
    await expect(
      service.completeUpload(actor, assetId, { parts }),
    ).resolves.toEqual({ assetId, status: 'UPLOADED' });
    expect(media.confirmUpload).toHaveBeenCalledWith(
      assetId,
      21n * 1024n * 1024n,
    );
  });

  it('aborts its own multipart upload when another request attached one first', async () => {
    const big = asset({
      kind: 'VIDEO',
      mime: 'video/mp4',
      declaredSize: 21n * 1024n * 1024n,
    });
    media.findUpload.mockResolvedValueOnce(new MediaUpload(big, reservation()));
    storage.createMultipartUpload.mockResolvedValueOnce('mine');
    media.attachMultipartUpload.mockResolvedValueOnce('theirs');
    storage.createPartUploadUrls.mockResolvedValueOnce({
      parts: [{ partNumber: 1, url: 'u' }],
      expiresAt: new Date(),
    });
    await service.signUploadParts(actor, assetId, { partNumbers: [1] });
    expect(storage.abortMultipartUpload).toHaveBeenCalledWith(
      expect.anything(),
      'mine',
    );
    expect(storage.createPartUploadUrls).toHaveBeenCalledWith(
      expect.objectContaining({ uploadId: 'theirs' }),
    );
  });

  it('skips families the actor cannot read in batch signing', async () => {
    media.findFamilyIds.mockResolvedValueOnce(new Map([[assetId, familyId]]));
    access.requireParent.mockRejectedValueOnce(
      new DomainError('expired', 'SUBSCRIPTION_REQUIRED', 402),
    );
    await expect(
      service.signViewUrls(actor, { assetIds: [assetId] }),
    ).resolves.toEqual({ items: [], unavailableIds: [assetId] });
    expect(media.findViewableByParent).not.toHaveBeenCalled();
  });
});
